package com.openq.authorization;


public class FeaturePermissionMetadata implements java.io.Serializable{
	
	private long id;
	private String permissionName;
	private boolean allowedByDefault;
	/**
	 * @return the allowedByDefault
	 */
	public boolean isAllowedByDefault() {
		return allowedByDefault;
	}
	/**
	 * @param allowedByDefault the allowedByDefault to set
	 */
	public void setAllowedByDefault(boolean allowedByDefault) {
		this.allowedByDefault = allowedByDefault;
	}
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
	 * @return the permissionName
	 */
	public String getPermissionName() {
		return permissionName;
	}
	/**
	 * @param permissionName the permissionName to set
	 */
	public void setPermissionName(String permissionName) {
		this.permissionName = permissionName;
	}
}
