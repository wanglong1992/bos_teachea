package cn.itcast.bos.service.impl;

import java.util.Date;
import java.util.Iterator;
import java.util.UUID;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.AreaRepository;
import cn.itcast.bos.dao.FixedAreaRepository;
import cn.itcast.bos.dao.OrderRepository;
import cn.itcast.bos.dao.WorkBillRepository;
import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.base.FixedArea;
import cn.itcast.bos.domain.base.SubArea;
import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.domain.take_delivery.Order;
import cn.itcast.bos.domain.take_delivery.WorkBill;
import cn.itcast.bos.service.OrderService;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderRepository orderRepository;
	
	@Autowired
	private FixedAreaRepository fixedAreaRepository;
	
	@Autowired
	private AreaRepository areaRepository;
	
	@Autowired
	private WorkBillRepository workBillRepository;
	
	//使用jmsTemplate
	@Autowired
	@Qualifier("jmsQueueTemplate")
	private JmsTemplate jmsTemplate;

	@Override
	public void save(Order order) {
		// System.out.println(order);
		// 保存订单之前，赋值属性
		// 订单号（唯一）uuid或者时间戳
		order.setOrderNum(UUID.randomUUID().toString());
		// 订单状态 1 待取件 2 运输中 3 已签收 4 异常
		order.setStatus("1");
		// 下单时间
		order.setOrderTime(new Date());
		// 解决瞬时态异常
		// 使用寄件人的省市区，查询区域对象，获取寄件人区域的持久化对象
		Area sendArea = order.getSendArea();
		Area persistSendArea = areaRepository.findByProvinceAndCityAndDistrict(sendArea.getProvince(),sendArea.getCity(),sendArea.getDistrict());
		// 使用收件人的省市区，查询区域对象，获取收件人区域的持久化对象
		Area recArea = order.getRecArea();
		Area persistRecArea = areaRepository.findByProvinceAndCityAndDistrict(recArea.getProvince(),recArea.getCity(),recArea.getDistrict());
		// 将持久化的对象存放到order
		order.setSendArea(persistSendArea);
		order.setRecArea(persistRecArea);
		/**2.2． 自动分单逻辑 -- 基于CRM地址完全匹配自动分单（1）*/
		// 获取客户id，和客户的下单地址（寄件人地址），查询CRM系统，获取定区ID
		String fixedAreaId = WebClient.create(Constants.CRM_MANAGEMENT_URL+"/services/customerService/customer/findFixedAreaIdByIdAndAddress/"+order.getCustomer_id()+"/"+order.getSendAddress())
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON)
					.get(String.class);
		// 如果存在定区ID，获取快递员信息
		if(StringUtils.isNotBlank(fixedAreaId)){ 
			// 使用定区ID，查询定区的对象，用来获取快递员的信息
			FixedArea fixedArea = fixedAreaRepository.findOne(fixedAreaId);
			if(fixedArea!=null){
				Iterator<Courier> iterator = fixedArea.getCouriers().iterator();
				while(iterator.hasNext()){
					Courier courier = iterator.next();
					// 保存订单，同时用订单关联快递员
					saveOrder(order,courier);
					// 生成工单（发送短信给快递员，快递员负责取件）
					saveWorkBill(order);
					return;
				}
			}
			
		}
		/**2.3． 自动分单逻辑 -- 基于分区关键字匹配自动分单（2）--重要*/
		for(SubArea subArea:persistSendArea.getSubareas()){
			// 使用寄件人的地址，如果包含了分区中的关键字
			if(order.getSendAddress().contains(subArea.getKeyWords())){
				// 获取定区，获取快递员
				Iterator<Courier> iterator = subArea.getFixedArea().getCouriers().iterator();
				while(iterator.hasNext()){
					Courier courier = iterator.next();
					// 保存订单，同时用订单关联快递员
					saveOrder(order,courier);
					// 生成工单（发送短信给快递员，快递员负责取件）
					saveWorkBill(order);
					return;
				}
			}
		}
		for(SubArea subArea:persistSendArea.getSubareas()){
			// 使用寄件人的地址，如果包含了分区中的辅助关键字
			if(order.getSendAddress().contains(subArea.getAssistKeyWords())){
				// 获取定区，获取快递员
				Iterator<Courier> iterator = subArea.getFixedArea().getCouriers().iterator();
				while(iterator.hasNext()){
					Courier courier = iterator.next();
					// 保存订单，同时用订单关联快递员
					saveOrder(order,courier);
					// 生成工单（发送短信给快递员，快递员负责取件）
					saveWorkBill(order);
					return;
				}
			}
		}
		// 如果自动分单失败
		// 分单类型 1 自动分单 2 人工分单
		order.setOrderType("2"); // 表示需要使用人工分单的模块，对没有自动分单成功的订单完成分单
		orderRepository.save(order);
	}

	// 生成工单（发送短信给快递员，快递员负责取件）
	private void saveWorkBill(final Order order) {
		WorkBill workBill = new WorkBill();
		// 工单类型 新,追,销
		workBill.setType("新");
		/*
		 * 新单:没有确认货物状态的 
		   已通知:自动下单下发短信 
		   已确认:接到短信,回复收信确认信息 
		   已取件:已经取件成功,发回确认信息 生成工作单
		 * 已取消:销单
		 * 
		 */
		workBill.setPickstate("新单");
		// 工单生成时间
		workBill.setBuildtime(new Date());
		// 追单次数
		workBill.setAttachbilltimes(0);
		// 订单备注
		workBill.setRemark(order.getRemark());
		// 短信序号
		final String smsNumber = RandomStringUtils.randomNumeric(4);
		workBill.setSmsNumber(smsNumber);
		// 快递员
		workBill.setCourier(order.getCourier());
		// 订单
		workBill.setOrder(order);
		// 发送短信给快递员，快递员负责取件（编写MQ生产者）
		jmsTemplate.send("bos_smscouries",new MessageCreator() {
			
			@Override
			public Message createMessage(Session session) throws JMSException {
				// 创建消息
				// 速运快递 短信序号：${num},取件地址：${sendAddres},联系人：${sendName},手机:${sendMobile}，快递员捎话：${sendMobileMsg}
				MapMessage mapMessage = session.createMapMessage();
				// 手机号
				mapMessage.setString("telephone",order.getCourier().getTelephone());
				// 参数
				mapMessage.setString("num",smsNumber);
				mapMessage.setString("sendAddres",order.getSendAddress());
				mapMessage.setString("sendName",order.getSendName());
				mapMessage.setString("sendMobile",order.getSendMobile());
				mapMessage.setString("sendMobileMsg",order.getSendMobileMsg());
				return mapMessage;
			}
		});
		workBillRepository.save(workBill);
	}

	// 保存订单，同时用订单关联快递员（自动分单）
	private void saveOrder(Order order, Courier courier) {
		// 订单关联快递员
		order.setCourier(courier);
		// 分单类型 1 自动分单 2 人工分单
		order.setOrderType("1");
		// 保存
		orderRepository.save(order);
	}
	
	@Override
	public Order findByOrderNum(String orderNum) {
		return orderRepository.findByOrderNum(orderNum);
	}
}
