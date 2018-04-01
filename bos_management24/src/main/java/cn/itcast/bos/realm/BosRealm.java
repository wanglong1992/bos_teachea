package cn.itcast.bos.realm;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;

import cn.itcast.bos.domain.system.Permission;
import cn.itcast.bos.domain.system.Role;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.PermissionService;
import cn.itcast.bos.service.RoleService;
import cn.itcast.bos.service.UserService;

public class BosRealm extends AuthorizingRealm {

	@Autowired
	UserService userService;
	
	@Autowired
	RoleService roleService;
	
	@Autowired
	PermissionService permissionService;
	
	// 认证（登录）
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
		System.out.println("shiro认证！");
		// 获取登录用户名
		UsernamePasswordToken usernamePasswordToken = (UsernamePasswordToken)authenticationToken;
		String username = usernamePasswordToken.getUsername();
		// 使用用户名查询数据库 ，判断数据库中是否存在数据
		User user = userService.findByUsername(username);
		/**
		 * return null;org.apache.shiro.authc.UnknownAccountException：表示用户名不存在
		 */
		if(user==null){
			return null;
		}
		else{
			// 用户名输入正确，判断一个密码
			/**
			 * 参数一：Object principal，用来存放当前用户信息（理解成Session），表示认证成功
			 * 参数二：Object credentials，用来存放当前用户从数据库中获取的密码
			 * 			shiro会将UsernamePasswordToken中存放的密码和该参数的密码进行比对
			 * 				* 如果比对成功，表示成功登陆系统，并将用户信息存放到了principal对象
			 * 				* 如果比对不成功，表示密码输入有误，抛出一个异常org.apache.shiro.authc.IncorrectCredentialsException
			 * 参数三：String realmName，当前Realm的名称
			 */
			return new SimpleAuthenticationInfo(user, user.getPassword(), getName());
		}
	}
	
	// 授权（url级别、细粒度）
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection arg0) {
		System.out.println("shiro授权！");
		// 添加当前用户具有的角色（keyword）和权限（keyword）
		SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
		// 获取当前用户信息
		Subject subject = SecurityUtils.getSubject();
		User user = (User)subject.getPrincipal();
		// 添加角色：使用当前用户查询当前用户具有的角色
		List<Role> roleList = roleService.findByUser(user);
		for(Role role:roleList){
			authorizationInfo.addRole(role.getKeyword());
		}
		// 添加权限：使用当前用户查询当前用户具有的权限
		List<Permission> permissionList = permissionService.findByPermission(user);
		for(Permission permission:permissionList){
			authorizationInfo.addStringPermission(permission.getKeyword());
		}
		return authorizationInfo;
	}

	

}
