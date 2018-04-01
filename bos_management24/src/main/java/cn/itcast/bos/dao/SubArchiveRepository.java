package cn.itcast.bos.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import cn.itcast.bos.domain.base.SubArchive;

public interface SubArchiveRepository extends JpaRepository<SubArchive, Integer>,JpaSpecificationExecutor<SubArchive>{

	@Query("from SubArchive s inner join fetch s.archive a where a.id = ?")
	List<SubArchive> findSubArchiveByArchiveId(Integer archiveId);
	
}
