package com.openq.web.controllers;

import com.openq.kol.DBUtil;

public class Constants {
    // List of session variables
    public static final String CURRENT_USER = "currentUser";
    public static final String COMPLETE_USER_NAME = "completeUserName";
    public static final String ENTITY_TYPE_TREE_NODE = "entityTypeTreeNode";

    public static final String TREE_ROOT = "treeRoot";
    public static final String KOL_PROFILE_TREE = "KOLProfileTree";
    public static final String INSTITUTIONS_TREE = "Institutions";
    public static final String TRIALS_TREE = "Trials";

    public static final String ATTRIBUTE_FORM_OBJECT = "attributeFormObject";
    public static final String USER_ID = "userId";
    public static final String USER_TYPE = "userType";

    public static final String CURRENT_KOL_NAME = "currentKOLName";
    public static final String CURRENT_KOL_ID = "currentKOLId";
    public static final String CURRENT_KOL_ID_SET = "NONE";
    public static final String CURRENT_USER_TA = "currentUserTA";
    public static final String CURRENT_USER_TAS = "currentUserTAs";

    public static final String CURRENT_STAFF_ID = "currentStaffId";
    public static final String GROUP_FUNCTIONAL_AREA = "groupFunctionalArea";

    public static final String SAVED_ATTRIBUTE_MAP = "savedAttributeMap";
    public static final String ATTRIBUTE_MAP = "attributeMap";
    public static final String ATTRIBUTE_LIST = "attributeList";
    public static final String ALERT_NAME = "alertName";
    public static final String ATTRIBUTE_ALERT_MAP = "attributeAlertMap";
    public static final String GROUPS = "groups";
    public static final String ALERTS = "alerts";
    public static final String ALERT_OBJ = "alertObj";
    public static final String SAVED_RECIPIENT_MAP = "savedRecipientMap";
    public static final String ALERT_QUEUE = "alertQueue";
/* The survey Constants*/
    public static final String LIKERT4SCALE="agreement";
    public static final String LIKERT5SCALE="agreement5";
    public static final String MULTIOPTMULTISEL="multioptmultisel";
    public static final String MULTIOPTSISEL="multioptsinglesel";
    public static final String OPENTEXT="simpleText";
    public static final String NUMTEXT="numText";
    public static final String STRAGREE="Strongly Agree";
    public static final String AGREE="Agree";
    public static final String STRDISAGREE="Strongly Disagree";
    public static final String DISAGREE="Disagree";
    public static final String NEUTRAL="Neutral";
    public static final String CURRENT_USER_GROUP = "UserGroup";
    public static final String LAUNCHED ="Launched";
    public static final String MEDICAL_INTELLIGENCE ="Medical Intelligence";
    public static final String SURVEY_TYPE_INTERACTIONS="Interactions";
    public static final String DCI ="DCI";
    public static final long ADMIN_TYPE=1l;
    // Group Level Security Constants
    public static final long REPORT_PERMISSION_ID = 1L;
    public static final long LOV_VALUE_PERMISSION_ID = 2L;
    public static final long SURVEY_PERMISSION_ID = 3L;
    public static final long SEARCH_ATTRIBUTES_PERMISSION_ID = 4L;
    
    public static final String INTERACTION_ATTENDEE_TYPE = "AttendeeType";
    public static final String INTERACTION_RELATED_EVENTS = "RelatedEvent";

    // Interaction_Data table related constants
    
    public static final String INTERACTION_TYPE_LOV_TRIPLET_IDS = "interactionTypeLOVTripletIds";
    public static final String PRODUCT_MULTISELECT_IDS = "productMultiselectIds";
    public static final String INTENT_OF_VISIT = "intentOfVisit";
    public static final String UNSOLICTED_OFF_LABEL_CHECKBOX = "unsolicitedOffLabelCheckbox";
    public static final String SPEAKER_DECKS_MULTISELECT_IDS = "speakerDecksMultiselectIds";
    public static final String UNSOLICTED_OFF_LABEL_TRIPLET_IDS  = "unsolictedOffLabelTripletIds";
    public static final String EDUCATIONAL_OBJECTIVES_MULTISELECT_IDS = "educationalObjectivesMultiselectIds";
    public static final String SELECT_STUDY_MULTISELECT_IDS = "selectStudyMultiselectIds";
    public static final String PROACTIVE_INTENT_OF_VISIT = "Proactive";
    public static final String REACTIVE_INTENT_OF_VISIT = "Reactive";
    public static final String DISEASE_STATE_MULTISELECT_IDS = "diseaseStateMultiselectIds";
    public static final String PRODUCT_PRESENTATION_MULTISELECT_IDS = "ProductPresentationMultiselectIds";
    public static final String MIRF_MULTISELECT_IDS ="MIRFMultiselectIds";
    public static final String MEDICAL_PLAN_ACTIVITY="MedicalPlanActivityMultiSelectIds";
    // Interaction tagged data for reports
    
    /* These delimiters are used in populating the child LOVs through Ajax.
     * If any change is made to their values then please also change the 
     * values in populateChildLOV.js for the following variables  :
     * var jsGlobalVarDelimiterToSeparateValues = DELIMITER_TO_SEPARATE_VALUES and 
     * var jsGlobalVarDelimiterToSeparateSubValues = DELIMITER_TO_SEPARATE_SUBVALUES
     * For eg. their current values are :
     *  var jsGlobalVarDelimiterToSeparateValues = "`";
     *  var jsGlobalVarDelimiterToSeparateSubValues = "~";
     *  
     *   PS:- Be careful when you are using regular expression characters.
     *   You must escape it as it is done here with DELIMITER_TO_SEPARATE_VALUES.
     *   And in JavaScript you can directly use the character even if its regular expression character.
     */
    public static final String DELIMITER_TO_SEPARATE_VALUES = "`";
    public static final String DELIMITER_TO_SEPARATE_SUBVALUES = "~";
    
    // Joint Venture Constants
    public static final String SAXA_JV_GROUP_NAME = "SAXA_JV";
    public static final String IS_SAXA_JV_GROUP_USER = "isSAXAJVGroupUser";
    public static final String OTSUKA_JV_GROUP_NAME= "OTSUKA_JV";
    public static final String IS_OTSUKA_JV_GROUP_USER ="isOTSUKAGroupUser";
    
     
    // Reports related constants
    public static final long HQ_REPORT_LEVEL = 4L;
    public static final long TA_REPORT_LEVEL = 3L;
    public static final long RAD_REPORT_LEVEL = 2L;
    public static final long MSL_REPORT_LEVEL = 1L;
    public static final String GET_ALL_CHILD_LOVS = "getAllChildLOVs";
    
    public static final String CURRENT_USER_RELATIONSHIP = "currentUserRelationship";
    public static final String INTERACTION_NO_DATA_FOUND = "For the given search criteria, there is no match found";
    // Pagination constants
    public static final int MAX_NUM_USERS_PER_PAGE=25;
    public static final int HALF_BANDWIDTH=8;
    public static final String INTERACTION_PROFILE_KOLID = "interactionProfileKolId";
    public static final String INTERACTION_PROFILE_EXPERTID = "interactionProfileExpertId";
    public static final int LINKS_PER_PAGE = 15;
    public static final String PREV_SEARCH_RESULTS_START_LINK = "prevSearchResultsStartLink";
    public static final String NEXT_SEARCH_RESULTS_START_LINK = "nextSearchResultsStartLink";
    // error messages
    public static final String LOGIN_FAILED_MESSAGE = "Either your session has timed out or there was a problem with your Synergy request. Please click on the login button to log back in again";
    public static final String ACCESS_DENIED_MESSAGE = "You do not have access to the requested page. Please click on the login button to log back in again";
    // vCard Related
    public static final String VCARD_TEXT = "vCardText";
    public static final String SEARCH_HCP = "searchHCP";
    public static final String SPHERE_OF_INFLUENCE_SUFFIX = "Sphere of Influence";
    public static final String REGION_SUFFIX = "Region";
    public static final String SUB_REGION_SUFFIX = "Sub-Region";
    public static final String TA_AFFILIATIONS ="Affiliation";
    // TL Selection Criteria
    public static final String TL_REGION ="Region";
    public static final String TL_REGION_INTERCON ="Intercon";
    public static final String THOUGHT_LEADER_CRITERIA ="Thought Leader Criteria";
    public static final String SELECTION_CRITERIA_ANSWERS ="Selection Criteria Answers";
    
    public static final String EMPLOYEE_SEARCH_MESSAGE = "No result found";
    public static final String EDIT_NOTE_MESSAGE = "Double click on a line above to edit Scope Document Notes";
    public static final String UNSOLICITED_EDIT_NOTE_MESSAGE = "Double click on a line above to edit the Question";
    public static final long ADMIN_USER_TYPE = 1L;
    public static final long EXPERT_USER_TYPE = 4L;
    public static final long USER_USER_TYPE = 2L;
    public static final long FRONT_END_ADMIN_USER_TYPE = 650L;
    
    // Search Text
    public static final String SEARCH_TEXT_MESSAGE = "<Enter Last Name>";
    public static final String MEDICAL_MEETING_SAVE_MSG = "Medical Meeting details saved successfully ";
    
    public static final long SELECTION_CRITERIA_ATTRIBUTEID = 83396589L;
    public static final long TL_TYPE_ATTRIBUTEID = 83396591L;
    
    public static final String TL_TYPE_TL = "TL";
    public static final String TL_TYPE_HCP = "HCP";
    
    public static final long BMS_INFO_ENTITY_TYPE_ID = 83005800L;

    
    public static final long SELECTION_CRITERIA_ENTITYID = 83396588L;
   
    public static final String DEFAULT_MSL_OL_TYPE = "N/A";
    public static final long COUNTRY_LOV_ATTRIBUTE_ID = 6L;

}