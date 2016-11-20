package com.openq.authorization;

import com.openq.group.Groups;
import com.openq.group.IGroupService;
import com.openq.group.IUserGroupMapService;
import com.openq.user.IUserService;

/**
 * The Privilege Service provides a mechanism to set privileges for specific users/groups
 * to have access to specific features. It also provides mechanisms to identify groups/users
 * who have access to certain features. The service allows privileges to be defined at a 
 * UserGroup/UserType/Feature level. For each feature, 4 separate privilege types can be specified:
 * <ul>
 * <li>CREATE @see Privilege.CREATE </li>
 * <li>READ @see Privilege.READ </li>
 * <li>UPDATE @see Privilege.UPDATE </li>
 * <li>DELETE @see Privilege.DELETE </li>
 * </ul> 
 * 
 * @author Amit Arora
 *
 */
public interface IPrivilegeService {
	/**
	 * This routine is used to identify all groups who have privileges to access the 
	 * specified feature. At present this routine does not look at user types. 
	 * 
	 * @param featureKey Unique key for the feature
	 * @param privType One of Privelege.CREATE, Privelege.READ, Privelege.UPDATE, Privelege.DELETE
	 * 
	 * @return List of all groups who can access the feature for the specific privilege type
	 * 
	 * @deprecated
	 */
	public Groups[] getAllPrivilegedGroupsForFeature(String featureKey, String privType);
	
	/**
	 * This routine sets the privileges for the specified userGroup, usertype 
	 * and feature triplet
	 * 
	 * @param userGroup The user group for which the privilege is to be set
	 * @param userType The user type in the specified user group for which the privilege is
	 * 				   to be set. Specify -1 if the privilege should be set for all user types
	 * @param featureKey The key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 * @param allow True if the user should be allowed to access the feature, false otherwise
	 * 
	 * @throws IllegalArgumentException if the privType is not one of "CREATE, READ, UPDATE, DELETE"
	 * @throws NonCompatiblePrivilegeException if the privilege being specified is not compatible
	 * 											with the privilege specified for the parent feature
	 */
	public void setPrivilege(Groups userGroup, long userType, String featureKey, String privType, boolean allow)
													throws IllegalArgumentException, NonCompatiblePrivilegeException;
	
	/**
	 * This routine sets the privileges for the specified userGroup, usertype 
	 * and feature triplet
	 * 
	 * @param groupName Name of the user group for which the privilege is to be set
	 * @param userType The user type in the specified user group for which the privilege is
	 * 				   being set. Specify -1 if the privilege should be set for all user types
	 * @param featureKey The key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 * @param allow True if the user should be allowed to access the feature, false otherwise
	 * 
	 * @throws IllegalArgumentException if the privType is not one of "CREATE, READ, UPDATE, DELETE"
	 * @throws NonCompatiblePrivilegeException if the privilege being specified is not compatible
	 * 											with the privilege specified for the parent feature
	 */
	public void setPrivilege(String groupName, long userType, String featureKey, String privType, boolean allow)
													throws IllegalArgumentException, NonCompatiblePrivilegeException;
	
	
	/**
	 * This routine is used to check if the user has sufficient privileges to access the 
	 * specified feature
	 *  
	 * @param userId Id for the user whose privileges need to be evaluated
	 * @param featureKey Key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 *
	 * @return true if the user has sufficient privileges to access the feature, false otherwise
	 */
	public boolean isOperationAllowed(long userId, String featureKey, String privType) throws PrivilegeNotFoundException;
	
	
	/**
	 * This is a wrapper around "isOperationAllowed" routine. In case the desired 
	 * privilege is not found in the System, this routine returns the default access value for that privilege type
	 * 
	 * @param userId Id for the user whose privileges need to be evaluated
	 * @param featureKey Key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 * 
	 * @see #isOperationAllowed(long, String, String)
	 * 
	 * @return  true if the user has sufficient privileges to access the feature, false otherwise
	 */
	public boolean wrappedIsOperationAllowed(long userId, String featureKey, String privType);
	
	/**
	 * This routine is used to delete all privileges which have been specified for the given
	 * feature. This should be called for clean-up purposes only when the attribute 
	 * is being deleted from the System.
	 * 
	 * @param featureKey Unique key for the feature whose privileges should be deleted
	 */
	public void deletePrivilegesForFeature(String featureKey) ;
	
	
	/**
	 * This routine is used to get all Privilege objects which have been defined for the 
	 * specified feature
	 *  
	 * @param featureKey Unique key for the feature whose defined privileges should be returned
	 * 
	 * @return defined privileges for the given feature
	 */
	public Privilege[] getDefinedPrivileges(String featureKey);
	
	// These are test-hooks
	void setUserService(IUserService userService);
	void setGroupService(IGroupService groupService);
	void setUserGroupMapService(IUserGroupMapService userGroupMapService);		
}
