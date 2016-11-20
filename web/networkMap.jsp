<%@ page import="java.util.*"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="java.io.InputStream"%>
<!-- saved from url=(0022)http://internet.e-mail -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Network Map</title>
</head>

<%
	session.setAttribute("CURRENT_LINK", "NETWORKMAP");
%>

<%@ include file="header.jsp" %>

<br>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">

<table border="0" cellspacing="0" cellpadding="0" width="100%">

  <!-- Top menu -->


  <!-- Network Map -->
  <tr>
   <td class="text-blue-02-glow">

    <div class="contentmiddle">
     <div class="producttext">
      <table width="100%" height="10" border="0" cellspacing="0" cellpadding="0" >
   	   	
   	<tr>
	<td class="myexpertlist">
	<table width="100%">   
	    	<tr style="color:#4C7398;height=10">
	        			<td width="2%" align="left">
	          				<div class="myexperttext">Network Map</div>
	        			</td>
	      </tr>	
	 </table>
	</td>
	</tr>
        <tr>
            <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
        <tr>
            <td align="left" valign="top" class="back-white">            
            	<table cellpadding=0 cellspacing=0 border=0 align="center">
            	<tr>
            		<!--
					<td width=200 valign=top>
            			<table width=200 cellpadding=5 ><tr><td width=200>
            			<font face="verdana" size="-1">
            				This interactive map of your physician network allows you to explore and 
            				analyze your network of physicians to uncover the strength and the extent
            				of their professional connections with one another.
            				<BR><BR>
            				<b>
            				<u>Instructions</u>
            				<ul>
            					<li>Use the right mouse button to bring up a menu of options</li>
            					<li>To zoom in or out, use the mouse wheel or the zoom slider to the right</li>
            					<li>To move to a different part of the network, click on any whitespace and drag the network</li>
            				</ul>
            				</b>
            			</font>	
            			</td></tr></table>
            		</td>-->
            		<td>
            		<!-- 
            			The following javscript include is a hack that prevents the user
            			from seeing that "Press the spacebar......" message when
            			looking at the page in IE. 
            		 -->
            		<script src="applet/applet_include.js"></script>
					</td>
				</tr>
			 </table>
            </td>
        </tr>
      </table>
     </div>
    </div>
   </td>
  </tr>
</table>
</body>
<%@ include file="footer.jsp" %>
</html>