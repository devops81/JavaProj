<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file = "imports.jsp" %>
<%@page import = "com.openq.kol.NodeDTO,
				  com.openq.kol.MainObjectiveDTO"%>

<HTML>
<HEAD>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>Brand Objectives</TITLE>
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

function show_calendar(sName) {
	gsDateFieldName=sName;	
	var winParam="top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
	if (document.layers)	
		winParam="top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
	window.open("jsp/Popup/PickerWindow.htm","_new_picker",winParam);
}

function copySelected(fromObject,toObject) 
{
	 var k;
	 l=fromObject.options.length;
	 to=toObject.options.length;


	 for (var i=0;i<l;i++)
	 {
		if (fromObject.options[i].selected)
		{
			myval=(fromObject.options[i].value)
			for  (var j=0;j<to;j++)
				{
					toval=(toObject.options[j].value)
					k=(myval==toval? true:false);
					if(k) break;
				}
			if(!k)
				{
					addOption(toObject,fromObject.options[i].text,fromObject.options[i].value);
				}
		}
	}
	for (var j=0;j<toObject.options.length;j++)
	{
		toObject.options[j].selected=true;
	}				
			 
}

	function deleteOption(object,index)
	{
		object.options[index] = null;
	}

	function addOption(object,text,value) {
		var defaultSelected = true;
		var selected = true;
		var optionName = new Option(text, value, defaultSelected, selected)
		object.options[object.length] = optionName;
	}

	function deleted(fromObject)
	{
		
		 l=fromObject.options.length
		for (var i=fromObject.options.length-1;i>-1;i--) {
		if (fromObject.options[i].selected)
		deleteOption(fromObject,i);
		}	
	}


</script>
<script type="text/javascript" src="./js/sorttable.js"></script>
</head>

<%	
	ArrayList segmentObjectiveList = new ArrayList();

	if(session.getAttribute("SEGMENT_OBJECTIVE") != null) 
		segmentObjectiveList = (ArrayList) session.getAttribute("SEGMENT_OBJECTIVE");

	ArrayList mainObjectiveList = new ArrayList();

	if(session.getAttribute("MAIN_OBJECTIVES") != null)
		mainObjectiveList = (ArrayList) session.getAttribute("MAIN_OBJECTIVES");

%>


<body>
 <form name="KOLKeyMsg" method="POST">
  <table width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>              
		<jsp:include page="kol_menu.jsp" flush="true"/>
	  </td>
	</tr>
	</table>
	<div class="producttext">
    	<div class="myexpertlist">
      		<table width="100%">
        		<tr style="color:#4C7398">
        		    <td width="5%"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
        			<td width="50%" align="left">
          				<div class="myexperttext">Brand Objective</div>
        			</td>
        		</tr>
           </table>
         </div>
         <table width="100%" cellspacing="0" class="sortable">
      		<tr bgcolor="#faf9f2">
      			<td width="1%">&nbsp;</td>
				<td width="25%" class="expertListHeader">Main Objective</td>
				<td width="1%">&nbsp;</td>
		        <td width="30%" class="expertListHeader">Organization</td>
				<td width="1%">&nbsp;</td>
				<td width="22%" class="expertListHeader">Segment Used</td>
				<td width="1%">&nbsp;</td>
				<td width="22%" class="expertListHeader">Segment Strategy</td>
     		 </tr>

  
     
  

	
	<% 
	    
		for(int i=0;i < segmentObjectiveList.size(); ++i) {
			
			String objectiveName = "";

			NodeDTO  segmentDTO = (NodeDTO) segmentObjectiveList.get(i);
			String mainObjectives = segmentDTO.getSegmentObjective();
			if(mainObjectives != null && !mainObjectives.equals("0")) {
    			 StringTokenizer str = new StringTokenizer(mainObjectives, ",");
				 int changeCount = 0;
				 while (str.hasMoreTokens()) {					    
					    int mainObjectiveId = Integer.parseInt(str.nextToken());
						for(int j=0;j<mainObjectiveList.size();++j) {
							MainObjectiveDTO mainObjectiveDTO = (MainObjectiveDTO) mainObjectiveList.get(j);
							if(mainObjectiveId == mainObjectiveDTO.getId()) {
								if(changeCount == 0) {
									objectiveName = mainObjectiveDTO.getMainObjective();							
								} else {
									objectiveName = objectiveName +","+mainObjectiveDTO.getMainObjective();	
								}			  
		                    }
				        }
				        changeCount++;
			     }
		    }		  
	  %>
	  <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
	      <td width="1%">&nbsp;</td>
		  <td width="25%" height="25" align="left" class="text-blue-01"><%=objectiveName != null ? objectiveName : ""%></td>
		  <td width="1%">&nbsp;</td>
		  <td width="31%" align="left" class="text-blue-01"><%=segmentDTO.getCountryName() != null ? segmentDTO.getCountryName() : ""%></td>
		  <td width="1%">&nbsp;</td>
		  <td width="23%" align="left" class="text-blue-01"><%=segmentDTO.getSegmentName() != null ? segmentDTO.getSegmentName() : ""%></td>
		  <td width="1%">&nbsp;</td>
	      <td width="23%" align="left" class="text-blue-01"><%=segmentDTO.getStatedStrategy() != null ? segmentDTO.getStatedStrategy() : ""%></td>
	  </tr>
	  

	<%
	    }
	%>
	

   </table>
  </div>




</form>
</body>
</html>

