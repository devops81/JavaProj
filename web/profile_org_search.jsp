<%@ include file = "imports.jsp" %>

<%@ page import="com.openq.eav.org.Organization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	Organization[] orgArray = null;
	if (session.getAttribute("orgs") != null) {
		orgArray = (Organization[]) session.getAttribute("orgs");
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
	function searchOrg() {
		var thisform = document.orgSearchForm;
		thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.SEARCH_ORG_ON_PROFILE%>";
		thisform.submit();
	}

	function setParentTextBox() {
		var radioObj = document.orgSearchForm.selectedOrg;

		var value = getCheckedValue(radioObj);

		window.opener.addSelectedOrg(value);
		window.close();
	}

	function  getCheckedValue(radioObj) {
		if(!radioObj)
			return "";
		var radioLength = radioObj.length;
		if (radioLength == undefined)
			if(radioObj.checked)
				return radioObj.value;
			else
				return "";
		for(var i = 0; i < radioLength; i++) {
			if(radioObj[i].checked) {
				return radioObj[i].value;
			}
		}
		return "";
}

</script>

</head>

<body>
<form name="orgSearchForm" method="post">
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10" class="back-blue-02-light">&nbsp;</td>
    <td class="back-blue-02-light"><div>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
              <td width="15" height="20">&nbsp;</td>
              <td width="35"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="text-white-bold">Organization Search</td>
            </tr>
          </table></td>
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
			  <td width="190"><input name="searchText"  value="" type="text" class="field-blue-01-180x20" maxlength="50" /></td>
              <td><input name="Submit332" type="button" class="button-01" value="        Search        " onclick="javascript:searchOrg()" /></td>
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
          <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
              <td width="15" height="20">&nbsp;</td>
              <td width="40"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="text-white-bold">Organization Search Results</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
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
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  
                  	<% 
                  	if (orgArray != null && orgArray.length > 0) { 
                  		Organization org = null;
                  		for (int i=0;i<orgArray.length;i++) { 
                  		org = (Organization) orgArray[i];
                  	%>
	                    <tr <% if (i%2 != 0) { %> class="back-grey-02-light" <% } %> >
    	                  <td width="15" height="20" valign="top">&nbsp;</td>
        	              <td width="35" valign="middle" class="text-blue-01">
        	              	<input type="radio" name="selectedOrg" value="<%=("org;" + org.getEntityId() + ";" + org.getName() + ";" + org.getAcronym() + ";" + org.getType())%>">
        	              </td>
            	          <td valign="middle" width="300" class="text-blue-01-link"><%=( org.getName() != null ? org.getName() : "")%></td>
                	      <td valign="middle" class="text-blue-01" width="200"> <%=( org.getAcronym() != null ? org.getAcronym() : "")%> </td>
                    	  <td valign="middle" class="text-blue-01"> <%= (org.getCountry() != null ? org.getCountry() : "") %></td>
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
              <td class="text-blue-01" width="20"><input name="Submit333" type="button" class="button-01" value=" Add " onclick="javascript:setParentTextBox()"/></td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01"><input name="Submit334" type="button" class="button-01" value="         Close         " onclick="javascript:window.close()" /></td>
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
</form>
</body>
</html>
<%
	session.removeAttribute("orgs");
%>