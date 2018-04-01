package cn.itcast.bos.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import cn.itcast.bos.dao.ArchiveRepository;
import cn.itcast.bos.dao.SubArchiveRepository;
import cn.itcast.bos.domain.base.Archive;
import cn.itcast.bos.domain.base.SubArchive;
import cn.itcast.bos.service.ArchiveService;

@Service
public class ArchiveServiceImpl implements ArchiveService {

	@Autowired
	ArchiveRepository archiveRepository;
	
	@Autowired
	SubArchiveRepository subArchiveRepository;
	
	@Override
	public void save(Archive archive) {
		//判断修改后是否为不分级
		if (archive.getHasChild() != 1 && archive.getId() != null ) {
			List<SubArchive> list = subArchiveRepository.findSubArchiveByArchiveId(archive.getId());
			if (list != null) {
				for (SubArchive subArchive : list) {
					subArchiveRepository.delete(subArchive.getId());
				}
			}
		} 
			archiveRepository.save(archive);
	}
	@Override
	public Page<Archive> findPageQuery(Pageable pageable) {
		return archiveRepository.findAll(pageable);
	}
	@Override
	public void delete(Integer id) {
		List<SubArchive> list = subArchiveRepository.findSubArchiveByArchiveId(id);
		if (list != null) {
			for (SubArchive subArchive : list) {
				subArchiveRepository.delete(subArchive.getId());
			}
		}
		archiveRepository.delete(id);
	}
	

}
