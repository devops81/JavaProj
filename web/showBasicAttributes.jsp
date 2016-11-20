<%@ page import="com.openq.eav.metadata.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.data.EavAttribute" %>
<%@ page import="com.openq.audit.AuditLogRecord" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<jsp:directive.page import="com.openq.utils.PropertyReader"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%
String fromEdit = (String)request.getSession().getAttribute("FROM_EDIT_ATTR");
%>
<html>
<head>
<script type="text/javascript" src="./js/sorttable.js"></script>
	<link href="css/openq.css" rel="stylesheet" type="text/css">
	<script type="text/javascript">
		
<%
	String prettyPrint = (String) request.getParameter("prettyPrint");
    String fromProfileSummary = null;
	fromProfileSummary = (String) request.getAttribute("profileSummary");
       
%>



	function showHideButtons() {
	  <%
		  if (prettyPrint == null) {
	  %>
		if (document.deleteTableRowForm._table)
		{
			// this is a table with rows
			parent.editDeleteForm.deleteRow.style.display = 'block';
			parent.editDeleteForm.addRow.style.display = 'block';
		}
		else
		{
			parent.editDeleteForm.deleteRow.style.display = 'none';
			parent.editDeleteForm.addRow.style.display = 'none';
		}

        if ('<c:out escapeXml="false" value="${disableAddButton}"/>' != '') {
           parent.editDeleteForm.addRow.disabled = true;
           parent.editDeleteForm.addRow.style.backgroundImage = 'url(images/buttons/add_new.gif)';
        } else {
           parent.editDeleteForm.addRow.disabled = false;
           parent.editDeleteForm.addRow.style.backgroundImage = 'url(images/buttons/add-int.gif)';
        }
        if ('<c:out escapeXml="false" value="${disableDeleteButton}"/>' != '') {
            parent.editDeleteForm.deleteRow.disabled = true;
            parent.editDeleteForm.deleteRow.style.backgroundImage = 'url(images/buttons/delete_new.gif)';
        }  else {
            parent.editDeleteForm.deleteRow.disabled = false;
            parent.editDeleteForm.deleteRow.style.backgroundImage = 'url(images/buttons/delete.gif)';
        }
        if ('<c:out escapeXml="false" value="${disableEditButton}"/>' != '') {
            parent.editDeleteForm.editButton.disabled = true;
            parent.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/edit_new.gif)';
        } else {
            parent.editDeleteForm.editButton.disabled = false;
            parent.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/edit.gif)';
        }
	  <% } %>
    }

    
    function pageOnLoad(fromEdit){
      
     /* if(fromEdit!=null&&fromEdit.toString()=="true")
      {
       var attributeId = (document.deleteTableRowForm.attributeId.value).toString();
       window.open('sendNotificationEmail.htm?attributeId=' + attributeId + '&currentKOLName=<%=request.getParameter("currentKOLName")%>','notificationEmail','width=500,height=150,top=300,left=330,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
      }*/

      showHideButtons();
      if(parent.setNotifyIcon) parent.setNotifyIcon();
      if(parent.resizeIFramesInnerProfile) parent.resizeIFramesInnerProfile();
    }
    
    
</script>

</head>

<body onLoad="javascript:pageOnLoad(<%=fromEdit %>);">

  
  
<%
	if (prettyPrint != null) {
	String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
%>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td>
		
		</td></tr>
      <tr>
       	<td align="right"><!--span class="text-blue-01-bold" onclick="javascript:window.close()"><IMG 
            height=16 src="images/close.gif" width=16 align=middle 
            border=0>&nbsp;Close</span-->&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print.gif' align=middle border=0 height="32"/></span>&nbsp;</td>
	  </tr>
	  <tr>
	    <td align="left">
		<div class="myexpertlist">
		  <table width="100%"><tr><td><div class="myexperttext"><%=currentKOLName%></div></td></tr></table>
		</div>
		</td>
	  </tr>
	  </table>
<%}%>
<form name="deleteTableRowForm" >
  <input type="hidden" name="attributeId" value='<c:out escapeXml="false" value="${attributeId}"/>' />
  <input type="hidden" name="entityId" value='<c:out escapeXml="false" value="${entityId}"/>' />
  <input type="hidden" name="parentId" value='<c:out escapeXml="false" value="${parentId}"/>' />
  <input type="hidden" name="totalRowId" value='<%=request.getSession().getAttribute("totalPositionToAmgenScienceExists")%>' />
  <input type="hidden" name="TLStatusAlreadySet" value='false' />
<%
	String parentIsArray = (String) request.getSession().getAttribute("parentIsArray");
	AttributeType [] basicAttrs = (AttributeType []) request.getSession().getAttribute("basicAttributes");
	Map map = (Map) request.getSession().getAttribute("attrValueMap");
    Map auditMap = (Map) request.getSession().getAttribute("auditLastUpdated");

	if (parentIsArray.equals("true") && basicAttrs.length > 0) {
		int width = (int) 100 / basicAttrs.length;
%>
	  <input type="hidden" name="_table" value="table" />
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="sortable">
      <tr class="back-grey-02-light">
       			<td width="1%">&nbsp;</td>
	  <% for (int k=0; k<basicAttrs.length; k++) { %>				
				<td width="1%" height="20">&nbsp;</td>
				    
				<td height="25" align="left" width="<%=(basicAttrs[k].getColumnWidth() != null ? basicAttrs[k].getColumnWidth() : "")%>px" align="left" valign="middle" class="text-blue-01-bold">
				<%=basicAttrs[k].getName()+""%>
				</td>
	  <% } %>
	  </tr>
	  <%
		if (map != null) {
	  	Iterator it = map.keySet().iterator();
	  	boolean gray = true;
		boolean recordsFound = false;
		while (it.hasNext()) {
		EntityAttribute ea = (EntityAttribute) it.next();
		ArrayList eavAttr = (ArrayList) map.get(ea);
		boolean doesValueExist = false;
		for (int x=0; (eavAttr != null && x<eavAttr.size()); x++)
			if (eavAttr.get(x) != null) doesValueExist = true;

		
		
		// custom rule: do not show advisory board type of data to user in GCO
		/*if (ea.getAttribute().getAttribute_id() == 7l && eavAttr.size() >= 1 && ("" + eavAttr.get(0)).indexOf("Advisory Board") != -1 && request.getSession().getAttribute("_hideAdvisoryBoardRow") != null) {
			doesValueExist = false;
		}*/

		if (doesValueExist) {
			gray = !gray;
			recordsFound = true;
	  %>
      <tr <%=gray ? "class='back-grey-02-light'" : ""%>>
       		<td width="1%" class="text-blue-01">
			<%if(fromProfileSummary==null){%>
			<input type="checkbox" name="rowsToDelete" value="<%=ea.getId()%>" />
			<%}%>
			</td>
		  <% for (int k=0; k<basicAttrs.length && eavAttr != null; k++) { 
		  		EavAttribute a = null;
		  		String link=null;

                // Fetch the audit information
                AuditLogRecord auditRecord = null;
                String title = AuditLogRecord.getNoUpdateTitle();
		  		
		  		for (int x=0; x<eavAttr.size(); x++) {
		  			if (((EavAttribute) eavAttr.get(x)).getAttribute().getAttribute_id() == basicAttrs[k].getAttribute_id()) {
		  				a = (EavAttribute) eavAttr.get(x);
                        Long id = new Long(a.getId());
                        title=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "value"));
		  			}
					if (((EavAttribute) eavAttr.get(x)).getAttribute().getAttribute_id()== Long.parseLong(PropertyReader.getEavConstantValueFor("PUBLICATION_ID")))
					{
						link=(EavAttribute) eavAttr.get(x)+"";
					}
		  		}
		  %>
			<td width="1%" height="20" class="text-blue-01">&nbsp;</td>	    
			<td height="25" align="left" align="left" valign="middle" class="text-blue-01" <%if(fromProfileSummary==null){ %>title='<%=title%>' <%} %>>
			<%if(basicAttrs[k].getAttribute_id()==Long.parseLong(PropertyReader.getEavConstantValueFor("PUBLICATION_TITLE")))
			{%>
			<a target="_blank" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=pubmed&cmd=Retrieve&dopt=AbstractPlus&list_uids=<%=link%>&query_hl=8&itool=pubmed_docsum">
			<% } %>
				<%=a == null ? "" : a + ""%>
			</td>
		  <% } %>
	  </tr>
	  <%} 
	} // end while
	//session.removeAttribute("_hideAdvisoryBoardRow");
	if (!recordsFound) {
	%>
		<tr>
			 <td width="1%" class="text-blue-01"></td>
			 <td width="1%" colspan="<%=(2*basicAttrs.length)%>" height="20" class="text-blue-01-red">No rows found.</td>
		</tr>
	<%
	}
}%>
	</table>

<%	} else { 
	
	if (basicAttrs != null && basicAttrs.length > 0)
	{
%>
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
<% for (int i=0; i<basicAttrs.length; i+=3) { 
   
	String label1 = (i<basicAttrs.length ? basicAttrs[i].getName() : "&nbsp;");
	String label2 = (i+1<basicAttrs.length ? basicAttrs[i+1].getName() : "&nbsp;");
	String label3 = (i+2<basicAttrs.length ? basicAttrs[i+2].getName() : "&nbsp;");
    
    String val1 = (i<basicAttrs.length && map != null && map.get(basicAttrs[i]) != null? map.get(basicAttrs[i]) + "" : "");
	String val2 = (i+1<basicAttrs.length  && map != null && map.get(basicAttrs[i+1]) != null? map.get(basicAttrs[i+1]) + "" : "");
	String val3 = (i+2<basicAttrs.length  && map != null && map.get(basicAttrs[i+2]) != null? map.get(basicAttrs[i+2]) + "" : "");
    
	String valueTD1 = (i<basicAttrs.length ? "attr_" + basicAttrs[i].getAttribute_id() + "TD" : "");
    String valueTD2 = (i+1<basicAttrs.length ? "attr_" + basicAttrs[i+1].getAttribute_id() + "TD" : "");
    String valueTD3 = (i+2<basicAttrs.length ? "attr_" + basicAttrs[i+2].getAttribute_id() + "TD" : "");
	
    if( label1.equals("Official Title") && val3.startsWith("NCT"))
    {
        val1 = "<a target=\"_blank\" class=\"text-blue-link\" href=\"http://www.clinicaltrials.gov/ct/show/" + val3 + "\"> " + val1 + "</a>";
    }

    AuditLogRecord auditRecord = null;
    String title1 = AuditLogRecord.getNoUpdateTitle();
    String title2 = AuditLogRecord.getNoUpdateTitle();
    String title3 = AuditLogRecord.getNoUpdateTitle();
    if (i<basicAttrs.length && map != null && map.get(basicAttrs[i]) != null && auditMap != null) {
        Long id  = new Long(((EavAttribute)map.get(basicAttrs[i])).getId());
        title1=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "value"));
    }
    if (i+1<basicAttrs.length && map != null && map.get(basicAttrs[i+1]) != null && auditMap != null) {
        Long id  = new Long(((EavAttribute)map.get(basicAttrs[i+1])).getId());
        title2=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "value"));
    }
    if (i+2<basicAttrs.length && map != null && map.get(basicAttrs[i+2]) != null && auditMap != null) {
        Long id  = new Long(((EavAttribute)map.get(basicAttrs[i+2])).getId());
        title3=AuditLogRecord.getMouseHoverTitle((AuditLogRecord) auditMap.get(id + "value"));
    }
    String TLType = "";
    if(i<basicAttrs.length && basicAttrs[i].getAttribute_id() == Constants.TL_TYPE_ATTRIBUTEID){
    	TLType = val1;
    }else if(i+1<basicAttrs.length && basicAttrs[i+1].getAttribute_id() == Constants.TL_TYPE_ATTRIBUTEID){
        TLType = val2;
    }else if(i+2<basicAttrs.length && basicAttrs[i+2].getAttribute_id() == Constants.TL_TYPE_ATTRIBUTEID){
        TLType = val3;
    }
    if(Constants.TL_TYPE_TL.equalsIgnoreCase(TLType) ||
         Constants.TL_TYPE_HCP.equalsIgnoreCase(TLType)){
  %>
<script>
   document.deleteTableRowForm.TLStatusAlreadySet.value = 'true';
</script>
<% } %>
	<tr>
	  <td width="10" height="20">&nbsp;</td>
	  <td width="31%" class="text-blue-01-bold"><%=label1%> </td>
	  <td width="20" class="text-blue-01-bold">&nbsp;</td>
	  <td width="31%" class="text-blue-01-bold"><%=label2%></td>
	  <td width="20" class="text-blue-01-bold">&nbsp;</td>
	  <td class="text-blue-01-bold"><%=label3%></td>
	</tr>
    <tr>
	  <td height="20">&nbsp;</td>
      <td id=<%=valueTD1 %> class="text-blue-01" valign=top <%if(fromProfileSummary==null){ %>title='<%=title1%>' <%} %>><%=(val1 != null && !val1.equals("null") ? val1 : "")%></td>
      <td class="text-blue-01" valign=top>&nbsp;</td>
      <td id=<%=valueTD2 %> class="text-blue-01" valign=top <%if(fromProfileSummary==null){ %>title='<%=title2%>' <%} %> ><%=(val2 != null && !val2.equals("null") ? val2 : "")%></td>
      <td class="text-blue-01" valign=top>&nbsp;</td>
      <td id=<%=valueTD3 %> class="text-blue-01" valign=top <%if(fromProfileSummary==null){ %>title='<%=title3%>' <%} %>><%=(val3 != null && !val3.equals("null") ? val3 : "")%></td>
	</tr>
	<tr>
	  <td height="20" colspan="6"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<%}%>
  </table>
<% } } %>
</form>
</body>
</html>
