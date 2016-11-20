package com.openq.orgContacts;
import java.io.Serializable;
import java.util.Date;

public class OrgContacts implements Serializable{
	
	public OrgContacts(){}
	private long orgContactsId;
	private long orgId;
	private String contactName;
	private String email;
	private String isPrimaryContact;
	private String phone;
	private long staffid;
	private Date begindate;
	private Date enddate;
	
	public Date getBegindate() {
		return begindate;
	}
	public void setBegindate(Date begindate) {
		this.begindate = begindate;
	}
	public Date getEnddate() {
		return enddate;
	}
	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}
	public long getStaffid() {
		return staffid;
	}
	public void setStaffid(long staffid) {
		this.staffid = staffid;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getIsPrimaryContact() {
		return isPrimaryContact;
	}
	public void setIsPrimaryContact(String isPrimaryContact) {
		this.isPrimaryContact = isPrimaryContact;
	}
	public long getOrgContactsId() {
		return orgContactsId;
	}
	public void setOrgContactsId(long orgContactsId) {
		this.orgContactsId = orgContactsId;
	}
	public long getOrgId() {
		return orgId;
	}
	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
}
