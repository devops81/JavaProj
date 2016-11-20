<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="java.util.TreeMap"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Map"%>
<%
String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
boolean isSAXAJVUser = false;
if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
		isSAXAJVUser = true;
}

String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
boolean isOTSUKAJVUser = false;
if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
		isOTSUKAJVUser = true;
}
%>

<html>
<LINK href="css/openq.css" type=text/css rel=stylesheet>

<head>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript">
var oldLink = null;
function setActiveStyleSheet(link, title) {
  var i, a, main;
  for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
    if(a.getAttribute("rel").indexOf("style") != -1 && a.getAttribute("title")) {
      a.disabled = true;
      if(a.getAttribute("title") == title) a.disabled = false;
    }
  }
  if (oldLink) oldLink.style.fontWeight = 'normal';
  oldLink = link;
  link.style.fontWeight = 'bold';
  return false;
}

// This function gets called when the end-user clicks on some date.
function selected(cal, date) {
  cal.sel.value = date; // just update the date in the input field.
  if (cal.dateClicked && (cal.sel.id == "sel1" || cal.sel.id == "sel2"||cal.sel.id=="sel3"))
    // if we add this call we close the calendar on single-click.
    // just to exemplify both cases, we are using this only for the 1st
    // and the 3rd field, while 2nd and 4th will still require double-click.
    cal.callCloseHandler();
}

// And this gets called when the end-user clicks on the _selected_ date,
// or clicks on the "Close" button.  It just hides the calendar without
// destroying it.
function closeHandler(cal) {
  cal.hide();                        // hide the calendar
//  cal.destroy();
  _dynarch_popupCalendar = null;
}

// This function shows the calendar under the element having the given id.
// It takes care of catching "mousedown" signals on document and hiding the
// calendar if the click was outside.
function showCalendar(id, format, showsTime, showsOtherMonths) {

  var el = document.getElementById(id);
  if (_dynarch_popupCalendar != null) {
    // we already have some calendar created
    _dynarch_popupCalendar.hide();                 // so we hide it first.
  } else {
    // first-time call, create the calendar.
    var cal = new Calendar(1, null, selected, closeHandler);
    // uncomment the following line to hide the week numbers
    // cal.weekNumbers = false;
    if (typeof showsTime == "string") {
      cal.showsTime = true;
      cal.time24 = (showsTime == "24");
    }
    if (showsOtherMonths) {
      cal.showsOtherMonths = true;
    }
    _dynarch_popupCalendar = cal;                  // remember it in the global var
    cal.setRange(1900, 2070);        // min/max year allowed.
    cal.create();
  }
  _dynarch_popupCalendar.setDateFormat(format);    // set the specified date format
  _dynarch_popupCalendar.parseDate(el.value);      // try to parse the text in field
  _dynarch_popupCalendar.sel = el;                 // inform it what input field we use

  // the reference element that we pass to showAtElement is the button that
  // triggers the calendar.  In this example we align the calendar bottom-right
  // to the button.
  _dynarch_popupCalendar.showAtElement(el.nextSibling, "Br");        // show the calendar

  return false;
}

var MINUTE = 60 * 1000;
var HOUR = 60 * MINUTE;
var DAY = 24 * HOUR;
var WEEK = 7 * DAY;

// If this handler returns true then the "date" given as
// parameter will be disabled.  In this example we enable
// only days within a range of 10 days from the current
// date.
// You can use the functions date.getFullYear() -- returns the year
// as 4 digit number, date.getMonth() -- returns the month as 0..11,
// and date.getDate() -- returns the date of the month as 1..31, to
// make heavy calculations here.  However, beware that this function
// should be very fast, as it is called for each day in a month when
// the calendar is (re)constructed.
function isDisabled(date) {
  var today = new Date();
  return (Math.abs(date.getTime() - today.getTime()) / DAY) > 10;
}

function flatSelected(cal, date) {
  var el = document.getElementById("preview");
  el.innerHTML = date;
}

function showFlatCalendar() {
  var parent = document.getElementById("display");

  // construct a calendar giving only the "selected" handler.
  var cal = new Calendar(0, null, flatSelected);

  // hide week numbers
  cal.weekNumbers = false;

  // We want some dates to be disabled; see function isDisabled above
  cal.setDisabledHandler(isDisabled);
  cal.setDateFormat("%A, %B %e");

  // this call must be the last as it might use data initialized above; if
  // we specify a parent, as opposite to the "showCalendar" function above,
  // then we create a flat calendar -- not popup.  Hidden, though, but...
  cal.create(parent);

  // ... we can show it here.
  cal.show();
}
</script>


    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>

    <%@ include file="header.jsp" %>
    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
         }


        -->
    </style>
    <script type="text/javascript" src="./js/sorttable.js"></script>
    </head>
<script type="text/javascript">
    function deleteEvent(entityId) {
        var thisform = document.eventsearch;
        thisform.action = "<%=CONTEXTPATH%>/event_add.htm?action=<%=ActionKeys.DELETE_EVENT%>&eventid="+entityId;
        thisform.submit();
    }
    function show_calendar(sName) {
		gsDateFieldName = sName;
		// pass in field name dynamically

		var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
		if (document.layers) // NN4 param
			winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";

		var win = window.open("Popup/PickerWindow.html", "_new_picker", winParam);
        if(win != "")
          win.focus();
    }

    function searchEvents() {
        if(window.event.keyCode == 0 || window.event.keyCode == 13) {
            var thisform = document.eventsearch;
            var toFlag = false;
            var fromFlag = false;

            if(thisform.fromDate != null && thisform.fromDate.value != null &&
                    thisform.fromDate.value != "") {
                fromFlag = true;
            }
            if(thisform.toDate != null && thisform.toDate.value != null &&
                    thisform.toDate.value != "") {
                toFlag = true;
            }
            if((fromFlag && !toFlag) || (!fromFlag && toFlag)) {
                alert("Please enter both From Date and To Date");
                if(!toFlag) {
                    thisform.toDate.focus();
                } else if(!fromFlag) {
                    thisform.fromDate.focus();
                }
                return false;
            }
           thisform.action = "<%=CONTEXTPATH%>/event_search.htm?action=<%=ActionKeys.SEARCH_EVENT%>";
           openProgressBar();
            thisform.submit();

        }
    }
    function addEvent(){
        var thisform = document.eventsearch;
        thisform.action = "<%=CONTEXTPATH%>/event_add.htm";
        thisform.submit();
    }

    function addAttendee(empName, empPhone, empEmail,empId){
		document.eventsearch.eventOwner.value=empName;
		document.eventsearch.staffId.value = empId;
	}

    function alertMsgOtsuka(){
        alert("This feature has been disabled.");
    }
</script>
<%
    OptionLookup therapyLookup[] = null;
    if (session.getAttribute("EVENT_THERAPY") != null) {
        therapyLookup = (OptionLookup[]) session.getAttribute("EVENT_THERAPY");
    }
    OptionLookup taLookup[] = null;
    if (session.getAttribute("EVENT_THERAPAEUTIC_AREA") != null) {
        taLookup = (OptionLookup[]) session.getAttribute("EVENT_THERAPAEUTIC_AREA");
    }
    OptionLookup eventTypesLookup[] = null;
    if (session.getAttribute("EVENT_TYPES") != null) {
        eventTypesLookup = (OptionLookup[]) session.getAttribute("EVENT_TYPES");
    }
    EventEntity[] result = null;
    if(session.getAttribute("EVENT_SEARCH_RESULTS") != null) {
        result = (EventEntity[]) session.getAttribute("EVENT_SEARCH_RESULTS");
    }
    TreeMap searchMap = null;
    if(session.getAttribute("SEARCH_MAP") != null) {
        searchMap = (TreeMap) session.getAttribute("SEARCH_MAP");
    }
    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
		message = (String) session.getAttribute("MESSAGE");
	}
    boolean isAlreadySelected = false;
    UserDetails userDetails = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
    long currentUserTypeId = -1;
    long currentUserId = -1;
    if(userDetails != null){
        OptionLookup userTypeLookup = userDetails.getUserType();
        if(userTypeLookup != null){
            currentUserTypeId = userTypeLookup.getId();
        }
        currentUserId = Long.parseLong(userDetails.getId());
    }
    
%>
<body  onUnload="javascript:checkForProgressBar()">
<form name="eventsearch" method="post" onkeypress="searchEvents()" >
     <div class="producttext">
        <div class="myexpertlist">
          	<table width="100%">
				<tbody>
					<tr style="color: rgb(76, 115, 152);">
						<td width="2%"><img src="images/searchpic.jpg"></td>
						<td width="50%" align="left">
							<div class="myexperttext">Medical Meeting Search</div>
						</td>
					</tbody>
			</table>
		</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01">Medical Meeting Title:</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">From Date:</td>
    <td class="text-blue-01">&nbsp;</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">To Date:</td>
    <td class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01">&nbsp;</td>
</tr>
<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01"><input name="title" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=searchMap != null && searchMap.containsKey("title") ? searchMap.get("title"):""%>"/>
    </td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01"><input type="text" name="fromDate" readonly="true" class="field-blue-01-180x20" name="eventDate" id="sel1" value="<%=searchMap != null && searchMap.containsKey("toDate1") ? searchMap.get("toDate1"):""%>"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"> </td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="33" valign="top" class="text-blue-01"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></td>
    <td width="156" class="text-blue-01"><input type="text" readonly="true" class="field-blue-01-180x20" name="toDate" id="sel2" value="<%=searchMap != null && searchMap.containsKey("toDate2") ? searchMap.get("toDate2"):""%>"><a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"></td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01"><a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></td>
</tr>

<tr>
    <td height="10" colspan="6"></td>
</tr>

<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01">Type:</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01"><%=DBUtil.getInstance().customer%> Owner:</td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">&nbsp;</td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01">&nbsp;</td>
</tr>

<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01"><span class="text-blue-01">
                <select name="type" class="field-blue-01-180x20" onchange="">
                    <option value="-1">Any</option>
                    <%
                        if (eventTypesLookup != null && eventTypesLookup.length > 0) {
                            OptionLookup eventLookup = null;
                            isAlreadySelected = false;
                            for (int i = 0; i < eventTypesLookup.length; i++) {
                                eventLookup = eventTypesLookup[i];
                         		String selected = "" ;
                          		if(eventLookup.isDefaultSelected())
                          			selected = "selected";

                    %>
                    <option value="<%=eventLookup.getId()%>"
                            <%if(searchMap != null && searchMap.containsKey("type") &&
                                    Long.parseLong((String)searchMap.get("type")) == eventLookup.getId()){
                            	isAlreadySelected = true;
                            %> selected <% }
                            else if(!isAlreadySelected){%><%=selected%> <%} %>><%=eventLookup.getOptValue()%></option>
                    <%
                            }
                        }
                    %>
                </select>
              </span></td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01"><input name="eventOwner" type="text" class="field-blue-01-180x20" maxlength="50"
            value="<%=searchMap != null && searchMap.containsKey("owner") ? searchMap.get("owner"):""%>" readonly="true"/>
        <input name="staffId" type="hidden" />
    </td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <%if(!(isOTSUKAJVUser || isSAXAJVUser)) {%>
    <td width="186" class="text-blue-01" colspan="2" valign="top"><a  href="#" onclick="javascript:window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')" class="text-blue-01-link">Lookup&nbsp;Company&nbsp;Owner</a></td>
    <% } %>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01">&nbsp;</td>
    
</tr>

<tr>
    <td height="10" colspan="6"></td>
</tr>

<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01">Therapeutic Area:</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">Product:</td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">&nbsp;</td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01">&nbsp;</td>
</tr>

<tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="150" class="text-blue-01"><select name="ta" class="field-blue-01-180x20" onchange="">

    <option value="-1">Any</option>
        <%
            if (taLookup != null && taLookup.length > 0) {
                OptionLookup tasLookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < taLookup.length; i++) {
                    tasLookup = taLookup[i];
             		String selected = "" ;
              		if(tasLookup.isDefaultSelected())
              			selected = "selected";

        %>
        <option value="<%=tasLookup.getId()%>"
        	<%if(searchMap != null && searchMap.containsKey("ta") &&
            Long.parseLong((String)searchMap.get("ta")) == tasLookup.getId()){
       		isAlreadySelected = true;
        %> selected <% }
         else if(!isAlreadySelected){ %><%=selected%> <%} %>><%=tasLookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </select></td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01"><select name="therapy" class="field-blue-01-180x20" onchange="">
    	<%if(!isSAXAJVUser && !isOTSUKAJVUser){%>
    	<option value="-1">Any</option>
    	<%}%>
        <%
            if (therapyLookup != null && therapyLookup.length > 0) {
                OptionLookup therapysLookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < therapyLookup.length; i++) {
                    therapysLookup = therapyLookup[i];
             		String selected = "" ;
              		if(therapysLookup.isDefaultSelected())
              			selected = "selected";

        %>
        <option value="<%=therapysLookup.getId()%>"

        	<%if(isSAXAJVUser&&therapysLookup.getOptValue().equalsIgnoreCase("Diabetes")){%>
 		   selected
 		   <%}else if(isOTSUKAJVUser&&therapysLookup.getOptValue().equalsIgnoreCase("Abilify")){%>
 		   selected
 		   <%} %>
 		   

        	<%if(searchMap != null && searchMap.containsKey("therapy") &&
                 Long.parseLong((String)searchMap.get("therapy")) == therapysLookup.getId()){
        		isAlreadySelected = true;
                 %> selected <% }
           else if(!isAlreadySelected){%><%=selected%> <%} %>><%=therapysLookup.getOptValue()%>


           </option>
        <%
                }
            }
        %>
    </select></td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="33" class="text-blue-01">&nbsp;</td>
    <td width="156" class="text-blue-01">&nbsp;</td>
    <td width="4" class="text-blue-01">&nbsp;</td>
    <td width="47%" class="text-blue-01">&nbsp;</td>

</tr>

</table>
</div>
<div class="producttext">
</td>
</tr>
<tr>
    <td height="10" align="left" class="back-white"></td>
</tr>
<tr>
    <td height="10" align="left"></td>
</tr>
<tr>
    <td height="10" align="left" class="back-white"></td>
</tr>
<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td class="text-blue-01"><input name="Submit332" type="button" class="button-01" style="border:0;background:url(images/buttons/search_event.gif);width:168px; height:22px;" value="" onclick="searchEvents()"/>
                  &nbsp;  <input name="Submit332" type="button" style="border:0;background : url(images/buttons/calendar_view.gif);width:118px; height:22px;" class="button-01" value="" onClick="parent.location='event_schedule.htm?action=<%=ActionKeys.ALL_MEDICAL_MEETINGS %>'"></td>
            </tr>
        </table>
    </td>
</tr>
</div>
<%if(request.getAttribute("go")!=null && request.getParameter("go").equals("true")){ %>
   <div class="producttext">
        <div class="myexpertlist">
          	<table width="100%">
				<tbody>
					<tr style="color: rgb(76, 115, 152);">
						<td width="2%"><img src="images/searchpic.jpg"></td>
						<td width="50%" align="left">
							<div class="myexperttext">Medical Meetings for <%=request.getAttribute("kol_name") %></div>
						</td>
					</tbody>
				</table>
			</div>
			<iframe frameborder="0" src="event_search.htm?action=<%=ActionKeys.SHOW_EVENTS_BY_EXPERT%>&kolId=<%=request.getAttribute("kol_id")%>" width="100%" name="eventsByExpert"></iframe>
	</div>

<%}else{ %>
<div class="producttext">
        <div class="myexpertlist">
          	<table width="100%">
				<tbody>
					<tr style="color: rgb(76, 115, 152);">
						<td width="2%"><img src="images/searchpic.jpg"></td>
						<td width="50%" align="left">
							<div class="myexperttext">Medical Meeting Search Result</div>
						</td>
					</tbody>
				</table>
			</div>

    <table width="98%" border="0" cellspacing="0" cellpadding="0" color="#faf9f2" class="sortable">
        <tr bgcolor="#faf9f2">
            <td width="15" height="20">&nbsp;</td>
            <td width="25" ></td>
            <td width="36">&nbsp;</td>
            <td width="34">&nbsp;</td>
            <td width="17">&nbsp;</td>
            <td width="200" class="expertListHeader" width="200" align="left">Medical Meeting Title</td>
            <td width="200" class="expertListHeader" width="200" align="left">Type</td>
            <td width="200" class="expertListHeader" width="200" align="left">Therapeutic Area</td>
            <td width="121" class="expertListHeader" width="200" align="left">Product</td>
            <td width="99" class="expertListHeader" width="200">Date</td>
            <td width="200" class="expertListHeader" width="200" align="left">City</td>
            <td width="200" class="expertListHeader" align="100" align="left">State/Prov.</td>
            <td width="200" class="expertListHeader" align="100" align="left">Country</td>
        </tr>
 <% if (!"".equals(message)) { %>
        <tr class="back-white">
            <td width="15" height="20">&nbsp;</td>
            <td width="1365" class="text-blue-01" colspan="11">&nbsp;<font face ="verdana" size ="2" color="red">
                         <b><%=message%></b>
                         </font></td>
        </tr>
   <% } %>
            <%
                    if (null != result && result.length > 0) {
                        EventEntity entity = null;
                        for (int i = 0; i < result.length; i++) {
                            entity = result[i];
                            long id = entity.getId();
            %>
        <tr class='<%=(i%2==0)?"back-white-02-light":"back-grey-02-light"%>'>
            <td width="15" height="20">&nbsp;</td>
            <td width="25" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"/></td>
            <td align="center" valign="bottom">
            <a href="<%=CONTEXTPATH%>/event_search.htm?action=<%=ActionKeys.VIEW_EVENT%>&eventid=<%=entity.getId()%>" class="text-blue-01-link">View</a></td>
        <%
                        if(currentUserTypeId == Constants.FRONT_END_ADMIN_USER_TYPE || currentUserId == entity.getUserid()){
         %>
            <td align="center" valign="bottom">
            <a href="<%=CONTEXTPATH%>/event_add.htm?action=<%=ActionKeys.EDIT_EVENT%>&eventid=<%=entity.getId()%>" class="text-blue-01-link">Edit</a></td>
        <%
                        }else{
		%>
            <td width="17" align="left">&nbsp;&nbsp;</td>
		<% } %>
            <td width="60" align="center" valign="bottom"><%if(currentUserTypeId == Constants.FRONT_END_ADMIN_USER_TYPE || currentUserId == entity.getUserid()) {%><a href="javascript:deleteEvent('<%=entity.getId()%>')" class="text-blue-01-link">&nbsp;Delete</a><%} else {%> <%}%></td>
            <td width="200" class="text-blue-01" width="200" align="left" ><%=entity.getTitle() != null?entity.getTitle():""%></td>
            <td width="200" class="text-blue-01" width="200" align="left" ><%=entity.getEvent_type() != null?entity.getEvent_type().getOptValue():""%></td>
            <td width="200" class="text-blue-01" width="200" align="left" ><%=entity.getTa() != null?entity.getTa().getOptValue():""%></td>
            <td width="121" class="text-blue-01" width="200" align="left" ><%=entity.getTherapy() != null?entity.getTherapy().getOptValue():""%></td>
            <td width="99" class="text-blue-01" width="200" ><%
                    Date eveDate =	entity.getEventdate();
                    int y = eveDate.getYear()+1900;
                    int m = eveDate.getMonth()+1;
                    String eveDateStr = m+"/"+eveDate.getDate()+"/"+y;
                    out.print(eveDateStr);
				%></td>
            <td width="200" class="text-blue-01" width="200" align="left" ><%=entity.getCity() != null?entity.getCity():""%></td>
            <td width="200" class="text-blue-01" align="100" align="left" ><%=entity.getState() != null?entity.getState().getOptValue():""%></td>
            <td width="200" class="text-blue-01" align="100" align="left" ><%=entity.getCountry() != null?entity.getCountry().getOptValue():""%>
                <input type="hidden" name="eventIds" value="<%=entity.getId()%>"/>
            </td>
                </tr>
            <%
                        }
                    }
            %>
    </table>

    </tr>

     <tr>
        <td height="10" align="left" class="back-blue-02-light"></td>
    </tr>
    <tr>
        <td height="10" align="left"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"/></td>
    </tr>
<%--<tr>
    <td height="10" align="left" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                         height="10"/></td>
</tr>--%>
    <tr>
        <td height="10" align="left" valign="top" class="back-white">
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr class="back-white" height="30">
                    <td width="10" height="20">&nbsp;</td>
                    <td class="text-blue-01"> <input <%=((isOTSUKAJVUser) ?"disabled":"")%> type="button" name="Submit33" value=""
      	    	style="border:0;background : url(images/buttons/<%=((isOTSUKAJVUser)?"add_event_disabled.gif":"add_event.gif")%>);width:150px; height:22px;"  class="button-01"
            	onclick="addEvent()" target="self"> </td>
                                                    
                </tr>

            </table>
        </td>
    </tr>
    <tr>
        <td height="10" align="left" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                             height="10"/></td>
    </tr>
    <tr>
        <td height="10" align="left"></td>
    </tr>
    </table>
    </div>
    <%} %>
    </td>
    </tr>
    </table>
    </form>
    <p>&nbsp;
    <p>&nbsp;
    <p>&nbsp;
    <%@ include file="footer.jsp" %><%
        session.removeAttribute("EVENT_SEARCH_RESULTS");
        session.removeAttribute("SEARCH_MAP");
        session.removeAttribute("EVENT_DETAILS");
        session.removeAttribute("MESSAGE");
        session.removeAttribute("refreshed_event_add");//we are removing it here coz when we chose to edit a event,if it was set to true then
        											   //invited_user variable will be removed according to the logic in event_add and hence it wont display any attendee even thouh there are.

%></html>
