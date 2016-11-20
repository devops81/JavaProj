
<%@ include file = "imports.jsp" %>
<script language="JavaScript">
	
	function returnDialogArguments()
	{
   		
	}

	function setReturnValue(value){
     	confirmation.returnValue.value=value;
     	window.opener.markPrimaryContactFlag(confirmation.returnValue.value);
     	window.close();
	}
</script>


<html>
<head>  <LINK href="css/openq.css" type=text/css rel=stylesheet>
<title>Select Primary Contact Type</title>
</head>
<body  onunload="returnDialogArguments()" >
<form name="confirmation">
<input type="hidden" name="returnValue" value=""/>
<table border="0" width="100%" class="back-blue-03-medium">
<tr>
<td class="black-white">
<table border="0" width="100%" class="back-blue-03-medium">
	<tr>
   		<td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
   	</tr>
   	
   	<tr class ="back-white-02-light">
  		<td align="center" width="100%" class="text-black-link:hove" font="Verdana">Primary Contact Designation</td> 	 
   	</tr>
   	<tr>
   		<td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
   	</tr>
</table>
</td></tr>
<tr><td>
<table class ="back-blue-02-light " border="0" width="100%">   	
   	<tr class ="back-blue-02-light  ">
   		<td  align="right"><input name="primaryContact" type="radio" align="center"  value="Yes" onclick="setReturnValue('yes')"/>&nbsp;</td>
   		<td align="right">&nbsp;&nbsp;&nbsp;Yes</td>
    	<td width="20%">&nbsp;</td>
   	</tr>
	<tr class ="back-blue-02-light ">
   		<td align="right"><input name="primaryContact" type="radio" align="center"  value="No" onclick="setReturnValue('no')"/>&nbsp;</td>
   		<td align="right">&nbsp;&nbsp;&nbsp;No</td>
    	<td width="20%">&nbsp;</td>
    </tr>
</table>
</td></tr>
</table>
</form>
</body>
</html>
