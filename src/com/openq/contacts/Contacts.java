package com.openq.contacts;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import com.openq.audit.Auditable;

public class Contacts implements Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "begindate", "brand", "contactId", "contactName",
            "email", "enddate", "isPrimaryContact", "kolId", "otherRole", "phone", "role", "staffid", "type", "begindate" });

	public Contacts(){}
		private long contactId;
		private long kolId;
		private String type;
		private String contactName;
		private String email;
		private String phone;
		private String brand;
		private String isPrimaryContact;
		private String otherRole;
		private String role;
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

    public String getPrimaryContact() {
        return isPrimaryContact;
    }

    public void setPrimaryContact(String primaryContact) {
        isPrimaryContact = primaryContact;
    }

    public String getBrand() {
			return brand;
		}
		
		public String [] getBrandList(){
			return splitString(brand); 
		}
		
		public void setBrand(String brand) {
			this.brand = brand;
		}
		
		public void setBrandList(String [] brandList){
			this.brand = concatenateString(brandList);
		}
		
		public long getContactId() {
			return contactId;
		}
		public void setContactId(long contactId) {
			this.contactId = contactId;
		}
		public String getContactName() {
			return contactName;
		}
		public void setContactName(String contactName) {
			this.contactName = contactName;
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
		public long getKolId() {
			return kolId;
		}
		public void setKolId(long kolId) {
			this.kolId = kolId;
		}
		public String getPhone() {
			return phone;
		}
		public void setPhone(String phone) {
			this.phone = phone;
		}
		public String getRole() {
			return role;
		}
		public void setRole(String role) {
			this.role = role;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		
		private String [] splitString(String str) {
			if (str != null)
				return str.split(",");
			return new String[0];
		}
		
		private String concatenateString(String [] strList) {
			if (strList == null || strList.length == 0)
				return null;
			
			if (strList.length == 1)
				return strList[0];
			
			String result = strList[0] + ",";
			for (int i = 1; i < strList.length - 1; i++) {
				result += strList[i] + ",";
			}
			
			result += strList[strList.length - 1];
			
			return result;
		}

		public String getOtherRole() {
			return otherRole;
		}

		public void setOtherRole(String otherRole) {
			this.otherRole = otherRole;
		}
	
    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
}
