package cn.itcast.bos.web.action;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Actions;
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

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.base.Standard;
import cn.itcast.bos.service.CourierService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage("json-default")
@Namespace("/")
@Actions
@Controller
@Scope(value="prototype")
public class CourierAction extends BaseAction<Courier>{
	
	@Autowired
	CourierService courierService;
	
	// 保存
	@Action(value="courier_save",results={@Result(name="success",type="redirect",location="pages/base/courier.jsp"),
			@Result(name="error",type="redirect",location="unauthorized.jsp")})
	public String save(){
		try {
//			Subject subject = SecurityUtils.getSubject();
//			if(subject.isPermitted("courier:add")){
//				courierService.save(model);
//			}
//			else{
//				System.out.println("当前用户没有权限可以访问");
//			}
			courierService.save(model);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}
	
	
	// 快递员的数据表格遍历
	@Action(value="courier_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		// 无条件的分页查询
		//Pageable pageable = new PageRequest(page-1, rows);
		//Page<Courier> page = courierService.findPageQuery(pageable);
		// 有条件的分页查询
		Pageable pageable = new PageRequest(page-1, rows);
		// 组织查询条件
		Specification<Courier> specification = new Specification<Courier>() {
			// 完成的条件查询
			/**
			 * 传递：
			 * 		Root<Courier> root：（连接语句的时候需要字段，获取字段的名称）代表Criteria查询的根对象，Criteria查询的查询根定义了实体类型，能为将来导航获得想要的结果，它与SQL查询中的FROM子句类似
			 * 		CriteriaQuery<?> query： （简单的查询可以使用CriteriaQuery）代表一个specific的顶层查询对象，它包含着查询的各个部分，比如：select 、from、where、group by、order by等
			 * 		CriteriaBuilder cb：（复杂的查询可以使用CriteriaBuilder构建）用来构建CritiaQuery的构建器对象
			 * 返回：Predicate：封装查询条件
			 * 
			 */
			@Override
			public Predicate toPredicate(Root<Courier> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// 封装的查询条件（所有）
				Predicate predicate = null;
				// 将条件先封装到List集合
				List<Predicate> list = new ArrayList<Predicate>();
				//工号
				if(StringUtils.isNotBlank(model.getCourierNum())){
					Predicate p = cb.equal(root.get("courierNum").as(String.class), model.getCourierNum());// courierNum = ?
					list.add(p);
				}
				//所属单位	
				if(StringUtils.isNotBlank(model.getCompany())){
					Predicate p = cb.like(root.get("company").as(String.class), "%"+model.getCompany()+"%");// company like ?
					list.add(p);
				}
				//取派员类型
				if(StringUtils.isNotBlank(model.getType())){
					Predicate p = cb.like(root.get("type").as(String.class), "%"+model.getType()+"%");// type like ?
					list.add(p);
				}
				// 如果多表操作，连接的语法
				Join<Courier, Standard> join = root.join("standard", JoinType.INNER);
				//收派标准
				if(model.getStandard()!=null && model.getStandard().getId()!=null){
					Predicate p = cb.equal(join.get("id").as(Integer.class), model.getStandard().getId());// standard.id = ?
					list.add(p);
				}
				// 将list集合存放的多个条件，转换成predicate
				// 方案一
//				if(list!=null && list.size()>0){
//					Predicate [] p = new Predicate[list.size()];
//					predicate = cb.and(list.toArray(p));
//				}
//				return predicate;
				// 方案二
				if(list!=null && list.size()>0){
					Predicate [] p = new Predicate[list.size()];
					query.where(list.toArray(p));
				}
				// 排序
				query.orderBy(cb.desc(root.get("id").as(Integer.class)));
				return query.getRestriction();
			}
		};
		Page<Courier> page = courierService.findPageQuery(specification,pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}

	// 传递的id字符串，中间使用逗号分开
	private String ids;
	
	public void setIds(String ids) {
		this.ids = ids;
	}

	// 收派标准的删除
	@Action(value="courier_delete",results={@Result(name="success",type="redirect",location="pages/base/courier.jsp")})
	public String delete(){
		String [] arraysIds = ids.split(",");
		courierService.deleteByIds(arraysIds);
		return SUCCESS;
	}
	
	// 查询没有被关联的快递员列表
	@Action(value="courier_findnoassociation",results={@Result(name="success",type="json")})
	public String findnoassociation(){
		List<Courier> list = courierService.findnoassociation();
		pushValueStack(list);
		return SUCCESS;
	}
	
	// 属性驱动
	private String fixedAreaId;
	
	public void setFixedAreaId(String fixedAreaId) {
		this.fixedAreaId = fixedAreaId;
	}


	// 使用当前定区id，查询对应定区的快递员的集合
	@Action(value="courier_findCourierByFixedAreaId",results={@Result(name="success",type="json")})
	public String findCourierByFixedAreaId(){
		List<Courier> list = courierService.findCourierByFixedAreaId(fixedAreaId);
		pushValueStack(list);
		return SUCCESS;
	}
	
	//还原快递员
	@Action(value = "courier_restoreCourier", results = {
			@Result(name = "success", type = "redirect", location = "./pages/base/courier.html") })
	public String restoreCourier() {
		String[] idArray = ids.split(",");
		courierService.restoreBatch(idArray);
		return SUCCESS;
	}
}
