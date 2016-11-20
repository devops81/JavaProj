<!-- saved from url=(0022)http://internet.e-mail -->
<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.event.EventAttendee"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.web.ActionKeys"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@page import="java.util.Map"%>
<%
	if (request.getSession().getAttribute(Constants.CURRENT_USER) == null)
		response.sendRedirect("login.htm");

     EventEntity eventEntity = null;
	 int flag=0;
    if(session.getAttribute("EVENT_OBJECT") != null) {
        eventEntity = ( EventEntity ) session.getAttribute("EVENT_OBJECT");
    }
   String link = null;
   if (null != session.getAttribute("CURRENT_LINK")){
         link = (String)session.getAttribute("CURRENT_LINK");
   }

String userType = null;
	String disValue = null;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();
    }
	if(userType !=null && userType.equalsIgnoreCase("Viewer")){
		disValue = "disabled";
	}else{
		disValue="";
	}

   String groupFunctionalArea = null != session.getAttribute(Constants.GROUP_FUNCTIONAL_AREA) ? (String)session.getAttribute(Constants.GROUP_FUNCTIONAL_AREA) : "";
%>
  <jsp:include page="header.jsp" flush="true"/>
<script type="text/javascript" >

 function editAttendees(editId){
    var thisform = document.viewAttendees;
    thisform.action = "<%=CONTEXTPATH%>/event_search.htm?action=<%=ActionKeys.EDIT_ATTENDEE%>";
    thisform.submit();
 }


</script>
<HTML>
<head>
    <TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" >

<form name ="viewAttendees" method="post">
 		<div class="producttext">
		    <div class="myexpertlist">
		      <table width="100%">
		        <tr style="color:#4C7398">
			        <td width="50%" align="left">
			          <div class="myexperttext">View Medical Meeting</div>
			        </td>
		        </tr>
		      </table>
		    </div>
		    <table width=100% cellpadding=0 cellspacing=0>
<%
    if ( eventEntity != null ) {
        long id = eventEntity.getId();
%>

        <tr>
		  <td width="5%">&nbsp;</td>
          <td width="20%" class="text-blue-01" align="left"><strong>Medical Meeting Title</strong></td>
          
          <td width="12%" class="text-blue-01" align="left"><strong>Date:</strong></td>
          
          <td width="14%" align="left" class="text-blue-01-bold">Type</td>
          
          <td width="13%" class="text-blue-01" align="left"><strong><%=DBUtil.getInstance().customer%> Owner</strong></td>
           <td  class="text-blue-01" align="left"><a href="#" class="text-blue-01-link" 
           onClick="javascript:window.open('materialList.htm?eventId=<%=eventEntity.getId()%>','materiallist');"><strong>SupportMaterials</strong></a></td>
          <td width="5%">&nbsp;</td>
        </tr>
		
        <tr>
          <td width="5%">&nbsp;</td>
          <td width="20%"class="text-blue-01" ><%=null != eventEntity.getTitle() ? eventEntity.getTitle() : ""%></td>
          
          <td class="text-blue-01" width="12%" >
            <% java.util.Date eventDate =	eventEntity.getEventdate();
				              int y = eventDate.getYear()+1900;
				              int m = eventDate.getMonth()+1;
				              String eventDateStr = m+"/"+eventDate.getDate()+"/"+y;

	       %>  <%=null != eventDateStr ? eventDateStr : ""%>

          </td>
          
          <td  width="14%" align="left" class="text-blue-01" ><%=( eventEntity.getEvent_type() != null ? eventEntity.getEvent_type().getOptValue() : "" ) %></td>
         
          <td width="13%" class="text-blue-01" ><%=null != eventEntity.getOwner() ? eventEntity.getOwner() :""%></td>
          <td width="5%">&nbsp;</td>
          
        </tr>
        <tr>
          
          <td width="5%">&nbsp;</td>
          <td height="15" width="25% "align="left" class="text-blue-01-bold">&nbsp;</td>
          <td  width="15% align="left" class="text-blue-01-bold">&nbsp;</td>
          <td  width="25% class="text-blue-01">&nbsp;</td>
          <td  width="10% class="text-blue-01">&nbsp;</td>
          
        </tr>
        <tr>
          <td width="5%">&nbsp;</td>
          <td width="25%" class="text-blue-01"><strong>Therpaeutic Area</strong></td>
          
          <td width="25%" class="text-blue-01"><strong>Therapy:</strong></td>
          
          <td width="25%" align="left" class="text-blue-01-bold">Description</td>
          <td  width="20%"  class="text-blue-01">&nbsp;</td>
          
        </tr>
        <tr>
          <td width="5%">&nbsp;</td>
          <td valign="top" class="text-blue-01" ><%=( eventEntity.getTa() != null ? eventEntity.getTa().getOptValue() : "" )%></td>
          
          <td valign="top" class="text-blue-01" ><%=( eventEntity.getTherapy() != null ? eventEntity.getTherapy().getOptValue() : "" )%></td>
          
          <td align="left" valign="top" class="text-blue-01" ><%=null != eventEntity.getDescription() ? eventEntity.getDescription() : ""%>
         </td>
          <td class="text-blue-01">&nbsp;</td>
          
        </tr>
        
		<tr>
		   <td width="5%">&nbsp;</td>
		   <td height="20" width="25% "align="left" class="text-blue-01-bold">&nbsp;</td>
          <td  width="25% align="left" class="text-blue-01-bold">&nbsp;</td>
          <td  width="25% class="text-blue-01">&nbsp;</td>
          <td  width="20% class="text-blue-01">&nbsp;</td>
		</tr>

          <tr> 
		  <td width="5%">&nbsp;</td>
          <td width="25%" class="text-blue-01"><strong>Invited Attendees</strong></td>
          
          <td width="25%" class="text-blue-01"><strong>Attended Medical Meeting</strong></td>
          <td align="left" class="text-blue-01-bold">Status</td>
          <td align="left" class="text-blue-01-bold">&nbsp;</td>
          
        </tr>
         
           <% 
           Set attendees = eventEntity.getAttendees();
           Iterator itr = attendees.iterator();
           EventAttendee eventAttendee = null;
           int ctr = 0;
           String attendeeType = "";
           long attendeeTypeId = -1;
            while(itr.hasNext()){
                attendeeType = "";
               eventAttendee = (EventAttendee) itr.next();
               attendeeTypeId = eventAttendee.getExpertId().getUserType().getId();
               if(attendeeTypeId == Constants.EXPERT_USER_TYPE ){
                   attendeeType = " (" + DBUtil.getInstance().doctor + ")";
               }else if(attendeeTypeId == Constants.USER_USER_TYPE ){
                   attendeeType = " (Employee)";
               }
	          %>
	                      <tr <%if(ctr%2 >0){%> class="back-grey-02-light"<% }%>>
	         				 <td height="20">&nbsp;</td>
	          				<td class="text-blue-01" valign="top"><input type="hidden" name="invitedOL" value="<%=eventAttendee.getExpertId().getId()%>"><%=eventAttendee.getExpertId().getLastName()+", "%><%=eventAttendee.getExpertId().getFirstName()%><%=attendeeType%></td>
	 				         <td class="text-blue-01" ><input type="checkbox" name="expertId" value="<%=eventAttendee.getExpertId().getId()%>" <% if (eventAttendee.getAttended().equalsIgnoreCase("Y")){%>checked=true<%}%> /></td>
					          <td class="text-blue-01" ><%=eventAttendee.getAcceptanceStatus()%></td>
					          <td align="left" class="text-blue-01">&nbsp;
					               <input type="hidden" name="eventId" value="<%=eventAttendee.getExpertId().getId()%>">
					          </td>
					        </tr>
	                      
            <% ctr++;
            }
            if(ctr == 0){
				         flag = 1;
            %>
              			<tr <%if(ctr%2 >0){%> class="back-grey-02-light"<% }%>>
         				 <td height="20">&nbsp;</td>
          				<td class="text-blue-01" valign="top"><input type="hidden" name="invitedOL" ><font color="red">No Invitees Found</font></td>
 				         <td class="text-blue-01"></td>
				          <td class="text-blue-01">
		        		    <input type="hidden" name="eventId" value="<%=eventEntity.getId()%>">
		        		  </td>
				          <td align="left" class="text-blue-01">&nbsp;</td>
				        </tr>         
            <%  }%>
          </table>
 
  <table width="100%">
 <%}%>
 
   <%if(flag ==0){%>
   <tr>
   
    <td height="10" align="left">
		<p>&nbsp;
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
			
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="Submit332" type="button"  style="background: transparent url(images/buttons/save_attendee_status.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 158px; height: 22px;" value=""  
			    <%if ((null != eventEntity ) || (userType !=null && userType.equalsIgnoreCase("Viewer")) || 
			            "Commercial".equalsIgnoreCase(groupFunctionalArea)) {%> disabled  <%}%> onClick="editAttendees()">
			    </td>
                <td>&nbsp;</td>
			  <td width="78%">&nbsp;</td>
            </tr>
        </table>
	 </td>
	 </tr>
	 <%}%>
	 </table>
    </div>
</form>
<br>
<br>
<br>
<br><br>
<br>
<br>
<br>

<p>&nbsp;
<p>&nbsp;
<p>&nbsp;
<p>&nbsp;<br>
<br>
<br>
<br>
<br>
<br>
<br>

 <%if (null != link && !"HOME".equalsIgnoreCase(link)){%><%@ include file ="footer.jsp"%><% } %>
 </p></p></p>
 </body>
