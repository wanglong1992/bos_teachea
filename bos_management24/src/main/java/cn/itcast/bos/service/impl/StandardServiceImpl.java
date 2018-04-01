package cn.itcast.bos.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.StandardRepository;
import cn.itcast.bos.domain.base.Standard;
import cn.itcast.bos.service.StandardService;

@Service
@Transactional
public class StandardServiceImpl implements StandardService{

	@Autowired
	StandardRepository standardRepository;
	
	@Override
	@CacheEvict(cacheNames="standard",allEntries=true) //清除缓存区数据 --- 用于 增加、修改、删除 方法 ；allEntries=true：表示清除缓存数据，allEntries=false:表示不清除缓存数据
	public void save(Standard standard) {
		standardRepository.save(standard);
	}
	
	@Override
	public List<Standard> findByName(String name) {
		return standardRepository.findByName(name);
	}
	
	@Override
	@Cacheable(cacheNames="standard",key="#pageable.pageNumber+'_'+#pageable.pageSize") // 第一页：key:0_3；第二页：key:1_3
	public Page<Standard> findPageQuery(Pageable pageable) {
		return standardRepository.findAll(pageable);
	}
	
	@Override
	public void deleteByIds(String[] arraysIds) {
		if(arraysIds!=null && arraysIds.length>0){
			for(int i=0;i<arraysIds.length;i++){
				Integer id = Integer.parseInt(arraysIds[i]);
				standardRepository.delete(id);
			}
		}
	}
	
	@Override
	@Cacheable(cacheNames="standard") // 如果缓存中存在收派标准集合的数据，读取缓存，不会执行findAll()
	public List<Standard> findAll() {
		return standardRepository.findAll();
	}
}
