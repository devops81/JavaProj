package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authorization.IPrivilegeService;
import com.openq.authorization.Privilege;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.trials.ClinicalTrials;
import com.openq.eav.trials.ITrialOlMapService;
import com.openq.eav.trials.ITrialService;
import com.openq.eav.trials.TrialOlMap;
import com.openq.eav.trials.TrialsConstants;
import com.openq.web.ActionKeys;

/**
 * This class is used to render trials to which the specified OL is affiliated.
 * 
 * @author Amit
 */
public class OlToTrialMapController extends AbstractController {

	ITrialOlMapService trialOlMapService;
	ITrialService trialService;
	IOptionServiceWrapper optionServiceWrapper;
	IDataService dataService;
	IMetadataService metadataService;
	IPrivilegeService privilegeService;

	/**
	 * Handle the specified HttpRequest
	 */
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		request.getSession().removeAttribute("trials");		
		request.getSession().removeAttribute("TRIAL_MODE");
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);

		String action = request.getParameter("action");
		if(action.equalsIgnoreCase(ActionKeys.CLINICAL_TRIAL_HOME)) {
			// do nothing, the trial list would get refreshed later in the routine 
		}
		else if(action.equalsIgnoreCase(ActionKeys.ADD_CLINICAL_TRIAL)) {
			// add the trial
			addOrUpdateTrial(request, action);
		}
		else if(action.equalsIgnoreCase(ActionKeys.EDIT_CLINICAL_TRIAL)) {
			// set trial details on session
			setSelectedTrialDetailsOnSession(request);
		}
		else if(action.equalsIgnoreCase(ActionKeys.SAVE_UPDATED_CLINICAL_TRIAL)) {
			// save the updated trial
			addOrUpdateTrial(request, action);
		}
		else if(action.equalsIgnoreCase(ActionKeys.DELETE_CLINICAL_TRIALS)) {
			// delete the selected trials
			deleteTrials(request);
		}
		
		if(request.getSession().getAttribute("TRIAL_STATUS") == null) {
			request.getSession().setAttribute("TRIAL_STATUS", optionServiceWrapper.getValuesForOptionName("Trial Status", userGroupId));
		}
		
		// Refresh the list of trials
		setTrialsForOl(request);
		
		// Set the permissions for the current user
		String uId = (String) request.getSession().getAttribute(Constants.USER_ID);
		long userId = Long.parseLong(uId);
		ModelAndView mav = new ModelAndView("ol_to_trial_map");
		
		setCRUDPermissions(mav, TrialsConstants.TRIAL_INFO_ATTRIB_ID, TrialsConstants.TRIAL_ENTITY_ID, userId);
		
		return mav;
	}
	
	/**
	 * Set CRUD permissions to signal to the UI whether to allow addition/deletion/editing of
	 * trial objects by the specified user
	 *  
	 * @param mav
	 * @param attrId
	 * @param entityTypeId
	 * @param userId
	 */
	private void setCRUDPermissions(ModelAndView mav, long attrId, long entityTypeId, long userId) {
		String featureKey = metadataService.getFeatureKeyForAttribute(entityTypeId, attrId);
		if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.CREATE)) {
			// hide add button
			mav.addObject("disableTrialAddButton", "disabled");
			System.out.println("Hiding the add button");
		}
		if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.DELETE)) {
			// hide delete button
			mav.addObject("disableTrialDeleteButton", "disabled");
			System.out.println("Hiding the delete button");
		}
		if (!privilegeService.wrappedIsOperationAllowed(userId, featureKey, Privilege.UPDATE)) {
			// hide edit button
			mav.addObject("disableTrialEditButton", "disabled");
			System.out.println("Hiding the update button");
		}
	}
	
	/**
	 * Set details corresponding to the trial whose id is selected by the user, and set those
	 * in the session object 
	 * 
	 * @param request
	 */
	private void setSelectedTrialDetailsOnSession(HttpServletRequest request) {
		String[] trialIds = null;
		if (request.getParameter("checkedTrialIds") != null) {
			trialIds = request.getParameterValues("checkedTrialIds");
		}
		
		if((trialIds != null) && (trialIds.length != 0)) {
			// Get trial details for first element
			long trialId = Long.parseLong(trialIds[0]);
			
			ClinicalTrials trial = trialService.getTrialWithId(trialId);
			
			// Set the trial details on the session object
			HttpSession session = request.getSession();
			
			session.setAttribute("trialId", trialIds[0]);
			session.setAttribute(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID + "", trial.getOfficialTitle());
			session.setAttribute(TrialsConstants.TRIAL_PURPOSE_ATTRIB_ID + "", trial.getPurpose());
			session.setAttribute(TrialsConstants.TRIAL_PHASE_ATTRIB_ID + "", trial.getPhase());
			session.setAttribute(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID + "", trial.getMolecules());
			session.setAttribute(TrialsConstants.TRIAL_STATUS_ATTRIB_ID + "", trial.getStatus());
			
			// Set the mode to edit
			session.setAttribute("TRIAL_MODE", "EDIT");
		}
	}
	
	/**
	 * This helper routine is used to add a new trial or update the details of an existing one
	 * by using the values provided by the user in the given http request 
	 * 
	 * @param request
	 * @param action
	 */
	private void addOrUpdateTrial(HttpServletRequest request, String action) {
		String title = null;
		String purpose = null;
		String phase = null;
		String molecule = null;
		String status = null;
		
		if(request.getParameter("title") != null) {
			title = request.getParameter("title");
        }
		
		if(request.getParameter("purpose") != null) {
			purpose = request.getParameter("purpose");
		}
        if(purpose == null) purpose = " ";

        if(request.getParameter("phase") != null) {
			phase = request.getParameter("phase");
		}
        if (phase==null) phase=" ";

        if(request.getParameter("molecule") != null) {
			molecule = request.getParameter("molecule");
		}
		if(molecule==null) molecule =" ";

        if(request.getParameter("status") != null) {
			status = request.getParameter("status");
		}
		
		System.out.println(action + " - title=" + title + ", purpose=" + purpose
				+ ", phase=" + phase + ", molecule=" + molecule + ", status=" + status);
		
		if(action.equalsIgnoreCase(ActionKeys.ADD_CLINICAL_TRIAL)) {
			long trialId = createNewTrial(title, purpose, phase, molecule, status);
			
			long kolId = Long.parseLong(request.getParameter("olId"));
			
			TrialOlMap map = new TrialOlMap();
			map.setOlId(kolId);
			map.setTrialId(trialId);
			map.setInstitution(" ");
			map.setRole(" ");
			trialOlMapService.saveTrialOlMap(map);
		}
		else if(action.equalsIgnoreCase(ActionKeys.SAVE_UPDATED_CLINICAL_TRIAL)) {
			String trialId = (String) request.getSession().getAttribute("trialId");
			if(trialId != null) {
				editTrialDetails(Long.parseLong(trialId), title, purpose, phase, molecule, status);
				
				// Remove the id for the edited trial
				request.getSession().removeAttribute("trialId");
			}
			else {
				throw new IllegalArgumentException("Could not find id for the trial that needs to be edited");
			}
			
		}
	}
	
	/**
	 * This routine is used to save the updated trial details in the DB
	 * 
	 * @param trialId
	 * @param title
	 * @param purpose
	 * @param phase
	 * @param molecule
	 * @param status
	 */
	private void editTrialDetails(long trialId, String title, String purpose, String phase, String molecule, String status) {
		EntityAttribute[] attribs = dataService.getEntityAttributes(trialId, TrialsConstants.TRIAL_INFO_ATTRIB_ID);
		if((attribs == null) ||  (attribs.length == 0))
			throw new IllegalArgumentException("Couldn't find Trial Info attribute for specified trial : " + trialId);
		
		EntityAttribute trialInfoAttrib = attribs[0];
		
		// Update the Trial title
		dataService.saveOrUpdateAttribute(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID, trialInfoAttrib.getMyEntity().getId(), title);
		
		// Update the Trial purpose
		dataService.saveOrUpdateAttribute(TrialsConstants.TRIAL_PURPOSE_ATTRIB_ID, trialInfoAttrib.getMyEntity().getId(), purpose);
		
		// Update the Trial phase
		dataService.saveOrUpdateAttribute(TrialsConstants.TRIAL_PHASE_ATTRIB_ID, trialInfoAttrib.getMyEntity().getId(), phase);
		
		// Update the Trial molecule
		dataService.saveOrUpdateAttribute(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID, trialInfoAttrib.getMyEntity().getId(), molecule);
		
		// Update the Trial status
		dataService.saveOrUpdateAttribute(TrialsConstants.TRIAL_STATUS_ATTRIB_ID, trialInfoAttrib.getMyEntity().getId(), status);
	}
	
	/**
	 * This routine is used to create a new trial with the specified attribute values
	 * 
	 * @param title
	 * @param purpose
	 * @param phase
	 * @param molecule
	 * @param status
	 * @return
	 */
	private long createNewTrial(String title, String purpose, String phase, String molecule, String status) {
		// create new trial
		EntityType et = metadataService
				.getEntityType(TrialsConstants.TRIAL_ENTITY_ID);
		Entity entity = new Entity();
		entity.setType(et);
		entity.setDeleteFlag("N");
		dataService.saveEntity(entity);

		System.out.println("Created the trial entity");
		
		// Save the Trial Details attribute
		AttributeType type = metadataService.getAttributeType(TrialsConstants.TRIAL_DETAILS_ATTRIB_ID);
		EntityAttribute entityAttribute = new EntityAttribute();
		entityAttribute.setParent(entity);
		entityAttribute.setAttribute(type);
		dataService.saveEntityAttribute(entityAttribute, type);
		
		// Save the Trial Info attribute
		entityAttribute = new EntityAttribute();
		entityAttribute.setParent(entity);
		dataService.saveEntityAttribute(entityAttribute, metadataService
				.getAttributeType(TrialsConstants.TRIAL_INFO_ATTRIB_ID)); 
		
		// Now set values for sub-attributes of the trial info attribute
		// Save the official title
		AttributeType titleAttribType = metadataService.getAttributeType(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID);
		dataService.saveStringAttribute(titleAttribType, entityAttribute.getMyEntity(), title);
		
		// Save the purpose
		AttributeType purposeAttribType = metadataService.getAttributeType(TrialsConstants.TRIAL_PURPOSE_ATTRIB_ID);
		dataService.saveStringAttribute(purposeAttribType, entityAttribute.getMyEntity(), purpose);
		
		// Save the phase
		AttributeType phaseAttribType = metadataService.getAttributeType(TrialsConstants.TRIAL_PHASE_ATTRIB_ID);
		dataService.saveStringAttribute(phaseAttribType, entityAttribute.getMyEntity(), phase);
		
		// Save the molecule
		AttributeType moleculeAttribType = metadataService.getAttributeType(TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID);
		dataService.saveStringAttribute(moleculeAttribType, entityAttribute.getMyEntity(), molecule);
		
		// Save the status
		AttributeType statusAttribType = metadataService.getAttributeType(TrialsConstants.TRIAL_STATUS_ATTRIB_ID);
		dataService.saveStringAttribute(statusAttribType, entityAttribute.getMyEntity(), status);
		
		return entity.getId();
	}
	
	
	/**
	 * This routine is used to delete the selected trials
	 * 
	 * @param request
	 */
	private void deleteTrials(HttpServletRequest request) {
		String[] trialIds = null;
		if (request.getParameter("checkedTrialIds") != null) {
			trialIds = request.getParameterValues("checkedTrialIds");
		}
		
		if((trialIds != null) && (trialIds.length != 0)) {
			trialService.deleteTrials(trialIds);
		}
	}
	
	/**
	 * This routine is used to get the trials for the OL specified in the http request, 
	 * and set all those trials on the session object
	 * 
	 * @param request
	 */
	private void setTrialsForOl(HttpServletRequest request) {
		long kolId = Long.parseLong(request.getParameter("olId"));
		
		TrialOlMap [] trialOlMapArray = trialOlMapService.getAllTrialsForOl(kolId);
		ClinicalTrials [] trials = new ClinicalTrials[trialOlMapArray.length];
		
		for(int i=0;i<trialOlMapArray.length;i++){
			trials[i] = trialService.getTrialWithId(trialOlMapArray[i].getTrialId());
		}
		
		if(trials.length != 0){
			request.getSession().setAttribute("trials", trials);
			request.getSession().setAttribute("trialOlMapArray", trialOlMapArray);
		}

	}
	
	public ITrialOlMapService getTrialOlMapService() {
		return trialOlMapService;
	}
	
	public void setTrialOlMapService(ITrialOlMapService trialOlMapService) {
		this.trialOlMapService = trialOlMapService;
	}

	public ITrialService getTrialService() {
		return trialService;
	}

	public void setTrialService(ITrialService trialService) {
		this.trialService = trialService;
	}


	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}


	public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}


	public IPrivilegeService getPrivilegeService() {
		return privilegeService;
	}


	public void setPrivilegeService(IPrivilegeService privilegeService) {
		this.privilegeService = privilegeService;
	}
	
	public IDataService getDataService() {
		return dataService;
	}


	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}


	public IMetadataService getMetadataService() {
		return metadataService;
	}


	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}
}
