package cn.itcast.crm.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import cn.itcast.crm.domain.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Integer>,JpaSpecificationExecutor<Customer> {

	
	// == fixedAreaId is null
	List<Customer> findByFixedAreaIdIsNull();

	// == fixedAreaId = ?
	List<Customer> findByFixedAreaId(String fixedAreaId);

	@Query(value="update Customer set fixedAreaId=null where fixedAreaId=?")
	@Modifying
	void updateFixedAreaIdByFixedAreaId(String fixedAreaId);

	@Query(value="update Customer set fixedAreaId=?1 where id=?2")
	@Modifying
	void updateFixedAreaIdByIds(String fixedAreaId, Integer id);

	Customer findByTelephone(String telephone);

	@Query(value="update Customer set type = 1 where telephone = ?")
	@Modifying
	void updateType(String telephone);

	Customer findByTelephoneAndPassword(String telephone, String password);

	@Query(value="select fixedAreaId from Customer where id = ? and address = ?")
	String findFixedAreaIdByIdAndAddress(Integer id, String address);

	Customer findById(Integer id);

	//清空所有签到状态
	@Query("update Customer  set hasSignInToday = 0 ")
	@Modifying
	void clearSignInStatus();
	
	@Query("from Customer WHERE to_char(birthday,'MM-DD')=?")
	List<Customer> findCurrentBirthday(String currentDate);


}
