package cn.itcast.bos.test;

import org.junit.Test;

import redis.clients.jedis.Jedis;

public class TestRedis {

	// 没有设置存活时间
	@Test
	public void setValue(){
		Jedis jedis = new Jedis("localhost");
		jedis.set("city", "上海");
		System.out.println(jedis.get("city"));
	}
	
	// 设置存活时间
	@Test
	public void setValueTime(){
		Jedis jedis = new Jedis("localhost");
		jedis.setex("province", 15, "江苏省");
		System.out.println(jedis.get("province"));
	}
}
