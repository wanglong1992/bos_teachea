package cn.itcast.crm.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

@Entity
@Table(name = "T_CUSTOMER_ADDRESS")
@XmlRootElement(name = "CustomerAddress")
public class CustomerAddressBook implements Serializable {

    private static final long serialVersionUID = 5522392099442294534L;
    @Id
    @GeneratedValue()
    @Column(name = "C_ID")
    private Long id;// 主键id
    @Column(name = "C_USERNAME")
    private String username;// 用户名
    @Column(name = "C_TELEPHONE")
    private String telephone;// 手机
    @Column(name = "C_COMPANY")
    private String company;// 公司
    @Column(name = "C_ADDRESS")
    private String address; // 地址
    @Column(name="C_COUNT")
    private Integer count;//使用频次
    @Column(name = "C_DEFAULT")
    private  boolean  isDefault=false;//(默认不是default)
    @ManyToOne
    @JoinColumn(name ="C_CUSTOMER_ID")
    private Customer customer;  //关联客户

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    @Override
    public String toString() {
        return "CustomerAddressBook{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", telephone='" + telephone + '\'' +
                ", company='" + company + '\'' +
                ", address='" + address + '\'' +
                ", count=" + count +
                ", isDefault=" + isDefault +
                ", customer=" + customer +
                '}';
    }
}
