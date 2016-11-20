<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.openq.interaction.InteractionSearchView" %>
<%@ page import="com.openq.user.User,java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="header.jsp" %>

<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript" src="./js/scriptaculous/lib/prototype.js"></script>
<script type="text/javascript" src="./js/fastinit.js"></script>
<script type="text/javascript" src="./js/tablesort.js"></script>
<script type="text/javascript" src="./js/sorttable.js"></script>
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
    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

    <script language="Javascript">
       function addAttendee(username, phone, email, staffid, userId) {
        document.interactionForm.userName.value = username;
        document.interactionForm.staffId.value=staffid;
        document.interactionForm.userId.value=userId;
   }
        function editInteraction(interactionId, mode) {
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.EDIT_INTERACTION%>";
			// pass data through hidden variables
			thisform.interactionId.value = interactionId;
			thisform.mode.value = mode;
            thisform.submit();
        }

        function showAddInteraction() {
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.SHOW_ADD_INTERACTION%>";
            thisform.submit();
        }
        function searchInteractions() {
            var thisform = document.interactionForm;

            if (thisform.fromDate.value != "" && thisform.toDate.value == "" ){
                alert("Please enter To Date");
                return false;
            }   

            if (thisform.fromDate.value == "" && thisform.toDate.value != "") {
                alert("Please enter From Date");
                return false;
            }

            if (thisform.fromDate.value != "" && thisform.toDate.value != "") {
                
                if (!compareDate(new Date(thisform.fromDate.value), new Date(thisform.toDate.value))) {
                    alert("From date should be lesser than or equal to To date");
                    return false;
                }
            }
						
			
			if(thisform.kolName.value == ""  ){
				alert('Please enter an <%=DBUtil.getInstance().doctor%>/Org name');
				return false;
			}
            thisform.action = '<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.SEARCH_INTERACTION%>';
            thisform.kolName.value = checkAndReplaceApostrophe(thisform.kolName.value);
            thisform.submit();
        }

        function compareDate(date, date1) {

            if (date1.getYear()>date.getYear()) {
                return true;
            } else if (date1.getYear()==date.getYear()) {
                if (date1.getMonth()>date.getMonth())
                    return true;
                else if (date1.getMonth()==date.getMonth()) {
                    if(date1.getDate()>date.getDate() || date1.getDate()==date.getDate())
                        return true;
                    else
                        return false;
                } else 
                    return false;
            } else
                return false;
        }

        function show_calendar(sName) {

            gsDateFieldName = sName;
            // pass in field name dynamically

            var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";

            if (document.layers) // NN4 param

                winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";

            var win = window.open("Popup/PickerWindow.html", "_new_picker", winParam);
            if (win != ""){
                win.focus();
            }

        }
        
        function deleteInteraction(interactionId) {
            var thisform = document.interactionForm;
            if (confirm("Are you sure that you want to delete this Interaction ? Please press \"OK\" to proceed or \"Cancel\" to recede ")){
             thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.DELETE_INTERACTION%>&interactionId="+interactionId+"&from=main";
             thisform.submit();
            }
        }
        function resetInteractions(){
            var thisform = document.interactionForm;
            thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm";
            thisform.submit();

        }
        function resetUser(){
            var thisform = document.interactionForm;
            thisform.userName.value=''; 
            thisform.staffId.value = '0'; 
            thisform.userId.value = '0';
        }
        function alertMsgOtsuka(){
            alert("This feature has been disabled.");
        }
        
    </script>
</HEAD>

<%
	long currentUserTypeId = -1;
	if (request.getSession().getAttribute(Constants.USER_TYPE) != null) {
	    currentUserTypeId = ((OptionLookup) request.getSession().getAttribute(
				Constants.USER_TYPE)).getId();
	}
	List interactionSearchResultsList = (List) session.getAttribute("INTERACTION_SEARCH_RESULT");
	Map interactionSearchParameters =  (Map) session.getAttribute("INTERACTION_SEARCH_PARAMETER_MAP"); 
	
	String fromDate = "";
	String toDate = "";
	String kolName = "";
	String userName = "";
	String currentStaffId = "0";
	String currentUserId = "0";
	String selectedProductIdString = "0";
	long selectedProductId = 0;
	
	if( interactionSearchParameters != null ){
	    if ( interactionSearchParameters.get("fromDate") != null) {
	        fromDate = (String) interactionSearchParameters.get("fromDate");
	    }
	    if ( interactionSearchParameters.get("toDate") != null) {
	        toDate = (String) interactionSearchParameters.get("toDate");
	    }
	    if ( interactionSearchParameters.get("kolName") != null) {
	        kolName = (String) interactionSearchParameters.get("kolName");
	    }
	    if ( interactionSearchParameters.get("userName") != null) {
	        userName = (String) interactionSearchParameters.get("userName");
	    }
	    if( interactionSearchParameters.get("searchStaffId") != null){
	        currentStaffId = (String) interactionSearchParameters.get("searchStaffId");
	    }
	    if( interactionSearchParameters.get("searchUserId") != null){
	        currentUserId = (String) interactionSearchParameters.get("searchUserId");
	    }
	    if( interactionSearchParameters.get("productSelectedId") != null){
	        selectedProductIdString = (String) interactionSearchParameters.get("productSelectedId");
	    }
	    if( selectedProductIdString != null ){
	        selectedProductId = Long.parseLong(selectedProductIdString);
	    }
	}
	OptionLookup productsLookup[] = null;
	if (session.getAttribute("PRODUCTS") != null) {
		productsLookup = (OptionLookup[]) session
				.getAttribute("PRODUCTS");
	}
	boolean isAlreadySelected = false;
%>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">

<form name="interactionForm" method="POST" AUTOCOMPLETE="OFF">
<input type="hidden" name="interactionId" value="" />
<input type="hidden" name="mode" value="" />
<div id="searchInteraction" class="producttext">
     <div class="myexpertlist">
          <div class="myexpertlist">
                <table width="100%" height="18">
                    <tbody>
                        <tr style="color: rgb(76, 115, 152);">
	                        <td width="50%" align="left">
                                <div class="myexperttext">Search Interaction</div>
                            </td>
                    </tbody>
                </table>
            </div>
     </div>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
	     <tr>
	         <td width="1%" height="20" valign="top">&nbsp;</td>
	         <td width="13%" valign="middle" class="text-blue-01-bold">Product</td>
	         <td width="6%" valign="middle">&nbsp;</td>
	         <td width="5%" valign="middle">&nbsp;</td>
	         <td width="13%" valign="middle"></td>
	         <td valign="middle" width="62%">&nbsp;</td>
	     </tr>
         <tr>
             <td width="1%" height="20" valign="top">&nbsp;</td>
             <td width="13%" valign="middle" class="text-blue-01-bold">
              <select id="productLOV" name="productLOV" class="field-blue-01-180x20">
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
	  	        	
                  	if (!isSAXAJVUser && !isOTSUKAJVUser) {
                  %>
                   <option id="-1" value="-1" selected>Please select a value</option>
                   <%
                   	}
                   	if (productsLookup != null && productsLookup.length > 0) {
                   		OptionLookup lookup = null;
                   		isAlreadySelected = false;
                   		for (int i = 0; i < productsLookup.length; i++) {
                   			lookup = productsLookup[i];
                   			String selected = "";
                   			if(selectedProductId == lookup.getId()){
                   				isAlreadySelected = true;
                   				selected = "selected";
                   			} else if (!isAlreadySelected && lookup.isDefaultSelected()){
                   				selected = "selected";
                   			}
                   %>
                    <script>
                        var optionvalue = document.createElement("option");
                        optionvalue.setAttribute("id", "<%=lookup.getId()%>");
                        optionvalue.setAttribute("value", "<%=lookup.getId()%>");
                        optionvalue.setAttribute("title", "<%=lookup.getOptValue()%>");
                        optionvalue.appendChild(document.createTextNode("<%=lookup.getOptValue()%>"));
                        optionvalue.selected = "<%=selected%>";
                        var productLOV = document.getElementById("productLOV");
                        productLOV.appendChild(optionvalue);
                    </script>
                   <%
                   	}
                   	}
                   %>
                </select>
            </td>                 
             <td width="6%" valign="middle">&nbsp;</td>
             <td width="5%" valign="middle">&nbsp;</td>
             <td width="13%" valign="middle"></td>
             <td valign="middle" width="62%">&nbsp;</td>
         </tr>
         <tr>
              <td width="1%" height="20" valign="top">&nbsp;</td>
              <td width="13%" valign="middle" class="text-blue-01-bold">Date From </td>
              <td width="6%" valign="middle" class="text-blue-01">&nbsp;</td>
              <td width="5%" valign="middle" class="text-blue-01">&nbsp;</td>
              <td width="13%" valign="middle" class="text-blue-01-bold">Date To </td>
              <td valign="middle" class="text-blue-01" width="62%">&nbsp;</td>
          </tr>
          <tr>
              <td height="20" valign="top">&nbsp;</td>
              <td valign="top"><input type="text" name="fromDate" readonly="true" class="field-blue-01-180x20" name="eventDate" id="sel1" value="<%=fromDate%>"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></td>
              <td valign="top"><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></td>
              <td valign="top">&nbsp;</td>
              <td valign="top"><input name="toDate" type="text" id="sel2" class="field-blue-01-180x20" maxlength="50" readonly value="<%=toDate%>"><a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"></td>
              <td valign="top" width="62%"><a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></a></td>
          </tr>
          <tr>
              <td height="10" colspan="6" valign="top"></td>
          </tr>
          <tr>
              <td height="20" valign="top">&nbsp;</td>
              <td class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%> / Org</td>
              <td class="text-blue-01">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
             <!--  <td class="text-blue-01-bold">User</td>
              <td class="text-blue-01" width="62%">&nbsp;</td>
              -->
          </tr>
          <tr>
              <td height="20" valign="top">&nbsp;</td> <!-- (request.getAttribute("go")!=null && request.getAttribute("go").equals("true"))?request.getAttribute("kol_name"):-->
              <td valign="top"><input name="kolName" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=kolName.replaceAll("''", "'")%>"></td>
              <td valign="top">&nbsp;</td>
              <td valign="top">&nbsp;</td>
              <!--  
              <td valign="top">
  				
              	<input name="userName" type="text" class="field-blue-01-180x20" maxlength="50" readonly value="<%=userName.replaceAll("''", "'")%>" onclick="resetUser();">
              	<input type="hidden" name="staffId" value="<%=currentStaffId%>" />
                <input type="hidden" name="userId" value="<%=currentUserId%>" />
              </td>
              
              <td valign="top" width="62%"> 
              <% if(!(isOTSUKAJVUser || isSAXAJVUser)) { %>   
              	<a href="#" onClick="javascript:window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes')" class="text-blue-01-link">Lookup User</a>
              <% } %>	
              </td>
              -->
            </tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
            <tr>
            	<td width="1%" height="20">&nbsp;</td>
                <td width="16%" class="text-blue-01">
                    <input type="button" style="border:0;background : url(images/buttons/search_interaction.gif);width:144px; height:22px;" class="button-01" onClick="javascript:searchInteractions();"/>
                 </td>
                <td class="text-blue-01" valign="top">
                	<input type="button" style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;" class="button-01" onClick="javascript:resetInteractions();" />
                </td>
            </tr>
		</table>
</div>
<%
	if (request.getAttribute("go") != null
			&& request.getAttribute("go").equals("true")) {
%>
            <div id="viewInteraction" style="display:none" class="producttext">
              <div class="myexpertlist">
                <table width="100%">
                    <tbody>
                        <tr style="color: rgb(76, 115, 152);">
                            <td width="50%" align="left">
                                <div class="myexperttext">Edit/View Interaction</div>
                            </td>
                    </tbody>
                </table>
              </div>
            </div>
            <iframe id="expertInteraction" frameborder='0' height="350px"width="100%" scrolling="auto" src="searchInteraction.htm?action=<%=ActionKeys.PROFILE_INTERACTION%>&kolId=<%=request.getAttribute("kol_id")%>"></iframe>
<%
	} else {
%>
<div class="producttext">
	<div class="myexpertlist">
	      <table width="100%" height="18">
	          <tbody>
	              <tr style="color: rgb(76, 115, 152);">
	                  <td width="2%" ><img src="images/searchpic.jpg"/></td>
	                  <td width="98%" align="left">
	                      <div class="interactionsearchresults">Search Interaction Result&nbsp;&nbsp;&nbsp;
	                           <font face ="verdana" size ="2" color="red">
	                              <b><%=(interactionSearchResultsList != null ? interactionSearchResultsList.get(0) : "")%></b>
	                          </font>
	                      </div>
	                  </td>
	          </tbody>
	      </table>
	</div>
    <div style="height:270px; overflow:auto;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" color="#faf9f2" class="sortable">
            <tr>
                <td width="1%" height="20" valign="top"></td>
                <td width="3%" valign="middle" class="expertListHeader">&nbsp;</td>
                <td width="1%"></td>                                    
                <td width="4%" valign="middle">&nbsp;</td>
                <td width="1%"></td>                              
                <td width="10%" valign="middle" class="expertListHeader">User</td>
                <td width="1%"></td>
                <td width="11%" valign="middle" class="expertListHeader">Attendee Count</td>
                <td width="2%"></td>
                <td width="20%" valign="middle" class="expertListHeader"><%=DBUtil.getInstance().doctor%> / Org</td>
                <td width="1%"></td>
                <td width="15%" valign="middle" class="expertListHeader">Topic</td>
                <td width="1%"></td>
                <td width="20%" valign="middle" class="expertListHeader sortfirstdesc">Product(s)</td>
                <td width="1%"></td>
                <td width="10%" valign="middle" class="expertListHeader sortfirstdesc">Date</td>
                <td width="1%"></td>
            </tr>
        	<%if (null != interactionSearchResultsList ) {
        	    List interactionSearchResults = ( List ) interactionSearchResultsList.get(1);
   					for (int i = 0; i < interactionSearchResults.size(); i++) {
   					    InteractionSearchView interactionSearchResult = ( InteractionSearchView ) interactionSearchResults.get(i);
        	%>
                <tr bgcolor='<%=(i % 2 == 0 ? "#fcfcf8"
													: "#faf9f2")%>'>
                    <td width="1%" height="20" valign="top"></td>
                    <td width="3%" valign="top">
                    <%
                    	if ((Long.parseLong((String) request.getSession()
                    							.getAttribute(Constants.USER_ID)) == interactionSearchResult.getUserId())
                    							|| currentUserTypeId == Constants.FRONT_END_ADMIN_USER_TYPE) {
                    %>                      
                        <a href="javascript:editInteraction(<%=interactionSearchResult.getInteractionId()%>, 'edit')" class="text-blue-01-link">Edit</a>
                    <%
                    	} else {
                    %>
                        <a href="javascript:editInteraction(<%=interactionSearchResult.getInteractionId()%>, 'view')" class="text-blue-01-link">View</a>
                    <%
                    	}
                    %>
                    </td>
                    <td width="1%"></td> 
                    <td width="4%" valign="top">
                    <%
                    	if ((Long.parseLong((String) request.getSession()
                    							.getAttribute(Constants.USER_ID)) == interactionSearchResult
                    							.getUserId())
                    							|| currentUserTypeId == Constants.FRONT_END_ADMIN_USER_TYPE) {
                    %>                                      
                        <a href="javascript:deleteInteraction(<%=interactionSearchResult.getInteractionId()%>)" class="text-blue-01-link">Delete</a>
                    <%
                    	}
                    %>
                    </td>
                    <td width="1%"></td> 
                    <td width="10%" valign="middle"
                        class="text-blue-01" ><%=interactionSearchResult.getUserName() != null ? 
                                interactionSearchResult.getUserName() : ""%></td>
                    <td width="1%"></td>
                    <td width="11%" valign="middle" class="text-blue-01">
                    	<%
                    		long totalAttendeeCount = interactionSearchResult
                    								.getAttendeeCount()
                    								+ interactionSearchResult
                    										.getOtherAttendeeCount();
                    	%>
                    	<%=totalAttendeeCount%>
                    </td>
                    <td width="2%"></td>
                    <td width="20%" valign="middle" class="text-blue-01" ><%=interactionSearchResult
													.getAttendeeList() != null ? interactionSearchResult
											.getAttendeeList()
											: ""%></td>
                    <td width="1%"></td>
                    <td width="15%" valign="middle"
                        class="text-blue-01" ><%=interactionSearchResult
													.getFirstInteractionTopic() != null ? interactionSearchResult
											.getFirstInteractionTopic()
											: ""%></td>
                    <td width="1%"></td>
                    <td width="20%" valign="middle" class="text-blue-01">
                    	<%=interactionSearchResult
											.getProductList()%>
                    </td>
                    <td width="1%"></td>
                    <td width="19%" valign="middle" class="text-blue-01" >
                    <%
                    	SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                    %> 
                    <%=sdf.format(interactionSearchResult.getInteractionDate())%>
                    </td>
                    <td width="1%"></td>
                </tr>
                <%
                	}
                			}
                %>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
	            <tr>
	                <td class="text-blue-01">
						<input class="button-01" style="BORDER-RIGHT: 0px; BORDER-TOP: 0px; BACKGROUND: url(images/buttons/add_interaction.gif); BORDER-LEFT: 0px; WIDTH: 120px; BORDER-BOTTOM: 0px; HEIGHT: 23px" onclick="javascript:showAddInteraction()" type="button" value="" name="Submit33" target="self" >
					</td>
	            </tr>
			</table>
		</div>
</div>
<%
	}
%>
</form>
</body>
<script type="text/javascript">
<%if (request.getAttribute("kol_name") != null) {%>
  document.interactionForm.kolName.value='<%=request.getAttribute("kol_name")%>';
<%}%>
</script>
<%@ include file="footer.jsp" %>
</html>
