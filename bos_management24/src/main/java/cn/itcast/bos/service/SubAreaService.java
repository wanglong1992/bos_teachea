package cn.itcast.bos.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import cn.itcast.bos.domain.base.SubArea;

public interface SubAreaService {

	void saveSubAreas(List<SubArea> subAreas);

	Page<SubArea> findAll(Pageable pageable);


	List<SubArea> findSubAreaByFixedAreaId(String fixedAreaId);
	
	Page<SubArea> findPageQueryCourierByCondition(Specification<SubArea> specification, Pageable pageable);

	void save(SubArea model);

	void delete(String ids);

	List<SubArea> findAll();

	List<Object[]> exportSubAreaHighcharts();


}
