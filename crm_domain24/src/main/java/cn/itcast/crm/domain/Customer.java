package cn.itcast.crm.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

import org.apache.struts2.json.annotations.JSON;


/**
 * @description:客户信息表
 * 
 */
@Entity
@Table(name = "T_CUSTOMER")
@XmlRootElement(name = "Customer")
public class Customer implements Serializable {
	private static final long serialVersionUID = 1923852725015090031L;
	@Id
	@GeneratedValue()
	@Column(name = "C_ID")
	private int id; // 主键id
	@Column(name = "C_USERNAME")
	private String username; // 用户名
	@Column(name = "C_PASSWORD")
	private String password; // 密码
	@Column(name = "C_TYPE")
	private int type; // 类型
	@Column(name = "C_BRITHDAY")
	@Temporal(TemporalType.DATE)
	private Date birthday; // 生日
	@Column(name = "C_SEX")
	private int sex; // 性别
	@Column(name = "C_TELEPHONE")
	private String telephone; // 手机
	@Column(name = "C_COMPANY")
	private String company; // 公司
	@Column(name = "C_DEPARTMENT")
	private String department; // 部门
	@Column(name = "C_POSITION")
	private String position; // 职位
	@Column(name = "C_ADDRESS")
	private String address; // 地址
	@Column(name = "C_MOBILEPHONE")
	private String mobilePhone; // 座机
	@Column(name = "C_EMAIL")
	private String email; // 邮箱
	@Column(name = "C_Fixed_AREA_ID")
	private String fixedAreaId; // 定区编码
	@Column(name = "C_HEADIMG")
	private	String headImg;
	

	@Column(name = "C_has_sign_in_today")
	private String hasSignInToday;// 是否已经签到 0:未签到 1:已签到

	@Column(name = "C_is_continuous_sign_in")
	private Integer hasSignIsDay; // 连续签到天数

	@Column(name = "C_last_sign_in_time")
	@Temporal(TemporalType.DATE)
	private Date lastSignInTime; // 上次签到时间

	@Column(name = "C_credits")
	private Long credits; // 用户积分
	@OneToMany(mappedBy = "customer")
	private Set<CustomerAddressBook>  addresses = new HashSet<>();


	public String getHeadImg() {
		return headImg;
	}

	public void setHeadImg(String headImg) {
		this.headImg = headImg;
	}
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
	public int getSex() {
		return sex;
	}

	public void setSex(int sex) {
		this.sex = sex;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getFixedAreaId() {
		return fixedAreaId;
	}

	public void setFixedAreaId(String fixedAreaId) {
		this.fixedAreaId = fixedAreaId;
	}
	public String getHasSignInToday() {
		return hasSignInToday;
	}

	public void setHasSignInToday(String hasSignInToday) {
		this.hasSignInToday = hasSignInToday;
	}


	public Integer getHasSignIsDay() {
		return hasSignIsDay;
	}

	public void setHasSignIsDay(Integer hasSignIsDay) {
		this.hasSignIsDay = hasSignIsDay;
	}

	public Date getLastSignInTime() {
		return lastSignInTime;
	}

	public void setLastSignInTime(Date lastSignInTime) {
		this.lastSignInTime = lastSignInTime;
	}

	public Long getCredits() {
		return credits;
	}

	public void setCredits(Long credits) {
		this.credits = credits;
	}

	@JSON(serialize=false)
	public Set<CustomerAddressBook> getAddresses() {
		return addresses;
	}

	public void setAddresses(Set<CustomerAddressBook> addresses) {
		this.addresses = addresses;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", username=" + username + ", password=" + password + ", type=" + type
				+ ", birthday=" + birthday + ", sex=" + sex + ", telephone=" + telephone + ", company=" + company
				+ ", department=" + department + ", position=" + position + ", address=" + address + ", mobilePhone="
				+ mobilePhone + ", email=" + email + ", fixedAreaId=" + fixedAreaId + ", headImg=" + headImg
				+ ", hasSignInToday=" + hasSignInToday + ", hasSignIsDay=" + hasSignIsDay + ", lastSignInTime="
				+ lastSignInTime + ", credits=" + credits + ", addresses=" + addresses + "]";
	}

	
}