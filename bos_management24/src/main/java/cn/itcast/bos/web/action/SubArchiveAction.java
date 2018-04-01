package cn.itcast.bos.web.action;

import java.util.List;

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
import cn.itcast.bos.domain.base.SubArchive;
import cn.itcast.bos.service.SubArchiveService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class SubArchiveAction extends BaseAction<SubArchive> {

	private static final long serialVersionUID = 1L;
	
	@Autowired
	private SubArchiveService subArchiveService;
	
	@Action(value="subArchive_save",results={@Result(name="success",type="redirect",location="./pages/base/archives.jsp")})
	public String save(){
		subArchiveService.save(model);
		return SUCCESS;
	}
	
	/*@Action(value="subArchive_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		Pageable pageable = new PageRequest(page-1, rows);
		Page<SubArchive> page = subArchiveService.pageQuery(pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}*/
	
	private String ArchiveId;
	public void setArchiveId(String archiveId) {
		ArchiveId = archiveId;
	}
	@Action(value="subArchive_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		List<SubArchive> list = subArchiveService.findSubArchiveByArchiveId(ArchiveId);
		pushValueStack(list);
		return SUCCESS;
	}
	
	private String ids;
	public void setIds(String ids) {
		this.ids = ids;
	}
	@Action(value="subArchive_delete",results={@Result(name="success",type="redirect",location="./pages/base/archives.jsp")})
	public String delete(){
		String[] arrayids = ids.split(",");
		for (String id : arrayids) {
			subArchiveService.delete(Integer.valueOf(id));
		}
		return SUCCESS;
	}
}
