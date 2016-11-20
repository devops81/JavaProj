<%@ page import="java.awt.*"%>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.IUserService" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.option.IOptionServiceWrapper" %>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.*"%>
<%@ page import="com.openq.time.TimeReport"%>

<%@ include file="header.jsp" %>

<%
	
	String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
	long userGroupId = -1;
	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString));
		userGroupId = Long.parseLong(userGroupIdString);
	/* This code definitely needs formatting */
	
    if(request.getSession().getAttribute(Constants.CURRENT_USER) == null)
        response.sendRedirect("login.htm");

	/* Fetch data objects that were set in the controller */               
    TimeReport[] timereports = null;
    if (null != session.getAttribute("TIMEREPORT") &&
            !"".equals(session.getAttribute("TIMEREPORT"))) {
        timereports = (TimeReport[]) session.getAttribute("TIMEREPORT");
    }

    OptionLookup timeTypeLookup [] = null;
    if (session.getAttribute("TIME_TYPE") != null) {
        timeTypeLookup = (OptionLookup[]) session.getAttribute("TIME_TYPE");
    }
    
    OptionLookup timeSpentLookup [] = null;
    if (session.getAttribute("TIME_SPENT") != null) {
        timeSpentLookup = (OptionLookup[]) session.getAttribute("TIME_SPENT");
    }
    
    String message = (String) request.getSession().getAttribute("MESSAGE");
    String updateMessage = (String) request.getSession().getAttribute("UPDATE_MESSAGE");

    Date searchFromDate = null;
    if (session.getAttribute("SEARCH_FROM_DATE") != null) {
		searchFromDate = (Date) session.getAttribute("SEARCH_FROM_DATE");
    }
	
    Date searchToDate = null;
    if (session.getAttribute("SEARCH_TO_DATE") != null) {
		searchToDate = (Date) session.getAttribute("SEARCH_TO_DATE");
    }

	/* Having the optionService here is probably a bad idea as it defeats 
     * loose coupling and isolation, but I lack knowing how else to do it currently
	 */
    IOptionServiceWrapper optSrvWrp = null;
    if(null != session.getAttribute("OPTION_SRV_WRP") &&
    		!"".equals(session.getAttribute("OPTION_SRV_WRP"))) {
    	optSrvWrp = (IOptionServiceWrapper) session.getAttribute("OPTION_SRV_WRP");
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");            
		
%>

<script language="Javascript">

    function show_calendar(sName) {
	    gsDateFieldName = sName;
        // pass in field name dynamically
        var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
        if (document.layers) // NN4 param
            winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
        var win = window.open("Popup/PickerWindow.html", "_new_picker", winParam);
        if (win != "") {
            win.focus();
        }
    }
        
    function editTimeReport(timeEntryId, fromDate, timeType, timeSpent, comments, finished) {
        var thisform = document.timereportForm;
        thisform.addEntryType.value = 'singleEntry';
            
        thisform.addTimeEntryId.value = timeEntryId;
        thisform.addFromDate.value = fromDate;
        thisform.addToDate.value = '';
        thisform.addTimeType.value = timeType;
        thisform.addTimeSpent.value = timeSpent;         
        if(comments != 'null')
        	thisform.addComments.value = comments;
     }        
       
     function deleteTimeReport(timeReportId) {
         var thisform = document.timereportForm;
         if(confirm("Please confirm deletion of the Report Entry")) {
          	thisform.action = "<%=CONTEXTPATH%>/timeReport.htm?action=<%=ActionKeys.DELETE_TIMEREPORT%>&timeReportId="+timeReportId;
           	thisform.submit();
         }
     }
        
     function searchTimeReport(fromDate, toDate) {
         var thisform = document.timereportForm;
         thisform.action = "<%=CONTEXTPATH%>/timeReport.htm?action=<%=ActionKeys.SEARCH_TIMEREPORT%>&fromDate="+fromDate+"&toDate="+toDate;
         thisform.submit();
     }
        
     function saveTimeReport(entryType, timeEntryId, fromDate, toDate, timeType, timeSpent, comments, finished) {
         var thisform = document.timereportForm;
		 if(timeEntryId != null && timeEntryId != "") {
			 if(!confirm("Please confirm updation of the Report Entry")) {
				 return;
			 }
		 }
         thisform.action = "<%=CONTEXTPATH%>/timeReport.htm?action=<%=ActionKeys.SAVE_TIMEREPORT%>"+"&addEntryType="+entryType+"&addFromDate="+fromDate+"&addToDate="+toDate+"&addTimeEntryId="+timeEntryId+"&addTimeType="+timeType+"&addTimeSpent="+timeSpent+"&addComments="+comments+"&addFinished="+finished;
         thisform.submit();
     }
     function showToDate() {
     	 var thisform = document.timereportForm;
         document.getElementById("addDate").style.visibility = 'visible';
         document.getElementById("hideDate").style.visibility = 'visible';
         thisform.addEntryType.value = 'rangeEntry';         
 		 <%
         if (timeSpentLookup != null && timeSpentLookup.length > 0) {
         	 OptionLookup lookup = null;
          	 for (int i = 0; i < timeSpentLookup.length; i++) {
           	     lookup = timeSpentLookup[i];
           	     if(lookup.getOptValue().equals("100")) {
         %>
     			 	 thisform.addTimeSpent.value = '<%= lookup.getId() %>';
     			 	 thisform.addTimeSpent.readonly;
     	 <%      	     
           	     }
          	 }
         }
         %>
         thisform.addFinished.checked = 'true';
     }
     function hideToDate() {
     	 var thisform = document.timereportForm;
         document.getElementById("addDate").style.visibility = 'hidden';
         document.getElementById("hideDate").style.visibility = 'hidden';
         thisform.addEntryType.value = 'singleEntry';
 		 <%
         if (timeSpentLookup != null && timeSpentLookup.length > 0) {
         	 OptionLookup lookup = timeSpentLookup[0];
         %>
          	 thisform.addTimeSpent.value = '<%= lookup.getId() %>';
         <%      	     
         }
         %>
         thisform.addFinished.checked = 'false';
     }
     function toggleButtons(buttonId) {
     	 var checkBox = 'finishedBox'+buttonId;
     	 var editButton = 'editButton'+buttonId;
     	 var deleteButton = 'deleteButton'+buttonId;
     	    	 
		 if(document.getElementById(checkBox).checked == true)
		 {
		 	 document.getElementById(editButton).disabled=true;
		 	 document.getElementById(deleteButton).disabled=true;
		 }
		 else
		 {
		 	 document.getElementById(editButton).disabled=false;
		 	 document.getElementById(deleteButton).disabled=false;		 	 
		 }                 
     }
        
</script>


<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
<form name="timereportForm" method="post">
	
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

<td>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td width="10" >&nbsp;</td>
</tr>

<tr>
<td align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
    
    <td width="10" >&nbsp;</td>
    <td >

    <div style="height:415px; overflow:auto;">

			
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <TBODY>
                        <tr align="left" valign="center" class="colTitle">
                            
                            <td class="myexperttext">Time Report </td>
                            
                            <td width="40" height="20">&nbsp;</td>
                        </tr>
                    </TBODY>   
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                                 width="1" height="1"></td>
            </tr>
            <tr>
                <td height="10" align="left" valign="top" class="back-white"></td>
            </tr>
            <tr>
                <td align="left" valign="top" class="back-white">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            
            <tr>
                <td width="10" height="20" valign="top">&nbsp;</td>
                <td width="190" valign="middle" class="text-blue-01">Date From </td>
                <td width="20" valign="middle" class="text-blue-01">&nbsp;</td>
                <td width="60" valign="middle" class="text-blue-01">&nbsp;</td>
                <td width="190" valign="middle" class="text-blue-01">Date To</td>
                <td valign="middle" class="text-blue-01">&nbsp;</td>
            </tr>
            <tr>
                <td height="20" valign="top">&nbsp;</td>

                <%
                GregorianCalendar calendar = new GregorianCalendar();
                calendar.setTime(new Date());
                calendar.add(Calendar.DATE, -6);
                %>

                <td valign="top"><input name="fromDate" type="text" class="field-blue-01-180x20" maxlength="50" readonly value="<%= sdf.format(searchFromDate) %>"></td>
                <td valign="top"><a href="javascript:show_calendar('forms[0].fromDate');"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a></td>
                <td valign="top">&nbsp;</td>
                <td valign="top"><input name="toDate" type="text" class="field-blue-01-180x20" maxlength="50" readonly value="<%= sdf.format(searchToDate) %>"></td>
                <td valign="top"><a href="javascript:show_calendar('forms[0].toDate');"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a></td>
                <td valign="top"> <input name="Submit1" type="button" style="border:0;background : url(images/search.jpg);width:86px; height:26px;" value="" onClick="searchTimeReport(fromDate.value, toDate.value)"></td>   
            </tr>
            </tr>
                    </table>
                </td>
            </tr>
                      
            <tr>
                <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                               height="10"></td>
                <td width="10" rowspan="11" align="left" valign="top">&nbsp;</td>
            </tr>
           
           
</tr>
<tr>
    <td height="10" align="left" valign="top">&nbsp;</td>
</tr>


<tr>
                <td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<TBODY>
<tr align="left" valign="center" class="colTitle">

<td class="myexperttext">Time Entry </td>
<td width="40" height="10">&nbsp;</td>
</tr>
</TBODY>   
</table>
</td>
</tr>
<tr>
<td height="10" align="left" valign="top" class="back-white"></td>
</tr><hr>
<tr align=center class="back-white">
<td>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
<TBODY>
<% 
	if(updateMessage != null) 
	{ 
%>
    	<tr>
        <td colspan=7 valign="middle" class="text-blue-01" width="100%"><font face ="verdana" size ="2" color="red"><b><%= updateMessage %></b></font></td>
		</tr>
		<tr>
		<td>
		</td>
		</tr>
		<hr>

<% 
	}                    
%>


<TR>
    <TD height="10" align="left" valign="top" class="back-white"></TD>
    <input type="hidden" name="addEntryType" value="singleEntry" >
	<%
	GregorianCalendar cal = new GregorianCalendar();
    cal.setTime(new Date());
    cal.add(Calendar.DATE, +6);
    %>
    <TD valign="middle" width="190"><div id="addDate" style="visibility:hidden"><input name="addToDate" type="text" class="field-blue-01-180x20" maxlength="50" readonly value="<%=sdf.format(cal.getTime())%>">
    <a href="javascript:show_calendar('forms[0].addToDate');"><img src="images/icon_calendar.gif" width="14" height="17" border="0"></a></div></TD>
</TR>
<TR>
	<TD width="10" height="20" valign="top">&nbsp;</TD>
    <TD width="150" valign="middle" class="text-blue-01" align="left">Date </TD>
    <TD width="50" valign="middle" align="left">
		<input align="left" name="addFromDate" type="text" class="field-blue-01-180x20" maxlength="50" readonly value="<%=sdf.format(new Date())%>">
	</TD>
	<TD width="200" valign="middle" align="center">
	    <a align="left" href="javascript:show_calendar('forms[0].addFromDate');"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a>
	</TD>
	
    <TD width="10" valign="middle" class="text-blue-01" align="left">&nbsp;</TD>
	<TD width="250" valign="middle" class="text-blue-01" align="left">Time Report Type </TD>
	<TD width="450" valign="middle" align="left">
	<select name="addTimeType"  class="field-blue-01-180x20">
<%
   		if (timeTypeLookup != null && timeTypeLookup.length > 0) {
       		OptionLookup lookup = null;
          	for (int i = 0; i < timeTypeLookup.length; i++) {
           		lookup = timeTypeLookup[i];
         		String selected = "" ;
          		if(lookup.isDefaultSelected())
          			selected = "selected";
%>
				<option value="<%=lookup.getId()%>" <%=selected%>> <%=lookup.getOptValue()%> </option>
<%
            }
        }
%>
	</select>
	</TD>
</TR>

<TR>
	<TD height="10" align="left" valign="top" class="back-white"></TD>
</TR>
<input type ="hidden" name="addTimeEntryId" >
<tr>
	<td width="10" height="20" valign="top">&nbsp;</td>
    <td width="150" valign="middle" class="text-blue-01" align="left">Time Spent</td>
    <td width="60">
    <select name="addTimeSpent" class="field-blue-01-180x20" align="left">

                                  <%
                                     if (timeSpentLookup != null && timeSpentLookup.length > 0) {
                                   		OptionLookup lookup = null;
                                     	for (int i = 0; i < timeSpentLookup.length; i++) {
                                     		lookup = timeSpentLookup[i];
                                     		String selected = "" ;
                                      		if(lookup.isDefaultSelected())
                                      			selected = "selected";
                                  %>
			                      			<option value="<%=lookup.getId()%>" <%=selected%> > <%=lookup.getOptValue()%> </option>
                                  <%
                                  	 	}
                                 	 }
                                  %>
                                  </select>
	 </td>
	<TD width="10" height="50">&nbsp;</TD>
	 <!--td width="10" height="20">&nbsp;</td>
     <td width="150" valign="middle" class="text-blue-01-bold">Comments </td>
     <td width="250" valign="middle"><input name="addComments" type="text" class="field-blue-01-180x20"></td-->
                                  
	 <td width="10" height="20">&nbsp;</td>
     <td width="150" valign="middle" class="text-blue-01" align="left">Tick When Finished </td>
     <td width="60" class="text-blue-01" valign="middle" align="left">
		                          <input type="checkbox" name="addFinished" align="left">
     </td>
</TR>
<TR>
	<TD height="10" align="left" valign="top" class="back-white"></TD>
</TR>
<tr>
	<td width="10" height="20" valign="top">&nbsp;</td>
    <td> <input name="Submit3" type="button" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" class="button-01" value="" 
											onClick="saveTimeReport(addEntryType.value, addTimeEntryId.value, addFromDate.value, addToDate.value, addTimeType.value, addTimeSpent.value, '', addFinished.checked)"></td>
                                  
</tr>
						</TBODY>
					</TABLE>
					</td>
				</tr>
				<tr>
                <td height="10" align="left" valign="top" class="back-white"></td>
            </tr>
				

 <tr>
                <td height="20" align="left" valign="top" ></td>
            </tr>

<tr>
                <td height="20" align="left" valign="top" class="colTitle">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="middle">

                            <td class="myexperttext">All My Time Reports </td>
                            
                            <td width="30" height="20">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr align=center>
					<td>
					<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
						<TBODY>
							<TR valign=center align=left class="back-grey-02-light">
								<TD align=middle width=25 height=28></TD>
								
								<TD width=1>&nbsp;</TD>
								<TD class=expertListHeader width=150>Date</TD>
								<TD width=1>&nbsp;</TD>
								<TD class=expertListHeader width=150>Type of Time Report</TD>
								<TD width=1>&nbsp;</TD>
								<TD class=expertListHeader width=150>Time Spent</TD>
								<TD width=1>&nbsp;</TD>
								
								<!--TD class=text-blue-01-bold width=150>Comments</TD>
								<TD width=1>&nbsp;</TD-->
								
								<TD class=expertListHeader width=150>Finished</TD>
								<TD width=1>&nbsp;</TD>
								
								<TD class=expertListHeader width=150>Edit / Delete</TD>
								<TD width=1>&nbsp;</TD>
								<TD></TD>
								</tr>
						</TBODY>
					</TABLE>
					</td>
				</tr>
				<tr class="back-white">
					<td colspan="15" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="/images/transparent.gif" width="1" height="1"></td>
			</tr>
				<tr align=center>
					<td>

                <div style="height:200px; overflow:auto;">
                  <table id="timeTable" width="100%"  border="0" cellspacing="0" cellpadding="0">
                  
                 <% if (timereports != null && timereports.length != 0) { 

	               String[] daysOfWeek = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
                 
                 for(int i=0;i<timereports.length;i++){ %>
                     <tr bgcolor='<%=(i%2==0?"white":"#faf9f2")%>' >
                      <TD align=middle width=25 height=25>&nbsp;</td>
                      <TD width=1>&nbsp;</TD>
                      <td class="text-blue-01" width="150"><%=sdf.format(timereports[i].getActivityDate())%>&nbsp;(<%=daysOfWeek[(timereports[i].getActivityDate()).getDay()]%>)</td>
                      <TD width=1>&nbsp;</TD>
                      <% 
                      OptionLookup optHolder = optSrvWrp.getValuesForId(timereports[i].getActivityId(), userGroupId);
                      %>
                      <td class="text-blue-01" width="150"><%=optHolder.getOptValue()%></td>
                      <TD width=1>&nbsp;</TD>
                      <%
                      	optHolder = optSrvWrp.getValuesForId(timereports[i].getPercentage(), userGroupId);
                      %>
                      <td class="text-blue-01" width="150"><%=optHolder.getOptValue()%></td>
                      <TD width=1>&nbsp;</TD>
		              <!--td class="text-blue-01" width="150"><%=timereports[i].getComments()==null?"":timereports[i].getComments()%></td>
		              <TD width=1>&nbsp;</TD-->
		              <td class="text-blue-01" width="150">
		             
		              <INPUT type="checkbox" value="<%=timereports[i].isFinished()%>" <% if(timereports[i].isFinished() == true) { %> checked <% } else { %> disabled <% } %> name="finishedBox<%= i %>" onClick="toggleButtons('<%=i%>')">
		              
		              </td>
		              
		              <TD width=1>&nbsp;</TD>
		              <td class="text-blue-01" width="75"><input name="editButton<%= i %>" type="button" class="button-01"
                                                style="border:0 none;background : url('images/buttons/edit.gif');width:60px; height:22px" value="" 
                                                <% if(timereports[i].isFinished() == true) { %> disabled <% } %>  
                                                onClick="editTimeReport('<%=timereports[i].getId()%>', '<%=sdf.format(timereports[i].getActivityDate())%>', '<%=timereports[i].getActivityId()%>', '<%=timereports[i].getPercentage()%>', '<%=timereports[i].getComments()%>', '<%=timereports[i].getFinishedFlag()%>')"></td>
                      <td class="text-blue-01" width="75"><input name="deleteButton<%= i %>" type="button" class="button-01"
                                                style="border:0 none;background : url('images/buttons/delete.gif');width:73px; height:22px" value="" 
                                                <% if(timereports[i].isFinished() == true) { %> disabled <% } %>  
                                                onClick="deleteTimeReport(<%=timereports[i].getId()%>)"></td>
		              <TD width=1>&nbsp;</TD>
								<TD></TD>
                                                             
                    </tr>
                    
                                        
                    <%} }  else { if(message != null) {%>
                     <tr>
                      <td colspan=7 aligh="center" valign="middle" class="text-blue-01" width="100%"><font face ="verdana" size ="2" color="red"><b>No reports found for date range</b></font></td>
                    </tr>
                    <% } }%>
                    
                  </table>
                </div>
   </td>
   <tr class="back-white">
					<td colspan="15" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="/images/transparent.gif" width="1" height="1"></td>
			</tr>
   </tr>		

<tr>
    <td height="10" align="left" valign="top"></td>
</tr>
</table>
</td>
<td width="10" class="back-white-02-light">&nbsp;</td>
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
</html>
<%
	/* code here look and feel */
	/* code here weekday and not weekends access */
	/* code here merged finished flags */
   
    session.removeAttribute("MESSAGE");
    session.removeAttribute("TIMEREPORT");
    session.removeAttribute("UPDATE_MESSAGE");
%>
<%@ include file="footer.jsp" %>
