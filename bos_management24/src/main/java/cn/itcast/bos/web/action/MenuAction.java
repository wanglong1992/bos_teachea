package cn.itcast.bos.web.action;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.system.Menu;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.MenuService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class MenuAction extends BaseAction<Menu> {

	@Autowired
	private MenuService menuService;
	
	// 菜单列表
	@Action(value="menu_list",results={@Result(name="success",type="json")})
	public String list(){			
		List<Menu> list = menuService.findMenuList();
		pushValueStack(list);
		return SUCCESS;
	}
	
	// 菜单保存
	@Action(value="menu_save",results={@Result(name="success",type="redirect",location="./pages/system/menu.jsp")})
	public String save(){
		// 解决瞬时态异常
		if(model.getParentMenu()!=null && model.getParentMenu().getId()==0){
			model.setParentMenu(null);
		}
		menuService.save(model);
		return SUCCESS;
	}
	
	// 左侧菜单列表
	@Action(value="menu_showMenu",results={@Result(name="success",type="json")})
	public String showMenu(){
		// 使用当前用户获取所有的菜单
		Subject subject = SecurityUtils.getSubject();
		User user = (User)subject.getPrincipal();
		List<Menu> list = menuService.findMenuListByUser(user);
		pushValueStack(list);
		return SUCCESS;
	}		    
}
