package cn.itcast.bos.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.base.Courier;
import cn.itcast.bos.domain.base.Standard;
import cn.itcast.bos.service.AreaService;
import cn.itcast.bos.utils.PinYin4jUtils;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class AreaAction extends BaseAction<Area> {

	@Autowired
	private AreaService areaService;
	
	// 属性驱动
	/**
	 *  private File [页面元素name属性名称]：表示获取文件
		private String [页面元素name属性名称]ContentType：表示获取上传文件的类型
		private String [页面元素name属性名称]FileName：表示获取上传的文件名
	 */
	private File file; 
	private String fileContentType;
	private String fileFileName;
	
	public void setFile(File file) {
		this.file = file;
	}

	public void setFileContentType(String fileContentType) {
		this.fileContentType = fileContentType;
	}

	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}

	// 区域导入
	@Action(value="area_importData",results={@Result(name="success",type="json")})
	public String importData() throws Exception{
//		System.out.println(file);
//		System.out.println(fileContentType);
//		System.out.println(fileFileName);
		// 使用POI技术，解析上传的excel文件，从文件中读取数据，导入到数据库（批量导入）
		// 创建工作簿，加载file文件
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(new FileInputStream(file));
		// 从工作簿中获取每个工作表的内容
		HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0); // 0表示第一个
		// 遍历工作表的内容
		List<Area> list = new ArrayList<>();
		for(Row row:hssfSheet){
			// 第一行的数据不导入
			if(row.getRowNum()==0){
				continue;
			}
			// 第一列的数据不能为空，因为它是主键
			if(row.getCell(0)==null || row.getCell(0).getStringCellValue()==null){
				continue;
			}
			Area area = new Area();
			//区域编码	省份	城市	区域	邮编
			area.setId(row.getCell(0).getStringCellValue());
			area.setProvince(row.getCell(1).getStringCellValue());
			area.setCity(row.getCell(2).getStringCellValue());
			area.setDistrict(row.getCell(3).getStringCellValue());
			area.setPostcode(row.getCell(4).getStringCellValue());
			// 简码
			// 去掉省市区的最后一个字
			String province = area.getProvince().substring(0, area.getProvince().length()-1);
			String city = area.getCity().substring(0, area.getCity().length()-1);
			String district = area.getDistrict().substring(0, area.getDistrict().length()-1);
			String[] headByString = PinYin4jUtils.getHeadByString(province+city+district);
			StringBuffer buffer = new StringBuffer();
			for(String head:headByString){
				buffer.append(head);
			}
			String shortcode = buffer.toString();
			area.setShortcode(shortcode);
			// 城市编码
			String citycode = PinYin4jUtils.hanziToPinyin(city,"");
			area.setCitycode(citycode);
			list.add(area);
		}
		areaService.saveList(list);
		return SUCCESS;
	}
	
	// 区域的数据表格遍历
	@Action(value="area_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery() throws Exception{
		Pageable pageable = new PageRequest(page-1, rows);
		// 组织查询条件
		Specification<Area> specification = new Specification<Area>() {
			// 完成的条件查询
			@Override
			public Predicate toPredicate(Root<Area> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				// 将条件先封装到List集合
				List<Predicate> list = new ArrayList<Predicate>();
				// 省
				if(StringUtils.isNotBlank(model.getProvince())){
					Predicate p = cb.like(root.get("province").as(String.class), "%"+model.getProvince()+"%");// province like ?
					list.add(p);
				}
				// 市
				if(StringUtils.isNotBlank(model.getCity())){
					Predicate p = cb.like(root.get("city").as(String.class), "%"+model.getCity()+"%");// city like ?
					list.add(p);
				}
				// 区
				if(StringUtils.isNotBlank(model.getDistrict())){
					Predicate p = cb.like(root.get("district").as(String.class), "%"+model.getDistrict()+"%");// district like ?
					list.add(p);
				}
				if(list!=null && list.size()>0){
					Predicate [] p = new Predicate[list.size()];
					query.where(list.toArray(p));
				}
				// 排序
				query.orderBy(cb.desc(root.get("id").as(String.class)));
				return query.getRestriction();
			}
		};
		Page<Area> page = areaService.findPageQuery(specification,pageable);
		pushValueStackToPage(page);
		return SUCCESS;
	}
}
