package cn.itcast.bos.test;

import java.util.concurrent.TimeUnit;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(value=SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations="classpath:applicationContext.xml")
public class TestSpringDataRedis {

	@Autowired
	RedisTemplate<String, String> redisTemplate;
	
	// 没有设置存活时间
	@Test
	public void setValue(){
		redisTemplate.opsForValue().set("name", "黑马程序员");
		System.out.println(redisTemplate.opsForValue().get("name"));
	}
	
	// 设置存活时间
	@Test
	public void setValueTime(){
		redisTemplate.opsForValue().set("name", "黑马程序员",10,TimeUnit.SECONDS);
		System.out.println(redisTemplate.opsForValue().get("name"));
	}
}
