package cn.itcast.bos.web.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import cn.itcast.bos.domain.base.Archive;
import cn.itcast.bos.service.ArchiveService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class ArchiveAction extends BaseAction<Archive> {

	private static final long serialVersionUID = 1L;
	
	@Autowired
	private ArchiveService archiveService;
	
	@Action(value="archive_save",results={@Result(name="success",type="redirect",location="./pages/base/archives.jsp")})
	public String save(){
		archiveService.save(model);
		return SUCCESS;
	}
	
	@Action(value="archive_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		Pageable pageable = new PageRequest(page-1, rows);
		Page<Archive> page = archiveService.findPageQuery(pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}
	
	private String ids;
	public void setIds(String ids) {
		this.ids = ids;
	}
	@Action(value="archive_delete",results={@Result(name="success",type="redirect",location="./pages/base/archives.jsp")})
	public String delete(){
		String[] arrayids = ids.split(",");
		for (String id : arrayids) {
			archiveService.delete(Integer.valueOf(id));
		}
		return SUCCESS;
	}
}
