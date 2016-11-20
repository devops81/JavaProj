<%@ page language="java" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.utils.TimeTracker"%>
<%@ page import="java.util.*"%>
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

	ArrayList OLData = null;
    if (null != session.getAttribute("OLNAME_WITH_ID")) {
        OLData = (ArrayList) session.getAttribute("OLNAME_WITH_ID");
    }
    OptionLookup eventTypesLookup[] = null;
    boolean isAlreadySelected = false;
 %>

<script type="text/javascript">
	dojo.require("dijit.layout.ContentPane");

	var loadingMessageHtml = "<div class=\"text-blue-01\" style=\"padding: 3px 0px; text-align: center; vertical-align: middle;\"><img src=\"images/loading_blue.gif\"/> \&nbsp;Loading...</div>";
	var calendarURL = "available_calendar.htm";

  function getLoadingMsg(){
    return loadingMessageHtml;
  }

	function initPage(){
	  //var calendarPane = dijit.byId("calendarPane");
		//uploadCalendar("calendarPane");
	}

	var attendeelist ;
	function createAttendeeList(){
	    attendeelist="";
	    var thisform=document.events;
	    for(var i=0;i<thisform.invitedOl.length;i++){
	       attendeelist+=thisform.invitedOl.options[i].value+ ",";
	    }
	}

	function uploadCalendar(p_calendarPaneName){
	  createAttendeeList();
	  var calendarPane = dojo.byId(p_calendarPaneName);
		if(calendarPane!=undefined)
		{
		calendarPane.innerHTML = loadingMessageHtml;
		calendarPane = dijit.byId(p_calendarPaneName);
		var calendarURL = "available_calendar.htm?invitedOl="+attendeelist;
		calendarPane.setHref(calendarURL);
		}
	}
	dojo.addOnLoad(initPage);
</script>



<html>

<head>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script language="javascript" src="js/populateChildLOV.js"></script>
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

var available=true;
//This function is called when user clicks on a available date to create an event.
function pickDate(year,month,date){
  var thisForm=document.events;
  var date=(month<10?'0'+month:month)+'/'+(date<10?'0'+date:date)+'/'+year;
  if(available==true)
    thisForm.eventDate.value=date;
  available=true;
}

function availCheck(){
  alert("One or more <%=DBUtil.getInstance().doctor%>(s) are unavailable on this date.Choose another date for creating event");
  available=false;

}

// This function gets called when the end-user clicks on some date.
function selected(cal, date) {
  cal.sel.value = date; // just update the date in the input field.
  if (cal.dateClicked && (cal.sel.id == "sel1" || cal.sel.id == "sel2"||cal.sel.id=="sel3"||cal.sel.id=="endDate"))
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

<%
    if (request.getSession().getAttribute(Constants.CURRENT_USER) == null) {
        response.sendRedirect("login.htm");
    }
    String startHrs[] = TimeTracker.TimeArray;


    String endHrs[] = TimeTracker.TimeArray;


    OptionLookup taLookup[] = null;
    if (session.getAttribute("EVENT_THERAPAEUTIC_AREA") != null) {
        taLookup = (OptionLookup[]) session.getAttribute("EVENT_THERAPAEUTIC_AREA");
    }

    if (session.getAttribute("EVENT_TYPES") != null) {
        eventTypesLookup = (OptionLookup[]) session.getAttribute("EVENT_TYPES");
    }

     OptionLookup eventStatusLookup[] = null;
     if (session.getAttribute("EVENT_STATUS") != null) {
        eventStatusLookup = (OptionLookup[]) session.getAttribute("EVENT_STATUS");
    }



    OptionLookup stateLookup[] = null;
    if (session.getAttribute("EVENT_STATE") != null) {
        stateLookup = (OptionLookup[]) session.getAttribute("EVENT_STATE");
    }
    
    OptionLookup countryLookup[] = null;
    if (session.getAttribute("EVENT_STATE") != null) {
        countryLookup = (OptionLookup[]) session.getAttribute("EVENT_COUNTRY");
    }
    
    EventEntity eventEntity = null;
    if(session.getAttribute("EVENT_DETAILS") != null) {
        eventEntity = (EventEntity) session.getAttribute("EVENT_DETAILS");

    }
    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
        message = (String) session.getAttribute("MESSAGE");
    }

%>


<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<SCRIPT src = "<%=COMMONJS%>/listbox.js" language = "Javascript"></SCRIPT>
<SCRIPT src = "<%=COMMONJS%>/validation.js" language = "Javascript"></SCRIPT>
<script language="javascript">
function help() {
    alert("For demonstration purpose only. All links are just placeholders.");
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
	/*CHANGED*/
function time_alert()
{

}

function searchEvents() {
    var thisform = document.events;
    thisform.action = "<%=CONTEXTPATH%>/event_search.htm";
    thisform.submit();
}

function saveEvent() {
    var thisform = document.events;

    var therapyLookup = document.getElementById("eventTherapy");
    var selectedIndex = therapyLookup.selectedIndex;
    thisform.eventTherapyId.value = therapyLookup.options[selectedIndex].id;
    
    if (!isEmpty(thisform.eventTitle, "Medical Meeting Title")){ thisform.eventTitle.focus(); return false;}
    if(thisform.eventDate.value == "") {
        alert("Please enter the Medical Meeting Date");
        thisform.eventDate.focus();
        return false;
    }
    if (!isEmpty(thisform.eventOwner, "<%=DBUtil.getInstance().customer%> Owner")){ thisform.eventOwner.focus(); return false;}

    if (!isEmpty(thisform.eventCountry, "Medical Meeting Country")) {
        return false;
    }
    
    if(thisform.eventDescription != null && thisform.eventDescription.value != null &&
       thisform.eventDescription.value.length > 1000) {
        alert("Description can not be more than 1000 characters");
        thisform.eventDescription.focus();
        return false;
    }
    var attendeeListLen = thisform.invitedOl.length;
    if(attendeeListLen > 0) {
        for(var j=0;j < attendeeListLen; j++) {
            thisform.invitedOl.options[j].selected = true;
        }
    }
    if(attendees != null && attendees.length > 0) {
        if(attendees.length > 4000) {
            var maxAttendee = null;
            var attendee = attendees.split(",");
            if(attendee != null && attendee.length>0) {
                for(var a=0;a<attendee.length;a++) {
                    if(a == 0) {
                        maxAttendee = attendee[a];
                    } else {
                        maxAttendee +=", "+attendee[a];
                    }
                    if(maxAttendee != null && maxAttendee.length >= 4000) {
                        alert("Can not add more than "+a+" Attendees");
                        return false;
                    }
                }
            }
        }
    }
    thisform.action = "<%=CONTEXTPATH%>/event_add.htm?action=<%=ActionKeys.SAVE_EVENT%>";
    thisform.submit1.disabled =true;
    thisform.submit();
}
var attendees = null;
var approvers=null;
function addOLs(childValue) {

    var thisform = document.events;
    for (var i = 0; i < childValue.length; i++)
    {
        var attendeeListLen = thisform.invitedOl.length;
        var flag = false;
        if(attendeeListLen > 0) {
            for(var j=0;j < attendeeListLen; j++) {
                if(thisform.invitedOl.options[j].value == childValue[i].split(";")[0]) {
                    flag = true;
                    break;
                }
            }
            if(!flag) {
                thisform.invitedOl.options[attendeeListLen] = new Option(childValue[i].split(";")[1],childValue[i].split(";")[0]);
                thisform.invitedOl.options[attendeeListLen].selected = true;
                attendees +=", "+childValue[i].split(";")[0];
            }
        } else {
            thisform.invitedOl.options[attendeeListLen] = new Option(childValue[i].split(";")[1],childValue[i].split(";")[0]);
            thisform.invitedOl.options[attendeeListLen].selected = true;
            attendees = childValue[i].split(";")[0];
        }
    }
}
function deleteOls() {
    var thisform = document.events;
    deleted(thisform.invitedOl);

    var arr = thisform.invitedOl.options;
    if(arr != null && arr.length > 0) {
        for(var i=0;i<arr.length;i++) {
            arr[i].selected = true;
        }
    }
    //uploadCalendar("calendarPane");
}
function deleteApprovers() {
   /* var thisform = document.events;

    deleted(thisform.approvers);

    var arr1 = thisform.approvers.options;
    if(arr1 != null && arr1.length > 0) {
        for(var i=0;i<arr1.length;i++) {
            arr1[i].selected = true;
        }
    }*/
}
function addMaterial(versionNumber,materialFile){
    document.events.versionNumber.value=versionNumber;
    document.events.materialFile.value=materialFile;
}
function addAttendee(empName, empPhone, empEmail,empId){
    document.events.eventOwner.value=empName;
    document.events.staffId.value = empId;
}
function addAttendeeNew(userName,id) {
			len = document.getElementById("invitedOl").options.length;
	   	    for(var i=0;i<len;i++){
	   	      if(document.getElementById("invitedOl").options[i].value==id){
	   	      		alert("This user is already in the list");
	   	      		return false;
	   	      }
	   	    }
            document.getElementById("invitedOl").options[len++] = new Option(userName+"(Employee)", id);

	   	    var arr = document.getElementById("invitedOl").options;
    		if(arr != null && arr.length > 0) {
        		for(var i=0;i<arr.length;i++) {
           		 arr[i].selected = true;
        		}
        	}
       //uploadCalendar("calendarPane");
}


function addAttendeeFromAdvSearch(a){

	for(var i=0;i<a.length;i++)
	{


		var userInfo = a[i].split(";");
		var id = userInfo[0];
		var userName = userInfo[1]+","+userInfo[2] + "(" + '<%=DBUtil.getInstance().doctor%>' + ")";
		var flag = true;
		len = document.getElementById("invitedOl").options.length;
	   	    for(var j=0;j<len;j++){
	   	      if(document.getElementById("invitedOl").options[j].value == id){
	   	      		alert(userInfo[1]+","+userInfo[2]+"is already in the list");
	   	      		flag = false
	   	      }
	   	    }
		if(flag == true){
		document.getElementById("invitedOl").options[len++] = new Option(userName,id);
	   	}
	   	    var arr = document.getElementById("invitedOl").options;
    		if(arr != null && arr.length > 0) {
        		for(var k=0;k<arr.length;k++) {
           		 arr[k].selected = true;
        		}
        	}

	}

}




function addApprovers(empName, empPhone, empEmail,empId){
    //	document.events.invitedO2[document.events.invitedO2.length]=empName;
    //	alert(empName);
    //document.events.approvers.options[document.events.approvers.length]=new Option(empName);
}



    var checkURL = true;

    function toggleAll()
    {
        var image = dojo.byId("allImg");
        if( checkURL){
                closeAllSections("colContent");
                image.src="images/buttons/plus.gif";
            checkURL = false;
        } else {
             openAllSections("colContent");
             image.src="images/buttons/minus.gif";
            checkURL = true;
        }
   }
   function submitAdvExpertSearch()
	{
		createAttendeeList();
	    var thisform = document.events;

		thisform.action = "<%=CONTEXTPATH%>/search.htm?default=true&fromEvent=true";
		//thisform.action = "<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&fromEvents=true&usersFromEvents="+attendeelist;
		//thisform.target="_top";
		thisform.submit();


		//window.open('search.htm?default=true&frompage=from_event_add', 'Attendee_Search','top=200,left=200,width=600,height=400,scrollbars=1,resizable=1');

	}
	function callback() {
    //If the readystate is 4 then check for the request status.
            // update the HTML DOM based on whether or not message is valid
            //populateOLList(req.responseText);

            if (document.getElementById("invitedOl").options.length > 0) {
                len = document.getElementById("invitedOl").options.length;
            }

        <% String ols = "";
           String[] tempArr = null;
           if(OLData != null && OLData.size()>0) {
           String val = null;
              for (int i = 0; i < OLData.size(); i++) {
                  val = (String)OLData.get(i);
                  tempArr = val.split("/");
        %>
            document.getElementById("invitedOl").options[len++] = new Option('<%=tempArr[1]%>', '<%=tempArr[0]%>');

        <%

               }

            }
        %>
}
function populateOLList(val) {
    var start = val;
    var stdate = new Array();
    stdate = start.split(';');
    document.getElementById("invitedOl").options.length = 0;
    //document.getElementById ("invitedOl").options.length;
    for (i = 0; i < stdate.length - 1; i++) {
        var objArray = new Array();
        objArray = stdate[i].split('/');
        document.getElementById("invitedOl").options[i] = new Option(objArray[1], objArray[0]);
    }
}

</script>

<script type="text/javascript" src="js/subsection.js">
</script>

<style>
    <!--

    body{font-family:arial,sans-serif}.fs{border-left:9px solid}.sd .fs{border-left-color:#c3d9ff}.msg{}
    td{font-family:arial,sans-serif}.cbln{background-image:url('card_left_new.gif');background-position: left 50%;background-repeat:repeat-y}.cbln{padding:0 1 0 0}.mb{font-size:80%;padding:6 8 10 14;width:100%}-->
</style>
</head>


<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
<!--
  Following is a dummy form which is used by the calendar widget to set the selected date.
  Note the name of the form and the the input field are fixed. If they are changed the
  calendar widget would start showing javascript errors.
-->
<form name="demoForm">
  <input type="hidden" name="dateField"/>
</form>
<form name="events" method="post">
<input type="hidden" name="eventTherapyId" value=""/>
<% if (!"".equals(message)) { %>
<table>
<tr align="left" class="back-blue-02-light">
    <td>&nbsp;
        <font face ="verdana" size ="2" color="red">
            <b><%=message%></b>
        </font>
    <td>
</tr>
</table>
<% } %>

<div class="producttext">
    <input type="hidden" name="hiddeneventid" value="<%=eventEntity != null?eventEntity.getId():0%>" />
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height="30%"/>
        <tr height="80%">
            <td width="10" height="20">&nbsp;</td>
            <td width="10" class="boldp"><input name="submit1" type="button" style="border:0;background : url(images/buttons/save_event.gif);width:152px; height:22px;" class="button-01"
                                                value="" onClick="saveEvent()"></td>
            <td width="20">&nbsp;</td>
            <td width="20" class="boldp"><input name="Submit332" type="button" style="border:0;background : url(images/buttons/search_event.gif);width:168px; height:22px;" class="button-01"
                                                value="" onClick="searchEvents()"></td>
            <td width="20">&nbsp;</td>
            <td class="boldp"><input name="Submit332" type="button" style="border:0;background : url(images/buttons/calendar_view.gif);width:118px; height:22px;" class="button-01"
                                     value="" onClick="parent.location='event_schedule.htm?action=<%=ActionKeys.ALL_MEDICAL_MEETINGS %>'"></td>
             <td><div style="PADDING-RIGHT: 10px; FLOAT: right; font-size:10px">
                    <img id="allImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleAll()"/> Expand/Collapse &nbsp;&nbsp;
             </div></td>

        </tr>
        <tr height="10%"/>
    </table>
	<p>&nbsp;</div>

<!--  Section 1 -->
<table width="100%">
<td>
<div class="reset colOuter">
<div class="colTitle" class=>
    <img id="eventTypeImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('eventType')"/><%if(eventEntity != null) {%>Edit<%} else {%><%}%>  Medical Meeting Details
</div>
<div id="eventTypeContent" class="colContent">

<table border="0" cellspacing="0" cellpadding="0">
<tr>
    <td width="1%" height="20">&nbsp;</td>
    <td  class="text-blue-01" width="17%">Title:*</td>
    <td width="1%">&nbsp;</td>
    <td width="17%" class="text-blue-01">Status:</td>
    <td width="1%">&nbsp;</td>
    <td width="16%" class="text-blue-01">Type:</td>
    <td width="1%">&nbsp;</td>
    <td  class="text-blue-01" width="15%"><%=DBUtil.getInstance().customer%> Owner:*</td>
    <td width="12%" class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01" width="19%">&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01" valign="top" width="17%"><input name="eventTitle" type="text" class="field-blue-01-180x20" maxlength="50"
                                                 value="<%=eventEntity != null && eventEntity.getTitle() != null?eventEntity.getTitle():""%>">    </td>
    <td width="1%">&nbsp;</td>

   <td class="text-blue-01" valign="top">
	<select name="status" class="field-blue-01-180x20">
		<%
				if (eventStatusLookup != null && eventStatusLookup.length > 0) {
				OptionLookup eventLookup = null;
				isAlreadySelected = false;
				for (int i = 0; i < eventStatusLookup.length; i++) {
					eventLookup = eventStatusLookup[i];
             		String selected = "" ;
              		if(eventLookup.isDefaultSelected())
              			selected = "selected";
		%>
		<option value="<%=eventLookup.getOptValue()%>"
			<%if(eventEntity != null && eventEntity.getStatus() != null
					&& eventEntity.getStatus().equals(eventLookup.getOptValue())) {
						isAlreadySelected = true;
					%>selected <%}
			else if(!isAlreadySelected) {%><%=selected%> <%} %>>
			<%=eventLookup.getOptValue()%>
		</option>
		<%
			}
			}
		%>
	</select>
									</td>
    <td class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01" valign="top">
        <select name="eventType" class="field-blue-01-180x20">
            <%
                if (eventTypesLookup != null && eventTypesLookup.length > 0)
                {
                    OptionLookup eventLookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < eventTypesLookup.length; i++){
                        eventLookup = eventTypesLookup[i];
                 		String selected = "" ;
                  		if(eventLookup.isDefaultSelected())
                  			selected = "selected";

            %>
            <option value="<%=eventLookup.getId()%>"
            <%if(eventEntity != null && eventEntity.getEvent_type() != null &&
                    eventEntity.getEvent_type().getId() == eventLookup.getId()) {
            		isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected){%><%=selected%> <%} %>><%=eventLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>
    </td>
    <td class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01" valign="top" width="15%"><input name="eventOwner" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=eventEntity != null && eventEntity.getOwner() != null?eventEntity.getOwner():""%>" readonly="true">
        <input name="staffId" type="hidden" value="<%=eventEntity != null && eventEntity.getStaffids() != null?eventEntity.getStaffids():"" %>"/>    </td>
    
    <% if(!(isOTSUKAJVUser || isSAXAJVUser)) { %>
    <td valign="top"><A href="#" onClick="javascript:window.open('employee_search.htm?fromEvents=false','searchLDAP','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');" class="text-blue-01-link"  >Lookup Employee</A></td>
	<%} %>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01" valign="bottom" width="17%">City:</td>
    <td>&nbsp;</td>
    <td valign="bottom" class="text-blue-01">State/Prov.:</td>
    <td class="text-blue-01">&nbsp;</td>
    <td valign="bottom" class="text-blue-01">Country:*</td>
    <td class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01" valign="bottom">Therapeutic Area:*</td>
    <td class="text-blue-01">&nbsp;</td>
    
    <td>&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01" valign="top" width="17%"><input name="eventCity" type="text" class="field-blue-01-180x20" maxlength="50"
                                                 value="<%=eventEntity != null && eventEntity.getCity() != null?eventEntity.getCity():""%>"></td>
    <td>&nbsp;</td>
    <td valign="top" class="text-blue-01">
        <select name="eventState" class="field-blue-01-180x20">
            <%
                if (stateLookup != null && stateLookup.length > 0) {
                    OptionLookup statesLookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < stateLookup.length; i++) {
                        statesLookup = stateLookup[i];
                 		String selected = "" ;
                  		if(statesLookup.isDefaultSelected())
                  			selected = "selected";

            %>
            <option value="<%=statesLookup.getId()%>"
            <%if(eventEntity != null && eventEntity.getEvent_type() != null &&
                    eventEntity.getState().getId() == statesLookup.getId()) {
            		isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected){%><%=selected%> <%} %>><%=statesLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select></td>
    <td class="text-blue-01">&nbsp;</td>
    <td valign="top" class="text-blue-01">
        <select name="eventCountry" class="field-blue-01-180x20">
        	<option value=""></option>
            <%
                if (countryLookup != null && countryLookup.length > 0) {
                    OptionLookup countrysLookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < countryLookup.length; i++) {
                        countrysLookup=countryLookup[i];
                 		String selected = "" ;
                  		if(countrysLookup.isDefaultSelected())
                  			selected = "selected";

            %>
            <option value="<%=countrysLookup.getId()%>"
            <%if(eventEntity != null && eventEntity.getEvent_type() != null &&
                    null!=eventEntity.getCountry()&&  eventEntity.getCountry().getId() == countrysLookup.getId()) {
            		isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected){%>  <%} %>><%=countrysLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select></td>
        <td class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01" valign="top">
        <% String eventTherapyLOVName = PropertyReader.getLOVConstantValueFor("THERAPY"); 
           long selectedTAId = -1;
        %>
        <select id="eventTa" name="eventTa" class="field-blue-01-180x20" onChange='populateChildLOV(this, "eventTherapy", true, "<%=eventTherapyLOVName%>")'>
        <%
            if (taLookup != null && taLookup.length > 0) {
                OptionLookup tasLookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < taLookup.length; i++) {
                    tasLookup = taLookup[i];
                    if(i == 0){
                        selectedTAId = tasLookup.getId();
                    }
             		String selected = "" ;
              		if(tasLookup.isDefaultSelected()){
              			selected = "selected";
              			selectedTAId = tasLookup.getId();
              		}
        %>
        <option id="<%=tasLookup.getId()%>" value="<%=tasLookup.getId()%>"
        <%if(eventEntity != null && eventEntity.getEvent_type() != null &&
                eventEntity.getTa().getId() == tasLookup.getId()) {
        		isAlreadySelected = true;
        		selectedTAId = tasLookup.getId();
                %> selected <%}
                else if(!isAlreadySelected){%><%=selected%> <%} %>><%=tasLookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </select></td>
</tr>
<tr>

<td height="20">&nbsp;</td>
	<td class="text-blue-01" valign="bottom" width="15%" >Product:</td>
	<td>&nbsp;</td>
    <td class="text-blue-01" valign="bottom" width="17%">Description:</td>
    <td>&nbsp;</td>
    
</tr>
<tr>
<td>&nbsp;</td>
<td class="text-blue-01" valign="top" width="15%">
        <select id="eventTherapy" name="eventTherapy" class="field-blue-01-180x20" >
           <option id="" value=""></option>
        </select>
        <%
          long eventTherapyId = -1;
          if( eventEntity != null && eventEntity.getTherapy() != null ){
              eventTherapyId = eventEntity.getTherapy().getId();
          }
        %>
        <script>populateChildLOVById("<%=selectedTAId%>", "eventTherapy", true, "<%=eventTherapyLOVName%>", "<%=eventTherapyId%>");</script>
    </td>

<td>&nbsp;</td>   

<td class="text-blue-01" colspan="3" valign="top">
        <div style="float:left"><textarea name="eventDescription" class="field-blue-02-220x50"  rows="7" cols="32"><%if(eventEntity != null && eventEntity.getDescription() != null){%><%=eventEntity.getDescription()%><%}%></textarea>
    </div>
        <div style="float:left; margin:17px 0 0 3px;"><a href="#" class="text-blue-01-link" onClick="javascript:window.open('exp_present_mat.jsp','materials','width=800,height=500,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');">
        Support Materials</a></div>

    </td>
 </tr>
<tr>
    <td height="10" colspan="10"></td>
</tr>
</table>
</div>
</div>
</td>
</table>


<table width="100%">
    <td>
        <div class="reset colOuter">
            <div class="colTitle" class=>
                <img id="eventDateImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('eventDate')"/>  Medical Meeting Attendees and Dates
            </div>
            <div id="eventDateContent" class="colContent">
            	<table border="0" cellspacing="0" cellpadding="0" height="223">
                    <tr>
                        <td width="3%" height="20">&nbsp;</td>
                        <td width="16%" align="left" valign="top" class="text-blue-01">Attendees:</td>
                        <td width="3%" height="20">&nbsp;</td>
                        <td width="20%">&nbsp;</td>
                        <td width="58%" height="20">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="176" width="3%">&nbsp;</td>
                        <td class="text-blue-01" valign="top" width="16%">
                            <select name="invitedOl" multiple class="field-blue-20-260x150" width="30" size="12">
                            </select>
                        </td>
                        <td width="3%">&nbsp;</td>
                        <td align="left" valign="bottom" width="20%">
                        	<table width="100%">
                        	<tr>
                        		<td class="text-blue-01">Lookup Attendees:</td>
                        	</tr>
                        	<tr>
                        		<td>
                        			<a href="#" class="text-blue-01-link" onClick="javascript:window.open('search.htm?fromEvent=true&default=true','ExpertsSearch','width=700,height=630,top=50,left=200,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')"><%=DBUtil.getInstance().doctor%>s</a>
                        		</td>
                        	</tr>
                        	<tr>
                        		<td height="20">
                        			<a href="#" class="text-blue-01-link" onClick="javascript:window.open('employee_search.htm?fromEvents=yes','employeesearch','width=690,height=400,top=100,left=100,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')">Employee</a>
                        		</td>
                        	</tr>
                        	<tr><td height="20"> </td></tr>
                        	</table>
                        </td>

                        <td height="176" width="58%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="27">&nbsp;</td>

                        <td class="text-blue-01" width="17%"> <input type="button" onClick="javascript:deleteOls();" style="background: transparent url(images/buttons/remove_attendee.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 150px; height: 22px;" value="" name="deleteOL"/>                </td>
                        <td height="27">&nbsp;</td>
                        <td height="27">&nbsp;</td>

                        <td class="text-blue-01">
						</td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0" height="85">
                    <tr>
                        <td height="15">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="20" width="3%">&nbsp;&nbsp;</td>
                        <td class="text-blue-01" width="30%">Medical Meeting Begin Date:*</td>
                        <td class="text-blue-01" width="5%">&nbsp;</td>
                        <td class="text-blue-01" width="30%">Medical Meeting End Date:</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                    <td height="20" width="3%">&nbsp;&nbsp;</td>
                    <%
				       String createDate = null;
				       SimpleDateFormat sdf1 = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
				       if(eventEntity != null && eventEntity.getEventdate() != null) {
				           createDate = sdf1.format(eventEntity.getEventdate());
				       }
				       if(request.getParameter("eventdate")!=null){
				           createDate=request.getParameter("eventdate");
				           createDate=createDate.replace('-','/');
				       }
				     %>
				     <td class="text-blue-01" align="left" valign=top width="30%">
				     <input type="text" readonly="true"  class="field-blue-01-180x20" name="eventDate" id="eventDate"
							value="<%=createDate != null?createDate:""%>" size="20" ><a href="#" onclick="return showCalendar('eventDate', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ><br />

				<br /><br />

				                            </a>
				     </td>
				     <td class="text-blue-01" width="5%">&nbsp;</td>
				     <%
						 String endDate = null;
					     SimpleDateFormat sdf12 = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
				         if(eventEntity != null && eventEntity.getEndDate() != null) {
					           endDate = sdf12.format(eventEntity.getEndDate());
					     }
				    %>
				    <td class="text-blue-01" width="30%" valign=top>
				    <input type="text" readonly="true" size="8" class="field-blue-01-180x20" name="endDate"  id="endDate" value="<%=endDate != null?endDate:""%>"><a href="#" onclick="return showCalendar('endDate', '%m/%d/%Y', '24', true);">
					<img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a>
				    </td>
                    <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
	                    <td height="20" width="3%">&nbsp;&nbsp;</td>
	                    <td class="text-blue-01" width="30%">Start Time:</td>
	                    <td class="text-blue-01" width="5%">&nbsp;</td>
	                    <td class="text-blue-01" width="30%">End Time:</td>
	                    <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td height="20" width="3%">&nbsp;&nbsp;</td>
                    	<td class="text-blue-01" width="30%" valign=top>
                    		<select name="startHrs" class="field-blue-01-180x20" >

					        <%
					            if (startHrs != null && startHrs.length > 0) {
					                String temp = null;
					                for (int i = 0; i < startHrs.length; i++) {
					                    temp = startHrs[i];
					        %>
					        <option value="<%=temp%>" <%if(eventEntity != null && eventEntity.getStartTime() != null &&
					                eventEntity.getStartTime().equals(temp)) {%> selected <%}%>><%=temp%></option>
					        <%
					                }
					            }
					        %>
					       </select>
					   </td>
					   <td class="text-blue-01" width="5%">&nbsp;</td>
					   <td class="text-blue-01" width="30%" valign=top>
		                    <select name="endHrs" class="field-blue-01-180x20">
					        <%
					            if (endHrs != null && endHrs.length > 0) {
					                String temp = null;
					                for (int i = 0; i < endHrs.length; i++) {
					                    temp = endHrs[i];
					        %>
					        <option value="<%=temp%>" <%if(eventEntity != null && eventEntity.getEndTime() != null &&
					                eventEntity.getEndTime().equals(temp)) {%> selected <%}%>><%=temp%></option>
					        <%
					                }
					            }
					        %>
					        </select>
					   </td>
					   <td class="text-blue-01">&nbsp;</td>
					</tr>
                </table>
            	</div>
        </div>
    </td>
</table>



			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				        <tr height="30%"/>
				        <tr height="80%">
				            <td width="10" height="20">&nbsp;</td>
				            <td width="10" class="boldp"><input name="submit1" type="button" style="border:0;background : url(images/buttons/save_event.gif);width:152px; height:22px;" class="button-01"
				                                                value="" onClick="saveEvent()"></td>
				            <td width="20">&nbsp;</td>
				            <td width="20" class="boldp"><input name="Submit332" type="button" style="border:0;background : url(images/buttons/search_event.gif);width:168px; height:22px;" class="button-01"
				                                                value="" onClick="searchEvents()"></td>
				            <td width="20">&nbsp;</td>
				            <td class="boldp"><input name="Submit332" type="button" style="border:0;background : url(images/buttons/calendar_view.gif);width:118px; height:22px;" class="button-01"
				                                     value="" onClick="parent.location='event_schedule.htm?action=<%=ActionKeys.ALL_MEDICAL_MEETINGS %>'"></td>
				             <td>&nbsp;</td>

				        </tr>
				        <tr height="10%"/>
	 			</table>

<table width="100%">
    <td>
            <div id="spaceContent">
                <table border="0" width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                                        <tr >
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                                           <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                        <tr >
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                        <tr >
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                        <td class="text-blue-01">&nbsp;</td>
                    </tr>
                </table>

            </div>
    </td>
</table>


</form>
</body>
<script type="text/javascript">
    <%
   User[] userList = null;

   if(session.getAttribute("INVITED_USERS") != null) {
       userList = (User[]) session.getAttribute("INVITED_USERS");
       if(userList != null && userList.length>0) {
       User user = null;
       String userType = "";
       for(int i=0;i<userList.length;i++) {
        user = userList[i];
        if( user != null ){
            if(user.getUserType().getId() == Constants.EXPERT_USER_TYPE ){
             userType = " (" + DBUtil.getInstance().doctor + ")";
            }else{
             userType = " (Employee)";
            }
    %>
    var thisform = document.events;
    thisform.invitedOl.options[<%=i%>] = new Option('<%=user.getLastName()+", "+user.getFirstName()+ userType%> ', <%=user.getId()%>);
    thisform.invitedOl.options[<%=i%>].selected = true;
    <%
       }
        }

        }
    }
    if(session.getAttribute("approversList")!=null){

       String[] approver=session.getAttribute("approversList").toString().split("@");
       for(int i=0;i<approver.length;i++){
    %>
    /*var thisform = document.events;
    thisform.approvers.options[<%=i%>] = new Option('<%=approver[i].toString()%>');
    thisform.approvers.options[<%=i%>].selected = true;*/
    <%
       }
    }
    %>
</script>
<%@ include file="footer.jsp" %>
<%
    		session.removeAttribute("MESSAGE");
		    session.removeAttribute("filePath");
		    session.removeAttribute("description");
		    session.removeAttribute("inputStream");
		    if (!"true".equalsIgnoreCase(request.getParameter("fromEvents"))) {
	            session.removeAttribute("EVENT_DETAILS");
			    session.removeAttribute("INVITED_USERS");
			    session.removeAttribute("approversList");
			    session.setAttribute("refreshed_event_add","true");

    		}



%>
</html>

