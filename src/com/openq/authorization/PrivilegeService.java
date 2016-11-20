package com.openq.authorization;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.group.UserGroupMap;
import com.openq.user.IUserService;
import com.openq.user.User;

/**
 * The Privilege Service provides a mechanism to specify and retrieve privileges for 
 * specific users/groups to have access to various features
 * 
 * @see com.openq.authorization.IPrivilegeService
 * 
 * @author Amit Arora
 *
 */
public class PrivilegeService extends HibernateDaoSupport implements
		IPrivilegeService {

	IUserService userService;
	IGroupService groupService;
	IUserGroupMapService userGroupMapService;
	
	/**
	 * @see IPrivilegeService#setPrivilege(Groups, long, String, String, boolean)
	 */
	public void setPrivilege(Groups userGroup, long userType,
					String featureKey, String privType, boolean allow)
			throws IllegalArgumentException, NonCompatiblePrivilegeException {
	
		Privilege[] allPrivs = getExistingPrivileges(new Groups[] {userGroup}, userType, featureKey);
		Privilege p = null;
		boolean existingPriv = false;
		
		if((allPrivs == null) || (allPrivs.length == 0)) {
			// We need to add a new privilege to the DB
			p = new Privilege(userGroup.getGroupId(), userType, featureKey);			
		}
		else if (allPrivs.length > 1) {
			// This should not have happened
			throw new IllegalStateException("There are more than 1 privileges defined for : (" + 
					userGroup.getGroupName() + ", " + userType + ", " + featureKey + ") triplet");
		}
		else {
			// We have a single privilege
			p = allPrivs[0];
			existingPriv = true;
		}
		
		if(privType.equals(Privilege.CREATE))
			p.setAllowCreate(allow);
		else if(privType.equals(Privilege.READ))
			p.setAllowRead(allow);
		else if(privType.equals(Privilege.UPDATE))
			p.setAllowUpdate(allow);
		else if(privType.equals(Privilege.DELETE))
			p.setAllowDelete(allow);
		else
			throw new IllegalArgumentException("Privilege type must be one of CREATE/READ/UPDATE/DELETE");

		if(existingPriv) {
			updatePrivilege(p);
		}	
		else {
			addPrivilege(p);
		}
	}
	
	/**
	 * @see IPrivilegeService#setPrivilege(String, long, String, String, boolean)
	 */
	public void setPrivilege(String groupName, long userType, String featureKey, String privType, boolean allow)
										throws IllegalArgumentException, NonCompatiblePrivilegeException {
		
		// TODO: Use the group service for retrieving this
		List matchingGroups = getHibernateTemplate().find(
				" select g from Groups g" +
				" where g.groupName = '" + groupName + "'");
		
		if(matchingGroups.size() == 0)
			throw new IllegalArgumentException("No groups found with the given name : " + groupName);
		else if(matchingGroups.size() > 1)
			throw new IllegalArgumentException("More than 1 groups found with the given name : " + groupName);
		
		Groups grp = (Groups) matchingGroups.get(0);
		
		setPrivilege(grp, userType, featureKey, privType, allow);
	}
	
	/**
	 * @see IPrivilegeService#getAllPrivilegedGroupsForFeature(String, String)
	 * 
	 * @deprecated
	 */
	public Groups[] getAllPrivilegedGroupsForFeature(String featureKey, String privType) {
		String fieldToChoose = "";
		
		if(privType.equals(Privilege.CREATE))
			fieldToChoose = "p.allowCreate";
		else if(privType.equals(Privilege.READ))
			fieldToChoose = "p.allowRead"; 
		else if(privType.equals(Privilege.UPDATE))
			fieldToChoose = "p.allowUpdate";
		else if(privType.equals(Privilege.DELETE))
			fieldToChoose = "p.allowDelete";
		else
			throw new IllegalArgumentException("This privilege type is not supported");
		
		List result = getHibernateTemplate().find(
				" select g from Privilege p, Groups g" +
				" where p.featureKey = '" + featureKey + "'" +
				" and " + fieldToChoose + " = 'Y'" +
				" and p.groupId = g.groupId");
		
		return (Groups[]) result.toArray(new Groups[result.size()]);
	}
	
	/**
	 * @see IPrivilegeService#getDefinedPrivileges(String)
	 */
	public Privilege[] getDefinedPrivileges(String featureKey) {
		List result = getHibernateTemplate().find(" from Privilege p" +
				" where p.featureKey = '" + featureKey + "'");
		
		return (Privilege[]) result.toArray(new Privilege[result.size()]);
	}
	
	/**
	 * This routine is used to check if the user has sufficient privileges to access the 
	 * specified feature
	 *  
	 * @param userId Id for the user whose privileges need to be evaluated
	 * @param featureKey Key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 * 
	 * @see IPrivilegeService#isOperationAllowed(long, String, String)
	 *
	 * @return true if the user has sufficient privileges to access the feature, false otherwise
	 */
	public boolean isOperationAllowed(long userId, String featureKey, String privType) throws PrivilegeNotFoundException {
		User u = userService.getUser(userId);
		
		if(u == null)
			throw new IllegalArgumentException("Could not find user for the specified userId : " + userId);
		
		// Find out the user type for this user
		long userType = u.getUserType().getId();
		
		// Find out all the groups to which this user belongs
		UserGroupMap[] groupsMap = userGroupMapService.getAllGroupsForUser(userId);
		
		// Check if the user belongs to any groups
		if(groupsMap.length == 0)
			throw new PrivilegeNotFoundException("The user : " + userId + " does not belong to any group");
		
		Groups[] allGroups = new Groups[groupsMap.length];
		
		for(int i=0; i<groupsMap.length; i++) {
			allGroups[i] = groupService.getGroup(groupsMap[i].getGroup_id());
		}
		
		// Now get the privileges for all the groups to which the user belongs
		Privilege[] allPrivileges = getExistingPrivileges(allGroups, userType, featureKey);
		
		if((allPrivileges == null) || (allPrivileges.length == 0)) {
			// No privileges have been defined for these groups or user type
			
			// Check if any privileges are defined for these groups and all user types (user type == -1)
			allPrivileges = getExistingPrivileges(allGroups, -1, featureKey);
			
			// if we still don't have any privileges defined, throw PrivilegeNotFoundException
			if((allPrivileges == null) || (allPrivileges.length == 0))
				throw new PrivilegeNotFoundException("Couldn't find any privilege for (" + userId 
						+ ", " + featureKey + ",");
		}
		//System.out.println("feature key in is operation is "+featureKey);
		
		// We have found some privilege objects. Traverse all of them and OR the values
		boolean allowed = false;
		for(int i=0; i<allPrivileges.length; i++) {
			if(privType.equals(Privilege.CREATE))
				allowed = allowed || allPrivileges[i].getAllowCreate();
			else if(privType.equals(Privilege.READ))
				allowed = allowed || allPrivileges[i].getAllowRead();
			else if(privType.equals(Privilege.UPDATE))
				allowed = allowed || allPrivileges[i].getAllowUpdate();
			else if(privType.equals(Privilege.DELETE))
				allowed = allowed || allPrivileges[i].getAllowDelete();
			else
				throw new IllegalArgumentException("Privilege type must be one of CREATE/READ/UPDATE/DELETE");
		}
		
	
		return (allowed);
	}
	
	
	/**
	 * @see IPrivilegeService#wrappedIsOperationAllowed(long, String, String)
	 */
	public boolean wrappedIsOperationAllowed(long userId, String featureKey, String privType) {
		boolean allowed = false;
		//System.out.println("feature key is "+featureKey);
		try {
			allowed = isOperationAllowed(userId, featureKey, privType);
		}
		
		catch(PrivilegeNotFoundException e) {
			// In case the privilege is not found, return the defualt privilege for the specified type
			if(privType.equals(Privilege.CREATE))
				allowed = Privilege.DEFAULT_CREATE_PRIVILEGE;
			else if(privType.equals(Privilege.READ))
				allowed = Privilege.DEFAULT_READ_PRIVILEGE;
			else if(privType.equals(Privilege.UPDATE))
				allowed = Privilege.DEFAULT_UPDATE_PRIVILEGE;
			else if(privType.equals(Privilege.DELETE))
				allowed = Privilege.DEFAULT_DELETE_PRIVILEGE;
			else
				throw new IllegalArgumentException("Privilege type must be one of CREATE/READ/UPDATE/DELETE");
		}
		
		return (allowed);
	}
	
	/**
	 * @see IPrivilegeService#deletePrivilegesForFeature(String)
	 */
	public void deletePrivilegesForFeature(String featureKey) {
		getHibernateTemplate().delete("from Privilege p where p.featureKey = '" + featureKey + "'");
	}
	
	/**
	 * This routine is used to persist a new Privilege object in the DB
	 * @param p
	 */	
	private void addPrivilege(Privilege p) {
		getHibernateTemplate().save(p);
	}

	/**
	 * This routine is used to update an existing Privilege object in the DB
	 * @param p
	 */
	private void updatePrivilege(Privilege p) {
		getHibernateTemplate().update(p);
	}
	
	/**
	 * This routine is used to retrieve existing privileges objects for the specified userType,
	 * featureKey across all groups. It would return a Union of all such objects
	 * 
	 * @param groups List of all groups across which the privileges should be checked
	 * @param userType User type for which the privileges are needed
	 * @param featureKey Unique key for the feature
	 * 
	 * @return List of all existing Privilege objects. An empty list if non exist
	 */
	private Privilege[] getExistingPrivileges(Groups[] groups, long userType,
			String featureKey) {
		
		StringBuffer buff = new StringBuffer();
		for(int i=0; i<groups.length; i++) {
			buff.append(groups[i].getGroupId());
			if(i != groups.length - 1)
				buff.append((", "));
		}
		
		String groupsToCheck = buff.toString();
		
		List result = getHibernateTemplate().find(
                " from Privilege p where p.userType = " + userType +
                " and p.featureKey = '" + featureKey.replaceAll("'", "''") + "'" +
                " and p.groupId in (" + groupsToCheck + ")");
		
        return (Privilege[]) result.toArray(new Privilege[result.size()]);
	}

	
	public IUserService getUserService() {
		return userService;
	}


	public void setUserService(IUserService userService) {
		this.userService = userService;
	}


	public IUserGroupMapService getUserGroupMapService() {
		return userGroupMapService;
	}


	public void setUserGroupMapService(IUserGroupMapService userGroupMapService) {
		this.userGroupMapService = userGroupMapService;
	}


	public IGroupService getGroupService() {
		return groupService;
	}


	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}
}
