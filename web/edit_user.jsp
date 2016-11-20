<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup,
                 com.openq.user.User" %>
<%@ page import="com.openq.user.UserAddress" %>
<%@ page import="com.openq.group.Groups"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%
    ArrayList userTypeList = null;

      SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");

    if (request.getAttribute("USER_TYPE_LIST") != null) {
        userTypeList = (ArrayList) request.getAttribute("USER_TYPE_LIST");
    }

    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
        message = (String) session.getAttribute("MESSAGE");
    }

    OptionLookup countryLookup[] = null;
    if (session.getAttribute("COUNTRY_LIST") != null) {
        countryLookup = (OptionLookup[]) session.getAttribute("COUNTRY_LIST");
    }

    OptionLookup stateLookup[] = null;
    if (session.getAttribute("STATE_LIST") != null) {
        stateLookup = (OptionLookup[]) session.getAttribute("STATE_LIST");
    }

    OptionLookup userTypeOption[] = null;
    if (session.getAttribute("USER_TYPE_LIST") != null) {
        userTypeOption = (OptionLookup[]) session.getAttribute("USER_TYPE_LIST");
    }


    OptionLookup prefixLookup[] = null;
    if (session.getAttribute("PREFIX_LIST") != null) {
        prefixLookup = (OptionLookup[]) session.getAttribute("PREFIX_LIST");
    }


    OptionLookup suffixLookup[] = null;
    if (session.getAttribute("SUFFIX_LIST") != null) {
        suffixLookup = (OptionLookup[]) session.getAttribute("SUFFIX_LIST");
    }

    Groups[] groupInfo = null;
    int groupLen = 0;
    if (session.getAttribute("ALL_USER_GROUPS") != null) {
        groupInfo = (Groups[]) session.getAttribute("ALL_USER_GROUPS");
        groupLen = groupInfo.length;
    }
    boolean isAlreadySelected = false;
%>
<html>
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

<title><%=DBUtil.getInstance().doctor%> DNA 2.0 - openQ Technologies</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
<script src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
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
<Script language="Javascript">

function saveUser(formObj, contextURL, userId, k, full) {

    var thisform = document.userForm;

    var arrayOfCheckedGroup = new Array();
    var j = 0;

    if ((checkNullSearch(thisform.userName) && checkNullSearch(thisform.userPassword) && checkNullSearch(thisform.confirmUserPassword)
            && checkNullSearch(thisform.firstName) && checkNullSearch(thisform.lastName) && checkNullSearch(thisform.address1)
            && checkNullSearch(thisform.city) && checkNullSearch(thisform.state)  ) == false) {
        return false
    }

    if (formObj.userPassword.value != formObj.confirmUserPassword.value)
    {
        alert("Password & Confirm User Password are not equal");
        formObj.confirmUserPassword.focus();
        return false;
    }

    var userType = document.getElementById("userTypeId");
	//alert(userType.options[userType.selectedIndex].value);
	if(userType.options[userType.selectedIndex].value != 4)
    	{
    	if ((checkNull(thisform.staffid, 'Staff ID')) == false) {
	    formObj.staffid.focus();
        return false;
        }
    }

    if((isNaN(thisform.staffid.value))) {
    	if(userType.options[userType.selectedIndex].value != 4)
    	{
        alert("Please enter numbers only for Staff ID");
        formObj.staffid.focus();
        return false;
        }
    }

    if (!emailCheck(formObj.emailAddress.value))
    {
        alert("Please enter the required values for Email Address");
        formObj.emailAddress.focus();
        return false;
    }

    if ('<%=groupLen%>' != 0)
    {
        var userForm = window.frames['userGroupList'].groupsListForm;
        var flag = false;

        if (window.frames['userGroupList'].groupsListForm.checkedGroups.length) {

            for (var i = 0; i < window.frames['userGroupList'].groupsListForm.checkedGroups.length; i++) {
                if (window.frames['userGroupList'].groupsListForm.checkedGroups[i].checked == true) {
                    arrayOfCheckedGroup[j++] = window.frames['userGroupList'].groupsListForm.checkedGroups[i].value;
                }
            }
        }
        else
        {
            arrayOfCheckedGroup[0] = window.frames['userGroupList'].groupsListForm.checkedGroups.value;
        }

        for (var i = 0; i < userForm.elements.length; i++) {

            if (userForm.elements[i].type == "checkbox" && userForm.elements[i].checked) {
                flag = true;
                break;
            }
        }

        formObj.action = contextURL + "/addUser.htm?action=<%=ActionKeys.SAVE_USER%>&userId=" + userId + "&chkGroupIds=" + arrayOfCheckedGroup + "&fullProfile=" + full;
        /*if (flag) {
            if (full == "true") {
                formObj.target = "_top";
            }*/
            formObj.submit();
       /* } else {
            alert("Please select atleast one group to add to user");
        }*/
    }
    <%--else
    {
        formObj.action = contextURL + "/user.do?action=<%=ActionKeys.SAVE_USER%>&userId=" + userId + "&chkGroupIds=" + arrayOfCheckedGroup + "&fullProfile=" + full;
        if (full == "true") {
            formObj.target = "_top";
        }
        formObj.submit();
    }--%>

} // end of saveUser()

function goBack(formObj, contextURL) {
    formObj.action = contextURL + "/users.htm?action=<%=ActionKeys.UPDATE_USER%>";
    formObj.submit();
}

function checkUncheck(formObj)
{
   if (document.userForm.checkAllGroups.checked == true)
    {
        box = eval(window.frames['userGroupList'].groupsListForm.checkedGroups);

        if (box.length > 0)
        {
            for (var i = 0; i < box.length; i++) {
                box[i].checked = true;
            }
        }
        else
        {
            box.checked = true;
        }
    }
    else
    {
        box = eval(window.frames['userGroupList'].groupsListForm.checkedGroups);

        if (box.length > 0)
        {
            for (var i = 0; i < box.length; i++)
            {
                box[i].checked = false;
            }
        }
        else
        {
            box.checked = false;
        }
    }
}// end of checkUncheck()

function show_calendar(sName) {

    gsDateFieldName = sName;
    // pass in field name dynamically

    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";

    if (document.layers) // NN4 param

        winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";

    window.open("Popup/PickerWindow.html", "_new_picker", winParam);

}

function showFullProfile(field) {

    elem = document.getElementById("expertProfile");


    var staffText = document.getElementById("staffid");
    var staffTd = document.getElementById("staffIdName");

	 if( field.options[field.selectedIndex].value == 4)
	 {
	    staffText.readOnly = true;
	    staffTd.innerHTML = "StaffId";
	 }
	 else
	 {
	  staffText.readOnly = false;
	    staffTd.innerHTML = "Staff ID<sup>*</sup>";
	 }
    if (field.value == 3) {
        elem.style.display = "block";
    } else {
        elem.style.display = "none";
    }

}

</Script>
</head>

<body class="">

<form name="userForm" method="Post" AUTOCOMPLETE="OFF">
<%
    User user = null;
    UserAddress address = null;
    if (session.getAttribute("USER_INFO") != null) {
        user = (User) session.getAttribute("USER_INFO");
        address = user.getUserAddress();
    }


    if (user != null) {
    session.setAttribute("USER_ORIGINAL_PASSWORD",user.getPassword());
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="left">
    <td>
        <font face="verdana" size="2" color="red">
            <b><%=message%></b>
        </font>
    <td>
</tr>
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
    <td width="10" rowspan="23" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertlist">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="20">&nbsp;</td>
                <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="myexperttext">Update User - Account Information </td>
            </tr>
        </table>
	</div>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="121" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="10" colspan="9"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
            <tr>
                <td width="25" height="20">&nbsp;</td>
                <td width="180" class="text-blue-01">Username<sup>*</sup></td>
                <td width="20">&nbsp;</td>
                <td width="180" class="text-blue-01">Password<sup>*</sup></td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                <td width="180" class="text-blue-01">Confirm Password <sup>*</sup></td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                 <td width="180" class="text-blue-01">Disable User </td>
                <td class="text-blue-01">&nbsp;</td>
            </tr>
            <tr>
                <td height="20">&nbsp;</td>
                <td><input name="userName" type="text" class="field-blue-01-180x20" value="<%=user.getUserName()%>"
                           maxlength="30"></td>
                <td>&nbsp;</td>
                <td>
                    <input name="userPassword" type="password" class="field-blue-01-180x20"
                           value="<%=user.getPassword()%>" maxlength="30">
                    <input name="dbPassword" type="hidden" class="field-blue-01-180x20" value="<%=user.getPassword()%>">
                </td>
                <td>&nbsp;</td>
                <td><input name="confirmUserPassword" type="password" class="field-blue-01-180x20"
                           value="<%=user.getPassword()%>" maxlength="30"></td>
                <td>&nbsp;</td>
                <td><input name="deleteFlag" type="checkbox"
                           <%if("Y".equals(user.getDeleteFlag())){ %> checked <%} %> ></td>
                <td>&nbsp;</td>

            </tr>
            <tr>
                <td height="10" colspan="9"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
            <tr>
                <td height="20">&nbsp;</td>
                <td class="text-blue-01">User Type </td>
                <td>&nbsp;</td>
                <td class="text-blue-01">E-Mail Address<sup>*</sup></td>
                <td>&nbsp;</td>
                <td id = "staffIdName" class="text-blue-01">Staff ID<sup>*</sup></td>
                <td>&nbsp;</td>

              </tr>
            <tr>
                <td height="20">&nbsp;</td>
                <td><select name="userTypeId"  id="userTypeId" class="field-blue-01-180x20" onchange="showFullProfile(this)">
                     <%
                        if (userTypeOption != null && userTypeOption.length > 0) {
                            OptionLookup lookup = null;
                            isAlreadySelected = false;
                            for (int i = 0; i < userTypeOption.length; i++) {
                                lookup = userTypeOption[i];
                         		String selected = "" ;
                          		if(lookup.isDefaultSelected())
                          			selected = "selected";
                    %>
                    <option value="<%=lookup.getId()%>"
                    <% if (lookup.getOptValue().equals(user.getUserType().getOptValue())) {
                    	isAlreadySelected = true;
                    %>selected<%}
                       else if(!isAlreadySelected){%> <%=selected%> <%} %>><%=lookup.getOptValue()%></option>
                    <%
                            }
                        }
                    %>
                </select></td>
                <td>&nbsp;</td>
                <td><input name="emailAddress" type="text" class="field-blue-01-180x20"
                           value="<%=(user.getEmail() != null ? user.getEmail() : "")%>"
                           maxlength="50"></td>
                <td>&nbsp;</td>
                <td><input name="staffid" id ="staffid" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=(user.getStaffid() == null?"":user.getStaffid())%>"></td>
                <td>&nbsp;</td>

            </tr>
            <tr>
                <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
            <tr>
                <td height="1" colspan="7" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                            width="1" height="1"></td>
            </tr>
            <tr>
                <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertplan">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="20">&nbsp;</td>
                <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="myexperttext">Update User - Personal Information </td>
            </tr>
        </table>
	</div>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="40" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="4">&nbsp;</td>
                <td width="95" class="text-blue-01">Prefix</td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                <td width="180" class="text-blue-01">First Name<sup>*</sup></td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                <td width="100" class="text-blue-01">Middle Initial</td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                <td width="180" class="text-blue-01">Last Name<sup>*</sup></td>
                <td width="20" class="text-blue-01">&nbsp;</td>
                <td class="text-blue-01">Suffix</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><select name="prefix" class="field-blue-06-100x20">
            <%
                if (prefixLookup != null && prefixLookup.length > 0) {
                    OptionLookup lookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < prefixLookup.length; i++) {
                        lookup = prefixLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";

            %>

            <option value="<%=lookup.getId()%>"
            <% if(user.getPrefix() != null)if (lookup.getOptValue().equals(user.getPrefix().getOptValue())) {
            	isAlreadySelected = true;
            %>selected<%}
            else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select></td>
                <td>&nbsp;</td>
                <td><input name="firstName" type="text" class="field-blue-01-180x20"
                           value="<%=(user.getFirstName() != null ? user.getFirstName() : "")%>" maxlength="30"></td>
                <td>&nbsp;</td>
                <td><input name="middleInitial" type="text" class="field-blue-04-50x20"
                           value="<%=((user.getMiddleName()) != null ? user.getMiddleName() : "")%>" maxlength="30">
                </td>
                <td>&nbsp;</td>
                <td><input name="lastName" type="text" class="field-blue-01-180x20"
                           value="<%=((user.getLastName()) != null ? user.getLastName() : "")%>" maxlength="30"></td>
                <td>&nbsp;</td>
                <td><select name="suffix" class="field-blue-06-100x20">
            <%
                if (suffixLookup != null && suffixLookup.length > 0) {
                    OptionLookup lookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < suffixLookup.length; i++) {
                        lookup = suffixLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
            %>

            <option value="<%=lookup.getId()%>"
            <% if(user.getSuffix() != null)if (lookup.getOptValue().equals(user.getSuffix().getOptValue())) {
            	isAlreadySelected = true;
            %>selected<%}
             else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><span class="back-white"><img
            src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" class="back-blue-03-medium"></span></td>
</tr>
<tr>
<td align="left" valign="top" class="back-white">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td width="2%" height="20">&nbsp;</td>
    <td width="20%" class="text-blue-01">Birth Date</td>
    <td width="1%">&nbsp;</td>
    <td width="18%" class="text-blue-01">Security Question </td>
    <td width="2%" class="text-blue-01">&nbsp;</td>
    <td width="18%" class="text-blue-01">Answer </td>
    <td class="text-blue-01" width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
           <tr>
                 <td width="113" height="20" valign="center"><input type="text" name="birthDate" readonly="true" class="field-blue-01-180x20" name="eventDate" id="sel1" value=""><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></td>
                <td width="0"></td>
                <td><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></a></td>            </tr>        </table>
    </td>
    <td>&nbsp;</td>
    <td><input name="securityQuestion" type="text" class="field-blue-01-180x20"
               value="<%=((user.getSecurityQuestion()) != null ? user.getSecurityQuestion() : "")%>" maxlength="256">
    </td>
    <td>&nbsp;</td>
    <td><input name="answer" type="text" class="field-blue-01-180x20"
               value="<%=((user.getAnswer()) != null ? user.getAnswer() : "")%>" maxlength="256"></td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="1" colspan="7" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                height="1"></td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01">Address 1 <sup>*</sup></td>
    <td>&nbsp;</td>
    <td class="text-blue-01">Address 2 </td>
    <td class="text-blue-01">&nbsp;</td>
    <td class="text-blue-01">City<sup>*</sup></td>
    <td class="text-blue-01" width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td><input name="address1" type="text" class="field-blue-01-180x20"
               value="<%=((address!=null&&address.getAddress1() != null )? address.getAddress1() : "")%>" maxlength="80"></td>
    <td>&nbsp;</td>
    <td><input name="address2" type="text" class="field-blue-01-180x20"
               value="<%=((address!=null&&address.getAddress2() != null) ? address.getAddress2() : "")%>" maxlength="80"></td>
    <td>&nbsp;</td>
    <td><input name="city" type="text" class="field-blue-01-180x20"
               value="<%=((address!=null&&address.getCity() != null )? address.getCity() : "")%>" maxlength="30"></td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01">State/Prov.<sup>*</sup></td>
    <td>&nbsp;</td>
    <td class="text-blue-01">Country<sup>*</sup></td>
    <td>&nbsp;</td>
    <td class="text-blue-01">Postal Code  </td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td>
        <select name="state" class="field-blue-01-180x20">
            <%
                if (stateLookup != null && stateLookup.length > 0) {
                    OptionLookup lookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < stateLookup.length; i++) {
                        lookup = stateLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
            %>

            <option value="<%=lookup.getId()%>"
            <%if(address!=null&&address.getState()!=null)
            	if (lookup.getOptValue().equals(address.getState().getOptValue())) {
            		isAlreadySelected = true;
            	%>selected<%}
                else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>

    </td>
    <td>&nbsp;</td>
    <td><select name="country" class="field-blue-01-180x20">
        <%
            if (countryLookup != null && countryLookup.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < countryLookup.length; i++) {
                    lookup = countryLookup[i];
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
        %>

        <option value="<%=lookup.getId()%>"
        <% if(address!=null&&address.getCountry() != null)
        	if (lookup.getOptValue().equals(address.getCountry().getOptValue())) {
        		isAlreadySelected = true;
        	%>selected<%}
            else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </select></td>
    <td>&nbsp;</td>
    <td><input name="zip" type="text" class="field-blue-06-100x20" value="<%=((address!=null&&address.getZip()!=null)?address.getZip():"N.A")%>" maxlength=15></td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01">Phone Number </td>
    <td>&nbsp;</td>
    <td class="text-blue-01">Suite Room </td>
    <td>&nbsp;</td>
    <td id = "mslDateName" class="text-blue-01">MSL Start Date</td>
    <td>&nbsp;</td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td><input name="phoneNumber" type="text" class="field-blue-01-180x20"
               value="<%=(user.getPhone() != null ? user.getPhone() : "")%>"
               onKeyPress="javascript:allow_only_digits()" maxlength=10></td>
    <td>&nbsp;</td>
    <td><input name="suiteRoom" type="text" class="field-blue-01-180x20"
               value="<%=((address!=null&&address.getSuiteRoom() != null) ? address.getSuiteRoom() : "")%>"
               onKeyPress="javascript:allow_only_digits()" maxlength="10"></td>
    <td>&nbsp;</td>
    <td>
        <table width="50%" border="0" cellspacing="0" cellpadding="0">
		            <tr>

		                 <td width="113" height="20" valign="center"><input type="text" name="MSLDate" readonly="true" class="field-blue-06-100x20"  id="sel2" value="<%=(user.getMslStartDate() == null)?"":sdf.format(user.getMslStartDate())%>"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></td>
                		<td width="0"></td>
                		<td><a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></a></td>
                		</tr>
       				 </table>
     </td>

    <td>&nbsp;</td>
    <td width="39%">&nbsp;</td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20">&nbsp;</td>
    <td class="text-blue-01">Title </td>
</tr>
<tr>
	<td height="20">&nbsp;</td>
	<td>
	   <input name="title" type="text" class="field-blue-01-180x20" maxlength=100 value="<%=(user.getTitle()!=null)?user.getTitle():"" %>">
	   </td>
	   <td>&nbsp;</td>
	   </tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="1" colspan="7" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                height="1"></td>
</tr>
<tr>
    <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
</table>
</td>
</tr>
<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<%
    if (groupInfo != null && groupInfo.length > 0) {
%>
<tr>
    <td height="20" align="left" valign="top" class="">
	<div class="myexpertlist">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="20">&nbsp;</td>
                <td width="2%"><img src="<%=COMMONIMAGES%>/icon_attendees.gif" width="14" height="14"></td>
                <td class="myexperttext">Update Assigned User Groups </td>
            </tr>
        </table>
	</div>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="25" align="center">
                    <!--<input type="checkbox" name="checkAllGroups" value="checkbox" title="Select or deselect all groups" onClick="javascript:checkUncheck(this.form)">--></td>
                <td width="2%" align="left"><img src="<%=COMMONIMAGES%>/icon_attendees.gif" width="14" height="14"></td>
                <td class="myexperttext">Available User Groups</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                   height="1"></td>
</tr>
<tr>
    <td height="100" align="left" valign="top" class="back-white">
        <iframe src="edit_group_list.jsp" height="100%" width="100%" name="userGroupList" frameborder="0"
                scrolling="yes"></iframe>
    </td>
</tr>
<tr>
    <td align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                   height="1"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<%
    }
%>
<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="25" height="30">&nbsp;</td>
                <td>
                    <input name="save" type="button" class="button-01" style="background: transparent url(images/buttons/save_user.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 94px; height: 22px;" value=""
                           onClick="javascript:saveUser(this.form, '<%=CONTEXTPATH%>', '<%=user.getId()%>', '','false')">
                </td>
                <td width="25" height="30">&nbsp;</td>
                <td id="expertProfile" style="display:none">
                	<!--
                    <input name="expert" type="button" class="button-01" value="Edit Full Profile"
                           onClick="javascript:saveUser(this.form, '<%=CONTEXTPATH%>', '<%=user.getId()%>', '','true')">
                    -->
                </td>
                <td width="10">&nbsp;</td>
                <td><input name="cancel" type="button" class="button-01" value=""
                           onClick="javascript:goBack(this.form, '<%=CONTEXTPATH%>')"  style="background: transparent url(images/buttons/cancel_edit.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 101px; height: 22px;"></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td align="left" valign="top">&nbsp;</td>
</tr>
</table>
<%
        session.removeAttribute("userAddressDTO");
        session.removeAttribute("MESSAGE");
    }
%>
<script>
  //  showFullProfile(document.userForm.userTypeId);
</script>
</form>
</body>

</html>
