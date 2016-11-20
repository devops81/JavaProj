<%@page import="com.openq.audit.AuditLogRecord"%>
<%@ page import="com.openq.event.EventAttendee"%>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="java.util.*"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<!-- saved from url=(0022)http://internet.e-mail -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
<%@ include file="imports.jsp"%>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>
<script type="text/javascript">
  function popup(url,frame){
    window.open(url,frame,"status=0, toolbar=0, location=0, height=200, width=300");
    window.name='opener';
  }
</script>
 <%
    Object[] eventObject = null;
    if(session.getAttribute("EXP_EVENTS") != null) {
        eventObject = (Object[]) session.getAttribute("EXP_EVENTS");
    }
    String setKol = (String) request.getSession().getAttribute(Constants.CURRENT_KOL_ID_SET);
    Map auditMap = (Map) session.getAttribute("auditLastUpdated");
    String fromProfileSummary = (String)request.getAttribute("fromProfSummary");
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
<body>
<%
	String prettyPrint = (String) request.getParameter("prettyPrint");
	if (prettyPrint != null) {
%>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"><IMG 
            height=16 src="images/close.gif" width=16 align=middle 
            border=0>&nbsp;Close</span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print_icon.gif' align=middle border=0 height="19"/>&nbsp;Print</span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>
<%--
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">

  <tr align="left">
    <td width="10" class="back-blue-02-light">&nbsp;</td>
    <td valign="top" class="back-blue-02-light">--%>
    <%--<div>--%>
<%if (fromProfileSummary!=null)
{
%>
<table width="100%"  valign="top" border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light">
<tr>
          <td height="10" align="left" class="back-white">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
              <td width="2%" height="20">&nbsp;</td>
              <td width="5%" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14" /></td>
              <td width="20%"class="text-blue-01-bold" width="150">Meeting Name</td>
              <td width="10%" class="text-blue-01-bold" width="150">Meeting Date</td>
              <td width="18%" class="text-blue-01-bold" width="200">Status</td>
            </tr>
	        <tr>
              <td colspan="9" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
            <tr>
              <td colspan="9" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
              <tr>
               <div style="position:absolute; height:160px; overflow:auto;">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	          <%
              EventEntity eventEntity = null;
              EventAttendee eventAttendee = null;
              OptionLookup eventType = null;
              OptionLookup ta = null;
              OptionLookup therapy = null;
              Object[] tmpArr = null;
              if (null != eventObject && eventObject.length > 0) {
                  int c = 0;
                  for (int i = 0; i < eventObject.length; i++) {
                      tmpArr = (Object[]) eventObject[i];
                      if (tmpArr != null && tmpArr.length > 0) {
                          eventEntity = (EventEntity) tmpArr[0];
                          eventAttendee = (EventAttendee) tmpArr[1];
                          eventType = (OptionLookup) tmpArr[2];
                          ta = (OptionLookup) tmpArr[3];
                          therapy = (OptionLookup) tmpArr[4];

                          // Fetch the audit information
                          AuditLogRecord auditRecord = null;
                          long id = eventEntity.getId();

                          String eventTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "title"));
                          //String typeTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "event_type"));
                          String dateTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "eventdate"));
                          //String taTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "ta"));
                          //String therapyTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "therapy"));
          if(!isSAXAJVUser && !isOTSUKAJVUser){%>
		<tr <%if(i%2 >0){%> class="back-grey-02-light"<% }%>>
                          <td width="2%" height="20">&nbsp;</td>
                          <td width="5%" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"/></td>
                          <td class="text-blue-01" width="20%" title='<%=eventTitle %>'>
			               <%=null != eventEntity.getTitle() ? eventEntity.getTitle() : ""%> 
                          </td>
                          <td width="10%" class="text-blue-01"  title='<%=dateTitle %>'>
                             <% java.util.Date eventDate =	eventEntity.getEventdate();
				              int y = eventDate.getYear()+1900;
				              int m = eventDate.getMonth()+1;
				              String eventDateStr = m+"/"+eventDate.getDate()+"/"+y;

				             %>
                              <%=null != eventDateStr ? eventDateStr : ""%></td>
                          <td width="10%" class="text-blue-01">
                          <%=eventAttendee.getAcceptanceStatus()%>
                          </td>
                       </tr>
	              <%// end of if
            } else if (isSAXAJVUser)
              {
               if(therapy!=null&&therapy.getOptValue().equalsIgnoreCase("Diabetes")){
              %>
                <tr <%if(c%2 >0){%> class="back-grey-02-light"<% }%>>
                          <td width="2%" height="20">&nbsp;</td>
                          <td width="5%" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"/></td>
                          <td width="20%" class="text-blue-01" title='<%=eventTitle%>'>
			               <%=null != eventEntity.getTitle() ? eventEntity.getTitle() : ""%> 
                          </td>
                          <td width="10%" class="text-blue-01"  title='<%=dateTitle %>'>
                             <% java.util.Date eventDate =	eventEntity.getEventdate();
				              int y = eventDate.getYear()+1900;
				              int m = eventDate.getMonth()+1;
				              String eventDateStr = m+"/"+eventDate.getDate()+"/"+y;

				             %>
                              <%=null != eventDateStr ? eventDateStr : ""%></td>
                          <td width="10%" class="text-blue-01">
                          <%=eventAttendee.getAcceptanceStatus()%>
                          </td>
                       </tr>   
              <%c++;
              }
              }else
              {
               if(therapy!=null&&therapy.getOptValue().equalsIgnoreCase("Abilify")){
              %>
                <tr <%if(c%2 >0){%> class="back-grey-02-light"<% }%>>
                          <td width="2%" height="20">&nbsp;</td>
                          <td width="5%" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"/></td>
                          <td width="20%" class="text-blue-01" title='<%=eventTitle%>'>
			               <%=null != eventEntity.getTitle() ? eventEntity.getTitle() : ""%> 
                          </td>
                          <td width="10%" class="text-blue-01"  title='<%=dateTitle %>'>
                             <% java.util.Date eventDate =	eventEntity.getEventdate();
				              int y = eventDate.getYear()+1900;
				              int m = eventDate.getMonth()+1;
				              String eventDateStr = m+"/"+eventDate.getDate()+"/"+y;

				             %>
                              <%=null != eventDateStr ? eventDateStr : ""%></td>
                          <td width="10%" class="text-blue-01">
                          <%=eventAttendee.getAcceptanceStatus()%>
                          </td>
                       </tr>   
              <%c++;
              }
              }
            }
            }//end of for
            }else if (null != eventObject && eventObject.length == 0){ // end of if %>
                  <tr>
                      <td width=10 >&nbsp;</td>
                      <td height="10" align="left" valign="top" class="text-blue-01-red">
                          &nbsp;No rows found.
                          </td><%}%>
                  </tr>
                       </table>
               </div>
         </td>
        </tr>
            <tr>
          <td height="50" align="left" class="back-white"></td>
        </tr>
</table>
      
  <%} else{ %>    
      <table width="100%"  valign="top" border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light">
        <%-- <tr>
          <td height="20" align="left" class="back_horz_head">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left">
              <td width="15" height="20"></td>
              <td width="40"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
              <td class="text-white-bold">Amgen Profile-Event Tab</td>
            </tr>
          </table></td>
          <td width="10" rowspan="5" align="left">&nbsp;</td>
        </tr>--%>
        <tr>
          <td height="10" align="left" class="back-white">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
              <td width="2%" height="20">&nbsp;</td>
              <td width="5%" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14" /></td>
              <td width="20%"class="text-blue-01-bold" width="150">Medical Meeting Title</td>
              <td width="15%" class="text-blue-01-bold" width="200">Type</td>
              <td width="10%" class="text-blue-01-bold" width="150">Date</td>
              <td width="18%" class="text-blue-01-bold" width="200">Therapeutic Area</td>
              <td width="10%" class="text-blue-01-bold" width="150">Therapy</td>
              <td width="10%" class="text-blue-01-bold">Attended</td>
              <td width="10%" class="text-blue-01-bold">
                <%= setKol.equalsIgnoreCase("Yes") ? "Response":"&nbsp;"%>
              </td>
              <td width="5%" class="text-blue-01-bold">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="9" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
              <tr>
               <div style="position:absolute; height:160px; overflow:auto;">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">




          <%
              EventEntity eventEntity = null;
              EventAttendee eventAttendee = null;
              OptionLookup eventType = null;
              OptionLookup ta = null;
              OptionLookup therapy = null;
              Object[] tmpArr = null;
              if (null != eventObject && eventObject.length > 0) {
                  for (int i = 0; i < eventObject.length; i++) {
                      tmpArr = (Object[]) eventObject[i];
                      if (tmpArr != null && tmpArr.length > 0) {
                          eventEntity = (EventEntity) tmpArr[0];
                          eventAttendee = (EventAttendee) tmpArr[1];
                          eventType = (OptionLookup) tmpArr[2];
                          ta = (OptionLookup) tmpArr[3];
                          therapy = (OptionLookup) tmpArr[4];

                          // Fetch the audit information
                          AuditLogRecord auditRecord = null;
                          long id = eventEntity.getId();

                          String eventTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "title"));
                          String typeTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "event_type"));
                          String dateTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "eventdate"));
                          String taTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "ta"));
                          String therapyTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "therapy"));
          %>
                      <tr <%if(i%2 >0){%> class="back-grey-02-light"<% }%>>
                          <td width="2%" height="20">&nbsp;</td>
                          <td width="5%" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"/></td>
                          <td width="20%" title='<%=eventTitle %>'>
                             <a target="_parent" href="<%=CONTEXTPATH%>/event_search.htm?action=<%=ActionKeys.VIEW_EVENT%>&eventid=<%=eventEntity.getId()%>"
                                             class="text-blue-01-link" target="showBasicAttrs"><%=null != eventEntity.getTitle() ? eventEntity.getTitle() : ""%></a>
                          </td>
                          <td width="15%"
                              class="text-blue-01" title='<%=typeTitle %>'><%=null != eventType.getOptValue() ? eventType.getOptValue() : ""%></td>
                          <td width="10%"
                              class="text-blue-01"  title='<%=dateTitle %>'>
                             <% java.util.Date eventDate =	eventEntity.getEventdate();
				              int y = eventDate.getYear()+1900;
				              int m = eventDate.getMonth()+1;
				              String eventDateStr = m+"/"+eventDate.getDate()+"/"+y;

				             %>
                              <%=null != eventDateStr ? eventDateStr : ""%></td>
                          <td width="18%"
                              class="text-blue-01"  title='<%=taTitle %>'><%=null != ta.getOptValue() ? ta.getOptValue() : ""%></td>
                          <td width="10%"
                              class="text-blue-01"  title='<%=therapyTitle %>'><%=null != therapy.getOptValue() ? therapy.getOptValue() : "" %></td>
                          <td width="10%" class="text-blue-01"><input type="checkbox" name="checkbox"  disabled
                                                           <% if (eventAttendee.getAttended().equalsIgnoreCase("Y")) {%>
                                                           checked="true" <%}%>/></td>
                         <td width="10%" class="text-blue-01">
                           <% 
                              if(setKol.equalsIgnoreCase("Yes")){
                                if("Pending".equals(eventAttendee.getAcceptanceStatus())) {
                           %>
                          <a href="javascript:popup('updateEventStatus.htm?showClose=true&attendeeId=<%=eventAttendee.getId()%>&status=Accepted','newFrame')">Accept</a>
                          /
                          <a href="javascript:popup('updateEventStatus.htm?showClose=true&attendeeId=<%=eventAttendee.getId()%>&status=Declined','newFrame')">Decline</a>
                          <%    } else { %>
                            <%=eventAttendee.getAcceptanceStatus()%>
                          <%    } %>
                          <% } %>
                         </td>
                         <td width="5%" class="text-blue-01">&nbsp;</td>
                      </tr>

            <% } // end of if
            }//end of for
            }else if (null != eventObject && eventObject.length == 0){ // end of if %>
                  <tr>
                      <td width=10 >&nbsp;</td>
                      <td height="10" align="left" valign="top" class="text-blue-01-red">
                          &nbsp;No rows found.
                          </td><%}%>
                  </tr>
                       </table>
               </div>
         </td>
        </tr>
            <tr>
          <td height="50" align="left" class="back-white"></td>
        </tr>
</table>
<%} %>
       <%-- <tr>
          <td align="left" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1" /></td>
        </tr>--%>

   


    <!--</div>-->
 <%-- </tr>

</table>--%>
  <%
			 session.removeAttribute("FromProfile");         
		%>
</body>
</html>
