package cn.itcast.bos.dao;

import cn.itcast.bos.domain.base.TakeTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface TakeTimeRepository extends JpaRepository<TakeTime, Integer>, JpaSpecificationExecutor<TakeTime> {
	List<TakeTime> findTakeTimesByName(String name);

}
