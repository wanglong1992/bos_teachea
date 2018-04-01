package cn.itcast.bos.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.TermQueryBuilder;
import org.elasticsearch.index.query.WildcardQueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.core.query.NativeSearchQuery;
import org.springframework.data.elasticsearch.core.query.SearchQuery;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.itcast.bos.dao.PromotionRepository;
import cn.itcast.bos.domain.page.PageBean;
import cn.itcast.bos.domain.take_delivery.Promotion;
import cn.itcast.bos.index.PromotionIndexRepository;
import cn.itcast.bos.service.PromotionService;

@Service
@Transactional
public class PromotionServiceImpl implements PromotionService {

	@Autowired
	private PromotionRepository promotionRepository;
	
	@Autowired
	private PromotionIndexRepository promotionIndexRepository;

	@Override
	public void save(Promotion promotion) {
		promotionRepository.save(promotion);
		promotionIndexRepository.save(promotion);
	}
	
	
	
	@Override
	public PageBean<Promotion> findPageQueryWebservice(int page, int rows) {
		Pageable pageable = new PageRequest(page-1, rows);
		Page<Promotion> pageData = promotionRepository.findAll(pageable);
		// 组织到PageBean的对象中
		PageBean<Promotion> pageBean = new PageBean<>();
		pageBean.setTotalElements(pageData.getTotalElements());
		pageBean.setContent(pageData.getContent());
		return pageBean;
	}
	
	// 在数据库查询所有的数据，同步更新索引库（定时任务），保证数据的准确
	@Override
	public void sysIndexRepository() {
		List<Promotion> list = promotionRepository.findAll();
		promotionIndexRepository.save(list);
	}
	
	@Override
	public Promotion findById(Integer id) {
		return promotionRepository.findOne(id);
	}
	
	@Override
	public void updateStatus(Date date) {
		promotionRepository.updateStatus(date);
	}

	@Override
	public void zuofeiByIds(String[] arraysIds) {
		if(arraysIds!=null && arraysIds.length>0){
			for(int i=0;i<arraysIds.length;i++){
				Integer id = Integer.parseInt(arraysIds[i]);
				promotionRepository.zuofeiByIds(id);
			}
		}
		sysIndexRepository();
	}


	@Override
	public Page<Promotion> findPageQuery(Promotion promotion, Pageable pageable) {
		if(StringUtils.isBlank(promotion.getTitle())
				&& StringUtils.isBlank(promotion.getStatus())
				&& (promotion.getStartDate() == null)
				&& (promotion.getEndDate() == null)){
			return promotionRepository.findAll(pageable); 
		}
		else {
			BoolQueryBuilder query = new BoolQueryBuilder();
			//向组合条件对象添加条件
			if(StringUtils.isNotBlank(promotion.getTitle())){
				QueryBuilder wildcardQuery = new WildcardQueryBuilder("title", "*"+promotion.getTitle()+"*");
				query.must(wildcardQuery);
			}
			if(StringUtils.isNotBlank(promotion.getStatus())){
				QueryBuilder termQuery = new TermQueryBuilder("status",promotion.getStatus());
				query.must(termQuery);
			}
			if(promotion.getStartDate() != null){
				QueryBuilder termQuery = new TermQueryBuilder("startDate", promotion.getStartDate().getTime());
				query.must(termQuery);
			}
			if(promotion.getEndDate() != null){
				QueryBuilder termQuery = new TermQueryBuilder("endDate",promotion.getEndDate().getTime());
				query.must(termQuery);
			}
			SearchQuery searchQuery = new NativeSearchQuery(query);
            searchQuery.setPageable(pageable); // 分页效果
			return promotionIndexRepository.search(searchQuery);
			
		}
	}
}
