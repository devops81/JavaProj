<%@ include file="imports.jsp"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.openq.audit.AuditLogRecord" %>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.eav.org.Organization" %>
<%
	Organization [] relatedOrgs = (Organization [])request.getSession().getAttribute("relatedOrgs");
	Map auditMap = (Map) request.getSession().getAttribute("auditLastUpdated");

	//Long [] orgolMapId = (Long []) request.getSession().getAttribute("orgolMapId");
%>

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


	<form name="orgListForm" method="post">
	  <input type="hidden" name="olType" value=""/>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<%
    boolean header = false;
    if ( request.getParameter("printHeader") != null  )
    {
        header = true;
    }
    if ( header)
    {
    %>
      <tr bgcolor="#faf9f2" >
      <td height="25" align="left" valign="top">
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle">

        <td width="5%" height="25">&nbsp;</td>
        <td width="1%" height="25">&nbsp;</td>
        <td width=20% class="expertListHeader">Name</td>
        <td width=20% class="expertListHeader">Type</td>
        <td width=20% class="expertListHeader">Position</td>
        <td width=20% class="expertListHeader">Division</td>
        <td width=15% class="expertListHeader">Year</td>
        </tr>
	    </table>
	   </td>
	  </tr>

    <%
    }
    if(relatedOrgs != null && relatedOrgs.length != 0) { for(int i=0;i<relatedOrgs.length;i++){
    if(relatedOrgs[i]!=null){
        // Fetch the audit information
        AuditLogRecord auditRecord = null;
        long id = relatedOrgs[i].getEntityId();

        String nameTitle = AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "name"));
        String typeTitle = AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "type"));
        id = relatedOrgs[i].getOrgOlMapId();
        String positionTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "position"));
        String divisionTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "division"));
        String yearTitle=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "year"));
    %>

	  <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
		<td height="25" align="left" valign="top">
	     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	      <tr align="left" valign="middle">

	        <td width="5%" height="25" align="center"><input type="checkbox" name="checkedOrg" value="<%=relatedOrgs[i].getEntityId()%>"/>&nbsp;</td>
	        <td width="1%" align="left"><img src="images/transparent.gif" width="5" height="14"></td>
		    <td width="20%" class="text-blue-01" title='<%=nameTitle%>'><A target="_top" class=text-blue-01-link href='institutions.htm?entityId=<%=relatedOrgs[i].getEntityId()%>'><%=relatedOrgs[i].getName()%></A></TD></td>
	        <td width="20%" class="text-blue-01" title='<%=typeTitle%>'><%=relatedOrgs[i].getType()==null?"":relatedOrgs[i].getType()%></td>
	        <td width="20%" class="text-blue-01" title='<%=positionTitle%>'>&nbsp;&nbsp;<%=relatedOrgs[i].getPosition()==null?"":relatedOrgs[i].getPosition()%></td>
	        <td width="20%" class="text-blue-01" title='<%=divisionTitle%>'>&nbsp;&nbsp;<%=relatedOrgs[i].getDivision()==null?"":relatedOrgs[i].getDivision()%></td>
	        <td width="15%" class="text-blue-01" title='<%=yearTitle%>'>&nbsp;&nbsp;&nbsp;&nbsp;<%=relatedOrgs[i].getYear()==null?"":relatedOrgs[i].getYear()%></td>
			

	      </tr>
	    </table>
	   </td>
	  </tr>

	  <% }}
      }
      %>
</table>
	</form>
