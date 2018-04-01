package cn.itcast.bos.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.CourierRepository;
import cn.itcast.bos.dao.FixedAreaRepository;
import cn.itcast.bos.dao.TakeTimeRepository;
import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.base.FixedArea;
import cn.itcast.bos.domain.base.TakeTime;
import cn.itcast.bos.service.FixedAreaService;

@Service
@Transactional
public class FixedAreaServiceImpl implements FixedAreaService {

	@Autowired
	private FixedAreaRepository fixedAreaRepository;
	
	@Autowired
	private CourierRepository courierRepository;
	
	@Autowired
	private TakeTimeRepository takeTimeRepository;


	@Override
	public void save(FixedArea fixedArea) {
		fixedAreaRepository.save(fixedArea);
	}
	
	@Override
	public Page<FixedArea> findPageQuery(Specification<FixedArea> specification, Pageable pageable) {
		return fixedAreaRepository.findAll(specification, pageable);
	}
	
	@Override
	public void associationCourierToFixedArea(String fixedAreaId, String courierId, String takeTimeId) {
		// 定区
		FixedArea fixedArea = fixedAreaRepository.findOne(fixedAreaId);
		// 快递员
		Courier courier = courierRepository.findOne(Integer.parseInt(courierId));
		// 收派时间
		TakeTime takeTime = takeTimeRepository.findOne(Integer.parseInt(takeTimeId));
		// 建立快递员和收派时间的关联关系
		courier.setTakeTime(takeTime);
		// 建立快递员和定区的关联关系
		fixedArea.getCouriers().add(courier);
		// 快照更新
	}

	@Override
	public void delete(String id) {
		fixedAreaRepository.delete(id);
	}

	@Override
	public List<FixedArea> findAll() {
		return fixedAreaRepository.findAll();
	}
	
}
