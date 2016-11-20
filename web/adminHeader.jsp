<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.authentication.UserDetails" %>
<%
  java.util.Properties featuresProp = DBUtil.getInstance().featuresProp;
	if(request.getSession().getAttribute(Constants.CURRENT_USER) != null){
		UserDetails currentUser = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
		if(currentUser != null && currentUser.getUserType().getId() != 1){ // 1 is the user_type_id for admin user
			response.sendRedirect("sessionexpired.jsp?accessDenied=true");
		}
	}else{
		response.sendRedirect("sessionexpired.jsp");
	}
%>
<HTML>
<HEAD>
  <TITLE>BMS Synergy</TITLE>
  <LINK href="css/openq.css" type=text/css rel=stylesheet>
    <!-- The current values will be substituted in the output file by an ant task during build -->
    <meta svnHighestRevisionNumber=1>
    <meta svnLastCommitedRevisionNumber=1>
    <meta buildVersionNumber=1>
    <meta buildDate="mm/dd/yyyy hh:mm:ss aa">

</HEAD>
<script src="./js/utilityFunctions.js"></script>
<script language="javascript">
 <%
		String disclaimer = (String)request.getSession().getAttribute("disclaimer");

		if (disclaimer!=null && disclaimer == "true")
		{
	%>
			//flag = "true";
			if(!confirm("Your use of this system including how and what information is acquired and added, and how the information is used to implement medical plan objectives and activities, must be in compliance with all applicable laws, regulations, rules and company policies. Users are required to comply with all training provided prior to use of this tool.  If you have any questions or are unclear about the appropriate use of synergy, please speak with your manager before accessing the system."))
			{
				alert("You are logging out of synergy and your browser will be closed.")
				if(window.close())
					window.location.href="login.htm?action=logout";
				else
					window.location.href="login.htm?action=logout";
			}
	<%
		session.removeAttribute("disclaimer");
		}
	%>


  function help() {
    alert("For demonstration purpose only. All links are just placeholders.");
  }
</script>
<script language="javascript">
	 var win ;
	function openProgressBar() {
  	  /* win = window.open('start.jsp','searchHCP','width=500,height=100,top=375,left=250,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
	     win.focus();
	  */
	    document.forms[0].submit();
	/*	win= window.showModalDialog('main.jsp','Locations','dialogHeight:100px;dialogWidth:400px;scroll:no;resizable:no;status:no;center:no');*/
	    win= window.showModelessDialog('main.jsp','Locations','dialogHeight:150px;dialogWidth:500px;scroll:no;resizable:no;status:no;center:yes;help:no;unadorned:yes');
	}

	function checkForProgressBar(){
		if(win != null){
			if(!win.closed){
				win.close();
			}
		}
	}

	function logOutFunction()
	{
		if(confirm("You are logging out of synergy and your browser will be closed."))
		{
			if(window.close())
				window.location.href="login.htm?action=logout";
		}
	}

	</script>
<%
  String completeName = (String) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);

  String currentLink = null;
  if (null !=  session.getAttribute("CURRENT_LINK")){
    currentLink = (String)session.getAttribute("CURRENT_LINK");
  }
%>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" onUnload="javascript:checkForProgressBar()">

   <div class="outerdiv">

		<div class="banner">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td class="logo"></td>
				<td class="logoright"></td>
			</tr>
		</table>
		</div>
   		<table width="100%" cellpadding="0" cellspacing="0">

					<tr class="menubar">
						<% if (null != currentLink && currentLink.equalsIgnoreCase("USERS")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/icon_menu_user_mgmt.gif"></div>
								<div class="menuSelectedText">&nbsp;&nbsp;
									<a class="text-blue-link" href="admin.htm">Users</a>
								</div>
							</div>
						</td>

						<% if (null != currentLink && currentLink.equalsIgnoreCase("GROUPS")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/icon_menu_user_grp_mgmt.gif"></div>
								<div class="menuNotSelectedText">
									&nbsp;&nbsp;
									<a class="text-blue-link" href="grp.htm">Groups</a>
								</div>
							</div>
						</td>

						<% if (null != currentLink && currentLink.equalsIgnoreCase("LIST")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%"  class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/icon_menu_app.gif"></div>
								<div class="menuNotSelectedText">
									&nbsp;&nbsp;
									<a class="text-blue-link" href="list.htm">List of Values</a>
								</div>
							</div>
						</td>

						<% if (null != currentLink && currentLink.equalsIgnoreCase("METADATA")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/icon_menu_user_meta_mgmt.gif"></div>
								<div class="menuNotSelectedText">
									&nbsp;&nbsp;
									<a class="text-blue-link" href="metadataEdit.htm">Meta Data</a>
								</div>
							</div>
						</td>

						<% if (null != currentLink && currentLink.equalsIgnoreCase("PUBCAP")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
								<div class="menuNotSelectedText">&nbsp;&nbsp;
									<a class="text-blue-link" href="pubcap.htm">PubCap</a>
								</div>
							</div>
						</td>

						<% if (null != currentLink && currentLink.equalsIgnoreCase("REPORTS")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/expertpic.gif"></div>
								<div class="menuNotSelectedText">&nbsp;&nbsp;
									<a class="text-blue-link" href="reportsAdmin.htm">Reports</a>
								</div>
							</div>
						</td>
                                          <%if(!(featuresProp!=null && featuresProp.getProperty("SURVEY")!=null && featuresProp.getProperty("SURVEY").equalsIgnoreCase("false"))){
                                          	if (null != currentLink && currentLink.equalsIgnoreCase("SURVEY")) {%>
                                            <td width="10%" class="menuSelected">
                                          <%}else {%>
                                              <td width="10%" class="menuNotSelected">
                                          <%}%>
                                            <div class="mpictext">
                                                <div class="menuIcon"><img src="images/expertpic.gif"></div>
                                                  <div class="menuNotSelectedText">&nbsp;&nbsp;
                                                    <a class="text-blue-link" href="survey.htm">Survey</a>
                                                  </div>
                                                </div>
                                              </td>
										<%} %>
						<% if (null != currentLink && currentLink.equalsIgnoreCase("ALERTS")) {%>
							<td width="10%" class="menuSelected">
						<%}else {%>
							<td width="10%" class="menuNotSelected">
			            <%}%>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/alert.JPG"></div>
								<div class="menuNotSelectedText">&nbsp;&nbsp;
									<a class="text-blue-link" href="alert.htm">Alerts</a>
								</div>
							</div>
						</td>


						<%
							if (null != currentLink
									&& currentLink.equalsIgnoreCase("GLOBAL_CONSTANTS")) {
						%>
							<td width="10%" class="menuSelected">
						<%
							} else {
						%>
							<td width="10%" class="menuNotSelected">
			            <%
			            	}
			            %>
							<div class="mpictext">
								<div class="menuIcon"><img src="images/alert.JPG"></div>
								<div class="menuNotSelectedText">&nbsp;&nbsp;
									<a class="text-blue-link" href="globalConstants.htm">Global Settings</a>
								</div>
							</div>
						</td>


						</tr>
					</table>


                      <div class="welcome">
						<div>
							<div class="welcometext">&nbsp;&nbsp;<%=completeName == null ? "" : "Welcome " + completeName%>&nbsp;</div>
							<div style="float:right;padding-right:20px;">
								<div style="float:left;padding-top:3px;"><img src="images/helppic.jpg"></div>
									&nbsp;
									<a class="text-blue-link" href="#">Help</a>
								&nbsp;&nbsp;|&nbsp;&nbsp;
								<a class="text-blue-link" href="#" onclick="logOutFunction()">Logout</a>
							</div>
						 </div>
						<div class="clear"></div>
					</div>

      <!-- body starts here -->
