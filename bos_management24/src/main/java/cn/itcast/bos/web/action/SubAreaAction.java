package cn.itcast.bos.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.servlet.ServletOutputStream;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.struts2.ServletActionContext;
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
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.base.FixedArea;
import cn.itcast.bos.domain.base.SubArea;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.SubAreaService;
import cn.itcast.bos.utils.FileUtils;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class SubAreaAction extends BaseAction<SubArea> {
	
	// 接收上传文件
	private File file;

	public void setFile(File file) {
		this.file = file;
	}
	
	@Autowired
	private SubAreaService subAreaService;
	
	// 属性驱动，接收删除的区域ids
	private String ids;

	public void setIds(String ids) {
		this.ids = ids;
	}
	
	// 日志
	Logger logger = LoggerFactory.getLogger(SubArea.class);

	// 批量区域数据导入
	@Action(value = "subArea_importSubArea")
	public String importSubArea() throws IOException {
		List<SubArea> subAreas = new ArrayList<SubArea>();
		// 编写解析代码逻辑
		// 基于.xls 格式解析 HSSF
		// 1、 加载Excel文件对象
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(new FileInputStream(file));
		// 2、 读取一个sheet
		HSSFSheet sheet = hssfWorkbook.getSheetAt(0);//获取第一个sheet对象
		// 3、 读取sheet中每一行，一行数据 对应 一个区域对象
		for (Row row : sheet) {
			// 第一行表头跳过
			if (row.getRowNum() == 0) {
				// 第一行 跳过
				continue;
			}
			// 跳过空值的行，要求此行作废
			if (row.getCell(0) == null
					|| StringUtils.isBlank(row.getCell(0).getStringCellValue())) {
				continue;
			}
			SubArea subArea = new SubArea();
			subArea.setId(row.getCell(0).getStringCellValue());//区域编号
			
			FixedArea fixedArea = new FixedArea();
			fixedArea.setId(row.getCell(1).getStringCellValue());
			subArea.setFixedArea(fixedArea);//定区编码
			
			Area area = new Area();
			area.setId(row.getCell(2).getStringCellValue());
			subArea.setArea(area);//区域编码
			
			subArea.setKeyWords(row.getCell(3).getStringCellValue());// 关键字
			subArea.setStartNum(row.getCell(4).getStringCellValue());// 初始化
			subArea.setEndNum(row.getCell(5).getStringCellValue());// 结束号
			
			subArea.setSingle(row.getCell(6).getStringCellValue().toCharArray()[0]);// 单双号
			subArea.setAssistKeyWords(row.getCell(7).getStringCellValue());// 辅助关键字（位置信息）
			
			
			subAreas.add(subArea);
		}
		// 调用业务层
		subAreaService.saveSubAreas(subAreas);
		return NONE;
	}
	
	@Action(value="subArea_findAll",results={@Result(name="success",type="json")})
	public String findAll(){
		Pageable pageable = new PageRequest(page-1, rows);
		// 这里不做条件的查询了
		Page<SubArea> page = subAreaService.findAll(pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}
	
	// 分页条件查询
	@Action(value="subArea_pageQuery",results={@Result(name="success",type="json")})
	public String findSubAreaParams(){
		// 获取pageable对象
		Pageable pageable = new PageRequest(page-1, rows);// 参数一，从0开始，0表示第一页
		// 构建分页对象Specification
		Specification<SubArea> specification = new Specification<SubArea>() {
			// 完成的条件查询
/**
 * 传递：
 * 		Root<SubArea> root：（连接语句的时候需要字段，获取字段的名称）代表Criteria查询的根对象，Criteria查询的查询根定义了实体类型，能为将来导航获得想要的结果，它与SQL查询中的FROM子句类似
 * 		CriteriaQuery<?> query： （简单的查询可以使用CriteriaQuery）代表一个specific的顶层查询对象，它包含着查询的各个部分，比如：select 、from、where、group by、order by等
 * 		CriteriaBuilder cb：（复杂的查询可以使用CriteriaBuilder构建）用来构建CritiaQuery的构建器对象
 * 返回：Predicate：封装查询条件
 * 
 */
			@Override
			public Predicate toPredicate(Root<SubArea> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				Predicate predicate = null;
				/**
				 * 封装查询条件
				 */
				ArrayList<Predicate> list = new ArrayList<Predicate>();
				/*********关联Area表的查询条件**********/
				Join<SubArea, Area> join = root.join("area", JoinType.INNER);
				// 省
				if(model.getArea() != null && StringUtils.isNotBlank(model.getArea().getProvince())){
					Predicate p = cb.like(join.get("province").as(String.class), "%"+model.getArea().getProvince()+"%");
					list.add(p);
				}
				// 市
				if(model.getArea() != null && StringUtils.isNotBlank(model.getArea().getCity())){
					Predicate p = cb.like(join.get("city").as(String.class), "%"+model.getArea().getCity()+"%");
					list.add(p);		
				}
				// 区
				if(model.getArea() != null && StringUtils.isNotBlank(model.getArea().getDistrict())){
					Predicate p = cb.like(join.get("district").as(String.class), "%"+model.getArea().getDistrict()+"%");
					list.add(p);
				}
				/*********关联FixedArea表的查询条件**********/
				Join<SubArea, FixedArea> join2 = root.join("fixedArea",JoinType.INNER);
				// 定区编码
				if(model.getFixedArea() != null && StringUtils.isNotBlank(model.getFixedArea().getId())){
					Predicate p = cb.equal(join2.get("id").as(String.class), model.getFixedArea().getId());
					list.add(p);
				}
				
				// 关键字
				if(StringUtils.isNotBlank(model.getKeyWords())){
					Predicate p = cb.like(root.get("keyWords").as(String.class), "%"+model.getKeyWords()+"%");
					Predicate p1 = cb.like(root.get("assistKeyWords").as(String.class), "%"+model.getKeyWords()+"%");
					Predicate or = cb.or(p,p1);
					list.add(or);
				}
				// 构建条件的组合，将list集合存放的多个条件，转换成predicate
				if(list != null && list.size()>0){
					Predicate[] p = new Predicate[list.size()];
					predicate = cb.and(list.toArray(p));
				}
				
				return predicate;
				
			}
			
		};
		
		Page<SubArea> page = subAreaService.findPageQueryCourierByCondition(specification,pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}
	
	
	
	//subArea_add
	@Action(value="subArea_add",results={@Result(name="success",type="json")
	,@Result(name="error",type="json")})
	public String add(){
		// shiro获取S当前登录用户信息
		Subject subject = SecurityUtils.getSubject();
		User user = (User)subject.getPrincipal();
		String currentName = user.getUsername();
		
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			subAreaService.save(model);
			map.put("success", true);
			map.put("msg", "保存分区成功,分拣编号： "+model.getId());
			logger.info("保存分区成功，分拣编号：" + model.getId() +"[日期： "+ new Date()+"]"+"操作人："+currentName);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("success", false);
			map.put("msg", "保存分区失败");
			logger.error("保存分区失败，分拣编号：" + model.getId() +"[日期： "+ new Date()+"]"+"操作人："+currentName);
		}finally{
			pushValueStack(map);
		}
		return SUCCESS;
		
	}
	
	
	/**
	 * 删除快递员
	 * @return
	 */
	@Action(value="subArea_delete",results={@Result(name="success",type="redirect",location="./pages/base/sub_area.jsp")})
	public String delete(){
		subAreaService.delete(ids);
		return SUCCESS;
	}
	
	
	@Action(value="subArea_exportXls")
	public String exportXls() throws Exception{
		List<SubArea> list = subAreaService.findAll();
		
		// 生成Excel文件
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
		// 创建Sheet
		HSSFSheet sheet = hssfWorkbook.createSheet("分区数据");
		// 表头
		HSSFRow headRow = sheet.createRow(0);

		headRow.createCell(0).setCellValue("分拣编号");
		headRow.createCell(1).setCellValue("起始号");
		headRow.createCell(2).setCellValue("终止号");
		headRow.createCell(3).setCellValue("单双号");
		headRow.createCell(4).setCellValue("关键字");
		headRow.createCell(5).setCellValue("辅助关键字");
		headRow.createCell(6).setCellValue("区域Id");
		headRow.createCell(7).setCellValue("定区Id");
		// 表格数据
		for (SubArea subArea : list) {
			// 设置Sheet中最后一行的行号+1，或者for循环的时候用索引for(int i=0;i<wayBills.size();i++)，用i的形式创建行号
			HSSFRow dataRow = sheet.createRow(sheet.getLastRowNum() + 1);
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(0).setCellValue(subArea.getId());
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(1).setCellValue(subArea.getStartNum());
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(2).setCellValue(subArea.getEndNum());
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(3).setCellValue(subArea.getSingle());
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(4).setCellValue(subArea.getKeyWords());
			if(StringUtils.isNotBlank(subArea.getAssistKeyWords()))
			dataRow.createCell(5).setCellValue(subArea.getAssistKeyWords());
			
			if(subArea.getArea() != null){
				dataRow.createCell(6).setCellValue(subArea.getArea().getId());
			}else{
				dataRow.createCell(6).setCellValue("");
			}
			if(subArea.getFixedArea() != null){
				dataRow.createCell(7).setCellValue(subArea.getFixedArea().getId());
			}else{
				dataRow.createCell(7).setCellValue("");
			}
			
			
		}
		
		// 下载导出
		// 设置头信息
		ServletActionContext.getResponse().setContentType(
				"application/vnd.ms-excel");
		String filename = "分区数据.xls";
		String agent = ServletActionContext.getRequest()
				.getHeader("user-agent");
		filename = FileUtils.encodeDownloadFilename(filename, agent);
		ServletActionContext.getResponse().setHeader("Content-Disposition",
				"attachment;filename=" + filename);
		
		// 将Excel文档写到输出流中
		ServletOutputStream outputStream = ServletActionContext.getResponse().getOutputStream();
		hssfWorkbook.write(outputStream);

		// 关闭
		hssfWorkbook.close();

		return NONE;
	}
	
	
	private String fixedAreaId;
	public void setFixedAreaId(String fixedAreaId) {
		this.fixedAreaId = fixedAreaId;
	}
	@Action(value="subArea_findSubAreaByFixedAreaId",results={@Result(name="success",type="json")})
	public String findSubAreaByFixedAreaId(){
		List<SubArea> list= subAreaService.findSubAreaByFixedAreaId(fixedAreaId);
		pushValueStack(list);
		return SUCCESS;
	}

}
































