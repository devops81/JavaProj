<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<HTML>
	<HEAD><TITLE>BMS Synergy</TITLE>
	<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
    <!-- The current values will be substituted in the output file by an ant task during build -->
    <meta svnHighestRevisionNumber=1>
    <meta svnLastCommitedRevisionNumber=1>
    <meta buildVersionNumber=1>
    <meta buildDate="mm/dd/yyyy hh:mm:ss aa">
	<LINK href="css/openq.css" type=text/css rel=stylesheet>

    <script src="js/getBrowserVersion.js"></script>
	<SCRIPT>

	function FocusUserdata() {
		document.loginForm.userName.focus();
	}

	detectBrowser();

	</SCRIPT>
<BODY onload=FocusUserdata()>
<%
    String _msg = request.getParameter("message");
%>
<FORM name=loginForm action=login.htm method=post>
<div class="loginouterdiv">
		<div class="loginbanner">
			<div class="loginbannerleft"><img src="images/loginbannerleftsynergy.jpg"></div>
			<div class="loginbannerright"><img src="images/loginbannerright.jpg"></div>
			<div class="clear"></div>
		</div>
		<div class="logincontentpictext">
			<div>
				<div class="logincontentpic"><img src="images/loginpic.jpg"></div>
				<div class="logincontenttext">
					<table width="100%" height="100%" cellspacing="0" align="left">
				  		<tr width="100%" height="70">
				    			<td width="20%">&nbsp;</td>
				    			<td class="boldp">&nbsp;</td>
				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td class="boldp">Username</td>
				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td><input name="userName" type="text" class="boldp"></td>
				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td class="boldp">Password</td>
				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td><input name="userPassword" type="password" class="boldp"></td>
				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>

				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td class="boldp">
								<div class="login">
									<input type="submit" class="button-01" value="" name=Submit2 style="border:0;background : url(images/buttons/login.gif);width:50px; height:22px;"/>
								</div>
							</td>

				    			<td>&nbsp;</td>
				  		</tr>
				  		<tr width="100%">
				    			<td width="20%">&nbsp;</td>
				    			<td class="boldpred"><%if (_msg == null) {%><c:out escapeXml="false" value="${status}"/><%} else { %> <%=_msg%><%}%></td>
				    			<td>&nbsp;</td>
				  		</tr>
				   </table>
			    </div>
		<div class="clear"></div>
	  </div>
      </div>
	<div class="table"><table width="100%" cellspacing="0" bgcolor="#f3f0df">
  	<tr>
    		<td width="94" height="70">&nbsp;</td>
    		<td width="911">&nbsp;</td>
  	</tr>
  	<tr>
    		<td>&nbsp;</td>
    		<td>&nbsp;</td>
  	</tr>
</table>
</div>

	</div>
</form>
<div class="footer" style="width:99%">
		<div class="copyrighttext">
			Copyright 2007 OpenQ. All Rights Reserved.  |  Contact Us  |   www.openq.com
		</div>
</body>
</html>