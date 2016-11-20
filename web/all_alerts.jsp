<%@ page import="com.openq.alerts.data.AlertQueue"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@include file = "commons.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Alert List</title>
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
</style>
</head>

<body>
	<div class="producttext" style="overflow:auto">
			<div class="myexpertlist">
				<div class="myexperttext">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Alert List</div>
				<div class="clear"></div>
			</div>

            <table width="100%" cellspacing="0">
			  <tr bgcolor="#faf9f2">
			    <td width="5%" class="expertListHeader"></td>
				<td width="25%" class="expertListHeader">Alert Category</td>
				<td width="60%" class="expertListHeader">&nbsp;Message</td>
			  </tr>

                    <%
                     AlertQueue[] queue = (AlertQueue[])session.getAttribute(Constants.ALERT_QUEUE);
                     for( int i = 0; i < queue.length; i++ )
                     {
                        int j = queue.length-i-1;
                        String name = (queue[j].getAlert().getName() == null) ? "" : queue[j].getAlert().getName();
                        String message = (queue[j].getMessage() == null)? "" :queue[j].getMessage();
                    %>

                    <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
 					<td width="5%" align="left" class=text-blue-01></td>
	  				<td width="25%" align="left" class=text-blue-01><%=name%></td>
	  				<td width="60%" align="left" class=text-blue-01><%=message%></td>

                    </tr>
                    <%}%>
               </table>
         </div>
</body>
</html>