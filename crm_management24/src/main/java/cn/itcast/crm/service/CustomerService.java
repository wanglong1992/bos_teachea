package cn.itcast.crm.service;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import cn.itcast.crm.domain.Customer;

public interface CustomerService {

	// 查询所有未关联客户列表
	@Path("/findNoAssociationCustomers")
	@GET
	@Produces(value = { "application/xml", "application/json" })
	public List<Customer> findNoAssociationCustomers();

	// 已经关联到指定定区的客户列表，使用@PathParam实现
	@Path("/findHasAssociationFixedAreaCustomers/{fixedAreaId}")
	@GET
	@Produces(value = { "application/xml", "application/json" })
	@Consumes(value = { "application/xml", "application/json" })
	public List<Customer> findHasAssociationFixedAreaCustomers(@PathParam("fixedAreaId") String fixedAreaId);

	// 将客户关联到定区上 ， 将所有客户id 拼成字符串 1,2,3，使用@QueryParam实现
	@Path("/associationCustomersToFixedArea")
	@PUT
	@Consumes(value = { "application/xml", "application/json" })
	public void associationCustomersToFixedArea(@QueryParam("customerIdStr") String customerIdStr,
			@QueryParam("fixedAreaId") String fixedAreaId);

	// 注册客户
	@Path("/customer/save")
	@POST
	@Consumes(value = { "application/xml", "application/json" })
	public void save(Customer customer);

	// 使用电话号查询客户信息
	@Path("/customer/telephone/{telephone}")
	@GET
	@Consumes(value = { "application/xml", "application/json" })
	@Produces(value = { "application/xml", "application/json" })
	public Customer findByTelephone(@PathParam("telephone") String telephone);

	// 使用电话号更新客户信息，将type字段从0变成1，表示被激活
	@Path("/customer/updateType/{telephone}")
	@PUT
	@Consumes(value = { "application/xml", "application/json" })
	public void updateType(@PathParam("telephone") String telephone);

	// 使用电话号和密码查询客户信息
	@Path("/customer/telephoneAndPassword/{telephone}/{password}")
	@GET
	@Consumes(value = { "application/xml", "application/json" })
	@Produces(value = { "application/xml", "application/json" })
	public Customer findByTelephoneAndPassword(@PathParam("telephone") String telephone,
			@PathParam("password") String password);

	// 使用客户id和客户的下单地址，查询客户信息表，获取唯一定区id
	@Path("/customer/findFixedAreaIdByIdAndAddress/{id}/{address}")
	@GET
	@Consumes(value = { "application/xml", "application/json" })
	@Produces(value = { "application/xml", "application/json" })
	public String findFixedAreaIdByIdAndAddress(@PathParam("id") Integer id, @PathParam("address") String address);

	// 用户签到的方法
	@Path("/customer/signIn/{id}")
	@PUT
	@Consumes(value = { "application/xml", "application/json" })
	// @Produces(value={"application/xml","application/json"})
	public Response signIn(@PathParam("id") Integer id);

	// 使用客户id和客户的下单地址，查询客户信息表，获取唯一定区id
	@Path("/customer/findCustomerById/{id}")
	@GET
	@Consumes(value = { "application/xml", "application/json" })
	@Produces(value = { "application/xml", "application/json" })
	public Customer findCustomerById(@PathParam("id") Integer id);

	// 更新客户信息
	@Path("/customer/update")
	@PUT
	@Consumes(value = { "application/xml", "application/json" })
	public void update(Customer customer);

	// crm系统客户分页查询
	public Page<Customer> pageQuery(Pageable pageable);

	//清除用户当天签到状态
	public void clearSignInStatus();
	
	//扫描和发送祝福短信和email给当天生日的客户
	public void sendMessageAndEmail();

}