package cn.itcast.bos.service.impl;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.TransitInfoRepository;
import cn.itcast.bos.dao.WayBillRepository;
import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.domain.transit.TransitInfo;
import cn.itcast.bos.index.WayBillIndexRepository;
import cn.itcast.bos.service.TransitInfoService;

@Service
@Transactional
public class TransitInfoServiceImpl implements TransitInfoService {

	@Autowired
	private TransitInfoRepository transitInfoRepository;
	
	@Autowired
	private WayBillRepository wayBillRepository;
	
	@Autowired
	private WayBillIndexRepository wayBillIndexRepository;

	@Override
	public void saveCreate(String wayBillIds) {
		if(StringUtils.isNotBlank(wayBillIds)){
			String[] arrayWayBillIds = wayBillIds.split(",");
			for(String wayBillId:arrayWayBillIds){
				// 使用运单id查询运单
				WayBill wayBill = wayBillRepository.findOne(Integer.parseInt(wayBillId));
				// 保证只有事待发货的状态，才能新增流程
				if(wayBill.getSignStatus()==1){
					// 一：往流程表transitInfo新增一条数据
					TransitInfo transitInfo = new TransitInfo();
					// 建立运单和流程的关联关系
					transitInfo.setWayBill(wayBill);
					// 出入库中转、到达网点、开始配送、正常签收、异常
					transitInfo.setStatus("出入库中转");
					transitInfoRepository.save(transitInfo);
					// 二：更新运单的状态码：从1变成2
					/**
					 * 运单状态： 1 待发货、 2 派送中、3 已签收、4 异常
					 */
					wayBill.setSignStatus(2);
					// 三：只要数据库发生变化，索引库跟着发生变化
					wayBillIndexRepository.save(wayBill);
				}
			}
		}
		
	}
	
	@Override
	public Page<TransitInfo> findPageQuery(Pageable pageable) {
		return transitInfoRepository.findAll(pageable);
	}
}
