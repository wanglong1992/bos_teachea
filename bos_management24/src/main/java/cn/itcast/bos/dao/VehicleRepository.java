package cn.itcast.bos.dao;

import cn.itcast.bos.domain.base.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

/**
 * @author zhangjie
 * @date 2018-03-31 16:35
 */
public interface VehicleRepository extends JpaRepository<Vehicle,Integer>,JpaSpecificationExecutor<Vehicle> {
}
