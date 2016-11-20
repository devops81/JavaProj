<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%
	UserDetails currentUser = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
	if ( currentUser == null )
		response.sendRedirect("login.htm?message=You have not logged in yet or your session has timed out.");
	String hostName = request.getHeader("host") == null ? "localhost" : request.getHeader("host");
	String offlineImageName = "transparent.gif";
	String onlineImageName = "transparent.gif";
	String _defaultImageName = "transparent.gif";
	if (hostName.indexOf("localhost") >= 0) {
		offlineImageName = "offline.gif";
		onlineImageName = "online.gif";
		_defaultImageName = "loading-icon.gif";
	}

	String staffId = (String) request.getSession().getAttribute(Constants.CURRENT_STAFF_ID);
	String setKol = (String) request.getSession().getAttribute(Constants.CURRENT_KOL_ID_SET);

%>

<%@page import="com.openq.user.User"%>
<%@page import="com.openq.authentication.UserDetails"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>openQ Medical Relationship Management System</title>
		<LINK href="css/openq.css" type=text/css rel=stylesheet>
		<link rel="stylesheet" href="css/Autocompleter.css" type="text/css"/>


    <script src="./js/cookieHelper.js"></script>
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

	function setOfflineOnlineMode() {
		if (getCookie("_OfflineStatus")) {
			document.getElementById('_onlineOfflineButton').src = 'images/<%=offlineImageName%>';
		} else {
			document.getElementById('_onlineOfflineButton').src = 'images/<%=onlineImageName%>';
		}
	}

	function toggleOnlineMode() {
		var _onlineIconName = document.getElementById('_onlineOfflineButton').src.toString();
		if (_onlineIconName.indexOf('online') > 0) {
			if (confirm("Please confirm that you would like to switch to offline mode.")) {
				document.getElementById('_onlineOfflineButton').src = 'images/<%=offlineImageName%>';
			}
			setCookie("_OfflineStatus", "enabled", 15);
		} else {
			if (confirm("Please confirm that you would like to switch to online mode.")) {
				document.getElementById('_onlineOfflineButton').src = 'images/<%=onlineImageName%>';
			}
			eraseCookie("_OfflineStatus");
		}
	}
	</script>
  <script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
  <script language="javascript">
	 dojo.addOnLoad(setOfflineOnlineMode);
  </script>
</HEAD>

<%
	String completeName = (String) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);

	String currentLink = null;
	if (null !=  session.getAttribute("CURRENT_LINK")){
	  currentLink = (String)session.getAttribute("CURRENT_LINK");
	}
   OptionLookup userTypeId = null;
    if (session.getAttribute(Constants.USER_TYPE) != null) {
        userTypeId = (OptionLookup)session.getAttribute(Constants.USER_TYPE);
    }

	Properties prop = DBUtil.getInstance().getDataFromPropertiesFile("resources/ServerConfig.properties");
    String httpsUrl = prop.getProperty("https.url");
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

		<!-- Menu starts -->
		<table width="100%" cellpadding="0" cellspacing="0">
		
		<tr class="menubar">
			<% if (null != currentLink && currentLink.equalsIgnoreCase("HOME")) {%>
				<td  class="menuSelected">
			<%}else {%>
				<td  class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/homepic.jpg"></div>
					<div class="menuSelectedText">&nbsp;&nbsp;
                        <% if ( setKol.equalsIgnoreCase("Yes")) { %>
                            <a class="text-blue-link" href="experthome.htm">Home</a>
                        <% } else { %>
                           <a class="text-blue-link" href="home.htm">Home</a>
                        <% } %>
                    </div>
				</div>
			</td>

			<% if ( setKol.equalsIgnoreCase("Yes")) { %>
				<% if (null != currentLink && currentLink.equalsIgnoreCase("MYPROFILE")) { %>
					<td  class="menuSelected">
				<% } else {%>
					<td  class="menuNotSelected">
				<% } %>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expertpic.gif"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="expertfullprofile.htm?CURRENT_LINK=MYPROFILE&kolid=<%=currentUser.getId()%>&entityId=<%=currentUser.getKolId()%>&currentKOLName=<%=currentUser.getCompleteName()%>">My Profile</a>
					</div>
				</div>
			</td>
			<% } %>

           <% 
               String advS = "Peer";
               if ( !setKol.equalsIgnoreCase("Yes")) { 
		advS = "Expert";
	    %>

            <% if (null != currentLink && currentLink.equalsIgnoreCase("KOL_Strategy")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/mexpertpic.jpg"></div>
					<div class="menuNotSelectedText">
						&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXT_URL%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_STRATEGY%>&fromPage=Main" target="_self">Strategy</a>
					</div>
				</div>
			</td>
			
			<% if (null != currentLink && currentLink.equalsIgnoreCase("INTERACTIONS")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/interactionpic.jpg"></div>
					<div class="menuNotSelectedText">
						&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/search_interaction_main.htm?action=<%=ActionKeys.SHOW_ADD_INTERACTION%>">Interactions</a>
					</div>
				</div>
			</td>

            <%}%>
          <!--  <% if (null != currentLink && currentLink.equalsIgnoreCase("presentation")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
				<div class="menuIcon"><img src="images/presentation.png" height="22" width="22"></div>
					<div class="menuNotSelectedText">
						&nbsp;&nbsp;
						<a class="text-blue-link" href="SlideSorter.jsp">Presentations</a>
					</div>
				</div>
			</td>
		-->
            <% if (null != currentLink && currentLink.equalsIgnoreCase("EVENTS")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
<div class="menuIcon"><img src="images/calendar_32new.png" height="22" width="22"></div>
					<div class="menuNotSelectedText">
						&nbsp;&nbsp;
						<a class="text-blue-link" href="event_schedule.htm">Events</a>
					</div>
				</div>
			</td>
			
			<% if (null != currentLink && currentLink.equalsIgnoreCase("ADVANCED_SEARCH")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXT_URL%>/search.htm?default=true">Advanced Search</a>
					</div>
				</div>
			</td>
			<!--
			<% if (null != currentLink && currentLink.equalsIgnoreCase("ADVANCED_ORG_SEARCH")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXT_URL%>/advanced_org_search.htm?action=<%=ActionKeys.ADV_SEARCH_ORG%>">Organization</a>
					</div>
				</div>
			</td>
			<% if (null != currentLink && currentLink.equalsIgnoreCase("ADVANCED_TRIAL_SEARCH")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
                        <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXT_URL%>/advanced_trial_search.htm?action=<%=ActionKeys.ADV_SEARCH_TRIAL%>">Trial</a>
					</div>
				</div>
			</td>

			-->
            <% if ( !setKol.equalsIgnoreCase("Yes")) { %>
            <% if (null != currentLink && currentLink.equalsIgnoreCase("REPORTS")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expertpic.gif"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="reportsUser.htm">Reports</a>
					</div>
				</div>
			</td>

			<% if (null != currentLink && currentLink.equalsIgnoreCase("NETWORKMAP")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/mappingpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="networkMap.jsp">Maps</a>
					</div>
				</div>
			</td>

            <%}%>
          </tr>
		</table>

		<!-- Menu ends -->

		<!-- User Header starts -->
		<div class="welcome"><br>
			    <div class="welcometext">&nbsp;&nbsp;<%=completeName == null ? "" : "Welcome " + completeName%> <img id="_onlineOfflineButton" border=0 src="images/<%=_defaultImageName%>" onClick="javascript:toggleOnlineMode()"/></div>
				
				<div style="float:right;padding-right:20px;">

                    <img src="images/helppic.jpg">
				     <a class="text-blue-link" href="#" onclick="window.open('help/help.html', 'tinyWindow', 'width=1000,height=800');">Help</a>
					&nbsp;&nbsp;|&nbsp;&nbsp;
					<a class="text-blue-link" href="login.htm?action=logout">Logout</a>

                </div>
		</div>

	    </div>
		   <div class="overlaydiv" id="overlaydiv">
		</div>

   	    <div class="columnchanger1" id="columnchanger">
			<div class="columnchangeheader">
				<div class="changemessage"><b>Select column headers</b></div>
				<div class="closebutton" onclick="javascript: hideColumnChanger();">X</div>
			</div>
			<div class="columnchangecontent">
				<div class="message">Please check the column headers that you want to show up:</div>
				<table class="columnselection">
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Name</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Speciality</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Phone</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Location</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Address</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Availability</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Latest Publication</td>
					</tr>
					<tr>
						<td></td>
						<td><input class="updatebutton" type="button" name="update" value="Update Selection" onclick="javascript: wipeOutColumnChanger();"></td>
					</tr>
				</table>
			</div>
		  </div>



        <!-- User Header ends -->

			<!-- body starts here -->
