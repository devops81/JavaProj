<%@ include file="imports.jsp"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.openq.audit.AuditLogRecord" %>
<%@ page import="com.openq.contacts.Contacts"%>

<%
	Contacts [] contact = (Contacts [])request.getSession().getAttribute("contacts");
    String prettyPrint = null != request.getParameter("prettyPrint") ? (String) request.getParameter("prettyPrint") : null ;
    Map auditMap = (Map) request.getSession().getAttribute("auditLastUpdated");

   if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"><IMG
            height=16 src="images/close.gif" width=16 align=middle
            border=0>&nbsp;Close</span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print_icon.gif' align=middle border=0 height="19"/>&nbsp;Print</span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>


<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<link href="css/openq.css" rel="stylesheet" type="text/css">


	<form name="contactsListForm" method="post">
	  <input type="hidden" name="contactType" value=""/>

<table width="100%" cellspacing="0" cellpadding="0">
 <%if (null != prettyPrint) {%>
  <tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr align="left" valign="middle">
        <td width=5% height="25" align="center">&nbsp;</td>
        <td width="18%" class="text-blue-01-bold" align="left" >Name</td>
        <td width="18%" class="text-blue-01-bold" align="left">Phone</td>
        <td width="18%" class="text-blue-01-bold" align="left">E-Mail</td>
        <td width="15%" class="text-blue-01-bold" align="left">Role</td>
        <td width="15%" class="text-blue-01-bold" align="left">Comment</td>
		 <td width="11%" class="text-blue-01-bold" align="left">&nbsp;</td>
              
      </tr>
    </table>
   </td>
  </tr>
   <%}%>
   <% if(contact != null && contact.length != 0) {
          for(int i=0;i<contact.length;i++) {

              // Fetch the audit information
              AuditLogRecord auditRecord = null;
              long id = contact[i].getContactId();

              String nameTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "contactName"));
              String phoneTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "phone"));
              String emailTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "email"));
              String roleTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "role"));
              String typeTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "type"));

              if(i%2 ==0) {%>

	  <tr>
	    <td>
	     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	      <tr>
	        <td width="5%" class="expertListRow">
	          <input type="checkbox" name="checkedContacts" value="<%=contact[i].getContactId()%>"/>
	        </td>
			<td width="18%" class="text-blue-01" title='<%=nameTitle%>'><% if (null != prettyPrint) { %><%=contact[i].getContactName()%> <% } else {%> <%=contact[i].getContactName()%> <%}%> </td>
	        <td width="18%" class="text-blue-01" title='<%=phoneTitle%>'>
		        <%=(contact[i].getPhone()==null?"N.A":contact[i].getPhone())%></td>
			<td width="18%" class="text-blue-01" title='<%=emailTitle%>'>
		         <%=(contact[i].getEmail()==null || contact[i].getEmail().equals("test@test.com")?"N.A":contact[i].getEmail())%></td>
		    <td width="15%" class="text-blue-01" title='<%=roleTitle%>'>
		        <%=(contact[i].getRole()==null?"N.A":contact[i].getRole())%></td>
		    <td width="15%" class="text-blue-01" title='<%=typeTitle%>'>
		        <%=(contact[i].getType()==null?"N.A":contact[i].getType())%></td>         
			 <td width="11%" class="text-blue-01">&nbsp;</td>
	      </tr>
	    </table>
	   </td>
	  </tr>

	  <% } else { %>

	  <tr bgcolor="#faf9f2">
	    <td>
	     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	      <tr>
	        <td width="5%" class="expertListRow">
	          <input type="checkbox" name="checkedContacts" value="<%=contact[i].getContactId()%>"/>
	        </td>
			<td width="18%" class="text-blue-01" title='<%=nameTitle%>'><% if (null != prettyPrint) { %><%=contact[i].getContactName()%> <% } else {%> <%=contact[i].getContactName()%> <%}%> </td>
	        <td width="18%" class="text-blue-01" title='<%=phoneTitle%>'>
		        <%=(contact[i].getPhone()==null?"N.A":contact[i].getPhone())%></td>
			<td width="18%" class="text-blue-01" title='<%=emailTitle%>'>
		         <%=(contact[i].getEmail()==null || contact[i].getEmail().equals("test@test.com") ?"N.A":contact[i].getEmail())%></td>
	       <td width="15%" class="text-blue-01" title='<%=roleTitle%>'>
		        <%=(contact[i].getRole()==null?"N.A":contact[i].getRole())%></td>
		    <td width="15%" class="text-blue-01" title='<%=typeTitle%>'>
		        <%=(contact[i].getType()==null?"N.A":contact[i].getType())%></td>  
			 <td width="11%" class="text-blue-01">&nbsp;</td>
	      </tr>
	    </table>
	   </td>
	  </tr>
 <% } } } %>
</table>
	</form>

