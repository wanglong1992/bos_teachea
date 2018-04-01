package cn.itcast.crm.job;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;

import cn.itcast.crm.service.CustomerService;

public class BosJob2 implements Job {

	@Autowired
	CustomerService customerService;
	
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		System.out.println("定时任务2启动");
		//任务1:每天0:0:0清空所有客户的当天签到状态
		customerService.sendMessageAndEmail();
	}

}
