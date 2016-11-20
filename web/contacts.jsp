<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@ page language="java" %>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%  String selectedTab=request.getParameter("selected")==null ?"":request.getParameter("selected");
    String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");
	String prettyPrint = null != request.getParameter("prettyPrint1") ? (String) request.getParameter("prettyPrint1") : null ;
	String parentId=request.getParameter("parentId");
	if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onclick="javascript:window.close()"></span>&nbsp;&nbsp;<span class="text-blue-01-bold" onclick="javascript:window.print()"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/></span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>
<%  Contacts editContact = (Contacts) request.getSession().getAttribute("editContact");
	OptionLookup [] contactType = (OptionLookup []) request.getSession().getAttribute("contactType");
	String message = (String) request.getSession().getAttribute("message");
    OptionLookup userType = null != session.getAttribute(Constants.USER_TYPE) ? (OptionLookup)session.getAttribute(Constants.USER_TYPE) : null;
    long userTypeId = null != userType  ? userType.getId() : 0;
    System.out.println("station 1");
    OptionLookup roleLookup[] = null;
    if (session.getAttribute("contactRole")!= null) {
        roleLookup = (OptionLookup[]) session.getAttribute("contactRole");
    }
    boolean isAlreadySelected = false;
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
function toggleAlertMode() {
	

		var iconName = document.getElementById('_alertIcon').src.toString();
		if (iconName.indexOf('disabled') > 0) {


			if (confirm("Please confirm that you would like to recieve e-mail when '" + "Affiliations" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {

				document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
			
				alert("E-mail alerts for '" + "Affiliations" + "' of <%=currentKOLName%> activated.");
				setCookie("Affiliations" + entityId, "enabled", 15);
				//alert(document.getElementById('_alertIcon').src);
			}
		} else {
			if (confirm("Please confirm that you would not like to recieve e-mail when '" + "Contacts" + "' of " + " <%=currentKOLName%> changes. Press OK to confirm.")) {
				document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
				alert("E-mail alerts for '" + "Contacts" + "' of <%=currentKOLName%> de-activated.");
				eraseCookie("Contacts" + entityId);
				//alert(document.getElementById('_alertIcon').src);
			}
		}
	}



	/*var attrId = <c:out escapeXml="false" value="${selectedTab}"/>;
	var entityId = <c:out escapeXml="false" value="${entityId}"/>;
	var parentId = <c:out escapeXml="false" value="${parentId}"/>;*/
	/*var "Contacts" = <%=selectedTab%>*/

	function addAttendee(empName, empPhone, empEmail,empId,empRole,empType){
		document.contacts.contactName.value=empName;
		document.contacts.phone.value = empPhone;
		document.contacts.email.value = empEmail;
		document.contacts.staffId.value = empId;
            document.contacts.contactRole.value=empRole;
            document.contacts.contactType.value=empType;

	}

    function addORXName(valueFromChild) {
		alert(valueFromChild);
		document.contacts.contactName.value = valueFromChild;
	}

function deleteContact(kolId){

 var thisform =window.frames['contactsList'].contactsListForm;
 var flag =false;
 for(var i=0;i<thisform.elements.length;i++){
  
  if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
   flag =true;
   break;  
  }
 } 
 thisform.action = "contacts.htm?kolId=" + kolId;
 if(flag){
  thisform.target="inner";
  if(confirm("Do you want to delete the selected contact?")){
  thisform.submit();
  }
 }else {
  alert("Please select atleast one contact to delete");
 }

}
    function saveData(){
        var thisform = document.contacts;
        
     if (!isEmpty(thisform.contactName, "Contact Name")){
       alert("Enter the contact name");
       thisform.contactName.focus();
       return false;
       }
     if (thisform.contactRole.value==''){
       alert("Enter the role");
       thisform.contactName.focus(); 
       return false;
      }

     if (!isEmpty(thisform.phone, "Phone")){ thisform.phone.focus(); return false;}
     if (!emailCheck(thisform.email.value))
     {
        alert("Please enter valid  Email Address");
        thisform.email.focus();
        return false;
     }

        thisform.submit();
    }


</script>
</head>

<body>
<div class="producttext">
<form name="contacts" method="post" AUTOCOMPLETE="OFF">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" id="responseBlock">
   <tr>
     <td height="20" align="left" valign="top">
      <div class="myexpertlist">
	      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr align="left" valign="middle" style="color:#4C7398">
	          <td width=100% valign="middle">
	          	 <div class="myexperttext"><%=DBUtil.getInstance().customer%> Contacts</div>
	          </td>
	        </tr>
	     </table>
     </div>
    </td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
<% if(message != null){ %>  
  <tr>
    <td height="1" align="left" valign="top" class="back-white"><font face ="verdana" size ="2" color="red"><b><%=message%></b></font></td>
  </tr>
<% } %>
  <tr>
    <td>
     <table width="98%">
      <tr bgcolor="#faf9f2">
        <td width="5%">&nbsp;</td>
        <td width="18%" class="expertListHeader">Name</td>
        <td width="18%" class="expertListHeader">Phone</td>
        <td width="18%" class="expertListHeader">E-Mail</td>
        <td width="15%" class="expertListHeader">Role</td>
        <td width="15%" class="expertListHeader">Comment</td>
        <td width="11%"></td>
      </tr>
    </table>
   </td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="100" align="left" valign="top" class="back-white">    
     <iframe name="contactsList" src="contacts_list.jsp?kolId=<%=request.getParameter("kolId")%>&currentKOLName=<%=request.getParameter("currentKOLName")%>&parentId=<%=request.getParameter("parentId")%>" height="100%" width="100%" frameborder="0" scrolling="yes"></iframe>
    </td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>  
  
  <tr>
    <td height="30" align="left" valign="top" class="back-white">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="5" height="30">&nbsp;</td> 
          <td><input name="Submit" type="button" style="border:0;background : url(images/buttons/delete_contacts.gif);width:127px; height:23px;" class="button-01"  onClick="deleteContact(<%=request.getParameter("kolId")%>);"></td>
          <td>&nbsp;</td>
          <td width="10">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
  
<% if(request.getParameterValues("editContactId") == null) {%>  
	
	<tr>
     <td height="20" align="left" valign="top">
      <div class="myexpertplan">
	      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr align="left" valign="middle" style="color:#4C7398">
	          <td width=100% valign="middle">
	          	 <div class="myexperttext">Add New Contact</div>
	          </td>
	        </tr>
	     </table>
     </div>
    </td>
  </tr>
	
  <tr>  
    <td height="120" align="left" valign="top" class="back-white">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  height="20">&nbsp;</td>
          <td  class="text-blue-01">Name *</td>
          <td  class="text-blue-01">Phone Number *</td>
          <td  class="text-blue-01">E-Mail *</td>
          <td  class="text-blue-01">Role *</td>
          <td  class="text-blue-01">Comment </td>
        </tr>
                 
        <tr>
          <td><input type="hidden" name="staffId"/></td>
          <td  class="text-blue-01">
            <input name="contactName" type="text" class="field-blue-01-180x20" maxlength="25" readonly/>
          </td> 
          <td   class="text-blue-01-link">
			<input name="phone" type="text" class="field-blue-01-180x20" readonly/>
          </td>
          <td  class="text-blue-01"> 
            <input name="email" type="text" class="field-blue-01-180x20" readonly />
          </td>
          <td  class="text-blue-01">
          <select name="contactRole" class="field-blue-01-180x20"
                >
            <%
                if (roleLookup != null && roleLookup.length > 0) {
                    OptionLookup rolesLookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < roleLookup.length; i++) {
                        rolesLookup = roleLookup[i];
                		String selected = "" ;
                  		if(rolesLookup.isDefaultSelected())
                  			selected = "selected";

            %>
            <option value="<%=rolesLookup.getOptValue()%>" <%if(editContact != null &&
                    editContact.getRole() == rolesLookup.getOptValue()) {
            	isAlreadySelected = true;
                    %> selected <%} 
                    else if(!isAlreadySelected){%> <%=selected %> <%} %>><%=rolesLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>

        <td  class="text-blue-01">
            <input name="contactType" type="text" class="field-blue-01-180x20" />
        </td>

        <%--/td>
          <td  align="left" valign="top">
          <select name="contactType" class="field-blue-01-180x20"
                >
            <%
                if (contactType != null && contactType.length > 0) {
                    OptionLookup typesLookup = null;
                    for (int i = 0; i < contactType.length; i++) {
                        typesLookup = contactType[i];

            %>
            <option value="<%=typesLookup.getOptValue()%>" <%if(editContact != null &&
                    editContact.getType() == typesLookup.getOptValue()) {%> selected <%}%>><%=typesLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>

          </td--%>
          <td class="text-blue-01">&nbsp;</td>
      </tr>
      <tr>
        <td height="10" colspan="6"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
      </tr>             
      <tr>
        <td height="20">&nbsp;</td>
<td valign="left"><A href="#"  onclick="javascript:window.open('employee_search.htm','searchLDAP','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');" class="text-blue-01-link" >Lookup Employee</A></td>
        <td valign="top"></td>
 
        <td>&nbsp;</td>
        <td valign="top">&nbsp;</td> 
        <td valign="top">&nbsp;</td>        
      </tr>          
    </table>
   </td>
  </tr>

<% } else { %>

  <tr> 
     <td height="20" align="left" valign="top">
      <div class="myexpertplan">
	      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr align="left" valign="middle" style="color:#4C7398">
	          <td width=100% valign="middle">
	          	 <div class="myexperttext">Edit Contact</div>
	          </td>
	        </tr>
	     </table>
     </div>
   </td>
  </tr>
  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>

  <tr>  
    <td height="120" align="left" valign="top" class="back-white">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        
          <tr>
          <td  height="20">&nbsp;</td>
          <td  class="text-blue-01">Name *</td>
          <td  class="text-blue-01">Phone Number *</td>
          <td  class="text-blue-01">E-Mail *</td>
          <td  class="text-blue-01">Role*</td>
          <td  class="text-blue-01">Type*</td>
          </tr>
                        
        <tr>
          <td  height="20">&nbsp;<input type="hidden" name="staffId" value='<%=editContact.getStaffid()%>'/></td>
          <td  class="text-blue-01">
            <input name="contactName" value='<%=editContact.getContactName()%>' type="text" class="field-blue-01-180x20" maxlength="25"/>
          </td> 
          <td  class="text-blue-01">
			<input name="phone" value='<%=editContact.getPhone()%>' type="text" class="field-blue-01-180x20"/>
          </td>
          <td  class="text-blue-01"> 
            <input name="email" value='<%=editContact.getEmail()%>' type="text" class="field-blue-01-180x20" />
          </td>
          <td valign="top" class="text-blue-01">
        	<select name="contactRole" class="field-blue-01-180x20"
                >
            <%
                if (roleLookup != null && roleLookup.length > 0) {
                    OptionLookup rolesLookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < roleLookup.length; i++) {
                        rolesLookup = roleLookup[i];
                		String selected = "" ;
                  		if(rolesLookup.isDefaultSelected())
                  			selected = "selected";

            %>
            <option value="<%=rolesLookup.getOptValue()%>" <%if(editContact != null &&
                    editContact.getRole() == rolesLookup.getOptValue()) {
            	isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected) {%> <%=selected %> <%} %>><%=rolesLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>
    	</td>
    	<%--
          
          <td class="text-blue-01">
             <input name="role" value='<%=(editContact.getRole()==null?"":editContact.getRole())%>' type="text" class="field-blue-01-180x20" />
          </td>
         -------------  end here
		<td valign="top" class="text-blue-01">
        	<select name="contactType" class="field-blue-01-180x20"
                >
            <%
                if (contactType != null && contactType.length > 0) {
                    OptionLookup typesLookup = null;
                    for (int i = 0; i < contactType.length; i++) {
                        typesLookup = contactType[i];

            %>
            <option value="<%=typesLookup.getOptValue()%>" <%if(editContact != null &&
                    editContact.getType() == typesLookup.getOptValue()) {%> selected <%}%>><%=typesLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
        </select>
    	</td>
          --%>
        <td  class="text-blue-01">
            <input name="contactType" value='<%=editContact.getType() %>' type="text" class="field-blue-01-180x20" />
        </td>



            <%--
		          
          <td  class="text-blue-01">
              <input name="contactType" value='<%=(editContact.getType()==null?"":editContact.getType())%>' type="text" class="field-blue-01-180x20" />
          </td>
      --%></tr>
      <tr>
        <td height="10" colspan="6"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
      </tr>            

      <tr>
        <td height="20">&nbsp;</td>  
        <td valign="top"><A href="#"  onclick="javascript:window.open('employee_search.htm','searchLDAP','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');" class="text-blue-01-link" >Lookup Employee</A></td>
        <td>&nbsp;</td>
        <td class="text-blue-01" valign="top">&nbsp;</td> 
        <td class="text-blue-01">&nbsp;</td>             
        <td valign="top">&nbsp;<input name="editContact" value='<%=editContact.getContactId()%>' type="hidden"/></td>
        <td valign="top">&nbsp;</td>
      </tr>           
    </table>
   </td>
  </tr>

<% } %>

  <tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td height="30" align="left" valign="top" class="back-white"><table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="5" height="30">&nbsp;</td>
        <td>
           <input name="Submit2" type="button" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" class="button-01" onClick="saveData()">
        </td>  
        <td width="10">&nbsp;</td>	
        <td><input name="Submit22" type="hidden" class="button-01" value="Cancel Edit" onClick="javascript:cancel(this.form, '<%=CONTEXTPATH%>');"></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">&nbsp;</td>
	 <table>
      <td width=80%>&nbsp;</td>
	<%if (!"true".equalsIgnoreCase(prettyPrint) ) {%>

      <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %>
                 <td valign="top" align="right" width="67" style="cursor:hand"
                     >
					<a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>
<img src='images/vCard.jpg' border=0 height="32" title="Download Vcard"></a><br>
					<a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>
					Vcard</a></td><%}%>
      <% String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
  		 boolean isSAXAJVUser = false;
		 if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
			isSAXAJVUser = true;
		 }
		 String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
			boolean isOTSUKAJVUser = false;
			if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
				isOTSUKAJVUser = true;
			}
      if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") &&
    		  !isSAXAJVUser && !isOTSUKAJVUser)
                 { %><td width="8">&nbsp;</td>
                 <td valign="top" align="right" width="37" style="cursor:hand" class="text-blue-link"
                     onClick="javascript:window.open('printFullProfile.htm?entityId=<%=request.getParameter("parentId")%>&currentKOLName=<%=request.getParameter("currentKOLName")%>')">
                    						<a class="text-blue-link" href="#" > <img src='images/print_profile.gif' border=0 height="32" title="Printer friendly format"/><br>
Profile</a>

                 </td>
                 <% } %>     
	<td width="39" height="30" onclick="window.open('contacts.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint=true')" align=center><a class="text-blue-link" href="#"><img src='images/print.gif' border=0 height="32" title="Printer friendly format"/><br>
		Print</a></td>
        <td width="4"></td>

        </td>  
        <td valign="top" align="top" width="45" onclick='toggleAlertMode()' style="cursor:hand">
					<img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes.' /><br><a class="text-blue-link" href="#">
		Notify</a></td>
<tr>
<td valign="top" align="right"  height="30" width="67" style="cursor:hand">&nbsp;</td>
                 <td valign="top" align="right" width="8" style="cursor:hand"
                     >
					&nbsp;</td>
     <td valign="middle" align="right" width="5">&nbsp;</td>
     <td width="8" height="30" onclick="window.open('contacts.htm?kolId=' + <%=request.getSession().getAttribute("KOLID")%> + '&prettyPrint1=true')">&nbsp;</td>
        <td width="39">&nbsp;</td>

        <td valign="top" align="top" width="4" onclick='toggleAlertMode()' style="cursor:hand">
					&nbsp;</td>
</tr>
		</table><%}%></td>
      
      </tr>
    </table>
  </tr> 
</table>
</td>
</tr>
</form>
</div>
</body>
</html>

