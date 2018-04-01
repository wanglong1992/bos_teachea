package cn.itcast.crm.dao;

import cn.itcast.crm.domain.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface CustomerAddressBookRepository extends JpaRepository<Customer, Integer>,JpaSpecificationExecutor<Customer> {
}
