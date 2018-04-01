package cn.itcast.bos.service;

import java.util.List;

import cn.itcast.bos.domain.system.Permission;
import cn.itcast.bos.domain.system.User;

public interface PermissionService {

	List<Permission> findByPermission(User user);

	List<Permission> findPermissionList();

	void save(Permission model);


}
