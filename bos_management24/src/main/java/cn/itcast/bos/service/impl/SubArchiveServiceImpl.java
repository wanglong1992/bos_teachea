package cn.itcast.bos.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import cn.itcast.bos.dao.SubArchiveRepository;
import cn.itcast.bos.domain.base.SubArchive;
import cn.itcast.bos.service.SubArchiveService;

@Service
public class SubArchiveServiceImpl implements SubArchiveService {

	@Autowired
	private SubArchiveRepository subArchiveRepository;
	
	@Override
	public void save(SubArchive subArchive) {
		subArchiveRepository.save(subArchive);
	}

	@Override
	public void delete(Integer id) {
		subArchiveRepository.delete(id);
	}

	@Override
	public Page<SubArchive> pageQuery(Pageable pageable) {
		return subArchiveRepository.findAll(pageable);
	}

	@Override
	public List<SubArchive> findSubArchiveByArchiveId(String archiveId) {
		return subArchiveRepository.findSubArchiveByArchiveId(Integer.valueOf(archiveId));
	}
	

}
