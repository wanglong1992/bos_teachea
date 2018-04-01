package cn.itcast.crm.service;

import cn.itcast.crm.domain.CustomerAddressBook;

import javax.ws.rs.*;
import java.util.List;

public interface CustomerAddressBookService {
    //根据用户id,查找所有的地址
    @Path(value = "/findCustomerAddressBook/{id}")
    @GET
    @Produces(value = { "application/xml", "application/json" })
    @Consumes(value = { "application/xml", "application/json" })
    public List<CustomerAddressBook> findByUserId(@PathParam("id") Integer id);

    //根据用户id添加地址簿
    @Path("/customerAddressBook/save")
    @POST
    @Consumes(value = { "application/xml", "application/json" })
    @Produces(value = { "application/xml", "application/json" })
    public  void save(CustomerAddressBook customerAddressBook);
    //TODO
}
