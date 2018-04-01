package cn.itcast.crm.web.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;

import cn.itcast.crm.domain.Customer;
import cn.itcast.crm.service.CustomerService;
import cn.itcast.crm.web.action.common.BaseAction;

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class CustomerAction extends BaseAction<Customer> {
	private static final long serialVersionUID = 1L;
	@Autowired
	private CustomerService customerService;

	@Action(value = "customer_page_query", results = { @Result(name = SUCCESS, type = "json") })
	public String pageQuery() {
		Pageable pageable = new PageRequest(page - 1, rows,new Sort(Sort.Direction.ASC,"id"));
		Page<Customer> page = customerService.pageQuery(pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}

}
