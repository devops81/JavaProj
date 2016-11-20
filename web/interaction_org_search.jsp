<%@ include file = "imports.jsp" %>

<%@ page import="com.openq.eav.org.Organization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ include file = "UserCheck.jsp" %>

<%
	Organization[] orgArray = null;
	if (request.getAttribute("orgs") != null) {
		orgArray = (Organization[]) request.getAttribute("orgs");
	}
    String searchText = null;
    if (session.getAttribute("SEARCH_TEXT") != null) {
		searchText = (String) session.getAttribute("SEARCH_TEXT");
	}
    String fromAdvSearch = null;
    if (session.getAttribute("FROM_ADV_SEARCH") != null) {
		fromAdvSearch = (String) session.getAttribute("FROM_ADV_SEARCH");
	}


%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="js/utilityFunctions.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Organization Search</title>
<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
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

<script>
	function deleteAllRowsFromTable(tableId){
	     var table = document.getElementById(tableId);
	     if(table != null && 
	     	table != undefined && 
	     	table.rows != null &&
	     	table.rows != undefined){
		     for(var i = table.rows.length - 1; i > -1; i--){
		      	table.deleteRow(i);
		     }
		 }
	}
	function searchOrg() {
		var thisform = document.orgSearchForm;
		thisform.searchText.value = checkAndReplaceApostrophe(thisform.searchText.value)
		thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.SEARCH_ORG%>";
		thisform.submit();
	}

	function setParentTextBox() {
		var arrayOfcheckedOrg = new Array();
		var isRadioChecked = false;
        if (orgSearchForm.checkedOrg != null){
			for (var i = 0;i < orgSearchForm.checkedOrg.length;i++){
				if (orgSearchForm.checkedOrg[i].checked){
					isRadioChecked = true;
					arrayOfcheckedOrg.push(orgSearchForm.checkedOrg[i].value);
					break;
				}
			}
			if(!isRadioChecked && orgSearchForm.checkedOrg.checked){
				isRadioChecked = true;
				arrayOfcheckedOrg.push(orgSearchForm.checkedOrg.value);
			}
			if(isRadioChecked){
				deleteAllRowsFromTable('orgSearchResults');
				document.forms['orgSearchForm'].reset();
				
				if(window.opener.addORXName(arrayOfcheckedOrg)) {
					alert('Organization added successfully');
				}
				
			}else{
				alert('Please select an Organization first');
			}
		}
	}
</script>

</head>

<body>
<form name="orgSearchForm" method="post" action = "javascript:searchOrg();">
<div class="producttext" style=width:100%>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10" class="">&nbsp;</td>
    <td class="">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="">
		<div class="myexpertlist" style=width:100%>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Organization Search</td>
            </tr>
            </table>
		</div>
	   </td>
        </tr>
        <tr>
          <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="100" class="text-blue-01-bold">Organization</td>
			  <td width="190"><input name="searchText"  type="text" class="field-blue-01-180x20" maxlength="50" /></td>
              <td><input name="Submit332" type="button"  style="border:0;background:url(images/buttons/search_orgs.gif);width:108px; height:22px;"  onclick="javascript:searchOrg()" class="button-01"  /></td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="">
		<div class="myexpertplan" style=width:100%>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Organization Search Results</td>
            </tr>
          </table>
		</div>
		</td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr bgcolor="#f5f8f4">
              <td width="15" height="20" valign="top">&nbsp;</td>
              <td width="35" valign="middle" class="text-blue-01-bold">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="300">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="200">Acronym</td>
              <td valign="middle" class="text-blue-01-bold">Location</td>
            </tr>
            <tr>
              <td colspan="6" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
                <div style="height:200px; overflow:auto;">
                  <table id="orgSearchResults" width="100%"  border="0" cellspacing="0" cellpadding="0">
                  
                  	<% 
                  	if (orgArray != null && orgArray.length > 0) { 
                  		Organization org = null;
                  		for (int i=0;i<orgArray.length;i++) { 
                  		org = (Organization) orgArray[i];
                  	%>
	          		<tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
				<td width="15" height="20" valign="top">&nbsp;</td>
        	              <td width="35" valign="middle" class="text-blue-01">
        	              	<input type="radio" name="checkedOrg" value="<%=("org;" + org.getEntityId() + ";" + org.getName())%>">
        	              </td>
            	          <td valign="middle" width="300" class="text-blue-01"><%= org.getName() %> </td>
                	      <td valign="middle" class="text-blue-01" width="200"> <%= org.getAcronym()%> </td>
                    	  <td valign="middle" class="text-blue-01"> <%= (org.getCity()!= null)?org.getCity():"" %>
                    	  <%String temp=null; 
                    	  	if(org.getState()!=null && org.getState()!="" && org.getCity()!=null && org.getCity()!="")
                    	  		temp = ",";
                    	   %>
                    	  <%=temp!=null?temp:"" %>
                    	  <%= ((org.getState()!= null)?org.getState():"") %>
                    	   </td>
	                    
	                    </tr>
					<% 
						} // end of for
					} // end of if
					%>
                  </table>
                </div></td>
        </tr>
        <tr>
          <td align="left" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20"><input name="Submit333" type="button" style="border:0;background : url(images/buttons/add_organization.gif);width:136px; height:23px;" class="button-01" value="" onclick="javascript:setParentTextBox()"/></td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01"><input name="Submit334" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onclick="javascript:window.close()" /></td>
            </tr>
            
            
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"></td>
        </tr>
      </table>
    </div></td>
  </tr>
</table>
</div>
</form>
</body>
<%
    session.removeAttribute("SEARCH_TEXT");
%>
</html>
