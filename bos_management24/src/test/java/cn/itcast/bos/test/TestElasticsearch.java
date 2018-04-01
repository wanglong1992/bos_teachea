package cn.itcast.bos.test;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.service.WayBillService;

@RunWith(value=SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="classpath:applicationContext.xml")
public class TestElasticsearch {
	
	
	@Autowired
	ElasticsearchTemplate elasticsearchTemplate;
	
	@Autowired
	WayBillService wayBillService;
	
	// 使用ElasticsearchTemplate，先去创建索引和映射
	@Test
	public void createIndexAndMapping(){
		elasticsearchTemplate.createIndex(WayBill.class);
		elasticsearchTemplate.putMapping(WayBill.class);
	}
	
	// 测试同步更新索引库
	@Test
	public void testIndex(){
		wayBillService.sysIndexRepository();
	}

}
