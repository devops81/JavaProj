<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ include file = "UserCheck.jsp" %>
<%@ page import="com.openq.user.User"%>


<%
    User[] employeeSearchResults = (User []) request.getAttribute("EMPLOYEE_SEARCH_RESULTS");
    String employeeSearchMessage = (String) request.getAttribute("EMPLOYEE_SEARCH_MESSAGE");
    String fromEvents = "";
    if( request.getAttribute("fromEvents") !=null ){
        fromEvents = (String) request.getAttribute("fromEvents");
    }
%>
<script language="javascript">
    function setParentTextBox(empName, empPhone, empEmal, empId,id) {
        window.opener.addAttendee(empName, empPhone, empEmal, empId,id);
    }
    function setParentTextBoxForAttendee(userName,id) {
        window.opener.addAttendeeNew(userName,id);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Employee search</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
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

<body>
<form name="employee_search" method="post">
<div>
    <div class="producttext">
            <div class="myexpertlist">
                <div class="myexperttext">
                    <img src="images/searchpic.gif">&nbsp;&nbsp;Search Employee</div>
                <div class="clear"></div>
            </div>

            <input type="hidden" name="parentFormName" value=""/>
            <div style="padding-left: 20px;padding-top: 10px;" align="left">
                <input name="searchtext" type="text" class="blueTextBox" maxlength="50"/>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input  value="" name="Submit332" type="submit"
                            style="border:0;background : url(images/buttons/search_employees.gif);width:144px; height:22px;"/>
      </div>    
    </div>
    <br/>
    <div class="producttext" style="overflow:auto">
            <div class="myexpertlist">
                <div class="myexperttext">
                    <img src="images/searchpic.gif">&nbsp;&nbsp;Search Employee Results</div>
                <div class="clear"></div>
            </div>

            <table width="100%" cellspacing="0">
              <tr bgcolor="#faf9f2">
                <td width="10%" align="center">&nbsp;&nbsp;&nbsp;<img src="images/tpic.jpg"></td>
                <td width="20%" class="expertListHeader">Name</td>
                <td width="20%" class="expertListHeader">Phone</td>
                <td width="20%" class="expertListHeader">Email</td>
                <td width="20%" class="expertListHeader">Title</td>
                <td width="20%" class="expertListHeader">Location</td>
              </tr>
           </table>
              <%if ( employeeSearchResults != null && employeeSearchResults.length > 0) { %>
                 <table width="98%" cellspacing="0">
              <% for(int i=0; i<employeeSearchResults.length; i++){
                         String displayName = employeeSearchResults[i].getLastName() + ", " + employeeSearchResults[i].getFirstName();
                         String  name = displayName.replaceAll("'","\\\\'");
              %>
                    <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
                        <td width="10%" align="center">
                        <% if(!fromEvents.equalsIgnoreCase("yes")){%>
                            <input name="radiobutton" type="radio" value="radiobutton" onClick="javascript:setParentTextBox('<%=name %>','<%=employeeSearchResults[i].getPhone() == null ? "N.A" : employeeSearchResults[i].getPhone()%>','<%=employeeSearchResults[i].getEmail() == null ? "N.A" : employeeSearchResults[i].getEmail()%>','<%=employeeSearchResults[i].getStaffid() == null ? "N.A" : employeeSearchResults[i].getStaffid()%>','<%=employeeSearchResults[i].getId()%>');"/>
                        <%}else{%>
                            <input name="radiobutton" type="radio" value="radiobutton" onClick="javascript:setParentTextBoxForAttendee('<%=name%>','<%=employeeSearchResults[i].getId()%>');"/>
                            
                        <%}%>
                        </td>
                        <td width="20%" class="boldp"><%= displayName%></td>
                        <td width="20%" class="boldp"><%=employeeSearchResults[i].getPhone() == null ? "N.A" : employeeSearchResults[i].getPhone()%></td>
                        <td width="20%" class="boldp"><%=employeeSearchResults[i].getEmail() == null ? "N.A" : employeeSearchResults[i].getEmail()%></td>
                        <td width="20%" class="boldp"><%=employeeSearchResults[i].getTitle() == null ? "N.A" : employeeSearchResults[i].getTitle()%></td>
                        <td width="20%" class="boldp"><%=employeeSearchResults[i].getLocation() == null ? "N.A" : employeeSearchResults[i].getLocation()%></td>
                    </tr>
                    <% } %>
               </table>
            <%}else{%>
                 <table width="98%" cellspacing="0">
                     <tr bgcolor='#fcfcf8'>
                        <td width="10%" align="center"><%= employeeSearchMessage%></td>
                      </tr>
                 </table>
            <%} %>  
        </div>
    <br/>
    <div class="producttext"  align="left">
        
         <div style="padding-left: 20px;padding-top: 10px" align="left"><input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onClick="javascript:window.close()" /></div>
        
    </div>
</div>
</form>
</body>
<script>
</script>
</html>
