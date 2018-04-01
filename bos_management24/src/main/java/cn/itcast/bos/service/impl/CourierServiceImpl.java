package cn.itcast.bos.service.impl;

import java.util.List;
import java.util.Set;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.CourierRepository;
import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.service.CourierService;

@Service
@Transactional
public class CourierServiceImpl implements CourierService {

	@Autowired
	CourierRepository courierRepository;

	@Override
	// @RequiresPermissions("courier:add") // 不管是谁操作都不会有权限
	public void save(Courier courier) {
		courierRepository.save(courier);
	}

	@Override
	public Page<Courier> findPageQuery(Pageable pageable) {
		Page<Courier> page = courierRepository.findAll(pageable);
		return page;
	}

	// 有条件的分页
	@Override
	public Page<Courier> findPageQuery(Specification<Courier> specification, Pageable pageable) {
		Page<Courier> page = courierRepository.findAll(specification, pageable);
		return page;
	}

	@Override
	public void deleteByIds(String[] arraysIds) {
		if (arraysIds != null && arraysIds.length > 0) {
			for (String ids : arraysIds) {
				Integer id = Integer.parseInt(ids);
				// 逻辑删除，更新字段
				courierRepository.updateDelType(id);
			}
		}
	}

	@Override
	public List<Courier> findnoassociation() {
		// 方案一
		// List<Courier> list = courierRepository.findByFixedAreasIsNull();
		// 方案二
		Specification<Courier> spec = new Specification<Courier>() {

			@Override
			public Predicate toPredicate(Root<Courier> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				Predicate predicate = cb.isEmpty(root.get("fixedAreas").as(Set.class));
				return predicate;
			}
		};
		List<Courier> list = courierRepository.findAll(spec);
		return list;
	}

	@Override
	public List<Courier> findCourierByFixedAreaId(String fixedAreaId) {
		List<Courier> list = courierRepository.findCourierByFixedAreaId(fixedAreaId);
		return list;
	}

	// 批量还原
	@Override
	public void restoreBatch(String[] idArray) {
		for (String idStr : idArray) {
			Integer id = Integer.parseInt(idStr);
			courierRepository.updateResTag(id);
		}
	}
}
