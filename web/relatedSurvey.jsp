<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.survey.SurveyProfileDetails"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<% 
    List surveyProfileDetailsList  = (ArrayList)request.getSession().getAttribute("surveyProfileInfo");
    SurveyProfileDetails[] surveyProfileDetails = (SurveyProfileDetails[])surveyProfileDetailsList.toArray(new SurveyProfileDetails[surveyProfileDetailsList.size()]);
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");   
   String selectedTab=request.getParameter("selected")==null ?"":request.getParameter("selected");
    String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
	String prettyPrint = null != request.getParameter("prettyPrint1") ? (String) request.getParameter("prettyPrint1") : null ;
	 
	String kolName = "kol_"+(String)request.getSession().getAttribute(Constants.CURRENT_KOL_ID)+"_"+(String) session.getAttribute(Constants.CURRENT_KOL_NAME);
	
	if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"></span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/></span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>
 


<html>

<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
body {
    margin-left: 0px;
    margin-top: 0px;
    margin-right: 0px;
    margin-bottom: 0px;
}
</style>

<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

<script  src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
<script  src="<%=COMMONJS%>/formChangeCheck.js" language="JavaScript"></script>

<script language="JavaScript">


function pageOnLoad(){
    if(parent.resizeIFramesInnerProfile) parent.resizeIFramesInnerProfile();
}

function getAddedAttendeesArray()
{
   var attendeeArrayToReturn = new Array();
  /* for(var i=0;i<attendeesObj.length;i++)
	{
	   var val=attendeesObj[i].value;
	   var text=attendeesObj.text;
       attendeeArrayToReturn.push(val);
	}*/
	attendeeArrayToReturn.push('<%=kolName%>');
  	return attendeeArrayToReturn;
}

</script>
</head>
<body onLoad="javascript:pageOnLoad();">
<!--div class="producttext" style=width:100%-->
<form name="relatedSurvey" target="inner" action="relatedSurvey.htm?kolId=<%=request.getParameter("kolId")%>" method="post" AUTOCOMPLETE="OFF">
 <table width="100%"  border="0" cellspacing="0" cellpadding="0" id="responseBlock">
  
  <tr>
    <td height="25" colspan="2" align="left" valign="top" class="">
	<div class="myexpertlist">
     <table width="1052"  border="0" cellspacing="0" cellpadding="0" height="49">
	 <tr align="left" valign="middle" style="color:#4C7398">
	          <td colspan="5" width=100% valign="middle">
	          	 <div class="myexperttext">Survey</div>
	          </td>
			  
	  </tr>
      <tr bgcolor="#faf9f2" >
        <td width="5%" height="25">&nbsp;</td>
        <td width="1%" height="25">&nbsp;</td>
        <td width=20% class="expertListHeader">Date</td>
        <td width=20% class="expertListHeader">BMS Employee</td>
        <td width=20% class="expertListHeader">Survey Name</td>
        <td width=20% class="expertListHeader">&nbsp;</td>        
        <td width=15%  class="expertListHeader">&nbsp;</td>
      </tr>
    </table>
	</div>   </td>
  </tr>
  <tr>
  <td height="100" colspan="2" align="left" valign="top" class="back-white"> 
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <%for(int i=0;i< surveyProfileDetails.length;i++){
      
  %>
  <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
		<td height="25" align="left" valign="top">
	     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	      <tr align="left" valign="middle">

	        <td width="5%" height="25" align="center"><input type="hidden" name="checkedOrg" value="<%=surveyProfileDetails[i].getSurveyId()%>"/>&nbsp;</td>
	        <td width="1%" align="left"><img src="images/transparent.gif" width="5" height="14"></td>
		    <td width="20%" class="text-blue-01" title=''><%=surveyProfileDetails[i].getDate()==null?"N.A":sdf.format(surveyProfileDetails[i].getDate())%></td>
		    <td width="20%" class="text-blue-01" title=''>  <%=surveyProfileDetails[i].getUserName()==null?"N.A":surveyProfileDetails[i].getUserName()%><!--  </A>--></td>
	        <td width="20%" class="text-blue-01" title=''><A target="_new" class=text-blue-01-link href="survey.htm?action=viewProfileSurvey&expertId=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&surveyId=<%=surveyProfileDetails[i].getSurveyId()%>&page=profile">
	        											<%=surveyProfileDetails[i].getSurveyName()==null?"N.A":surveyProfileDetails[i].getSurveyName()%></td>
	        <td width="20%" >&nbsp;</td>
	        <td width="15%" >&nbsp;</td>
			

	      </tr>
	    </table>
	   </td>
	  </tr>
 <%} %>
 
    <tr>
    <td height="1" colspan="2" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  </table>
 </table>
  
  <table width="100%" height="95" style="height: 95px;">
   <tr>
        <td height="20">&nbsp;</td>  
        <td valign="top">&nbsp;</td>
        <td width="30%">&nbsp;</td>  
        <td width="30%">&nbsp;</td>
        <td width="30%">&nbsp;</td>  
        
 
 	<%if (!"true".equalsIgnoreCase(prettyPrint) ) {%>

      <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %>
                 <td valign="top" align="right" width="67">
					<br>
				 </td>
                 <td width="8">&nbsp;</td>
                 <td valign="top" align="right" width="37">
					<br>
                 </td>
                 <% } %>  
                 <td width="8">&nbsp;</td>   
	<td width="39" height="30" onclick="window.open('relatedSurvey.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')" align=center><a class="text-blue-link" href="#"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br>
		Print</a></td>
        <td width="4"></td>

        </td>  
      <!--  <td valign="top" align="top" width="45" onclick='toggleAlertMode()' style="cursor:hand">
					<img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">
		Notify</a></td>-->
<tr>
<td valign="top" align="right"  height="30" width="67" style="cursor:hand">&nbsp;</td>
                 <td valign="top" align="right" width="8" style="cursor:hand"
                     >
					&nbsp;</td>
     <td valign="middle" align="right" width="5">&nbsp;</td>
     <td width="8" height="30" onclick="window.open('relatedSurvey.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')">&nbsp;</td>
        <td width="39">&nbsp;</td>

        <td valign="top" align="top" width="4" onclick='toggleAlertMode()' style="cursor:hand">
					&nbsp;</td>
</tr>
		</table><%}%></td>
      
      </tr>
    </table></td>
  </tr>
  
   
 
</table>
</form>
<!--/div-->
</body>
</html>