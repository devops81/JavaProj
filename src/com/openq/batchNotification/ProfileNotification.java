package com.openq.batchNotification;

public class ProfileNotification implements java.io.Serializable{
	
	long kolId;
	
	long attributeId;

	public long getAttributeId() {
		return attributeId;
	}

	public void setAttributeId(long attributeId) {
		this.attributeId = attributeId;
	}

	public long getKolId() {
		return kolId;
	}

	public void setKolId(long kolId) {
		this.kolId = kolId;
	}

 
}
