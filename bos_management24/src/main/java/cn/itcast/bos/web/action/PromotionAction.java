package cn.itcast.bos.web.action;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.take_delivery.Promotion;
import cn.itcast.bos.service.PromotionService;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class PromotionAction extends BaseAction<Promotion> {

	// 上传的文件
	private File titleImgFile;
	// 上传的文件名
	private String titleImgFileFileName;
	
	public void setTitleImgFile(File titleImgFile) {
		this.titleImgFile = titleImgFile;
	}

	public void setTitleImgFileFileName(String titleImgFileFileName) {
		this.titleImgFileFileName = titleImgFileFileName;
	}

	@Autowired
	private PromotionService promotionService;
	
	// 保存
	@Action(value="promotion_save",results={@Result(name="success",type="redirect",location="./pages/take_delivery/promotion.jsp")})
	public String save() throws Exception{
		//文件保存目录路径（绝对路径：上传）
		String savePath = ServletActionContext.getServletContext().getRealPath("/") + "upload/";

		//文件保存目录URL（相对路径：存储/页面）
		String saveUrl  = ServletActionContext.getRequest().getContextPath() + "/upload/";
		
		// 生成文件名
		String filename = UUID.randomUUID().toString();
		// 后缀
		String ext = titleImgFileFileName.substring(titleImgFileFileName.lastIndexOf("."));
		// 文件名
		String newFileName = filename+ext;
		
		// 上传
		File destFile = new File(savePath+"/"+newFileName);
		FileUtils.copyFile(titleImgFile, destFile);
		// 相对路径
		model.setTitleImg(saveUrl+newFileName);
		promotionService.save(model);
		return SUCCESS;
	}
	
	// 宣传活动的数据表格遍历
	@Action(value="promotion_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery(){
		// 无条件的分页查询
		Pageable pageable = new PageRequest(page-1, rows, new Sort(
				new Sort.Order(Sort.Direction.DESC, "id")));//按照ID字段降序排列
		Page<Promotion> page = promotionService.findPageQuery(model,pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}
	
	// 传递的id字符串，中间使用逗号分开
	private String ids;
	
	public void setIds(String ids) {
		this.ids = ids;
	}

	// 宣传任务的作废
	@Action(value="promotion_zuofei",results={@Result(name="success",type="redirect",location="pages/take_delivery/promotion.jsp")})
	public String delete(){
		String [] arraysIds = ids.split(",");
		promotionService.zuofeiByIds(arraysIds);
		return SUCCESS;
	}
	
	// 宣传任务的修改
	@Action(value="promotion_update",results={@Result(name="success",type="redirect",location="pages/take_delivery/promotion.jsp")})
	public String update(){
		Promotion promotion = promotionService.findById(model.getId());
		model.setTitleImg(promotion.getTitleImg());
		promotionService.save(model);
		return SUCCESS;
	}
	
}
