package cn.itcast.bos.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.SubAreaRepository;
import cn.itcast.bos.domain.base.SubArea;
import cn.itcast.bos.service.SubAreaService;

@Service
@Transactional
public class SubAreaServiceImpl implements SubAreaService {

	@Autowired
	private SubAreaRepository subAreaRepository;

	@Override
	public void saveSubAreas(List<SubArea> subAreas) {
		subAreaRepository.save(subAreas);
	}
	
	@Override
	public Page<SubArea> findAll(Pageable pageable) {
		return subAreaRepository.findAll(pageable);
	}

	@Override
	public Page<SubArea> findPageQueryCourierByCondition(Specification<SubArea> specification, Pageable pageable) {
		
		return subAreaRepository.findAll(specification, pageable);
	}

	@Override
	public void save(SubArea model) {
		
		subAreaRepository.save(model);
		//System.out.println(model);
	}

	@Override
	public void delete(String ids) {
		String[] idArray = ids.split(",");
		for (String id : idArray) {
			subAreaRepository.delete(id);
		}
	}

	@Override
	public List<SubArea> findAll() {
		
		return subAreaRepository.findAll();
	}

	@Override
	public List<SubArea> findSubAreaByFixedAreaId(String fixedAreaId) {
		return subAreaRepository.findSubAreaByFixedAreaId(fixedAreaId);
	}

	@Override
	public List<Object[]> exportSubAreaHighcharts() {
		
		 return subAreaRepository.findByAreaId();
	}

	
}
























