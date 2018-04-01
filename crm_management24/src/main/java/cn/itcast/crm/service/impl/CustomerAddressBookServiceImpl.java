package cn.itcast.crm.service.impl;

import cn.itcast.crm.dao.CustomerAddressBookRepository;
import cn.itcast.crm.dao.CustomerRepository;
import cn.itcast.crm.domain.CustomerAddressBook;
import cn.itcast.crm.service.CustomerAddressBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CustomerAddressBookServiceImpl implements CustomerAddressBookService {
    @Autowired
    private CustomerRepository customerRepository;
    @Autowired
    private CustomerAddressBookRepository addressBookRepository;

    @Override
    public List<CustomerAddressBook> findByUserId(Integer id) {
        //TODO
        return null;
    }

    @Override
    public void save(CustomerAddressBook customerAddressBook) {
        //TODO
    }
}
