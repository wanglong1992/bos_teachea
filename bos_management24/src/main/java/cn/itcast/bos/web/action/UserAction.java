package cn.itcast.bos.web.action;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.system.Role;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.UserService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class UserAction extends BaseAction<User> {

	@Autowired
	private UserService userService;
	
	// 登录
	@Action(value="user_login",results={@Result(name="success",type="redirect",location="index.jsp"),
			@Result(name="input",type="redirect",location="login.jsp")})
	public String login(){
		// System.out.println(model.getUsername()+"        "+model.getPassword());
		// shiro获取Subject的对象
		Subject subject = SecurityUtils.getSubject();
		// 存放用户名和密码
		AuthenticationToken authenticationToken = new UsernamePasswordToken(model.getUsername(),model.getPassword());
		try {
			// 登录（将用户名和密码存放到Subject中，调用安全管理器，通过安全管理器调用Realm），如果正常登录，不会抛出异常；如果输入有误（非正常登录），此时会抛出异常
			subject.login(authenticationToken);
			return SUCCESS;
		} catch (AuthenticationException e) {
			//e.printStackTrace();
			if(e instanceof UnknownAccountException){
				System.out.println("用户名输入有误！");
			}
			if(e instanceof IncorrectCredentialsException){
				System.out.println("密码输入有误！");
			}
			return INPUT;
		}
		
	}
	
	@Action(value="user_logout",results={@Result(name="success",type="redirect",location="login.jsp")})
	public String logout(){
		// 清空主题Subject
		Subject subject = SecurityUtils.getSubject();
		subject.logout();
		return SUCCESS;
	}
	
	// 用户列表
	@Action(value="user_list",results={@Result(name="success",type="json")})
	public String list(){
		List<User> list = userService.findUserList();
		pushValueStack(list);
		return SUCCESS;
	}
	
	// 属性驱动
	// 角色id（数组）
	String [] roleIds;
	
	public void setRoleIds(String[] roleIds) {
		this.roleIds = roleIds;
	}

	// 用户保存
	@Action(value="user_save",results={@Result(name="success",type="redirect",location="./pages/system/userlist.jsp")})
	public String save(){
		userService.save(model,roleIds);
		return SUCCESS;
	}
}
