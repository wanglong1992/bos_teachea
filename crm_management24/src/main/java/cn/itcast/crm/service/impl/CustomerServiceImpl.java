package cn.itcast.crm.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;
import javax.ws.rs.core.Response;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.crm.dao.CustomerRepository;
import cn.itcast.crm.domain.Customer;
import cn.itcast.crm.service.CustomerService;
import cn.itcast.crm.utils.DateFormatUtil;

@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {

	@Autowired
	CustomerRepository customerRepository;
	
	@Autowired
	@Qualifier("jmsQueueTemplate")
	JmsTemplate jmsTemplate;

	@Override
	public List<Customer> findNoAssociationCustomers() {
		return customerRepository.findByFixedAreaIdIsNull();
	}

	@Override
	public List<Customer> findHasAssociationFixedAreaCustomers(String fixedAreaId) {
		return customerRepository.findByFixedAreaId(fixedAreaId);
	}

	// 将客户关联到定区上 ， 将所有客户id 拼成字符串 1,2,3，使用@QueryParam实现
	@Override
	public void associationCustomersToFixedArea(String customerIdStr, String fixedAreaId) {
		// 一：使用定区id清空当前定区ID的字段
		customerRepository.updateFixedAreaIdByFixedAreaId(fixedAreaId);
		// 二：将客户重新关联到指定的定区ID的字段
		if (StringUtils.isBlank(customerIdStr) || "null".equals(customerIdStr)) {
			return;
		}
		String[] arrayCustomerIds = customerIdStr.split(",");
		for (String customerIds : arrayCustomerIds) {
			Integer id = Integer.parseInt(customerIds);
			customerRepository.updateFixedAreaIdByIds(fixedAreaId, id);
		}
	}

	@Override
	public void save(Customer customer) {
		customerRepository.save(customer);
	}

	@Override
	public Customer findByTelephone(String telephone) {
		return customerRepository.findByTelephone(telephone);
	}

	@Override
	public void updateType(String telephone) {
		customerRepository.updateType(telephone);
	}

	@Override
	public Customer findByTelephoneAndPassword(String telephone, String password) {
		return customerRepository.findByTelephoneAndPassword(telephone, password);
	}

	@Override
	public String findFixedAreaIdByIdAndAddress(Integer id, String address) {
		return customerRepository.findFixedAreaIdByIdAndAddress(id, address);
	}



	@Override
	public Response signIn(Integer id) {
			// 获取当前用户
			Customer customer = customerRepository.findOne(id);
			//判空问题
			Integer hasSignIsDay = customer.getHasSignIsDay();
			if(hasSignIsDay==null){
				hasSignIsDay=0;
			}
			Long credits = customer.getCredits();
			if(credits==null){
				credits=0l;
			}
			// 判断是否连续签到 
			// 获取上次签到的时间
			Date lastSignInTime = customer.getLastSignInTime();
			if(lastSignInTime==null){
				// 从未签到过,则为初次签到,则积分加200
				customer.setCredits(credits+200);
				//积分设为0
				customer.setHasSignIsDay(0);
				//记录最后更新时间
				customer.setLastSignInTime(new Date());
				//将用户签到状态设置为1,已经签到
				customer.setHasSignInToday("1");
				return Response.ok().build();
			}
			//如果上次有签到时间
			// 通过工具类获取第二天的日期
			Date tomorrow = DateFormatUtil.getDateWithOffsetDay(lastSignInTime, 1);
			// 获取当前日期
			Date nowdate = new Date();
			// 比较两个日期是否相等
			if (DateFormatUtil.compareDateByString(tomorrow,nowdate)) {
				// 如果相等则是连续签到,则积分加400
				customer.setCredits(credits+400);
				//连续签到天数+1
				customer.setHasSignIsDay(hasSignIsDay+1);
			} else {
				//如果不想等则不是连续签到,则积分加200
				customer.setCredits(credits+200);
				//连续签到天数归零
				customer.setHasSignIsDay(0);
				}
			
			//记录最后更新时间
			customer.setLastSignInTime(new Date());
			//将用户签到状态设置为1,已经签到
			customer.setHasSignInToday("1");
			//快照更新
			return Response.ok().build();
		
			//如果签到出错则提示错误
			//return Response.status(Status.NOT_FOUND).build();
	}




	@Override
	public Customer findCustomerById(Integer id) {
		return customerRepository.findById(id);
	}

	@Override
	public void update(Customer customer) {
		Customer customer2 = customerRepository.findById(customer.getId());
		customer2.setAddress(customer.getAddress());
		customer2.setUsername(customer.getUsername());
		customer2.setCompany(customer.getCompany());
		customer2.setBirthday(customer.getBirthday());
		customer2.setDepartment(customer.getDepartment());
		customer2.setSex(customer.getSex());
		customer2.setPosition(customer.getPosition());
		customer2.setMobilePhone(customer.getMobilePhone());
		customer2.setTelephone(customer.getTelephone());
		customer2.setEmail(customer.getEmail());
		customer2.setAddress(customer.getAddress());
		customer2.setHeadImg(customer.getHeadImg());
	}


	@Override
	public Page<Customer> pageQuery(Pageable pageable) {
		
		return customerRepository.findAll(pageable);
	}

	@Override
	public void clearSignInStatus() {
		 customerRepository.clearSignInStatus();
	}

	@Override
	public void sendMessageAndEmail() {
		//查询当天日期
		String currentDate=new SimpleDateFormat("MM-dd").format(new Date());
		final String num = currentDate.replace('-', '月')+"日";
		System.out.println(num);
		//列出所有客户的生日
		List<Customer> list = customerRepository.findCurrentBirthday(currentDate);
		for (Customer customer : list) {
			//System.out.println(customer);
			final String telephone = customer.getTelephone();
			//final String num = currentDate;
			jmsTemplate.send("bos_smsbirthday", new MessageCreator() {
				
				@Override
				public Message createMessage(Session session) throws JMSException {
					MapMessage message = session.createMapMessage();
					message.setString("telephone",telephone );
					message.setString("number", num);
					return message;
				}
			});
		}
	}
	
	
	
	

}
