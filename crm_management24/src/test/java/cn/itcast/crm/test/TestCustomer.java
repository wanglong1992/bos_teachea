package cn.itcast.crm.test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.itcast.crm.domain.Customer;
import cn.itcast.crm.service.CustomerService;

@RunWith(value=SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class TestCustomer {

	@Autowired
	CustomerService customerService;
	
	// 查询所有未关联客户列表
	@Test
	public void findNoAssociationCustomers(){
		List<Customer> list = customerService.findNoAssociationCustomers();
		for(Customer c:list){
			System.out.println(c);
		}
	}
	
	// 已经关联到指定定区的客户列表
	@Test
	public void findHasAssociationFixedAreaCustomers(){
		String fixedAreaId = "dq001";
		List<Customer> list = customerService.findHasAssociationFixedAreaCustomers(fixedAreaId);
		for(Customer c:list){
			System.out.println(c);
		}
	}
	
	// 将客户关联到定区上 ， 将所有客户id 拼成字符串 1,2,3，使用@QueryParam实现
	@Test
	public void associationCustomersToFixedArea(){
		String fixedAreaId = "dq001";
		String customerIdStr = "10001,10003";
		customerService.associationCustomersToFixedArea(customerIdStr,fixedAreaId);
	}
}
