<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@page import = "com.openq.kol.NodeDTO, com.openq.kol.TacticDTO, com.openq.eav.option.OptionLookup, com.openq.kol.MainObjectiveDTO"%>

<%
	OptionLookup taLookup[] = null;
    if (session.getAttribute("TA") != null) {
        taLookup = (OptionLookup[]) session.getAttribute("TA");
    }

	OptionLookup faLookup[] = null;
    if (session.getAttribute("FA") != null) {
        faLookup = (OptionLookup[]) session.getAttribute("FA");
    }

	OptionLookup regionLookup[] = null;
    if (session.getAttribute("REGION") != null) {
        regionLookup = (OptionLookup[]) session.getAttribute("REGION");
    }	
    
    ArrayList objectiveList = null;
    if (session.getAttribute("OBJECTIVES") != null) {
        objectiveList = (ArrayList) session.getAttribute("OBJECTIVES");	
    }	
    
    int selectedTa = 0;
    if (session.getAttribute("FILTER_TA") != null) {
    	selectedTa = Integer.parseInt( (String) session.getAttribute("FILTER_TA"));
    }
    
    int selectedFa = 0;
    if (session.getAttribute("FILTER_FA") != null) {
    	selectedFa = Integer.parseInt( (String) session.getAttribute("FILTER_FA"));
    }

    int selectedRegion = 0;
    if (session.getAttribute("FILTER_REGION") != null) {
    	selectedRegion = Integer.parseInt( (String) session.getAttribute("FILTER_REGION"));
    }

    int selTa = 0;
    if (session.getAttribute("SEL_TA") != null) {
    	selTa = Integer.parseInt( (String) session.getAttribute("SEL_TA"));
    }

    int selFa = 0;
    if (session.getAttribute("SEL_FA") != null) {
    	selFa = Integer.parseInt( (String) session.getAttribute("SEL_FA"));
    }
    
    int selRegion = 0;
    if (session.getAttribute("SEL_REGION") != null) {
    	selRegion = Integer.parseInt( (String) session.getAttribute("SEL_REGION"));
    } 
%>

<HTML>
<HEAD>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>Create Node</TITLE>
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
<script src="./js/validation.js"></script>

<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
<script language="javascript">

function show_calendar(sName) {
	gsDateFieldName=sName;	
	var winParam="top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
	if (document.layers)	
		winParam="top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
	window.open("Popup/PickerWindow.html","_new_picker",winParam);
}




function submitTactic(formObj,contextURL)
{    

	if(!isEmpty(formObj.tacticName,'Tactic Name'))
		   return;
         	
   	if(!isEmpty(formObj.tacticDetails,'Tactic Details'))
 	   return;

	if(formObj.tacticName.value.length <= 0) {
		alert ("Please provide valid input for Tactic Name");
		formObj.tacticName.focus();
		return false;
	}
	if(formObj.tacticDetails.value.length <= 0)
	{	
		alert ("Please provide valid input for Tactic Details");
		formObj.tacticDetails.focus();
		return false;
	}
	if(formObj.tacticDetails.value.length > 500 ) {		
		alert ("Tactic Details should be less than 500 characters");
		formObj.tacticDetails.focus();
		return false; 
	}		
	
	if(formObj.ta.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.ta.focus();
		return false;
	}	
	if(formObj.fa.value == -1)
	{	
		alert ("Please select a Functional Area");
		formObj.fa.focus();
		return false;
	}
	if(formObj.region.value == -1)
	{	
		alert ("Please select a Region");
		formObj.region.focus();
		return false;
	}	
		
	if(formObj.objective.value == -1)
	{	
		alert ("Please select a Objective");
		formObj.objective.focus();
		return false;
	}
	
	formObj.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.ADD_TACTIC%>";

	formObj.target="_self";
	formObj.submit();
}

function saveTactic(formObj,contextURL)
{

	if(!isEmpty(formObj.tacticName,'Tactic Name'))
		   return;
         	
   	if(!isEmpty(formObj.tacticDetails,'Tactic Details'))
 	   return;
 	   
 	   
	if(formObj.tacticName.value.length <= 0) {
		alert ("Please provide valid input for Tactic Name");
		formObj.tacticName.focus();
		return false;
	}
	if(formObj.tacticDetails.value.length <= 0)
	{	
		alert ("Please provide valid input for Tactic Details");
		formObj.tacticDetails.focus();
		return false;
	}
	if(formObj.tacticDetails.value.length > 500 ) {		
		alert ("Tactic Details should be less than 500 characters");
		formObj.tacticDetails.focus();
		return false; 
	}	
	
	if(formObj.ta.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.ta.focus();
		return false;
	}	
	if(formObj.fa.value == -1)
	{	
		alert ("Please select a Functional Area");
		formObj.fa.focus();
		return false;
	}	
	if(formObj.region.value == -1)
	{	
		alert ("Please select a Region");
		formObj.region.focus();
		return false;
	}			
	if(formObj.objective.value == -1)
	{	
		alert ("Please select a Objective");
		formObj.objective.focus();
		return false;
	}
	
	formObj.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.SAVE_TACTIC%>";

	formObj.target="_self";
	formObj.submit();
}


function editTactic(tacticId) {

	var formObj=document.tacticForm;
	
	formObj.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.EDIT_TACTIC%>&tacticId="+tacticId;

	formObj.target="_self";
	formObj.submit();
}

function cancelTactic(formObj,contextURL) {

	formObj.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.VIEW_TACTICS%>";

	formObj.target="_self";
	formObj.submit();
}

function deleteTactic(){


	var thisform=document.tacticForm;
	var flag =false;

	thisform.action="<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.DELETE_TACTIC%>";
	thisform.target="_self";
	
	for(var i=0;i<thisform.elements.length;i++){
		
		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].name=="tacticId" && thisform.elements[i].checked){
			flag =true;
			break;		
		}
	}	
	
	if(flag){
		if(confirm("Do you want to delete the selected Tactic/s?")){
			thisform.submit();
		}
	}else {
		alert("Please select atleast one Tactic to delete");
	}

}

function filterTactics()
{	
	var formObj = document.tacticForm;
	
	if(formObj.filterTa.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.filterTa.focus();
		return false;
	}	
	if(formObj.filterFa.value == -1)
	{	
		alert ("Please select a Functional Area");
		formObj.filterFa.focus();
		return false;
	}	
	if(formObj.filterRegion.value == -1)
	{	
		alert ("Please select a Region");
		formObj.filterRegion.focus();
		return false;
	}			
	
	formObj.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.VIEW_TACTICS%>";

	formObj.target="_self";
	formObj.submit();
}
/*
function getObjectives() {

	var thisform = document.tacticForm;
	
	thisform.action = "<%=CONTEXTPATH%>/kol_tactics.htm?action=<%=ActionKeys.GET_OBJECTIVES%>";
	thisform.target = "_self";
	thisform.submit();	
}
*/

/*******************************************************************************
validate() - This function performs the ajax functionality to populate the 
             objective list.
*******************************************************************************/
var req;
function getObjectives() {

	var thisform = document.tacticForm;

	var taField = thisform.ta.value;
	var faField = thisform.fa.value;
	var regionField = thisform.region.value;     

	/*if (taField == -1 && faField != -1 && regionField != -1) {
		alert("Please select all the values")
		thisform.ta.focus();
	   	return false; 
	} 
   if (taField != -1 && faField == -1 && regionField != -1) {
		alert("Please select Functional Area")
		thisform.fa.focus();
	   	return false;
    }
    if (taField != -1 && faField != -1 && regionField == -1) {
		alert("Please select Region")
		thisform.region.focus();
		return false;
	}*/
     if (taField != -1 && faField != -1 && regionField != -1) {
    	var url = "ObjectiveListHelper?taField="+taField+"&faField="+faField+"&regionField="+regionField;
    if (window.XMLHttpRequest) {
       	req = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
   	    req = new ActiveXObject("Microsoft.XMLHTTP");
    }
    req.open("GET", url, true);
    req.onreadystatechange = callback;
    req.send(null);
  }
}	

/*******************************************************************************
callback() - This function to check the request status.
*******************************************************************************/
function callback() {
	//If the readystate is 4 then check for the request status.
    if (req.readyState == 4) {
        if (req.status == 200) {
            // update the HTML DOM based on whether or not message is valid
			populateObjList(req.responseText);
		}
    }
}

/*******************************************************************************
populateObjList(val) -	This function is used to set the Objective list when 
						the user chooses the ta, fa & region using Ajax.
*******************************************************************************/
function populateObjList(val){
	var start = val;
	var stdate = new Array();
	stdate = start.split(';');
	document.getElementById("objective").options.length = 0;
	document.getElementById("objective").options[0] = new Option("Please select", "-1");	
	for(i=0;i<stdate.length-1;i++) {
		var objArray = new Array();
		objArray = stdate[i].split('*');
		document.getElementById("objective").options[i+1] = new Option(objArray[i,1],objArray[i,0]);								
	}
}

</script>
</head>

<%
	ArrayList tacticList = new ArrayList();

	if(session.getAttribute("KOL_TACTICS") != null)
		tacticList = (ArrayList) session.getAttribute("KOL_TACTICS");

	TacticDTO tacticDTO = null;
	
	if(session.getAttribute("SEL_TACTIC") != null)
		 tacticDTO  = (TacticDTO) session.getAttribute("SEL_TACTIC");

	String message = null;
	if(session.getAttribute("MESSAGE") != null)
		message = (String) session.getAttribute("MESSAGE");
	
	String show = "show";
				
	if(session.getAttribute("SHOW") != null)
		show = (String) session.getAttribute("SHOW");
	boolean isAlreadySelected = false;
%>

<body>
 
 <form name="tacticForm" method="POST">

  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>              
		<jsp:include page="kol_menu.jsp" flush="true"/>
	  </td>
	</tr>

	<tr>
	  <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	</tr> 

<%  if(message != null) {
%>             
 <tr>
   <td class="text-blue-01-red"><%=message%></td>
 </tr>
<%
	}
%>
</table>
<div class="contentmiddle">
    <div class="producttext">
	    <div class="myexpertlist">
	      <table width="100%">
	        <tr style="color:#4C7398">
	        <td width="50%" align="left">
	          <div class="myexperttext">Tactics Inventory</div>
	        </td>
	        </tr>
	      </table>
	    </div>
	    
	    <table width="100%" cellspacing="0">
	         <tr align="left" valign="middle" >
				<td width="3%">&nbsp;</td>
				<td width="25%" class="expertListHeader">Therapeutic Area</td>
		        <td width="25%" class="expertListHeader">Functional Area</td>
		        <td width="25%" class="expertListHeader">Region</td>
	      </tr>    
		 
      		  <tr align="left" valign="middle">
				<td width="3%">&nbsp;</td>
				<td width="25%">
		 <select name="filterTa" class="field-blue-01-180x20">
		  <option value="-1">Please select</option>			 		 		 
		  <%
            if (taLookup != null && taLookup.length > 0) {
                OptionLookup lookup = null;
               isAlreadySelected = false;
                for (int i = 0; i < taLookup.length; i++) {
                    lookup = taLookup[i];
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
						
          %>
			<option value="<%=lookup.getId()%>" 
			<% if (lookup.getId() == selectedTa) { 
				isAlreadySelected = true;
			%> selected <% }
			else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>          
          </select>			
		</td>

		<td width="25%">
		 <select name="filterFa" class="field-blue-01-180x20">
		  <option value="-1">Please select</option>			 		 		 
		  <%
            if (faLookup != null && faLookup.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < faLookup.length; i++) {
                    lookup = faLookup[i];
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
						
          %>
			<option value="<%=lookup.getId()%>" 
			<% if (lookup.getId() == selectedFa) { 
				isAlreadySelected = true;
			%> selected <% }
			else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>          
          </select>
		</td>
		<td width="25%">
		 <select name="filterRegion" class="field-blue-01-180x20">
		  <option value="-1">Please select</option>			 		 
		  <%
            if (regionLookup != null && regionLookup.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < regionLookup.length; i++) {
                    lookup = regionLookup[i];
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
						
          %>
			<option value="<%=lookup.getId()%>" 
			<% if (lookup.getId() == selectedRegion) { 
				isAlreadySelected = true;
			%> selected <% }
			else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>          
          </select>			
		</td>	
				<td>
				    	<input name="getFilter" type="button" style="border:0;background : url(images/buttons/search_tactics.gif);width:119px; height:22px;" class="button-01" value="" onClick="javascript:filterTactics();"> 
				</td>

      		</tr>

			<tr>
				<td height="10" align="left" valign="top" ><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="10"></td>
			</tr>

	  </table>
   		 
   		 <table width="100%" cellspacing="0">
	      <tr bgcolor="#faf9f2">
		        <td width="1%">&nbsp;</td>
		        <td width="27%" align="left" class="expertListHeader">Tactic Name</td>
		        <td width="10%" class="expertListHeader">Objectives</td>
            
                </tr>
	      
		      <% 
			    for(int i=0;i < tacticList.size(); ++i) {
				  TacticDTO  tempTacticDTO = (TacticDTO) tacticList.get(i);
			  %>
		        <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
		  
				  <td width="3%" height="25" align="right" class="text-blue-01">&nbsp;<input type="checkbox" name="tacticId"  value="<%=tempTacticDTO.getTacticId()%>"
			      <% if( null != tempTacticDTO.getActivity() && Integer.parseInt(tempTacticDTO.getActivity()) == tempTacticDTO.getTacticId()) { %> disabled <%}%>></td>
				  <td width="27%" height="25" align="left" class="text-blue-01-link"><a href="javascript:editTactic('<%=tempTacticDTO.getTacticId()%>')"
				  class="text-blue-01-link"> <%=tempTacticDTO.getTacticName() != null ? tempTacticDTO.getTacticName() : ""%> </a></td>	  
				  <td class="text-blue-01">  <%=tempTacticDTO.getObjective() != null ? tempTacticDTO.getObjective() : ""%> </td>
	       </tr>
				<%
					}
				%>	 
      </table>
	  <tr>
 <td  width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

      <!--td height="30" align="left" valign="top" class="back-white"-->
	       <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					 
				 <td width="1" height="30">&nbsp;</td>
				 <%
			        if(tacticList!=null && tacticList.size()>0){
			
			        	
			     %>
				 <td width="90" align="left"><input name="delNodes" type="button" style="border:0;background : url(images/buttons/delete_tactics.gif);width:112px; height:23px;" class="button-01" onClick="deleteTactic();"></td> 
				 <%
			        	
			        }
			     %>
				</tr>
	    </table>
</div>			
			<br/> 
			
			<div class="producttext">
		    <div class="myexpertplan">
		      <table width="100%">
		        <tr style="color:#4C7398">
		        <td align="left">
		          <div class="myexperttext"><%if(tacticDTO != null) { %> Edit <% } else { %> Add New <% } %> Tactics</div>
		        </td>
		        </tr>
		      </table>
		    </div>		
		    
		    <table width="100%"  border="0" cellspacing="0" cellpadding="0">

  		<tr>
	      <td width="5" height="5">&nbsp;</td>
	  	</tr>

	  	<tr>
		  <td width="3%" height="20">&nbsp;</td>
		  <td width="25%" class="expertPlanHeader" >Tactic Name <sup> * </sup></td>
		  <td width="35%" class="expertPlanHeader" >Tactic Details <sup> * </sup></td> 
		  <td width="40%" class="expertPlanHeader" >&nbsp;</td>		  			    
		  <td width="1%" height="20">&nbsp;</td>	
		</tr>
				
		<tr>
		  <td width="20" height="20">&nbsp;</td>
  		  <td valign="top"><input name="tacticName" type="text" class="field-blue-03-130x20" maxLength="50" value="<%=(tacticDTO != null && tacticDTO.getTacticName() != null) ? tacticDTO.getTacticName() : ""%>">
		  <input name="selTacticId" type="hidden" value="<%=(tacticDTO != null && tacticDTO.getTacticId() != 0) ? tacticDTO.getTacticId()+"" : ""%>">
		  </td>	 
		  <td><textarea name="tacticDetails" maxlength=500 wrap="VIRTUAL" class="field-blue-07-180x50" ><%=(tacticDTO != null && tacticDTO.getTacticDetail() != null) ? tacticDTO.getTacticDetail().trim() : ""%></textarea></td>	
		  <td>&nbsp;</td>	 		  
		  <td width="10" height="20">&nbsp;</td>		 
		</tr>

  		<tr>
	      <td colspan="6" width="2" height="5">&nbsp;</td>
	  	</tr>

	    <tr>
		 <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  	    </tr>

  		<tr>
	      <td width="10" height="">&nbsp;</td>
	  	</tr>

		<tr>
		  <td width="3%" height="20">&nbsp;</td>
		  <td width="25%" class="expertPlanHeader">Therapeutic Area <sup> *</td>		
		  <td width="35%" class="expertPlanHeader">Functional Area <sup> *</td> 
		  <td width="40%" class="expertPlanHeader">Region <sup> *</td>		  			    
		  <td width="1%" height="20">&nbsp;</td>	
		</tr>

		<tr>
		  <td height="3%">&nbsp;</td>  		 		  
		  <td width="25%">
			 <select name="ta" class="field-blue-01-180x20" onChange="javascript:getObjectives()">
			  <option value="-1">Please select</option>			 
			  <%
				if (taLookup != null && taLookup.length > 0) {
					OptionLookup lookup = null;
					isAlreadySelected = false;
					for (int i = 0; i < taLookup.length; i++) {
						lookup = taLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
							
			  %>
				<option value="<%=lookup.getId()%>" 
				<% if ( (tacticDTO != null && tacticDTO.getTA() != null 
						&& Integer.parseInt(tacticDTO.getTA()) == lookup.getId() ) || selTa == lookup.getId()) { 
					isAlreadySelected = true;
						%> selected <% }
				else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
			  <%
					}
				}
			  %>          
			  </select>	
		  </td>

		  <td width="35%">
			 <select name="fa" class="field-blue-01-180x20" onChange="javascript:getObjectives()">
			  <option value="-1">Please select</option>
			  <%
				if (faLookup != null && faLookup.length > 0) {
					OptionLookup lookup = null;
					isAlreadySelected = false;
					for (int i = 0; i < faLookup.length; i++) {
						lookup = faLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
							
			  %>
				<option value="<%=lookup.getId()%>" 
				<% if ( (tacticDTO != null && tacticDTO.getFA() != null 
						&& Integer.parseInt(tacticDTO.getFA()) == lookup.getId()) || selFa == lookup.getId()) {
					isAlreadySelected = true;
						%> selected <% }
				else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
			  <%
					}
				}
			  %>          
			  </select>	
		  </td>

		  <td width="40%">
			 <select name="region" class="field-blue-01-180x20" onChange="javascript:getObjectives()">
			  <!-- <option value="-1">Please select</option> -->	 
			  <%
				if (regionLookup != null && regionLookup.length > 0) {
					OptionLookup lookup = null;
					for (int i = 0; i < regionLookup.length; i++) {
						lookup = regionLookup[i];
                 		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
							
			  %>
				<option value="<%=lookup.getId()%>" 
				<% if ( (tacticDTO != null && tacticDTO.getRegion() != null 
						&& Integer.parseInt(tacticDTO.getRegion()) == lookup.getId()) || selRegion == lookup.getId()){
						isAlreadySelected = true;
						%> selected <% }
				else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
			  <%
					}
				}
			  %>          
			  </select>	
		  </td>
		  <td width="1%"  class="expertPlanHeader" height="20">&nbsp;</td>
		</tr>

  		<tr>
	      <td width="10" height="">&nbsp;</td>
	  	</tr>

		<tr>
		  <td width="3%" height="20">&nbsp;</td>
		  <td width="25%" class="expertPlanHeader" >Objectives<sup> *</td>		
		  <td width="35%" class="expertPlanHeader" >&nbsp;</td> 
		  <td width="40%" class="expertPlanHeader" >&nbsp;</td>		  			    
		  <td width="1%" height="20">&nbsp;</td>	
		</tr>

		<tr>
		  <td height="3%">&nbsp;</td>  		 		  
		  <td width="25%">		  
			<select name="objective" class="field-blue-01-180x20">
				<option value="-1">Please Select</option>
				<% 
					MainObjectiveDTO mainObjectiveDTO = null;
					if (objectiveList != null) {
					  for (int i=0;i<objectiveList.size();i++) { 
						mainObjectiveDTO = (MainObjectiveDTO) objectiveList.get(i);
				%>
				<option value="<%=mainObjectiveDTO.getId()%>" <% if (tacticDTO != null && tacticDTO.getObjectiveId() == mainObjectiveDTO.getId()) { %> selected <% } %>><%=mainObjectiveDTO.getMainObjective()%></option>
				<% 	
					  } // end of for loop
					} // end of if 
				%>
			</select>
		  </td>

		  <td width="35%">&nbsp;</td>

		  <td width="40%">&nbsp;</td>
		  <td width="1%"  class="text-blue-01-bold" height="20">&nbsp;</td>
		</tr>

  		<tr>
	      <td width="10" height="5">&nbsp;</td>
	  	</tr>

	    <tr>
			<td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
   	    </tr>

		<tr height="30">
		  <td width="5">&nbsp;</td>
		  <% if("show".equalsIgnoreCase(show)) { %>

		  <td colspan="5">
		    	<input name="addMsg" type="button" style="border:0;background : url(images/buttons/add_tactics.gif);width:98px; height:23px;" class="button-01" value="" onClick="submitTactic(this.form, '<%=CONTEXTPATH%>');"> 
		  </td>
		  <% } else { %>

		  <td colspan="5">
		    	<input name="editMsg" type="button" style="border:0;background : url(images/button2.jpg);width:152px; height:23px;" class="button-01" value="Save Tactic" onClick="saveTactic(this.form, '<%=CONTEXTPATH%>');">
				&nbsp;&nbsp;&nbsp;&nbsp;<input name="cancelMsg" type="button" style="border:0;background : url(images/button2.jpg);width:152px; height:23px;" class="button-01" value="Cancel" onClick="cancelTactic(this.form, '<%=CONTEXTPATH%>');"> 
		  </td>

		  <% } %>

		</tr>
   </table>	
   
   </div>
   </div>
</form>
</body>
</html>

<%

session.removeAttribute("MESSAGE");
session.removeAttribute("SHOW");
session.removeAttribute("SEL_TACTIC");
session.removeAttribute("KOL_TACTICS");
/*
session.removeAttribute("TA");
session.removeAttribute("FA");
session.removeAttribute("REGION");
*/
%>
