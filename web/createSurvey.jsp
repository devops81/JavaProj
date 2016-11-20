<%@ include file="imports.jsp"%>
<%
String message = (String)request.getSession().getAttribute("surveyMessage");
request.getSession().removeAttribute("surveyMessage");
%>
<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="js/surveyBasics.js"></script>
<script type="text/javascript">
function createSurveys()
{
  //alert('before call')
  var surveyTitle = document.forms['createSurveyForm'].elements['surveyTitle'];

  var surveyType = document.forms['createSurveyForm'].elements['surveyType'];
  
  if(surveyTitle!=null&&surveyTitle.value!=null&&surveyTitle.value!=undefined&&surveyTitle.value!='')
	{
	  //alert(surveyTitle.value)
	  //alert(surveyType.options[surveyType.selectedIndex].value)
      document.forms['createSurveyForm'].action ="<%=CONTEXTPATH%>/survey.htm?action=createTitle";
      document.forms['createSurveyForm'].target = "_parent";
      document.forms['createSurveyForm'].submit();

	}
  else
	{
	  alert('Please enter a value')
	   return 0;
	 }
}
function showLaunchedSurveys()
{
	
      document.forms['createSurveyForm'].action ="<%=CONTEXTPATH%>/survey.htm?action=showLaunchedSurveys";
      document.forms['createSurveyForm'].target = "_parent";
      document.forms['createSurveyForm'].submit();
}
 
</script>
<HEAD>
  <TITLE> openQ 2.0 - openQ Technologies Inc.</TITLE>
</HEAD>

 <BODY>
 <form name="createSurveyForm" method="POST" AUTOCOMPLETE="OFF">
  
<table width="100%" border="0">
    <tr>
	    <td>
		    <table width="100%" border="0">
			<%if(message!=null){%>
			<tr>
				<td class="text-blue-01-red" >
				<%=message%>
				</td>
			</tr>
		<%}%>
			  <tr>
			    <td width="100%">
				 <div id="surveyTitleBanner" class="colTitle">
				 &nbsp;&nbsp;Add New Survey
				 </div>
				</td>
			 </tr>
			 <tr>
			   <td>
			    <div id="surveyContent" class="colContent">
				  <table width="100%">
				   <tr>
				     <td width="10%" class="text-blue-01"> &nbsp;Title
					 </td>
					 <td width="90%">
					 <input type=textbox name="surveyTitle" id="surveyTitle" class="field-blue-01-120x20a"  >
					 </td>
				   </tr>
				   <tr>
				   <td width="10%" class="text-blue-01">&nbsp;Type 
				   </td>
				   <td width="90%"class="text-blue-01">
		            <select name="surveyType" id="surveyType" class="field-blue-10-120x20">
					<option value="Medical Intelligence">Medical Intelligence </option>
					<option value="Interactions">Interactions </option>
					<option value="DCI">DCI </option>
					</select>
					</td>
				   </tr>
				  </table> 
				</div>
			  </td>
			</tr>
		 </table>
	  </td>
	</tr>
	<tr>
	<td>
	&nbsp;<input name="createSurvey" type="button"  style="background: transparent url(images/buttons/create_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 112px; height: 22px;" value="" onClick="createSurveys()" />
	</td>
	</tr>
	<tr>
	<td>
	&nbsp;<input name="showSurvey" type="button" value ="Show Launched Surveys"  value="" onClick="showLaunchedSurveys()" />
	</td>
	</tr>
</table>
 </form>
 </BODY>
</HTML>
