package cn.itcast.bos.service;

import cn.itcast.bos.domain.base.TakeTime;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface TakeTimeService {

	List<TakeTime> findAll();

	Page<TakeTime> pageQuery(Pageable pageable);

	List<TakeTime> findByName(String name);

	void save(TakeTime takeTime);

	void deleteByIds(String[] arraysIds);
}
