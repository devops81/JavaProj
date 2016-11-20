<html>
<%@ page import="com.openq.publication.data.OvidDb" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">


<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript">
	function help() {
		alert("For demonstration purpose only. All links are just placeholders.");
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
    <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
    }

    -->
</style>
<%
	OvidDb [] datasource = (OvidDb [])request.getSession().getAttribute("DATASOURCE");
%>
</head>

<body  class="" >
<div align="center">
<table class="back-white" border="0" cellpadding="0" cellspacing="0" width="100%" height="43">
	<tr>
		<td width="7" align="center"><img src="images/transparent.gif" width="7" height="20"></td>
		<td width="7" align="center"><img src="images/transparent.gif" width="7" height="20"></td>
	</tr>
  <tr>
     <td class="myexpertplan" align="left" height="22" valign="top">
     <table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
      <tbody><tr align="left" valign="middle" style="color:#4C7398">
        <td height="22" width="1%">&nbsp;</td>
        <td width="1%" height="22"><img src="images/icon_my_events.gif" height="14" width="14"></td>
        <td class="myexperttext" height="22">Profile Capture - Ovid Data 
		Bases</td>
      </tr>
      
     </tbody></table></td>
    </tr>
    <tr>
     <td>
     <table border="0" cellpadding="0" cellspacing="0" width="80%">
		<tbody>
			<tr class="myexpertlist" align="left" valign="middle">
			<td align="center" height="25" width="3%">&nbsp;</td>
			<td align="left" width="3%"><img src="images/icon_values.gif" height="14" width="14"></td>
			<td class="myexperttext" width="0%">Database Name</td>
			<td class="myexperttext" width="0%">Short Name</td>
			</tr>
		
	<% for(int i=0; i<datasource.length;i++){ 
	     if(i%2==0) {
	%>
		<tr align="left" valign="middle">
	<% }else { %>
		<tr class="back-blue-02-light" align="left" valign="middle">
	<% }%>
			<td align="center" height="21" width="3%">&nbsp;</td>
			<td align="left" width="3%"><img src="images/icon_check.gif" height="14" width="14"></td>
			<td class="text-blue-01" width="27%"><%=datasource[i].getOvidDatabaseNameFull() %> </td>
			<td align="center" height="21" width="2%">&nbsp;</td>
			<td class="text-blue-01" width="48%"><%=datasource[i].getOvidDatabaseName() %></td>
			<td align="center" height="21" width="12%">&nbsp;</td>
		</tr>
		<% }%>
		
		<tr align="left" valign="middle">
			<td align="center" height="41" width="3%">&nbsp;</td>
			<td align="left" width="3%">&nbsp;</td>
			<td class="text-blue-01" width="27%">&nbsp;</td>
			<td align="center" height="41" width="2%">&nbsp;</td>
			<td class="text-blue-01" width="48%">&nbsp;</td>
			<td align="center" height="41" width="12%">&nbsp;</td>
		</tr>
		
	</tbody></table>

     
     </td>
    </tr>
</table>
</div>
</body>

</html>