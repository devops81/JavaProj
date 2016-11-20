<jsp:directive.page import="com.openq.web.controllers.Constants"/><html>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ include file="imports.jsp"%>
<%@page import = "java.util.ArrayList"%>
<%@ page import="com.openq.utils.PropertyReader"%>

<%@page import = "java.util.TreeMap"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.kol.*"%>


<head>

<%
	String frontEndAdmin = PropertyReader.getEavConstantValueFor("FRONT_END_ADMIN");
	ArrayList segmentTacticList = new ArrayList();
	ArrayList tacticList = new ArrayList();

	if(session.getAttribute("SEGMENT_TACTICS") != null)
		segmentTacticList = (ArrayList) session.getAttribute("SEGMENT_TACTICS");

	if(session.getAttribute("KOL_TACTICS") != null)
		tacticList = (ArrayList) session.getAttribute("KOL_TACTICS");

	TacticDTO tacticDTO = null;

	String message = "";
	if(session.getAttribute("MESSAGE") != null)
		message = (String) session.getAttribute("MESSAGE");

	int appliedTacticId = 0;
	if(session.getAttribute("APPLIED_TACTIC") != null) 
		appliedTacticId  = Integer.parseInt((String) session.getAttribute("APPLIED_TACTIC"));

    
	String segmentId = "";
	if(session.getAttribute("segmentId") != null) {
	   segmentId = ((Integer)session.getAttribute("segmentId")).toString();
	}

	TreeMap hirarchyMap = new TreeMap();
	if(session.getAttribute("HIERARCHY_MAP") != null) {
		hirarchyMap = (TreeMap) session.getAttribute("HIERARCHY_MAP");
	}

	String rootNode = "";
	if (session.getAttribute("rootnode")!=null) {
		rootNode = (String)session.getAttribute("rootnode");	
	}
	ArrayList latestCriteriaList = null;
	if(session.getAttribute("LATEST_CRITERIA_LIST") != null) {
		latestCriteriaList = (ArrayList) session.getAttribute("LATEST_CRITERIA_LIST");
	}

 	OptionLookup statusLookUp[] = null;
    if (session.getAttribute("STRATEGY_STATUS_LIST") != null) {
        statusLookUp = (OptionLookup[]) session.getAttribute("STRATEGY_STATUS_LIST");
    }

	String taName = null;
	if (session.getAttribute("TA_NAME") != null) {
		taName = (String) session.getAttribute("TA_NAME");
	}    
	
	String faName = null;
	if (session.getAttribute("FA_NAME") != null) {
		faName = (String) session.getAttribute("FA_NAME");
	} 
   OptionLookup roleLookup[] = null;
   if (session.getAttribute("SEGMENT_ROLE") != null) {
		roleLookup = (OptionLookup[]) session.getAttribute("SEGMENT_ROLE");
	}
   boolean isAlreadySelected = false;
%>


<title>openQ 2.0 - openQ Technologies Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
<%
	ArrayList segmentCriteriaList = new ArrayList(); 
	if (session.getAttribute("SEGMENT_CRITERIA") != null) { 
		segmentCriteriaList	 = (ArrayList)session.getAttribute("SEGMENT_CRITERIA"); 
	}
	
	if(session.getAttribute("MESSAGE") != null)
	{
		message = (String) session.getAttribute("MESSAGE");
	}
    int userType = 0;
        if (session.getAttribute("USER_TYPE") != null) {
            userType = Integer.parseInt((String)session.getAttribute("USER_TYPE"));
        }

%>
<script language="JavaScript" type="text/JavaScript">

function show_calendar(sName) {   
    gsDateFieldName = sName;
    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
    if (document.layers)
        winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
    var win = window.open("Popup/PickerWindow.html", "_new_picker", winParam);
    if(win != "")
      win.focus();
}

function addMatchingExpert() {
 	var thisform = document.kolsetsegments;
	thisform.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.KOL_ADD_MATCHING_EXPERT%>";
	thisform.target = "_self";
	thisform.submit();	
}
function deleteExpert()
{
	var thisform = document.kolsetsegments;
	var flag =false;
	for(var i=0;i<thisform.elements.length;i++){
		
		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].name=="checkExpertIds" && thisform.elements[i].checked){
			flag =true;
			break;
		}
	}	
	if(flag){
	
		if(confirm("Are you sure to delete the <%=DBUtil.getInstance().doctor%>s from segment")){
			thisform.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.KOL_DELETE_EXPERT%>";
			thisform.target = "_self";
			thisform.submit();
		}
	}else {
		alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
	}
}

function addExpert()
{
	document.kolsetsegments.action = "<%=CONTEXTPATH%>/searchKol.htm?action=<%=ActionKeys.EXPERT_SEARCH%>&fromKOLStrategy=true";
	document.kolsetsegments.target = "_parent";
	document.kolsetsegments.submit();	
}

<%--function gotoExpertMap()
{
	document.kolsetsegments.action = "<%=CONTEXTPATH%>/map.do?action=<%=ActionKeys.EXPERT_MAP%>&fromPage=KolStrategy&toTGFromPage=KolStrategy";
	document.kolsetsegments.target = "_parent";
 	document.kolsetsegments.submit();
}--%>

function saveStrategy()
{
	document.kolsetsegments.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.KOL_SAVE_STRATEGY%>";
	document.kolsetsegments.target = "_self";
 	document.kolsetsegments.submit();
}

function addCriteria() {

  // Get the dynamic table object
  var oTable = document.getElementById('CriteriaTable');   
  var len = oTable.rows.length;
  var oRow = oTable.insertRow();  
    
  // Insert <td>s
  var oCell = oRow.insertCell();
  oCell.width = "1%";
  oCell.height = "20";
  oCell.innerHTML = "&nbsp;";      

  if(len % 2 >0){
	oRow.className="back-grey-02-light";
  }
  oCell = oRow.insertCell();

  //blank column
  oCell.width = "20";
  oCell.innerHTML = "<img src=\"<%=COMMONIMAGES%>/icon_my_expert.gif\" width=\"14\" height=\"14\">";
  oCell = oRow.insertCell();    
 
  //Segment Criteria Attribute Name List box.
  oCell.width = "40%";
  oCell.className = "text-blue-01-link";  
  oCell.innerHTML = "<select name=\"attributename\" class=\"field-blue-01-200x20\"><% if (segmentCriteriaList != null && segmentCriteriaList.size() > 0) { for(int i=0; i < segmentCriteriaList.size(); i++) { SegmentCriteriaDTO segmentCriteriaDTO = (SegmentCriteriaDTO)segmentCriteriaList.get(i);  %> <option value=\"<%=segmentCriteriaDTO.getAttributeId()%>+<%=segmentCriteriaDTO.getAttributeDataType()%>\"><%=segmentCriteriaDTO.getAttributeName()%></option> <% }  } %> <option value=\"PUBLICATIONSINDEX\">Publications Index</option><option value=\"JOURNALINDEX\">Journal Index</option><option value=\"CITATIONINDEX\">Citation Index</option><option value=\"ACTIVITYINDEX\">Activity Index</option></select>";
  oCell = oRow.insertCell();
 
  //Segment Criteria Attribute Type List box.
  oCell.width = "20%";
  oCell.className = "text-blue-01";
  oCell.innerHTML = "<select name=\"attributetype\" class=\"field-blue-01-50x20\"> <option value=\"1\"> = </option> <option value=\"2\"> > </option> <option value=\"3\"> < </option> </select></td>";
  oCell = oRow.insertCell();
 
  //Segment Criteria Attribute Value Text Box.
  oCell.width = "35%";
  oCell.className = "text-blue-01";
  oCell.innerHTML = "<input name=\"attributevalue\" type=\"text\" class=\"field-blue-03-130x20\" maxLength=\"50\" value=\"\">";
  oCell = oRow.insertCell();
}

//// dynamic segment activity loading..

 var allSegmentTactics= new Array();
 var allTactics = new Array();

 var segmentTacticId;
 var activityId;
 var activityName;
 var role;
 var dueDate;

function tacticObject(tacticId, tacticName, tacticRole, tacticDueDate) {
	this.activityId = tacticId;
	this.activityName = tacticName;
    this.role = tacticRole;
    this.dueDate = tacticDueDate;
}

function segmentTacticObject(segmentTacticId, activityId,activityName,role,dueDate)
{	
	  this.segmentTacticId=segmentTacticId;
	  this.activityId=activityId;
	  this.activityName=activityName;
	  this.role=role;
	  this.dueDate=dueDate;	  
}


<%
	
	if ( null != segmentTacticList && segmentTacticList.size() >0 ){
	StringBuffer tacticName = null;
	for(int i=0; i < segmentTacticList.size(); ++i) { 
		
		TacticDTO tempSegmentTacticDTO = (TacticDTO) segmentTacticList.get(i);
		if (null != tempSegmentTacticDTO.getTacticName() && tempSegmentTacticDTO.getTacticName().indexOf("'") != -1 ){
		  tacticName = new StringBuffer(tempSegmentTacticDTO.getTacticName());
		  tacticName.replace(tempSegmentTacticDTO.getTacticName().indexOf("'"),tempSegmentTacticDTO.getTacticName().indexOf("'")+1,"") ;
		}
%>
		allSegmentTactics[<%=i%>] = new segmentTacticObject('<%=tempSegmentTacticDTO.getSegmentTacticId()%>','<%=tempSegmentTacticDTO.getTacticId()%>', '<%=tacticName != null ? tacticName.toString() : ""%>', '<%=tempSegmentTacticDTO.getRoleName() != null ? tempSegmentTacticDTO.getRoleName() : "" %>','<%=tempSegmentTacticDTO.getTacticDueDate() != null ? tempSegmentTacticDTO.getTacticDueDate() : ""%>');
<%	}
}
%>


<% 
	if(tacticList != null && tacticList.size() > 0) { 
		for(int i=0; i<tacticList.size(); ++i) { 
			tacticDTO = (TacticDTO) tacticList.get(i); 
%>
   <% StringBuffer tName = null;
    if (null != tacticDTO.getTacticName() && tacticDTO.getTacticName().indexOf("'") != -1 ){
        tName = new StringBuffer(tacticDTO.getTacticName());
        tName.replace(tacticDTO.getTacticName().indexOf("'"),tacticDTO.getTacticName().indexOf("'")+1,"") ;}
    %>

    allTactics[<%=i%>] = new tacticObject('<%=tacticDTO.getTacticId()%>',
		'<%=null != tName  ? tName.toString() : "" %>',  '<%=tacticDTO.getRoleName() != null ? tacticDTO.getRoleName() : "" %>' ,'<%=tacticDTO.getTacticDueDate() != null ? tacticDTO.getTacticDueDate() : ""%>');
<%
		}
	}
%>


function init(hirarName,rootNode) {

	document.getElementById('addBlock').style.display="block";
	document.getElementById('saveBlock').style.display="none";
    document.getElementById('segmentTacticTableHeader').style.display = "none";
    document.getElementById('normalHeader').style.display = "block";
    window.parent.showHirarchyView(hirarName,rootNode);
}


function setTacticDueDate(obj, row) {
    var id = row;
	var element = document.getElementById("tacticDueDate" + "_" + row);
	for (var k=0;k<allTactics.length;k++) {
		if(obj.value == allTactics[k].activityId) {
			element.value = allTactics[k].dueDate;
		}
	}

}
function setNewTacticDueDate(obj) {

	var element = document.getElementById("newtacticDueDate");
	
	for (var k=0;k<allTactics.length;k++) {
		if(obj.value == allTactics[k].activityId) {
			element.value = allTactics[k].dueDate;
		}
	}
}


function selectTacticOption() {

	var element;
    var element1;
    var attId = "tacticList";
    var tacRole = "tacticRole";

    if (null != allSegmentTactics && allSegmentTactics.length >0){
		for (var k=0;k<allSegmentTactics.length;k++) {

			element = document.getElementById( attId + "_" + k);
			element1 = document.getElementById( tacRole + "_" + k);

            if(element != null && element != undefined) {
				for(var i=0; i<element.options.length; ++i) {
					if(element.options[i].value == allSegmentTactics[k].activityId) {
						element.options[i].selected = true;
                        break;
					}
				}
			}
            if(element1 != null && element1 != undefined) {
                <%
                if(roleLookup != null && roleLookup.length > 0) {
                    OptionLookup lookup = null;
                    for(int i=0;i<roleLookup.length;i++) {
                        lookup = roleLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
                %>
                var lookupVal = '<%=lookup.getOptValue()%>';
                var lookupId = '<%=lookup.getId()%>';
                for(var j=0; j<element1.options.length; ++j) {
                    if(allSegmentTactics[k].role == lookupVal) {
                        if(element1.options[j].value == lookupId) {
                            element1.options[j].selected = true;
                            break;
                        }
                    }
                }
                <%

                    }

                }
                %>
			}
        }
  }
}

function createTactics() {

// Get the dynamic table object


  var oTable = document.getElementById('segmentTacticTable');   
  var len = oTable.rows.length;

  document.getElementById("tacticApplied").innerHTML = "";

  // Delete all existing rows in the dynamic table
  for (var curr_row = 0; curr_row < len; curr_row++)
  {
    oTable.deleteRow(oTable.rows[curr_row]);
  } 
 
  var counter=0;
  var cellValue = "";
  var fieldName = "";

  // Create rows in the dynamic table
  for (var k=0;k<allSegmentTactics.length;k++) {

   // If this Tactic object is null, then don't do anything, 
   // else create rows (<tr>s) in the table with appropriate values for the columns(<td>s)

     var oRow = oTable.insertRow();  
  
    
	// To alternate the background of rows to gray & white colors
     if (counter%2>0) {
	     oRow.className = "back-grey-02-light";
     } 


     // Insert <td>s
     var oCell = oRow.insertCell();
	 fieldName = "activityId" ;
	 oCell.width = "2%";     
     oCell.height = "25";
	 cellValue = allSegmentTactics[k].segmentTacticId != null ? allSegmentTactics[k].segmentTacticId : "";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;<input type=\"hidden\" name=\""  + fieldName + "\"  value=\"0\">&nbsp;<input type=\"hidden\" name=\"segmentTacticIds\"  value=\"" + cellValue + "\">";       


     // Activity drop down 
	 oCell = oRow.insertCell();
	 fieldName = "tacticList";
	 oCell.width = "10%";
     oCell.className = "text-blue-01";	 
     oCell.innerHTML = "&nbsp;&nbsp;<select id=\"" + fieldName + "_" + k + "\" name=\""  + fieldName + "\" class=\"field-blue-01-200x20\" ><% if(tacticList != null && tacticList.size() > 0) { for(int i=0; i<tacticList.size(); ++i) { tacticDTO = (TacticDTO) tacticList.get(i); 	%> <option value=\"<%=tacticDTO.getTacticId()%>\"><%=tacticDTO.getTacticName()%></option> <% } 	} %>  </select>";

	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "2%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

	 // Role column
	 oCell = oRow.insertCell();
	 oCell.width = "10%";
	 fieldName = "tacticRole" ;
	 oCell.className = "text-blue-01";
	 cellValue = allSegmentTactics[k].role != null ? allSegmentTactics[k].role : "";
     //oCell.innerHTML = "<input id=\"" + fieldName + "_" + k + "\" name=\""  + fieldName + "\" type=\"text\" class=\"field-blue-05-70x20\" value=\"" + cellValue + "\">";
     oCell.innerHTML = "&nbsp;&nbsp;<select id=\"" + fieldName + "_" + k + "\" name=\""  + fieldName + "\" class=\"field-blue-16-150x20\"><% if (roleLookup != null && roleLookup.length > 0){ OptionLookup lookup = null; String val = ""; for (int i = 0; i < roleLookup.length; i++) { lookup = roleLookup[i]; val =  String.valueOf(lookup.getId()); %> <option value=\"<%=lookup.getId()%>\" <% if ( (tacticDTO != null) && (tacticDTO.getRole() != null) && (tacticDTO.getRole().equals(val)) )  { %> SELECTED <% } %>> <%=lookup.getOptValue()%></option><% } } %> </select>";

	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "2%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

 	 // DueDate column
	 oCell = oRow.insertCell();
	 oCell.width = "10%";
	 fieldName = "tacticDueDate";
	 oCell.className = "text-blue-01";
     var currentDate = new Date();
     cellValue = allSegmentTactics[k].dueDate != null && allSegmentTactics[k].dueDate != ""? allSegmentTactics[k].dueDate : "";
     oCell.innerHTML = 
     
     "<input type=\"text\" readonly=\"true\" class=\"field-blue-01-180x20\" name=\""  + fieldName + "\" id=\"" + fieldName + "_" + k + "\"><a href=\"#\" onclick=\"return showCalendar(\'" + fieldName + "_" + k + "\', '%m/%d/%Y', '24', true);\"><img src=\"images/buttons/calendar_24.png\" width=\"22\" height=\"22\" border=\"0\" align=\"top\" > </a>";

     // "<input id=sel1 name=\"sel2\" type=\"text\" class=\"field-blue-03-130x20\" readonly value=\"sanjeev\"> <a href=\"#\" onClick=\"return showCalendar('sel1', '%m/%d/%Y', '24', true);\"> <img src=\"<%=COMMONIMAGES%>/icon_calendar.gif\" width=14 height=17 border=0> </a>";
     
	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "6%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

//	 oCell = oRow.insertCell();
	 counter ++;

  }  // end of for loop

  selectTacticOption();

  // new blank row

     var oRow = oTable.insertRow();

	// To alternate the background of rows to gray & white colors
     if (counter%2>0) {
	     oRow.className = "back-grey-02-light";
     }

     // Insert <td>s
     var oCell = oRow.insertCell();
	 oCell.width = "2%";
     oCell.height = "25";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;<input type=\"hidden\" name=\"newActivityId\" value=\"0\">";

     // Activity drop down
	 oCell = oRow.insertCell();
	 oCell.width = "10%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;&nbsp;<select name=\"newTacticList\" class=\"field-blue-01-200x20\" onChange=\"setNewTacticDueDate(this);\" ><% if(tacticList != null && tacticList.size() > 0) { for(int i=0; i<tacticList.size(); ++i) { tacticDTO = (TacticDTO) tacticList.get(i); 	%> <option value=\"<%=tacticDTO.getTacticId()%>\"><%=tacticDTO.getTacticName()%></option> <% } 	} %>  </select>";

	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "3%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

	 // Role column
	 oCell = oRow.insertCell();
	 oCell.width = "10%";
	 oCell.className = "text-blue-01";
    // oCell.innerHTML = "<input name=\"newTacticRole\" type=\"text\" class=\"field-blue-05-70x20\">";
  oCell.innerHTML = "&nbsp;&nbsp;<select  name=\"newTacticRole\" class=\"field-blue-16-150x20\" ><% if (roleLookup != null && roleLookup.length > 0){ OptionLookup lookup = null; String val = ""; for (int i = 0; i < roleLookup.length; i++) { lookup = roleLookup[i]; val =  String.valueOf(lookup.getId()); %> <option value=\"<%=lookup.getId()%>\" <% if ( (tacticDTO != null) && (tacticDTO.getRole() != null) && (tacticDTO.getRole().equals(val)) )  { %> SELECTED <% } %>> <%=lookup.getOptValue()%></option><% } } %> </select>";
  	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "3%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

 	 // DueDate column
	 oCell = oRow.insertCell();
	 oCell.width = "10%";
	 oCell.className = "text-blue-01";
     oCell.innerHTML = "<input type=\"text\" readonly=\"true\" class=\"field-blue-01-180x20\" name=\"newTacticDueDate\" id=\"newTacticDueDate\"><a href=\"#\" onclick=\"return showCalendar('newTacticDueDate', '%m/%d/%Y', '24', true);\"><img src=\"images/buttons/calendar_24.png\" width=\"22\" height=\"22\" border=\"0\" align=\"top\" > </a>";

	 // blank column
	 oCell = oRow.insertCell();
	 oCell.width = "6%";
     oCell.className = "text-blue-01";
     oCell.innerHTML = "&nbsp;";

//	 oCell = oRow.insertCell();
	 setNewTacticDueDate(document.getElementById("newTacticList"));

	 document.getElementById('addBlock').style.display="none";
	 document.getElementById('saveBlock').style.display="block";
     document.getElementById('segmentTacticTableHeader').style.display = "block";
     document.getElementById('normalHeader').style.display = "none";

}

function saveSegmentTactics(formObj) {

	var flag = "true";

	var attId = "";
	var element = "";
    var currentDate = new Date();

	for (var i=0;i<allSegmentTactics.length;i++) {

		attId = "tacticRole_" + i;
		element = document.getElementById(attId);

		if (element.value == "") {
			alert("Please enter a value for the Role in the row " + (i+1));
			element.focus();
			flag = "false";
			break;
		}

        attId = "tacticDueDate_"+i;
        element = document.getElementById(attId);

		if (element.value == "") {
			alert("Please enter a value for the Due Date in the row " + (i+1));
			element.focus();
			flag = "false";
			break;
		}


	}

	if(flag == "false")
		return false;

	var newTacticDueDate = document.getElementById("newTacticDueDate");
	var newTacticRole = document.getElementById("newTacticRole");


	if(newTacticDueDate.value.length > 0 || newTacticRole.value.length > 0) {

		if (newTacticDueDate.value == "") {
			alert("Please enter a value for the Due Date");
			newTacticDueDate.focus();

			return false;
		}

        if (newTacticRole.value == "") {
			alert("Please enter a value for the Role");
			newTacticRole.focus();

			return false;
		}

	}


	if(allSegmentTactics.length == 0) {

		if(newTacticRole.value.length 	== 0) {
			alert("Please enter the values for the Segment Tactics");
			return false;
		}
	}

	formObj.action="<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.ADD_SEGMENT_TACTIC%>";
	formObj.target="_self";
	formObj.submit();

}


function cancelSegmentTactic(formObj,contextURL) {

	formObj.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.VIEW_SEGMENT_TACTIC%>";

	formObj.target="_self";
	formObj.submit();
}

function deleteSegmentTactics(segmentTacticId){


	var thisform=document.kolsetsegments;
	var flag =false;

	if(confirm("Are you sure to delete the selected Segment Tactic(s)")){
		thisform.action="<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.DELETE_SEGMENT_TACTIC%>&segmentTacticId=" + segmentTacticId;
		thisform.target="_self";
		thisform.submit();

	} else
		return false;

}


function applyTactics() {

	var thisform=document.kolsetsegments;
	var counter = 0;
	var flag =false;

	var segmentTacticId;

	for(var i=0;i<thisform.elements.length;i++){

		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].name=="appliedTacticId" && thisform.elements[i].checked){
			flag =true;
			segmentTacticId = thisform.elements[i].value;
			counter++;
		}
	}

	if(flag){
		if(counter > 1) {
			alert("Please select only one Segment Tactic to apply.");
			return false;
		}
		if(confirm("Do you want to apply the selected Segment Tactic?")){
			thisform.action="<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.APPLY_SEGMENT_TACTIC%>&segmentTacticId=" + segmentTacticId;
			thisform.submit();
		}
	}else {
		alert("Please select atleast one Segment Tactic to apply");
	}
}

function submitExpertSearch(formObj,contextURL)
{
	var keyword_value = formObj.expertKeyword.value;
	if(keyword_value.length <= 0)
	{
		alert ("Please provide valid input for searching <%=DBUtil.getInstance().doctor%>(s)");
		formObj.expertKeyword.focus();
		return false;
	}
	formObj.action = "<%=CONTEXTPATH%>/searchKol.htm?action=<%=ActionKeys.EXPERT_SEARCH%>&searchText="+formObj.expertKeyword.value+"&chkId=false&fromKOLStrategy=true";
	formObj.target="_top";
	formObj.submit();
}
function submitAdvExpertSearch(formObj,contextURL)
{
	formObj.action = "<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&fromKOLStrategy=true";
	formObj.target="_top";
	formObj.submit();
}

</script>
<link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<script type="text/javascript" src="js/newcalendar.js"></script>
</head>



<body onLoad="init(
<% String hirarName = "";
   if(segmentId != null && !segmentId.equals("") && hirarchyMap!= null) {
	  hirarName = (String)hirarchyMap.get(new Integer(segmentId));
   }
%>
'<%=hirarName%>',<%if(rootNode != null) {%>'<%=rootNode%>'<% } %>
);">

<form name="kolsetsegments" method="post" AUTOCOMPLETE="OFF">

<div class="producttext">
		<div class="myexpertlist">
			<table width="100%">
			
			
				<tbody><tr style="color: rgb(76, 115, 152);">
				<td width="70%" align="left">
					<div class="myexperttext"><%=DBUtil.getInstance().doctor%>(s) in Strategy</div>
				</td>
				</tr>
			</tbody></table>
		</div>
		<table width="100%" cellspacing="0">
		  <tbody>
		  <tr bgcolor="#faf9f2">
		    <%  if(message != null) {
           %>
                 <tr>
                           <td colspan=20 width ="250px"class="text-blue-01-red"><%=message != null ? message : ""%></td>
                   </tr>
             <%
                  	}
             %>
				<td align="left" width="5%"/>
				<td width="95%" class="expertListHeader" height="25" align="left" valign="bottom">
					Objectives <%= taName != null && faName != null ? " for "+taName+" - "+faName : "" %>
				</td>
		  </tr>
		  <tr bgcolor="#faf9f2">
				<td align="left" width="5%"/>
				<td width="95%" class="expertListHeader" height="25" align="left" valign="top">
					<select name="mainObjectives" multiple class="field-blue-02-220x50">
					   <%
					     NodeDTO nodeDTO = null;
						if (session.getAttribute("SEGMENTINFO_FOR_SEGMENTID")!=null) {
							nodeDTO = (NodeDTO)session.getAttribute("SEGMENTINFO_FOR_SEGMENTID");
						}
						 if(session.getAttribute("MAIN_OBJECTIVES") != null) {
							 ArrayList mainObjectiveList = new ArrayList();
							 mainObjectiveList = (ArrayList)session.getAttribute("MAIN_OBJECTIVES");
							 MainObjectiveDTO mainObjectiveDTO = new MainObjectiveDTO();

							 if ((mainObjectiveList != null) && (nodeDTO != null)) {
								 for (int i=0;i<mainObjectiveList.size();i++) {

									 mainObjectiveDTO = (MainObjectiveDTO) mainObjectiveList.get(i);
					   %>
									 <option value="<%= mainObjectiveDTO.getId()%>"
					   <%
										 if ((nodeDTO!=null) && (nodeDTO.getSegmentObjective()!=null)) {
											 String mainObjectives = nodeDTO.getSegmentObjective();
											 if(mainObjectives != null && !mainObjectives.equals("0")) {
											 StringTokenizer str = new StringTokenizer(mainObjectives, ",");
											 while (str.hasMoreTokens()) {
												 int mainObjectiveId = Integer.parseInt(str.nextToken());
												 if(mainObjectiveId==mainObjectiveDTO.getId()) { %>selected<%}}} %>><%=
												 mainObjectiveDTO.getMainObjective()%></option>
					   <%
								   }
								 }
							 }
						}
					   %>
					</select>
				</td>
		  </tr>
		  <tr bgcolor="#faf9f2" valign="bottom">
				<td align="left" width="5%"/>
				<td width="95%" class="expertListHeader" height="25" align="left" valign="bottom">
					Status
				</td>
		  </tr>
		  <tr valign="top" bgcolor="#faf9f2">
				<td align="left" width="5%"/>
				<td width="95%" class="expertListHeader" height="25" align="left" valign="top">
				  <select name="segmentstatus" class="field-blue-01-180x20" >
				
				  
					<%

					if (statusLookUp != null && statusLookUp.length > 0) {
						OptionLookup lookup = null;
						isAlreadySelected = false;
						String val = "";
						for (int i = 0; i < statusLookUp.length; i++) {
							lookup = statusLookUp[i];
							val =  String.valueOf(lookup.getId());
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
				   %>
							<option value="<%=lookup.getId()%>" 
							<% if ( (nodeDTO != null) && (nodeDTO.getStrategyStatus() != null) 
									&& (nodeDTO.getStrategyStatus().equals(val)) ){  
								isAlreadySelected = true;
								%> selected <% }
							else if(!isAlreadySelected) {%><%=selected%> <%} %>> <%=lookup.getOptValue()%></option>

					<%
						}
					}
					%>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" name="SaveStrategy" value="" <% if (userType != Integer.parseInt(frontEndAdmin)){%>disabled <%}%>
							style="padding-bottom:10px;background : url(images/buttons/save_strategy.gif);width:115px; height:22px; border:0"	onclick="javascript:saveStrategy();"/>
				</td>
			</tr>
				
		</tbody></table>  
   </div>
   <br/>
   <div class="producttext">
		<div class="myexpertlist" >
			<table width="100%">
				<tbody><tr style="color: rgb(76, 115, 152);">
				<td width="50%" align="left">
					<div class="myexperttext"><%=DBUtil.getInstance().doctor%>(s) in Segment</div>
				</td>
				</tr>
			</tbody></table>
		</div>

		<table style="padding-left:15px;" width="98%" cellspacing="0">
		
		  <tbody>
			  <tr bgcolor="#faf9f2">
				<td width="5%">&nbsp;</td>
				<td width="3%">&nbsp;</td>
				<td width="20%" class="expertListHeader"><%=DBUtil.getInstance().doctor%> Name</td>
				<td width="18%" class="expertListHeader">Specialty</td>
				<td width="3%">&nbsp;</td>
				<td width="18%" class="expertListHeader">Phone</td>
				<td width="20%" class="expertListHeader">Location</td>
				<td width="13%"></td>
			  </tr>
		  </tbody>
		</table>
		 <div style="height:120px;overflow:auto; width="100%";overflow-x:hidden;">
		<table style="padding-left:15px;" width="98%" cellspacing="0">

			  <tr>
			  
			   <%
					ArrayList expertsInSegment = (ArrayList)session.getAttribute("EXPERTS_IN_SEGMENT");
					if (expertsInSegment != null) {
					for (int i=0;i<expertsInSegment.size();i++) {
						MyExpertDTO myExpertDTO = (MyExpertDTO)expertsInSegment.get(i);
			   %>	
						<tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
							<td width="5%" align="right"><input type="checkbox" name="checkExpertIds" value="<%=myExpertDTO.getExpertId()%>"></td>
							<td width="3%">&nbsp;</td>
							<td width="20%" class="expertListRow">
								<a class=text-blue-01-link href='expertfullprofile.htm?kolid=<%= myExpertDTO.getExpertId()%>&entityId=<%=myExpertDTO.getKolId()%>&fromKOLStrategy=true' target="_top"><%=myExpertDTO.getExpertName()%></a>
							</td>
							<td width="18%" class="text-blue-01">
								<%=((myExpertDTO.getSpeciality()==null)?"":myExpertDTO.getSpeciality())%>
							</td>
							<td width="3%">&nbsp;</td>
							<td width="18%" class="text-blue-01">
								<%=(((myExpertDTO.getPhone()!=null) && (!myExpertDTO.getPhone().equals("null")))?myExpertDTO.getPhone():"")%>
							</td>
							<td width="20%" class="text-blue-01">
								<%=(((myExpertDTO.getLocation()!=null) && (!myExpertDTO.getLocation().equals("null")))?myExpertDTO.getLocation():"")%>
							</td>
							<td width="13%">
							    <a target=_top href='expertfullprofile.htm?fromInteraction=yes&kolid=<%=myExpertDTO.getExpertId()%>&entityId=<%=myExpertDTO.getKolId()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=myExpertDTO.getLastName()%>, <%=myExpertDTO.getFirstName()%>' class="text-blue-01-link">Interactions</a>
								<!-- a target=_top href='#' class="text-blue-01-link">Interactions</a-->
							</td>
							</TR>
						<% }
					} %>	
				
		  </table>
		 </div>
	</div>	
	<br height="1">
	<div align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" name="delete Expert" value="" <% if (userType != Integer.parseInt(frontEndAdmin)){%>disabled <%}%>
							style="padding-bottom:10px;background : url(images/buttons/delete_experts_segment.gif);width:160px; height:22px; border:0"	onclick="javascript:deleteExpert();"/>

						<input type="button" name="expertAdvSearchSubmit" value="" <% if (userType != Integer.parseInt(frontEndAdmin)){%>disabled <%}%>	style="padding-bottom:10px;background : url(images/buttons/search_experts_segment.gif);width:172px; height:22px; border:0"	onclick="submitAdvExpertSearch(this.form, '<%=CONTEXTPATH%>');"/>
					</div>
<br/>
   <div class="producttext">
		<div class="myexpertlist">
			<table width="100%">
				<tbody><tr style="color: rgb(76, 115, 152);">
				<td width="50%" align="left">
					<div class="myexperttext">Segment Tactics</div>
				</td>
				</tr>
			</tbody></table>
		</div>
	<div style="height:100px;overflow:auto; width="100%";overflow-x:hidden;>
	
	
	<table style="padding-left:15px;" width="98%" cellspacing="0" id="segmentTacticTableHeader">
	     <tr align="left" valign="middle">
      <td width="3%" height="25" >&nbsp;</td>
	  <td width="35%" class="text-blue-01-bold">Tactic </td>
      <td width="22%" class="text-blue-01-bold">Role </td>
      <td width="36%" class="text-blue-01-bold">&nbsp;&nbsp;&nbsp;Due Date(*)</td>
      <td width="3%">&nbsp;</td>
      	 </tr>
	</table>
		
		<table style="padding-left:15px;" width="98%" cellspacing="0" id="normalHeader">
		  <tbody>
			  <tr bgcolor="#faf9f2">
				<td width="16%" class="expertListHeader" id="tacticApplied" >
				Tactic Applied</td>
				<td width="16%" class="expertListHeader">Tactic</td>
				<td width="18%" class="expertListHeader">Role</td>
				<td width="9%" class="expertListHeader">&nbsp;Due Date</td>
				<td width="6%" class="expertListHeader">&nbsp;</td>
				<td width="20%" class="expertListHeader"></td>
				<td width="13%">&nbsp;</td>
			  </tr>
		   </tbody>
	     </table>
			  <table id="segmentTacticTable" style="padding-left:15px;" width="98%" cellspacing="0">
			  
			   <%
					if ( null != segmentTacticList && segmentTacticList.size() > 0 )
					  {
						for(int i=0;i < segmentTacticList.size(); ++i) {
						TacticDTO  tempTacticDTO = (TacticDTO) segmentTacticList.get(i);	
			  %>	
						<tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
							<td width="5%" align="left">
								<input type="hidden" name="activityId" value="0">
								<input type="checkbox" name="appliedTacticId" value="<%=tempTacticDTO.getSegmentTacticId()%>" <%if(tempTacticDTO.getSegmentTacticId() == appliedTacticId) { %>checked<% } %>  >
							</td>
							<td width="11%">&nbsp;</td>
							<td width="16%" class="text-blue-01">
								<%=tempTacticDTO.getTacticName() != null ? tempTacticDTO.getTacticName() : ""%>
							</td>
							<td width="15%" class="text-blue-01">
								<%=tempTacticDTO.getRoleName() != null ? tempTacticDTO.getRoleName() + "" : ""%>
							</td>
							<td width="3%">&nbsp;</td>
							<td width="15%" class="text-blue-01">
								<%=tempTacticDTO.getTacticDueDate() != null ? tempTacticDTO.getTacticDueDate() + "" : ""%>
							</td>
							<td width="20%" class="text-blue-01">
								<%if (userType == Integer.parseInt(frontEndAdmin)) { if(tempTacticDTO.getSegmentTacticId() != appliedTacticId)	{ %><a class="text-blue-01-link" href="#" onClick="deleteSegmentTactics('<%=tempTacticDTO.getSegmentTacticId()%>')">delete</a><%} } %>
							</td>
							<td width="13%">&nbsp;</td>
							
						</tr>
						<%
						}
					}
				%>
				<tr>
				<td align="left" colspan="1" height="1">&nbsp;</td></tr>
			</table>
			</div>
			<div align="left">
						<span id="addBlock" style="align:left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<% if(tacticList != null && tacticList.size() > 0) { %>
								 <input name="addTacticButton" type="button" style="border:0;background : url(images/buttons/add_edit_tactics.gif);width:125px; height:22px;" class="button-01" value="" <% if (userType != Integer.parseInt(frontEndAdmin)){%>disabled <%}%> onClick="createTactics()">
							<% } %>
				 
							<% if(expertsInSegment != null && expertsInSegment.size() > 0 && segmentTacticList != null && segmentTacticList.size() > 0) { %>
								<input name="applyTacticsButton" type="button" style="border:0;background : url(images/buttons/apply_tactics.gif);width:107px; height:22px;" class="button-01" value="" <% if (userType != Integer.parseInt(frontEndAdmin)){%>disabled <%}%> onClick="applyTactics();">  
							<% } %>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span id="saveBlock" style="align:left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input name="saveTacticButton" style="border:0;background : url(images/buttons/save_segment_tactics.gif);width:163px; height:23px;" type="button" class="button-01" value="" onClick="saveSegmentTactics(this.form);">
							&nbsp;
							<input name="cancelTactic" style="border:0;background : url(images/buttons/cancel.gif);width:75px; height:23px;" type="button" class="button-01" value="" onClick="cancelSegmentTactic(this.form, '<%=CONTEXTPATH%>');">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</span>
		</div>
	
  </div>
</form>
<% 
	session.removeAttribute("EXPERTS_IN_SEGMENT"); 
	session.removeAttribute("MESSAGE");
	session.removeAttribute("SEGMENT_TACTICS");
	session.removeAttribute("KOL_TACTICS");
	session.removeAttribute("APPLIED_TACTIC");
	session.removeAttribute("LATEST_CRITERIA_LIST");
%>
</body>
</html>