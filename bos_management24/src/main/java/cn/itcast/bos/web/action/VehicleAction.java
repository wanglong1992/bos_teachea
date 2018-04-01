package cn.itcast.bos.web.action;

import cn.itcast.bos.domain.base.Vehicle;
import cn.itcast.bos.service.VehicleService;
import cn.itcast.bos.web.action.common.BaseAction;
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

/**
 * @author zhangjie
 * @date 2018-03-31 16:43
 */

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class VehicleAction extends BaseAction<Vehicle> {
	private VehicleService vehicleService;

	private String ids;

	//  分页查询所有的班车信息
	@Action(value = "vehicle_pageQuery", results = {@Result(name = "success", type = "json")})
	public String pageQuery() {
		Pageable pageable = new PageRequest(page - 1, rows);
		Page<Vehicle> vehicles = vehicleService.pageQuery(pageable);
		pushValueStackToPage(vehicles);
		return SUCCESS;
	}

	// 班车信息保存
	@Action(value = "vehicle_save", results = {@Result(name = "success", type = "redirect", location = "pages/base/vehicle.jsp")})
	public String save() {
		vehicleService.save(model);
		return SUCCESS;
	}

	// 班车信息的删除
	@Action(value="vehicle_delete",results={@Result(name="success",type="redirect",location="pages/base/vehicle.jsp")})
	public String delete(){
		String [] arraysIds = ids.split(",");
		vehicleService.deleteByIds(arraysIds);
		return SUCCESS;
	}

	@Autowired
	public void setVehicleService(VehicleService vehicleService) {
		this.vehicleService = vehicleService;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}
}
