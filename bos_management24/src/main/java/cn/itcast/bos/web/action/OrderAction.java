package cn.itcast.bos.web.action;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.take_delivery.Order;
import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.service.OrderService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class OrderAction extends BaseAction<Order> {

	@Autowired
	private OrderService orderService;
	
	// 使用订单号，查询订单
	@Action(value="order_findByOrderNum",results={@Result(name="success",type="json")})
	public String findByOrderNum(){
		Map<String, Object> map = new HashMap<>();
		Order order = orderService.findByOrderNum(model.getOrderNum());
		// 没有查询到结果
		if(order==null){
			map.put("success", false);
		}
		// 查询到结果
		else{
			// 随机生成一个运单号，回显到页面上
			WayBill wayBill = new WayBill();
			wayBill.setWayBillNum("suyunwaybill"+RandomStringUtils.randomNumeric(32));
			order.setWayBill(wayBill);
			map.put("success", true);
			map.put("orderData", order);
		}
		pushValueStack(map);
		return SUCCESS;
	}
}
