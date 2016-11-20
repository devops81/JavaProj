<%@ page import="java.util.*"%>
<%@ page import="com.openq.web.ActionKeys" %>
<%@page import="com.openq.survey.NewSurvey"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ include file="header.jsp" %>
<%
    NewSurvey[] allMedSurveys = null;
    if(session.getAttribute("ALL_MEDICAL_SURVEYS")!=null)
    {
      allMedSurveys = (NewSurvey[])session.getAttribute("ALL_MEDICAL_SURVEYS");
    }
	NewSurvey[] allDciSurveys = null;
    if(session.getAttribute("ALL_DCI_SURVEYS")!=null)
    {
      allDciSurveys = (NewSurvey[])session.getAttribute("ALL_DCI_SURVEYS");
    }
   String SURVEY_UNAVAILABLE_MESSAGE = "Currently there are no surveys available";
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
 %>
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
<script src = "<%=COMMONJS%>/listbox.js" language = "Javascript"></script>
<script language="javascript" src="js/subsection.js"></script>
<script language="javascript">
function openSurvey(i){
  var thisform = document.specialtyForm;
  var selectElement = document.getElementById('surveySelect'+i)//thisform.surveySelect;
  if(selectElement!=null&&selectElement.selectedIndex!=-1){   
     var selectedValue = selectElement.options[selectElement.selectedIndex].value;
	 win = window.open('survey.htm?action=viewSpecialtySurvey&surveyId='+selectedValue,'viewSurveyNew','width=1024,height=768,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');     
     
  }
}

var checkURL = true;
function toggleAll(rootImageId, toggleClassName)
{
    var image = dojo.byId(rootImageId);
    if( checkURL){
        image.src="images/buttons/plus.gif";
        checkURL = false;
        openAllSections(toggleClassName);
    } else {
        image.src="images/buttons/minus.gif";
        checkURL = true;
        closeAllSections(toggleClassName);
    }
}

dojo.addOnLoad(function(){
  //closeAllSections("colContent");
  // Interaction Header and Attendeed section visible on laod.
  //setTimeout("openSection('intType')",300);
  //setTimeout("openSection('att')",300);
});

function openNewWindow()
{
	//alert('opening new window');
	var win = window.open('','viewSurvey','width=1024,height=768,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
}

</script>
<HEAD>
  <TITLE> openQ 2.0 - openQ Technologies Inc.</TITLE>
</HEAD>

 <BODY>
<form name="specialtyForm" method="POST" onsubmit="openNewWindow();" action='survey.htm?action=viewSpecialtySurvey' target='_new'>
<table id="specialityMainTable" width="100%" height="auto" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="15%">&nbsp;</td>
<div style="PADDING-RIGHT: 10px; FLOAT: right; font-size:10px">
<img id="allImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleAll('allImg', 'colContent')"/> Expand/Collapse All &nbsp;&nbsp;
</div>
</tr>
<%if(true) { %>
<tr>
  <td>
  <div style="display:block" id="medicalIntelligenceSectionContent" class="colSection" class="colContent">
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="medicalIntelligenceImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('medicalIntelligence')"/>&nbsp;&nbsp;Medical Intelligence
      </div>
      <div id="medicalIntelligenceContent" class="colContent">
       <table width="auto"  border="0" cellspacing="0" cellpadding="0">
        <tr>
		<td>&nbsp;</td>
		</tr>
		<%if(!isSAXAJVUser && !isOTSUKAJVUser){%>
		<tr>
		<td>
		<a style="display:none" class="text-blue-link" type="application/vnd.ms-excel" href="<%=CONTEXTPATH%>/KeyMedicalIntelligenceQuestions.XLS" target="_blank"> Link to Key Medical Intelligence Questions </a>
		</td>
		</tr>
		<%}%>
		<tr>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>
				  <%if(true){
				            if(allMedSurveys!=null&&allMedSurveys.length>0) {%>
				                 <select id="surveySelect1" name="surveySelect" readonly 
				                 class="field-blue-12-220x20">
				                   <%for(int i=0;i<allMedSurveys.length;i++){ 
								   %> 
				                    <option value=<%=allMedSurveys[i].getId() %>  class="blueTextBox" ><%=allMedSurveys[i].getName() %></option>
				                  <%} %>
				                  </select>   
				                 &nbsp;
            					<input name="viewsurvey" type="button"  style="background: transparent url(images/buttons/survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 75px; height: 22px;" value="" onclick="openSurvey(1)"/>&nbsp;
            					 <%} else{%>
            					 	<font face ="verdana" size ="2" color="red"><%=SURVEY_UNAVAILABLE_MESSAGE %></font>
            					 <%} %>
            				<%} %>
			</td>
			</tr>
                </table>

     </div>
     </div>
     </div>
     </td>
   </tr>
  
<%}%>
<!-- Profiling ends here -->
<%if(true) { %>
<tr>
  <td>
  <div id="dciSectionContent" class="colSection" class="colContent">
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="dciImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('dci')"/>&nbsp;&nbsp;DCI
      </div>
      <div id="dciContent" class="colContent">
       <table width="auto"  border="0" cellspacing="0" cellpadding="0">
        <tr>
		<td>
		&nbsp;
		</td>
		</tr>
		<tr>
		<td>
				  <%if(true){
				            if(allDciSurveys!=null&&allDciSurveys.length>0) {%>
				                 <select id="surveySelect2" name="surveySelect" readonly 
				                 class="field-blue-12-220x20">
				                   <%for(int i=0;i<allDciSurveys.length;i++){ 
								   %> 
				                    <option value=<%=allDciSurveys[i].getId() %>  class="blueTextBox" ><%=allDciSurveys[i].getName() %></option>
				                  <%} %>
				                  </select>   
				                 &nbsp;
            					<input name="viewsurvey" type="button"  style="background: transparent url(images/buttons/survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 75px; height: 22px;" value="" onclick="openSurvey(2)"/>&nbsp;
            					 <%} else{%>
            					 	<font face ="verdana" size ="2" color="red"><%=SURVEY_UNAVAILABLE_MESSAGE %></font>
            					 <%} %>
            				<%} %>
			</td>
			</tr>
                </table>

     </div>
     </div>
     </div>
     </td>
   </tr>
  
<%}%>

</table>
</form>
</BODY>
</HTML>