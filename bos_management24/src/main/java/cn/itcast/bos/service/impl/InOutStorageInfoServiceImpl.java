package cn.itcast.bos.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.InOutStorageInfoRepository;
import cn.itcast.bos.dao.TransitInfoRepository;
import cn.itcast.bos.domain.transit.InOutStorageInfo;
import cn.itcast.bos.domain.transit.TransitInfo;
import cn.itcast.bos.service.InOutStorageInfoService;

@Service
@Transactional
public class InOutStorageInfoServiceImpl implements InOutStorageInfoService {

	@Autowired
	private InOutStorageInfoRepository inOutStorageInfoRepository;
	
	@Autowired
	private TransitInfoRepository transitInfoRepository;

	@Override
	public void save(InOutStorageInfo inOutStorageInfo, String transitInfoId) {
		// 1：保存出入库信息
		inOutStorageInfoRepository.save(inOutStorageInfo);
		// 2：建立出入库和流程表的关联关系
		TransitInfo transitInfo = transitInfoRepository.findOne(Integer.parseInt(transitInfoId));
		transitInfo.getInOutStorageInfos().add(inOutStorageInfo);
		// 3：判断是否为到达网点的状态
		if(inOutStorageInfo.getOperation().equals("到达网点")){
			// 此时说明出入库状态要结束，改成到达网点
			// 出入库中转、到达网点、开始配送、正常签收、异常
			transitInfo.setStatus("到达网点");
			transitInfo.setOutletAddress(inOutStorageInfo.getAddress());
		}
	}
}
