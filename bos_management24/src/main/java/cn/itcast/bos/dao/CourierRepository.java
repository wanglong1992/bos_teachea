package cn.itcast.bos.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cn.itcast.bos.domain.base.Courier;

/**
 *  JpaRepository<T, Serializable>
 *  参数一：表示操作的实体类
 *  参数二：表示操作的实体类的主键的类型
 */
public interface CourierRepository extends JpaRepository<Courier, Integer>,JpaSpecificationExecutor<Courier>{

	@Query(value="update Courier set deltag='1' where id = ?")
	@Modifying
	void updateDelType(Integer id);

	List<Courier> findByFixedAreasIsNull();

	/**
	 * HQL语句的联合查询
	 * 案例一：from Courier c inner join c.fixedAreas f where f.id=?
	 *    返回List<Object[]>，存放Object数组，数组的第一个值是Courier，数组的第二个值是FixedArea
	 * 案例二：from Courier c inner join fetch c.fixedAreas f where f.id=?
	 *    返回List<Courier>，使用fetch表示对结果集进行了封装
	 * @return
	 */
	@Query(value="from Courier c inner join fetch c.fixedAreas f where f.id=?")
	List<Courier> findCourierByFixedAreaId(String fixedAreaId);

	
	
	@Query(value="update Courier set deltag = '' where id =?1 ")
	@Modifying
	void updateResTag(Integer id);
	
}
