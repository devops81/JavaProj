package com.openq.authorization;

/**
 * Encapsulate the privileges for Create/Read/Update/Delete operations for a given group,
 * user type and feature
 * 
 * @author Amit Arora
 */
public class Privilege {
	public static final String CREATE = "CREATE";
	public static final String READ = "READ";
	public static final String UPDATE = "UPDATE";
	public static final String DELETE = "DELETE";
	
	public static final boolean DEFAULT_CREATE_PRIVILEGE = true; // By default, every one has create privilege
	public static final boolean DEFAULT_READ_PRIVILEGE = true; // By default, every one has read privilege
	public static final boolean DEFAULT_UPDATE_PRIVILEGE = true; // By default, every one has update privilege
	public static final boolean DEFAULT_DELETE_PRIVILEGE = true; // By default, every one has delete privilege
	
	private long privilegeId;
	private long groupId;
	private long userType;
	private String featureKey;
	private boolean allowCreate;
	private boolean allowRead;
	private boolean allowUpdate;
	private boolean allowDelete;
	
	/**
	 * Create a new Privilege object
	 */
	public Privilege() {
		
	}
	
	/**
	 * Create a new Privilege object with the specified values
	 * 
	 * @param grp
	 * @param uType
	 * @param key
	 * @param create
	 * @param read
	 * @param update
	 * @param delete
	 */
	public Privilege(long grp, long uType, String key, 
							boolean create, boolean read, boolean update, boolean delete) {
		groupId = grp;
		userType = uType;
		featureKey = key;
		allowCreate = create;
		allowRead = read;
		allowUpdate = update;
		allowDelete = delete;
	}

	/**
	 * Create a new Privilege object with the default privilege values
	 * 
	 * @param grp
	 * @param uType
	 * @param key
	 */
	public Privilege(long grp, long uType, String key) {
		groupId = grp;
		userType = uType;
		featureKey = key;
		allowCreate = DEFAULT_CREATE_PRIVILEGE;
		allowRead = DEFAULT_READ_PRIVILEGE;
		allowUpdate = DEFAULT_UPDATE_PRIVILEGE;
		allowDelete = DEFAULT_DELETE_PRIVILEGE;
	}
	
	public boolean getAllowCreate() {
		return allowCreate;
	}
	
	public void setAllowCreate(boolean allowCreate) {
		this.allowCreate = allowCreate;
	}
	
	public boolean getAllowDelete() {
		return allowDelete;
	}
	
	public void setAllowDelete(boolean allowDelete) {
		this.allowDelete = allowDelete;
	}
	
	public boolean getAllowRead() {
		return allowRead;
	}
	
	public void setAllowRead(boolean allowRead) {
		this.allowRead = allowRead;
	}
	
	public boolean getAllowUpdate() {
		return allowUpdate;
	}
	
	public void setAllowUpdate(boolean allowUpdate) {
		this.allowUpdate = allowUpdate;
	}
	
	public String getFeatureKey() {
		return featureKey;
	}
	
	public void setFeatureKey(String featureKey) {
		this.featureKey = featureKey;
	}

	public long getGroupId() {
		return groupId;
	}

	public void setGroupId(long group) {
		this.groupId = group;
	}

	public long getUserType() {
		return userType;
	}

	public void setUserType(long userType) {
		this.userType = userType;
	}

	public long getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(long privilegeId) {
		this.privilegeId = privilegeId;
	}
}