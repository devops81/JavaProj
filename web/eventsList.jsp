
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<jsp:directive.page import="java.text.DateFormat"/><%@page import="java.util.Map;"%>
<html>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%
	EventEntity [] eventList  = (EventEntity []) request.getSession().getAttribute("EVENT_LIST_RESULTS");
	Map eventAttendeeMap =  null;
    Map interactionsCountMap = null;
      if(request.getSession().getAttribute("eventAttendees")!=null)
      {
        eventAttendeeMap = (Map)request.getSession().getAttribute("eventAttendees");
      }

	if(request.getSession().getAttribute("eventInteractionsCount")!=null)
	{
		interactionsCountMap = (Map)request.getSession().getAttribute("eventInteractionsCount");
	}
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">


<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript">
	function help() {
		alert("For demonstration purpose only. All links are just placeholders.");
	}
	function setParentTextBoxForEvent(eventId, eventName, eventDate, eventCity, eventState){
		window.opener.addEvent(eventId, eventName, eventDate, eventCity, eventState);
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
    <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
    }

    -->
</style>

</head>


<div align="center">
<form name="eventsListForm" method="post">

<div class="producttext">
     <table class="myexpertlist" width="100%"  border="0" cellspacing="0" cellpadding="0" >
	      <tr align="left" valign="middle" bgcolor="#faf9f2">
	        <td width="5%" height="25" align="center">&nbsp;</td>

	        <td width="5%" align="left"><img src="images/transparent.gif" width="8" height="14"></td>
			<td width="15%" class="expertListHeader" align="center">Meeting Name</td>
	        <td width="15%" class="expertListHeader" align="center">Date</td>
	        <%if("true".equalsIgnoreCase((String)request.getAttribute("fromSearch"))) {%>
	        <td width="15%" class="expertListHeader" align="center">Location</td>
	        <%} else { %>
			<td width="15%" class="expertListHeader" align="center">City</td>
	        <td width="15%" class="expertListHeader" align="center">State/Prov.</td>
   	        <td width="15%" class="expertListHeader" align="center">Country</td>
              <!--   <td width="35%" class="expertListHeader" align="center">Event Interaction Reports</td>-->
	        <%} %>


	      </tr>
        <div class="clear"/>
        </table>

 <table width="100%"  border="0" cellspacing="0" cellpadding="0" >

   <% Date date=new Date();
      if(eventList != null && eventList.length !=0)
      for(int i=0;i<eventList.length;i++){%>
	    <tr width="100%" align="left" valign="middle"  bgcolor='<%=(i%2==0?"white":"#faf9f2")%>'>
	        <td width="5%" height="25" align="center"><img src="images/transparent.gif" width="8" height="14"></td>
	        <%if("true".equalsIgnoreCase((String)request.getAttribute("fromSearch"))) {
	          SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                 String eventDate = sdf.format(eventList[i].getEventdate());

               %>
	        <td width="5%" align="left"><input type = "radio" name = "eventId" value="<%=eventList[i].getId()%>" class="text-blue-01-link" onclick="javascript:setParentTextBoxForEvent('<%=eventList[i].getId()%>', '<%=eventList[i].getTitle()%>','<%=eventDate%>','<%=eventList[i].getCity()%>','<%=eventList[i].getState().getOptValue()%>')">
			</td>
	        <%}else {%>

	        <td width="5%" align="left"><a target="_parent" href="event_search.htm?action=viewEvent&eventid=<%=eventList[i].getId()%>" class="text-blue-01-link">
			View</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<%}%>
			<td width="15%" class="boldp" align="center"><%=eventList[i].getTitle() == null ? "N/A" :eventList[i].getTitle()%></td>
			<%  date=eventList[i].getEventdate();
			    int year = date.getYear()+1900;
                    int month = date.getMonth()+1;
                    String dateStr = month+"/"+date.getDate()+"/"+year;

			 %>
	        <td width="15%" class="boldp" align="center"><%=eventList[i].getEventdate() == null ?"N/A" :dateStr%></td>
	        <%if("true".equalsIgnoreCase((String)request.getAttribute("fromSearch"))) {%>
	        <td width="15%" class="boldp" align="center"><%=eventList[i].getCity()==null ?"N/A" : eventList[i].getCity()%>,&nbsp;<%=eventList[i].getState().getOptValue()==null ? "N/A" : eventList[i].getState().getOptValue()%></td>
	        <%}else {
	          String eventAttendees = "N-A";
	          long interactionsCount = 0;
	           String eventDate = "01-JAN-04";
	           SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                  eventDate= sdf.format(eventList[i].getEventdate());
	  	    if(eventAttendeeMap!=null&&eventAttendeeMap.size()>0)
                  {
				    eventAttendees = (String)eventAttendeeMap.get(eventList[i].getId()+"");
                  }
            if(interactionsCountMap!=null && interactionsCountMap.size()>0)
            {
            	interactionsCount = Long.parseLong((String)interactionsCountMap.get(eventList[i].getId()+""));
            }
                %>
           	<td width="15%" class="boldp" align="center"><%=eventList[i].getCity()==null ?"N/A" : eventList[i].getCity()%></td>

	        <td width="15%" class="boldp" align="center"><%=eventList[i].getState().getOptValue()==null ? "N/A" : eventList[i].getState().getOptValue()%></td>
	        <td width="15%" class="boldp" align="center"><%=eventList[i].getCountry() == null ? "N/A" : eventList[i].getCountry().getOptValue()%></td>
	      <!--   <td width="35%"  align="center"><a target="_top" href="reportsUser.htm?action=viewEvent&eventid=<%=eventList[i].getId()%>&eventName=<%=eventList[i].getTitle()%>&eventCity=<%=eventList[i].getCity()%>&eventState=<%=eventList[i].getState().getOptValue()%>&eventAttendees=<%=eventAttendees%>&eventType=<%=eventList[i].getEvent_type().getOptValue() %>&eventDate=<%=eventDate%>&eventProduct=<%=(eventList[i].getTherapy() != null ? eventList[i].getTherapy().getOptValue() : "" )%>&interactionsCount=<%=interactionsCount %>" class="text-blue-01-link" >Reports</a></td>   -->
          <%} %>



	      </tr>

<% } %>

	    <tr align="left" valign="middle">
	        <td width="18" height="25" align="center">&nbsp;</td>
	        <td width="8" align="left">&nbsp;</td>
			<td width="185" class="text-blue-01" align="left">&nbsp;</td>
	        <td width="110" class="text-blue-01" align="left">&nbsp;</td>
		</tr>

		<tr>
             <td width="10" height="20">&nbsp;</td>
            <td class="text-blue-01" width="20">&nbsp;</td>
             <%if("true".equalsIgnoreCase((String)request.getAttribute("fromSearch"))) {%>
             <td class="text-blue-01"><input name="Submit334" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onclick="javascript:window.close()" /></td>
             <%} %>
       </tr>

		<tr>
			<td width="100" class="text-blue-01" align="left">&nbsp;</td>

	        <td width="100" class="text-blue-01" align="left">&nbsp;</td>
	        <td width="70" class="text-blue-01" align="left">&nbsp;</td>
			 <td width="60" class="text-blue-01" align="left">&nbsp;</td>
	        <td class="text-blue-01-bold">&nbsp;</td>
	    </tr>


	   </td>
	  </tr>
</table></form>
</div>
</body>

</html>