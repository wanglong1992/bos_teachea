package cn.itcast.bos.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import cn.itcast.bos.domain.take_delivery.WayBill;

public interface WayBillService {

	void save(WayBill wayBill);

	Page<WayBill> findPageQuery(Pageable pageable);

	WayBill findByWayBillNum(String wayBillNum);

	void sysIndexRepository();

	Page<WayBill> findPageQuery(Pageable pageable, WayBill wayBill);

	List<WayBill> findWayBills(WayBill wayBill);

	List<Object[]> exportHighcharts();

	void saveWayBills(List<WayBill> wayBills);

	List<String> searchNum(WayBill wayBill);
}
