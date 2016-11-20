package com.openq.eav.scripts;

import com.openq.eav.audit.IAuditService;
import com.openq.eav.data.Entity;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionService;
import com.openq.user.IUserService;

public interface IOlDataLoader {

	public long saveOl();
	public long saveOl(Summary s, String custId);

	public void saveSummary(Entity summaryTopTab, String custId);

	public void saveAddress(Entity parent, String custId);

	public void saveContactMachenism(Entity summaryTopTab, String custId);

	public void saveEducation(Entity summaryTopTab, String custId);

	public void saveTier(Entity summaryTopTab, String custId);

	public void saveProfile(Entity summaryTopTab, String custId);

	public void saveExperienceType(Entity indProfileTopTab, String custId);

	public void saveOrganizations(Entity indProfileTopTab, String custId);

	public void saveSocietyMembership(Entity indProfileTopTab, String custId);

	public void saveTopicExpertise(Entity indProfileTopTab, String custId);

	public void saveInterestDescription(Entity indProfileTopTab, String custId);

	public void savePresentations(Entity indProfileTopTab, String custId);

	public void savePositionToAmgenScience(Entity amgenProfile, String string);

	public void saveOlStrengths(Entity amgenProfile, String string);

	public void savePublications(Entity parent, String custId);

	public void saveAmgenTrials(Entity trials, String string);

	public void saveOtherTherapies(Entity parent, String custId);
	
	public void saveInBatch(int startIndex, int size, Summary[] summaries);

	public IUserService getUserService();
	

	public void setUserService(IUserService userService);

	public IOptionService getOptionService();
	public void setOptionService(IOptionService optionService);


	
	public IAuditService getAuditService();



	public void setAuditService(IAuditService auditService) ;

	public IDataLoadService getDataLoadService();
	
	public void setDataLoadService(IDataLoadService dataLoadService);
	


	
}