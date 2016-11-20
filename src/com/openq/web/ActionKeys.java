package com.openq.web;

public interface ActionKeys {

    //KOL-Strategy related actions
    public static final String KOL_STRATEGY = "getKOLStrategy";
    public static final String KOL_SEGMENT_TREE = "getKOLSegmentTree";
    public static final String KOL_SET_SEGMENT = "getKOLSetSegment";
    public static final String KOL_KEY_MESSAGE = "getKOLKeyMessage";
    public static final String KOL_TACTICS = "getKOLTactics";
    public static final String KOL_MAIN_OBJECTIVES = "getKOLMainObjectives";
    public static final String KOL_MAIN_OBJECTIVES_ON_FILTER = "getKOLMainObjectivesOnFilter";
    public static final String KOL_NEW_NODE_PAGE = "createNodePage";
    public static final String KOL_ADD_NEW_NODE = "addNewNode";
    public static final String KOL_ADD_MATCHING_EXPERT = "addMatchingExpert";
    public static final String KOL_DELETE_EXPERT = "kolDeleteExpert";
    public static final String KOL_SHOW_DATA_FOR_TREE = "kolExpertsForSegment";
    public static final String KOL_DELETE_NODE = "kolDeleteNode";
    public static final String KOL_EDIT_NODE = "kolEditNode";
    public static final String KOL_SAVE_NODE = "kolSaveNode";
    public static final String KOL_VIEW_NODE = "kolViewNode";
    public static final String KOL_SHOW_DATA_FOR_ROOTNODE = "kolRootNode";
    public static final String KOL_BRAND_OBJECTIVES = "kolBrandObjectives";
    public static final String KOL_OBJECTIVES = "kolObjectives";
    public static final String KOL_UPDATE_SEGMENT = "kolUpdateSegment";
    public static final String KOL_SAVE_STRATEGY = "kolSaveStrategy";
    public static final String KOL_ADD_EXPERTS = "kolAddExperts";

    public static final String VIEW_KOL_KEY_MESSAGE = "viewKOLKeyMessage";
    public static final String ADD_KOL_KEY_MESSAGE = "addKOLKeyMessage";
    public static final String EDIT_KOL_KEY_MESSAGE = "editKOLKeyMessage";
    public static final String SAVE_KOL_KEY_MESSAGE = "saveKOLKeyMessage";
    public static final String DELETE_KOL_KEY_MESSAGE = "deleteKOLKeyMessage";

    public static final String VIEW_TACTICS = "viewTactics";
    public static final String ADD_TACTIC = "addTactic";
    public static final String EDIT_TACTIC = "editTactic";
    public static final String SAVE_TACTIC = "saveTactic";
    public static final String DELETE_TACTIC = "deleteTactic";
    public static final String GET_OBJECTIVES = "getObjectives";

    public static final String VIEW_MAIN_OBJECTIVE = "viewMainObjective";
    public static final String ADD_MAIN_OBJECTIVE = "addMainObjective";
    public static final String EDIT_MAIN_OBJECTIVE = "editMainObjective";
    public static final String SAVE_MAIN_OBJECTIVE = "saveMainObjective";
    public static final String DELETE_MAIN_OBJECTIVE = "deleteMainObjective";

    public static final String VIEW_SEGMENT_TACTIC = "viewSegmentTactic";
    public static final String ADD_SEGMENT_TACTIC = "addSegmentTactic";
    public static final String DELETE_SEGMENT_TACTIC = "deleteSegmentTactic";

    public static final String APPLY_SEGMENT_TACTIC = "applySegmentTactic";

    public static final String SHOW_SEGMENT_OBJECTIVES ="showSegmentObjectives";

    // KOL Capability related action Keys.
    public static final String VIEW_CAPABILITY = "viewCapability";
    public static final String ADD_CAPABILITY = "addCapability";
    public static final String EDIT_CAPABILITY = "editCapability";
    public static final String SAVE_CAPABILITY = "saveCapability";
    public static final String DELETE_CAPABILITY = "deleteCapability";

    //User Management related keys
    public static final String CREATE_USER = "createUser";
    public static final String UPDATE_USER = "updateUser";
    public static final String ADD_USER = "add";
    public static final String SEARCH_USER = "searchUser";
    public static final String EDIT_USER = "editUser";
    public static final String SAVE_USER = "saveUser";
    public static final String DELETE_USER = "deleteUser";
    public static final String ADV_SEARCH_USER = "advSearchUser";
    public static final String ADV_SEARCH_HOME = "advSearchHome";
    public static final String ADV_SEARCH_ORG ="OrgNameSearch";
    public static final String ADV_SEARCH_ORG_MAIN = "AdvOrgNameSearch";
    public static final String ADV_SEARCH_TRIAL = "TrialNameSearch";
    public static final String ADV_SEARCH_TRIAL_MAIN = "AdvTrialNameSearch";

    // Clinical Trials related keys
    public static final String CLINICAL_TRIAL_HOME = "ClinicalTrials";
    public static final String DELETE_CLINICAL_TRIALS = "deleteTrials";
    public static final String ADD_CLINICAL_TRIAL = "addTrial";
    public static final String SAVE_UPDATED_CLINICAL_TRIAL = "saveTrial";
    public static final String EDIT_CLINICAL_TRIAL = "editTrial";

    public static final String CALENDAR_DATE_FORMAT = "MM/dd/yyyy";

    //Expert search related keys
    public static final String EXPERT_SEARCH = "expertSearch";

    // Interaction related keys
    public static final String SHOW_ADD_INTERACTION = "showAddInteraction";
    public static final String EXPERT_SEARCH_INTERACTION = "expSearchInteraction";
    public static final String ADD_INTERACTION = "addInteraction";
    public static final String EDIT_INTERACTION = "editInteraction";
    public static final String UPDATE_INTERACTION = "updateInteraction";
    public static final String PROFILE_INTERACTION = "profileInteraction";
    public static final String SEARCH_INTERACTION = "searchInteractions";
    public static final String PROFILE_SHOW_ADD_INTERACTION = "profileShowAddInteraction";
    public static final String PROFILE_SHOW_EDIT_INTERACTION = "profileShowEditInteraction";
    public static final String PROFILE_ADD_INTERACTION = "profileAddInteraction";
    public static final String PROFILE_UPDATE_INTERACTION = "profileUpdateInteraction";
    public static final String PROFILE_INTERACTION_HOME = "profileInteractionHome";
    public static final String DELETE_INTERACTION = "deleteInteraction";
    public static final String BACK_TO_SEARCH_RESULTS = "backToSearchResults";

    public static final String SEARCH_ORG = "searchOrg";
    public static final String SEARCH_ORG_ON_PROFILE = "searchOrgOnProfile";

    //    development plan related action keys
    public static final String DEV_PLAN_HOME = "devPlanHome";
    public static final String ADD_DEV_PLAN = "addDevPlan";
    public static final String UPDATE_DEV_PLAN = "updateDevPlan";
    public static final String LIST_DEV_PLANS = "listDevPlans";
    public static final String EDIT_DEV_PLAN = "editDevPlan";
    public static final String DELETE_DEV_PLAN = "deleteDevPlan";

    //event related action keys
    public static final String SAVE_EVENT = "saveEvent";
    public static final String SEARCH_EVENT = "searchEvents";
    public static final String EDIT_EVENT = "editEvent";
    public static final String VIEW_EVENT = "viewEvent";
    public static final String EDIT_ATTENDEE = "editAttendee";
    public static final String SHOW_EVENTS_BY_EXPERT = "showEventsByExpert";
    public static final String DELETE_EVENT = "deleteEvent";

    //OLalignment related
    public static final String GET_EXPERTS = "getExperts";
    public static final String OLREALIGNMENT = "olRealignment";
    public static final String SAVE_OLS = "saveOLs";
    public static final String SAVE_REALIGNMENT_OLS = "saveRealignmentOLs";
    public static final String ALIGNMENT_PRINT = "alignmentPrint";
    public static final String REALIGNMENT_PRINT ="realignmentPrint";
    public static final String GET_OLS = "getOLs";
	public static final String RESET_ALIGN = "resetAlignment";
	public static final String RESET_REALIGN = "resetReAlignment";


	//Org Alignment Related
	public static final String GET_ORGS = "getOrgs";
	public static final String ORGREALIGNMENT = "orgRealignment";
	public static final String SAVE_ORGS = "saveOrgs";
	public static final String SAVE_REALIGNMENT_ORGS = "saveRealignmentOrgs";
	public static final String ORG_ALIGNMENT_PRINT = "orgAlignmentPrint";
	public static final String ORG_REALIGNMENT_PRINT = "orgRealignmentPrint";
	public static final String RESET_ORG_ALIGN = "resetOrgAlignment";
	public static final String RESET_ORG_REALIGN = "resetOrgReAlignment";
	public static final String ADD_ORG_TO_ALIGNMENT = "addOrgToAlignment";


    //ovid related action keys
    public static final String OVID_HOME = "ovidHome";
    public static final String OVID_SEARCH = "ovidSearch";
    public static final String COMMIT_DB = "commitDB";
    public static final String OVID_DATA_SOURCES = "ovidDataSources";
    public static final String OVID_SCHEDULE = "ovidScheduke";
    public static final String OVID_RESULTS = "ovidResults";
    public static final String REFRESH_PROFILES = "refreshProfiles";
    public static final String PUBLICATION_DETAILS = "publicationDetails";
    public static final String DELETE_PUBLICATION = "deletePublication";
    public static final String SHOW_ABSTRACT = "abstract";

    //Alerts related action keys
    public static final String ALERTS_STEP1 = "alertsStep1";
    public static final String ALERTS_STEP2 = "alertsStep2";
    public static final String ALERTS_STEP3 = "alertsStep3";
    public static final String ALERTS_STATUS = "alertsStatus";
    public static final String ALERTS_SAVE = "alertsSave";
    public static final String ALERTS_EDIT = "alertsEdit";
    public static final String ALERTS_DELETE = "alertsDelete";
    //Reports related action keys

    public static final String REPORT_GROUP = "reportGroup";
    public static final String REPORT_GROUP_MAP = "reportGroupMap";
    public static final String EXPORT_PDF = "exportToPdf";
    public static final String EXPORT_XLS = "exportToXls";
    public static final String EMAIL_REPORT = "emailReport";

    //Time Report related action keys
    public static final String DELETE_TIMEREPORT ="DeleteTimeReport";
    public static final String SEARCH_TIMEREPORT ="SearchTimeReport";
    public static final String SAVE_TIMEREPORT ="SaveTimeReport";

    // Feature permission related action keys
    public static final String GET_FEATURE_PERMISSION_DATA ="getFeaturePermissionData";
    public static final String SAVE_OR_DELETE_PERMISSION_USERGROUP_MAPPING ="saveOrDeletePermissionUsergroupMapping";

    // Default LOV value related action keys
    public static final String SET_DEFAULT_LOV_VALUE ="setDefaultDisplayValue";
    public static final String DELETE_DEFAULT_LOV_VALUE ="deleteDefaultDisplayValue";

    public static final String RESET_ADVANCE_SEARCH = "resetAdvanceSearch";
    public static final String VIEW_SURVEY_FROM_PROFILE = "viewProfileSurvey";
    public static final String VIEW_SURVEY_SPECIALTY_FORM = "viewSpecialtySurvey";
    public static final String SAVE_SPECIALTY_SURVEY = "saveSpecialtySurvey";

    //Registration for alerts related

    public static final String REGISTER = "register";
    public static final String DE_REGISTER = "deregister";
    //vCard related
    public static final String DOWNLOAD_VCARD = "downloadVcard";

    //Site Search Related
    public static final String ASSOCIATE_SITE = "associateSite";
    
    public static final String ALL_MEDICAL_MEETINGS = "getAllMedicalMeetings";
    public static final String FILTERED_MEDICAL_MEETINGS = "getFilteredMedicalMeetings";

} // end of ActionKeys Class
