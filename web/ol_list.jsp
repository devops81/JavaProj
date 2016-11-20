<%@ include file="imports.jsp"%>
<%@ page import="com.openq.user.User"%>

<%
	User [] user = (User [])request.getSession().getAttribute("user");
	Long [] orgolMapId = (Long []) request.getSession().getAttribute("orgolMapId");
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


	<form name="olListForm" method="post">
	  <input type="hidden" name="olType" value=""/>
	
<table width="100%" height="40px"  border="0" cellspacing="0" cellpadding="0">
<%if(user != null && user.length != 0) { for(int i=0;i<user.length;i++){ System.out.println("in the list page"+i);%>
	  
	 <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
	         <td width="5%" height="25" align="center">
	           <input type="checkbox" name="checkedOl" value="<%=orgolMapId[i]%>"/>
	         </td>
	         <%System.out.println("last name is "+user[i].getLastName()); %>
			 <td width="20%" class="expertListRow" align="left" ><%=user[i].getLastName()%>, <%=user[i].getFirstName()%></td>
	         <td width="20%" class="expertListRow" align="left">
		        <%=user[i].getPreferredContactType()==null?"N.A":user[i].getPreferredContactType()%></td>
			 <td width="15%" class="expertListRow" align="left">
		         <%=user[i].getPreferredContactInfo()==null?"N.A":user[i].getPreferredContactInfo()%></td>
	         <td width="15%" class="expertListRow" align="left"><%=user[i].getPosition()==null?"N.A":user[i].getPosition() %></td>
	         <td width="15%" class="expertListRow" align="left"><%=user[i].getDivision()==null?"N.A":user[i].getDivision() %></td>
			 <td width="10%" class="expertListRow" align="left"><%=user[i].getYear()==null?"N.A":user[i].getYear() %></td>
	        
	      </tr>
	    
	  <% } } %>
</table>
	</form>