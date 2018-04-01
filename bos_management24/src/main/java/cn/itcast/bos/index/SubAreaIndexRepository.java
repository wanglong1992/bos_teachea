package cn.itcast.bos.index;

import java.util.List;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import cn.itcast.bos.domain.base.SubArea;

public interface SubAreaIndexRepository extends ElasticsearchRepository<SubArea, String> {

	public List<SubArea> findById(String SubAreaId);
}
