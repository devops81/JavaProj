package com.openq.eav.scripts;

import java.util.HashMap;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

import com.openq.eav.EavConstants;
import com.openq.eav.audit.IAuditService;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.scripts.organization.CmaIdsToLoad;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.user.UserAddress;

public class OlDataLoader extends EavDataLoader  implements IOlDataLoader {

	public static void main(String[] args) {
		ClassPathResource res = new ClassPathResource("beans.xml");

		XmlBeanFactory factory = new XmlBeanFactory(res);
		IOlDataLoader olDataLoader = (IOlDataLoader) factory
				.getBean("olDataLoader");
           
		
		// Select all OLs from summary
		int batchSize = 10;
		 Summary[] summaries = olDataLoader.getDataLoadService()
		.getAllSummaries();
         System.out.println("Found " + summaries.length + " Ols.");
         for (int i = 0; i < summaries.length; i += batchSize)
         {
	         System.out.println("Start load of " + (i + 1) + " to "
			+ (i + batchSize) + " OLs.");
	           olDataLoader.saveInBatch(i, batchSize, summaries);
	         System.out.println("Loaded " + (i + batchSize) + " OLs so far.");
          }
         
         
		//olDataLoader.saveOl();
		System.out.println("Congratulations! All OLs loaded into database.");
		
		
	}

	
	/*
	public void saveInBatch(int startIndex, int size, Address[] addresses) {
		for (int i = startIndex; ((i < addresses.length) && (i < startIndex
				+ size)); i++) {
			Summary[] s = dataLoadService.getSummaryByCustNum(addresses[i]
					.getCustnum());
			if (s.length > 0)
				saveOl(s[0], s[0].getCustnum());
		}
	}*/

	public void saveInBatch(int startIndex, int size, Summary[] summaries) {
		for (int i = startIndex; ((i < summaries.length) && (i < startIndex
				+ size)); i++) {
			saveOl(summaries[i], summaries[i].getCustnum());
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveOl(com.openq.eav.scripts.Summary,
	 *      java.lang.String)
	 */
	public long saveOl() {
		
		for (int i=0;i<CmaIdsToLoad.cmaIds.length;i++)
		{		
			Entity ol=dataService.getEntity(orgOlMapService.getOlEntityId(CmaIdsToLoad.cmaIds[i].trim()));
			savePublications(ol, CmaIdsToLoad.cmaIds[i].trim());		
		}
		return 0;
		
	}
	
	public long saveOl(Summary s, String custId) {

		//Entity ol=dataService.getEntity(orgOlMapService.getOlEntityId(custId));
		//savePublications(ol, custId);
		
		// create entity for OL
		Entity ol = new Entity();
		ol.setType(metadataService.getEntityType(EavConstants.KOL_ENTITY_ID));
		
		dataService.saveEntity(ol);
		

		User user = new User();
		user.setUserName(s.getFirstName());
		user.setPassword("test");
		user.setFirstName(s.getFirstName());
		user.setLastName(s.getLastName());
		user.setMiddleName(s.getMiddleName());
		user.setSpeciality(s.getSpecialty1());

		user.setDeleteFlag("N");
		user.setKolid(ol.getId());
		user.setUserType(optionService.getOptionLookup(4));

		Address add[] = dataLoadService.getAddressByCustNum(custId);
		
		UserAddress userAddress = new UserAddress();
		if (add.length > 0 && add != null) {
			userAddress.setUserId(user.getId());
			userAddress.setAddress1(add[0].getLine1());
			userAddress.setAddress2(add[0].getLine2());
			userAddress.setCity(add[0].getCity());
			userAddress.setZip(add[0].getZip());
			userService.createUserAddress(userAddress);
		} else {
			userAddress.setUserId(user.getId());
			userAddress.setAddress1("");
			userAddress.setAddress2("");
			userAddress.setCity("");
			userAddress.setZip("");
			userService.createUserAddress(userAddress);
		}
		user.setUserAddress(userAddress);
		userService.createUserForDataLoad(user);

		Entity summaryTopTab = createEntityAttribute(ol,
				OlConstants.KOL_OL_Summary);
		saveSummary(summaryTopTab, s.getCustnum());
		saveAddress(summaryTopTab, s.getCustnum());
		saveContactMachenism(summaryTopTab, s.getCustnum());
		saveEducation(summaryTopTab, s.getCustnum());
		saveTier(summaryTopTab, s.getCustnum());
		saveProfile(summaryTopTab, s.getCustnum());
		saveIdentifiers(summaryTopTab, s.getCustnum(), user.getId(), s.getPhoto());
		
		Entity indProfileTopTab = createEntityAttribute(ol,
				OlConstants.KOL_Industry_Profile);
		saveExperienceType(indProfileTopTab, s.getCustnum());
		saveOrganizations(indProfileTopTab, s.getCustnum());
		saveSocietyMembership(indProfileTopTab, s.getCustnum());
		saveTopicExpertise(indProfileTopTab, s.getCustnum());
		saveInterestDescription(indProfileTopTab, s.getCustnum());
		savePresentations(indProfileTopTab, s.getCustnum());
		// TODO: saveOrganizations(); - how do you load organizations data ??
		// TODO: saveSocieties(); - how do you load organizations data ??

		Entity amgenProfile = createEntityAttribute(ol,
				OlConstants.KOL_Amgen_Profile);
		savePositionToAmgenScience(amgenProfile, s.getCustnum());
		saveOlStrengths(amgenProfile, s.getCustnum());

		savePublications(ol, s.getCustnum());

		Entity trials = createEntityAttribute(ol, OlConstants.KOL_Trials);
		saveAmgenTrials(trials, s.getCustnum());
		saveOtherTherapies(trials, s.getCustnum());
		// create an entry in user table*/

		return 0;
	}

	private void saveIdentifiers(Entity summaryTopTab, String custnum, long id, String photo) {
		HashMap m = new HashMap();
		m.put(OlConstants.KOL_OL_Summary_Identifiers_CmaId + "", custnum); 
		m.put(OlConstants.KOL_OL_Summary_Identifiers_openQ_ID + "", id + ""); 
		m.put(OlConstants.KOL_OL_Summary_Identifiers_Image_Name + "", photo); 
		Entity identifiersTab = createEntityAttribute(summaryTopTab,
				OlConstants.KOL_OL_Summary_Identifiers);
		saveAttributes(identifiersTab, m);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveSummary(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveSummary(Entity summaryTopTab, String custId) {
		// TODO: Make sure to save CMA ID as hidden attribute
		Entity summaryTab = createEntityAttribute(summaryTopTab,
				OlConstants.KOL_OL_Summary_Summary);

		Summary sum[] = dataLoadService.getSummaryByCustNum(custId);
		if (sum.length > 0) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Summary_Clinical_Research_Interest
					+ "", sum[0].getClinicalInterest());
			m.put(OlConstants.KOL_OL_Summary_Summary_Assistant_Name + "",
					sum[0].getAssistantName());
			m.put(OlConstants.KOL_OL_Summary_Summary_Assistant_Phone + "",
					sum[0].getAssistantPhone());
			m.put(OlConstants.KOL_OL_Summary_Summary_Assistant_E_Mail + "",
					sum[0].getAssistantEmail());
			m.put(OlConstants.KOL_OL_Summary_Summary_Bio_Date + "", sum[0]
					.getBioDate()); // ??
			m.put(OlConstants.KOL_OL_Summary_Summary_CmaID + "", sum[0]
					.getCustnum());
			m.put(OlConstants.KOL_OL_Summary_Summary_Accessibility + "", sum[0].getAccessibility());
			m.put(OlConstants.KOL_OL_Summary_Summary_Current_Experience_Status + "", sum[0].getExpStatus());
			m.put(OlConstants.KOL_OL_Summary_Summary_IRB + "", sum[0].getIrb());
			
			Bio [] b = dataLoadService.getBioByCustNum(custId);
			if (b.length > 0)
				m.put(OlConstants.KOL_OL_Summary_Summary_Biography_narrative + "", b[0].getBio());
			saveAttributes(summaryTab, m);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveAddress(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveAddress(Entity parent, String custId) {
		Address address[] = dataLoadService.getAddressByCustNum(custId);
		for (int i = 0; i < address.length; i++) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Address_Type + "", address[i]
					.getType());
			
			//	m.put(OlConstants.KOL_OL_Summary_Address_Usage + "", "Primary");
			m.put(OlConstants.KOL_OL_Summary_Address_Usage + "", address[i]
					.getUsage());
			m.put(OlConstants.KOL_OL_Summary_Address_City + "", address[i]
					.getCity());
			m.put(OlConstants.KOL_OL_Summary_Address_State + "", address[i]
					.getState());
			m.put(OlConstants.KOL_OL_Summary_Address_Zip + "", address[i]
					.getZip());
			m.put(OlConstants.KOL_OL_Summary_Address_Country + "", address[i]
					.getCountry());
			m.put(OlConstants.KOL_OL_Summary_Address_Source + "", address[i]
					.getSource());
			m.put(OlConstants.KOL_OL_Summary_Address_Line_1 + "", address[i].getLine1());
			
			m.put(OlConstants.KOL_OL_Summary_Address_Line_2 + "", address[i].getLine2());
			// Entity addressTab = createEntityAttribute(parent,
			// OlConstants.KOL_OL_Summary_Address);
			saveTableRow(parent, OlConstants.KOL_OL_Summary_Address, m);
		}
		if (address.length == 0)
			saveTableRow(parent, OlConstants.KOL_OL_Summary_Address,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveContactMachenism(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveContactMachenism(Entity summaryTopTab, String custId) {

		Contact contact[] = dataLoadService.getContactByCustNum(custId);
		for (int i = 0; i < contact.length; i++) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Contact_Mechanism_Contact_Info
					+ "", contact[i].getContactInfo());
			m.put(OlConstants.KOL_OL_Summary_Contact_Mechanism_Contact_Type
					+ "", contact[i].getContactType());
			m.put(OlConstants.KOL_OL_Summary_Contact_Mechanism_Preferred_Contact
									+ "", contact[i].getPreferred());
			
           saveTableRow(summaryTopTab,
					OlConstants.KOL_OL_Summary_Contact_Mechanism, m);
		}
		if (contact.length == 0)
			saveTableRow(summaryTopTab,
					OlConstants.KOL_OL_Summary_Contact_Mechanism, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveEducation(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveEducation(Entity summaryTopTab, String custId) {

		Education education[] = dataLoadService.getEducationByCustNum(custId);
		for (int i = 0; i < education.length; i++) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Education_Education_Type + "",
					education[i].getType());
			m.put(OlConstants.KOL_OL_Summary_Education_Institution + "",
					education[i].getInstitution());
			m.put(OlConstants.KOL_OL_Summary_Education_Degree + "",
					education[i].getDegree());
			m.put(OlConstants.KOL_OL_Summary_Education_Beginning_Year + "",
					education[i].getBeginYear());
			m.put(OlConstants.KOL_OL_Summary_Education_Description + "",
					education[i].getDescription());
			m.put(OlConstants.KOL_OL_Summary_Education_End_Year + "",
					education[i].getEndYear());
			m.put(OlConstants.KOL_OL_Summary_Education_Location + "",
					education[i].getLocation());
			saveTableRow(summaryTopTab, OlConstants.KOL_OL_Summary_Education, m);

		}
		if (education.length == 0)
			saveTableRow(summaryTopTab, OlConstants.KOL_OL_Summary_Education,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveTier(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveTier(Entity summaryTopTab, String custId) {
		Tiers tiers[] = dataLoadService.getAllTiersByCustNum(custId);
		for (int i = 0; i < tiers.length; i++) 
		{
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Classification_Tier_Therapeutic_Area + "", tiers[i]
			                                          					.getTa());
			                                          			
			m.put(OlConstants.KOL_OL_Summary_Classification_Tier_Tier + "", tiers[i]
			                                          					.getTier());
			saveTableRow(summaryTopTab, OlConstants.KOL_OL_Summary_Classification_Tier, m);
		}
		
		if (tiers.length == 0)
		saveTableRow(summaryTopTab,
				OlConstants.KOL_OL_Summary_Classification_Tier, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveProfile(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveProfile(Entity summaryTopTab, String custId) {

		Summary sum[] = dataLoadService.getSummaryByCustNum(custId);
		if (sum.length > 0) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_OL_Summary_Profile_Firstname + "", sum[0]
			                                          					.getFirstName());
		    
		
			m.put(OlConstants.KOL_OL_Summary_Profile_Lastname + "", sum[0]
				                                          					.getLastName());
			m.put(OlConstants.KOL_OL_Summary_Profile_Middlename + "", sum[0]
					.getMiddleName());
			m.put(OlConstants.KOL_OL_Summary_Profile_Gender + "", sum[0]
					.getGender());
			m.put(OlConstants.KOL_OL_Summary_Profile_Global + "", sum[0]
			                                      					.getGlobal());
			m.put(OlConstants.KOL_OL_Summary_Profile_Prefix + "", sum[0]
					.getPrefix());
			m.put(OlConstants.KOL_OL_Summary_Profile_Suffix + "", sum[0]
					.getSuffix());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty1 + "", sum[0]
					.getSpecialty1());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty2 + "", sum[0]
					.getSpecialty2());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty3 + "", sum[0]
					.getSpecialty3());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty4 + "", sum[0]
					.getSpecialty4());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty5 + "", sum[0]
					.getSpecialty5());
			m.put(OlConstants.KOL_OL_Summary_Profile_Specialty6 + "", sum[0]
					.getSpecialty6());
			
			Entity profileTab = createEntityAttribute(summaryTopTab,
					OlConstants.KOL_OL_Summary_Profile);
			saveAttributes(profileTab, m);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveExperienceType(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveExperienceType(Entity indProfileTopTab, String custId) {
		ExperienceType expType[] = dataLoadService
				.getExperienceTypeByCustNum(custId);
		for (int i = 0; i < expType.length; i++) {
			HashMap m = new HashMap();

			m.put(OlConstants.KOL_Industry_Profile_Experience_Type_Description
					+ "", expType[i].getDescription());
			m.put(OlConstants.KOL_Industry_Profile_Experience_Type_Date + "",
					expType[i].getExpdate());
			m
					.put(
							OlConstants.KOL_Industry_Profile_Experience_Type_Experience_Type
									+ "", expType[i].getExptype());
			m.put(OlConstants.KOL_Industry_Profile_Experience_Type_Position
					+ "", expType[i].getPosition());
			m.put(
					OlConstants.KOL_Industry_Profile_Experience_Type_Sponsor
							+ "", expType[i].getSponsor());
			m
					.put(
							OlConstants.KOL_Industry_Profile_Experience_Type_Therapeutic_Area
									+ "", expType[i].getTa());
			m.put(
					OlConstants.KOL_Industry_Profile_Experience_Type_Therapy
							+ "", expType[i].getTherapy());
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Experience_Type, m);

		}
		if (expType.length > 0)
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Experience_Type,
					new HashMap());

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveOrganizations(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveOrganizations(Entity indProfileTopTab, String custId) {
		saveTableRow(indProfileTopTab,
				OlConstants.KOL_Industry_Profile_Organizations, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveSocietyMembership(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveSocietyMembership(Entity indProfileTopTab, String custId) {
		Societies societies[] = dataLoadService
				.getAllSocietiesByCustNum(custId);
		for (int i = 0; i < societies.length; i++) {
			HashMap m = new HashMap();
			m.put(
					OlConstants.KOL_Industry_Profile_Society_Membership_Name
							+ "", societies[i].getName());
			m
					.put(
							OlConstants.KOL_Industry_Profile_Society_Membership_Abbreviation
									+ "", " ");
			m.put(OlConstants.KOL_Industry_Profile_Society_Membership_Board
					+ "", societies[i].getBoard());
			m.put(OlConstants.KOL_Industry_Profile_Society_Membership_Title
					+ "", societies[i].getTitle());
			m.put(
					OlConstants.KOL_Industry_Profile_Society_Membership_Date
							+ "", societies[i].getSocietyDate());
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Society_Membership, m);
		}
		if (societies.length == 0)
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Society_Membership,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveTopicExpertise(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveTopicExpertise(Entity indProfileTopTab, String custId) {
		Topics [] topics = dataLoadService.getTopicsByCustNum(custId);
		for (int i=0; i<topics.length; i++) {
			HashMap m = new HashMap();
			
			m.put(OlConstants.KOL_Industry_Profile_Topic_Expertise_Topic_Description + "", topics[i].getTopic());
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Topic_Expertise, m);
		}
		if (topics.length == 0)
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Topic_Expertise, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveInterestDescription(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveInterestDescription(Entity indProfileTopTab, String custId) {
		InterestDescription intDesc[] = dataLoadService
				.getAllInterestDescriptionsByCustNum(custId);
		for (int i = 0; i < intDesc.length; i++) {
			HashMap m = new HashMap();
			m
					.put(
							OlConstants.KOL_Industry_Profile_Interest_Description_Interest_Description
									+ "", intDesc[i].getInterestDesc());
			m
					.put(
							OlConstants.KOL_Industry_Profile_Interest_Description_Frequency
									+ "", intDesc[i].getFrequency());
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Interest_Description, m);
		}
		if (intDesc.length == 0)
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Interest_Description,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#savePresentations(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void savePresentations(Entity indProfileTopTab, String custId) {
		Presentations presentations[] = dataLoadService
				.getAllPresentationsByCustNum(custId);
		for (int i = 0; i < presentations.length; i++) {
			HashMap m = new HashMap();
			m
					.put(
							OlConstants.KOL_Industry_Profile_Presentations_Presentation_Type
									+ "", presentations[i].getType());
			m
					.put(
							OlConstants.KOL_Industry_Profile_Presentations_Meeting_Description
									+ "", presentations[i].getDescription());
			
			m.put(OlConstants.KOL_Industry_Profile_Presentations_Location + "",
					(presentations[i].getCity() == null ? " " : presentations[i].getCity() + ", ")
							+ (presentations[i].getState() == null ? " " : presentations[i].getState() + ", ")
							+ (presentations[i].getCountry() == null ? " " : presentations[i].getCountry() + ", "));
			m.put(OlConstants.KOL_Industry_Profile_Presentations_Date + "",
					presentations[i].getDateOfPresentation());
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Presentations, m);
		}
		if (presentations.length == 0)
			saveTableRow(indProfileTopTab,
					OlConstants.KOL_Industry_Profile_Presentations,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#savePositionToAmgenScience(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void savePositionToAmgenScience(Entity amgenProfile, String custId) {
		Position [] pos = dataLoadService.getPositionByCustNum(custId);
		for (int i=0; i<pos.length; i++) {
			HashMap m = new HashMap();
			m.put(OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Platform + "", pos[i].getPlatform());
			m.put(OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Publication+ "", pos[i].getPublication());
			m.put(OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Research + "", pos[i].getResearch());
			
			m.put(OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Therapy+ "", pos[i].getTherapy());
			m.put(OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Position_Date+ "", pos[i].getPosDate());
			
			saveTableRow(amgenProfile,
					OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science,
					m);		}
		if (pos.length == 0)
			saveTableRow(amgenProfile,
					OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science,
					new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveOlStrengths(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveOlStrengths(Entity amgenProfile, String custId) {
		OlStrength [] olStrengths = dataLoadService.getOlStrengthByCustNum(custId);
		HashMap m = new HashMap();
		if (olStrengths.length > 0) {
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Advisory_Board_Member_Clinical_Dev + "", olStrengths[0].getAdboardclic());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Advisory_Board_Member_Commercial + "", olStrengths[0].getAdboardcom());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Advisory_Board_Member_Early_Development + "", olStrengths[0].getAdboardearl());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Advisory_Board_Member_Medical_Affairs + "", olStrengths[0].getAdboardma());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Investigator_Phase_1 + "", olStrengths[0].getInvestigator1());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Investigator_Phase_2 + "", olStrengths[0].getInvestigator2());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Investigator_Phase_3 + "", olStrengths[0].getInvestigator2());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Investigator_Phase_3B + "", olStrengths[0].getInvestigator3b());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Investigator_Phase_4 + "", olStrengths[0].getInvestigator4());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Author + "", olStrengths[0].getAuthor());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Guidelines + "", olStrengths[0].getGuidelines());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Payor_Formulary + "", olStrengths[0].getPayorformula());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Promotional_Speaker + "", olStrengths[0].getProspeaker());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Reimbursement + "", olStrengths[0].getReimbursement());
			m.put(OlConstants.KOL_Amgen_Profile_OL_Strengths_Therapeutic_Speaker + "", olStrengths[0].getTaspeaker());
			
			
			
		}
		Entity olstrengthTab = createEntityAttribute(amgenProfile,
				OlConstants.KOL_Amgen_Profile_OL_Strengths);
		
		saveAttributes(olstrengthTab, m);
	}

	protected static final String PUBMED_URL_PREFIX = "<a href='http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?CMD=search&DB=pubmed&term=";

	protected static final String CLOSE_URL = "' target='_external' />";

	protected static final String END_URL = "</a>";

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#savePublications(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void savePublications(Entity parent, String custId) {
		Publication pub[] = dataLoadService.getPublicationByCustNum(custId);
		for (int i = 0; i < pub.length; i++) {
			HashMap m = new HashMap();

			m.put(OlConstants.KOL_Publications_Journal + "", pub[i].getJournal());
			m.put(OlConstants.KOL_Publications_Journal_Reference + "", pub[i]
					.getJournalReference());
			m.put(OlConstants.KOL_Publications_Medline_ID + "", pub[i]
					.getMedlineId());
			m.put(OlConstants.KOL_Publications_Pub_Date + "", pub[i]
					.getPubDate());
			m.put(OlConstants.KOL_Publications_Sponsor + "", pub[i]
					.getSponsor());
			m.put(OlConstants.KOL_Publications_Title + "", PUBMED_URL_PREFIX
					+ pub[i].getMedlineId() + CLOSE_URL + pub[i].getTitle()	+ END_URL);
			m.put(OlConstants.KOL_Publications_Type + "", pub[i].getType());

			saveTableRow(parent, OlConstants.KOL_Publications, m);
		}
		if (pub.length == 0)
			saveTableRow(parent, OlConstants.KOL_Publications, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveAmgenTrials(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveAmgenTrials(Entity parent, String custId) {
		Trials trials[] = dataLoadService.getAllTrialsByCustNum(custId);
		for (int i = 0; i < trials.length; i++) {
			HashMap m = new HashMap();

			m.put(OlConstants.KOL_Trials_Amgen_Trials_Trial_Type + "", trials[i]
					.getType());
			m.put(OlConstants.KOL_Trials_Amgen_Trials_Trial_Name + "", trials[i]
					.getName());
			m.put(OlConstants.KOL_Trials_Amgen_Trials_Trial_Desc + "", trials[i]
					.getDesc());
			m.put(OlConstants.KOL_Trials_Amgen_Trials_Start_Date + "", trials[i]
					.getStartDate());
			m.put(OlConstants.KOL_Trials_Amgen_Trials_End_Date + "", trials[i]
					.getEndDate());
			m.put(OlConstants.KOL_Trials_Amgen_Trials_Phase + "", trials[i].getPhase());
		
			saveTableRow(parent, OlConstants.KOL_Trials_Amgen_Trials, m);
		}
		if (trials.length == 0)
			
		saveTableRow(parent, OlConstants.KOL_Trials_Amgen_Trials, new HashMap());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.openq.eav.scripts.IOlDataLoader#saveOtherTherapies(com.openq.eav.data.Entity,
	 *      java.lang.String)
	 */
	public void saveOtherTherapies(Entity parent, String custId) {
		Therapies therapies[] = dataLoadService.getTherapiesByCustNum(custId);
		for (int i = 0; i < therapies.length; i++) {
			HashMap m = new HashMap();

			m.put(OlConstants.KOL_Trials_Other_Therapies_Disease_State + "",
					therapies[i].getDiseaseState());
			m.put(OlConstants.KOL_Trials_Other_Therapies_End_Date + "",
					therapies[i].getDiseaseState());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Outcome + "",
					therapies[i].getDiseaseState());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Phase + "",
					therapies[i].getPhase());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Sponsor + "",
					therapies[i].getSponsor());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Start_Date + "",
					therapies[i].getStartDate());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Therapy + "",
					therapies[i].getTherapy());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Trial_Desc + "",
					therapies[i].getDescription());
			m.put(OlConstants.KOL_Trials_Other_Therapies_Trial_Name + "",
					therapies[i].getName());
			saveTableRow(parent, OlConstants.KOL_Trials_Other_Therapies, m);
		}
		if (therapies.length == 0)
			saveTableRow(parent, OlConstants.KOL_Trials_Other_Therapies,
					new HashMap());
	}


	private Entity createEntityAttribute(Entity entity, long attrId) {
		EntityAttribute ea = new EntityAttribute();
		ea.setAttribute(metadataService.getAttributeType(attrId));
		ea.setParent(entity);
		dataService.saveEntityAttribute(ea, ea.getAttribute());
		return ea.getMyEntity();
	}

	IOptionService optionService;
	IUserService userService;
	IDataLoadService dataLoadService;
	IOrgOlMapService orgOlMapService;

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

	public IDataLoadService getDataLoadService() {
		return dataLoadService;
	}

	public void setDataLoadService(IDataLoadService dataLoadService) {
		this.dataLoadService = dataLoadService;
	}
	
	public IOrgOlMapService getOrgOlMapService() {
		return orgOlMapService;
	}

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
		this.orgOlMapService = orgOlMapService;
	}


}
