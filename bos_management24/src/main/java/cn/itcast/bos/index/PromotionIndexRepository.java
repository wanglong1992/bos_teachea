package cn.itcast.bos.index;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import cn.itcast.bos.domain.take_delivery.Promotion;

public interface PromotionIndexRepository extends ElasticsearchRepository<Promotion, Integer>{

}
