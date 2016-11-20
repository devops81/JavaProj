<%@ page language="java" %>
<%@ include file = "imports.jsp" %>


<%
	
	String frequency = (String) session.getAttribute("userPreference");
	long preference = -1;
	if(frequency != null && !"".equalsIgnoreCase(frequency))
	 preference = Long.parseLong(frequency);
	String message = (String) session.getAttribute("message");
	System.out.println(preference);
%>
<script language="javascript">

	function savePreference(){
		
		var i = 0;
		for(i = 0;i<4;i++)
		{
			var obj = document.getElementById(i);
			if(obj.checked){
				
				document.userPreference.action = "userPreference.htm?action=savePreference&pref="+i;
                document.userPreference.submit();
                }
          }     
		
		
	}
	
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Preferences</title>
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
<form name="userPreference" method="post">
<input type="hidden" name="parentFormName" value=""/>
<table width="100%" height="90%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10" class="">&nbsp;</td>
    <td class=""><div >
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-white" align="center">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
        	
          <td height="20"  valign="top" class="myexpertlist" align="center" width="98%">
          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
              <td width="5%" align="right"><img src="<%=COMMONIMAGES%>/password.gif" width="14" height="14" /></td>
              <td class="myexperttext">User Preferences</td>
            </tr>
          </table></td>
          <tr>`
         
          <%if(message!=null){%>
           <td height="10" align="center" valign="top" class="back-white" ><font="blue">
          <b><%=message%></b> </font></td>
          <%} %>
          </tr>
        <tr/>
         <tr>
          <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
            
               <td  valign="top" width="5%" align="left"><input value="daily" id=0 type="radio" name="preference" class="field-blue-01-180x20" 
              		<%if ( preference == 0){ %> checked <%} %>/></td>
              <td align="left" class=text-blue-01 width="15%" height="20" valign="top">Daily (12.00 AM) </td>
            </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
            <tr>
               
              <td  valign="top"><input id=1 value="weekly" type="radio" name="preference" class="field-blue-01-180x20" 
               <%if ( preference == 1){ %> checked <%} %>/></td>
              <td class=text-blue-01 width="15%" height="20" valign="top">Weekly (Monday 12.00 AM) </td>
            </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
            <tr>
               
              <td  valign="top"><input id=2 value="monthly" type="radio" name="preference" class="field-blue-01-180x20" 
              <%if (preference == 2){ %> checked <%} %>/></td>
              <td class=text-blue-01 width="15%" height="20" valign="top">Monthly (1st of the Month 12.00 AM) </td>
            </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        
        <tr>
               
              <td  valign="top"><input id=3 value="monthly" type="radio" name="preference" class="field-blue-01-180x20" 
              <%if (preference == 3){ %> checked <%} %>/></td>
              <td class=text-blue-01 width="15%" height="20" valign="top">None</td>
            </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
      </table>
        <table>
        	<tr>
	          <td width="20" height="20" valign="top">&nbsp;</td>
              <td valign="top"><input name="Submit332" type="button" onclick="javascript:savePreference()" class="button-01" style="border:0;background : url(images/buttons/save.gif);width:70px; height:23px;"/></td>
              <td class="text-blue-01" width="20"><input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onClick="javascript:window.close()" /></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top"></td>
        </tr>
      </table>
    </div></td>
  </tr>
</table>
</form>
</body>
<%
//session.removeAttribute("userPreference");
session.removeAttribute("message");
 %>
</html>