package cn.itcast.bos.service.impl;

import cn.itcast.bos.dao.TakeTimeRepository;
import cn.itcast.bos.domain.base.TakeTime;
import cn.itcast.bos.service.TakeTimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class TakeTimeServiceImpl implements TakeTimeService {

	@Autowired
	private TakeTimeRepository takeTimeRepository;

	@Override
	@Transactional(readOnly = true)
	public List<TakeTime> findAll() {
		return takeTimeRepository.findAll();
	}

	@Override
	@Transactional(readOnly = true)
	public Page<TakeTime> pageQuery(Pageable pageable) {
		return takeTimeRepository.findAll(pageable);
	}

	@Override
	@Transactional(readOnly = true)
	public List<TakeTime> findByName(String name) {
		return takeTimeRepository.findTakeTimesByName(name);
	}

	@Override
	public void save(TakeTime takeTime) {
		takeTimeRepository.save(takeTime);
	}

	@Override
	public void deleteByIds(String[] arraysIds) {
		if (arraysIds != null && arraysIds.length != 0) {
			for (String id : arraysIds) {
				takeTimeRepository.delete(Integer.parseInt(id));
			}
		}
	}

}
