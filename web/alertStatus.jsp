<%@ page language="java"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.openq.alerts.data.*"%>
<html>
<head>
<meta http-equiv="Content-Type"
  content="text/html; charset=windows-1252">
<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript">
  function addAlert() {
     document.location.href="addalert.htm?action=alertsStep1";
  }
function checkAlerts(chk)
 {
	var flag=0;
	var i;
	for(i=0;i<chk.length;i++)
	 {
		 if(chk[i].checked == true)
	 		   flag = 1;
	 }   
	 if(flag == 1)
		 document.alert.submit();
	  else
	 {
		  alert('Please Check any of the Alerts');
		  
	 }

   
 }

  function refreshAlerts() {
    document.location.href="alert.htm?action=alertsStatus";
  }
</script>
<script type="text/javascript" src="./js/sorttable.js"></script>
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="200">
  <tr>
    <form name="alert" method="post" action="alert.htm">
    <td class="myexperttext1" align="left" height="1" valign="top">Status Of Alerts&nbsp; - <font size="2">Click on an Alert to Edit</font>
    <div class="myexperttext" style=width:100%>
    	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="1">
      <tbody>
        <tr>
          <td class="text-blue-01" colspan="4" height="1%" width="100%"><b>
          <br>
          
          </b> <input name="edit1" class="button-01" value="" style="border:0;background : url(images/buttons/add_alert.gif);width:88px; height:22px;" onclick="javascript:addAlert();" type="button">&nbsp;
          <input name="delete" class="button-01" style="border:0;background : url(images/buttons/delete_alert.gif);width:105px; height:22px;" value="" onclick="javascript:checkAlerts(document.alert.selected_alerts);" type="button"/>

          <input name="refresh" class="button-01" style="border:0;background : url(images/buttons/refresh.gif);width:80px; height:22px;" value="" onclick="javascript:refreshAlerts();" type="button"/>
          <hr>
          </td>
        </tr>
        <tr>
          <td class="text-blue-01" width="4" height="26" valign="top">
          <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
            <tbody>
              <tr>
                <td border-right="1px black" class="back-white" valign="top" width="5%">&nbsp;</td>
              </tr>
            </tbody>
          </table>
          </td>
          <div align="center">
          <table border="0" cellpadding="0" style="border-collapse: collapse"
            bordercolor="#111111" width="100%" id="AutoNumber1" height="10%" class="sortable">
            <tr class="myexpertplan" style=width:100%>
            <td class="text-blue-01" width="4%" height="15"><b>Sl.No.</b></td>
              <td class="text-blue-01" width="4%" height="15"><b>&nbsp;</b></td>
              <td class="text-blue-01" width="25%" height="15"><b>Alert Name </b></td>
              <td class="text-blue-01" width="14%" height="15"><b>Last Updated</b></td>
              <td class="text-blue-01" width="19%" height="15"><b>Delivery Mechanism</b></td>
              <td class="text-blue-01" width="21%" height="15"><b>User Groups</b></td>
              <td class="text-blue-01" width="13%" height="15"><b>Status</b></td>
            </tr>
            <%
                Alert[] alerts = (Alert[])session.getAttribute(Constants.ALERTS);
                DateFormat format = DateFormat.getDateInstance();
                for(int i = 0; i < alerts.length; i++) {
            %>
            <tr style=width:100%>
              <td class="text-blue-01" width="4%" height="20"><%=i + 1 %></td>
              <td class="text-blue-01" width="4%" height="20">
              <input type="checkbox" name="selected_alerts" value="<%=alerts[i].getId() %>"></td>
              <td class="text-blue-01" width="25%" height="20"><a href="editalert.htm?action=alertsStep1&id=<%=alerts[i].getId() %>" class="text-blue-01-link"s><%=alerts[i].getName() %></a></td>
              <td class="text-blue-01" width="14%" height="20"><%=format.format(alerts[i].getUpdatedAt()) %></td>
              <td class="text-blue-01" width="19%" height="20"><%=alerts[i].getDeliveryString() %></td>
              <td class="text-blue-01" width="21%" height="20"><%=(alerts[i].getRecipientString())==null ? alerts[i].getRecipientString():"N.A" %></td>
              <td class="text-blue-01" width="13%" height="20"><%=alerts[i].getStatusString() %></td>
            </tr>
            <%
                }
            %>
          </table>
          </div>
          </td>
        </tr>
      </tbody>
    </table>
    <p align=left>
    <input type="hidden" name="action" value="alertsDelete" />
	<input name="edit2" class="button-01" value="" style="border:0;background : url(images/buttons/add_alert.gif);width:88px; height:22px;" onclick="javascript:addAlert();" type="button">&nbsp;
              <input name="delete0" class="button-01" style="border:0;background : url(images/buttons/delete_alert.gif);width:105px; height:22px;" value="" onclick="javascript:checkAlerts(document.alert.selected_alerts);" type="button"/>
          <input name="refresh0" class="button-01" style="border:0;background : url(images/buttons/refresh.gif);width:80px; height:22px;" value="" onclick="javascript:refreshAlerts();" type="button"/>
    </p>	
	</div>
	</td>
    </form>
  </tr>
</table>
</body>
</html>