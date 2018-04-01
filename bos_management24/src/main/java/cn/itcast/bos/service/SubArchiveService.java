package cn.itcast.bos.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import cn.itcast.bos.domain.base.SubArchive;

public interface SubArchiveService {

	void save(SubArchive subArchive);

	void delete(Integer id);

	Page<SubArchive> pageQuery(Pageable pageable);

	List<SubArchive> findSubArchiveByArchiveId(String archiveId);

}
