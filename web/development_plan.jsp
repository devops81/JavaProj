<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ include file="imports.jsp"%>
<%@ page import="com.openq.eav.option.OptionLookup" %>

<%@page import = "java.util.List,
				  java.text.NumberFormat"%>
<%@ page import="com.openq.kol.InteractionsDTO"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%  String selectedTab=request.getParameter("selected")==null ?"":request.getParameter("selected");
    String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
	String prettyPrint = null != request.getParameter("prettyPrint") ? (String) request.getParameter("prettyPrint") : null ;
	if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"></span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/></span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>

<%
    long userType = -1;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getId();
    }
	String userType1=null;
	String disValue=null;
	 if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType1 = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();
    }
	if(userType1 !=null && userType1.equalsIgnoreCase("Viewer")){
		disValue = "disabled";
	}else{
		disValue="";
	}
	String mode = "ADD";
  	if (session.getAttribute("MODE") != null) {
		mode = (String) session.getAttribute("MODE");
	}

	InteractionsDTO interactionsDTO = new InteractionsDTO();
	if (session.getAttribute("SEL_DEV_PLAN") != null) {
		interactionsDTO =  (InteractionsDTO) session.getAttribute("SEL_DEV_PLAN");
	}
    String comments = null;
    if (session.getAttribute("SEL_COMMENTS") != null)
    {
    	comments = (String)session.getAttribute("SEL_COMMENTS");
    	
    }
	int devPlanId = 0;
	if (session.getAttribute("SEL_DEV_PLAN_ID") != null) {
		devPlanId =  Integer.parseInt((String) session.getAttribute("SEL_DEV_PLAN_ID"));
	}
	String activityId  = null;
    if (session.getAttribute("SEL_ACTIVITY_ID")!= null){
         activityId = (String)session.getAttribute("SEL_ACTIVITY_ID");
    }
    int userId = 0;
	if (session.getAttribute("USER_ID") != null) {
		userId = Integer.parseInt((String) session.getAttribute("USER_ID"));
	}

	/*int userTypeId = 0;
	if (session.getAttribute(SessionKeys.USER_TYPE_ID) != null) {
		userTypeId = Integer.parseInt((String) session.getAttribute(SessionKeys.USER_TYPE_ID));
	}*/

	int expertId = 0;
	if (session.getAttribute("EXPERT_ID") != null) {
		expertId = Integer.parseInt((String) session.getAttribute("EXPERT_ID"));
	}

	String userSectionName = (String)session.getAttribute("USER_SECTION_NAME");
	String userSectionId = (String)session.getAttribute("USERSECTION_ID");

	 float totalCost = 0;
     NumberFormat nf = NumberFormat.getCurrencyInstance();
	 if (session.getAttribute("DEV_PLANS_LIST") != null) {
		ArrayList devPlansList = (ArrayList)session.getAttribute("DEV_PLANS_LIST");

		for (int i = 0; i < devPlansList.size() ; i++) {
			InteractionsDTO dto =(InteractionsDTO) devPlansList.get(i);
			String planCost = dto.getPlanCost();
			if(planCost != null && !"".equals(planCost)) {
				try {
					totalCost += nf.parse(planCost).floatValue();
				} catch(NumberFormatException nfe) {
					nfe.printStackTrace();
				}
			}
		}
	 }
	 String totalCostString = nf.format(totalCost);


	List planHistoryList = new ArrayList();
	if (session.getAttribute("DEV_PLANS_HISTORY_LIST") != null) {
		planHistoryList =  (List) session.getAttribute("DEV_PLANS_HISTORY_LIST");
	}

    HashMap activityList = new HashMap();
    if(session.getAttribute("ACTIVITY") != null ){
       activityList = (HashMap) session.getAttribute("ACTIVITY");
    }

    OptionLookup statusLookUp[] = null;
    if (session.getAttribute("PLAN_STATUS") != null) {
        statusLookUp = (OptionLookup[]) session.getAttribute("PLAN_STATUS");
    }


	OptionLookup roleLookup[] = null;
   if (session.getAttribute("PLAN_ROLE") != null) {
		roleLookup = (OptionLookup[]) session.getAttribute("PLAN_ROLE");
	}

    OptionLookup therapyLookup[] = null;
   if (session.getAttribute("PLAN_THERAPY") != null) {
		therapyLookup = (OptionLookup[]) session.getAttribute("PLAN_THERAPY");
	}

    String mesg = null;
    if (null != session.getAttribute("MESSAGE") ){
        mesg = (String) session.getAttribute("MESSAGE");
    }
    boolean isAlreadySelected = false;
%>


<html>

<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript">
function toggleAlertMode() {

		var iconName = document.getElementById('_alertIcon').src.toString();
		if (iconName.indexOf('disabled') > 0) {


			if (confirm("Please confirm that you would like to recieve e-mail when '" + "devlopent plan" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {

				document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
			
				alert("E-mail alerts for '" + "devlopent plan" + "' of <%=currentKOLName%> activated.");
				setCookie("devlopent plan" + entityId, "enabled", 15);
				//alert(document.getElementById('_alertIcon').src);
			}
		} else {
			if (confirm("Please confirm that you would not like to recieve e-mail when '" + "Devlopemnt plan" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
				alert("E-mail alerts for '" + "Devlopment plan" + "' of <%=currentKOLName%> de-activated.");
				eraseCookie(Plan + entityId);
				//alert(document.getElementById('_alertIcon').src);
			}
		}
	}

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

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script  src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
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
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

<script language="JavaScript">
function show_calendar(sName) {
    gsDateFieldName = sName;
    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
    if (document.layers)
        winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
    window.open("Popup/PickerWindow.html", "_new_picker", winParam);
}
function addDevPlan(formObj,contextURL)
{

	var thisform = document.devPlans;

      if (thisform.activity.value == "-1"){
             alert ("Please select an Activity");
             thisform.role.focus();
             return false;
     }

  /*   if (!isEmpty(thisform.therapy, "Therapy")){ thisform.therapy.focus(); return false;}*/
     if (!isEmpty(thisform.dueDate, "Due Date")){ thisform.dueDate.focus(); return false;}
   /*  if (!isEmpty(thisform.owner, "Owner")){ thisform.owner.focus(); return false;}*/

     if (thisform.role.value == "-1"){
         alert ("Please select a Title");
         thisform.role.focus();
         return false;
     }
    if (thisform.status.value == "-1"){
         alert ("Please select a Status");
         thisform.status.focus();
         return false;
     }

    formObj.action = contextURL+"/searchInteraction.htm?action=<%=ActionKeys.ADD_DEV_PLAN%>";
    formObj.submit();

}

function updateDevPlan(formObj,contextURL)
{

	var thisform =document.devPlans;

         /* if (thisform.activity.value == "-1"){
             alert ("Please select an Activity");
             thisform.role.focus();
             return false;
         }*/
     /*    if (!isEmpty(thisform.therapy, "Therapy")){ thisform.therapy.focus(); return false;}*/
         if (!isEmpty(thisform.dueDate, "Due Date")){ thisform.dueDate.focus(); return false;}
     /*    if (!isEmpty(thisform.owner, "Owner")){ thisform.owner.focus(); return false;}*/

        if (thisform.role.value == "-1"){
             alert ("Please select a Title");
             thisform.role.focus();
             return false;
         }
        if (thisform.status.value == "-1"){
             alert ("Please select a Status");
             thisform.status.focus();
             return false;
         }

	formObj.action = contextURL+"/searchInteraction.htm?action=<%=ActionKeys.UPDATE_DEV_PLAN%>&devPlanId=<%=devPlanId%>&activity=<%=activityId%>";
	formObj.submit();

}

function addAttendee(username, phone, email, staffid) {
        document.devPlans.owner.value = username;
        document.devPlans.staffId.value = staffid;

    }

function cancel(formObj,contextURL)
{

  formObj.action = contextURL + "/searchInteraction.htm?action=<%=ActionKeys.DEV_PLAN_HOME%>";
  formObj.submit();

}

function deleteDevPlan(formObj, contextURL){

  var thisForm = window.frames['devPlansList'].devPlansListForm;
  var flag = false;
  var element = thisForm.checkedDevPlanList;

  if (element.length == null) {
	if (element.type == "checkbox" && element.checked){
	   flag = true;
	}
  } else {
    for (var i=0;i<element.length;i++){

     if (element[i].type == "checkbox" && element[i].checked){
		flag = true;
		break;
	 }
    }
  }

  if (flag) {
     if (confirm("Do you want to delete the selected development plan(s)?")) {
        formObj.action = contextURL+"/searchInteraction.htm?action=<%=ActionKeys.DELETE_DEV_PLAN%>";
        formObj.target = "_parent";
        formObj.submit();
     }
  } else {
     alert("Please select atleast one development plan to delete");
  }
}

</script>
</head>

<body>
<div class="producttext">
<form name="devPlans" method="post" AUTOCOMPLETE="OFF">

 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
   <%  if(mesg != null) {
   %>
   <tr>
   <td class="text-blue-01-red"><%=mesg != null ? mesg : ""%></td>
   </tr>
  <%
	}
  %>

   <tr>
     <td height="20" align="left" valign="top">
      <div class="myexpertlist">
	      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr align="left" valign="middle" style="color:#4C7398">
	          <td width=100% valign="middle">
	          	<div class="myexperttext">&nbsp; <%=DBUtil.getInstance().doctor%> Plan </div>
	          </td>
	     </table>
	   </div>
    </td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td>
     <table width="98%">
      <tr bgcolor="#faf9f2">
        <td width="4%">&nbsp;</td>
        <td width="20%" class="expertListHeader">Activity </td>
        <td width="11%" class="expertListHeader">Status </td>
        <td width="16%" class="expertListHeader">Due Date </td>
        <td width="15%" class="expertListHeader">Owner</td>
        <td width="15%" class="expertListHeader">Title </td>
        <td width="15%" class="expertListHeader">Comment </td>  
        <td width="2%" class="expertListHeader"></td>
      </tr>
    </table>
   </td>
  </tr>


  <tr>
    <td height="100" align="left" valign="top" class="back-white">
       <iframe name="devPlansList" src="development_plan_list.jsp" height="100%" width="100%" frameborder="0" scrolling="yes"></iframe>
    </td>
  </tr>

  <tr>
    <td height="30" valign="top" class="back-white">
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr>
         <td width="5" height="30">&nbsp;</td>
         <td>&nbsp;&nbsp;<input name="Submit" type="button" style="border:0;background : url(images/buttons/delete_experts_plan_activit.gif);width:196px; height:22px;" class="button-01" value="" onClick="deleteDevPlan(window.devPlansList.document.forms[0], '<%=CONTEXTPATH%>');"></td>
         <td width="10">&nbsp;</td>
         <td>&nbsp;</td>
         <td width="10">&nbsp;</td>
		 <td width="50" height="30">&nbsp;</td>
       </tr>
     </table>
    </td>
  </tr>


  <tr>
    <td height="20" align="left" valign="top">
     <div class="myexpertlist">
     	<table width="98%"  border="0" cellspacing="0" cellpadding="0">
	      <tr style="color:#4C7398">
	        <td>
	           <div class="myexperttext"><%=((mode.equalsIgnoreCase("EDIT")) ?  "Edit  Activity" :  "Add New Activity") %></div>
	        </td>
	      </tr>
	    </table>
    </div>
   </td>
  </tr>

  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
  </tr>

 <!-- <tr>
    <td width="230" height="40" align="left" valign="top" class="back-white">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="25" height="20">&nbsp;</td>
          <td width="200" class="text-blue-01-bold"> Development Strategy </td>
        </tr>
        <tr>
          <td width="25" height="20">&nbsp;</td>
          <td width="200" class="text-blue-01">
			<input name="strategy" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=(((interactionsDTO != null) && (interactionsDTO.getStrategy()!=null)) ? interactionsDTO.getStrategy() : "")%>" <% if ((mode.equalsIgnoreCase("EDIT")) && (userId != interactionsDTO.getUserId())) { %> disabled <% } %>>
          </td>
        </tr>
      </table>
    </td>
  </tr>

  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>-->
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
  </tr>

  <tr>
    <td height="120" align="left" valign="top" class="back-white">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
          <td width="5%" height="20">&nbsp;</td>
          <td width="27%" class="text-blue-01-bold" colspan="2"> Activity *</td>
          <td width="3%" class="text-blue-01">&nbsp;</td>
          <td width="22%" class="text-blue-01-bold"> Title * </td>
          <td width="5%" class="text-blue-01">&nbsp;</td>
          <td width="16%" class="text-blue-01-bold"> Status *</td>
          <td class="text-blue-01">&nbsp;</td>
          <td width="20%" class="text-blue-01-bold"> Comment</td>
          <td class="text-blue-01">&nbsp;</td>
        </tr>
        <tr>
          <td width="5%" height="20">&nbsp;</td>
          <td width="27%" class="text-blue-01" colspan="2">
            <input name="userId" type="hidden" class="text-blue-01" maxlength="10" value="<%= (mode.equalsIgnoreCase("ADD")) ? userId : interactionsDTO.getUserId() %>">
            <input name="expertId" type="hidden" class="text-blue-01" maxlength="10" value="<%=expertId%>">
			<%--<input name="activity" type="text" class="text-blue-01" maxlength="25" value="<%=(((interactionsDTO != null) && (interactionsDTO.getActivity()!=null)) ? interactionsDTO.getActivity() : "")%>" <% if ((mode.equalsIgnoreCase("EDIT")) && (userId != interactionsDTO.getUserId())) { %> disabled <% } %>>--%>
              <select name="activity" class="field-blue-01-180x20" <% if ((mode.equalsIgnoreCase("EDIT"))){%> disabled <%}%>>
                  <option value="-1">Please Select</option>
                  <%  String value = "";
                      String id ="";
                      String tactic = null;
                      if (null != activityList){
                        Iterator itr = activityList.keySet().iterator();
	                		while (itr.hasNext()) {
                                id = (String) itr.next();
                                value = (String)activityList.get(id);
                          %>
                               <option value="<%=id%>" <%  if ( (interactionsDTO != null) && (interactionsDTO.getActivity() != null) && (interactionsDTO.getActivity().equals(value)) )  { tactic = id; %> SELECTED <% } %>><%=value%></option>
                            <%}
                    }%>
               </select>
              <input type="hidden" name="tactic" value="<%=null != tactic ? tactic : activityId%>">
          </td>
          <td width="3%" class="text-blue-01">&nbsp;</td>
          <td width="22%" class="text-blue-01">
            <select  name="role" class="field-blue-01-180x20" <% if ((mode.equalsIgnoreCase("EDIT")) && interactionsDTO.getStaffId() != null && interactionsDTO.getRole() != null) {%> disabled <%}%>>
            <option value="-1">Please Select</option>
            <%  String title = null;

                String vals = "";
                if (roleLookup != null && roleLookup.length > 0) {
                 OptionLookup lookup = null;
                 isAlreadySelected = false;
                for (int i = 0; i < roleLookup.length; i++) {
                    lookup = roleLookup[i];
                    vals =  String.valueOf(lookup.getId());
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
           %>
         <option value="<%=lookup.getId()%>" 
         <%  if ( (interactionsDTO != null) && (interactionsDTO.getRole() != null) 
        		 && (interactionsDTO.getRole().equals(vals)) )  { 
        	 		title = lookup.getId()+"";
        	 		isAlreadySelected = true;
        	 %> SELECTED <% }
         else if(!isAlreadySelected) {%> <%=selected%> <%} %>><%=lookup.getOptValue()%></option>

            <%
                }
            }
            %>
           </select>
         </td>
          <td width="5%">&nbsp;</td>
          <td width="16%" class="text-blue-01">
			<select name="status"  class="field-blue-01-180x20">
			<option value="-1">Please Select</option>
			<%if (statusLookUp != null && statusLookUp.length > 0) {
                OptionLookup lookup = null;
                String val = "";
                isAlreadySelected = false;
                for (int i = 0; i < statusLookUp.length; i++) {
                    lookup = statusLookUp[i];
                    val =  String.valueOf(lookup.getId());
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
           %>
            <option value="<%=lookup.getId()%>" 
            <%  if ( (interactionsDTO != null) && (interactionsDTO.getStatus() != null) 
            		&& (interactionsDTO.getStatus().equals(val)) )  { 
            	isAlreadySelected = true;
            		%> SELECTED <% } 
            		else if(!isAlreadySelected){%> <%=selected%> <%} %>> <%=lookup.getOptValue()%></option>

            <%
                }
            }
            %>
			</select>
          </td>
          <td class="text-blue-01">&nbsp;</td>
          <td class="boldp"><input name="comment" type="text" class="field-blue-01-180x20" maxlength="500"
                                    value="<%=((comments!=null&&!comments.equalsIgnoreCase("null"))?comments:"")%>">
          </td>
        </tr>
       <tr>
        <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
       </tr>

       <tr>
        <td width="5%" class="text-blue-01">&nbsp;</td>
        <td width="27%" class="text-blue-01-bold" colspan="2"> Due Date *</td>
        <td width="3%" class="text-blue-01">&nbsp;</td>
        <td width="22%" class="text-blue-01-bold">Owner</td>
        <td width="5%" class="text-blue-01">&nbsp;</td>
        <td width="16%" height="18">&nbsp;</td>
        <td class="text-blue-01-bold">&nbsp;</td>
       </tr>
       <tr>
        <td width="5%">&nbsp;</td>
        <td width="11%" valign="middle"><input type="text" readonly="true" class="field-blue-01-180x20" name="dueDate" id="sel1" value="<%=((interactionsDTO != null) && (interactionsDTO.getDueDate()) != null) ? interactionsDTO.getDueDate() : ""%>"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></td>
        <td width="15%" valign="top">&nbsp;<a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></td>
        <td width="3%" valign="top">
		</td><td width="22%">
          <input name="owner" type="text" readonly  class="field-blue-01-180x20" maxlength="25" value="<%=((interactionsDTO != null && interactionsDTO.getOwner() != null) ? interactionsDTO.getOwner() : "")%>" >
          <input name="staffId" type="hidden" value="<%=null != interactionsDTO.getStaffId() ? interactionsDTO.getStaffId() : "" %>"/>
        </td>
        <td width="5%" valign="top" align="left">&nbsp;</td>

        <td width="16%" height="20">  <a href="#" onClick="javascript:window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')" class="text-blue-01-link">Lookup Company Owner</a></td>
        <td>&nbsp;</td>
      </tr>

      <tr>
	    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	  </tr>



      	  <tr>
	    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	  	</tr>



    </table>
   </td>
  </tr>
  <tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="50" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25" height="30">&nbsp;</td>
        <td>
        <%
       	  if (mode.equalsIgnoreCase("ADD")) {
        %>
           <input type="button" value="" name="Submit2" style="background : url(images/buttons/add_new_activity.gif);width:133px; height:23px;" class="button-01" <%=disValue %>  onClick="javascript:addDevPlan(this.form, '<%=CONTEXTPATH%>');">
        </td>
     </td>
	 <td width="5" height="30">&nbsp;</td>
        <td width="10">&nbsp;</td>

        <td>&nbsp;</td>
        <% } else {
           /* boolean found = false;
            if(session.getAttribute("FOUND")!= null  ){
                found = ((Boolean)session.getAttribute("FOUND")).booleanValue();

            }
            if (found) {*/
        %>
        <td>
           <input type="button" value="" name="Submit2" style="background : url(images/buttons/save_activity.gif);width:110px; height:22px;" class="button-01"  <%=disValue %> onClick="javascript:updateDevPlan(this.form, '<%=CONTEXTPATH%>');">
        </td>
        <td width="10">&nbsp;</td>
        <td>
			<input type="button" value="" name="Submit2" style="background : url(images/buttons/cancel_edit.gif);width:101px; height:23px;" class="button-01"  <%=disValue %>  onClick="javascript:cancel(this.form, '<%=CONTEXTPATH%>');"></td>
        <%
            } // end of if (userId == interactionsDTO.getUserId())  --%>
           <%-- else {
        %>
          	 	<td><input name="Submit22" type="button" class="button-01" value="Cancel View" onClick="javascript:cancel(this.form, '<%=CONTEXTPATH%>');"></td>
        <%
            }
           }
        %> --%>

      </tr>
    </table></td>
  </tr>

  <tr>
    <td align="right" valign="top"><table>

	<%if (!"true".equalsIgnoreCase(prettyPrint) ) {%>

      <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %>
                 <td valign="top" align="right" width="67" style="cursor:hand"
                     >
					<a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>
<img src='images/vCard.jpg' border=0 height="32" title="Download Vcard"></a><br>
					<a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>
					Vcard</a></td><%}%>
      <% String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
	  	boolean isSAXAJVUser = false;
		if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
				isSAXAJVUser = true;
		}
		
		String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
		boolean isOTSUKAJVUser = false;
		if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
			isOTSUKAJVUser = true;
		}
	
      if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") &&
    		  !isSAXAJVUser && !isOTSUKAJVUser)
                 { %><td width="8">&nbsp;</td>
                 <td valign="top" align="right" width="37" style="cursor:hand" class="text-blue-link"
                     onClick="javascript:window.open('printFullProfile.htm?entityId=<%=request.getParameter("parentId")%>&currentKOLName=<%=request.getParameter("currentKOLName")%>')">
                <a class="text-blue-link" href="#" > <img src='images/print_profile.gif' border=0 height="32" title="Printer friendly format"/><br>Profile</a>

                 </td>
                 <% } %>  <td width="8">&nbsp;</td>   
	<td width="39" height="30" onclick="javascript:window.open('searchInteraction.htm?action=<%=ActionKeys.DEV_PLAN_HOME%>' + '&prettyPrint=true')" align=center><a class="text-blue-link" href="#"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br>
		Print</a></td>
        <td width="4"></td>

        </td>  
      <!--  <td valign="top" align="top" width="45" onclick='toggleAlertMode()' style="cursor:hand">
					<img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">
		Notify</a></td>-->
<tr>
<td valign="top" align="right"  height="30" width="67" style="cursor:hand">&nbsp;</td>
                 <td valign="top" align="right" width="8" style="cursor:hand"
                     >
					&nbsp;</td>
     <td valign="middle" align="right" width="5">&nbsp;</td>
     <td width="8" height="30" onclick="window.open('related_org.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')">&nbsp;</td>
        <td width="39">&nbsp;</td>

        <td valign="top" align="top" width="4" onclick='toggleAlertMode()' style="cursor:hand">
					&nbsp;</td>
</tr>
		</table><%}%></td>

  </tr>
</table>
</form>
</div>
</body>
</html>

<%
   session.removeAttribute("SEL_DEV_PLAN");
   session.removeAttribute("SEL_DEV_PLAN_ID");
   session.removeAttribute("MODE");
   session.removeAttribute("DEV_PLANS_HISTORY_LIST");
   session.removeAttribute("MESSAGE");


%>