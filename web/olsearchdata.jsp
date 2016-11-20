<%@ page language="java" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.web.controllers.Constants" %>

<%
	response.setHeader("Cache-Control", "no-store");
    User searchResult[] = (User[]) session.getAttribute("ADV_SEARCH_RESULT");
	if (searchResult != null && searchResult.length > 0) {
%>
	<experts>
<%
	String expName = null;
	for (int i=0; i<searchResult.length; i++)
	{
		User u = searchResult[i];
        if(u.getLastName() != null && !"".equals(u.getLastName())) {
           expName = u.getLastName();
        }
        if(u.getFirstName() != null && !"".equals(u.getFirstName())) {
           expName +=", "+u.getFirstName();
        }
        if(u.getMiddleName() != null && !"".equals(u.getMiddleName())) {
           expName +=" "+u.getMiddleName();
        }
%>
	  <expert>
	   <photo><%=CONTEXTPATH%>/olpic/photos/<%=("Photo_"+ u.getFirstName() + "_" + u.getLastName() + ".jpg")%></photo>
	   <profile_url>/expertfullprofile.htm?kolid=<%=u.getId()%>&entityId=<%=u.getKolid()%>&currentKOLName=<%=u.getFirstName()%>%20<%=u.getLastName()%></profile_url>
	   <name><%=expName%></name>
	   <location><%= u.getLocation() != null ? u.getLocation().trim() : ""%></location>
	   <address></address>
	   <specialty><%= u.getSpeciality() != null ? u.getSpeciality().trim().replaceAll("^,","").replaceAll(" ,","").replaceAll(",$","") : ""%></specialty>
	   <bio><%=(u.getBioData() != null ? u.getBioData() : "")%></bio>
	   <publication_count><%=u.getPubCount()%></publication_count>
	   <interaction_date><%=(u.getLastInteraction() != null ? u.getLastInteraction().getCreateTime() + "" : "")%></interaction_date>
	  </expert> 
<%	
	}
%>

	</experts>

<% } %>