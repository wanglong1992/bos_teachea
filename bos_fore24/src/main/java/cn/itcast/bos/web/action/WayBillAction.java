package cn.itcast.bos.web.action;

import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;

import antlr.collections.List;
import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.domain.take_delivery.Promotion;
import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class WayBillAction extends BaseAction<WayBill> {

	// 日志
	Logger logger = LoggerFactory.getLogger(WayBillAction.class);


	private String ids;

	
	public void setIds(String ids) {
		this.ids = ids;
	}



	// 使用运单号，查询运单
	@Action(value="waybill_findById",results={@Result(name="success",type="json")})
	public String findByWayBillNum(){
		Map<String, Object> map = new HashMap<>();
		Collection<? extends WayBill> wayBills = WebClient.create(Constants.BOS_MANAGEMENT_URL+"/services/wayBillService/findByIds/"+ids)
				.type(MediaType.APPLICATION_JSON)
				.accept(MediaType.APPLICATION_JSON)
				.getCollection(WayBill.class);
		// 没有查询到结果
		if(wayBills==null){
			map.put("success", false);
		}
		// 查询到结果
		else{
			map.put("success", true);
			map.put("wayBillsData", wayBills);
		}
		pushValueStack(map);
		return SUCCESS;
	}
}