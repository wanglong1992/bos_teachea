package cn.itcast.bos.service.impl;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.MenuRepository;
import cn.itcast.bos.dao.PermissionRepository;
import cn.itcast.bos.dao.RoleRepository;
import cn.itcast.bos.domain.system.Menu;
import cn.itcast.bos.domain.system.Permission;
import cn.itcast.bos.domain.system.Role;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.RoleService;

@Service
@Transactional
public class RoleServiceImpl implements RoleService {

	@Autowired
	private RoleRepository roleRepository;
	
	@Autowired
	private PermissionRepository permissionRepository;
	
	@Autowired
	private MenuRepository menuRepository;

	// 使用当前用户查询角色列表
	@Override
	public List<Role> findByUser(User user) {
		// 如果当前用户是admin，查询所有角色
		if(user!=null && user.getUsername().equals("admin")){
			return roleRepository.findAll();
		}
		// 如果当前用户不是admin，按照当前用户的ID，查询对应用户角色
		else{
			return roleRepository.findByRoleListByUserId(user.getId());
		}
	}
	
	@Override
	public List<Role> findRoleList() {
		return roleRepository.findAll();
	}
	
	@Override
	public void save(Role role, String[] permissionIds, String menuIds) {
		// 1:保存角色
		roleRepository.save(role);
		// 2:建立角色和权限的关联关系
		if(permissionIds!=null && permissionIds.length>0){
			for(String permissionId:permissionIds){
				// 获取权限的对象
				Permission permission = permissionRepository.findOne(Integer.parseInt(permissionId));
				// 建立关联关系
				role.getPermissions().add(permission);
			}
		}
		// 3:建立角色和菜单的关联关系
		if(StringUtils.isNotBlank(menuIds)){
			String[] arrayMenuIds = menuIds.split(",");
			for(String menuId:arrayMenuIds){
				// 获取菜单的对象
				Menu menu = menuRepository.findOne(Integer.parseInt(menuId));
				// 建立关联关系
				role.getMenus().add(menu);
			}
		}
	}
}
