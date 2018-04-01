package cn.itcast.bos.web.action;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Actions;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

import cn.itcast.bos.domain.base.Standard;
import cn.itcast.bos.service.StandardService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage("json-default")
@Namespace("/")
@Actions
@Controller
@Scope(value="prototype")
public class StandardAction extends BaseAction<Standard> {

	@Autowired
	StandardService standardService;
	
	// 保存
	@Action(value="standard_save",results={@Result(name="success",type="redirect",location="pages/base/standard.jsp")})
	public String save(){
		//System.out.println(standard);
		standardService.save(model);
		return SUCCESS;
	}
	
	// ajax校验收派标准名称是否存在
	@Action(value="standard_validateName",results={@Result(name="success",type="json")})
	public String validateName(){
		// 获取页面输入的收派标准的名称
		String name = model.getName();
		// 使用name查询数据库，判断当前输入的收派标准名称是否存在，写一个条件 from Standard where name = ?
		List<Standard> list = standardService.findByName(name);
		// ajax，将返回的结果放置到栈顶，页面接收到ajax响应的数据
		// 表示数据库中没有记录，页面可以输入name的值
		if(list!=null && list.size()==0){
			ServletActionContext.getContext().getValueStack().push(true);// true表示验证正确
		}
		else{
			ServletActionContext.getContext().getValueStack().push(false);// true表示验证正确
		}
		return SUCCESS;
	}
	
	// 收派标准的数据表格遍历
	@Action(value="standard_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		// 无条件的分页查询
		Pageable pageable = new PageRequest(page-1, rows);
		Page<Standard> page = standardService.findPageQuery(pageable);
		/** 响应的结果，total（总记录数）和rows（集合）
		 * {                                                      
				"total":100,	
				"rows":[ 
					{"id":"001","name":"10-20公斤","minWeight":"10","maxWeight":"20","minLength":"11","maxLength":"22","operator":"张三","operatingTime":"2016-08-18","company":"杭州分部"}
				]
			}
		 */
		pushValueStackToPage(page);
		return SUCCESS;
	}
	
	// 传递的id字符串，中间使用逗号分开
	private String ids;
	
	public void setIds(String ids) {
		this.ids = ids;
	}

	// 收派标准的删除
	@Action(value="standard_delete",results={@Result(name="success",type="redirect",location="pages/base/standard.jsp")})
	public String delete(){
		String [] arraysIds = ids.split(",");
		standardService.deleteByIds(arraysIds);
		return SUCCESS;
	}
	
	// 查询收派标准的所有记录
	@Action(value="standard_findAll",results={@Result(name="success",type="json")})
	public String findAll(){
		List<Standard> list = standardService.findAll();
		ServletActionContext.getContext().getValueStack().push(list);
		return SUCCESS;
	}
}
