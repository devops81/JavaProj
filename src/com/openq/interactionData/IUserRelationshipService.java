package com.openq.interactionData;

public interface IUserRelationshipService {


	public String updateUserrelation(UserRelationship user);
	
	public String saveUserrelation(UserRelationship user);
		
	public UserRelationship[] getRelatedUser(String Id, String filterFlag);
	
	public String getTAbyCostCenter(String CC);
	
	public UserRelationship getUserRelationShip(long userId);
	
	public UserRelationship[] getUserRelationshipForTerritories(String territoryIds);
	
	
}


