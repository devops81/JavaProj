<%@ include file="header.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ page import="com.openq.event.materials.EventMaterial"%>
<%@ page import="com.openq.alerts.data.AlertQueue"%>
<%@ page import="java.util.Collection"%>
<%@ page import="com.openq.report.Report"%>
<%
  String kolId = (String) request.getSession().getAttribute(Constants.USER_ID);
	UserDetails ud = (UserDetails) session.getAttribute(Constants.CURRENT_USER);

  boolean isEventsEnabled = false;
  String eventsEnabledVersionPropVal = (String) session.getAttribute("isEventsFeatureEnabled");
  if((eventsEnabledVersionPropVal != null) && ("true".equalsIgnoreCase(eventsEnabledVersionPropVal)))
    isEventsEnabled = true;
%>

<%@page import="org.apache.commons.collections.MultiMap"%>
<%@page import="java.util.Map"%>
<script type="text/javascript">
  dojo.require("dojo.fx");
  var selectedYear, selectedMonth, selectedDay;
  var availColors = { 0:"#FF0000" , 1:"#008000", 2:"#99CC00", 3:"#FFFFFF"};
  var myHandlers = {
    resetMenu : function(){
      dojo.style(dojo.byId('availabilityMenu'), "display", "none");
    }
  };

  function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1)
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

  function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }

  function showAvailabilityMenu(offsetX, offsetY, year, month, day){
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    var calFrame = dojo.byId('calendarFrame');
    var menuX = findPosX(calFrame) + offsetX;
    var menuY = findPosY(calFrame) + offsetY;

    dojo.style(dojo.byId('availabilityMenu'), "display", "block");
    dojo.style(dojo.byId('availabilityMenu'), "width", "auto");
    dojo.style(dojo.byId('availabilityMenu'), "height", "auto");
    dojo.style(dojo.byId('availabilityMenu'), "top", menuY);
    dojo.style(dojo.byId('availabilityMenu'), "left", menuX);

    dojo.fx.wipeIn({
      node: dojo.byId('availabilityMenu'), 
      duration: 300
    }).play();
  }

  function viewEvents(){
    window.open('eventsList.htm?eventdate='+selectedYear+'-'+selectedMonth+'-'+selectedDay, 'eventDetails',"top=200,left=200,width=400,height=200,scrollbars=1,resizable=1");
  }

  function setPreference(pref){

    var myjsp2call = "experthome.htm?selectedYear="+selectedYear+"&selectedMonth="+selectedMonth+"&selectedDay="+selectedDay+"&pref="+pref;
    window.location.href = myjsp2call;
  }

  function showTab(tabID){
   <%
     // Render the events tab related code only if events are enabled
     if(isEventsEnabled) {
   %>
    dojo.style(dojo.byId('Tab1'), "display", "none");
    dojo.byId('Tab1Header').className = "menu-inactive"
   <%
    }
   %>
    dojo.style(dojo.byId('Tab2'), "display", "none");
    dojo.byId('Tab2Header').className = "menu-inactive";
    dojo.style(dojo.byId(tabID), "display", "block");
    dojo.byId(tabID+"Header").className = "menu-active";
  }

  function pageOnLoad(){
   <%
     // Render the events tab related code only if events are enabled
     if(isEventsEnabled) {
   %>
    showTab('Tab1');
   <%
    } else {
   %>
    showTab('Tab2');
   <%
    }
   %>
    dojo.connect(document,"onclick", myHandlers, "resetMenu");
  }

  dojo.addOnLoad(pageOnLoad);
</script>
<div id="availabilityMenu" style="position: absolute; display: none; text-align: left; left:7px; top:17px">
  <ul class="menulist text-blue-01">
    <li><a href="javascript:setPreference(0)"><img src="images/008000.gif"/>&nbsp;&nbsp;1st Preference</a></li>
    <li><a href="javascript:setPreference(1)"><img src="images/99CC00.gif"/>&nbsp;&nbsp;2nd Preference</a></li>
    <li><a href="javascript:setPreference(2)"><img src="images/FF0000.gif"/>&nbsp;&nbsp;Unavailable</a></li>
    <li><a href="javascript:setPreference(3)"><img src="images/white.jpg"/>&nbsp;&nbsp;Reset</a></li>
    <hr style="width: 90%; text-align: center;"/>
    <li><a href="javascript:viewEvents()"><img src="images/calendar16.jpg"/>&nbsp;&nbsp;View Medical Meetings</a></li>
  </ul>
</div>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td height="10px"></td>
  </tr>
  <tr>
    <td width="20%" align="left" valign="top">
      <div class="contentleft" id="expertInfoPanel" style="width: 100%;">
        <div class="koldetails" style="height: auto;">
          <div class="leftsearchbgpic">
            <div class="leftsearchtext">My Details</div>
          </div>
          <div class="manpic">
            <img align="center" onerror="javascript:document.getElementById('_OlImage').src = 'photos/noimage.jpg';" id="_OlImage" src=<%=CONTEXTPATH%>+"/olpic/photos/Photo_<c:out value="${kol.details.firstName}"/>_<c:out value="${kol.details.lastName}"/>.jpg" width="170" height="150" />
          </div>
          <div class="profileguesttext">
            <span class="text-blue-01-bold">
              <c:out value="${kol.details.prefix.optValue}" />
              <c:out value="${kol.details.firstName}" />
              <c:out value="${kol.details.middleName}" />
              <c:out value="${kol.details.lastName}" />
            </span>
            <br />
            <span class="text-blue-01-bold">
              <c:out value="${kol.details.location}" />
            </span>
          </div>
        </div>
        <div class="koldetails" style="height: auto;">
          <div class="leftsearchbgpic">
            <div class="leftsearchtext">Highlights</div>
          </div>
          <div class="profileguesttext">
            <div class="text-blue-01-bold">
              <div style="padding: 2px 0px 2px 0px;">Invitations this Qtr: <span style="color: red;"><c:out value="${eventsThisQtrSize}"/></span></div>
              <div style="padding: 2px 0px 2px 0px;">Acceptance for next 6mo: <c:out value="${acceptancesNext6MoSize}"/></div>
              <div style="padding: 2px 0px 2px 0px;">Contract Exp: 12/07</div>
            </div>
          </div>
        </div>
        <div class="koldetails" style="height: auto;">
          <div class="leftsearchbgpic">
            <div class="leftsearchtext">What's new this month</div>
          </div>
          <div class="profileguesttext">
            <table>
              <tr>
                <td><img src="images/expertpic.gif"/></td>
                <td class="text-blue-01-bold"><c:out value="${presentationsThisMonthSize}"/> Presentation</td>
              </tr>
              <%
                // Render the events related code only if events are enabled
               if(isEventsEnabled) {
              %>
              <tr>
                <td><img src="images/invitation.gif"/></td>
                <td class="text-blue-01-bold"><c:out value="${eventsThisMonthSize}"/> Medical Meeting</td>
              </tr>
              <%
               }
              %>
            </table>
          </div>
        </div>
      </div>
    </td><!-- KOL Details -->
    <!--content left ends here-->
    <td valign="top">
    <div id="topWidgetPane" style="width: 100%">
      <div id="leftColumn" style="padding: 0px 5px 0px 5px;  float: left; width: 100%;">
        <table width="100%" cellspacing="0" style="cursor: hand;">
          <tr>
           <%
            // Render the events tab only if events are enabled
            if(isEventsEnabled) {
           %>
            <td id="Tab1Header" class="menu-active" align="center" style="width: 50%">
              <div onclick="javascript:showTab('Tab1')">
                My Medical Meeting List
              </div>
            </td>
           <%
            }
           %>
           
            <td id="Tab2Header" class="menu-inactive" align="center" style="width: 50%">
              <div onclick="javascript:showTab('Tab2')">
                My Presentations
              </div>
            </td>
          </tr>
        </table>
        
        <%
          // Render the events tab only if events are enabled
          if(isEventsEnabled) {
        %>
        <div id="Tab1" style="float: left; border: 1px; width: 100%;">
          <div class="tabcontent">
            <table width="100%"  valign="top" border="0" cellspacing="0" cellpadding="0">
              <tr class="back-grey-02-light" style="height: 5px;">
                <td width="5%" align="right"></td>
              </tr>
            </table>
            <iframe src='event_search.htm?action=<%=ActionKeys.SHOW_EVENTS_BY_EXPERT%>&kolId=<%=kolId%>' name="rightPane" height="80" width="100%" frameborder="0" scrolling="yes" style="background-color:#fcfcf8;"></iframe>
          </div>
        </div>
        <%
          }
        %>
    
        <div id="Tab2" style="float: left; border: 1px; width: 100%;display:none; ">
          <div class="tabcontent">
            <table width="100%"  valign="top" border="0" cellspacing="0" cellpadding="0">
              <tr class="back-grey-02-light" style="height: 5px;">
                <td width="5%" align="right"></td>
              </tr>
            </table>
            <div>
              <table width="100%"  valign="top" border="0" cellspacing="0" cellpadding="0">
                <tr class="back-grey-02-light" style="height: 20px;">
                  <td width="5%" align="right">&nbsp;</td>
                  <td width="20%" class="text-blue-01-bold">Medical Meeting Title</td>
                  <td width="30%" class="text-blue-01-bold">Material</td>
                  <td width="30%" class="text-blue-01-bold">Description</td>
                  <td width="10%" class="text-blue-01-bold">&nbsp;</td>
                  <td width="5%">&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="9" class="back-blue-03-medium"><img src="http://localhost:7351/webapp/images/transparent.gif" width="1" height="1" /></td>
                </tr>
                <%
                  if (session.getAttribute("expertMaterialMap") != null) {
                    MultiMap expertMaterialMap = (MultiMap) session.getAttribute("expertMaterialMap");
                    for (Iterator itr=expertMaterialMap.entrySet().iterator(); itr.hasNext();) {
                      Map.Entry entry = (Map.Entry) itr.next();
                      String eventTitle = entry.getKey().toString();
                      Collection materials = (Collection) entry.getValue();
                      for (Iterator matItr = materials.iterator(); matItr.hasNext();){
                        EventMaterial mat = (EventMaterial) matItr.next();
                %>
                <tr>
                  <td width="5%" align="right">&nbsp;</td>
                  <td width="20%" class="text-blue-01"><%=eventTitle%></td>
                  <td width="30%" class="text-blue-01"><a href="<%=CONTEXTPATH%>/exp_present_mat.htm?action=getFile&materialId=<%=mat.getMaterialID()%>"><%=mat.getName()%></a></td>
                  <td width="30%" class="text-blue-01"><%=mat.getDescription()%></td>
                  <td width="10%" class="text-blue-01-bold"><a href="SlideSorter.jsp" >download</a></td>
                  <td width="5%">&nbsp;</td>
                </tr>
                <%
                      }
                    }
                  }
                %>
              </table>
              <br/>
            </div>
          </div>
        </div>
        <br />
        <br />
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
          
            <%
                // Render the availablity-related fields only if events are enabled
                if(isEventsEnabled) {
            %>
        <td align="center" width="230px" valign="top">
            <table width="98%" align="center">
                <tr>
                  <td valign="top" width="217" align="left" colspan="2">
                    <!--
                      Following is a dummy form which is used by the calendar widget to set the selected date.
                      Note the name of the form and the the input field are fixed. If they are changed the
                      calendar widget would start showing javascript errors.
                    -->
                    <form name="demoForm">
                      <input type="hidden" name="dateField"/>
                    </form>
                    <div id="calendarFrame">
                        <iframe id ="calendarIFrame" width="200" height=165 name="gToday:normal:agenda.jsp?disablePopup=true&source=1expert"
                                                            id="gToday:normal:agenda.jsp?disablePopup=true&source=1expert"
                                                            src="calendar/calendar.htm?abc=calendar&source=1expert&kolid=<%=kolId%>" scrolling="no" frameborder="0">
                        </iframe>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td valign="top" width="112" height="5px">
                    <img src="images/008000.gif"/>
                    <span class="text-blue-09">&nbsp;1st Preference</span>&nbsp;&nbsp;
                  </td>
                  <td valign="top" width="102" height="5px">
                    <img src="images/accepted.gif"/>
                    <span class="text-blue-09">&nbsp;Accepted</span></td>
                </tr>
                <tr>
                  <td valign="top" width="112">
                    <img src="images/99CC00.gif"/>
                    <span class="text-blue-09">&nbsp;2nd Preference</span>
                  </td>
                  <td valign="top" width="102">
                    <img src="images/invited.gif"/>
                    <span class="text-blue-09">&nbsp;Invited</span></td>
                </tr>
                <tr>
                  <td valign="top" width="112">
                    <img src="images/FF0000.gif"/>
                    <span class="text-blue-09">&nbsp;Unavailable</span>
                  </td>
                  <td valign="top" width="102">
                    <img src="images/rejected.gif"/>
                    <span class="text-blue-09">&nbsp;Attended</span></td>
                </tr>
                <tr>
                  <td valign="top" width="217" colspan="2">
                    <span class="text-blue-09">Please update your calendar. What days do you prefer? What days are you unavailable?</span>
                  </td>
                </tr>
            </table>
        </td>
            <%
              }
            %>
            
            
            <td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
            <td>
                <OBJECT ID="MediaPlayer"  height=300 CLASSID="CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95"
                        STANDBY="Loading Windows Media Player components..."
                        TYPE="application/x-oleobject"
                        CODEBASE="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=6,4,7,1112">

                        <PARAM name="autoStart" value="false">
                        <PARAM name="filename" value="images/a.mpg">

                        <EMBED TYPE="application/x-mplayer2"
                               SRC="images/a.mpg"
                               NAME="MediaPlayer"
                               WIDTH=320
                               HEIGHT=240>
                        </EMBED>
                </OBJECT>
            </td>
          </tr>
        </table>
      </div>
    </div>
    </td>
  </tr>
</table>
<%@ include file="footer.jsp"%>