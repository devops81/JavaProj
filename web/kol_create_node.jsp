<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@page import = "com.openq.kol.NodeDTO,
                  java.util.TreeMap,
                  com.openq.eav.option.OptionLookup "%>
<%@ page import="com.openq.utils.PropertyReader"%>

<%
    String frontEndAdmin = PropertyReader.getEavConstantValueFor("FRONT_END_ADMIN");
	OptionLookup taLookup[] = null;
    if (session.getAttribute("THERAPEUTIC_AREA") != null && session.getAttribute("THERAPEUTIC_AREA").getClass().isInstance(taLookup)  ) {
         System.out.println("i am here1");
        taLookup = (OptionLookup[]) session.getAttribute("THERAPEUTIC_AREA");
    }
    
	OptionLookup faLookup[] = null;
    if (session.getAttribute("FUNCTIONAL_AREA") != null && session.getAttribute("THERAPEUTIC_AREA").getClass().isInstance(faLookup)) {
        faLookup = (OptionLookup[]) session.getAttribute("FUNCTIONAL_AREA");
    }
    
	OptionLookup regionLookup[] = null;
    if (session.getAttribute("REGION_AREA") != null && session.getAttribute("THERAPEUTIC_AREA").getClass().isInstance(regionLookup)) {
        regionLookup = (OptionLookup[]) session.getAttribute("REGION_AREA");
    }
    OptionLookup taLookup1[] = null;
    if (session.getAttribute("THERAPEUTIC") != null   ) {
         
        taLookup1 = (OptionLookup[]) session.getAttribute("THERAPEUTIC");
    }
    
	OptionLookup faLookup1[] = null;
    if (session.getAttribute("FUNCTIONAL") != null ) {
        faLookup1 = (OptionLookup[]) session.getAttribute("FUNCTIONAL");
    }
    
	OptionLookup regionLookup1[] = null;
    if (session.getAttribute("RA") != null ) {
        regionLookup1 = (OptionLookup[]) session.getAttribute("RA");
        
    }
    boolean isAlreadySelected = false;
%>
 <HTML>
<HEAD>
<script src="./js/validation.js"></script>
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
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

<%
System.out.println("before tree map");
TreeMap hirarchyMap = new TreeMap();
if(session.getAttribute("HIERARCHY_MAP") != null) {
	hirarchyMap = (TreeMap) session.getAttribute("HIERARCHY_MAP");
}
String segmentId = "";
if(session.getAttribute("segmentId") != null) {
   segmentId = ((Integer)session.getAttribute("segmentId")).toString();
}
System.out.println("before root node");
String rootNode = "";
if (session.getAttribute("rootnode")!=null) {
	rootNode = (String)session.getAttribute("rootnode");	
}

ArrayList programs = null;
if(session.getAttribute("NODES_FOR_PARENT_ID")!=null){
	programs =(ArrayList)session.getAttribute("NODES_FOR_PARENT_ID");
}
System.out.println("before  node dto");
NodeDTO nodeDTO1 = null;
if(session.getAttribute("EDIT_NODE_INFO") != null) {
	nodeDTO1 = (NodeDTO)session.getAttribute("EDIT_NODE_INFO");
}
		
int userType = 0;
    if (session.getAttribute("USER_TYPE") != null) {
        userType = Integer.parseInt((String)session.getAttribute("USER_TYPE"));
    }
	
System.out.println("last main");
%>

<script language="javascript">

function showHirarchy(hirarName,rootNode) {		
	window.parent.showHirarchyView(hirarName,rootNode);
}

function show_calendar(sName) {
	gsDateFieldName=sName;	
	var winParam="top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
	if (document.layers)	
		winParam="top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
	window.open("jsp/Popup/PickerWindow.htm","_new_picker",winParam);
}
function addNodes(){

var formObj = window.document.KOLCreateNode;
	if(!isEmpty(formObj.parentName,'Segment Name'))
		return;
	
	if(document.getElementById("parentName") != null 
		&& document.getElementById("parentName").value != null
		&& document.getElementById("parentName").value != "") {
		var strategy = false;
		if ( document.KOLCreateNode.strategyLevel.checked == false )
		{
			 strategy = "false";
		}
		if ( document.KOLCreateNode.strategyLevel.checked == true )
		{
			  strategy = "true";
  
			  if (document.KOLCreateNode.ta.value == "-1"){
		           alert ("Please select a Therapeutic Area"); 
		           document.KOLCreateNode.ta.focus();
		           return false;
              } 
              if (document.KOLCreateNode.fa.value == "-1"){
		           alert ("Please select a Functional Area"); 
		           document.KOLCreateNode.fa.focus();
		           return false;
              }
              if (document.KOLCreateNode.region.value == "-1"){
		           alert ("Please select a Region"); 
		           document.KOLCreateNode.region.focus();
		           return false;
              }
              
               
		}
		document.KOLCreateNode.action = "<%=CONTEXTPATH%>/kol_create_node.htm?action=<%=ActionKeys.KOL_ADD_NEW_NODE%>&strategyLevel="+strategy;
		document.KOLCreateNode.target="_top";
		document.KOLCreateNode.submit();
	} else {
		alert("Segment Name can't be empty");
		return false;	
	}
}
function deleteNodes()
{
	var thisform = document.KOLCreateNode;
	var flag =false;
	for(var i=0;i<thisform.elements.length;i++){
		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
			flag =true;
			break;		
		}
	}
	thisform.action = "<%=CONTEXTPATH%>/kol_create_node.htm?action=<%=ActionKeys.KOL_DELETE_NODE%>";
	if(flag){
		if(confirm("Do you want to delete the selected Node/s?")){
		    thisform.target="_top";
			thisform.submit();
		}
	}else {
		alert("Please select atleast one Node to delete");
	}
}

function editNodes(segmentId,parentId) {
	var formObj=document.KOLCreateNode;
	
	formObj.action = "<%=CONTEXTPATH%>/kol_create_node.htm?action=<%=ActionKeys.KOL_EDIT_NODE%>&segmentId="+segmentId+"&parentId="+parentId;

	formObj.target="_self";
	formObj.submit();	
}

function saveNodes(formObj,contextURL,segmentId,parentId) {	

	if(!isEmpty(formObj.parentName,'Segment Name'))
		return;
		
	if(formObj.parentName.value.length <= 0) {
		alert ("Please provide valid input for Segment Name");
		formObj.parentName.focus();
		return false;
	}	
	
	if ( document.KOLCreateNode.strategyLevel.checked == true )
		{
			  strategy = "true";
	 if (formObj.ta.value == "-1"){
           alert ("Please select a Therapeutic Area"); 
           document.KOLCreateNode.ta.focus();
           return false;
        } 
      if (formObj.fa.value == "-1"){
           alert ("Please select a Functional Area"); 
           document.KOLCreateNode.fa.focus();
           return false;
      }
      if (formObj.region.value == "-1"){
           alert ("Please select a Region"); 
           document.KOLCreateNode.region.focus();
           return false;
      }
      }
	formObj.action = "<%=CONTEXTPATH%>/kol_create_node.htm?action=<%=ActionKeys.KOL_SAVE_NODE%>&segmentId="+segmentId+"&parentId="+parentId;

	formObj.target="_top";
	formObj.submit();
}

function cancelNodeSegment(parentId) {
    var formObj=document.KOLCreateNode;
	formObj.action = "<%=CONTEXTPATH%>/kol_create_node.htm?action=<%=ActionKeys.KOL_VIEW_NODE%>&parentId="+parentId;

	formObj.target="_self";
	formObj.submit();
}

function disableTaFaRegion() {
	var thisform = document.KOLCreateNode;
   if (thisform != null){
	if (null != thisform.strategyLevel && thisform.strategyLevel.checked == true) {
		document.getElementById("taFaRegion").style.display = "block";
		document.getElementById("nonTaFaRegion").style.display = "none";
	} else if (null != thisform.strategyLevel && thisform.strategyLevel.checked == false ){
		document.getElementById("taFaRegion").style.display = "none";
		document.getElementById("nonTaFaRegion").style.display = "block";
	}
  }
}

</script>
<script type="text/javascript" src="./js/sorttable.js"></script>
</head>

<body onload="showHirarchy(
<% String hirarName =""; 
   if(segmentId != null && !"".equals(segmentId) && hirarchyMap!= null) {
	  hirarName = (String)hirarchyMap.get(new Integer(segmentId));
   }
%>
'<%=hirarName%>',<%if(rootNode != null) {%>'<%=rootNode%>'<% } %>
);">

<%System.out.println(frontEndAdmin); if (userType == Integer.parseInt(frontEndAdmin)){%>
 <form name="KOLCreateNode" method="POST">
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>              
		<jsp:include page="kol_menu.jsp" flush="true"/>
	  </td>
	</tr>
	<tr>
	  <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	</tr> 
    </table>
    <div class="contentmiddle">
    <div class="producttext">
	    <div class="myexpertlist">
	      <table width="100%">
	        <tr style="color:#4C7398">
	        <td width="50%" align="left">
	          <div class="myexperttext">Segments <%=((session.getAttribute("parentName")!=null)?" for "+session.getAttribute("parentName"):"")%></div>
	        </td>
	        </tr>
	      </table>
	    </div>
         <table width="100%" cellspacing="0" class="sortable">
	      <tr bgcolor="#faf9f2">
		      <td width="5%">&nbsp;</td>
		      <td width="20%" class="expertListHeader">Segment Name</td>
		      <td width="20%" class="expertListHeader">Description</td>
		      <td width="20%" class="expertListHeader">Created By</td>
		      <td width="20%" class="expertListHeader">Date Created</td>
		      <td width="15%">&nbsp;</td>
	      </tr>
	      <%		
			if (programs != null) {
		  		for (int i=0;i<programs.size();i++) {
		    		NodeDTO nodeDTO = (NodeDTO)programs.get(i);
             
		%>
		
		  <tr>
	         <td width="5%" height="25" align="left" class="text-blue-01">
	           <input type="checkbox" name="NodeId" value="<%=nodeDTO.getSegmentId()%>"
		           <% if ( "YES".equalsIgnoreCase(nodeDTO.getChildPresent()) ) { %>
     	               disabled <% } %> >&nbsp;</td>
		     <td width="20%"><a href="javascript:editNodes(<%=nodeDTO.getSegmentId()%>,<%=nodeDTO.getParentId()%>)"
		            class="text-blue-01-link"><%= nodeDTO.getParentName() %></a>
	         </td>
			  <td width="20%" class="text-blue-01"><%=nodeDTO.getDescription() == null?"":nodeDTO.getDescription()%></td>
			  <td width="20%" class="text-blue-01"><%=nodeDTO.getCreatedBy()%> </td>
		      <td width="20%" class="text-blue-01"><%=nodeDTO.getCreatedDate()%></td>
		      <td width="15%">&nbsp;</td>
		      <input type="hidden" name="parentId" value="<%=nodeDTO.getSegmentId()%>,<%=nodeDTO.getParentId()%>">
		      <input type="hidden" name="createdBy" value="<%=nodeDTO.getCreatorId()%>">
		    </tr>
	  <% } 
		} %>
		</hr>
		</table>
		<table border="0" cellspacing="0" cellpadding="0" width="1005">
		    <tr>
		      <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  	        </tr>
			<tr>
			 <td width=137><br>
				&nbsp;&nbsp;&nbsp;<input name="delNodes" type="button" style="border:0;background : url(images/buttons/delete_nodes.gif);width:112px; height:22px;" class="button-01" value="" onclick="javascript:deleteNodes()"></td>
			 <td align="left" colspan="6">
			 <% if (programs != null && programs.size() != 0) { %>&nbsp;
			 <% } %>
			 </td> 
			 <td width="5">&nbsp;</td>
			</tr>
	    </table>
	    </div>
	    <div class="clean" style="height:40px"></div>
	    <div class="producttext" style="height:40px">
		    <div class="myexpertplan">
		      <table width="100%">
		        <tr style="color:#4C7398">
		        <td align="left">
		          <div class="myexperttext"><% if(nodeDTO1!= null) { %>Edit<% } else {%>Add<%}%> Segment</div>
		        </td>
		        </tr>
		      </table>
		    </div>
		    
		    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
			      <td colspan="6" width="0">&nbsp;</td>
			  	</tr>  		
			  	<tr>
				  <td width="10">&nbsp;</td>
		  		  <td width="115" class="expertPlanHeader">Segment Name <sup> * </sup></td>		  			   
				  <td>				
				    <input id="parentName" name="parentName" type="text" class="field-blue-01-180x20" maxLength="50" value="<%=(nodeDTO1 != null && nodeDTO1.getParentName() != null) ? nodeDTO1.getParentName() : ""%>">	
				  </td>	     			    				    
				  <td width="10" height="20">&nbsp;</td>
				  <td width="120" align="right" class="expertPlanHeader">Description</td>		  			    
				  <td>				
				    <input name="description" type="text" class="field-blue-01-180x20" maxLength="50" value="<%=(nodeDTO1 != null && nodeDTO1.getDescription() != null) ? nodeDTO1.getDescription() : ""%>">	
				  </td>	     			    				    
		 	  </tr>
			  <tr>
			      <td colspan="6" width="0">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="6" width="100%" height="1" align="left" valign="top">
					<% 
					if(programs != null && programs.size() >0 && nodeDTO1 != null) {
						for (int i=0;i<programs.size();i++) {
					      NodeDTO nodeDTO2 = (NodeDTO)programs.get(i);
						  if(nodeDTO1.getSegmentId() == nodeDTO2.getSegmentId()) {
							  nodeDTO1.setChildPresent(nodeDTO2.getChildPresent());
							  break;			  
						  }
						}
					 }
					%>
					<input name="strategyLevel" type ="checkbox" class="field-blue-04-50x20" value="true"
					<% if(nodeDTO1 != null && "YES".equalsIgnoreCase(nodeDTO1.getChildPresent())) {%> disabled <%}%> 
					<% if(nodeDTO1 != null && "true".equalsIgnoreCase(nodeDTO1.getStrategyLevel())) {%> disabled checked <%}%>
					<% if(nodeDTO1 != null && !"YES".equalsIgnoreCase(nodeDTO1.getChildPresent())) {%> disabled <%}%>
					<% if(session.getAttribute("parentName") != null && !"".equals((String)session.getAttribute("parentName")) 
						&& "Root Node".equalsIgnoreCase((String)session.getAttribute("parentName"))) {%> disabled <%}%>
					 onclick="disableTaFaRegion()">
					<span class="expertPlanHeader">Strategy Level</span>
				</td>
			 </tr>	
	
			 <tr>
				<td>
				<div  id="nonTaFaRegion" style="display:block"> 
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  		<tr>
		    		  <td width="1" height="1">&nbsp;</td>
				  	</tr>
		  		</table>
		  		</div> 
			  	</td>
		  	 </tr>
	  		
		     <tr>
		        <td colspan="6" width="100%" height="1" align="left" valign="top">
		        <div id="taFaRegion" style="display:none">    
		          <table width="100%"  border="0" cellspacing="0" cellpadding="0">			
					<tr>
					 <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
			  	    </tr>
			
			  		<tr>
				      <td width="10" height="1">&nbsp;</td>
				  	</tr>

		  	<tr>
			  <td width="10"></td> 	
	  		  <td width="120" class="expertPlanHeader">Therapeutic Area<sup>*</td>		  			   
			  <td width="190">				
				 <select name="ta" class="field-blue-01-180x20">
				  <option value="-1">Please select</option>			 
				  <%
					  String val ="";
					if (taLookup1 != null && taLookup1.length > 0) {
						OptionLookup lookup = null;
						isAlreadySelected = false;
						for (int i = 0; i < taLookup1.length; i++) {
							lookup = taLookup1[i];
							val = String.valueOf(lookup.getId());
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
				  %>
					<option value="<%=lookup.getId()%>" <% if ( (nodeDTO1 != null) && (nodeDTO1.getTaId() != null) 
							&& (nodeDTO1.getTaId().equals(val)) )  { 
						isAlreadySelected = true;
						%> selected <% } 
					else if(!isAlreadySelected){%><%=selected%> <%} %>  > <%=lookup.getOptValue()%></option>
				  <%
						}
					}
				  %>          
				  </select>	
			  </td>	     			    				    
			  <td width="10" height="20">&nbsp;</td>
			  <td width="120" class="expertPlanHeader">Functional Area<sup> *</td>		  			    
			  <td width="190">				
				 <select name="fa" class="field-blue-01-180x20">
				  <option value="-1">Please select</option>
				  <%
					if (faLookup1 != null && faLookup1.length > 0) {
						OptionLookup lookup = null;
						isAlreadySelected = false;
						for (int i = 0; i < faLookup1.length; i++) {
							lookup = faLookup1[i];
							val = String.valueOf(lookup.getId());
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
				  %>
					<option value="<%=lookup.getId()%>" <% if ( (nodeDTO1 != null) && (nodeDTO1.getFaId() != null) 
							&& (nodeDTO1.getFaId().equals(val)) )  { 
						isAlreadySelected = true;
						%> selected <% } 
					else if(!isAlreadySelected){%><%=selected%> <%} %> ><%=lookup.getOptValue()%></option>
				  <%
						}
					}
				  %>          
				  </select>	
			  </td>	    		    				    
	 	    </tr>
	
			<tr>
		      <td colspan="6" width="0">&nbsp;</td>
		  	</tr>
	
		  	<tr>
			  <td width="10"></td> 	
	  		  <td width="115" class="expertPlanHeader">Region <sup> *</td>		  			   
			  <td>				
				 <select name="region" class="field-blue-01-180x20">
				  <option value="-1">Please select</option>			 
				  <%
					if (regionLookup1 != null && regionLookup1.length > 0) {
						OptionLookup lookup = null;
						isAlreadySelected = false;
						for (int i = 0; i < regionLookup1.length; i++) {
							lookup = regionLookup1[i];
							val = String.valueOf(lookup.getId());
                     		String selected = "" ;
                      		if(lookup.isDefaultSelected())
                      			selected = "selected";
				  %>
					<option value="<%=lookup.getId()%>" 
					<% if ( (nodeDTO1 != null) && (nodeDTO1.getRegionId() != null) 
							&& (nodeDTO1.getRegionId().equals(val)) )  { 
							isAlreadySelected = true;
							%> selected <% } 
							else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
				  <%
						}
					}
				  %>          
				  </select>	
			  </td>	     			    				    
			  <td width="10" height="20">&nbsp;</td>
			  <td width="95" class="text-blue-01-bold">&nbsp;</td>		  			    
			  <td>&nbsp;</td>	     
	 	    </tr>

	  	    <tr>
		      <td colspan="6" width="2" height="">&nbsp;</td>
		  	</tr>
	  	  </table>
  		 </div>
  		</td>
  		</tr>
  		
		<tr>
		    <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  	    </tr>
		<tr height="30">
		  <td width="5">&nbsp;</td>
		  <td colspan="5">
		  <%      if(nodeDTO1 != null) { %>
					  <input name="editNode" type="button" style="border:0;background : url(images/buttons/save_segment.gif);width:123px; height:23px;" class="button-01" value="" onclick="javascript:saveNodes(this.form,'<%=CONTEXTPATH%>',<%=nodeDTO1.getSegmentId()%>,<%=nodeDTO1.getParentId()%>)">&nbsp;&nbsp;&nbsp;&nbsp;<input name="cancelNode" type="button" style="border:0;background : url(images/buttons/cancel.gif);width:75px; height:23px;" class="button-01" value="" onClick="cancelNodeSegment(<%=nodeDTO1.getParentId()%>);">						
          <%      } else { %>
					  <input name="addNode" type="button" style="border:0;background : url(images/buttons/add_segment.gif);width:115px; height:22px;" class="button-01" value="" onclick="javascript:addNodes()">
		 <%       }     %>		
				
				 
		  </td>
		</tr>
   </table>	
   </div>
   </div>
   
   </form>
<%}%>
 

<% session.removeAttribute("NODES_FOR_PARENT_ID");
   session.removeAttribute("EDIT_NODE_INFO");
%>
</body>
</html>

<script>
disableTaFaRegion();
</script>
	    

