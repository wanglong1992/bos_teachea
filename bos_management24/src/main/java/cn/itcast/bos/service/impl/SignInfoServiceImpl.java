package cn.itcast.bos.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.SignInfoRepository;
import cn.itcast.bos.dao.TransitInfoRepository;
import cn.itcast.bos.domain.transit.SignInfo;
import cn.itcast.bos.domain.transit.TransitInfo;
import cn.itcast.bos.index.WayBillIndexRepository;
import cn.itcast.bos.service.SignInfoService;

@Service
@Transactional
public class SignInfoServiceImpl implements SignInfoService {

	@Autowired
	private SignInfoRepository signInfoRepository;
	
	@Autowired
	private TransitInfoRepository transitInfoRepository;
	
	@Autowired
	private WayBillIndexRepository wayBillIndexRepository;

	@Override
	public void save(SignInfo signInfo, String transitInfoId) {
		// 1：保存签收录入信息
		signInfoRepository.save(signInfo);
		// 2：建立签收录入和流程表的关联关系
		TransitInfo transitInfo = transitInfoRepository.findOne(Integer.parseInt(transitInfoId));
		transitInfo.setSignInfo(signInfo);
		// 3：更新状态
		// 出入库中转、到达网点、开始配送、正常签收、异常
		if(signInfo.getSignType().equals("正常")){
			transitInfo.setStatus("正常签收");
			// 4：更新运单的状态码：从2变成3
			/**
			 * 运单状态： 1 待发货、 2 派送中、3 已签收、4 异常
			 */
			transitInfo.getWayBill().setSignStatus(3);
			// 5：只要数据库发生变化，索引库跟着发生变化
			wayBillIndexRepository.save(transitInfo.getWayBill());
		}
		else{
			transitInfo.setStatus("异常");
			// 4：更新运单的状态码：从2变成4
			transitInfo.getWayBill().setSignStatus(4);
			// 5：只要数据库发生变化，索引库跟着发生变化
			wayBillIndexRepository.save(transitInfo.getWayBill());
		}
	}
}
