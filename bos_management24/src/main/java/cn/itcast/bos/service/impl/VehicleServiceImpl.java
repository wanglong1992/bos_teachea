package cn.itcast.bos.service.impl;

import cn.itcast.bos.dao.VehicleRepository;
import cn.itcast.bos.domain.base.Vehicle;
import cn.itcast.bos.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author zhangjie
 * @date 2018-03-31 16:37
 */
@Service
@Transactional
public class VehicleServiceImpl implements VehicleService {
	private VehicleRepository vehicleRepository;

	@Override
	@Transactional(readOnly = true)
	public Page<Vehicle> pageQuery(Pageable pageable) {
		return vehicleRepository.findAll(pageable);
	}

	@Override
	public void save(Vehicle vehicle) {
		vehicleRepository.save(vehicle);
	}

	@Override
	public void deleteByIds(String[] arraysIds) {
		if (arraysIds != null && arraysIds.length != 0) {
			for (String id : arraysIds) {
				vehicleRepository.delete(Integer.parseInt(id));
			}
		}
	}

	@Autowired
	public void setVehicleRepository(VehicleRepository vehicleRepository) {
		this.vehicleRepository = vehicleRepository;
	}

}
