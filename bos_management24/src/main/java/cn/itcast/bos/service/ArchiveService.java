package cn.itcast.bos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import cn.itcast.bos.domain.base.Archive;

public interface ArchiveService {

	void save(Archive archive);

	Page<Archive> findPageQuery(Pageable pageable);

	void delete(Integer id);

}
