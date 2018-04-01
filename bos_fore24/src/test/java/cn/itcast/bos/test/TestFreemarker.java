package cn.itcast.bos.test;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import freemarker.template.Configuration;
import freemarker.template.Template;
import redis.clients.jedis.Jedis;

public class TestFreemarker {

	// 生成html
	@Test
	public void testFreemarker() throws Exception{
		// 创建对象
		Configuration configuration = new Configuration(Configuration.VERSION_2_3_22);
		// 查找模板路径
		configuration.setDirectoryForTemplateLoading(new File("D:\\workspace\\workspaceBos2.2\\workspace0303\\bos_fore24\\src\\main\\webapp\\WEB-INF\\template"));
		// 获取模板文件
		Template template = configuration.getTemplate("hello.ftl");
		
		// 指定参数
		Map<String, Object> dataModel = new HashMap<>();
		dataModel.put("title", "黑马程序员");
		dataModel.put("msg", "这是第一个Freemarker的案例！");
		// 使用模板文件输出文件内容（在控制台输出）
		template.process(dataModel, new PrintWriter(System.out));
		
	}
	
}
