package cn.itcast.bos.web.action;


import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import java.util.HashMap;

import java.util.concurrent.TimeUnit;

import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.Session;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Scope;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Controller;


import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.opensymphony.xwork2.ActionContext;


import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;



import cn.itcast.bos.domain.constants.Constants;
import cn.itcast.bos.utils.MailUtils;
import cn.itcast.bos.utils.SmsDemoUtils;
import cn.itcast.bos.web.action.common.BaseAction;
import cn.itcast.crm.domain.Customer;

@ParentPackage(value = "json-default")
@Namespace("/")
@Controller
@Scope("prototype")
public class CustomerAction extends BaseAction<Customer> {

	@Autowired
	private RedisTemplate<String, String> redisTemplate;

	@Autowired
	@Qualifier("jmsQueueTemplate")
	private JmsTemplate jmsTemplate;

	
	
	// 发送短信
	@Action(value = "customer_sendsms", results = { @Result(name = "success", type = "json") })
	public String sendsms() throws Exception {
		final String telephone = model.getTelephone();
		// 使用阿里大鱼短信平台，发送短信
		final String number = SmsDemoUtils.getNumber();
		// 将生成的验证码存放到Session中，使用手机号作为唯一的标志
		ServletActionContext.getRequest().getSession().setAttribute(telephone, number);
		// 设置Session的失效时间
		ServletActionContext.getRequest().getSession().setMaxInactiveInterval(1 * 60);// 单位是秒，表示1分钟失效
		// 发送短信(webservice)
		// SendSmsResponse sendSms = SmsDemoUtils.sendSms(telephone, number);
		// String code = sendSms.getCode();
		/** 将电话号和4位验证码作为参数传递MQ，属于消息的生产者 */
		jmsTemplate.send("bos_sms", new MessageCreator() {

			@Override
			public Message createMessage(Session session) throws JMSException {
				MapMessage message = session.createMapMessage();
				message.setString("telephone", telephone);
				message.setString("number", number);
				return message;
			}
		});

		String code = "OK";
		// 发送成功
		if (code.equals("OK")) {
			// System.out.println("发送短信成功！电话号是："+telephone+",验证码是："+number);
			pushValueStack(number);
		} else {
			throw new RuntimeException("发送短信失败");
		}

		return SUCCESS;
	}

	// 属性驱动
	// 页面输入的验证码
	private String checkcode;

	public void setCheckcode(String checkcode) {
		this.checkcode = checkcode;
	}
	
	// 客户注册
	@Action(value = "customer_regiest", results = {
			@Result(name = "success", type = "redirect", location = "./signup-success.jsp"),
			@Result(name = "input", type = "redirect", location = "./signup.jsp") })
	public String regiest() throws Exception {
		// 从Session中获取验证码
		String sessionCheckCode = (String) ServletActionContext.getRequest().getSession()
				.getAttribute(model.getTelephone());
		// 比对
		if (sessionCheckCode == null || !sessionCheckCode.equals(checkcode)) {
			System.out.println("验证已经失效或者是输入的验证码有误！");
			return INPUT;
		}
		/** 数据库的手机号一定要唯一 */
		// 使用电话号查询客户的信息
		Customer customer = WebClient
				.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/telephone/"
						+ model.getTelephone())
				.type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).get(Customer.class);
		if (customer != null) {
			System.out.println("手机号已经 注册，请联系管理员去操作系统！");
			return INPUT;
		}
		// 将页面注册的信息存放到CRM系统
		WebClient.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/save")
				.type(MediaType.APPLICATION_JSON).post(model);
		/** 生成32位的激活码，存放到redis数据库中 */
		String numeric = RandomStringUtils.randomNumeric(32);
		redisTemplate.opsForValue().set(model.getTelephone(), numeric, 24, TimeUnit.HOURS);
		/** 发送邮件 */
		// 传递电话和激活码的目的是：在激活的代码中和redis中的数据进行比对。
		String content = "尊敬的客户您好，请于24小时内，进行邮箱账户的绑定，点击下面地址完成绑定:<br/><a href='" + MailUtils.activeUrl + "?telephone="
				+ model.getTelephone() + "&activecode=" + numeric + "'>速运快递邮箱绑定地址</a>";
		MailUtils.sendMail("速运快递激活邮件", content, model.getEmail(), "");
		System.out.println("客户注册成功！");
		return SUCCESS;
	}

	// 属性驱动
	// 32位激活码
	private String activecode;

	public void setActivecode(String activecode) {
		this.activecode = activecode;
	}

	// 激活邮件
	@Action(value = "customer_activeMail")
	public String activeMail() throws Exception {
		ServletActionContext.getResponse().setContentType("text/html;charset=utf-8");
		// 1、CustomerAction 提供 activeMail 方法 ，接收参数：（1）客户手机号码 和 （2）激活码
		String telephone = model.getTelephone();
		// 2、先判断激活码是否有效，如果激活码无效，提示用户【激活码无效，请登录系统，重新绑定邮箱！】
		String number = redisTemplate.opsForValue().get(telephone);
		if (number == null || !activecode.equals(number)) {
			ServletActionContext.getResponse().getWriter().println("激活码无效，请登录系统，重新绑定邮箱！");
			return NONE;
		}
		// 3、如果激活码有效 ，判断是否在重复绑定，即T_CUSTOMER表type字段 为1，如果绑定，提示用户【邮箱已经绑定过，无需重复绑定！】
		// 使用电话号查询客户的信息
		Customer customer = WebClient
				.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/telephone/" + telephone)
				.type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).get(Customer.class);
		if (customer != null && customer.getType() == 1) {
			ServletActionContext.getResponse().getWriter().println("邮箱已经绑定过，无需重复绑定！");
			return NONE;
		} else {
			// 4、如果用户没有绑定过邮箱，完成绑定，提示用户【邮箱绑定成功！】
			WebClient
					.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/updateType/" + telephone)
					.type(MediaType.APPLICATION_JSON).put(null);
			ServletActionContext.getResponse().getWriter().println("邮箱绑定成功！");
		}
		// 5、使用手机号清空redis
		redisTemplate.delete(telephone);
		return NONE; // return null;
	}

	// 登录
	@Action(value = "customer_login", results = {
			@Result(name = "success", type = "redirect", location = "./index.jsp#/myhome"),
			@Result(name = "input", type = "redirect", location = "./login.jsp") })
	public String login() throws Exception {
		// 获取电话号
		String telephone = model.getTelephone();
		// 获取密码
		String password = model.getPassword();
		// 使用电话和密码，查询唯一的客户
		Customer customer = WebClient
				.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/telephoneAndPassword/"
						+ telephone + "/" + password)
				.type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).get(Customer.class);
		// 此时没有结果
		if (customer == null) {
			System.out.println("用户名和密码输入有误！");
			return INPUT;
		}
		// 判断当前用户是否被激活
		if (customer.getType() != 1) {
			System.out.println("当前电话号：" + telephone + "没有被激活，请联系管理员");
			return INPUT;
		}
		// 手机号和密码输入正确，且用户已经被激活，此时存放到Session中
		ServletActionContext.getRequest().getSession().setAttribute("customer", customer);
		System.out.println("用户登录成功！");
		return SUCCESS;
	}

	
	@Action(value="customer_findById",results={@Result(name="success",type="json")})
	public String findCustomerById(){
		Customer customer = WebClient.create(Constants.CRM_MANAGEMENT_URL+"/services/customerService/customer/findCustomerById/"+model.getId())
		.accept(MediaType.APPLICATION_JSON)
		.type(MediaType.APPLICATION_JSON)
		.get(Customer.class);
		ActionContext.getContext().getValueStack().push(customer);
//		String dateStr=new SimpleDateFormat("MM-dd").format(customer.getBirthday());
//		System.out.println(dateStr);
		return SUCCESS;
	}
	
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
	@Action(value="customer_update",results={@Result(name="success",type="redirect",location="index.jsp")})
	public String update() throws IOException{
		if (titleImgFile!=null) {
			//文件保存目录路径（绝对路径：上传）
			String savePath = ServletActionContext.getServletContext().getRealPath("/") + "images/head/";

			//文件保存目录URL（相对路径：存储/页面）
			String saveUrl = ServletActionContext.getRequest().getContextPath() + "/images/head/";

			// 生成文件名
			String filename = UUID.randomUUID().toString();
			// 后缀
			String ext = titleImgFileFileName.substring(titleImgFileFileName.lastIndexOf("."));
			// 文件名
			String newFileName = filename + ext;

			// 上传
			File destFile = new File(savePath + "/" + newFileName);
			FileUtils.copyFile(titleImgFile, destFile);
			// 相对路径
			model.setHeadImg(saveUrl+newFileName);
		}
		
			WebClient.create(Constants.CRM_MANAGEMENT_URL+"/services/customerService/customer/update")
			.type(MediaType.APPLICATION_JSON)
			.put(model);
		//ActionContext.getContext().getSession().put("msg", "保存成功");
		return SUCCESS;
	}

	
	@Action(value = "customer_logout", results = {
			@Result(name = "success", type = "redirect", location = "./index.jsp#/") })
	public String logout() {
		// 注销
		ServletActionContext.getRequest().getSession().invalidate();
		return SUCCESS;
	}

	// 签到的功能设计
	@Action(value = "customer_signIn", results = {
			@Result(name = "success", type = "json"),
			@Result(name = "login", type = "redirect", location = "./login.jsp"),
			@Result(name = "input", type = "json")})
	public String signIn() {
		// 获得session中已经登录的用户id
		Customer loginCustomer = (Customer) ServletActionContext.getRequest().getSession().getAttribute("customer");
		// 判断用户是否已经登录了,如果没用登录则让用户去登录
		if (loginCustomer == null || loginCustomer.getId() == 0) {
			return LOGIN;
		}
		// 如果已经登录了,则传入获取登录id,然后调用远程服务,获取用户信息
		// 是否已经签到 0:未签到 1:已签到
		HashMap<String, Object> result = new HashMap<>();
		String hasSignInToday = loginCustomer.getHasSignInToday();
		if (hasSignInToday!=null&&"1".equals(hasSignInToday)) {
			// 已经签到不可以在签到
			System.out.println("您今天已签到");
			result.put("success", false);
			result.put("msg", "您今天已签到");
			pushValueStack(result);
			return INPUT;
		}
		// 发起远程调用服务,设置签到,并且累计积分
		Response putResponse =
				WebClient.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/signIn/" + loginCustomer.getId())
				.type(MediaType.APPLICATION_JSON).put(null);
		System.out.println(putResponse.getStatus());
		
		//重新查询用户当前的信息,用于返回给页面
		Customer customer = WebClient.create(Constants.CRM_MANAGEMENT_URL + "/services/customerService/customer/findCustomerById/" + loginCustomer.getId())
		.type(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).get(Customer.class);
		result.put("success", true);
		result.put("msg", "签到成功");
		result.put("customer", customer);
		//更新session中客户的状态
		ServletActionContext.getRequest().getSession().setAttribute("customer", customer);
		pushValueStack(result);
		return SUCCESS;
	}


}
