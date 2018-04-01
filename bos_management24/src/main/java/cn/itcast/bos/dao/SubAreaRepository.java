package cn.itcast.bos.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import cn.itcast.bos.domain.base.SubArea;

public interface SubAreaRepository extends JpaRepository<SubArea,String>,JpaSpecificationExecutor<SubArea> {

	List<SubArea> findSubAreaByFixedAreaId(String fixedAreaId);

	@Query(value="select count(s.c_area_id),(SELECT a.c_district FROM t_area a WHERE s.c_area_id = a.c_ID) FROM t_sub_area s GROUP BY s.c_area_id",nativeQuery=true)
	List<Object[]> findByAreaId();
}
