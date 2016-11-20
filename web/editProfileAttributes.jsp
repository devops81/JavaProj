<%@ page import="com.openq.eav.metadata.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.openq.eav.data.EavAttribute" %>
<%@ page import="com.openq.eav.data.BooleanAttribute" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
<%@ page import="com.openq.eav.EavConstants" %>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%long profile_id = (Long.parseLong((String)session.getAttribute("profile_id")));  %>
<% String Orgmessage=(String)session.getAttribute("Message1")==null?"":(String)session.getAttribute("Message1"); 
String TLStatusAttr = (String) request.getAttribute("TLStatusAttr");
String SOIAttr = (String) request.getAttribute("SOIAttr");
String TLStatusAttrId = (String) request.getAttribute("TLStatusAttrId");
String SOIAttrId = (String) request.getAttribute("SOIAttrId");
String subTabAttributeIdString = (String) request.getAttribute("subTabAttributeIdString");
String region = (String) request.getAttribute("regionOfTL");
long subTabAttributeId = -1;
if(subTabAttributeIdString != null && !"".equals(subTabAttributeIdString)){
	subTabAttributeId = Long.parseLong(subTabAttributeIdString);
}
Map selectionCriteriaMap = (Map) request.getAttribute("selectionCriteriaMap");
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
  if (cal.dateClicked && (cal.sel.id !== ""))
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

<title>openQ 2.0 - openQ Technologies Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="css/openq.css" rel="stylesheet" type="text/css">
<script src="js/trim.js"></script>
<script language="javascript">
	function show_calendar(sName) {
		gsDateFieldName = sName;
	    // pass in field name dynamically
	    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
	
	    if (document.layers) // NN4 param
	    	winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
	    window.open("Popup/PickerWindow.html", "_new_picker", winParam);
	}
	
	function toggleCheckValue(checkField) {
		if (checkField.value == "true") {
			checkField.value = "false";
		} else {
			checkField.value = "true";
		}
	}

	function showHideButtons() {
		if (!parent.editDeleteForm && parent.editDeleteForm.editButton!=null)
		{
			return;
		}
		parent.editDeleteForm.deleteRow.style.display = 'none';
		parent.editDeleteForm.addRow.style.display = 'none';
		//parent.editDeleteForm.editButton.value = 'Save';
        parent.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/save.gif)';
        parent.editDeleteForm.editButton.style.height='22'
		parent.editDeleteForm.editButton.style.width='73'
		parent.editDeleteForm.editButton.disabled = false;
	}

	function addSelectedOrg(val) {
		var temp = new Array();
		temp = val.split(';');
		
		if (document.editProfileAttributesForm.attr_17)
		{
			document.editProfileAttributesForm.attr_17.value = "<a target='_top' href='institutions.htm?entityId=" + temp[1] + "'>" + temp[2] + "</a>";
		}
		if (document.editProfileAttributesForm.attr_18)
		{
			document.editProfileAttributesForm.attr_18.value = temp[3];
		}
	}
	
	function checkRequiredFields() {
	var mandatoryFields = new Array();
	var textFields=new Array();
	<%
		AttributeType [] attributes = (AttributeType []) request.getSession().getAttribute("attributesToAdd");
		HashMap optionMap = (HashMap) request.getSession().getAttribute("optionMap");
		HashMap valueMap = (HashMap) request.getSession().getAttribute("valueMap");
		int mandatoryCount = 0;
		int textFieldsCount=0;
		for (int i=0; ((attributes != null) && (i < attributes.length)); i++) {
			boolean mandatory = attributes[i].isMandatory();
			if(attributes[i].getType()==1){   //This is for String type text attribute
	%>
	           textFields[<%=textFieldsCount%>]=document.editProfileAttributesForm.attr_<%=attributes[i].getAttribute_id()%>;
	<%
	           textFieldsCount++;
			
			}
		if (mandatory) {
	%>
		mandatoryFields[<%=mandatoryCount%>] = document.editProfileAttributesForm.attr_<%=attributes[i].getAttribute_id()%>;
	<%	
		mandatoryCount++;
			} 
		}
	%>
			
		for (var i=0; i<mandatoryFields.length; i++) {
			if (mandatoryFields[i].value == null || trimAll(mandatoryFields[i].value) == '') {
				alert("Please enter all required fields before saving.");
				mandatoryFields[i].focus();
				return false;
			}
		}
		for(var j=0;j<textFields.length;j++){
		   if(trimAll(textFields[j].value)=='' && textFields[j].value.length>0){
		      alert("Please enter a valid text in the field");
		      textFields[i].focus();
		      return false;
		  } 
		}   
		
		return true;
	}
	
function calculateNewValues(){
	var thisform = document.editProfileAttributesForm;
    var dropdowns = document.getElementsByTagName('select');
    var nationalCount = 0;
    var totalCount = 0;
	var internationalCount =0;  
	var SOIAttr = thisform.attr_<%=SOIAttrId%>;
    var TLStatusAttr = thisform.attr_<%=TLStatusAttrId%>;
    
    for(var i=0;i<dropdowns.length; i++){
    var selectedId = dropdowns[i].options[dropdowns[i].selectedIndex].id;
    var selectedValue = dropdowns[i].options[dropdowns[i].selectedIndex].value;
    	if (!(dropdowns[i].name =='attr_<%=SOIAttrId%>' || dropdowns[i].name == 'attr_<%=TLStatusAttrId%>')){ 
			if('<%=region%>' == '<%=Constants.TL_REGION_INTERCON%>'){
				 if(selectedValue !='No'){
     				if(selectedValue == 'International'){   
            			internationalCount = internationalCount + 1;
        			}else if(selectedValue == 'National'){   
            				nationalCount = nationalCount + 1;
        			}		
        			totalCount = totalCount + 1;
    			}		
    
   	 		}else if(selectedValue == 'Yes'){
        		if(selectedId == 'National'){
            		nationalCount = nationalCount + 1;
        		}
        		totalCount = totalCount + 1;
    		
			}
		
		}
	}
	if('<%=region%>' == '<%=Constants.TL_REGION_INTERCON%>'){
		if(internationalCount >=4){
			SOIAttr.value = 'International';
		}else if((internationalCount + nationalCount) >=3){
			SOIAttr.value = 'National';
		}else if((internationalCount + nationalCount) ==2 && totalCount >=4){
			SOIAttr.value = 'National';
		}else if(totalCount >=3){
			SOIAttr.value = 'Local';
		}else {
			SOIAttr.value = 'N/A';
		} 
	
	
	
	}else {
	

    if(nationalCount >= 4){
    	SOIAttr.value = 'National';
    }else if(totalCount >= 4){
    	SOIAttr.value = 'Regional A';
    }else if(totalCount == 3){
    	SOIAttr.value = 'Regional B';
    }else{
    	SOIAttr.value = 'N/A';
    }

    if(totalCount >= 3){
        TLStatusAttr.value = '<%=Constants.TL_TYPE_TL%>';
    }else{
        TLStatusAttr.value = '<%=Constants.TL_TYPE_HCP%>';
    }
	
	
	
	}
	
}
<%--
	
function calculateNewValues(dropdown){
    var thisform = document.editProfileAttributesForm;
    var nationalCountObj = thisform.nationalCount;
    var totalCountObj = thisform.totalCount;
    
    var nationalCount = parseInt(nationalCountObj.value);
    var totalCount = parseInt(totalCountObj.value);
    var selectedId = dropdown.options[dropdown.selectedIndex].id;
    var selectedValue = dropdown.options[dropdown.selectedIndex].value;

    if(selectedValue == 'Yes'){
        if(selectedId == 'National'){
            nationalCountObj.value = nationalCount + 1;
        }
        totalCountObj.value = totalCount + 1;
    }else{
        if(selectedId == 'National' && nationalCount > 0){
            nationalCountObj.value = nationalCount - 1;
        }
        if(totalCount > 0){
            totalCountObj.value = totalCount - 1;
        }
    }
    setNewValues();
}

function setNewValues(){
	var thisform = document.editProfileAttributesForm;
    var nationalCountObj = thisform.nationalCount;
    var totalCountObj = thisform.totalCount;
    var SOIAttr = thisform.attr_<%=SOIAttrId%>;

    if(nationalCountObj.value >= 4){
    	SOIAttr.value = 'National';
    }else if(totalCountObj.value >= 4){
    	SOIAttr.value = 'Regional A';
    }else if(totalCountObj.value == 3){
    	SOIAttr.value = 'Regional B';
    }else{
    	SOIAttr.value = 'N/A';
    }
    var TLStatusAttr = thisform.attr_<%=TLStatusAttrId%>;
    if(totalCountObj.value >= 3){
        TLStatusAttr.value = '<%=Constants.TL_TYPE_TL%>';
    }else{
        TLStatusAttr.value = '<%=Constants.TL_TYPE_HCP%>';
    }
 }
 --%>
</script>
</head>
<font family="verdana" color="red" size="2"><b><%=Orgmessage%></b></font>
<body onLoad="javascript:showHideButtons()">
<form name="editProfileAttributesForm" method="POST" enctype="multipart/form-data">
<input type="hidden" name="attributeId" value='<c:out escapeXml="false" value="${attributeId}"/>' />
<input type="hidden" name="entityId" value='<c:out escapeXml="false" value="${entityId}"/>' />
<input type="hidden" name="parentId" value='<c:out escapeXml="false" value="${parentId}"/>' />
<input type="hidden" name="entityAttr" value='<c:out escapeXml="false" value="${entityAttr}"/>' />
<input type="hidden" name="action" value="save"/>
<input type="hidden" name="nationalCount" value="0"/>
<input type="hidden" name="totalCount" value="0"/>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	   <tr>
	   <td height="20" class="text-blue-01-bold">&nbsp;</td>
	   </tr>
       <tr>
           <td height="20" align="left" valign="top" >
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		       
		       <%OptionLookup userType = (OptionLookup) session.getAttribute(Constants.USER_TYPE);
               long userTypeId = (userType != null ? userType.getId() : -1);
               long nationalCount = 0;
               long totalCount = 0;
		       for (int i=0; ((attributes != null) && (i < attributes.length)); i+=3) {
		       %>
		       <tr>
		       <%
		       for (int k=0; k<3; k++) {
		      	String label = (i + k < attributes.length) ?  attributes[i+k].getName() : "" ;
		       	boolean mandatory = (i + k < attributes.length) ?  attributes[i+k].isMandatory() : false ;

		       %>
		           <td height="20" class="text-blue-01-bold">&nbsp;</td>
		           <td class="text-blue-01-bold">
					<p><%=label%><%=mandatory ? "*" : ""%></td>
		       <%}%>
		       </tr>
		       <tr>
		       	<%             
		       	for (int k=0; k<3; k++) {
		       		String val = (i + k < attributes.length && valueMap.get(attributes[i+k]) != null) ?  valueMap.get(attributes[i+k]) + "": "" ;
		       		
					String size = (i + k < attributes.length) ?  attributes[i+k].getAttributeSize(): "" ;
		       		long type = (i + k < attributes.length) ?  attributes[i+k].getType(): -1 ;
		       		long attrId = (i + k < attributes.length) ?  attributes[i+k].getAttribute_id(): -1 ;
					if (type > 0) {
		       		if (type == EavConstants.DATE_ID || (type == EavConstants.STRING_ID && size != null && !size.equals("Large")) ) { // textbox
		             	              
		              if(val.length()!=0 && val.charAt(0)=='<'){
		                 String[] tempString=val.split(">");
		                 if(tempString.length>0){
		                 	tempString=tempString[1].split("<");
		                 	val=tempString[0];
		                 }
		              }
		            
		       	%>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td valign=top>
			        	<input  class="field-blue-01-180x20" name="attr_<%=attrId%>" id="attr_<%=attrId%>" value="<%=val%>"  <%=(type == EavConstants.DATE_ID) ? "readonly" : ""%>/><%if (type == EavConstants.DATE_ID) {%><a href="#" onclick="return showCalendar('attr_<%=attrId%>', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="middle" ></a><%}%>
			           </td>
		           <% } else if (type == EavConstants.STRING_ID && size != null && size.equals("Large")) { 
		               // text area%>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td valign=top>
			        	<textarea class="field-blue-07-180x50"  name="attr_<%=attrId%>" cols="20" rows="4" wrap="VIRTUAL" class="field-blue-07-180x50" ><%=val%></textarea>
			           </td>
		           <% } else if (type == EavConstants.BOOLEAN_ID) { // bool%>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td>
			        	<input name="_attr_<%=attrId%>" onclick="javascript:toggleCheckValue(document.editProfileAttributesForm.attr_<%=attrId%>)" type="checkbox" <%=(!val.equals("") ? "checked" : "")%> <%=((attrId == 107 && request.getSession().getAttribute("preferredContactExists") != null)? "disabled" : "")%>/>
			        	<input name="attr_<%=attrId%>" type="hidden" value='<%=!val.equals("") ? "true" : "false"%>'/>
			           </td>
		           <% } else if (type == EavConstants.BINARY_ID) { // bool%>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td valign=top>
			        	<input name="attr_<%=attrId%>" class="button-02" type="file"/>
			           </td>
		           <% } else if (type == EavConstants.DROPDOWN_ID) { // dropdown
                       String disabled = "";
		               String onChange = "";
		               String quesType = "";
		        	   if(subTabAttributeId == Constants.SELECTION_CRITERIA_ATTRIBUTEID){
	                       String attributeName = (i + k < attributes.length) ?  attributes[i+k].getName(): "" ;
	                       if((attributeName.equals(TLStatusAttr) || attributeName.equals(SOIAttr)) &&
	                               userTypeId != Constants.FRONT_END_ADMIN_USER_TYPE){
	                           disabled = "disabled";  
	                       }
	                       quesType = (selectionCriteriaMap.get(attributeName) != null ? selectionCriteriaMap.get(attributeName)+"" : "" );
	                       if("Yes".equalsIgnoreCase(val)){
	                    	   if("National".equalsIgnoreCase(quesType)){
	                    		    nationalCount++;
	                    	   }
                               totalCount++;
	                         }
	                       if(userTypeId != Constants.FRONT_END_ADMIN_USER_TYPE){
	                    	    onChange = "onchange = 'calculateNewValues()'";
	                       }
		        	   }
		           %>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td valign=top>
			        	<select name="attr_<%=attrId%>" class="field-blue-01-180x20" <%=disabled %> <%=onChange %>>
			        	<% 
			        		OptionLookup [] lookups = (OptionLookup []) optionMap.get(attributes[i+k]);
			        		for (int x=0; lookups != null && x < lookups.length; x++) {
								String selected = "";
								if(lookups[x].isDefaultSelected() && "".equals(val.trim()))
									selected="selected";
								if (lookups[x].getOptValue() != null && !"".equals(val.trim()) &&  lookups[x].getOptValue().trim().equalsIgnoreCase(val.trim())) {
									selected = "selected";
								}
								if ("".equals(val.trim()) && attrId >= 41 && attrId <= 43 &&	lookups[x].getOptValue().equals("unknown")) {
									selected = "selected";
								}
								if (!(attrId == 109 && !selected.equals("selected") && lookups[x].getOptValue() != null && lookups[x].getOptValue().equals("Primary") && request.getSession().getAttribute("primaryAddressExists") != null)) {
			        	%>
							<option id="<%=quesType %>" value="<%=lookups[x].getOptValue()%>" <%=selected%>><%=lookups[x].getOptValue()%></option>		
						<% } } 
						if (attrId >= 216 && attrId <= 220) {
						%>
							<option value="__NULL__" <%=(val.trim().equals("") ? "selected" : "")%>>None</option>
						<%}
						%>
						</select>
			           </td>
		           <% } else if (type == EavConstants.MULTI_SELECT_ID) {  // multi-select%>
			           <td height="20" class="text-blue-01">&nbsp;</td>
			           <td>
			        	<select name="attr_<%=attrId%>" multiple class="field-blue-13-260x100">
							<option value="-1">Please Select</option>
		        		</select>
			           </td>
		           <% } %>
		         <% } else { %>
		           <td height="20" class="text-blue-01">&nbsp;</td>
		           <td>
		        	&nbsp;
		           </td>
		         <% } %>
		        <%}%>
		        </tr>
		        <tr>
		            <td height="10" colspan="6"><img src="images/transparent.gif" width="10" height="10"></td>
		        </tr>
		        <% } // end for%>
				<c:if test="${attributeId == profile_id}">
				<tr>
					<td height="20" class="text-blue-01">&nbsp;</td>
					<td class="text-blue-01" colspan=5 align=left><input name="orgSearch01" class="button-01" type="button" value="Select Organization" onclick="javascript:window.open('profile_org_search.jsp','searchOrg','width=720,height=450,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no')"></td>
				</tr>
				</c:if>
			</table>
		</td>
	</tr></table>
<script>
document.editProfileAttributesForm.nationalCount.value = '<%=nationalCount%>';
document.editProfileAttributesForm.totalCount.value = '<%=totalCount%>';
</script>
</form>
</body>