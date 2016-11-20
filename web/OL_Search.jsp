<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.expert.ExpertDetails"%>

<%
    ExpertDetails [] users = (ExpertDetails []) request.getSession().getAttribute("users");
%>

<script language="javascript">
    function setParentTextBox(firstName, lastName, kolId, phone, email, position, division, year) {
        window.opener.addOL(firstName + ", " + lastName, phone, email, kolId, position, division, year);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><%=DBUtil.getInstance().doctor%> search</title>
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
<form name="<%=DBUtil.getInstance().doctor%>_Search" method="post">
<input type="hidden" name="parentFormName" value=""/>
    <div class="contentmiddle">
        <div class="producttext" >
        <div class="myexpertlist">
          <table width="100%">
            <tr style="color:#4C7398">
            <td width="2%"><img src="images/searchpic.gif"/>
            </td>
            <td width="50%" align="left">
              <div class="myexperttext">Search <%=DBUtil.getInstance().doctor%></div>
            </td>
            
            </tr>
          </table>
        </div>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top">&nbsp;</td>
              <td>&nbsp;</td>
            <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="190" valign="top"><input name="searchtext" type="text" class="field-blue-01-180x20" maxlength="50"/></td>
              <td valign="top"><input name="Submit332" type="submit" style="border:0;background : url(images/buttons/search_expert.gif);width:90px; height:22px;" value=""/></td>
            </tr>
         </table>
         </div>
         <br>
         
         <div class="producttext" style="height:200px" style="overflow:auto" >
          
            <div class="myexpertplan" height:200px style="overflow:auto">
              <table width="100%">
                <tr style="color:#4C7398">
                <td align="left">
                  <div class="myexperttext">Search <%=DBUtil.getInstance().doctor%> Results</div>
                </td>
                </tr>
              </table>
            </div>
            <table width="100%" cellspacing="0">
              <tr bgcolor="#f5f8f4">
                  <td width="10%" align="right">&nbsp;</td>
                  <td width="30%" class="expertPlanHeader">Name</td>
                  <td width="30%" class="expertPlanHeader">Speciality</td>
                  <td width="30%" class="expertPlanHeader">Primary Phone</td>
                  <td width="30%" class="expertPlanHeader">Primary Email</td>
                  <td width="15%">&nbsp;</td>
              </tr>
              
            
            <% if (users != null && users.length != 0) { %>
                 
                 <%for(int i=0;i<users.length;i++){  %>
                      <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
                      
                      <td width="10%" valign="middle"><input name="radiobutton" type="radio" value="radiobutton" onClick="javascript:setParentTextBox('<%=users[i].getFirstName()==null ? "":users[i].getFirstName()%>', '<%=users[i].getLastName() == null ? "" : users[i].getLastName()%>', '<%=users[i].getId()%>', '<%=users[i].getPrimaryPhone()==null?"":users[i].getPrimaryPhone()%>', '<%=users[i].getPrimaryEmail()==null?"":users[i].getPrimaryEmail()%>','','','');"/></td>

                      <td width="30%" valign="middle" class="text-blue-01" width="200"><%=users[i].getFirstName() == null ? "" : users[i].getFirstName()%>, <%=users[i].getLastName() == null ? "" : users[i].getLastName()%></td>
                      
                      <% String speciality = "";
                        if(users[i].getPrimarySpeciality()!= null && !users[i].getPrimarySpeciality().equals("")){
                            speciality = users[i].getPrimarySpeciality();
                        }
                        if(users[i].getSecondarySpeciality()!= null && !users[i].getSecondarySpeciality().equals("")){
                            if(speciality.equals(""))
                                speciality = users[i].getSecondarySpeciality();
                            else
                                speciality = speciality + ", " + users[i].getSecondarySpeciality();
                        }
                        if(users[i].getTertiarySpeciality()!= null && !users[i].getTertiarySpeciality().equals("")){
                           if(speciality.equals(""))
                                speciality = users[i].getTertiarySpeciality();
                           else
                                speciality = speciality +", " + users[i].getTertiarySpeciality();
                        }
                      %>
                      <td width="30%" valign="middle" class="text-blue-01" width="100"><%=speciality == null ? "N.A" : speciality%></td>
                      <td width="30%" valign="middle" class="text-blue-01" width="100"><%=users[i].getPrimaryPhone() == null ? "N.A" : users[i].getPrimaryPhone()%></td>
                      <td width="30%" valign="middle" class="text-blue-01" width="100"><%=users[i].getPrimaryEmail() == null ? "N.A" : users[i].getPrimaryEmail()%></td>
                      <td width="15%" valign="middle" class="text-blue-01" width="100">&nbsp;</td>                                              
                    </tr>
                <%}
                } else if(users != null) {%>
                     <tr>
                      
                      <td width="10%" valign="middle" class="text-blue-01">&nbsp;</td>
                      <td width="30%" valign="middle" class="text-blue-01" width="100">&nbsp;</td>
                      <td width="30%" valign="middle" width="100"><font face="verdana" color="#ff0000" size="2"> <b> No result found &nbsp; </b></td>
                      <td width="30%" valign="middle" class="text-blue-01" width="100">&nbsp;</td>
                      <td width="15%" valign="middle" class="expertListRow" width="100">&nbsp;</td>                                   
                    </tr>
                    <% } %>    
        
        
      </table>
    </div></td>
    <br>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="producttext">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>
            <tr>
              <td width="10" height="20">&nbsp;</td>

              <td class="text-blue-01" width="20"><input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:22px;" class="button-01" value="" onClick="javascript:window.close()" /></td>

              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>
            
          </table></td>
  </tr>
</table>
</div>
</form>
</body>
</html>