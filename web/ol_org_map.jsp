<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.user.HomeUserView"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.eav.expert.ExpertDetails"%>

<%
	ExpertDetails [] myOL = (ExpertDetails[]) request.getSession().getAttribute("myOL");
	OptionLookup [] contactType = (OptionLookup []) request.getSession().getAttribute("contactType");
%>

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

	function addOL(name, phone, email,id, position, division, year) {
		document.olorgmap.olName.value=name;
		document.olorgmap.phone.value = phone;
		document.olorgmap.email.value = email;
		document.olorgmap.olId.value = id;
		document.olorgmap.position.value = position;
		document.olorgmap.division.value = division;
		document.olorgmap.year.value = year;
	}
	 function saveol(){
	   var thisform=document.olorgmap;

	   if(thisform.olName.value.length==0){
	     alert("Please enter the Name");
	     return false
	     }
	    /* if(thisform.phone.value.length==0){
	     alert("Please enter the contact type");
	     return false
	     }
	     if(thisform.email.value.length==0){
	     alert("Please enter the contact info");
	     return false
	     }*/
	     thisform.submit();
	}

    function addORXName(valueFromChild) {
		alert(valueFromChild);
		document.olorgmap.olName.value = valueFromChild;
	}

function deleteOL(orgId) {

 var thisform =document.olorgmap;
 var flag =false;
 for(var i=0;i<thisform.elements.length;i++){

  if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
   flag =true;
   break;
  }
 }
 thisform.action = "ol_org_map.htm?entityId=" + orgId;
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
<form name="olorgmap" method="post" AUTOCOMPLETE="OFF">



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
        <td><% boolean prettyprint=false;
        String pprint=request.getParameter("prettyPrint");
        if(pprint!=null && pprint.equalsIgnoreCase("true"))
        prettyprint=true;
        if(prettyprint){
        %>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="right">
	      <span class="text-blue-01-bold" onclick="javascript:window.print()">
	        <img src='images/print.gif' align=middle border=0 height="32"/>
	      </span>
	    </td>
	  </tr>
	</table>
<%
   }
%>



        </td>

        </tr>
      </table>
    </div>
    <table width="100%" cellspacing="0" scrolling="yes">
      <tr bgcolor="#faf9f2">
	      <td width="5%">&nbsp;</td>
	      <td width="20%" class="expertListHeader">Name</td>
	      <td width="20%" class="expertListHeader">Contact Type</td>
	      <td width="15%" class="expertListHeader">Contact Info</td>
	      <td width="15%" class="expertListHeader">Position</td>
	      <td width="15%" class="expertListHeader">Division</td>
	      <td width="10%" class="expertListHeader">Year</td>
      </tr>
	</table>
<div class="producttext" style=width:100%;height=150;overflow:auto>
    <table width="100%" cellspacing="0" scrolling ="yes">

	  <%

		User [] user = (User [])request.getSession().getAttribute("user");
		Long [] orgolMapId = (Long []) request.getSession().getAttribute("orgolMapId");
	  if(user != null && user.length != 0) { for(int i=0;i<user.length;i++){ %>

	       <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
	         <td width="5%" height="25" align="center">
	           <input type="checkbox" name="checkedOl" value="<%=orgolMapId[i]%>"/>
	         </td>

			 <td width="20%" class="text-blue-01-link" align="left" > <A class=text-blue-01-link target='_top' href="expertfullprofile.htm?kolid=<%=user[i].getId()%>&entityId=<%=user[i].getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=user[i].getLastName()%>, <%=user[i].getFirstName()%>"><%=user[i].getLastName()%>, <%=user[i].getFirstName()%></A></td>
	         <td width="20%" class="text-blue-01-link" align="left">
		        <%=user[i].getPreferredContactType()==null?"":user[i].getPreferredContactType()%></td>
			 <td width="15%" class="text-blue-01" align="left">
		         <%=user[i].getPreferredContactInfo()==null?"":user[i].getPreferredContactInfo()%></td>
	         <td width="15%" class="text-blue-01" align="left"><%=user[i].getPosition()==null?"":user[i].getPosition() %></td>
	         <td width="15%" class="text-blue-01" align="left"><%=user[i].getDivision()==null?"":user[i].getDivision() %></td>
			 <td width="10%" class="text-blue-01" align="left"><%=user[i].getYear()==null?"":user[i].getYear() %></td>

	      </tr>

	  <% } } %>
	  </table>
 </div>
      <table width="100%" cellspacing="0" scrolling="yes">
      <tr>

          <td width="5%">&nbsp;&nbsp;&nbsp;<input name="Submit" type="button" style="border:0;background : url(images/buttons/delete_expert.gif);width:85px; height:22px;" class="button-01" value="" onClick="deleteOL(<%=request.getParameter("entityId")%>);"></td>
	      <td width="20%" >&nbsp;</td>
	      <td width="20%" ></td>
	      <td width="15%" ></td>
	      <td width="15%" ></td>
	      <td width="15%" ></td>
	      <td width="10%" ></td>
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
		        <td width="2%" valign="top">&nbsp;</td>
		        <td class="expertPlanHeader" width="36%">Name*</td>
		        <td class="expertPlanHeader" width="24%">Contact Type</td>
		         <td class="expertPlanHeader" width="29%">Contact Info</td>
		        <td class="expertPlanHeader">&nbsp;<input name="orgId" type="hidden" value="<%=request.getParameter("entityId")%>"/></td>
		        <td align="left" valign="top">&nbsp;</td>
		        <td class="expertPlanHeader">&nbsp;</td>
    	    </tr>
            <tr>
	          <td width="2%" >&nbsp;<input type="hidden" name="olId"/></td>
	          <td class="text-blue-01-link" width="36%">
	            <input name="olName" type="text" class="field-blue-01-180x20" maxlength="25" readonly/><font color="#ffffff">te</font><a href="#"  onclick="javascript:window.open('OL_Search.htm','searchopenQ','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-link">Lookup <%=DBUtil.getInstance().doctor%></a>
	          </td>
	          <td class="text-blue-01-link" width="24%">
				<input name="phone" type="text" class="field-blue-01-180x20" />
	          </td>
	          <td class="text-blue-01-link" width="29%">
	            <input name="email" type="text" class="field-blue-01-180x20" />
	          </td>
	            <input name="orgId" type="hidden" value="<%=request.getParameter("entityId")%>"/></td>
	          <td align="left" valign="top">&nbsp;</td>
	          </tr>
      		<tr>
		        <td height="20" valign="top">&nbsp;</td>
		        <td class="expertPlanHeader" width="36%">Position</td>
		        <td class="expertPlanHeader" width="24%">Division</td>
		        <td class="expertPlanHeader" width="29%">Year</td>
		        <td class="expertPlanHeader">&nbsp;</td>
		        <td class="expertPlanHeader">&nbsp;</td>
		        <td class="expertPlanHeader">&nbsp;</td>
    	   </tr>

           <tr>
	          <td width="2%" >&nbsp;</td>
	          <td  class="text-blue-01-link" width="36%">
				<input name="position" type="text" class="field-blue-01-180x20" />
	          </td>
	          <td  class="text-blue-01-link" width="24%">
				<input name="division" type="text" class="field-blue-01-180x20" />
	          </td>
	           <td  class="text-blue-01-link" width="29%">
				<input name="year" type="text" class="field-blue-01-180x20" />
	          </td>
	          <td class="text-blue-01">&nbsp;<input name="orgId" type="hidden" value="<%=request.getParameter("entityId")%>"/></td>
	          <td align="left" valign="top">&nbsp;</td>
	          <td class="text-blue-01">&nbsp;</td>
          </tr>
	      <tr>
	        <td height="10" colspan="6"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	      </tr>
	      <tr>
	        <td height="20">&nbsp;</td>
	        <td  valign="top" width="36%">
	        <td width="24%">&nbsp;</td>
	        <td width="29%">&nbsp;</td>
	        <td class="text-blue-01">&nbsp;</td>
	        <td valign="top">&nbsp;</td>
	        <td valign="top">&nbsp;</td>
	      </tr>
	      <tr>
	        <td height="10" colspan="6"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
	      </tr>
		  <tr>
	        <td height="20">&nbsp;</td>
	        <td valign="top" width="36%"><input name="Submit2" type="button" style="border:0;background : url(images/buttons/add_expert.gif);width:80px; height:22px;" class="button-01" value="" onClick="saveol()"></td>
	        <td width="24%">&nbsp;</td>
	        <% if(!prettyprint) {%>
 		<td valign="middle" align="right" style="cursor:hand" onClick="javascript:window.open('ol_org_map.htm?entityId=82619332&prettyPrint=true')" width="29%"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br><a class="text-blue-link" href="#">Print</a></td>
		 <td width="1%" height="30">&nbsp;</td>
	 <td valign="middle" align="right" width="3%" onclick='javascript:toggleAlertMode()' style="cursor:hand"><img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">Notify</a></td><%}%>
	 <td width="1%" height="30">&nbsp;</td>


	        <td class="text-blue-01" width="1%">&nbsp;</td>
	        <td valign="top" width="1%">&nbsp;</td>
	        <td valign="top" width="1%">&nbsp;</td>
	      </tr>
      </table>
      </div>
    </div>




</form>
</body>
</html>
