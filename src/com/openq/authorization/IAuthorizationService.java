package com.openq.authorization;

//import java.util.List;

import com.openq.eav.option.OptionLookup;
import com.openq.group.Groups;

/**
 * The authorization service provides a mechanism to set privileges for specific users/groups.
 * The privileges are set at a UserGroup/UserType/Feature level. 
 * 
 * @author Amit Arora
 *
 */
public interface IAuthorizationService {
	/**
	 * This routine sets the privileges for the specified userGroup, usertype 
	 * and feature triplet
	 * 
	 * @param userGroup The user group for which the privilege is being set
	 * @param userType The user type in the specified user group for which the privilege is
	 * 				   being set
	 * @param featureKey The key for the feature for which the privilege is being set
	 * @param privType One of "CREATE, READ, UPDATE, DELETE"
	 * @param allow True if the user should be allowed to access the feature, false otherwise
	 * 
	 * @throws IllegalArgumentException if the privType is not one of "CREATE, READ, UPDATE, DELETE"
	 * @throws NonCompatiblePrivilegeException if the privilege being specified is not compatible
	 * 											with the privilege specified for the parent feature
	 */
	public boolean setPrivilege(Groups userGroup, OptionLookup userType, String featureKey,
						  String privType, boolean allow) 
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
	
	
	// Possible extensions
	
	/**
	 * This routine sets the privileges for the specified groups, and feature.
	 * These privileges would be applicable to “all” user types in the specified 
	 * groups.
	 * 
	 * @param allowedGroupIds  Ids for all groups which should be allowed
	 * @param featureKey Unique key of the feature	 
	 * @param privileges The CRUD privileges encapsulated in an object
	 * 
	 * @throws NonCompatiblePrivilegeException if the privilege being specified is 
	 *                              not compatible with what is specified for the parent feature
	 */
	/*public boolean setPrivilegesForGroups(long[] allowedGroupIds, String featureKey,
							Privilege privileges) throws NonCompatiblePrivilegeException;*/

	
	/**
	 * This routine is used to get a list of all privileges which the specified user has.
	 * 
	 * @param userId Id for the user whose privileges need to be evaluated
	 * 
	 * @return a List containing entries of type Privilege
	 */
	/*public List getAllPrivileges(long userId);*/
}
