<%@ page import="com.openq.web.controllers.Constants" %>
<%@include file = "commons.jspf"%>
<html>
<head>
	<title>BMS Synergy</title>
	<meta http-equiv=Content-Type content="text/html; charset=iso-8859-1">
	<link href="css/openq.css" type=text/css rel=stylesheet>
<%
	Cookie[] cookies = request.getCookies();
	boolean siteMinderAuth = false;
	if (cookies != null && cookies.length > 0) {
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().trim().equalsIgnoreCase("sm_user")) {
				siteMinderAuth = true;
			}
		}
	}
%>
<script>
		function relogin(){
			var thisform = document.errorpageForm;
			var newWindow;
			if(<%=siteMinderAuth%> == true){
				newWindow = window.open('siteMinderLogin.htm','_blank');
			}else{
				newWindow = window.open('login.jsp','_blank');
			}
			newWindow.focus();
			window.close();
		}
	</script>
</head>
<body>
<form name="errorpageForm" >
<div>
		<div>
			<div><img src="images/loginbannerleftsynergy.jpg"></div>
			<div class="clear"></div>
		</div>
		<div>
			<div>
				<div>
					<table width="100%" cellspacing="0" align="left">
				  		<tr width="100%">
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
			    			<td>
				    			<font face="Verdana" size="2" color="#4c7398">
				    			<%
				    				String accessDenied = request.getParameter("accessDenied");
				    				if ("true".equals(accessDenied)) {
				    			%>
				    				<%=Constants.ACCESS_DENIED_MESSAGE%>
				    			<%
				    				} else {
				    			%>
				    				<%=Constants.LOGIN_FAILED_MESSAGE%>
				    			<%
				    				}
				    			%>
				    			</font>
			    			</td>
				  		</tr>
				  		<tr>
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
				  		</tr>
				  		<tr>
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
				  			<td>
				    			<input type="button" class="button-01" value="" name=Submit2 style="border:0;background : url(images/buttons/login.gif);width:50px; height:22px;" onclick="relogin()"/>
				    		</td>
				  		</tr>
				   </table>
			    </div>
		<div class="clear"></div>
	  </div>
      </div>
	</div>
</form>
<div class="footer" style="width:99%">
		<div class="copyrighttext">
			Copyright 2007 OpenQ. All Rights Reserved.  |  Contact Us  |   www.openq.com
		</div>
</body>
</html>