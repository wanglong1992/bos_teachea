package cn.itcast.bos.web.action;

import javax.ws.rs.core.MediaType;

import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.domain.page.PageBean;
import cn.itcast.bos.domain.take_delivery.Order;
import cn.itcast.bos.domain.take_delivery.Promotion;
import cn.itcast.bos.web.action.common.BaseAction;
import cn.itcast.crm.domain.Customer;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class OrderAction extends BaseAction<Order> {

	// 属性驱动
	// 寄件人区域
	private String sendAreaInfo;
	// 收件人区域
	private String recAreaInfo;
	
	public void setSendAreaInfo(String sendAreaInfo) {
		this.sendAreaInfo = sendAreaInfo;
	}

	public void setRecAreaInfo(String recAreaInfo) {
		this.recAreaInfo = recAreaInfo;
	}

	// 订单保存
	@Action(value="order_save",results={@Result(name="success",type="redirect",location="./index.jsp#/myhome")})
	public String save() throws Exception{
		// System.out.println("order:"+model);
		// 1：model中封装寄件人和收件人的省市区
		String[] sendAreaArray = sendAreaInfo.split("/");
		String[] recAreaArray = recAreaInfo.split("/");
		// 寄件人的省市区存放到Area对象中
		Area sendArea = new Area();
		sendArea.setProvince(sendAreaArray[0]);
		sendArea.setCity(sendAreaArray[1]);
		sendArea.setDistrict(sendAreaArray[2]);
		model.setSendArea(sendArea);
		// 收件人的省市区存放到Area对象中
		Area recArea = new Area();
		recArea.setProvince(recAreaArray[0]);
		recArea.setCity(recAreaArray[1]);
		recArea.setDistrict(recAreaArray[2]);
		model.setRecArea(recArea);
		// 2：先登录，再下单，从Session中获取登录用户的信息，用作后面的自动分单
		Customer c = (Customer)ServletActionContext.getRequest().getSession().getAttribute("customer");
		// 客户id存放到订单中
		model.setCustomer_id(c.getId());
		// 3：执行webservice，调用bos_management，保存订单
		WebClient.create(Constants.BOS_MANAGEMENT_URL+"/services/orderService/order/save")
				.type(MediaType.APPLICATION_JSON)
				.post(model);
		return SUCCESS;
	}
	
	
}
