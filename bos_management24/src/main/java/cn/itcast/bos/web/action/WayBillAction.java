package cn.itcast.bos.web.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.take_delivery.WayBill;
import cn.itcast.bos.service.WayBillService;
import cn.itcast.bos.utils.FileUtils;
import cn.itcast.bos.web.action.common.BaseAction;

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class WayBillAction extends BaseAction<WayBill> {

	// 日志
	Logger logger = LoggerFactory.getLogger(WayBillAction.class);

	@Autowired
	private WayBillService wayBillService;

	@Action(value = "waybill_save", results = { @Result(name = "success", type = "json") })
	public String save() throws Exception {

		Map<String, Object> map = new HashMap<>();
		try {
			// 防止瞬时对象异常
			if (model.getOrder() != null && model.getOrder().getId() == null) {
				model.setOrder(null);
			}
			wayBillService.save(model);
			map.put("success", true);
			map.put("msg", "保存运单成功，运单号是：" + model.getWayBillNum());
			logger.info("保存运单成功，运单号是：" + model.getWayBillNum() + new Date());
		} catch (Exception e) {
			e.printStackTrace();
			map.put("success", false);
			map.put("msg", "保存运单失败，运单号是：" + model.getWayBillNum());
			logger.error("保存运单失败，运单号是：" + model.getWayBillNum() + new Date());
		}
		pushValueStack(map);
		return SUCCESS;
	}

	// 运单快速录入的数据表格遍历
	@Action(value = "waybill_pageQuery", results = { @Result(name = "success", type = "json") })
	public String pageQuery() {
		// 无条件的分页查询（按照id字段完成排序）
		Pageable pageable = new PageRequest(page - 1, rows, new Sort(Direction.ASC, "id"));
		// 无条件的分页查询
		// Page<WayBill> page = wayBillService.findPageQuery(pageable);
		// 有条件的分页查询
		Page<WayBill> page = wayBillService.findPageQuery(pageable, model);
		pushValueStackToPage(page);
		return SUCCESS;
	}

	// 使用运单号，查询运单
	@Action(value = "waybill_findByWayBillNum", results = { @Result(name = "success", type = "json") })
	public String findByWayBillNum() {
		Map<String, Object> map = new HashMap<>();
		WayBill wayBill = wayBillService.findByWayBillNum(model.getWayBillNum());
		// 没有查询到结果
		if (wayBill == null) {
			map.put("success", false);
		}
		// 查询到结果
		else {
			map.put("success", true);
			map.put("wayBillData", wayBill);
		}
		pushValueStack(map);
		return SUCCESS;
	}

	private File xls;

	public void setXls(File xls) {
		this.xls = xls;
	}

	@Action(value = "waybill_batchImport")
	public String batchImport() throws FileNotFoundException, IOException {

		List<WayBill> wayBills = new ArrayList<WayBill>();
		Workbook hssfWorkbook = new XSSFWorkbook(new FileInputStream(xls));

		Sheet sheetAt = hssfWorkbook.getSheetAt(0);
		for (Row row : sheetAt) {
			if (row.getRowNum() == 0) {
				continue;

			}
			WayBill wayBill = new WayBill();
			Cell id = row.getCell(0);
			id.setCellType(HSSFCell.CELL_TYPE_STRING); // 将ID转成String
			Cell goodsType = row.getCell(1);
			goodsType.setCellType(HSSFCell.CELL_TYPE_STRING);// 将产品类型转换成String
			Cell sendProNum = row.getCell(2);
			sendProNum.setCellType(HSSFCell.CELL_TYPE_STRING);// 将快递类型编号转换成String
			Cell sendMobile = row.getCell(4);
			sendMobile.setCellType(HSSFCell.CELL_TYPE_STRING);// 将发件人电话转换成String
			Cell recMobile = row.getCell(7);
			recMobile.setCellType(HSSFCell.CELL_TYPE_STRING);// 将收件人电话转换成String
			wayBill.setId(Integer.parseInt(row.getCell(0).getStringCellValue()));// 编号
			wayBill.setGoodsType(row.getCell(1).getStringCellValue());// 产品
			wayBill.setSendProNum(row.getCell(2).getStringCellValue());// 快递类型编号
			wayBill.setSendName(row.getCell(3).getStringCellValue());// 发件人姓名
			wayBill.setSendMobile(row.getCell(4).getStringCellValue());// 发件人电话
			wayBill.setSendAddress(row.getCell(5).getStringCellValue());// 发件人地址
			wayBill.setRecName(row.getCell(6).getStringCellValue());// 收件人姓名
			wayBill.setRecMobile(row.getCell(7).getStringCellValue());// 收件人电话
			wayBill.setRecCompany(row.getCell(8).getStringCellValue());// 收件人公司
			wayBill.setRecAddress(row.getCell(9).getStringCellValue());// 收件人地址
			wayBills.add(wayBill);
		}
		wayBillService.saveWayBills(wayBills);

		return NONE;
	}

	@Action(value = "download")
	public String download() throws IOException {
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
		HSSFSheet sheet = hssfWorkbook.createSheet("运单模板");

		HSSFRow headRow = sheet.createRow(0);
		headRow.createCell(0).setCellValue("编号");
		headRow.createCell(1).setCellValue("产品");
		headRow.createCell(2).setCellValue("快递产品类型");
		headRow.createCell(3).setCellValue("发件人姓名");
		headRow.createCell(4).setCellValue("发件人电话");
		headRow.createCell(5).setCellValue("发件人地址");
		headRow.createCell(6).setCellValue("收件人姓名");
		headRow.createCell(6).setCellValue("收件人电话");
		headRow.createCell(6).setCellValue("收件人公司");
		headRow.createCell(6).setCellValue("收件人地址");

		ServletActionContext.getResponse().setContentType("application/vnd.ms-excel");

		String filename = "工作单导入模板.xls";
		ServletActionContext.getRequest().getHeader("user-agent");
		filename = FileUtils.encodeDownloadFilename("Content-Disposition", "attachment;filename=" + filename);
		ServletOutputStream outputStream = ServletActionContext.getResponse().getOutputStream();
		hssfWorkbook.write(outputStream);
		hssfWorkbook.close();

		return NONE;
	}

	// 使用运单号，查询运单
	@Action(value="waybill_searchNum",results={@Result(name="success",type="json")})
	public String searchNum(){
		List<String> NumList = wayBillService.searchNum(model);
		Map<String,Object> map = new HashMap<>();
		map.put("value",NumList);
		pushValueStack(map);
		return SUCCESS;
	}

}
