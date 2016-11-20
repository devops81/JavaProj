<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.eav.trials.TrialOlMap"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.user.User"%>

<html>

<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>

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

<script  src="<%=COMMONJS%>/validation.js" language="JavaScript"></script>
<script  src="<%=COMMONJS%>/formChangeCheck.js" language="JavaScript"></script>

<script language="JavaScript">

	function addOL(name, phone, email, kolId, position, division, year) {
		document.trial_to_ol_map.olName.value=name;
		document.trial_to_ol_map.olId.value=kolId;
	}
	 function saveol(){
	   var thisform=document.trial_to_ol_map;
	   
	   if(thisform.olName.value.length==0){
	     alert("Please enter the Name");
	     return false
	     }
	   if(thisform.role.value.length==0){
	     alert("Please enter the role");
	     return false
	     }
	   if(thisform.institution.value.length==0){
	     alert("Please enter the Institution");
	     return false
	     }
	     
	   thisform.submit();
	}

    function addORXName(valueFromChild) {
		alert(valueFromChild);
		document.oltrialmap.olName.value = valueFromChild;
	}

function deleteOL(trialId) {

 var thisform =document.trial_to_ol_map;
 var flag =false;
 for(var i=0;i<thisform.elements.length;i++){
  
  if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
   flag =true;
   break;  
  }
 } 
 thisform.action = "trial_to_ol_map.htm?entityId=" + trialId;
 if(flag){
  thisform.target="inner";
  if(confirm("Do you want to delete the selected affiliated <%=DBUtil.getInstance().doctor%>?")){
  thisform.submit();
  }
 }else {
  alert("Please select atleast one contact to delete");
 }
}

</script>
</head>

<body >
<form name="trial_to_ol_map" method="post" AUTOCOMPLETE="OFF">

 
  
  <div class="producttext">
    <div class="myexpertlist">
      <table width="100%">
        <tr style="color:#4C7398">
        <td width=1%>
         <div style="float:right"><img src="images/addpic.jpg"></div>
        </td>
        <td width="50%" align="left">
          <div class="myexperttext">Affiliated <%=DBUtil.getInstance().doctor%>s</div>
        </td>
        
        </tr>
      </table>
    </div>
    <table width="100%" cellspacing="0">
      <tr bgcolor="#faf9f2">
	      <td width="5%">&nbsp;</td>
	      <td width="40%" class="expertListHeader">Name</td>
	      <td width="30%" class="expertListHeader">Role</td>
	      <td width="25%" class="expertListHeader">Institution</td>
      </tr>
      <%
     
		User [] user = (User [])request.getSession().getAttribute("user");
		TrialOlMap [] trialOlMapArray = (TrialOlMap []) request.getSession().getAttribute("trialOlMapArray");

      if(user != null && user.length != 0) { for(int i=0;i<user.length;i++){ %>
	  
	       <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
	         <td width="5%" height="25" align="center">
	           <input type="checkbox" name="checkedOl" value="<%=trialOlMapArray[i].getId()%>"/>
	         </td>
	         
			 <td width="40%" class="text-blue-01" align="left" ><a target='_top' href="expertfullprofile.htm?kolid=<%=user[i].getId()%>&entityId=<%=user[i].getKolid()%>&currentKOLName=<%=user[i].getLastName()%>, <%=user[i].getFirstName()%>"><%=user[i].getLastName()%>, <%=user[i].getFirstName()%></a></td>	        
			 <td width="30%" class="text-blue-01" align="left" ><%=((trialOlMapArray[i].getRole()==null)?"":trialOlMapArray[i].getRole())%></td>
			 <td width="25%" class="text-blue-01" align="left" ><%=(trialOlMapArray[i].getInstitution()==null?"":trialOlMapArray[i].getInstitution())%></td>
	      </tr>
	    
	  <% } } %>
        
      
      <tr>
          
	      <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;<input name="Submit" type="button" style="border:0;background : url(images/buttons/delete_expert.gif);width:117px; height:23px;" class="button-01" value="" onClick="deleteOL(<%=request.getParameter("entityId")%>);"></td>
	      <td ></td>
	      <td ></td>
      </tr>
      </table>
      </div>
      <div class="clean"></div>
      <br/>
  <!-- Add expert from here -->
  <div class="producttext">
    <div class="myexpertplan">
      <table width="100%">
        <tr style="color:#4C7398">
        <td align="left">
          <div class="myexperttext">Add <%=DBUtil.getInstance().doctor%></div>
        </td>
        </tr>
      </table>
    </div>
    <div style="height:200; overflow:auto;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-white">
	 		<tr>
		        <td width="20" valign="top">&nbsp;</td>
		        <td class="expertPlanHeader">Name*</td>
		        <td class="expertPlanHeader">Role*</td>
		         <td class="expertPlanHeader">Institution*</td>
		         <td class="expertPlanHeader">&nbsp;<input name="trialId" type="hidden" value="<%=request.getParameter("entityId")%>"/></td>
		        <td align="left" valign="top">&nbsp;</td>
		        <td class="expertPlanHeader">&nbsp;</td>
    	    </tr>
            <tr>
	          <td width="20" >&nbsp;<input type="hidden" name="olId" value="-1"/></td>
	          <td class="text-blue-01-link">
	            <input name="olName" type="text" class="field-blue-01-180x20" maxlength="25" readonly/>
	          </td> 
	          <td class="text-blue-01-link">
				<input name="role" type="text" class="field-blue-01-180x20" />
	          </td>
	          <td class="text-blue-01-link"> 
	            <input name="institution" type="text" class="field-blue-01-180x20" />
	          </td>
	          <td>&nbsp;<input name="trialId" type="hidden" value="<%=request.getParameter("entityId")%>"/></td>
	          <td align="left" valign="top">&nbsp;</td>
	          <td>&nbsp;</td>
            </tr>
	      <tr>
	        <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	      </tr>             
	      <tr>
	        <td height="20">&nbsp;</td>  
	        <td  valign="top"><!--input name="olSearch" type="button" style="border:0;background : url(images/button3.jpg);width:98px; height:23px;" class="button-01" value="<%=DBUtil.getInstance().doctor%> Search" onClick="javascript:window.open('OL_Search.htm','searchopenQ','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');"-->
			<A href="#"  onClick="javascript:window.open('OL_Search.htm','searchopenQ','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-link" >Lookup <%=DBUtil.getInstance().doctor%></A>
			</td>
	        <td>&nbsp;</td>  
	        <td>&nbsp;</td>
	        <td class="text-blue-01">&nbsp;</td>             
	        <td valign="top">&nbsp;</td>
	        <td valign="top">&nbsp;</td>        
	      </tr>
	      <tr>
	        <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	      </tr>      
		  <tr>
	        <td height="20">&nbsp;</td>  
	        <td valign="top"><input name="Submit2" type="button" style="border:0;background : url(images/buttons/add_expert.gif);width:80px; height:22px;" class="button-01" value="" onClick="saveol()"></td>
	        <td>&nbsp;</td>  
	        <td>&nbsp;</td>
	        <td class="text-blue-01">&nbsp;</td>             
	        <td valign="top">&nbsp;</td>
	        <td valign="top">&nbsp;</td>        
	      </tr>
      </table>
      </div>
    </div>
</form>
</body>
</html>

