<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@page import = "com.openq.kol.NodeDTO,
                  com.openq.kol.MainObjectiveDTO"%>

<HTML>
<HEAD>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>Main Objectives</TITLE>
<script src="./js/validation.js"></script>
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
<script language="javascript">

function showObjectivesOnFilter(){

	var thisform=document.mainObjectiveForm;

	if(thisform.therapeuticArea.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.therapeuticArea.focus();
		return false;
	}	
	if(thisform.functionalArea.value == -1)
	{	
		alert ("Please select a Functional Area");
		formObj.functionalArea.focus();
		return false;
	}	
	if(thisform.regionArea.value == -1)
	{	
		alert ("Please select a Region");
		formObj.regionArea.focus();
		return false;
	}	
	
	thisform.action="<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.KOL_MAIN_OBJECTIVES_ON_FILTER%>";
	thisform.target="_self";
	thisform.submit();
	
	
}
function submitMainObjective(formObj,contextURL) 

{
	    
	if(!isEmpty(formObj.mainObjective , 'Main Objective'))
		   return;

   if(!isEmpty(formObj.description,'Description'))
		   return;
	 
	 if(formObj.TA.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.ta.focus();
		return false;
	}	
	if(formObj.FA.value == -1)
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
	
if(formObj.description.value.length >=255 ) {	
	
		alert ("Description should be less than 255 characters");
		formObj.description.focus();
		return false; 
} else

	
	if(formObj.mainObjective.value.length <= 0 || formObj.mainObjective.value == " ") {
		alert ("Please provide valid input for Main Objective Name");
		formObj.mainObjective.focus();
		return false;
	} else 	if(formObj.description.value.length <=0 || formObj.description.value=="" ) {	
	
		alert (" Please provide valid inpu for Description");
		formObj.description.focus();
		return false;
	

	


	}

	formObj.action = "<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.ADD_MAIN_OBJECTIVE%>";

	formObj.target="_self";
	formObj.submit();
}  

function saveMainObjective(formObj,contextURL,mainObjectiveId)
{
	
	if(!isEmpty(formObj.mainObjective,'Main Objective'))
		   return;

   if(!isEmpty(formObj.description,'Description'))
		   return;
	
   if(formObj.description.value.length >=255 ) {	
	
		alert ("Description should be less than 255 characters");
		formObj.description.focus();
		return false; 
	}
 if(formObj.TA.value == -1)
	{	
		alert ("Please select a Therapeutic Area");
		formObj.ta.focus();
		return false;
	}	
	if(formObj.FA.value == -1)
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
	if(formObj.mainObjective.value.length <= 0) {
		alert ("Please provide valid input for Main Objective");
		formObj.mainObjective.focus();
		return false;
	} else if(formObj.description.value.length <= 0) {	
		alert ("Please provide valid input for Description");
		formObj.description.focus();
		return false;
	}	
	
	formObj.action = "<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.SAVE_MAIN_OBJECTIVE%>&mainObjectiveId="+mainObjectiveId;

	formObj.target="_self";
	formObj.submit();
}


function editMainObjective(mainObjectiveId) {

	var formObj=document.mainObjectiveForm;
	
	
	if (mainObjectiveId != "" ){
		formObj.action = "<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.EDIT_MAIN_OBJECTIVE%>&mainObjectiveId="+mainObjectiveId;
		formObj.target="_self";
		formObj.submit();
	}
	
}

function cancelMainObjective(formObj,contextURL) {
if (formObj != null ){
	formObj.action = "<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.VIEW_MAIN_OBJECTIVE%>";

	formObj.target="_self";
	formObj.submit();}
}

function deleteMainObjective(){

    
	var thisform=document.mainObjectiveForm;
	var flag =false;

	thisform.action="<%=CONTEXTPATH%>/kol_main_objectives.htm?action=<%=ActionKeys.DELETE_MAIN_OBJECTIVE%>";
	thisform.target="_self";
	
	for(var i=0;i<thisform.elements.length;i++){
		
		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].name=="mainObjectiveId" && thisform.elements[i].checked){
			flag =true;
			break;		
		}
	}	
	
	if(flag){
		if(confirm("Do you want to delete the selected Main Objective/s?")){
			thisform.submit();
		}
	}else {
		alert("Please select at least one Main Objective to delete");
	}

}


</script>
</head>

<script type="text/javascript" src="./js/scriptaculous/lib/prototype.js"></script>
<script type="text/javascript" src="./js/fastinit.js"></script>
<script type="text/javascript" src="./js/tablesort.js"></script>

<%
	ArrayList mainObjectiveList = new ArrayList();

	if(session.getAttribute("MAIN_OBJECTIVES") != null)
		mainObjectiveList = (ArrayList) session.getAttribute("MAIN_OBJECTIVES");

	MainObjectiveDTO mainObjectiveDTO = null;
	
	if(session.getAttribute("SEL_MAIN_OBJECTIVE") != null)
		 mainObjectiveDTO  = (MainObjectiveDTO) session.getAttribute("SEL_MAIN_OBJECTIVE");

	String message = null;
	if(session.getAttribute("MESSAGE") != null)
		message = (String) session.getAttribute("MESSAGE");
	
	String show = "show";
				
	if(session.getAttribute("SHOW") != null)
		show = (String) session.getAttribute("SHOW");

	OptionLookup FALookUp[] = null;
    if (session.getAttribute("FA") != null) {
        FALookUp = (OptionLookup[]) session.getAttribute("FA");
    }

	OptionLookup TALookUp[] = null;
    if (session.getAttribute("TA") != null) {
        TALookUp = (OptionLookup[]) session.getAttribute("TA");
    }

	OptionLookup regionLookUp[] = null;
    if (session.getAttribute("REGION") != null) {
        regionLookUp = (OptionLookup[]) session.getAttribute("REGION");
    }


	int  filterTA  = 0;
    if (session.getAttribute("THERAPEUTIC_AREA") != null) {
        filterTA = Integer.parseInt((String) session.getAttribute("THERAPEUTIC_AREA"));
    }
	int  filterFA  = 0;
    if (session.getAttribute("FUNCTIONAL_AREA") != null) {
        filterFA = Integer.parseInt((String) session.getAttribute("FUNCTIONAL_AREA"));
    }
    int  filterRegion  = 0;
    if (session.getAttribute("REGION_AREA") != null) {
        filterRegion = Integer.parseInt((String) session.getAttribute("REGION_AREA"));
    }
    boolean isAlreadySelected = false;
%>



<body>
 <form name="mainObjectiveForm" method="POST">

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
	          <div class="myexperttext">Main Objectives</div>
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
					<select name="therapeuticArea" class="field-blue-01-180x20">
			 			<option value="-1">Please select</option>		
						<%
					       if (TALookUp != null && TALookUp.length > 0) {
			                OptionLookup lookup = null;
			                isAlreadySelected = false;
			               for (int i = 0; i < TALookUp.length; i++) {
			                    lookup = TALookUp[i];
                         		String selected = "" ;
                          		if(lookup.isDefaultSelected())
                          			selected = "selected";
			                                      
			           %>
			            <option value="<%=lookup.getId()%>" 
			            <% if (lookup.getId() == filterTA ) { 
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
					<select name="functionalArea" class="field-blue-01-180x20">
					 <option value="-1">Please select</option>		
					<%
				       if (FALookUp != null && FALookUp.length > 0) {
		                OptionLookup lookup = null;
		                isAlreadySelected = false;
		                String val = "";
		                for (int i = 0; i < FALookUp.length; i++) {
		                    lookup = FALookUp[i];
		                    val =  String.valueOf(lookup.getId());
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
		           %>
		          <option value="<%=lookup.getId()%>" 
		          <% if (lookup.getId() == filterFA) { 
		        	  isAlreadySelected = true;
		          %> selected <% }
		          else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
		          <%
		                }
		            }
		            %> 
					</select>
				</td>
				<td width="25%">
					<select name="regionArea" class="field-blue-01-180x20">
					 <option value="-1">Please select</option>		
				   <%
				       if (regionLookUp != null && regionLookUp.length > 0) {
		                OptionLookup lookup = null;
		                isAlreadySelected = false;
		                for (int i = 0; i < regionLookUp.length; i++) {
		                    lookup = regionLookUp[i];
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
		                
		           %>
		            <option value="<%=lookup.getId()%>" 
		            <% if (lookup.getId() == filterRegion) { 
		            	isAlreadySelected = true;
		            %> selected <% } 
		            else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
		          <%
		                }
		            }
		            %> 
					</select>
				</td>
				<td colspan="5">
				    	<input name="getFilter" type="button" style="border:0;background : url(images/buttons/search_objectives.gif);width:142px; height:23px;" class="button-01" value="" onClick="javascript:showObjectivesOnFilter();"> 
				</td>

      		</tr>

			<tr>
				<td height="10" align="left" valign="top" ><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="10"></td>
			</tr>

   		 </table>
   		 <table width="100%" cellspacing="0" class="sortable1">
	      <tr bgcolor="#faf9f2">
		        <td width="1%">&nbsp;</td>
		        <td width="27%" align="left" class="expertListHeader sortfirstasc">Main Objective</td>
		        <td width="30%" class="expertListHeader">Description</td>
	      </tr>
			  <% 
				for(int i=0;i < mainObjectiveList.size(); ++i) {
					MainObjectiveDTO mainObjectiveDTO1 = (MainObjectiveDTO) mainObjectiveList.get(i);
			  %>
			<tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
			  
			  <td width="3%" height="25" align="right" class="text-blue-01">&nbsp;<input type="checkbox" name="mainObjectiveId" value="<%=mainObjectiveDTO1.getId()%>" 
			   <% if ( null != mainObjectiveDTO1.getObjective() && ( mainObjectiveDTO1.getId() ==  Long.parseLong(mainObjectiveDTO1.getObjective()) ) ) {%>  disabled <%}%>></td>
			  <td width="26%" height="25" align="left" class="expertListRow"><a href="javascript:editMainObjective('<%=mainObjectiveDTO1.getId()%>')"
			  class="text-blue-01-link"> <%=mainObjectiveDTO1.getMainObjective() != null ? mainObjectiveDTO1.getMainObjective() : ""%> </a></td>
			  <td width="2%"><span class="text-blue-01"><%=mainObjectiveDTO1.getDescription() != null ? mainObjectiveDTO1.getDescription() + "" : ""%></span></td>
		      <td width="30%" class="text-blue-01">&nbsp;</td>
		
		    </tr> 
			<%
				}
			%>	
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					 
				 <td width="30" height="30">&nbsp;</td>
				 <%
			        if(mainObjectiveList!=null && mainObjectiveList.size()>0){
			
			        	
			     %>
				 <td >
				 <input name="delNodes" type="button" style="border:0;background : url(images/buttons/delete_main_objectives.gif);width:165px; height:23px;" class="button-01"  onClick="deleteMainObjective();"> </td> 
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
		          <div class="myexperttext"><%if(mainObjectiveDTO != null) { %> Edit <% } else { %> Add New <% } %> Main Objective</div>
		        </td>
		        </tr>
		      </table>
		    </div>		
		    
		    <table width="100%"  border="0" cellspacing="0" cellpadding="0">

  		<tr>
	      <td width="10" height="">&nbsp;</td>
	  	</tr>
	  	<tr>
		  <td width="3%" height="20">&nbsp;</td>
		  <td width="30%%" class="expertPlanHeader" >Main Objective <sup> * </sup></td>		  			    
		  <td width="30%" class="expertPlanHeader" >Description <sup> * </sup></td>		  			    
		  <td width="30%"  class="expertPlanHeader" height="20">Therapeutic Area <sup> *</td>
		</tr>
				
		<tr>
		  <td height="20" width="3%">&nbsp;</td>
  		  <td valign="top" width="30%"><input name="mainObjective" type="text" class="field-blue-03-130x20" maxLength="50" value="<%=(mainObjectiveDTO != null && mainObjectiveDTO.getMainObjective() != null) ? mainObjectiveDTO.getMainObjective() : ""%>">
		  <input name="selMainObjectiveId" type="hidden" value="<%=(mainObjectiveDTO != null && mainObjectiveDTO.getId() != 0) ? mainObjectiveDTO.getId()+"" : ""%>">
		  </td>	 
		  
		  <td valign="top" width="30%"><textarea name="description" wrap="VIRTUAL" class="field-blue-07-180x50" ><%=(mainObjectiveDTO != null && mainObjectiveDTO.getDescription() != null) ? mainObjectiveDTO.getDescription().trim() : ""%></textarea></td>	
		  
		  <td width="30%" valign="top">
			<select name="TA" class="field-blue-01-180x20">
			 <option value="-1">Please select</option>		
			<%
		       if (TALookUp != null && TALookUp.length > 0) {
                OptionLookup lookup = null;
                String val = "";
                isAlreadySelected = false;
                for (int i = 0; i < TALookUp.length; i++) {
                    lookup = TALookUp[i];
                    val =  String.valueOf(lookup.getId());
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
           %>
            <option value="<%=lookup.getId()%>" 
            <% if ( (mainObjectiveDTO != null) && (mainObjectiveDTO.getTA() != null) 
            		&& (mainObjectiveDTO.getTA().equals(val)) )  { 
            	isAlreadySelected = true;
            		%> selected <% } 
            else if(!isAlreadySelected){%><%=selected%> <%} %>> <%=lookup.getOptValue()%></option> 
          <%
                }
            }
            %> 
			</select>
		  </td>
		</tr>

  		<tr>
	      <td colspan="6" width="2" height="">&nbsp;</td>
	  	</tr>

	  	<tr>
		  <td width="3%" height="20">&nbsp;</td>
		  <td width="30%%" class="expertPlanHeader" >Functional Area <sup> *</td>		  			    
		  <td width="30%" class="expertPlanHeader" >Region<sup> *</td>		  			    
		  <td width="30%"  class="expertPlanHeader" height="20">&nbsp;</td>
		</tr>

		<tr>
		  <td height="20">&nbsp;</td>  		 		  
		  <td width="30%">
			<select name="FA" class="field-blue-01-180x20">
			 <option value="-1">Please select</option>		
				<%
		       if (FALookUp != null && FALookUp.length > 0) {
                OptionLookup lookup = null;
                String val = "";
                isAlreadySelected = false;
                for (int i = 0; i < FALookUp.length; i++) {
                    lookup = FALookUp[i];
                    val =  String.valueOf(lookup.getId());
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
           %>
           
            <option value="<%=lookup.getId()%>" 
            <% if ( (mainObjectiveDTO != null) && (mainObjectiveDTO.getFA() != null) 
            		&& (mainObjectiveDTO.getFA().equals(val)) )  { 
            		isAlreadySelected = true;
            		%> selected <% }
            else if(!isAlreadySelected){%><%=selected%> <%} %>> <%=lookup.getOptValue()%></option> 
          <%
                }
            }
            %> 
			</select>
		  </td>

		  <td width="30%">
			<select name="region" class="field-blue-01-180x20">
			 <option value="-1">Please select</option>		
			<%
		       if (regionLookUp != null && regionLookUp.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                String val = "";
                for (int i = 0; i < regionLookUp.length; i++) {
                    lookup = regionLookUp[i];
                    val =  String.valueOf(lookup.getId());
             		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
           %>
            <option value="<%=lookup.getId()%>" 
            <% if ( (mainObjectiveDTO != null) && (mainObjectiveDTO.getRegion() != null) 
            		&& (mainObjectiveDTO.getRegion().equals(val)) )  { 
            	isAlreadySelected = true;
            		%> selected <% }
            else if(!isAlreadySelected){%><%=selected%> <%} %>> <%=lookup.getOptValue()%></option> 
          <%
                }
            }
            %>
			</select>
		  </td>
		  <td width="30%"  class="text-blue-01-bold" height="20">&nbsp;</td>
		</tr>

  		<tr>
	      <td colspan="6" width="2" height="">&nbsp;</td>
	  	</tr>

		<tr>
		    <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  	    </tr>

		<tr height="30">
		  <td width="5">&nbsp;</td>
		  <% if("show".equalsIgnoreCase(show)) { %>

		  <td colspan="5">
		    	<input name="addMsg" type="button" style="border:0;background : url(images/buttons/add_main_objective.gif);width:147px; height:22px;" class="button-01" value="" onClick="submitMainObjective(this.form, '<%=CONTEXTPATH%>');"> 
		  </td>
		  <% } else { %>

		  <td colspan="5">
		    	<input name="editMsg" type="button" style="border:0;background : url(images/button2.jpg);width:152px; height:23px;" class="button-01" value="Save Main Objective" onClick="saveMainObjective(this.form, '<%=CONTEXTPATH%>','<%=mainObjectiveDTO.getId()%>');">
				&nbsp;&nbsp;&nbsp;&nbsp;<input name="cancelMsg" type="button" style="border:0;background : url(images/button.jpg);width:80px; height:23px;" class="button-01" value="Cancel" onClick="cancelMainObjective(this.form, '<%=CONTEXTPATH%>');"> 
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
session.removeAttribute("MAIN_OBJECTIVES");
session.removeAttribute("SEL_MAIN_OBJECTIVE");


%>