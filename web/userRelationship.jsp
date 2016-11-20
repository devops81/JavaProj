<jsp:directive.page import="javax.management.relation.RelationType"/>

<%@ include file = "header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ page import="com.openq.attendee.Attendee"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.*"%>
<%@ page import="com.openq.interactionData.InteractionData,com.openq.interaction.Interaction"%>
<%@ page import="com.openq.interactionData.UserRelationship" %>
<%@ page import="java.util.*"%>
<%@ page import="com.openq.user.HomeUserView"%>
<%@ page import="com.openq.eav.org.Organization"%>


<%
    
    OptionLookup reportPrivilegeLookUp[] = null;//CORRESPONDS TO THE RELATIONSHIP_TYPE
    if (session.getAttribute("REPORT_PRIVILEGE_TYPE") != null) {
        reportPrivilegeLookUp = (OptionLookup[]) session.getAttribute("REPORT_PRIVILEGE_TYPE");
    }
    
    OptionLookup territories[] = (OptionLookup[])session.getAttribute("Territories");
    
    OptionLookup territory = (OptionLookup)session.getAttribute("Territory");
    
    UserRelationship userRelationship = (UserRelationship)session.getAttribute("userRelationship");
    User user = (User)session.getAttribute("User");
   
    User Supervisor = (User) session.getAttribute("Supervisor");
    Interaction interaction = null;
    if (session.getAttribute("INTERACTION_DETAILS") != null) {
        interaction = (Interaction) session.getAttribute("INTERACTION_DETAILS");
    }
    
    
 String message = (String) request.getSession().getAttribute("MESSAGE");
     
    
 UserRelationship[] userrelation = null;
    if (session.getAttribute("USER_RELATION") != null) {
        userrelation= (UserRelationship[]) request.getSession().getAttribute("USER_RELATION");
    }
    
 String uname= "";
    if (session.getAttribute("USERNAME") != null) {
        uname = (String) session.getAttribute("USERNAME");
    }
    
 String mode = "";
    if (session.getAttribute("MODE") != null) {
        mode = (String) session.getAttribute("MODE");
    }
   else
    {
     session.removeAttribute("INTERACTION_SEARCH_RESULT");
     session.removeAttribute("USER_OBJECT");
    }
    
    
    
    String staffIdToPersist="";
  		if(session.getAttribute("REDISPLAY_STAFFID") != null)
  		{
  		staffIdToPersist =(String)session.getAttribute("REDISPLAY_STAFFID");
  		}
    
      String filterParam = null != session.getAttribute("FILTER_PARAM_USERRELATIONSHIP")
      										? (String)session.getAttribute("FILTER_PARAM_USERRELATIONSHIP") : null;
%>
 
<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<div id="dhtmltooltip"></div>
<!--[if lte IE 6]>
<iframe id="shim" src="" style="position:absolute;display:none;filter:progid:DXImageTransform.Microsoft.Chroma(Color='#ffffff');" scrolling="no" frameborder="0"></iframe>
<![endif]-->
<script src="./js/validation.js"></script>
<script type="text/javascript">
 
 var temp = 0;
//Calendar Widget
 // This function gets called when the end-user clicks on some date.
function selected(cal, date) {
  cal.sel.value = date; // just update the date in the input field.
  if (cal.dateClicked && (cal.sel.id == "beginDateId" || cal.sel.id == "endDateId"))
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
  _dynarch_popupCalendar.showAtElement(el, "Br");        // show the calendar
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
 

    
var checkValueInAddAttendee = 0;    
 function addAttendee(username, phone, email, staffid,id){
              if(checkValueInAddAttendee == 1){
                 document.useralignment.staffid.value=staffid;
             	 document.useralignment.username.value=username;
                }
              if(checkValueInAddAttendee == 2){ 
            	 document.getElementById('hiddenUserId').value=staffid;
	             document.getElementById('userTextId').value=username;
                }
              if(checkValueInAddAttendee == 3){ 
	            document.getElementById('hiddenSupervisorId').value=staffid;
    	        document.getElementById('supervisorTextId').value=username;
                }
              if(checkValueInAddAttendee == 4){ 
            	document.getElementById('hiddenTerritoryId').value=staffid;
	            document.getElementById('territoryTextId').value=username;
                }
          }

function callForUserSearch(checkValue){
	window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
	checkValueInAddAttendee = parseInt(checkValue);
   }

function submitPage(sid){	
	if(document.useralignment.username.value=="")
	{
	alert('Choose the user');
	}
	else{
	document.useralignment.staffid.value=checkAndReplaceApostrophe(document.useralignment.staffid.value);
	document.useralignment.action="userRelationship.htm?action=relateduser&staffid=" +sid+"&name="+document.useralignment.username.value;
	document.useralignment.submit();
	}
}

function resetPage()
{
document.useralignment.action="userRelationship.htm?action=resetPage";
document.useralignment.submit();
}

	
function setValue()
{
document.getElementById('hiddenReportPrivilegeId').value = document.getElementById('reportPrivilegeType').value;
}	

function setTerritoryValue(){
document.getElementById('hiddenTerritoryId').value = document.getElementById('territoryType').value;
}


function savePage()
     {	
	    if( document.getElementById('hiddenSupervisorId').value==""||
	    document.getElementById('reportPrivilegeType').value== "0" ||
	    document.getElementById('hiddenUserId').value==""||
	    document.getElementById('beginDateId').value==""||
	    document.getElementById('endDateId').value==""||
	    document.getElementById('supervisorTextId').value==""){
	     alert('Enter All fields');
     	}
	else{
	  document.useralignment.action="userRelationship.htm?action=saveuser&begin="+document.getElementById('beginDateId').value+"&end="+document.getElementById('endDateId').value+'&hiddenSupervisorId='+document.getElementById('hiddenSupervisorId').value+'&hiddenUserId='+document.getElementById('hiddenUserId').value+'&hiddenTerritoryId='+document.getElementById('hiddenTerritoryId').value
	  +'&hiddenReportPrivilegeId='+document.getElementById('hiddenReportPrivilegeId').value+'&oldhiddenSupervisorId='+document.getElementById('oldhiddenSupervisorId').value+'&oldhiddenUserId='+document.getElementById('oldhiddenUserId').value+'&oldhiddenTerritoryId='+document.getElementById('oldhiddenTerritoryId').value+'&oldhiddenReportPrivilegeId='+document.getElementById('oldhiddenReportPrivilegeId').value
	  +'&userIdValue='+document.getElementById('userIdValue').value+"&name="+document.getElementById('username').value;;
	  document.useralignment.submit();
	  }
	}
	
function addPage()
      {	
	    if( document.getElementById('hiddenSupervisorId').value==""||
	    document.getElementById('reportPrivilegeType').value== "0" ||
	    document.getElementById('hiddenUserId').value==""||
	    document.getElementById('beginDateId').value==""||
	    document.getElementById('endDateId').value==""||
	    document.getElementById('supervisorTextId').value==""){
	     alert('Enter All fields');
     	}
	else{
	  document.useralignment.action="userRelationship.htm?action=addUser&begin="+document.getElementById('beginDateId').value+"&end="+document.getElementById('endDateId').value+'&hiddenSupervisorId='+document.getElementById('hiddenSupervisorId').value+'&hiddenUserId='+document.getElementById('hiddenUserId').value+'&hiddenTerritoryId='+document.getElementById('hiddenTerritoryId').value+'&hiddenReportPrivilegeId='+document.getElementById('hiddenReportPrivilegeId').value;	   
	  document.useralignment.submit();
	  }
	}

	
	
	
	function displayUserEdit(tdRow)
	{	
		var x = document.getElementById('userDetailsTableId').rows[tdRow].cells;
		
		document.getElementById('hiddenUserId').value= x[0].firstChild.value;
		document.getElementById('oldhiddenUserId').value= x[0].firstChild.value;
		document.getElementById('hiddenSupervisorId').value= x[1].firstChild.value;
    	document.getElementById('oldhiddenSupervisorId').value= x[1].firstChild.value;
		//document.getElementById('territoryTextId').value= x[3].innerHTML;
	    document.getElementById('userTextId').value = x[3].innerHTML;
	  
	   	var reportPriviligeValue = x[4].innerHTML;
	   	var reportPriviligeList = document.getElementById("reportPrivilegeType");
	   	
	   	if(reportPriviligeValue  != NaN && reportPriviligeValue!="")
		{
		  reportPriviligeValue  =parseInt(reportPriviligeValue);
	    	for(var i=0;i<reportPriviligeList.length;i++)
		    {
		    	var optionText = reportPriviligeList.options[i].text;
		    	if(optionText == reportPriviligeValue)
	    		{
	    			reportPriviligeList.options[i].selected= true;
	    			document.getElementById('hiddenReportPrivilegeId').value = document.getElementById('reportPrivilegeType').value;
	    			document.getElementById('oldhiddenReportPrivilegeId').value = document.getElementById('reportPrivilegeType').value;
			    }
		    }
		 } 
		 else
		 {
		 		reportPriviligeList.options[0].selected= true;
		 }
		 
		  var territoryValue = x[2].innerHTML;
		  var territoryList = document.getElementById("territoryType");
		  
		  
		  
		  if(territoryValue != NaN && territoryValue !="")
		  {
		          
		  	 for(var i=0;i<territoryList.length;i++)
		    {
		        
		    	var optionText = territoryList.options[i].text;
		    	
		    	if(optionText+' ' == territoryValue)
	    		{
	    		   //alert(optionText);
	    			territoryList.options[i].selected= true;
	    			document.getElementById('hiddenTerritoryId').value = document.getElementById('territoryType').value;
	    			//document.getElementById('oldhiddenReportPrivilegeId').value = document.getElementById('reportPrivilegeType').value;
			    }
		    }
		 } 
		 else
		 {
		 		territoryList.options[0].selected= true;
		 }
		
		  
		 document.getElementById('supervisorTextId').value = x[5].innerHTML;
	     document.getElementById('beginDateId').value = x[6].innerHTML;
	     document.getElementById('endDateId').value = x[7].innerHTML;
	     document.getElementById('oldendDateId').value = x[7].innerHTML;
	     document.getElementById('userIdValue').value = x[8].firstChild.value;	    
         document.getElementById('olduserIdValue').value = x[8].firstChild.value;	    		
	     document.getElementById('addButtonId').disabled = true;
	     document.getElementById('saveButtonId').disabled = false;
	}
	
	function setButtonsOnLoad(){

	 /*  var filterButtonRadio = document.useralignment.filterRadio;
	    var length = filterButtonRadio.length;
		for(var i = 0; i < length; i++) {
			if('<%=filterParam%>' != null && filterButtonRadio[i].value == '<%=filterParam%>') {
					filterButtonRadio[i].checked='true';
				}
			else if(filterButtonRadio[i].value == 'Current Only') {
				filterButtonRadio[i].checked='true';
			}
		}*/
	 }
    </script>

<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" onLoad="setButtonsOnLoad()" >
<form name="useralignment" method="post" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="producttext">
<tr align="left" valign="top">
	<td width="10" class="colContent">&nbsp;</td>
    <td class="colContent">
    	<div style="height:415px; ">
        	<table width="96%" border="0" cellspacing="0" cellpadding="0" class="colContent">
            	<tr>
                	<td width="96%" align="center" valign="top" >
                    	    <tr align="left" valign="middle">
                        	    <td class="colTitle">Report Privileges </td>
	                        </tr>    
    	            </td>
        	     </tr>
	          </table>          
              <table width="96%"  border="0" cellspacing="0" cellpadding="0" class="colContent">
				 <tr>
                   	<td width="30" height="50">&nbsp;</td>
                    <td width="80" class="text-blue-01">User Name</td>
                    <td width="20">&nbsp;</td>
                    <td width="40" class="text-blue-01"><input name="username" type="text" value="<%if(uname != null){%><%=uname%><%}%>"  disabled %> </td>
                    <td width="40">&nbsp;</td>
        	        <td class="text-blue-01"  width="10%">
		      	      <input name="Submit332" type="button" class="button-01" value=" Select" onClick="callForUserSearch(1)">
                    </td>                                 
                    <td class="text-blue-01"><input name="Submit332" type="button" class="button-01" value=" RelatedUser" onClick= "submitPage(staffid.value)"></td>
                    <td class="text-blue-01"><input name="Submit332" type="button" class="button-01" value=" Reset " onClick= "resetPage()"></td>
                    <td width="40" class="text-blue-01"><input name="staffid" type="hidden"  value="<%=staffIdToPersist%>"  disabled ></td>
                </tr>
             <!--      <tr>
                 	<td width="30" height="50">&nbsp;</td>
                    <td width="150" class="text-blue-01">Filter User Relationship</td>
                    <td width="20">&nbsp;</td>
                    <td width="100" class="text-blue-01">
                    	<input id ="filterRadio" name ="filterRadio" type="radio" value="Current Only" />Current Only
                    </td>
                   	<td width="40" class="text-blue-01"><input id ="filterRadio" name ="filterRadio" type="radio" value="All"/>All</td>
                    <td class="text-blue-01"  width="10%"></td>
                    <td class="text-blue-01"></td>
           			<td class="text-blue-01"></td>
           			<td width="40" class="text-blue-01"></td>
           	  	</tr>-->
             </table>  
			<table>
				<tr>
					<td width="100%" height="100%" class="text-blue-01">&nbsp;</td>
				</tr>
			</table>
		    <table  width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >        
		    	 <tr>
		     		<td> &nbsp;</td>
			       	<td class="colContent">
			            <table width="96%"  border="0" cellspacing="0" cellpadding="0">
    	    				<tr>
			        	    	  <td class="text-blue-01"><table width="100%" border="0" cellspacing="0" cellpadding="2">
				                	 <tr>
								         <td width="60%" align="left" valign="top" class="colContent">
									         <table align="left" width="100%"  border="0" cellspacing="0" cellpadding="0" class="colTitle">
									         	 <tr align="left" valign="middle">
							                       	   <td width="1%" height="25" align="center">&nbsp;</td>
									  	               <td width="1%" height="25" align="center">&nbsp;</td>
									 	               <td width="15%" class="colTitle" align="left">  Territory </td>
									                   <td width="21%" class="colTitle" align ="left"> User</td>
									                   <td width="18%" class="colTitle" align= "left"> Report Privileges </td>
									                   <td width="16%" class="colTitle" align= "left"> Supervisor </td>
									                   <td width="13%" class="colTitle" align= "left"> Begin Date </td>
									                   <td width="23%" class="colTitle" align="left"> End Date </td>
									                   <td width="10%" class="colTitle" align= "left">&nbsp;</td>
									                   <td width="10%" valign="middle"  class="text-blue-01-bold">&nbsp;</td>
									                </tr>
							                </table>
										</td>
									</tr>
					<tr>
			         <td width="60%" align="left" valign="top" class="colContent">                 
			         	<div style="height:150px;">
		                  <table align="left" width="100%"  id="userDetailsTableId" border="0" cellspacing="0" cellpadding="0" class="colContent" >		                             
			                      
                   				<%if(userRelationship!=null ){ 
                   				  SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");%>
									<tr align="left" valign="middle" >		
											<td width="1%" height="25" class="text-blue-01" >
							       	           <input type="hidden" value="<%=user!=null?user.getStaffid():""%>"/>
						       	           </td>	
						       	           	<td width="1%" class="text-blue-01"  >
						 	                   	<input type="hidden" value="<%=Supervisor!=null?Supervisor.getStaffid():""%>"> 
						 	               </td>			
					       	               <td width="15%" class="text-blue-01" align="left"  onclick="displayUserEdit(0)"> 
					       	                    <%=territory!=null?territory.getOptValue():""%>                 
								           </td> 
						                   <td width="21%" class="text-blue-01" align ="left" onclick="displayUserEdit(0)">    
			       					   			<%=user!=null?user.getLastName()+", "+user.getFirstName():""%>
						                   </td>
				    		        	   <td width="18%" class="text-blue-01" align= "left" onclick="displayUserEdit(0)">
							       	             <%=userRelationship.getReportLevel()!=null?userRelationship.getReportLevel():""%> 
				    		        	   </td>
				            		       <td width="16%" class="text-blue-01" align= "left" onclick="displayUserEdit(0)"> 
	            	            		          <%=Supervisor!=null?Supervisor.getLastName()+", "+Supervisor.getFirstName():""%>
			            		           </td>
						                   <td width="13%" class="text-blue-01" align= "left" onclick="displayUserEdit(0)">
	    		    	            		     <%=(userRelationship.getBeginDate() != null ? sdf.format(userRelationship.getBeginDate()) : "")%>   					                  
						                   </td>
						                   <td width="23%" class="text-blue-01" align= "left" onclick="displayUserEdit(0)">  
    			        	        		      <%=(userRelationship.getEndDate() != null ? sdf.format(userRelationship.getEndDate()):"")%>   					                  
					                       </td>
						                    <td width="10%" class="text-blue-01" align="left"  onclick="displayUserEdit(0)" >
						                      <input type="hidden"  value="<%=userRelationship.getId() %>"/> 
						                   </td> 
						                   
				    	                
	    	  	                  </tr>
				                
				                 
								<%} else {if(session.getAttribute("firstTime")!=null){%>
								<!--  <tr>
	                				  <td colspan=7 align="center" valign="middle" class="text-blue-01" width="100%"><font face ="verdana" size ="2" color="red"><b>No result found</b></font></td>
			                    </tr>-->
	           		        <%}}%>
			               </table>
	                  </div>
                 </td>
   			</tr> 		
   	 
</table>
</td>
 </tr>
</table>
	
<table>
	<tr>
		<td width="100%"  height="100%" class="text-blue-01">&nbsp;</td>
	</tr>
</table>
	
<table width="96%" border="0" cellspacing="0" cellpadding="0" class="colContent">
	<tr>
		<td height="20" align="left" valign="top">  	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="colTitle">
		        <tr align="left" valign="middle">
       		        <td class="colTitle"> User Details </td>
               	    <td class="text-white-bold" align="right" valign="middle"></td>
                   	<td width="50" height="20" >&nbsp;</td>
		         </tr>                         
		   </table>
	   </td>
   </tr>
</table>
    
	
<table   width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" >      
	<tr>
	   <td align="left" valign="top" >
			<table width="96%" height="30%" border="0" cellspacing="0" cellpadding="0" class="colContent">
				<tr>
				  <td width="10%" class="text-blue-01"> Territory </td>
				  <td>
				  <select name="territoryType" id="territoryType" class="field-blue-01-180x20" onchange="setTerritoryValue()" >
							                    <option value="0" >Select a Privilege</option>
							                    <%
							                      
							                        if (territories != null && territories.length > 0) {
							                             for (int i = 0; i < territories.length; i++) {
							                             String selected = "";
							                                if(territory!=null && territory.getId() == territories[i].getId()){
							                          			//selected = "selected";
							                          			
							                          			}
							                    %>
							                    <option value="<%=territories[i].getOptValue()%>" <%=selected %>><%=territories[i].getOptValue()%></option>
							                    <%
							                            }
							                        }
							
							                    %>
		     </select>
		     </td>
		          <td width="18%"> &nbsp;</td>
		          <td width="20" class="text-blue-01"><br></td>
		          <td width="20" class="text-blue-01"> User</td>
		          <td>&nbsp;<input type="text" class="text-blue-01" id="userTextId" readonly="readonly" name="userTextId" size="30"></td>
		          <td class="text-blue-01"><input name="Submit332" type="button" class="button-01" value="User Search" onClick="callForUserSearch(2)"></td>                                 			         
	            </tr>
		        <tr>  
	          	  <td width="30" class="text-blue-01">Report Privileges</td>
	          	  <td>
		          	  <select  name="reportPrivilegeType"  id="reportPrivilegeType" class="field-blue-01-180x20" onchange="setValue()">
			          	  <option value="0" >Select a Privilege</option>
						       <%
	            			   if (reportPrivilegeLookUp != null && reportPrivilegeLookUp.length > 0) {
					                 OptionLookup lookup = null;
		    	       			     for (int i = 0; i < reportPrivilegeLookUp.length; i++) {
					                    lookup = reportPrivilegeLookUp[i];
                                 		String selected = "" ;
                                  		if(lookup.isDefaultSelected())
                                  			selected = "selected";
		           		       %>
			 	           <option  value="<%=lookup.getId()%>" <%=selected%>><%=lookup.getOptValue()%></option>
	                            <%
	        				         }
					              }
				                %>
				        </select>
				</td>	      
				<td class="text-blue-01">&nbsp;</td>
				 <td>&nbsp;</td>   	  
	        	 <td width="20" class="text-blue-01">Supervisor</td>
        	      <td><input type="text" class="text-blue-01" name="supervisorTextId" readonly id="supervisorTextId" size=30></td>
	    	      <td>&nbsp;<input type="button" name="Submit332" class="button-01" value="User Search" onclick="callForUserSearch(3)"></td>
    	          <td class="text-blue-01"><br></td>                                 
		     </tr>
	 	     <tr>
		       <td width="30"  class="text-blue-01">Begin Date</td>
		       <td width="15%">
    		        <input  name="beginDateId" id="beginDateId" type="text"  size=30 class="text-blue-01" readonly
 	      				  <%
		 					if (interaction != null && interaction.getInteractionDate() != null) {
					 		java.util.Date interactionDate = interaction.getInteractionDate();
							SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
	    				  %>
						    value="<%=sdf.format(interactionDate)%>"
						 <% } %>
						 <%  if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
					 <a href="#" onclick="return showCalendar('beginDateId', '%m/%d/%Y', '24', true);">
             </td>
   		     <td>
  				<% if (!"view".equalsIgnoreCase(mode)) { %>
          			<a href="#" onclick="return showCalendar('beginDateId', '%m/%d/%Y', '24', true);">
          			<img src="images/buttons/calendar_24.png" width="22" height="22" border="0" style=""></a>
  				<% } %>
   	 		</td>     
   	 		<td>&nbsp;</td>   
    	 		<td width="20" class="text-blue-01">End Date</td>			            
		    <td width="15%">
		        <input type="text" name="endDateId"  id="endDateId" size=30 class="text-blue-01" readonly
   				  <%
 					if (interaction != null && interaction.getInteractionDate() != null) {
				 		java.util.Date interactionDate = interaction.getInteractionDate();
							SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
				  %>
				    value="<%=sdf.format(interactionDate)%>"
				 <% } %>
				 <%  if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
					 <a href="#" onclick="return showCalendar('endDateId', '%m/%d/%Y', '24', true);">
             </td>
   			<td width="20%">&nbsp;<table width="96%" height="20%" cellspacing="0" cellpadding="0" border="0" class="colContent"><tr><td> 
   				<% if (!"view".equalsIgnoreCase(mode)) { %> 
	       			<a href="#" onclick="return showCalendar('endDateId', '%m/%d/%Y', '24', true);"> 
	      			<img width="22" height="22" border="0" src="images/buttons/calendar_24.png"></a> 
   				<% } %> 
	 		</td></tr></table></td>
   		     <td><br></td>        			                              
	    </tr>
       	<tr>
		     <td width="20" class="text-blue-01">&nbsp;</td>
	   	</tr> 
</table>
<table class="colContent" width="96%" border="0" cellspacing="0" cellpadding="0">
       <tr>
	        <td width="2%"><input type="button" name="save" value=" SAVE " id="saveButtonId" class="button-01" onClick="savePage()" disabled></td>
	        <td width="2%">&nbsp;</td>
	        <td width="2%"><input type="button" name="add" id="addButtonId" value=" ADD " class="button-01" onClick="addPage()"></td>
	        <td width="50%"></td>
	   </tr>
</table>
  
<table>
     <tr>			
	        <td><input class="back-white" width="6%" type="hidden" value="0" name="userIdValue" id="userIdValue"></td>		        
	        <td><input class="back-white" width="5%" name="hiddenUserId" id="hiddenUserId" type="hidden"  disabled > </td>                                
            <td><input class="back-white" width="5%" name="hiddenSupervisorId" id="hiddenSupervisorId" type="hidden"  disabled ></td>                                                    
            <td><input class="back-white" width="5%" name="hiddenTerritoryId" id="hiddenTerritoryId" type="hidden"  disabled ></td>                                                    
		    <td><input class="back-white" width="5%" name="hiddenReportPrivilegeId" id="hiddenReportPrivilegeId" type="hidden"  disabled ></td>                                                    
     </tr>
</table>
 
<table border="0">
	<tr>
			<td><input width="6%" type="hidden" value="0" name="olduserIdValue" id="olduserIdValue"></td>		        
            <td><input width="5%" name="oldhiddenUserId" id="oldhiddenUserId" type="hidden"  disabled > </td>                                
            <td><input width="5%" name="oldhiddenSupervisorId" id="oldhiddenSupervisorId" type="hidden"  disabled ></td>                                                    
	        <td><input width="5%" name="oldhiddenTerritoryId" id="oldhiddenTerritoryId" type="hidden"  disabled ></td>                                                    
	        <td><input width="5%" name="oldhiddenReportPrivilegeId" id="oldhiddenReportPrivilegeId" type="hidden" value="0" disabled ></td>                                                    
	        <td><input width="5%" name="oldendDateId" id="oldendDateId" type="hidden" disabled></td>
 	</tr>
</table>		
		
 
</td>
</tr>
</table>
<%@ include file="footer.jsp" %>
