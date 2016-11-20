<html>

&nbsp;<head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><link href="css/openq.css" type="text/css" rel="stylesheet"><script language="javascript">
function abc()
{
var a;
var a=parseInt(profCap.T1.value);
if(a<=0)
{
alert("Please Enter number greater than 0");
profCap.T1.value="";
profCap.T1.focus();
}
if(isNaN(a))
{
alert("You can only enter number");
profCap.T1.value="";
profCap.T1.focus();
}
}

	function help() {
		alert("For demonstration purpose only. All links are just placeholders.");
	}
</script><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
    <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
    }

    -->
</style><%

	String msg = (String) request.getSession().getAttribute("message");
	Integer cExp = (Integer)request.getSession().getAttribute("countExperts");
%>
</head>

<body class="" >
<div align="center">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="210">
  <tr>
     <td class="back_horz_head" align="left" height="22" valign="top">
     <table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
      <tbody><tr align="left" valign="middle" class="myexpertplan">
        <td height="22" width="2%">&nbsp;</td>
        <td width="2%" height="22"><img src="images/icon_search.gif" height="14" width="14"></td>
        <td class="myexperttext" height="22"><font face="verdana">Profile Capture - Ovid Search</font></td>
      </tr>
     </tbody></table></td>
    </tr>
<tr class="back-white">
<td>
<form name="profCap" method="post"  action="pubschedule.htm" >
<div align="">
<table  border="0" cellpadding="0" cellspacing="0" width="70%" height="74">
			<tbody>
			<tr style="color:#4C7398" align="left">		
				<td height="54" class="pubcaprow"><b><font face="verdana" size="-1">Status</font></b></td>
				<td height="54"><b>:</b>&nbsp;&nbsp;&nbsp;&nbsp;<font face="verdana" size="-1"><%=msg%></font></td>
</tr>
				<tr style="color:#4C7398" align="left">
				<td height="34" class="pubcaprow"><font face="verdana" size="-1">Total experts available</font></td>
				<td height="34"><b>:</b>&nbsp;&nbsp;&nbsp;&nbsp;<font face="verdana" size="-1"><%=cExp.intValue() %></font></td>
			
</tr>
				<tr style="color:#4C7398" align="left">
				<td height="38" class="pubcaprow"><b><font face="verdana" size="-1">Run Profile Capture</b></font></td>
				<td height="38"><b>:</b>&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="submit" style="border:0;background : url(images/buttons/fire_request.gif);width:106px; height:22px;" name="submitb" class="button-01" value=""/>&nbsp;
				<input type="submit" style="border:0;background : url(images/buttons/refresh_status.gif);width:120px; height:22px;" class="button-01" value="" name="Refresh"></td>
			
</tr>
				<tr>
				<td height="22" align="center">&nbsp;</td>
				<td >&nbsp;</td>
			
</tr>
</tbody></table>
	</div>
</form>

</td>
</tr>
</table>
</div>
</body>
</html>