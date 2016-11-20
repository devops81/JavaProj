<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page errorPage="sessionexpired.jsp"%>
<%@ page import="com.openq.utils.PropertyReader"%>
<%
	java.util.Properties featuresProp = DBUtil.getInstance().featuresProp;
  UserDetails currentUser = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
	if ( currentUser == null ){
		response.sendRedirect("sessionexpired.jsp");
	}
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
	String isSAXAJVUserStringHdr = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
	boolean isSAXAJVUserHdr = false;
	if(isSAXAJVUserStringHdr != null && "true".equals(isSAXAJVUserStringHdr)){
			isSAXAJVUserHdr = true;
	}
%>

<%@page import="com.openq.user.User"%>
<%@page import="com.openq.authentication.UserDetails"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>OpenQ KOL Management System</title>
		<LINK href="css/openq.css" type=text/css rel=stylesheet>
		<link rel="stylesheet" href="css/Autocompleter.css" type="text/css"/>


    <script src="./js/cookieHelper.js"></script>
	<script language="javascript">
	<%
		String disclaimer = (String)request.getSession().getAttribute("disclaimer");

		if (disclaimer!=null && disclaimer == "true")
		{
	%>
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

	function printUnavailableMessage()
	{
	 alert('This feature is unavailable at this time')
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
                            <a class="text-blue-link" href="experthome.htm" target="_top">Home</a>
                        <% } else { %>
                           <a class="text-blue-link" href="home.htm" target="_top">Home</a>
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

        <%
            // check if the strategy feature needs to be enabled or not
            String enableStrategy = (String) session.getAttribute("isStrategyFeatureEnabled");
            String strategyTdClass;
            String strategyTdTextClass;
            String strategyTabIcon = "images/mexpertpic.jpg";

            if(enableStrategy == null)
              enableStrategy = "false";

            if("true".equalsIgnoreCase(enableStrategy)) {
              if (null != currentLink && currentLink.equalsIgnoreCase("KOL_Strategy")) {
                strategyTdClass = "menuSelected";
                strategyTdTextClass = "menuSelectedText";
              }
              else {
                strategyTdClass = "menuNotSelected";
                strategyTdTextClass = "menuNotSelectedText";
              }
            }
            else {
              strategyTdClass = "menuDisabled";
              strategyTdTextClass = "menuDisabledText";
              strategyTabIcon = "images/strategy_tab_disabled.gif";
            }
        %>
            <td class="<%=strategyTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="<%=strategyTabIcon%>"></div>
                    <div class="<%=strategyTdTextClass%>">
                        &nbsp;&nbsp;
                        <%
                          if("true".equalsIgnoreCase(enableStrategy)&&!isSAXAJVUserHdr) {
                        %>
                          <a class="text-blue-link" href="javascript:printUnavailableMessage()">Medical Strategy</a>
                        <%
                          } else {
                        %>
                          <span class="text-grey" onclick="javascript:printUnavailableMessage()">Medical Strategy</span>
                        <%
                          }
                        %>
                    </div>
                </div>
            </td>

            <%
                // check if the interactions feature needs to be enabled or not
                String enableInteractions = (String) session.getAttribute("isInteractionsFeatureEnabled");
                String interactionsTdClass;
                String interactionsTdTextClass;

                if(enableInteractions == null)
                  enableInteractions = "false";

                if("true".equalsIgnoreCase(enableInteractions)) {
                  if (null != currentLink && currentLink.equalsIgnoreCase("INTERACTIONS")) {
                    interactionsTdClass = "menuSelected";
                    interactionsTdTextClass = "menuSelectedText";
                  }
                  else {
                    interactionsTdClass = "menuNotSelected";
                    interactionsTdTextClass = "menuNotSelectedText";
                  }
                }
                else {
                  interactionsTdClass = "menuDisabled";
                  interactionsTdTextClass = "menuDisabledText";
                }
            %>
            <td class="<%=interactionsTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="images/interactionpic.jpg"></div>
                    <div class="<%=interactionsTdTextClass%>">
                        &nbsp;&nbsp;
                        <%
                          if("true".equalsIgnoreCase(enableInteractions)) {
                        %>
                          <a class="text-blue-link" href="<%=CONTEXTPATH%>/search_interaction_main.htm?action=<%=ActionKeys.SHOW_ADD_INTERACTION%>" target="_top">Interactions</a>
                        <%
                         } else {
                        %>
                          <span class="text-grey">Interactions</span>
                        <%
                         }
                        %>
                    </div>
                </div>
            </td>

            <%}%>
           <% if(!(featuresProp!=null&&featuresProp.getProperty("PRESENTATIONS")!=null&&featuresProp.getProperty("PRESENTATIONS").equalsIgnoreCase("0"))){
                // check if the presentations feature needs to be enabled or not
                String enablePresentations = (String) session.getAttribute("isPresentationsFeatureEnabled");
                String presentationsTdClass;
                String presentationsTdTextClass;
                String presentationsTabIcon = "images/presentation.png";

                if(enablePresentations == null)
                  enablePresentations = "false";

                if("true".equalsIgnoreCase(enablePresentations)) {
                  if (null != currentLink && currentLink.equalsIgnoreCase("PRESENTATION")) {
                    presentationsTdClass = "menuSelected";
                    presentationsTdTextClass = "menuSelectedText";
                  }
                  else {
                    presentationsTdClass = "menuNotSelected";
                    presentationsTdTextClass = "menuNotSelectedText";
                  }
                }
                else {
                  presentationsTdClass = "menuDisabled";
                  presentationsTdTextClass = "menuDisabledText";
                  presentationsTabIcon = "images/presentation_tab_disabled.png";
                }
            %>
            <td style="display:none" class="<%=presentationsTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="<%=presentationsTabIcon%>" height="22" width="22"></div>
                    <div class="<%=presentationsTdTextClass%>">
                        &nbsp;&nbsp;
                        <%
                          if("true".equalsIgnoreCase(enablePresentations)) {
                        %>
                          <a class="text-blue-link" href="SlideSorter.jsp" target="_top">Presentations</a>
                        <%
                          } else {
                        %>
                          <span class="text-grey">Presentations</span>
                        <%
                          }
                        %>
					</div>
				</div>
			</td>
		<% }%>
            <%
                // check if the events feature needs to be enabled or not
                String enableEvents = (String) session.getAttribute("isEventsFeatureEnabled");
                String eventsTdClass;
                String eventsTdTextClass;
                String eventsTabIcon = "images/calendar_32new.png";

                if(enableEvents == null)
                  enableEvents = "false";

                if("true".equalsIgnoreCase(enableEvents)) {
                  if (null != currentLink && currentLink.equalsIgnoreCase("EVENTS")) {
                    eventsTdClass = "menuSelected";
                    eventsTdTextClass = "menuSelectedText";
                  }
                  else {
                    eventsTdClass = "menuNotSelected";
                    eventsTdTextClass = "menuNotSelectedText";
                  }
                }
                else {
                  eventsTdClass = "menuDisabled";
                  eventsTdTextClass = "menuDisabledText";
                  eventsTabIcon = "images/events_tab_disabled.png";
                }
            %>
            <td class="<%=eventsTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="<%=eventsTabIcon%>" height="22" width="22"></div>
                    <div class="<%=eventsTdTextClass%>">
                        &nbsp;&nbsp;
                        <%
                          if("true".equalsIgnoreCase(enableEvents)) {
                        %>
                          <a class="text-blue-link" href="event_schedule.htm" target="_top">Medical Meetings</a>
                        <%
                          } else {
                        %>
                          <span class="text-grey" onclick="javascript:printUnavailableMessage()">Medical Meetings</span>
                        <%
                          }
                        %>
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
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/search.htm?default=true" target="_top">Advanced Search</a>
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
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/advanced_org_search.htm?action=<%=ActionKeys.ADV_SEARCH_ORG%>" target="_top">Organization</a>
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
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/advanced_trial_search.htm?action=<%=ActionKeys.ADV_SEARCH_TRIAL%>" target="_top">Trial</a>
					</div>
				</div>
			</td>

			-->
            <% if ( !setKol.equalsIgnoreCase("Yes")) { %>
            <%
                // check if the reports feature needs to be enabled or not
                String enableReports = (String) session.getAttribute("isReportsFeatureEnabled");
                String reportsTdClass;
                String reportsTdTextClass;
                String reportsTabIcon = "images/expertpic.gif";

                if(enableReports == null)
                  enableReports = "false";

                if("true".equalsIgnoreCase(enableReports)) {
                  if (null != currentLink && currentLink.equalsIgnoreCase("REPORTS")) {
                    reportsTdClass = "menuSelected";
                    reportsTdTextClass = "menuSelectedText";
                  }
                  else {
                    reportsTdClass = "menuNotSelected";
                    reportsTdTextClass = "menuNotSelectedText";
                  }
                }
                else {
                  reportsTdClass = "menuDisabled";
                  reportsTdTextClass = "menuDisabledText";
                  reportsTabIcon = "images/reports_tab_disabled.gif";
                }
            %>
            <td class="<%=reportsTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="<%=reportsTabIcon%>"></div>
                    <div class="<%=reportsTdTextClass%>">&nbsp;&nbsp;
                      <%
                        if("true".equalsIgnoreCase(enableReports)) {
                      %>
                        <a class="text-blue-link" href="reportsUser.htm">Reports</a>
                      <%
                        } else {
                      %>
                        <span class="text-grey">Reports</span>
                      <%
                        }
                      %>
                    </div>
                </div>
            </td>

            <%   if(!(featuresProp!=null&&featuresProp.getProperty("MAPS")!=null&&featuresProp.getProperty("MAPS").equalsIgnoreCase("0"))){
                // check if the maps feature needs to be enabled or not
                String enableMaps = (String) session.getAttribute("isMapsFeatureEnabled");
                String mapsTdClass;
                String mapsTdTextClass;
                String mapsTabIcon = "images/mappingpic.jpg";

                if(enableMaps == null)
                  enableMaps = "false";

                if("true".equalsIgnoreCase(enableMaps)) {
                  if (null != currentLink && (currentLink.equalsIgnoreCase("NETWORKMAP") ||
                    currentLink.equalsIgnoreCase("KEYWORD_CRAWLER") ||
                    currentLink.equalsIgnoreCase("KEYWORD_CRAWL_RESULTS"))) {
                    mapsTdClass = "menuSelected";
                    mapsTdTextClass = "menuSelectedText";
                  }
                  else {
                    mapsTdClass = "menuNotSelected";
                    mapsTdTextClass = "menuNotSelectedText";
                  }
                }
                else {
                  mapsTdClass = "menuDisabled";
                  mapsTdTextClass = "menuDisabledText";
                  mapsTabIcon = "images/maps_tab_disabled.jpg";
                }
            %>
            <td style="display:none" class="<%=mapsTdClass%>">
                <div class="mpictext">
                    <div class="menuIcon"><img src="<%=mapsTabIcon%>"></div>
                    <div class="<%=mapsTdTextClass%>">&nbsp;&nbsp;
                      <%
                        if("true".equalsIgnoreCase(enableMaps)) {
                      %>
                        <a class="text-blue-link" href="keyword_pubmed_crawler.htm">Maps</a>
                      <%
                        } else {
                      %>
                        <span class="text-grey">Maps</span>
                      <%
                        }
                      %>
                    </div>
                </div>
            </td>

            <%}}%>

		 <%//OrgAlignment Tab
			 if (userTypeId != null && userTypeId.getId() == 650){%>
			                <%if(currentLink != null && currentLink.equalsIgnoreCase("orgAlignment")) { %>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
				<%} %>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/orgAlignment.htm">Org Alignment</a>
					</div>
				</div>
			</td>
			<%} %>
			<%//OLAlignment Tab
			 if (userTypeId != null && userTypeId.getId() == 650){%>
			                <%if(currentLink != null && currentLink.equalsIgnoreCase("OLAlignment")) { %>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
				<%} %>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/OLAlignment.htm">OL Alignment</a>
					</div>
				</div>
			</td>
			<%} %>

			<%//userRelationship Tab
			 if (userTypeId != null && userTypeId.getId() == 650){%>
			    <%if(currentLink != null && currentLink.equalsIgnoreCase("userRelationship")) { %>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
					<%} %>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/userRelationship.htm">User Relationship</a>
					</div>
				</div>
			</td>

				<%} %>




			<%if (null != currentLink && currentLink.equalsIgnoreCase("TIME_REPORT")) {%>
				<td style="display:none" class="menuSelected">
			<%}else {%>
				<td style="display:none" class="menuNotSelected">
            <%}%>
				<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNotSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="<%=CONTEXTPATH%>/timeReport.htm">Time Report</a>
					</div>
				</div>
			</td>
            <%if (null != currentLink && currentLink.equalsIgnoreCase("SPECIALTY_FORMS")) {%>
				<td class="menuSelected">
			<%}else {%>
				<td class="menuNotSelected">
            <%}%>
			<div class="mpictext">
					<div class="menuIcon"><img src="images/expaddpic.jpg"></div>
					<div class="menuNoSelectedText">&nbsp;&nbsp;
						<a class="text-blue-link" href="survey.htm?action=specialitySurvey">Specialty Forms</a>
					</div>
				</div>
			</td>
          </tr>
		</table>

		<!-- Menu ends -->

		<!-- User Header starts -->
		<div class="welcome"><br>
			    <div class="welcometext">&nbsp;&nbsp;<%=completeName == null ? "" : "Welcome " + completeName%> <img id="_onlineOfflineButton" border=0 src="images/<%=_defaultImageName%>" onClick="javascript:toggleOnlineMode()"/></div>

				<div style="float:right;padding-right:50px;">

					  <img src="images/password.gif">
                      <a class="text-blue-link" href="#"
                      onclick="javascript:window.open('userPreference.htm','changepassword','width=450,height=250,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no')">User Preference</A>
                     &nbsp;&nbsp;|&nbsp;&nbsp;


                    <%--<img src="images/password.gif">
                      <a class="text-blue-link" href="#"
                      onclick="javascript:window.open('change_password.htm','changepassword','width=550,height=180,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no')">Change Password</A>
                     &nbsp;&nbsp;|&nbsp;&nbsp;

                    --%><img src="images/helppic.jpg">
				     <a class="text-blue-link" href="<%=CONTEXTPATH%>/synergyHelpFile.doc" target="_blank">Help</a>
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
