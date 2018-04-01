package cn.itcast.bos.web.action;

import cn.itcast.bos.domain.base.TakeTime;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.TakeTimeService;
import cn.itcast.bos.web.action.common.BaseAction;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
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
import org.springframework.stereotype.Controller;

import java.util.Date;
import java.util.List;

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class TakeTimeAction extends BaseAction<TakeTime> {

	@Autowired
	private TakeTimeService takeTimeService;

	private String ids;

	// 查询所有的收派时间
	@Action(value = "taketime_findAll", results = {@Result(name = "success", type = "json")})
	public String findAll() {
		List<TakeTime> list = takeTimeService.findAll();
		pushValueStack(list);
		return SUCCESS;
	}

	//  分页查询所有的收派时间
	@Action(value = "taketime_pageQuery", results = {@Result(name = "success", type = "json")})
	public String pageQuery() {
		Pageable pageable = new PageRequest(page - 1, rows);
		Page<TakeTime> takeTimes = takeTimeService.pageQuery(pageable);
		pushValueStackToPage(takeTimes);
		return SUCCESS;
	}

	// ajax校验收派时间名称是否存在
	@Action(value = "taketime_validateName", results = {@Result(name = "success", type = "json")})
	public String validateName() {
		String name = model.getName();
		List<TakeTime> list = takeTimeService.findByName(name);

		if (list != null && list.size() == 0) {
			ServletActionContext.getContext().getValueStack().push(true);
		} else {
			ServletActionContext.getContext().getValueStack().push(false);
		}

		return SUCCESS;
	}

	// 收派时间保存
	@Action(value = "taketime_save", results = {@Result(name = "success", type = "redirect", location = "pages/base/take_time.jsp")
			, @Result(name = "error", type = "redirect", location = "login.jsp")})
	public String save() {
		Subject subject = SecurityUtils.getSubject();
		User user = (User) subject.getPrincipal();

		if (user == null) {
			return ERROR;
		}

		model.setOperator(user.getUsername());
		model.setOperatingTime(new Date());
		takeTimeService.save(model);

		return SUCCESS;
	}

	// 收派时间的删除
	@Action(value="taketime_delete",results={@Result(name="success",type="redirect",location="pages/base/take_time.jsp")})
	public String delete(){
		String [] arraysIds = ids.split(",");
		takeTimeService.deleteByIds(arraysIds);
		return SUCCESS;
	}


	public void setIds(String ids) {
		this.ids = ids;
	}
}
