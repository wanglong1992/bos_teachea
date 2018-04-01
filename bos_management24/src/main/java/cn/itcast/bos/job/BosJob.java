package cn.itcast.bos.job;

import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;

import cn.itcast.bos.service.PromotionService;
import cn.itcast.bos.service.WayBillService;

public class BosJob implements Job {

	@Autowired
	PromotionService promotionService;
	
	@Autowired
	WayBillService wayBillService;
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		// 任务一：从现在开始执行，每一个小时执行一次，更新宣传活动的状态，判断该状态是否已经过期。
		promotionService.updateStatus(new Date());
		// 任务二：每24小时，让数据库的数据与索引库的数据同步
		wayBillService.sysIndexRepository();
		promotionService.sysIndexRepository();
	}

}
