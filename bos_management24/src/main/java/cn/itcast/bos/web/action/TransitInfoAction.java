package cn.itcast.bos.web.action;

import java.util.HashMap;
import java.util.Map;

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

import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.transit.TransitInfo;
import cn.itcast.bos.service.TransitInfoService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class TransitInfoAction extends BaseAction<TransitInfo> {

	@Autowired
	private TransitInfoService transitInfoService;
	
	// 属性驱动
	// 运单id，多个值之间使用逗号分开
	private String wayBillIds;
	
	public void setWayBillIds(String wayBillIds) {
		this.wayBillIds = wayBillIds;
	}


	/**开启中转流程*/
	@Action(value="transit_create",results={@Result(name="success",type="json")})
	public String create(){
		Map<String, Object> map = new HashMap<>();
		try {
			transitInfoService.saveCreate(wayBillIds);
			map.put("success", true);
			map.put("msg", "运单保存成功，运单ID是："+wayBillIds);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("success", false);
			map.put("msg", "运单保存失败，失败的运单ID是："+wayBillIds);
		}
		pushValueStack(map);
		return SUCCESS;
	}
	
	// 流程信息的数据表格遍历
	@Action(value="transit_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		// 无条件的分页查询
		Pageable pageable = new PageRequest(page-1, rows);
		Page<TransitInfo> pageData = transitInfoService.findPageQuery(pageable);
		pushValueStack(pageData);
		return SUCCESS;
	}
}
