package cn.itcast.bos.web.action;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.base.FixedArea;
import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.service.FixedAreaService;
import cn.itcast.bos.web.action.common.BaseAction;
import cn.itcast.crm.domain.Customer;

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class FixedAreaAction extends BaseAction<FixedArea> {

	@Autowired
	private FixedAreaService fixedAreaService;

	// 保存
	@Action(value = "fixedArea_save", results = {
			@Result(name = "success", type = "redirect", location = "pages/base/fixed_area.jsp") })
	public String save() {
		fixedAreaService.save(model);
		return SUCCESS;
	}

	// 区域的数据表格遍历
	@Action(value = "fixedArea_pageQuery", results = { @Result(name = "success", type = "json") })
	public String pageQuery() throws Exception {
		Pageable pageable = new PageRequest(page - 1, rows);
		// 组织查询条件
		Specification<FixedArea> specification = new Specification<FixedArea>() {
			// 完成的条件查询
			@Override
			public Predicate toPredicate(Root<FixedArea> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// 将条件先封装到List集合
				List<Predicate> list = new ArrayList<Predicate>();
				// 定区编码
				if (StringUtils.isNotBlank(model.getId())) {
					Predicate p = cb.equal(root.get("id").as(String.class), model.getId());// id
																							// =
																							// ?
					list.add(p);
				}
				// 公司
				if (StringUtils.isNotBlank(model.getCompany())) {
					Predicate p = cb.like(root.get("company").as(String.class), "%" + model.getCompany() + "%");// company
																												// like
																												// ?
					list.add(p);
				}
				if (list != null && list.size() > 0) {
					Predicate[] p = new Predicate[list.size()];
					query.where(list.toArray(p));
				}
				// 排序
				query.orderBy(cb.desc(root.get("id").as(String.class)));
				return query.getRestriction();
			}
		};
		Page<FixedArea> page = fixedAreaService.findPageQuery(specification, pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}

	// 使用ajax查询没有关联定区的客户列表，通过webservice的调用查询CRM系统
	@Action(value = "fixedArea_noassociationSelect", results = { @Result(name = "success", type = "json") })
	public String noassociationSelect() throws Exception {
		Collection<? extends Customer> collection = WebClient
				.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/findNoAssociationCustomers")
				.accept(MediaType.APPLICATION_JSON).getCollection(Customer.class);
		ServletActionContext.getContext().getValueStack().push(collection);
		return SUCCESS;
	}

	// 使用ajax查询已经关联当前定区的客户列表，通过webservice的调用查询CRM系统
	@Action(value = "fixedArea_associationSelect", results = { @Result(name = "success", type = "json") })
	public String associationSelect() throws Exception {
		Collection<? extends Customer> collection = WebClient
				.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/findHasAssociationFixedAreaCustomers/"
						+ model.getId())
				.accept(MediaType.APPLICATION_JSON).type(MediaType.APPLICATION_JSON).getCollection(Customer.class);
		ServletActionContext.getContext().getValueStack().push(collection);
		return SUCCESS;
	}

	// 属性驱动，客户ID的数组
	private String[] customerIds;

	public void setCustomerIds(String[] customerIds) {
		this.customerIds = customerIds;
	}

	@Action(value = "fixedArea_associationCustomersToFixedArea", results = {
			@Result(name = "success", type = "redirect", location = "pages/base/fixed_area.jsp") })
	public String associationCustomersToFixedArea() {
		// System.out.println(model.getId());
		// System.out.println(customerIds);
		String customerIdStr = StringUtils.join(customerIds, ",");
		WebClient.create(Constants.CRM_MANAGEMENT_URL
				+ "/services/customerService/associationCustomersToFixedArea?customerIdStr=" + customerIdStr
				+ "&fixedAreaId=" + model.getId()).type(MediaType.APPLICATION_JSON).put(null);
		return SUCCESS;
	}

	// 属性驱动
	// 快递员id
	private String courierId;
	// 收派时间id
	private String takeTimeId;

	public void setCourierId(String courierId) {
		this.courierId = courierId;
	}

	public void setTakeTimeId(String takeTimeId) {
		this.takeTimeId = takeTimeId;
	}

	// 定区 关联快递员，快递员 关联收派时间
	@Action(value = "fixedArea_associationCourierToFixedArea", results = {
			@Result(name = "success", type = "redirect", location = "pages/base/fixed_area.jsp") })
	public String associationCourierToFixedArea() {
		// 定区id
		String fixedAreaId = model.getId();
		// 建立表和表之间的关联关系
		fixedAreaService.associationCourierToFixedArea(fixedAreaId, courierId, takeTimeId);
		return SUCCESS;
	}

	// 删除
	private String ids;

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value = "fixedArea_delete", results = {
			@Result(name = "success", type = "redirect", location = "pages/base/fixed_area.jsp"),
			@Result(name = "error", type = "redirect", location = "unauthorized.jsp") })
	public String delete() {
		String[] arrayIds = ids.split(",");
		try {
			for (String id : arrayIds) {
				fixedAreaService.delete(id);
			}
		} catch (Exception e) {
			return ERROR;
		}
		return SUCCESS;
	}
	
	@Action(value = "fixedArea_findAll", results = {
			@Result(name = "success", type = "json" )})
	public String findAll(){
		List<FixedArea> list = fixedAreaService.findAll();
		pushValueStack(list);
		return	SUCCESS;
	}
}
