package com.openq.eav.scripts;

import java.util.List;

public interface IDataLoadService {

	public Summary[] getSummaryByCustNum(String custnum);

	public Address[] getAddressByCustNum(String custnum);

	public Contact[] getContactByCustNum(String custnum);

	public Education[] getEducationByCustNum(String custnum);

	public ExperienceType[] getExperienceTypeByCustNum(String custnum);

	public Publication[] getPublicationByCustNum(String custnum);

	public Therapies[] getTherapiesByCustNum(String custnum);

	public Societies [] getAllSocietiesByCustNum(String custNum);
	
	public InterestDescription [] getAllInterestDescriptionsByCustNum(String custNum);
	
	public Presentations [] getAllPresentationsByCustNum(String custNum);
	
	public Address[] getAllAddresses();
	
	public Summary[] getAllSummaries();
	
	public Tiers[] getAllTiersByCustNum(String custNum);
	
	public Trials[] getAllTrialsByCustNum(String custNum);
	
	public Topics[] getTopicsByCustNum(String custnum);
	
	public Position[] getPositionByCustNum(String custnum);
	
	public OlStrength[] getOlStrengthByCustNum(String custnum);
	
	public Bio[] getBioByCustNum(String custnum);
}