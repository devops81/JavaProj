<%@ page import="com.openq.eav.option.OptionLookup, com.openq.interaction.Interaction, com.openq.attendee.Attendee, java.text.SimpleDateFormat, com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.openq.interactionData.InteractionData"%>
<%@ page import="java.util.*"%>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.web.ActionKeys" %>
<%@page import="com.openq.utils.PropertyReader"%>
<%@ page import="com.openq.eav.expert.ExpertDetails"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%
    java.util.Properties prop1 = DBUtil.getInstance().interactionProp;
    java.util.Properties featuresProfile = DBUtil.getInstance().featuresProp;

    OptionLookup attendeeTypeLookup[] = null;
    if (session.getAttribute("ATTENDEE_TYPE") != null) {
        attendeeTypeLookup = (OptionLookup[]) session.getAttribute("ATTENDEE_TYPE");
    }
    OptionLookup interactionTypeLookup[] = null;
    if (session.getAttribute("INTERACTION_TYPE") != null) {
        interactionTypeLookup = (OptionLookup[]) session.getAttribute("INTERACTION_TYPE");
    }
    OptionLookup productsLookup[] = null;
    if (session.getAttribute("PRODUCTS") != null) {
        productsLookup = (OptionLookup[]) session.getAttribute("PRODUCTS");
    }
    OptionLookup offLabelProductsLookup[] = null;
    if (session.getAttribute("OFF_LABEL_PRODUCTS") != null) {
    	offLabelProductsLookup = (OptionLookup[]) session.getAttribute("OFF_LABEL_PRODUCTS");
    }
    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
        message = (String) session.getAttribute("MESSAGE");
    }

    Interaction interaction = null;
    if (session.getAttribute("INTERACTION_DETAILS") != null) {
        interaction = (Interaction) session.getAttribute("INTERACTION_DETAILS");
        session.setAttribute("CREATE_TIME",interaction.getCreateTime());
      }
    long interactionId = 0;
    if (interaction != null) {
        interactionId = interaction.getId();
    }
    String mode = "";
    if (session.getAttribute("MODE") != null) {
        mode = (String) session.getAttribute("MODE");
    }
    // String used to disable elements if the mode is view
    boolean isViewModeOn = false;
    if("view".equalsIgnoreCase(mode)){
    	isViewModeOn = true;
    }
    String kolId = "";
    String kolName = "";
    String action = (String) request.getAttribute("ACTION");
    if (session.getAttribute(Constants.CURRENT_KOL_ID) != null && ActionKeys.PROFILE_SHOW_ADD_INTERACTION.equalsIgnoreCase(action)) {
        kolId = (String) session.getAttribute(Constants.CURRENT_KOL_ID);
    }
    if (session.getAttribute(Constants.CURRENT_KOL_NAME) != null && ActionKeys.PROFILE_SHOW_ADD_INTERACTION.equalsIgnoreCase(action)) {
        kolName = (String) session.getAttribute(Constants.CURRENT_KOL_NAME);
    }

    String kolid = (String) request.getAttribute("KOL_ID");
    String expertId = (String) request.getAttribute("EXPERT_ID");

    String orgId = null;
    if (session.getAttribute("ORGID") != null ){
        orgId = (String) session.getAttribute("ORGID");
    }
    String orgName = null;
    if (session.getAttribute("ORGNAME") != null ){
        orgName = (String)session.getAttribute("ORGNAME");
    }

    String presentLink = null;
    if (null != session.getAttribute("ORG_LINK")){
        presentLink = (String) session.getAttribute("ORG_LINK");
    }
    String mainLink = null;
    if (null != session.getAttribute("CURRENT_LINK")){
        mainLink = (String) session.getAttribute("CURRENT_LINK");
    }

/*Survey stuff
*/
    NewSurvey[] allSurveys = null;
    if(session.getAttribute("ALL_SURVEYS")!=null)
    {
      allSurveys = (NewSurvey[])session.getAttribute("ALL_SURVEYS");
    }
    Map surveyExpertIds =null;
    if(session.getAttribute("SURVEY_EXPERTS")!=null)
    {
     surveyExpertIds = (Map)session.getAttribute("SURVEY_EXPERTS");
    }
  Map attendeesMap = null;
  if(session.getAttribute("ATTENDEES_MAP")!=null)
  {
    attendeesMap = (Map)session.getAttribute("ATTENDEES_MAP");
  }

  ExpertDetails [] myOL = (ExpertDetails[]) request.getSession().getAttribute("myOL");
    ArrayList arr = new ArrayList();
    ArrayList arr1 = new ArrayList();
    int t = 0;
    arr.add("intType");
    arr.add("attendee");
    arr.add("relatedEvents");

    arr1.add("intType");
    arr1.add("attendee");
    arr1.add("relatedEvents");

  	if(surveyExpertIds!=null)
	{
	  arr.add("surveyType");
		arr1.add("surveyType");
	}
	Map surveyIdNameMap = new HashMap();
    boolean isAlreadySelected = false;

    Map auditMap = (Map) session.getAttribute("auditLastUpdated");
    final String LOV_VALUES_TO_EXCLUDE = PropertyReader.getLOVConstantValueFor("LOV_VALUES_TO_EXCLUDE");
%>
<%@page import="com.openq.survey.NewSurvey"%>

<link href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<link href="css/openq.css" type=text/css rel=stylesheet>
<link rel="stylesheet" href="css/Autocompleter.css" type="text/css"/>

<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js"></script>
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript" src="js/newcalendar.js"></script>
<script type="text/javascript" src="js/json.js"></script>
<script type="text/javascript" src="js/utilities/JSONError.js"></script>
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<script language="Javascript" src = "<%=COMMONJS%>/listbox.js"></SCRIPT>
<script language="javascript" src="js/subsection.js"></script>
<script language="javascript" src="js/populateChildLOV.js"></script>
<script language="javascript" src="js/validation.js"></script>

<script language="javascript">

function saveInteractionReset(){
  var resetInteractionForm = document.getElementById("resetInteractionForm");
  resetInteractionForm.value = "true";
  saveInteraction();
}

function collapseAll(){
     var thisform = document.addInteractionForm;
    var secNamesNew = thisform.divArray2.value;
    var secNames = secNamesNew.split(",");

    for(i = 0; i < secNames.length; i++)
    {
        var image = dojo.byId(secNames[i] + "Img");
        var content = dojo.byId(secNames[i] + "Content");
        dojo.fx.wipeOut({
          node: content,
          duration:200
        }).play();
        image.src="images/buttons/plus.gif";

    }
}

function saveInteraction() {

    if(window.event.keyCode == 0 || window.event.keyCode == 13) {
        var thisform = document.addInteractionForm;

        if (thisform.interactionDate.value == "") {
            alert("Please enter the Interaction Date");
            enableButton();
            return false;
        }
		if( thisform.interactionActivitiesTriplet != null &&
			thisform.interactionActivitiesTriplet != undefined &&
			thisform.interactionActivitiesTriplet.options.length > 0){

			var triplet = thisform.interactionActivitiesTriplet.options[0].id;
			if(triplet != null && triplet != undefined && triplet != ""){
				var selectedIds = triplet.split(jsGlobalVarDelimiterToSeparateSubValues);
				if(selectedIds != null && selectedIds != undefined && selectedIds.length >0)

				// set the value in a hidden parameter to pass the interactionTypeId to controller
           		thisform.interactionTypeId.value = selectedIds[0];
			}
  		}
        if (thisform.attendeeList.length > 0) {
            for (var i=0;i<thisform.attendeeList.length;i++) {
                thisform.attendeeList.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.attendeeInfo!=null && thisform.attendeeInfo.length > 0) {
            for (var i=0;i<thisform.attendeeInfo.length;i++) {
                thisform.attendeeInfo.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.attendeeList.value == "") {
            alert("Please add either an <%=DBUtil.getInstance().doctor%> Attendee or an Organization Attendee");
            enableButton();
            return false;
        }
        var tripletIds = getCommaSeparatedMultiselectIds('interactionActivitiesTriplet');
        if(tripletIds != ""){
	  		thisform.interactionTypeLOVTripletIds.value = tripletIds;
	  	}else{
	  		alert('Please enter an interaction topic and sub-topic');
			thisform.interactionType.focus();
			enableButton();
            return false;
	  	}
	  	var productIds = getCommaSeparatedMultiselectIds('productMultiSelect');
     	if(productIds != ""){
	  		thisform.productMultiselectIds.value = productIds;
	  	}else{
	  		alert('Please choose at least one product');
			thisform.productLOV.focus();
			enableButton();
            return false;
	  	}
	  	if(thisform.intentOfVisit != null && thisform.intentOfVisit != undefined){
	  		var isRadioButtonChecked = false;
	  		for(var i=0; i<thisform.intentOfVisit.length; i++){
	  			if(thisform.intentOfVisit[i].checked){
	  				isRadioButtonChecked = true;
	  				break;
	  			}
	  		}
	  		if(!isRadioButtonChecked){
	  			alert("Please choose the Intent of Interaction");
	  			enableButton();
	  			return false;
	  		}
	  	}
		// set the survey data in a hidden variable
   		 	surveyObjToString();
	  	// if section is visible then atleast 1 value has to be selected.
	  	var visibleSectionHasValues = setHiddenParameterValues('speakerTrainingSection', 'speakerTrainingMultiSelect', 'Speaker Training', thisform.speakerDecksMultiselectIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   		  enableButton();
   			return;
   			}

   		visibleSectionHasValues = setHiddenParameterValues('educationalDialogSection', 'educationalObjectivesMultiSelect', 'Educational Dialog', thisform.educationalObjectivesMultiselectIds, false);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

		visibleSectionHasValues = setHiddenParameterValues('medicalPlanActivitySection', 'medicalPlanMultiSelect', 'Medical Plan Activities',thisform.medicalPlanActivitiesMultiselectIds, false);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

   		visibleSectionHasValues = setHiddenParameterValues('unsolictedOffLabelSection', 'unsolicitedOffLabelTriplet', 'Unsolicted Off Label', thisform.unsolictedOffLabelTripletIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

   		visibleSectionHasValues = setHiddenParameterValues('clinicalTrialVisitSection', 'selectStudyMultiSelect', 'Clinical Trial Visit', thisform.selectStudyMultiselectIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

   		visibleSectionHasValues = setHiddenParameterValues('diseaseStateSection', 'diseaseStateMultiSelect', 'Disease State', thisform.diseaseStateMultiselectIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

   		visibleSectionHasValues = setHiddenParameterValues('productPresentationSection', 'productPresentationMultiSelect', 'Product Presentation', thisform.productPresentationMultiselectIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}
   		visibleSectionHasValues = setHiddenParameterValues('MIRFSection', 'MIRFMultiSelect', 'Medical Info Request Followup (Trechnet)', thisform.MIRFMultiselectIds, true);
   		if(!visibleSectionHasValues){ // section is empty, return so that user can select a value
   			enableButton();
   			return;
   			}

        if (<%=interactionId%> == 0) {
        thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_ADD_INTERACTION%>&intType=<%=request.getParameter("intType")%>";
    } else {
        thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_UPDATE_INTERACTION%>&intType=<%=request.getParameter("intType")%>";
    }
       thisform.submit();
        return;
    }
}
function setHiddenParameterValues(sectionId, multiselectId, sectionName, hiddenParameter, isMandatorySection){
 	if(isSectionVisible(sectionId)){
 		var lovIds = getCommaSeparatedMultiselectIds(multiselectId);
		if(lovIds != ""){
			hiddenParameter.value = lovIds;
			return true;
		}else if(isMandatorySection){
			alert('Please select at least 1 value in the \''+sectionName+'\' section');
			return false;
		}
	}
	return true;
}
var confirmationMessage = 'Please save your work before continuing.  This button will navigate you to a different page and any unsaved changes will be lost. Do you want to continue?';
function searchInteractions() {
	var proceedFlag = true;
	if(!<%=isViewModeOn%>){
		proceedFlag = confirm(confirmationMessage);
	}
    if(proceedFlag){
	    var thisform = document.addInteractionForm;
	    thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm";
	    thisform.target = "_top";
	    thisform.submit();
    }
}

function searchMyInteractions() {
	var proceedFlag = true;
	if(!<%=isViewModeOn%>){
		proceedFlag = confirm(confirmationMessage);
	}
    if(proceedFlag){
	    var thisform = document.addInteractionForm;
	    thisform.action = "<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.PROFILE_INTERACTION%>";

	    thisform.submit();
    }
}
function backToSearchResults() {
	var proceedFlag = true;
	if(!<%=isViewModeOn%>){
		proceedFlag = confirm(confirmationMessage);
	}
    if(proceedFlag){
	    var thisform = document.addInteractionForm;
	    thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm?action=<%=ActionKeys.BACK_TO_SEARCH_RESULTS%>";

	    thisform.submit();
    }
}
var expandAllSectionsFlag = true;
function toggleAll(rootImageId, toggleClassName){
    var image = dojo.byId(rootImageId);
    if(expandAllSectionsFlag){
        image.src="images/buttons/minus.gif";
        expandAllSectionsFlag = false;
        openAllSections(toggleClassName);
    } else {
        image.src="images/buttons/plus.gif";
        expandAllSectionsFlag = true;
        closeAllSections(toggleClassName);
    }
}
/*
dojo.addOnLoad(function(){
  closeAllSections("colContent");
  //setTimeout("openSection('intType')", 1);
  //setTimeout("openSection('att')", 1);
  // Interaction Header and Attendee section visible on load.
  openSection('intType');
  openSection('att');
});
*/
function openSurvey(i){
  var thisform = document.addInteractionForm;
  if (thisform.attendeeList.value == "") {
       alert('Please add an Attendee(s) first');
       return false;
  }
  var interactionId = thisform.interactionId.value;
  var selectElement = document.getElementById('surveySelect'+i)//thisform.surveySelect;
  if(selectElement!=null&&selectElement.selectedIndex!=-1){
     var selectedValue = selectElement.options[selectElement.selectedIndex].value;
	 win = window.open('survey.htm?action=viewSurvey&interactionId='+interactionId+'&surveyId='+selectedValue,'viewSurveyNew','width=1024,height=768,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');

  }
}
var surveyFilled = null
var surveyFilledIdsArray = new Array()
var surveyFilledArray = new Array()
var editSurveyGlobal = new Array()
function getSurveyArray()
{
 return surveyFilledIdsArray;
}

function surveyObjToString()
{
if(editSurveyGlobal!=null && editSurveyGlobal.length>0)
 {

     for(var i=0;i<editSurveyGlobal.length;i++)
	 {
         var expertsArray = editSurveyGlobal[i].experts
        if(expertsArray!=null)
        {
         for(var j=0;j<expertsArray.length;j++)
		{
		  var jsonText = expertsArray[j].jsonText
          var surveyObject = JSON.parse(jsonText);
          expertsArray[j].surveyId = editSurveyGlobal[i].surveyId
          expertsArray[j].questions = surveyObject.questionObjects
		  delete expertsArray[j].jsonText
		  delete expertsArray[j].expertName
		}
       }
	 }
   var editSurveyGlobalObject = editSurveyGlobal.toJSONString()
 document.addInteractionForm.surveyEditAnswersFilled.value = editSurveyGlobalObject
 editSurveyGlobal.splice(0,editSurveyGlobal.length)
 }

}

function deleteAllSurveys(){
 editSurveyGlobal.splice(0,editSurveyGlobal.length);
 populateSurveySelect();
 populateAttendeesSelect(0);
}
function setSurveyFilled(obj)
{
  surveyFilled = obj;
  try{
      var surveyFilledObject = surveyFilled.parseJSON()//JSON.decode(surveyFilled)
	   if(surveyFilledObject!=null)
		 {
	        var surveyId = surveyFilledObject.surveyId
			var expertId = surveyFilledObject.expertId
			surveyFilledIdsArray.push(surveyId+'|'+expertId)
			surveyFilledArray.push(surveyFilledObject)
			var questionsObj = surveyFilledObject.questions
		 }
  }
  catch(e)
 {
   alert(e)
  }
}

function getAddedAttendeesArray()
{
   var thisform = document.addInteractionForm;
   var attendeesObj=thisform.attendeeList;
   var attendeeArrayToReturn = new Array();
   for(var i=0;i<attendeesObj.length;i++)
	{
	   var val=attendeesObj[i].value;
	   var text=attendeesObj.text;
       attendeeArrayToReturn.push(val);
	}
  	return attendeeArrayToReturn;
}
function getEventsForInteraction(fromDate) {
	if(fromDate == null || fromDate == "") {
		alert("Please Enter interaction date to get Medical Meetings related to this interaction");
	}
	else {
		document.getElementById("resetEvent").value="false";
		window.open('eventsList.htm?fromSearch=true&interactionDate='+fromDate,'searchOrg','width=720,height=450,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
	}
}
  function addMyOL(){
       var selValue = document.getElementById("myOlList").options[document.getElementById("myOlList").selectedIndex].value;
       if(selValue!=-1){
          var arrayOfCheckedAttendee = new Array();
          arrayOfCheckedAttendee.push(selValue.toString());
          addORXName(arrayOfCheckedAttendee);
       }
       else{
          alert("Select a Option From My <%=DBUtil.getInstance().doctor%> List");
       }
   }
function addEditSurveyObject(editSurveyObject)
{
  editSurveyGlobal.push(editSurveyObject)
}
function setNewSurvey(surveyObject,expertObj,jsonText)
{

var newSurveyObject = null
var expertIdArray = null
var newSurvey = 'true'
if(editSurveyGlobal!=null&&editSurveyGlobal!=undefined){
for(var i=0;i<editSurveyGlobal.length;i++)
{
  if(editSurveyGlobal[i].surveyId==surveyObject.id)
  {
   newSurveyObject = editSurveyGlobal[i]
   expertIdArray = editSurveyGlobal[i].experts
   newSurvey ='false'
   }
}
}
if(newSurvey=='true')
	{
	newSurveyObject = new Object()
	newSurveyObject.surveyId = surveyObject.id
    newSurveyObject.surveyName = surveyObject.title
    expertIdArray = new Array()

	}
var expertObject = new Object()
expertObject.expertId = expertObj.split("_")[1]
expertObject.expertName = expertObj.split("_")[2]
expertObject.jsonText = jsonText
expertIdArray.push(expertObject)
surveyFilledIdsArray.push(newSurveyObject.surveyId+'|'+expertObject.expertId)
newSurveyObject.experts = expertIdArray
if(newSurvey=='true')
{
addEditSurveyObject(newSurveyObject)
}
populateSurveySelect()
populateAttendeesSelect(0)
}

function setEditSurveyFilled(surveyId,expertId,questionJsonText)
{
  try{
 	   for(var i=0;i<editSurveyGlobal.length;i++)
			{
			   if(surveyId==editSurveyGlobal[i].surveyId)
				   {
			         var expertIdsArray = editSurveyGlobal[i].experts
                      for(var j=0;j<expertIdsArray.length;j++)
						 {
					       if(expertId==expertIdsArray[j].expertId)
							   {
								 expertIdsArray[j].jsonText= questionJsonText
							   }
						 }
				   }
			}
     populateSurveySelect()
     populateAttendeesSelect(0)

	 }catch(e)
		 {}
}



function populateSurveySelect()
{
   var oSelect = document.getElementById('editSurveySelect')
  if(oSelect!=null){
  var optionsArr = oSelect.options;
   if(optionsArr!=null&&optionsArr.length>0)
	 {
	   var len = optionsArr.length;
	   for(var j=len-1;j>0;j--)
		  {
		   oSelect.remove(j)
		   }
	 }

   for(var i = 0;i<editSurveyGlobal.length;i++)
   {
	var oOption = document.createElement("OPTION");//Create the option element
    oOption.text = editSurveyGlobal[i].surveyName;
    oOption.value = editSurveyGlobal[i].surveyId;
    oSelect.add(oOption)
   }
 }
}

function populateAttendeesSelect(selectIndex)
{
var oSelect = document.getElementById('attendeeSelect')
var optionsArr = oSelect.options;
 if(optionsArr.length>0)
	 {
	   var len = optionsArr.length;
	   for(var j=len-1;j>0;j--)
		  {
		   oSelect.remove(j)
		   }
	 }
if(selectIndex>-1)
	{
    var surveyObjSelected = editSurveyGlobal[selectIndex]
	if(surveyObjSelected!=null)
	{
	  var expertsArray = surveyObjSelected.experts
     if(expertsArray!=null)
     {
     	for(var i=0;i<expertsArray.length;i++)
		{
		  var oOption = document.createElement("OPTION");//Create the option element
          oOption.text = expertsArray[i].expertName;
          oOption.value = expertsArray[i].jsonText;
          oSelect.add(oOption)
		}
      }
	}
   }

 }


function toPopulateEditSurvey()
{
 var oSelect = document.getElementById('editSurveySelect')
 var selectedSurvey = oSelect.options[oSelect.selectedIndex].value
 var oSelectAttendee = document.getElementById('attendeeSelect')
 var selectedAttendee = oSelectAttendee.options[oSelectAttendee.selectedIndex].value
}

var currEditSurveyText = ''
function editSurvey()
{
 var oSelect = document.getElementById('editSurveySelect')
 var selectedSurvey = oSelect.options[oSelect.selectedIndex].value
 var oSelectAttendee = document.getElementById('attendeeSelect')
 var selectedJsonText = oSelectAttendee.options[oSelectAttendee.selectedIndex].value
 var interactionId = document.forms['addInteractionForm'].interactionId.value;
 var surveyObjSelected = editSurveyGlobal[(oSelect.selectedIndex)-1]
var expertsArray = surveyObjSelected.experts
 if(expertsArray!=null)
   {
     var expertId = (expertsArray[oSelectAttendee.selectedIndex-1].expertId)
 var thisform = document.forms["editSurveyDummyForm"];
 thisform.answersJsonText.value = selectedJsonText
 thisform.expertId.value = expertId
 thisform.surveyId.value = selectedSurvey
 thisform.interactionId.value = interactionId
 thisform.submit();
	}
}
/*Clear the selected events*/
function clearEvents()
{
document.getElementById("selectedEvent").value = "";
document.getElementById("eventDate").value="";
document.getElementById("eventId").value="";
document.getElementById("eventLocation").value="";
document.getElementById("resetEvent").value="true";
}
var javascriptTripletSectionMap = {
  put : function(foo,bar) {this[foo] = bar;},
  get : function(foo) {return this[foo];}
}
<%

Map interactionTripletSectionMap = new HashMap();
if(session.getAttribute("INTERACTION_LOVTRIPLET_SECTION_MAP") != null ){
	interactionTripletSectionMap = (Map) session.getAttribute("INTERACTION_LOVTRIPLET_SECTION_MAP");
}
if(interactionTripletSectionMap != null ){
	Iterator it = interactionTripletSectionMap.entrySet().iterator();
    while (it.hasNext()) {
        Map.Entry pairs = (Map.Entry)it.next();
%>
javascriptTripletSectionMap.put('<%=pairs.getKey()%>','<%=pairs.getValue()%>');
<%
    }
}
	String speakerDecksLOVName = PropertyReader.getLOVConstantValueFor("SPEAKER_DECKS");
	String educationalObjectivesLOVName = PropertyReader.getLOVConstantValueFor("EDUCATIONAL_OBJECTIVES");
	String medicalObjectivesLOVName = PropertyReader.getLOVConstantValueFor("MEDICAL_OBJECTIVES");
	String dialogObjectivesLOVName = PropertyReader.getLOVConstantValueFor("DIALOG_OBJECTIVES");
	String sourceReferencedLOVName = PropertyReader.getLOVConstantValueFor("SOURCE_REFERENCED");
%>
jsGlobalVarDelimiterToSeparateValues = '<%=Constants.DELIMITER_TO_SEPARATE_VALUES%>'; // will store the delimiter used to separated the values or ids
jsGlobalVarDelimiterToSeparateSubValues = '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>'
function addProduct(productLOVName, productMultiselectName) {
	var productLOV = document.getElementById(productLOVName);
	var interactionProduct = document.getElementById(productMultiselectName);
	if(interactionProduct != null && interactionProduct.length == 3){
		alert("Cannot add more than 3 products.");
		return false;
	}
	var isSuccess = addTOMultipleSelect(productLOVName, productMultiselectName);
	if(isSuccess){
		populateChildLOV(productLOV, 'speakerDecksLOV', false, '<%=speakerDecksLOVName%>');
		populateChildLOV(productLOV, 'educationalObjectivesLOV', false, '<%=educationalObjectivesLOVName%>');
	}
}
function deleteProduct(productLOVName, productMultiselectName) {
	var deletedIds = deleteFromMultipleSelect(productMultiselectName);
	if( deletedIds != "" ){
		var deletedIdsArray = deletedIds.split(jsGlobalVarDelimiterToSeparateValues);
		for(var i=0; i<deletedIdsArray.length; i++){
			// Remove deleted product dependent lov values from the multi-select
			deleteFromMultipleSelectById('speakerTrainingMultiSelect', deletedIdsArray[i]);
			deleteFromMultipleSelectById('educationalObjectivesMultiSelect', deletedIdsArray[i]);
			// Remove the values from the existing LOVs for the product
			removeExistingChildLOVById('speakerDecksLOV', deletedIdsArray[i]);
			removeExistingChildLOVById('educationalObjectivesLOV', deletedIdsArray[i]);
		}
	}
}
function addLOVTripletToMultiselect(rootLOV, levelOneLOV, levelTwoLOV, multiSelectName, isInteractionTriplet) {
	var thisform = document.addInteractionForm;
	addLOVTriplet(rootLOV, levelOneLOV, levelTwoLOV, multiSelectName, isInteractionTriplet);

	// show/update initial intent of interaction section
	if( thisform.interactionActivitiesTriplet != null &&
		thisform.interactionActivitiesTriplet != undefined && thisform.interactionActivitiesTriplet.options.length == 1){

		showInitialIntentOfVisitSection(false);
	}

}
function deleteLOVTripletFromMultiselect(multiSelectName){
	var thisform = document.addInteractionForm;
	deleteLOVTriplet(multiSelectName);

	// show/update initial intent of interaction section
	if( thisform.interactionActivitiesTriplet != null &&
		thisform.interactionActivitiesTriplet != undefined &&
		thisform.interactionActivitiesTriplet.options.length <=1){

		showInitialIntentOfVisitSection(false);
	}
}
function closeRequiredSections(sectionClass){
  dojo.query("."+sectionClass).forEach(
    function (contentDiv){
      var sectionId = contentDiv.id.replace("Content","");
	  /* Interaction Header and Attendee section visible on load.
	  	 Add the id of the sections that should remain open by default
	  */
      if(sectionId != 'intType' &&
    	      sectionId != 'att' && sectionId != 'medicalPlanActivity'){
      	closeSection(sectionId);
      }
    }
  );
}
function showRequiredSections(){
	  closeRequiredSections("colContent");
	/* if the mode is view then disable all the elements
	which can let a user modify data */
	if(<%=isViewModeOn%>){
		disableAllElements();
	}
	var multiSelect =  document.getElementById('interactionActivitiesTriplet');
	if( multiSelect != null && multiSelect != undefined ){
		for (var i=multiSelect.options.length-1; i>-1; i--){
			if(javascriptTripletSectionMap != null &&
				javascriptTripletSectionMap.get(multiSelect.options[i].id) != null){
				// section dependent on triplet
				showHiddenSection(javascriptTripletSectionMap.get(multiSelect.options[i].id));
			}
		}
	}
	// if the unsolicitedOffLabelCheckbox is checked then show the Unsolicted Off Label section
	var unsolicitedOffLabelCheckbox = document.getElementById('unsolicitedOffLabelCheckbox');
	if(unsolicitedOffLabelCheckbox != null && unsolicitedOffLabelCheckbox != undefined && unsolicitedOffLabelCheckbox.checked)
		showHiddenSection('unsolictedOffLabelSection');

	// show initial intent of interaction section
	showInitialIntentOfVisitSection(true);
}
/* This function disables all the elements in a page or a form */
function disableAllElements(){
	// var allElementsInDocument = document.getElementsByTagName("*"); // for whole page
	var allElementsInDocument = document.addInteractionForm.getElementsByTagName("*");
    for(var i=allElementsInDocument.length-1; i>-1; i--) {
        var element = allElementsInDocument[i];
        if(element.id == 'searchOLInteractionButton' ||
        	element.id == 'searchInteractionButton' ||
        	element.id == 'backToSearchResultsButton' ||
        	element.type == 'select-multiple' ||
        	element.className == 'toggleImg'){ // do not disable search buttons
        	continue;
        }
        element.onclick = function(){return false}; // disable all onclick events
        if(element.type == 'select-one' || // drop-down
            //element.type == 'select-multiple' ||
            element.type == 'radio' ||
            element.type == 'checkbox' ||
            element.type == 'button' ||
            element.type == 'text' ||
            element.type == 'textarea' ||
            element.type == 'input'){
		 		element.disabled = true;
		 }
    }
}
function populateProductdependentLOVs(){
var productMultiselect = document.getElementById('productMultiSelect');
	if(productMultiselect != null){
		for (var i=productMultiselect.options.length-1; i>-1; i--) {
			populateChildLOVById(productMultiselect.options[i].id, 'speakerDecksLOV', false, '<%=speakerDecksLOVName%>');
			populateChildLOVById(productMultiselect.options[i].id, 'educationalObjectivesLOV', false, '<%=educationalObjectivesLOVName%>');
		}
	}
}

<% String activityTypeLOVName = PropertyReader.getLOVConstantValueFor("ACTIVITY_TYPE"); %>
/* Dummy arguments are passed to this function to make it consistent with the onchange property
of other LOVs. For every other LOV the on change function is :
populateChildLOV(selectedLOV, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName);
But, due to some new requiremnet we need to check which radio button is checked from the
Intent of Interaction radio buttons before populating the Interaction Topic LOV.
Therefore, the onchange property of the Interaction Type LOV is changed.


IMP : We pull the child LOV name from the onchange property of the LOVs in the
deleteChildRecordsCascade function.
Therefore, it is required that the onchange property of the Interaction Type LOV should
have the arguments in the format in which other lovs have.
*/
function checkAndPopulateInteractionTopic(selectedLOV, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName){
	/*check if intent of Interaction radio buttons
	are checked or not. Depending on the checked
	button we are required to filter some values from
	the populated LOV
	*/
	var intentOfVisit = getCheckedRadioValue();
	// populate the LOV
	populateInteractionTopicLOV(intentOfVisit);

}
function showInitialIntentOfVisitSection(populateInteractionTopicFlag){
	var thisform = document.addInteractionForm;
	var intentOfVisit = getCheckedRadioValue();

 	if(intentOfVisit == '') // intentOfVisit radio button is not checked
 		return false;

	if(intentOfVisit != ''){
		/* Repopulate the Topic LOV to exclude/include some LOV values
		if populateInteractionTopicFlag flag is true */
		if(populateInteractionTopicFlag){
			populateInteractionTopicLOV(intentOfVisit);
		}
		var interactionTopic = getFirstInteractionTopic();
		var initialIntentOfVisitRadioTd = document.getElementById('initialIntentOfVisitRadioTd');
		var initialIntentOfVisitTopicTd = document.getElementById('initialIntentOfVisitTopicTd');
		initialIntentOfVisitRadioTd.innerText = intentOfVisit;
		initialIntentOfVisitTopicTd.innerText = interactionTopic;
		showHiddenSection('initialIntentOfVisitSection');
	}
}
function getCheckedRadioValue(){
	var thisform = document.addInteractionForm;
	var intentOfVisit = '';
  	if(thisform.intentOfVisit != null && thisform.intentOfVisit != undefined){
 		for(var i=0; i<thisform.intentOfVisit.length; i++){
 			if(thisform.intentOfVisit[i].checked){
 				intentOfVisit = thisform.intentOfVisit[i].value;
 				break;
 			}
 		}
 	}
 	return intentOfVisit;
}
function getFirstInteractionTopic(){
 	var thisform = document.addInteractionForm;
	var interactionTopic = '';
	var interactionActivitiesTriplet =  thisform.interactionActivitiesTriplet;
	if( interactionActivitiesTriplet != null &&
		interactionActivitiesTriplet != undefined &&
		interactionActivitiesTriplet.options.length > 0){
		var triplet = interactionActivitiesTriplet.options[0].value;
		if(triplet != null && triplet != undefined && triplet != ""){
			var selectedValues = triplet.split(jsGlobalVarDelimiterToSeparateSubValues);
			if(selectedValues != null && selectedValues != undefined && selectedValues.length >1)
				interactionTopic = selectedValues[0];
		}
	}
	return interactionTopic;
}
function populateInteractionTopicLOV(intentOfVisit){
	var thisform = document.addInteractionForm;

	if('<%=Constants.PROACTIVE_INTENT_OF_VISIT %>' == intentOfVisit){
		populateChildLOV(thisform.interactionType, 'activityTypeLOV', true, '<%=activityTypeLOVName%>', "<%=LOV_VALUES_TO_EXCLUDE%>");
		// also make sure that the excluded values are deleted from the interaction multiselect
		var interactionActivitiesTriplet =  thisform.interactionActivitiesTriplet;
		for (var i=interactionActivitiesTriplet.options.length-1; i>-1; i--) {
			if( interactionActivitiesTriplet != null &&
				interactionActivitiesTriplet != undefined && interactionActivitiesTriplet.options.length > 0){
				var triplet = interactionActivitiesTriplet.options[i].value;
				if(triplet != null && triplet != undefined && triplet != ""){
					var selectedValues = triplet.split(jsGlobalVarDelimiterToSeparateSubValues);
					if(selectedValues != null && selectedValues != undefined && selectedValues.length >1)
						interactionTopic = "'" + selectedValues[0] + "'";
						var valuesToExclude = "<%=LOV_VALUES_TO_EXCLUDE%>";
						if(valuesToExclude.indexOf(interactionTopic) > -1){
							interactionActivitiesTriplet.options[i] = null;
						}
				}
			}
		}
	}else{
		populateChildLOV(thisform.interactionType, 'activityTypeLOV', true, '<%=activityTypeLOVName%>');
	}
}
function openNewWindow()
{
	//alert('opening new window');
	var win = window.open('','viewSurvey','width=1024,height=768,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
}

function windowOpen()
{
 win =
	 window.open('','viewSurvey','width=1024,height=768,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
win.focus();
}
function showToolTip(object){
	if(object != null && object != undefined){
		var selectedIndex = object.selectedIndex;
		if(selectedIndex > -1){
			Tip(object.options[selectedIndex].innerText, FIX, [object.id, 0, 0], WIDTH, object.offsetWidth-10);
		}
	}
}

function reSizeLOV() {
	var selectElement = document.getElementById("dialogObjectivesLOV");
	selectElement.style.width=document.body.clientWidth-150;
}

function editNotes(multiSelectObj,editNotes,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton){
	if(multiSelectObj != null &&
			multiSelectObj != undefined){
		var editNotes = document.getElementById(editNotes);
		if(editNotes != undefined){
			var selectedValue = multiSelectObj.options[multiSelectObj.selectedIndex].value;
			if(selectedValue != undefined){
				var tripletArray = selectedValue.split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				if(tripletArray != undefined && tripletArray.length > 2){
					editNotes.value = tripletArray[2];
					limitChars( editNotes, editNotes.id+'CharLimit', -1, false);
					// show the edit notes text area
					showEditNoteSection(true,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton);
				}
			}
		}
	}
}

function editNotesForQuartet(multiSelectObj,editNotes,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton){
	if(multiSelectObj != null &&
			multiSelectObj != undefined){
		var editNotes = document.getElementById(editNotes);
		if(editNotes != undefined){
			var selectedValue = multiSelectObj.options[multiSelectObj.selectedIndex].value;
			if(selectedValue != undefined){
				var quartetArray = selectedValue.split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				if(quartetArray != undefined && quartetArray.length > 3){
					editNotes.value = quartetArray[3];
					limitChars( editNotes, editNotes.id+'CharLimit', -1, false);
					// show the edit notes text area
					showEditNoteSection(true,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton);
				}
			}
		}
	}
}

function saveEditedNote(multiSelect,editNotes,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton){
	var selectStudyMultiSelect = document.getElementById(multiSelect);
	var clinicalTrialEditNotes = document.getElementById(editNotes);

	if(clinicalTrialEditNotes != undefined &&
			selectStudyMultiSelect != undefined){
		var editedNote = clinicalTrialEditNotes.value;

		if(editedNote != undefined && editedNote != '' ){
			var selectedOption = selectStudyMultiSelect.options[selectStudyMultiSelect.selectedIndex];

			if(selectedOption != undefined){
				var oldIdArray = (selectedOption.id).split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				var oldValueArray = (selectedOption.value).split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				selectedOption.id = oldIdArray[0] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' +
							oldIdArray[1] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + editedNote;
				selectedOption.value = oldValueArray[0] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' +
							   oldValueArray[1] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + editedNote;
				selectedOption.innerText = selectedOption.value;
			}
		}
	}
	showEditNoteSection(false,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton);
}

function saveEditedNoteForQuartet(multiSelect,editNotes,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton){
	var selectStudyMultiSelect = document.getElementById(multiSelect);
	var clinicalTrialEditNotes = document.getElementById(editNotes);

	if(clinicalTrialEditNotes != undefined &&
			selectStudyMultiSelect != undefined){
		var editedNote = clinicalTrialEditNotes.value;

		if(editedNote != undefined && editedNote != '' ){
			var selectedOption = selectStudyMultiSelect.options[selectStudyMultiSelect.selectedIndex];

			if(selectedOption != undefined){
				var oldIdArray = (selectedOption.id).split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				var oldValueArray = (selectedOption.value).split('<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>');
				selectedOption.id = oldIdArray[0] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' +
							oldIdArray[1] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + 
							oldIdArray[2] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + editedNote;
				selectedOption.value = oldValueArray[0] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' +
							   oldValueArray[1] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + 
							   oldValueArray[2] + '<%=Constants.DELIMITER_TO_SEPARATE_SUBVALUES%>' + editedNote;
				selectedOption.innerText = selectedOption.value;
			}
		}
	}
	showEditNoteSection(false,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton);
}

function showEditNoteSection(showEditNoteSectionFlag,multiselectId,editNotesId,addButton,saveButton,deleteButton,cancelButton){
	var clinicalTrialMultiselectDiv = document.getElementById(multiselectId);
	var clinicalTrialEditNotesDiv = document.getElementById(editNotesId);
	var clinicalTrialAddDiv = document.getElementById(addButton);
	var clinicalTrialSaveNoteDiv = document.getElementById(saveButton);
	var clinicalTrialDeleteDiv = document.getElementById(deleteButton);
	var clinicalTrialCancelNoteDiv = document.getElementById(cancelButton);
	var noteEditMessageTD = document.getElementById('noteEditMessageTD');
	if(clinicalTrialMultiselectDiv != undefined &&
			clinicalTrialEditNotesDiv != undefined &&
			clinicalTrialAddDiv != undefined &&
			clinicalTrialSaveNoteDiv != undefined &&
			clinicalTrialDeleteDiv != undefined &&
			clinicalTrialCancelNoteDiv != undefined){
		
		if(showEditNoteSectionFlag){
		 	
			clinicalTrialMultiselectDiv.style.display = 'none';
			clinicalTrialEditNotesDiv.style.display = 'block';
			// hide buttons
			clinicalTrialAddDiv.style.display = 'none';
			clinicalTrialDeleteDiv.style.display = 'none';
			// show edit buttons
			clinicalTrialSaveNoteDiv.style.display = 'block';
			clinicalTrialCancelNoteDiv.style.display = 'block';
			// hide the edit note message
			 noteEditMessageTD.innerText = '';
		}else{
				 
			var clinicalTrialEditNotes = document.getElementById(editNotes);
			if(clinicalTrialEditNotes != undefined){
				clinicalTrialEditNotes.value = '';
			}
			clinicalTrialMultiselectDiv.style.display = 'block';
			clinicalTrialEditNotesDiv.style.display = 'none';
			// hide buttons
			clinicalTrialAddDiv.style.display = 'block';
			clinicalTrialDeleteDiv.style.display = 'block';
			// show edit buttons
			clinicalTrialSaveNoteDiv.style.display = 'none';
			clinicalTrialCancelNoteDiv.style.display = 'none';
			// show the edit note message
			noteEditMessageTD.innerText = '<%=Constants.EDIT_NOTE_MESSAGE%>';
		}

		return true;
	}else{
	
		return false;
	}
}
function clearTextArea(textAreaId, isReadOnly){
	var textArea = document.getElementById(textAreaId);
	if(textArea != undefined){
		textArea.value = '';
		textArea.readOnly = isReadOnly;
		limitChars( textArea, textAreaId+'CharLimit', -1, false);
	}
}


function disableButton(){

    var button2 =document.getElementById('save_new1');
     	button2.disabled = true;

    var button4 =document.getElementById('save_new2');
     	button4.disabled = true;

}

function enableButton(){

    var button2 =document.getElementById('save_new1');
     	button2.disabled = false;
    var button4 =document.getElementById('save_new2');
     	button4.disabled = false;


}
</script>
<%
	String arrString = "";
	for(int count=0;count<arr.size()-1;count++){
		arrString = arrString + arr.get(count) + ",";
	}
	arrString = arrString + arr.get(arr.size()-1);

	String arr1String = "";
	for(int count = 0;count<arr1.size()-1;count++){
		arr1String = arr1String + arr1.get(count) + ",";
	}
	arr1String = arr1String + arr1.get(arr1.size()-1);

	final String DEFAULT_LOV_DISPLAY_VALUE = "Please select a value";
	final String DEFAULT_LOV_VALUE = "-1";
	final String DEFAULT_LOV_ID = "-1";

	boolean showInteractionsForThisOLButton = false;
	String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
	boolean isSAXAJVUser = false;
	if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
			isSAXAJVUser = true;
	}
	
	String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
	boolean isOTSUKAJVUser = false;
	if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
			isOTSUKAJVUser = true;
	}
	
	String interactionsIconImageName = "";
	String interactionsIconImageSize = "";
    String fromInteractionForThisOL = (String) request.getParameter("fromInteractionForThisOL");
	if(!isSAXAJVUser && !isOTSUKAJVUser &&
			(ActionKeys.PROFILE_SHOW_ADD_INTERACTION.equalsIgnoreCase(action) ||
					"true".equals(fromInteractionForThisOL))){
		showInteractionsForThisOLButton = true;
		interactionsIconImageName = "interactions_expert.gif";
		interactionsIconImageSize = "165";
		String interactionPageType = request.getParameter("intType");
		if (null != interactionPageType && interactionPageType.equalsIgnoreCase("org") ){
			interactionsIconImageName = "interactions_for_org.gif";
			interactionsIconImageSize = "224";
		}
	}

%>

<script language="javascript" type="text/javascript">

function isStudyValueSelected() {

	var studySelectedValue = document.getElementById("selectStudyIMPACTNumberLOV");

    if (!(studySelectedValue.options[studySelectedValue.selectedIndex].value != <%= DEFAULT_LOV_VALUE%> &&
    		studySelectedValue.options[studySelectedValue.selectedIndex].value != null &&
    		studySelectedValue.options[studySelectedValue.selectedIndex].value != "")) {
    	alert("Please select a Study Value");
    }
    else {
    	window.open('site_search.htm?selectedStudy='+studySelectedValue.options[studySelectedValue.selectedIndex].value,'SiteSearch',
    			'width=800,height=600,top=30,left=50,resizable=yes,status=yes,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes');
    }
}

</script>


<body onload="showRequiredSections();" onresize="reSizeLOV();">
<form name="editSurveyDummyForm" method="POST" onsubmit="openNewWindow();" action='survey.htm?action=EditInteractionSurvey' target='_new'>
<input type="hidden" name="answersJsonText" value="">
<input type="hidden" name="interactionId" value="">
<input type="hidden" name="expertId" value="">
<input type="hidden" name="surveyId" value="">
</form>
<form name="addInteractionForm" method="POST" AUTOCOMPLETE="OFF"  action='survey.htm?action=EditInteractionSurvey'>
	<input type="hidden" name="interactionId" value="<%=interactionId%>">
	<input type="hidden" name="divArray1" value="<%=arrString%>"/>
	<input type="hidden" name="divArray2" value="<%=arr1String%>"/>
	<input type="hidden" name="interactionTypeLOVTripletIds" value=""/>
	<input type="hidden" name="productMultiselectIds" value=""/>
	<input type="hidden" name="speakerDecksMultiselectIds" value=""/>
	<input type="hidden" name="educationalObjectivesMultiselectIds" value=""/>
	<input type="hidden" name="medicalPlanActivitiesMultiselectIds" value=""/>
	<input type="hidden" name="unsolictedOffLabelTripletIds" value=""/>
	<input type="hidden" name="selectStudyMultiselectIds" value=""/>
	<input type="hidden" name="diseaseStateMultiselectIds" value=""/>
	<input type="hidden" name="productPresentationMultiselectIds" value=""/>
	<input type="hidden" name="MIRFMultiselectIds" value=""/>
	<input type="hidden" name="surveyAnswersFilled" value=""/>
	<input type="hidden" name="surveyEditAnswersFilled" value=""/>

<table id="interactionMainTable" width="100%" height="auto" border="0" cellpadding="0" cellspacing="0">
	<% if (!"".equals(message)) { %>
	<tr align="left" class="back-blue-02-light">
		<td>&nbsp;
	        <font face ="verdana" size ="2" color="red">
	            <b><%=message%></b>
	        </font>
		<td>
	</tr>
	<% } %>
	<tr align="left" valign="top">
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
   					<td height="10" align="left"  class="back-white"></td>
				</tr>
				<tr>
   					<td>
       					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
           					<tr>
               					<td>&nbsp;</td>
           					</tr>
       					</table>
       				</td>
				</tr>
				<tr>
   					<td height="10" align="left"  class="back-white">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
       						<tr>
           						<td width="10" height="20">&nbsp;</td>
								<td width="40" class="text-blue-01">
									<input type="hidden" id="resetInteractionForm" name="resetInteractionForm" value="false">
									<input type="button" id="save_new1" onclick="disableButton();saveInteractionReset()" class="button-01" style="border:0;background : url(images/buttons/save_interaction_new.gif);width:186px;height:23px;"/>&nbsp;&nbsp;
								</td>
								<td width="10">&nbsp;</td>
								<td class="text-blue-01">
									<input id="searchInteractionButton" type="button" onclick="searchInteractions()" style="background: transparent url(images/buttons/search_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 144px; height: 22px;" value="" class="button-01" name="searc_int"/>
								</td>
								<% if(showInteractionsForThisOLButton){%>
									<td width="10">&nbsp;</td>
           							<td id ="myInt" width="10" class="text-blue-01"><input id="searchOLInteractionButton" name="Submit332" type="button" class="button-01" style="border:0;background : url(images/buttons/<%=interactionsIconImageName%>);width:<%=interactionsIconImageSize%>px;height:23px;"  onClick="searchMyInteractions()"></td>
           							<td>&nbsp;</td>
           							<td>
           								<a class=text-blue-01-link target='_top' href="expertfullprofile.htm?kolid=<%=(String)session.getAttribute(Constants.INTERACTION_PROFILE_KOLID) %>&entityId=<%=session.getAttribute(Constants.INTERACTION_PROFILE_EXPERTID)%>&<%=Constants.CURRENT_KOL_NAME%>=<%=request.getAttribute("kol_name")%>">Back To Profile</a>
           							</td>
           						<% } else if(!"".equalsIgnoreCase(mode)){%>
								<td width="10">&nbsp;</td>
       							<td width="10" class="text-blue-01">
       								<input id="backToSearchResultsButton" name="backToSearchResultsButton" type="button" class="button-01" value="" style="background: transparent url(images/buttons/back_to_search_results.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 168px; height: 22px;" onClick="backToSearchResults()"/>
       							</td>
       						    <% }%>
								<td width="15%">&nbsp;</td>
								<div style="PADDING-RIGHT: 10px; FLOAT: right; font-size:10px">
									<img id="allImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleAll('allImg', 'colContent')"/> Expand/Collapse All &nbsp;&nbsp;
								</div>
   		        			</tr>
						</table>
  					</td>
				</tr>
				<tr>
					<td height="10" align="left"  class="back-white"></td>
				</tr>
				<tr>
					<td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
				</tr>
				<tr>
					<td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
					<td width="10" rowspan="47" align="left" valign="top">&nbsp;</td>
				</tr>
				<tr>
    				<td>
        				<div class="reset colOuter">
							<div class="colTitle">
								<img id="intTypeImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('intType') "/>&nbsp;&nbsp;Interaction Header
							</div>
             			<div id="intTypeContent" class="colContent">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0"> <!-- table1 -->
										<tr>
											<td width="15%" class="text-blue-01">Date <font color="red" >*</font>:</td>
											<td>
												<%  String interactionDateString = "";
													if (interaction != null && interaction.getInteractionDate() != null) {
														java.util.Date interactionDate = interaction.getInteractionDate();
														SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
														interactionDateString = sdf.format(interactionDate);
													}
												%>
												<input type="text" size="15" name="interactionDate" readonly class="field-blue-01-180x20" id="sel2"
													   value="<%=interactionDateString%>"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></a>
												&nbsp;<a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a>
											</td>
										</tr>
							</table>
							<table id="interactionTripletTable" width="100%"  border="0" cellspacing="0" cellpadding="0"> <!-- table2 -->
								<tr>
									<td width="15%">&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr> <!-- Interaction Type Starts -->
									<td width="15%" class="text-blue-01">Interaction Type <font color="red" >*</font> : </td>
									<td>
										<select id="interactionType" name="interactionType" class="field-blue-13-300x100"
												onChange='checkAndPopulateInteractionTopic(this, "activityTypeLOV", true, "<%=activityTypeLOVName%>");'
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
											<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
											<%/* select interaction type by default */
												long interactionTypeId = 0;
												if(interaction != null){
													OptionLookup savedInteractionType = interaction.getType();
													if(savedInteractionType != null &&
															savedInteractionType.getId() > 0){

														interactionTypeId = savedInteractionType.getId();
													}

												}
												if (interactionTypeLookup != null && interactionTypeLookup.length > 0) {
													OptionLookup lookup = null;
													isAlreadySelected = false;
													for (int i = 0; i < interactionTypeLookup.length; i++) {
														lookup = interactionTypeLookup[i];
														String selected = "" ;
														if(	interactionTypeId == lookup.getId()){
															selected = "selected";
															isAlreadySelected = true;
														}else if (!isAlreadySelected && lookup.isDefaultSelected()){
															selected = "selected";
														}

											%>
											<option id="<%=lookup.getId()%>"
													value="<%=lookup.getOptValue()%>"
													<%=selected%>>
													<%=lookup.getOptValue()%>
											</option>
											<%
													}
												}
											%>
										</select>
										<input type="hidden" id="interactionTypeId" name="interactionTypeId" value=""/>
									</td>
								</tr><!-- Interaction Type Ends -->
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td width="15%" class="text-blue-01">Intent of Interaction <font color="red" >*</font> : </td>
									<td class="text-blue-01">
									   <%  InteractionData [] intentOfVisit = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.INTENT_OF_VISIT) : null;
										   String[] intentOfVisitArray = {"", ""};
											if (intentOfVisit != null &&
													intentOfVisit.length > 0){
													if(Constants.PROACTIVE_INTENT_OF_VISIT.equalsIgnoreCase(intentOfVisit[0].getData()))
														intentOfVisitArray[0] = "checked";
													else if(Constants.REACTIVE_INTENT_OF_VISIT.equalsIgnoreCase(intentOfVisit[0].getData()))
														intentOfVisitArray[1] = "checked";
											}
										%>
											<input type="radio" name="intentOfVisit" value="<%=Constants.PROACTIVE_INTENT_OF_VISIT %>" <%=intentOfVisitArray[0] %> onClick="showInitialIntentOfVisitSection(true)"/><%=Constants.PROACTIVE_INTENT_OF_VISIT %>
											<input type="radio" name="intentOfVisit" value="<%=Constants.REACTIVE_INTENT_OF_VISIT %>" <%=intentOfVisitArray[1] %> onClick="showInitialIntentOfVisitSection(true)"/><%=Constants.REACTIVE_INTENT_OF_VISIT %>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
							</table>
							<table id="initialIntentOfVisitTable" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="initialIntentOfVisitSectionContent" class="colSection" style="display:none; background-color:#f2f0de">
											<table>
												<tr>
													<td width="25%" class="text-blue-01">Initial Intent of Interaction :</td>
													<td width="5%">&nbsp;</td>
													<td width="20%" id="initialIntentOfVisitRadioTd" class="text-blue-01"></td>
													<td width="5%">&nbsp;</td>
													<td id="initialIntentOfVisitTopicTd" class="text-blue-01"></td>
												</tr>
											</table>
										 </div>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
							</table>
							<table width="auto"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<%String activitySubTypeLOVName = PropertyReader.getLOVConstantValueFor("ACTIVITY_SUB_TYPE"); %>
									<td class="text-blue-01" width="15%">Interaction Topic :</td>
									<td class="text-blue-01">
										<select id="activityTypeLOV" name="activityTypeLOV" class="field-blue-13-300x100" disabled onChange='populateChildLOV(this, "activitySubTypeLOV", true, "<%=activitySubTypeLOVName%>")'
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
											<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
										</select>
									</td>
									<td class="text-blue-01"  valign="top" width="15%">&nbsp;</td>
									<td class="text-blue-01">&nbsp;</td>
								</tr>
								<tr>
									<td class="text-blue-01" width="15%">Interaction Sub-Topic :</td>
									<td class="text-blue-01">
										<select id="activitySubTypeLOV" name="activitySubTypeLOV" class="field-blue-13-300x100" disabled
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
											<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
										</select>
									</td>
									<td class="text-blue-01"  valign="top" width="15%">
										<table id="tripletButtonsTable" width="100%"   border="0" cellpadding="0" cellspacing="0">
										<tr><td align="center" valign="top">&nbsp;</td></tr>
										<tr><td align="center" valign="top">
												<input type="button" name="addLOVTripletButton"  value="" onclick="addLOVTripletToMultiselect('interactionType', 'activityTypeLOV', 'activitySubTypeLOV', 'interactionActivitiesTriplet', true);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
											</td>
										</tr>
										<tr>
											<td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
										</tr>
										<tr>
											<td align="center" valign="top">
												<input type="button" name="deleteLOVTripletButton" value="" onclick="deleteLOVTripletFromMultiselect('interactionActivitiesTriplet');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%;  width: 73px; height: 22px;"/>
											</td>
										</tr>
										</table>
									</td>
									<td class="text-blue-01">
										<select id="interactionActivitiesTriplet" name="interactionActivitiesTriplet" multiple class="field-blue-55-360x100"
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
										<%  InteractionData [] interactionTypeLOVTripletValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.INTERACTION_TYPE_LOV_TRIPLET_IDS) : null;
											if (interactionTypeLOVTripletValue != null ){
												for(int i=0; i<interactionTypeLOVTripletValue.length; i++){
													String id = interactionTypeLOVTripletValue[i].getLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES +
																interactionTypeLOVTripletValue[i].getSecondaryLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
																interactionTypeLOVTripletValue[i].getTertiaryLovId().getId();
													String optValues = 	interactionTypeLOVTripletValue[i].getSecondaryLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
																		interactionTypeLOVTripletValue[i].getTertiaryLovId().getOptValue();

												%>
													<option id = "<%=id%>"
															value="<%=optValues%>"><%=optValues%>
													</option>
												<%}
											}
											%>
									   </select>
									</td>
								</tr>
                			</table>
	                        <table id="productTable" width="auto" border="0" cellspacing="0" cellpadding="0">
								<tr>
								   <td class="text-blue-01" width="15%">Product<font color="red" >*</font> :&nbsp;</td>
								   <td class="text-blue-01">
										<select id="productLOV" name="productLOV" class="field-blue-13-300x100"
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
										   <option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
											<%
												if (productsLookup != null && productsLookup.length > 0) {
													OptionLookup lookup = null;
													isAlreadySelected = false;
													for (int i = 0; i < productsLookup.length; i++) {
														lookup = productsLookup[i];
														String selected = "" ;
														if(lookup.isDefaultSelected())
															selected = "selected";

											%>
											<script>
												var optionvalue = document.createElement("option");
												optionvalue.setAttribute("id", "<%=lookup.getId()%>");
												optionvalue.setAttribute("value", "<%=lookup.getOptValue()%>");
												optionvalue.setAttribute("name", "<%=lookup.getId()%>"); // store the productLOVId for the child lov in the name attribute
												optionvalue.setAttribute("title", "<%=lookup.getOptValue()%>");
												optionvalue.appendChild(document.createTextNode("<%=lookup.getOptValue()%>"));
												optionvalue.selected = "<%=selected%>";
												var productLOV = document.getElementById("productLOV");
												productLOV.appendChild(optionvalue);
											</script>
										   <%}}%>
										</select>
								   </td>
									<td class="text-blue-01"  valign="top" width="15%">
										<table width="100%"   border="0" cellpadding="0" cellspacing="0">
										<tr><td align="center" valign="top">&nbsp;</td></tr>
										<tr><td align="center" valign="top">
												<input type="button" name="addProductButton"  value="" onclick="addProduct('productLOV', 'productMultiSelect');" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
											</td>
										</tr>
										<tr>
											<td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
										</tr>
										<tr>
											<td align="center" valign="top">
												<input type="button" name="deleteProductButton" value="" onclick="deleteProduct('productLOV', 'productMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
											</td>
										</tr>
										</table>
									 </td>
									<td class="text-blue-01">
										<select id="productMultiSelect" name="productMultiSelect" multiple class="field-blue-55-360x100"
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
									   <%   InteractionData [] productMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.PRODUCT_MULTISELECT_IDS) : null;
											if (productMultiselectValue != null &&
													productMultiselectValue.length > 0){
													for(int i=0; i<3; i++){
														long id = 0;
														String value = "";
														long parentId = 0;
														if(i == 0 && productMultiselectValue[0].getLovId() != null && productMultiselectValue[0].getLovId().getId() != 0){
															id = productMultiselectValue[0].getLovId().getId();
															value = productMultiselectValue[0].getLovId().getOptValue();
														}else if(i == 1 && productMultiselectValue[0].getSecondaryLovId() != null && productMultiselectValue[0].getSecondaryLovId().getId() != 0){
															id = productMultiselectValue[0].getSecondaryLovId().getId();
															value = productMultiselectValue[0].getSecondaryLovId().getOptValue();
														}else if(i == 2 && productMultiselectValue[0].getTertiaryLovId() != null && productMultiselectValue[0].getTertiaryLovId().getId() != 0){
															id = productMultiselectValue[0].getTertiaryLovId().getId();
															value = productMultiselectValue[0].getTertiaryLovId().getOptValue();
														}
											   %>
											   <script>addTOMultipleSelectByValue('productMultiSelect', "<%=id%>", "<%=value%>", "<%=id%>");</script>
											   <% }}%>
										</select>
										<script>populateProductdependentLOVs(); // populate all the lovs dependent on the selected products</script>
									</td>
								</tr>
								<tr>
									<td class="text-blue-01" width="15%">&nbsp;</td>
									<td class="text-blue-01">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="text-blue-01">
												 <%  	InteractionData [] unsolicitedOffLabelFlagValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.UNSOLICTED_OFF_LABEL_CHECKBOX) : null;
														String unsolicitedOffLabelFlag = "";
														if (unsolicitedOffLabelFlagValue != null &&
																unsolicitedOffLabelFlagValue.length > 0){
																if("on".equalsIgnoreCase(unsolicitedOffLabelFlagValue[0].getData())){
																	unsolicitedOffLabelFlag = "checked";
																}
														}
												  %>
													<input type="checkbox" name="unsolicitedOffLabelCheckbox" <%=unsolicitedOffLabelFlag %> onClick="this.checked ? showHiddenSection('unsolictedOffLabelSection') : hideOpenSection('unsolictedOffLabelSection'); deleteAllSelectedValuesInSection('unsolictedOffLabelSection');"/>Unsolicited Off-Label Question Received
												</td>
											</tr>
										</table>
               						</td>
    							</tr>
     						</table>
            		 </div>
        		</div>
	    	</td>
		</tr>
		<tr>
			<td height="20" align="left" valign="top" >
				<div class="reset colOuter">
					<div class="colTitle">
					    <img id="attImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('att') "/>&nbsp;&nbsp;Attendees
					</div>
					<div id="attContent" class="colContent">
          					<table id="selectMyOlTable" width="auto"  border="0" cellspacing="0" cellpadding="0">
             					<tr>
									<td class="text-blue-01" width="15%">Attendee List : </td>
									<td class="text-blue-01">
		                          		<select id="myOlList" name="myOlList" class="field-blue-13-300x100"
		                          				onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
		                          			<option value= -1>Select From My <%=DBUtil.getInstance().doctor%> List</option>
					                          <%
					                             if(myOL != null && myOL.length != 0){
					                                  for (int i = 0; i < myOL.length; i++) {
					                                  %>
					                                     <option value="<%=("kol;"+myOL[i].getId() + ";" +myOL[i].getLastName()+ ", " + myOL[i].getFirstName()).replaceAll("'","\'")%>"><%=myOL[i].getLastName()+ ", "+ myOL[i].getFirstName() %></option>
					                                  <%
					                                  }
					                             }
					                           %>
		                          		</select>
									</td>
							    	<td class="text-blue-01"  valign="top" width="15%">
					                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
						                    <tr><td align="center" valign="top">&nbsp;</td></tr>
						                    <tr><td align="center" valign="top">
									                <input name="button1" type="button" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;" onClick="addMyOL()">&nbsp;
									            </td>
						                    </tr>
						                    <tr>
						                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
						                    </tr>
						                    <tr>
						                        <td align="center" valign="top">
									                <input name="Submit3222" type="button" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%;  width: 73px; height: 22px;" onClick="deleteSelect();">
									            </td>
						                    </tr>
					                    </table>
				                	</td>
								    <td class="text-blue-01">
								        <input type='hidden' name='TL' value ='<%=DBUtil.getInstance().doctor%>'>
					  				    <select id="attendeeList" name="attendeeList" multiple class="field-blue-55-360x100"
									            onclick="showToolTip(this);"
									            onmouseover="showToolTip(this);"
	                							onmouseout="UnTip();">

									        <%
									            if (kolId != null && kolName!= null && !"".equals(kolName) && "".equalsIgnoreCase(mode) && (mainLink != null && mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("INTERACTIONS")) && (presentLink != null && !presentLink.equalsIgnoreCase("YES"))   ) {
									        %>
									        <option value="kol_<%=kolId%>_<%=kolName%>" <% if (!isViewModeOn) { %> selected <% } %> ><%=kolName%>(<%=DBUtil.getInstance().doctor%>)</option>
									        <%
									        } else if(orgId != null && orgName != null && "".equalsIgnoreCase(mode) && null != presentLink && presentLink.equalsIgnoreCase("YES")  && ( mainLink.equalsIgnoreCase("INTERACTIONS") || mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("ADVANCED_ORG_SEARCH")) ){
									        %>
									        <option value="org_<%=orgId%>_<%=orgName%>" <% if (!isViewModeOn) { %> selected <% } %> ><%=orgName%>(ORG)</option>
									        <%}%>
									        <%
									            Set attendeeList = null;
									            int size = 0;

									            if (interaction != null && interaction.getAttendees() != null) {
									                attendeeList = interaction.getAttendees();

									                Attendee attendee = null;
									                size = attendeeList.size();
									                Iterator attendeeIter = attendeeList.iterator();
									                String attendeeName = "";
									                String attendeeId = "";
									                for(int i=0;i<size;i++) {
									                    attendee = (Attendee) attendeeIter.next();
									                    attendeeName = attendee.getName();
									                    attendeeId = null;

									                    if (attendee.getAttendeeType() == Attendee.KOL_ATTENDEE_TYPE) {
									                        attendeeId = "kol_"+attendee.getUserId()+"_" + attendee.getName();
									                        attendeeName += "(" + DBUtil.getInstance().doctor + ")";
									                    }else if(attendee.getAttendeeType() == Attendee.EMPLOYEE_ATTENDEE_TYPE){
									                        attendeeId="emp_" + attendee.getUserId()+"_"+attendee.getName();
									                        attendeeName = attendeeName + "(Employee)";
									                    }else if(attendee.getAttendeeType() == Attendee.ORG_ATTENDEE_TYPE){
									                        attendeeId="org_" + attendee.getUserId()+"_"+attendee.getName();
									                        attendeeName = attendeeName + "(ORG)";
									                    }

									                    if(orgId != null && orgName != null && "".equalsIgnoreCase(mode) &&
									                            null != presentLink && presentLink.equalsIgnoreCase("YES")
									                            && ( mainLink.equalsIgnoreCase("INTERACTIONS") || mainLink.equalsIgnoreCase("HOME")
									                            || mainLink.equalsIgnoreCase("ADVANCED_ORG_SEARCH"))) {
									                        if(orgId.equals(attendee.getUserId()+"")) {} else {
									        %>

									        <option value="<%=attendeeId%>" <% if (!isViewModeOn) { %> selected <% } %> ><%=attendeeName%></option>

									        <%    }

									        } else if (kolId != null && kolName!= null && !"".equals(kolName) && "".equalsIgnoreCase(mode) && (mainLink != null && mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("INTERACTIONS")) && (presentLink != null && !presentLink.equalsIgnoreCase("YES")) ){
									            if(kolId.equals(attendee.getUserId()+"")) {}else{
									        %>
									        <option value="<%=attendeeId%>" <% if (!isViewModeOn) { %> selected <% } %> ><%=attendeeName%></option>
									        <%
									            }
									        } else{%>
									        <option value="<%=attendeeId%>" <% if (!isViewModeOn) { %> selected <% } %> ><%=attendeeName%></option>
									        <% }
									        }
									        }
									        %>
		    							</select>
									</td>
								</tr>
		 	  					<tr>
							        <td class="text-blue-01" width="15%">Lookup Attendees : </td>
							        <td>
							        	<table>
							        		<tr>
							        			<td class="text-blue-01-link">
							        				<a href="#" onclick="javascript:searchHCP();" class="text-blue-01-link">Search <%=DBUtil.getInstance().hcp %></a>
							        			</td>
							        			<td>&nbsp;</td>
							        			<td class="text-blue-01-link">
							        				<a href="#" onclick="javascript:window.open('interaction_org_search.jsp','searchOrg','width=720,height=450,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-link">Search Organization</a>
							        			</td>
							        			<% if(!(isOTSUKAJVUser || isSAXAJVUser)) { %>
							        				<td>&nbsp;</td>
							        				<td class="text-blue-01-link"><A href="#" onClick="javascript:window.open('employee_search.htm?fromEvents=false','searchLDAP','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');" class="text-blue-01-link"  >Lookup Employee</A></td>
							        			<%} %>
							        		</tr>
							        	</table>
							        </td>
							    </tr>
							</table><!-- selectMyOlTable ends -->
							<table id="otherAttendeesTable" width="100%" border="0" cellspacing="0" cellpadding="1">
								<tr>
						          <td class="text-blue-01" width="15%">Attendee Type
						              <select id="attendeeType1" name="attendeeType1" class="field-blue-12-220x20"
						              		  onclick="showToolTip(this);"
											  onmouseover="showToolTip(this);"
											  onmouseout="UnTip();">
						                 <%
						                    if (attendeeTypeLookup != null && attendeeTypeLookup.length > 0) {
						                      OptionLookup lookup = null;

						                        for (int i = 0; i < attendeeTypeLookup.length; i++) {
						                          lookup = attendeeTypeLookup[i];
						                   		String selected = "" ;
						                  		if(lookup.isDefaultSelected())
						                  			selected = "selected";

						                  %>
						                   <option value="<%=lookup.getId()%>"<%=selected%>><%=lookup.getOptValue()%></option>
						                   <%
						                      }
						                    }
						                   %>
						              </select>
						          </td>
						          <td>&nbsp;</td>
						          <td class="text-blue-01" width="10%" >Number Attended
						          		<input name = "numberAttended" type = "text" class="text-blue-01" title="Please enter only digits" maxlength="2" onkeyup="valid(this,'allowOnlyNumbers')"/>
						          </td>
						          <td>&nbsp;</td>
				        		  <td class="text-blue-01"  valign="top" width="6%">
					                 <table width="100%"   border="0" cellpadding="0" cellspacing="0">
					                    <tr><td align="center" valign="top">&nbsp;</td></tr>
					                    <tr><td align="center" valign="top">
								                <input type="button" onclick="javascript:copySelectedAttendeeInfo(document.addInteractionForm.attendeeType1,document.addInteractionForm.numberAttended, document.addInteractionForm.attendeeInfo);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_attendee_type"/>
								            </td>
					                    </tr>
					                    <tr>
					                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
					                    </tr>
					                    <tr>
					                        <td align="center" valign="top">
								                <input type="button" onclick="javascript:deleteSelectAttendeeInfo();" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value = "" name = "deleteAttendeeInfo" />
								            </td>
					                    </tr>
					                 </table>
					              </td>
					              <td>&nbsp;</td>
								  <td class="text-blue-01" width="15%">
									<select id="attendeeInfo" name="attendeeInfo" multiple class="field-blue-55-360x100"
									        onclick="showToolTip(this);"
											onmouseover="showToolTip(this);"
											onmouseout="UnTip();">
						                      <% InteractionData [] attendeeInfo = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.INTERACTION_ATTENDEE_TYPE) : null;
					                             if (attendeeInfo != null ){
					                            	 for(int i=0; i<attendeeInfo.length; i++){
						                             	OptionLookup lookup = attendeeInfo[i].getLovId();
						                       			String selected = "" ;
						                      			if(lookup.isDefaultSelected()){
						                      				selected = "selected";
						                      			}
						                      			String otherAttendeeCount = ( ( attendeeInfo[i] != null &&
						                      			      !"null".equalsIgnoreCase( attendeeInfo[i].getData() )) ? attendeeInfo[i].getData() : "0" );

					  	                        %>
					                            <option value="<%=lookup.getId()%>-<%= otherAttendeeCount%>" <% if (!isViewModeOn) { %> <%=selected%> <% } %> ><%=lookup.getOptValue()%>-<%= otherAttendeeCount%></option>
					                              <% }
					                         }
					                       %>
					                </select>
							      </td>
							      <td>&nbsp;</td>
							      <td>&nbsp;</td>
							    </tr>
						</table><!-- otherAttendeesTable ends -->
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
					 <%
					 if(allSurveys!=null&&allSurveys.length>0)
					 {
					  for(int i=0;i<allSurveys.length;i++)
					  {
					   surveyIdNameMap.put(allSurveys[i].getId()+"",allSurveys[i].getName());
					  }
					 }
					 if(surveyExpertIds!=null){
					Iterator itr = surveyExpertIds.keySet().iterator();
					  while(itr.hasNext())
					 {
					 String surveyId = (String) itr.next();
					 String surveyName = (String)surveyIdNameMap.get(surveyId);
					Set expertIds = (Set)surveyExpertIds.get(surveyId);
					if(expertIds!=null){
					   Iterator expertIdsIterator = expertIds.iterator();
					%>
					<script>
					var editSurveyObject = new Object()
					var expertIdArray = new Array()
					editSurveyObject.surveyId = <%=surveyId%>
					editSurveyObject.surveyName = '<%=surveyName != null ? surveyName.replaceAll("\\'","\\\\\'") : ""%>'
					</script>
					<%
					while(expertIdsIterator.hasNext())
					{
					if(attendeesMap!=null&&attendeesMap.size()>0)
					{
					  Map expertIdJsonMap = (Map)expertIdsIterator.next();
					  String expertIdN = (String)expertIdJsonMap.get("expertId");
					  String jsonText = (String)expertIdJsonMap.get("jsonText");
					  String flname = (String)attendeesMap.get(expertIdN);

					%>
					<script>
					var expertObject = new Object()
					expertObject.expertId = <%=expertIdN%>
					expertObject.expertName = '<%=flname != null ? flname.replaceAll("\\'","\\\\\'") : ""%>'
					expertObject.jsonText = '<%=jsonText != null ? jsonText.replaceAll("\\'","\\\\\'") : ""%>'
					expertIdArray.push(expertObject)
					surveyFilledIdsArray.push(editSurveyObject.surveyId+'|'+expertObject.expertId)
					</script>
					 <%
					  }
					 }
					}%>
					<script>
					editSurveyObject.experts = expertIdArray
					addEditSurveyObject(editSurveyObject)
					</script>
					 <%}
					}
					%>
			</td>
		</tr>
		<tr>
		    <td align="left" valign="top" >	</td>
		</tr>
		<tr>
		    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
		</tr>
		<tr>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
       			<%@ include file = "interactionUI.jsp" %>
  					 <%if("true".equalsIgnoreCase(prop1.getProperty("FILLED_SURVEY"))) { %>
 						<tr>
   							<td>
       							<div class="surveyType colOuter">
						            <div class="colTitle">
						                <img id="surveyTypeImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('surveyType')"/>&nbsp;&nbsp;Filled Surveys
						            </div>
           							<div id="surveyTypeContent" class="colContent">
                 						<table width="auto" id="surveyMainTable" border="0" cellspacing="0" cellpadding="0">
                   							<tr>
												<td>
													<select id="editSurveySelect" name ="editSurveySelect" class="field-blue-12-220x20" onchange = "populateAttendeesSelect(this.selectedIndex-1)"
													       	onclick="showToolTip(this);"
															onmouseover="showToolTip(this);"
															onmouseout="UnTip();">
													<option> Please Select a Survey </option>
													</select>
												</td>
												<td>&nbsp;</td>
							                    <td>
													<select id="attendeeSelect" name ="attendeeSelect" class="field-blue-12-220x20" onchange ="toPopulateEditSurvey()"
															onclick="showToolTip(this);"
															onmouseover="showToolTip(this);"
															onmouseout="UnTip();">
													<option>
													Please Select an Attendee
													</option>
													</select>
												</td>
												<td>&nbsp;
												  <input type="button" class="button-01" name="editSurveyButton" onClick="editSurvey()"  style="background: transparent url(images/buttons/edit_survey.gif) repeat scroll 0%; width: 96px; height: 22px;"/>
												</td>
											</tr>
										</table>
									</div>
									<script type="text/javascript">
										populateSurveySelect()
								    </script>
       							</div>
				    		</td>
						</tr>
					</table>
				</td>
			</tr>
			<%}%>
		    <tr>
		        <td height="10" align="left" valign="top"></td>
		    </tr>
   			<tr>
				<td>
       				<div class="reset colOuter">
						<div class="colTitle">
							<img id="relatedEventsImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('relatedEvents')"/>&nbsp;&nbsp;Link to Medical Meeting
						 </div>
           					<div id="relatedEventsContent" class="colContent">
								<table width="auto"  border="0" cellspacing="0" cellpadding="0">
								<%
									EventEntity event = (EventEntity)session.getAttribute("relatedEventEntity");
									long eventId ;
									String eventName = "";
									Date eventDate;
									String date = "" ;
									String eventCity ="";
									String eventIdString = "";
									String eventState = "";
									String eventNameTitle = "";
									String eventDateTitle = "";
									String eventLocationTitle = "";
									if(event != null)
									{
										 eventId = event.getId();
										 eventName = event.getTitle();
										 eventDate = event.getEventdate();
										 eventCity = (event.getCity() != null ? event.getCity():"");
										 eventState = (event.getState().getOptValue() != null ? event.getState().getOptValue() :"");
										 eventIdString = eventId + "";
										 SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
											 date = sdf.format(eventDate);

     								}

								 %>
									<tr>
										<td>
											<input type="button" onclick="javascript:getEventsForInteraction(document.addInteractionForm.interactionDate.value);" style="background: transparent url(images/buttons/get_event.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 150px; height: 22px;"  name="sav_int" class="button-01"/>&nbsp;&nbsp;
											<input type = "hidden" id="eventId" name = "eventId"   value = "<%=eventIdString%>" />
											<input type = "hidden" id="resetEvent" name = "resetEvent"   value = "false" />
										</td>
										<td  class="text-blue-01">
											Selected Meeting
											<input type = "text" class="text-blue-01" id="selectedEvent" name = "selectedEvent" readonly="readonly"  title="<%=eventNameTitle%>" value= "<%=eventName%>"/>
										</td>
										<td width = 20>&nbsp;</td>
										<td class="text-blue-01">
											Meeting Date
											<input type = "text" class="text-blue-01" id="eventDate" name = "eventDate" readonly="readonly"  title="<%=eventDateTitle%>" value= "<%=date%>" />
										</td>
										<td width = 20>&nbsp;</td>
										<td  class="text-blue-01">
											Meeting Location
											<input type = "text" class="text-blue-01" id="eventLocation" name = "eventLocation" readonly="readonly"  title="<%=eventLocationTitle%>" value= "<%=eventCity%>", <%=eventState%> />
										</td>
										<td>&nbsp;</td>
										<td>
											<input type="button" onclick="javascript:clearEvents();" style="background: transparent url(images/buttons/reset.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 65px; height: 22px;"  name="clear_evnt" class="button-01"/>&nbsp;&nbsp;
										</td>
									 </tr>
            					</table>
           					</div>
        				</div>
      				</td>
   				</tr>
   				<tr>
   					<td>
   						<table>
							<tr>
								<td width="10" height="20">&nbsp;</td>
								<td width="40" class="text-blue-01">
						      		<input type="hidden" id="resetInteractionForm" name="resetInteractionForm" value="false">
									<input type="button" id="save_new2" onclick="disableButton();saveInteractionReset()" class="button-01" style="border:0;background : url(images/buttons/save_interaction_new.gif);width:186px;height:23px;"/>&nbsp;&nbsp;
								</td>
								<td width="10">&nbsp;</td>
						    	<td width="10">&nbsp;</td>
							    <td valign="top">
							        <input id="searchInteractionButton" type="button" onclick="searchInteractions()" style="background: transparent url(images/buttons/search_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 144px; height: 22px;" value="" class="button-01" name="searc_int0"/>&nbsp;
							    </td>
  					    	    <% if(showInteractionsForThisOLButton){%>
  					    	    	<td width="10">&nbsp;</td>
						    		<td id ="myInt" width="10" class="text-blue-01"><input id="searchOLInteractionButton" name="Submit332" type="button" class="button-01" style="border:0;background : url(images/buttons/<%=interactionsIconImageName%>);width:<%=interactionsIconImageSize%>px;height:23px;"  onClick="searchMyInteractions()"></td>
						    	    <td>&nbsp;</td>
           							<td>
           								<a class=text-blue-01-link target='_top' href="expertfullprofile.htm?kolid=<%=(String)session.getAttribute(Constants.INTERACTION_PROFILE_KOLID) %>&entityId=<%=session.getAttribute(Constants.INTERACTION_PROFILE_EXPERTID)%>&<%=Constants.CURRENT_KOL_NAME%>=<%=request.getAttribute("kol_name")%>">Back To Profile</a>
           							</td>
						    	<%} else if(!"".equalsIgnoreCase(mode)){%>
							    <td width="10">&nbsp;</td>
       							<td width="10" class="text-blue-01">
       								<input id="backToSearchResultsButton" name="backToSearchResultsButton" type="button" class="button-01" value = ""  style="background: transparent url(images/buttons/back_to_search_results.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 168px; height: 22px;" onClick="backToSearchResults()"/>
       							</td>
       						    <%}%>
							</tr>
						</table>
   					</td>
   				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
<%
    session.removeAttribute("MESSAGE");
    session.removeAttribute("INTERACTION_DETAILS");
    session.removeAttribute("MODE");
%>
