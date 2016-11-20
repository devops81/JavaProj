package com.openq.authorization;

public class FeatureUsergroupMap implements java.io.Serializable{
	
	private long id;
	private long featureId;
	private String usergroupId;
	private long permissionOnFeature;
	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}
	/**
	 * @return the featureId
	 */
	public long getFeatureId() {
		return featureId;
	}
	/**
	 * @param featureId the featureId to set
	 */
	public void setFeatureId(long featureId) {
		this.featureId = featureId;
	}
	/**
	 * @return the usergroupId
	 */
	public String getUsergroupId() {
		return usergroupId;
	}
	/**
	 * @param usergroupId the usergroupId to set
	 */
	public void setUsergroupId(String usergroupId) {
		this.usergroupId = usergroupId;
	}
	/**
	 * @return the permissionOnFeature
	 */
	public long getPermissionOnFeature() {
		return permissionOnFeature;
	}
	/**
	 * @param permissionOnFeature the permissionOnFeature to set
	 */
	public void setPermissionOnFeature(long permissionOnFeature) {
		this.permissionOnFeature = permissionOnFeature;
	}
}
