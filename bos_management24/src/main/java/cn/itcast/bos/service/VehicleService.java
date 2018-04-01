package cn.itcast.bos.service;

import cn.itcast.bos.domain.base.Vehicle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * @author zhangjie
 * @date 2018-03-31 16:36
 */
public interface VehicleService {
	Page<Vehicle> pageQuery(Pageable pageable);

	void save(Vehicle vehicle);

	void deleteByIds(String[] arraysIds);
}
