package cn.itcast.bos.service;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import cn.itcast.bos.domain.base.Courier;

public interface CourierService {

	
	void save(Courier courier);

	Page<Courier> findPageQuery(Pageable pageable);

	Page<Courier> findPageQuery(Specification<Courier> specification, Pageable pageable);

	void deleteByIds(String[] arraysIds);

	List<Courier> findnoassociation();

	List<Courier> findCourierByFixedAreaId(String fixedAreaId);

	void restoreBatch(String[] idArray);


}
