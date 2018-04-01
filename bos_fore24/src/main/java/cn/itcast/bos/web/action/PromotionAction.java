package cn.itcast.bos.web.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.io.FileUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.domain.page.PageBean;
import cn.itcast.bos.domain.take_delivery.Promotion;
import cn.itcast.bos.web.action.common.BaseAction;
import freemarker.template.Configuration;
import freemarker.template.Template;

@ParentPackage(value="json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class PromotionAction extends BaseAction<Promotion> {


	// 宣传活动列表展示
	@Action(value="promotion_pageQuery",results={@Result(name="success",type="json")})
	public String pageQuery() throws Exception{
		// 参数（page和rows）
		@SuppressWarnings("unchecked")
		PageBean<Promotion> pageData = WebClient.create(Constants.BOS_MANAGEMENT_URL+"/services/promotionService/findPageQueryWebservice?page="+page+"&rows="+rows)
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON)
					.get(PageBean.class);
		// 响应结果
		Map<String, Object> map = new HashMap<>();
		map.put("totalCount", pageData.getTotalElements()); // long类型的总记录数
		map.put("pageData", pageData.getContent());// 集合
		pushValueStack(map);
		return SUCCESS;
	}
	
	// 宣传活动详情页面
	@Action(value="promotion_detail")
	public String detail() throws Exception{
		// 获取宣传活动主键ID
		Integer id = model.getId();
		// 判断freemarker文件夹下的html文件是否存在
		String path = ServletActionContext.getServletContext().getRealPath("/freemarker");
		File file = new File(path+"/"+id+".html");
		// 不存在
		if(!file.exists()){
			// 使用id查询宣传活动的详情
			Promotion promotion = WebClient.create(Constants.BOS_MANAGEMENT_URL+"/services/promotionService/findById/"+id)
					.type(MediaType.APPLICATION_JSON)
					.accept(MediaType.APPLICATION_JSON)
					.get(Promotion.class);
			// 使用FreeMarker技术生成html页面
			// 创建对象
			Configuration configuration = new Configuration(Configuration.VERSION_2_3_22);
			// 查找模板路径
			configuration.setDirectoryForTemplateLoading(new File(ServletActionContext.getServletContext().getRealPath("/WEB-INF/template")));
			// 获取模板文件
			Template template = configuration.getTemplate("promotion.ftl");
			
			// 指定参数
			Map<String, Object> dataModel = new HashMap<>();
			dataModel.put("promotion", promotion);
			// 使用模板文件输出文件内容（在控制台输出）
			template.process(dataModel, new OutputStreamWriter(new FileOutputStream(file)));
		}
		// 处理编码格式
		ServletActionContext.getResponse().setContentType("text/html;charset=utf-8");
		FileUtils.copyFile(file, ServletActionContext.getResponse().getOutputStream());
		return NONE;
	}
}
