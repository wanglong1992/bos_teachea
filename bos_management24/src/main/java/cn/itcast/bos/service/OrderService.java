package cn.itcast.bos.service;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;

import cn.itcast.bos.domain.take_delivery.Order;

public interface OrderService {


	// 保存订单
	@Path("/order/save")
	@POST
	@Consumes(value={"application/xml","application/json"})
	public void save(Order order);

	public Order findByOrderNum(String orderNum);
}
