package cn.itcast.bos.domain.transit;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderColumn;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;

import cn.itcast.bos.domain.take_delivery.WayBill;

/**
 * @description: 运输配送信息
 */
@Entity
@Table(name = "T_TRANSIT_INFO")
public class TransitInfo {
	@Id
	@GeneratedValue
	@Column(name = "C_ID")
	private Integer id;

	@OneToOne
	@JoinColumn(name = "C_WAYBILL_ID")
	private WayBill wayBill;

	@OneToMany
	@JoinColumn(name = "C_TRANSIT_INFO_ID")
	@OrderColumn(name = "C_IN_OUT_INDEX")
	private List<InOutStorageInfo> inOutStorageInfos = new ArrayList<InOutStorageInfo>();

	@OneToOne
	@JoinColumn(name = "C_DELIVERY_INFO_ID")
	private DeliveryInfo deliveryInfo;

	@OneToOne
	@JoinColumn(name = "C_SIGN_INFO_ID")
	private SignInfo signInfo;

	@Column(name = "C_STATUS")
	// 出入库中转、到达网点、开始配送、正常签收、异常
	private String status;

	// 到达网点的地址
	@Column(name = "C_OUTLET_ADDRESS")
	private String outletAddress;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public WayBill getWayBill() {
		return wayBill;
	}

	public void setWayBill(WayBill wayBill) {
		this.wayBill = wayBill;
	}

	public List<InOutStorageInfo> getInOutStorageInfos() {
		return inOutStorageInfos;
	}

	public void setInOutStorageInfos(List<InOutStorageInfo> inOutStorageInfos) {
		this.inOutStorageInfos = inOutStorageInfos;
	}

	public DeliveryInfo getDeliveryInfo() {
		return deliveryInfo;
	}

	public void setDeliveryInfo(DeliveryInfo deliveryInfo) {
		this.deliveryInfo = deliveryInfo;
	}

	public SignInfo getSignInfo() {
		return signInfo;
	}

	public void setSignInfo(SignInfo signInfo) {
		this.signInfo = signInfo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getOutletAddress() {
		return outletAddress;
	}

	public void setOutletAddress(String outletAddress) {
		this.outletAddress = outletAddress;
	}

	@Transient
	public String getTransferInfo(){
		// 物流信息表示：查询出入库描述、开始配送描述、签收录入描述
		StringBuffer buffer = new StringBuffer();
		// 出入库
		if(inOutStorageInfos!=null && inOutStorageInfos.size()>0){
			for(InOutStorageInfo inOutStorageInfo:inOutStorageInfos){
				buffer.append(inOutStorageInfo.getDescription()+"<br>");
			}
		}
		// 开始配送
		if(deliveryInfo!=null){
			buffer.append(deliveryInfo.getDescription()+"<br>");
		}
		// 签收录入
		if(signInfo!=null){
			buffer.append(signInfo.getDescription()+"<br>");
		}
		return buffer.toString();
	}
}
