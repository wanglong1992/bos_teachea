package cn.itcast.bos.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;

import cn.itcast.bos.domain.base.Standard;

/**
 *  JpaRepository<T, Serializable>
 *  参数一：表示操作的实体类
 *  参数二：表示操作的实体类的主键的类型
 */
public interface StandardRepository extends JpaRepository<Standard, Integer>{
	// 使用收派标准名称查询数据库，spring data jpa的时候，命名规范find + By + 属性名称 == from Standard where name = ?
	// 响应的结果List，都是存在对象，如果没有查询到结果，list集合的长度为0；如果查询到结果list集合的长度大于0
	List<Standard> findByName(String name);
	
	// 模糊查询
	List<Standard> findByNameLike(String name);
	
	// 按照名称查询，使用@Query的时候，默认采用HQL语句
	// nativeQuery=true：表示sql语句，默认值是false
	@Query(value="from Standard where name = ?")
	List<Standard> queryName(String name);
	
	// 使用命名查询的方式，优势在于不将HQL语句或者SQL语句写到持久层，统一将语句写到实体上
	@Query
	List<Standard> queryName2(String name);

	@Query(value="update Standard set maxWeight = ?2 where id = ?1")
	@Modifying
	void updateMaxWeight(Integer id, Integer maxWeight);
	
}
