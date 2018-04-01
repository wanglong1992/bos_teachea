package cn.itcast.bos.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import cn.itcast.bos.domain.base.Archive;

public interface ArchiveRepository extends JpaRepository<Archive, Integer>,JpaSpecificationExecutor<Archive>{

}
