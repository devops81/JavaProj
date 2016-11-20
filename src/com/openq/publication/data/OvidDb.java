package com.openq.publication.data;

import java.io.Serializable;

public class OvidDb implements Serializable {
	private long id;
	private String ovidDatabaseName;
	private String ovidDatabaseNameFull;
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getOvidDatabaseName() {
		return ovidDatabaseName;
	}
	public void setOvidDatabaseName(String ovidDatabaseName) {
		this.ovidDatabaseName = ovidDatabaseName;
	}
	public String getOvidDatabaseNameFull() {
		return ovidDatabaseNameFull;
	}
	public void setOvidDatabaseNameFull(String ovidDatabaseNameFull) {
		this.ovidDatabaseNameFull = ovidDatabaseNameFull;
	}

}
