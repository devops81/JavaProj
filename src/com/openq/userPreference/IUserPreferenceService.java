package com.openq.userPreference;

public interface IUserPreferenceService {
	
	public boolean userExist(long userId);
	
	public void updatePreference(UserPreference userPreference);
	
	public void savePreference(UserPreference userPreference);
	
	public UserPreference getUserPreference(long userId);
	
	public void saveOrUpdatePreference(UserPreference userPreference);
	

	 
}
