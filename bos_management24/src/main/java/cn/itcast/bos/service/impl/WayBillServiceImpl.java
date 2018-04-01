package cn.itcast.bos.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryStringQueryBuilder;
import org.elasticsearch.index.query.QueryStringQueryBuilder.Operator;
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

import cn.itcast.bos.dao.WayBillRepository;
import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.index.WayBillIndexRepository;
import cn.itcast.bos.service.WayBillService;

@Service
@Transactional
public class WayBillServiceImpl implements WayBillService {

	@Autowired
	private WayBillRepository wayBillRepository;

	@Autowired
	private WayBillIndexRepository wayBillIndexRepository;

	@Override
	public void save(WayBill wayBill) {
		// 如果运单已经开始配送，此时不允许修改运单
		// 修改功能
		if (wayBill != null && wayBill.getId() != null) {
			// 使用运单号查询
			WayBill persisitWayBill = wayBillRepository.findOne(wayBill.getId());
			if (persisitWayBill.getSignStatus() != 1) {
				System.out.println("该运单号是：" + wayBill.getWayBillNum() + "已经开始配送，此时不允许修改");
				throw new RuntimeException("该运单号是：" + wayBill.getWayBillNum() + "已经开始配送，此时不允许修改");
			} else {
				/*
				 * 运单状态： 1 待发货、 2 派送中、3 已签收、4 异常
				 */
				wayBill.setSignStatus(1);
				wayBillRepository.save(wayBill);
				// 同时更新索引库
				wayBillIndexRepository.save(wayBill);
			}
		}

	}

	@Override
	public Page<WayBill> findPageQuery(Pageable pageable) {
		return wayBillRepository.findAll(pageable);
	}

	@Override
	public WayBill findByWayBillNum(String wayBillNum) {
		return wayBillRepository.findByWayBillNum(wayBillNum);
	}

	// 在数据库查询所有的数据，同步更新索引库（定时任务），保证数据的准确
	@Override
	public void sysIndexRepository() {
		List<WayBill> list = wayBillRepository.findAll();
		wayBillIndexRepository.save(list);
	}

	@Override
	public Page<WayBill> findPageQuery(Pageable pageable, WayBill wayBill) {
		// 如果查询条件为空，即查询所有的数据，此时查询数据库
		if (StringUtils.isBlank(wayBill.getWayBillNum()) && StringUtils.isBlank(wayBill.getSendAddress())
				&& StringUtils.isBlank(wayBill.getRecAddress()) && StringUtils.isBlank(wayBill.getSendProNum())
				&& (wayBill.getSignStatus() == null || wayBill.getSignStatus() == 0)) {
			return wayBillRepository.findAll(pageable);
		}
		// 如果存在查询条件，查询索引库
		else {
			BoolQueryBuilder query = new BoolQueryBuilder();
			// 运单号
			if (StringUtils.isNotBlank(wayBill.getWayBillNum())) {
				QueryBuilder queryBuilder = new TermQueryBuilder("wayBillNum", wayBill.getWayBillNum());
				query.must(queryBuilder);
			}
			// 寄件人地址
			if (StringUtils.isNotBlank(wayBill.getSendAddress())) {
				// 通配符，词条的模糊
				QueryBuilder queryBuilder1 = new WildcardQueryBuilder("sendAddress",
						"*" + wayBill.getSendAddress() + "*");
				// 先分词，再检索
				QueryBuilder queryBuilder2 = new QueryStringQueryBuilder(wayBill.getSendAddress()).field("sendAddress")
						.defaultOperator(Operator.AND); // AND表示将查询的结果合并（交集）
				BoolQueryBuilder queryBuilder = new BoolQueryBuilder();
				queryBuilder.should(queryBuilder1).should(queryBuilder2);
				query.must(queryBuilder);
			}
			// 收件人地址
			if (StringUtils.isNotBlank(wayBill.getRecAddress())) {
				QueryBuilder queryBuilder1 = new WildcardQueryBuilder("recAddress",
						"*" + wayBill.getRecAddress() + "*");
				// 先分词，再检索
				QueryBuilder queryBuilder2 = new QueryStringQueryBuilder(wayBill.getRecAddress()).field("recAddress")
						.defaultOperator(Operator.AND); // AND表示将查询的结果合并（交集）
				BoolQueryBuilder queryBuilder = new BoolQueryBuilder();
				queryBuilder.should(queryBuilder1).should(queryBuilder2);
				query.must(queryBuilder);
			}
			// 产品类型
			if (StringUtils.isNotBlank(wayBill.getSendProNum())) {
				QueryBuilder queryBuilder = new TermQueryBuilder("sendProNum", wayBill.getSendProNum());
				query.must(queryBuilder);
			}
			// 签收状态
			if (wayBill.getSignStatus() != null && wayBill.getSignStatus() > 0) {
				QueryBuilder queryBuilder = new TermQueryBuilder("signStatus", wayBill.getSignStatus());
				query.must(queryBuilder);
			}
			SearchQuery searchQuery = new NativeSearchQuery(query);
			searchQuery.setPageable(pageable);
			return wayBillIndexRepository.search(searchQuery);
		}

	}

	@Override
	public List<WayBill> findWayBills(WayBill wayBill) {
		// 如果查询条件为空，即查询所有的数据，此时查询数据库
		if (StringUtils.isBlank(wayBill.getWayBillNum()) && StringUtils.isBlank(wayBill.getSendAddress())
				&& StringUtils.isBlank(wayBill.getRecAddress()) && StringUtils.isBlank(wayBill.getSendProNum())
				&& (wayBill.getSignStatus() == null || wayBill.getSignStatus() == 0)) {
			return wayBillRepository.findAll();
		}
		// 如果存在查询条件，查询索引库
		else {
			BoolQueryBuilder query = new BoolQueryBuilder();
			// 运单号
			if (StringUtils.isNotBlank(wayBill.getWayBillNum())) {
				QueryBuilder queryBuilder = new TermQueryBuilder("wayBillNum", wayBill.getWayBillNum());
				query.must(queryBuilder);
			}
			// 寄件人地址
			if (StringUtils.isNotBlank(wayBill.getSendAddress())) {
				// 通配符，词条的模糊
				QueryBuilder queryBuilder1 = new WildcardQueryBuilder("sendAddress",
						"*" + wayBill.getSendAddress() + "*");
				// 先分词，再检索
				QueryBuilder queryBuilder2 = new QueryStringQueryBuilder(wayBill.getSendAddress()).field("sendAddress")
						.defaultOperator(Operator.AND); // AND表示将查询的结果合并（交集）
				BoolQueryBuilder queryBuilder = new BoolQueryBuilder();
				queryBuilder.should(queryBuilder1).should(queryBuilder2);
				query.must(queryBuilder);
			}
			// 收件人地址
			if (StringUtils.isNotBlank(wayBill.getRecAddress())) {
				QueryBuilder queryBuilder1 = new WildcardQueryBuilder("recAddress",
						"*" + wayBill.getRecAddress() + "*");
				// 先分词，再检索
				QueryBuilder queryBuilder2 = new QueryStringQueryBuilder(wayBill.getRecAddress()).field("recAddress")
						.defaultOperator(Operator.AND); // AND表示将查询的结果合并（交集）
				BoolQueryBuilder queryBuilder = new BoolQueryBuilder();
				queryBuilder.should(queryBuilder1).should(queryBuilder2);
				query.must(queryBuilder);
			}
			// 产品类型
			if (StringUtils.isNotBlank(wayBill.getSendProNum())) {
				QueryBuilder queryBuilder = new TermQueryBuilder("sendProNum", wayBill.getSendProNum());
				query.must(queryBuilder);
			}
			// 签收状态
			if (wayBill.getSignStatus() != null && wayBill.getSignStatus() > 0) {
				QueryBuilder queryBuilder = new TermQueryBuilder("signStatus", wayBill.getSignStatus());
				query.must(queryBuilder);
			}
			SearchQuery searchQuery = new NativeSearchQuery(query);
			return wayBillIndexRepository.search(searchQuery).getContent();
		}
	}

	@Override
	public List<Object[]> exportHighcharts() {
		return wayBillRepository.exportHighcharts();
	}

	@Override
	public void saveWayBills(List<WayBill> wayBills) {
		wayBillRepository.save(wayBills);

	}
    @Override
    public List<String> searchNum(WayBill wayBill) {
		Page<WayBill> wayBillPage = wayBillRepository.findByWayBillNumLike("%"+wayBill.getWayBillNum()+"%", new PageRequest(0,10));
        List<WayBill> wayBillList = wayBillPage.getContent();
        List<String> numList = new ArrayList<>();
		for (WayBill bill : wayBillList) {
			numList.add(bill.getWayBillNum());
		}
		return numList;
    }
}
