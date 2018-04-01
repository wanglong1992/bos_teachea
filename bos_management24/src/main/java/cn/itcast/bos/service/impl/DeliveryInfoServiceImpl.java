package cn.itcast.bos.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.DeliveryInfoRepository;
import cn.itcast.bos.dao.TransitInfoRepository;
import cn.itcast.bos.domain.transit.DeliveryInfo;
import cn.itcast.bos.domain.transit.TransitInfo;
import cn.itcast.bos.service.DeliveryInfoService;

@Service
@Transactional
public class DeliveryInfoServiceImpl implements DeliveryInfoService {

	@Autowired
	private DeliveryInfoRepository deliveryInfoRepository;
	
	@Autowired
	private TransitInfoRepository transitInfoRepository;

	@Override
	public void save(DeliveryInfo deliveryInfo, String transitInfoId) {
		// 1：保存开始配送信息
		deliveryInfoRepository.save(deliveryInfo);
		// 2：建立开始配送和流程表的关联关系
		TransitInfo transitInfo = transitInfoRepository.findOne(Integer.parseInt(transitInfoId));
		transitInfo.setDeliveryInfo(deliveryInfo);
		// 3：更新状态
		// 出入库中转、到达网点、开始配送、正常签收、异常
		transitInfo.setStatus("开始配送");
	}
}
