<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.data.Entity" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.data.IDataService" %>
<%@ page import="com.openq.eav.metadata.IMetadataService" %>
<%@ page import="com.openq.authorization.IPrivilegeService" %>
<%@ page import="com.openq.authentication.UserDetails" %>
<%@ page import="com.openq.eav.data.StringAttribute" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
<%@ page import="com.openq.web.ActionKeys" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.utils.PropertyReader"%>
<%
String entityIdString;
if(null!=request.getParameter("entityId") && !(request.getParameter("entityId").equalsIgnoreCase("")))
    {
		entityIdString = request.getParameter("entityId");
	}
else{
entityIdString = (String) request.getSession().getAttribute("entityId");
}

		String kolName = request.getParameter(Constants.CURRENT_KOL_NAME);
		boolean commFlag = false;
		IDataService dataService = (IDataService) request.getSession().getAttribute("dataService");
		IMetadataService metadataService = (IMetadataService) request.getSession().getAttribute("metadataService");
		IPrivilegeService privilegeService = (IPrivilegeService) request.getSession().getAttribute("privilegeService");
		String photos_url = CONTEXTPATH+"/olpic";


		/*String ol_fName = "", ol_lName = "";
		//assuming kolName is lastname, FirstName
		String[] splitCompleteName= kolName.split(", ");
		if(splitCompleteName!=null && splitCompleteName.length>1)
		{
            ol_fName=splitCompleteName[1];
			ol_lName=splitCompleteName[0];
		}
*/
		//String ol_imageName = "Photo_"+ol_fName +"_"+ol_lName+".jpg";


        if(request.getSession().getAttribute("PRINTPROFILE_ROOT_PARENT_ID")!=null)
        {
        	entityIdString = (String) request.getSession().getAttribute("PRINTPROFILE_ROOT_PARENT_ID");
        }
        else
        {
            entityIdString = (String) request.getAttribute("ROOT_PARENT_ID");
        }

		long entityId = Long.parseLong(entityIdString);

		//new code for getting the Image name from DB
		String ol_imageName = "";
		EntityAttribute[] olSummary = dataService.getEntityAttributes(entityId,
		        dataService.getAttributeIdFromName(
		            PropertyReader.getEavConstantValueFor("EXPERT_SUMMARY"))
		            .getAttribute_id());
		if (olSummary != null && olSummary.length > 0)
		{
			EntityAttribute olSum = olSummary[0];
			EntityAttribute[] profile = dataService.getEntityAttributes(olSum.getMyEntity().getId(),
			          dataService.getAttributeIdFromName(
			              PropertyReader.getEavConstantValueFor("IDENTIFIERS"))
			              .getAttribute_id());
			if (profile != null && profile.length > 0) {
				EntityAttribute ea = profile[0];
			    StringAttribute[] attributes = dataService.getStringAttribute(ea.getMyEntity());
			    for (int i = 0; i < attributes.length; i++) {
			    	if(attributes[i].getAttribute().getAttribute_id() ==
			          dataService.getAttributeIdFromName(
			        		  PropertyReader.getEavConstantValueFor("PHOTO")).getAttribute_id())
			        {
			    		ol_imageName = attributes[i].toString();
			    	}
			    }
			}
		}

		Entity entity = (Entity)dataService.getEntity(entityId);
		EntityAttribute [] attributes = (EntityAttribute [])dataService.getAllEntityAttributes(entityId);
		String groupFunctionalArea = (String)session.getAttribute(Constants.GROUP_FUNCTIONAL_AREA);
		if(groupFunctionalArea !=null && groupFunctionalArea.equalsIgnoreCase("commercial")){
			commFlag = true;
		}
	%>

<HTML><HEAD><TITLE><%=DBUtil.getInstance().doctor%> Profile</TITLE>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
<STYLE type=text/css>UNKNOWN {
	MARGIN: 10px
}
</STYLE>
<BODY>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR vAlign=top align=left>
    <TD>
      <TABLE width="100%">
        <TBODY>
        <TR vAlign=top align=left>
          <TD class=text-blue-01-bold vAlign=center>&nbsp;
      </TD></TR></TBODY></TABLE></TD>
    <TD align=right>
      <TABLE width="100%">
        <TBODY>
        <TR vAlign=center align=left>
          <TD width="80%" height=5>&nbsp;</TD>
          <TD vAlign=center align=right><A class=text-blue-01-bold
            onclick=window.close();
            href="#"><IMG
            height=16 src="images/close.gif" width=16 align=middle
            border=0>&nbsp;Close</A> </TD>
          <TD width=30></TD>
          <TD vAlign=center align=right><A class=text-blue-01-bold
            onclick=window.print(); href="#">
            <IMG height=16 src="images/print_icon.gif" width=16
            align=middle border=0>&nbsp;Print</A> </TD>
          <TD width=10>&nbsp;</TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD>
      <TABLE width="100%">
        <TBODY>
        <TR vAlign=top align=left>
          <TD colSpan=3 height=10><IMG height=10
            src="images/transparent.gif" width=10></TD></TR>
        <TR vAlign=top align=left>
          <TD class=text-blue-01-bold-head3 vAlign=center><img align="center" onerror="javascript:document.getElementById('_OlImage').src = 'photos/noimage.jpg';" id="_OlImage" src="<%=photos_url%>/photos/<%=ol_imageName%>" width="170" height="150"/>
	        <%=kolName%></TD>
          <TD>&nbsp;</TD></TR>
        <TR vAlign=top align=left>
          <TD colSpan=3 height=5><IMG height=5
            src="images/transparent.gif"
    width=10></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD class=back-blue-03-medium width="100%" colSpan=2 height=2><IMG
      src="images/transparent.gif" width=1></TD></TR>
  <TR>
    <TD height=10></TD></TR></TBODY></TABLE>

<%
	for (int i=0; i<attributes.length; i++) {

%>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD vAlign=top align=left height=25><IMG height=1
      src="images/transparent.gif" width=1></TD></TR>
  <TR>
    <TD vAlign=top align=left height=20>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR vAlign=center align=left>
          <TD width=10 height=20>&nbsp;</TD>
          <TD width=25><IMG height=14
            src="images/icon_my_expert.gif" width=14></TD>
          <TD class=text-blue-01-bold-head2><%=attributes[i].getAttribute().getName()%></TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD class=back-blue-03-medium vAlign=top align=left colSpan=10
      height=1><IMG height=1 src="images/transparent.gif"
  width=1></TD></TR></TBODY></TABLE>
<%      Entity e = (Entity)attributes[i].getMyEntity();
        AttributeType [] subAttributes = (AttributeType [])metadataService.getAllShowableAttributes((long)e.getType().getEntity_type_id());

		for (int k=0; k<subAttributes.length; k++) {
			long eId = e.getId();

			if (!subAttributes[k].isArraylist()) {
				EntityAttribute[] subTab = dataService.getEntityAttributes(attributes[i].getMyEntity().getId(), subAttributes[k].getAttribute_id());
				if (subTab != null && subTab.length >0)
					eId = subTab[0].getMyEntity().getId();
				else
					eId = -1;
			}


%>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD vAlign=top align=left height=25><IMG height=1
      src="images/transparent.gif" width=1></TD></TR>
  <TR>
    <TD vAlign=top align=left height=20>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR vAlign=center align=left>
          <TD width=10 height=20>&nbsp;</TD>
          <TD width=25><IMG height=8
            src="images/icon_my_expert.gif" width=8></TD>
          <TD class=text-blue-01-bold-head1><%=subAttributes[k].getName()%></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE>
		   <%
		   if(subAttributes[k].getName().equalsIgnoreCase("Expert Strengths")){ %>
				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
				  <TR>
					<td>
						<jsp:include page ='showBasicAttributes.htm'>
							<jsp:param name="attributeId" value='<%=subAttributes[k].getAttribute_id()%>'/>
							<jsp:param name="entityId" value='<%=eId%>' />
							<jsp:param name="parentId" value='<%=attributes[i].getMyEntity().getId()%>'/>
						</jsp:include>
					</td>
				  </tr>
				</table>
				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
				  <TD class=text-blue-01-bold-head1><IMG height=8 src="images/icon_my_expert.gif" width=8>&nbsp;&nbsp;&nbsp;Medical Meetings</td>
					<TR>
					  <td>
						<jsp:include page ='event_search.htm'>
							<jsp:param name="action" value='<%=ActionKeys.SHOW_EVENTS_BY_EXPERT%>'/>
						</jsp:include>
					  </td>
					</tr>
				</table>
             <% } else if(subAttributes[k].getName().equalsIgnoreCase("Org. Affiliations")) {%>
               <table cellSpacing=0 cellPadding=0 width="100%" border=0>
				  <tr bgcolor="#faf9f2" >
			        <td width="5%" height="25">&nbsp;</td>
			        <td width="1%" height="25">&nbsp;</td>
			        <td width=20% class="expertListHeader">Name</td>
			        <td width=20% class="expertListHeader">Type</td>
			        <td width=20% class="expertListHeader">Position</td>
			        <td width=20% class="expertListHeader">Division</td>        
			        <td width=15% class="expertListHeader">Year</td>
			      </tr>
				  <tr>
					<td colspan='7'>
						<jsp:include page ='org_list.htm'>
							<jsp:param name="action" value='ORGLIST'/>
							<jsp:param name="kolId" value='<%=(String)session.getAttribute(Constants.CURRENT_KOL_ID) %>'/>
						</jsp:include>
					</td>
				  </tr>
				</table>
             <% } else { %>
			 <%
	                String gName = subAttributes[k].getName();
					if(commFlag){
					  if( !gName.equalsIgnoreCase("Trials")){// && !gName.equalsIgnoreCase("Other Therapies") && !gName.equalsIgnoreCase("Experience Type")){
			 %>
				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
				  <TR>
					<td>
						<jsp:include page ='showBasicAttributes.htm'>
							<jsp:param name="attributeId" value='<%=subAttributes[k].getAttribute_id()%>'/>
							<jsp:param name="entityId" value='<%=eId%>' />
							<jsp:param name="parentId" value='<%=attributes[i].getMyEntity().getId()%>'/>
						</jsp:include>
					</td>
				  </tr>
				</table>
				<% } %>
				<% } else { %>

				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
				  <TR>
					<td>
					  <jsp:include page ='showBasicAttributes.htm'>
							<jsp:param name="attributeId" value='<%=subAttributes[k].getAttribute_id()%>'/>
							<jsp:param name="entityId" value='<%=eId%>' />
							<jsp:param name="parentId" value='<%=attributes[i].getMyEntity().getId()%>'/>
						</jsp:include>
					</td>
				  </tr>
				</table>
				<% }} %>

<%}   } %>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TBODY>
        <TR vAlign=center align=left>
            <TD width=10 height=20>&nbsp;</TD>
            <TD width=25><IMG height=14
                              src="images/icon_my_expert.gif" width=14></TD>
            <TD class=text-blue-01-bold-head2><%=DBUtil.getInstance().doctor%> Plan</TD>
            </tr>
<TR>
    <TD class=back-blue-03-medium vAlign=top align=left colSpan=10
        height=1><IMG height=1 src="images/transparent.gif"
                      width=1></TD></TR>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TR>
        <td>
            <jsp:include page='searchInteraction.htm'>
                <jsp:param name="action" value='<%=ActionKeys.DEV_PLAN_HOME%>'/>
                <jsp:param name="prettyPrint" value='false'/>
            </jsp:include>
        </td>
    </tr>
</table>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TBODY>
        <TR vAlign=center align=left>
            <TD width=10 height=20>&nbsp;</TD>
            <TD width=25><IMG height=14
                              src="images/icon_my_expert.gif" width=14></TD>
            <TD class=text-blue-01-bold-head2>Interactions</TD>
            </tr>
<TR>
    <TD class=back-blue-03-medium vAlign=top align=left colSpan=10
        height=1><IMG height=1 src="images/transparent.gif"
                      width=1></TD></TR>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TR>
        <td>
            <jsp:include page='searchInteraction.htm'>
                <jsp:param name="action" value="<%=ActionKeys.PROFILE_INTERACTION%>"/>
                <jsp:param name="kolid" value='<%=(String) request.getAttribute("KOL_ID")%>'/>
                <jsp:param name="expertId" value='<%=(String) request.getAttribute("EXPERT_ID")%>'/>
                <jsp:param name="prettyPrint" value='false'/>
            </jsp:include>
        </td>
    </tr>
</table>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TBODY>
        <TR vAlign=center align=left>
            <TD width=10 height=20>&nbsp;</TD>
            <TD width=25><IMG height=14
                              src="images/icon_my_expert.gif" width=14></TD>
            <TD class=text-blue-01-bold-head2><%=DBUtil.customer %> Contacts</TD>
            </tr>
<TR>
    <TD class=back-blue-03-medium vAlign=top align=left colSpan=10
        height=1><IMG height=1 src="images/transparent.gif"
                      width=1></TD></TR>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
    <TR>
        <td>
            <jsp:include page='contacts.htm'>
                <jsp:param name="kolId" value='<%=(String)session.getAttribute(Constants.CURRENT_KOL_ID) %>'/>
                <jsp:param name="prettyPrint" value='false'/>
            </jsp:include>
        </td>
    </tr>
</table>
</body>
<%
	request.getSession().removeAttribute("dataService");
	request.getSession().removeAttribute("metadataService");
	request.getSession().removeAttribute("privilegeService");
%>

