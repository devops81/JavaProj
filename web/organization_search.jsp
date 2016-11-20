<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.eav.org.Organization" %>
<% 
	Organization [] organization = (Organization []) request.getSession().getAttribute("organization");
%>
<script language="javascript">
function setParentTextBox(id, orgName, country) {
	window.opener.addOrg(id, orgName, country);
}

function check(){
			document.searchOrg.searchText.value = 
				checkAndReplaceApostrophe(document.searchOrg.searchText.value);
	}

</script>


<html>
<head>
<script type="text/javascript" src="js/utilityFunctions.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Search Organization</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->

</style></head>

<body>
<form name="searchOrg" method="post" onSubmit="check()">
<div class="producttext" style=width:100%>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10" class="back-white">&nbsp;</td>
    <td class="back-white">
	<div class="myexpertlist" style=width:100%>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Organization Search </td>
            </tr>
            </table>
		</div>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-white">
        <tr>
          <td height="10" align="left" valign="top">&nbsp;</td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
       
        <tr>
          <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
       
        <tr>
          <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="100" class="text-blue-01-bold">Organization</td>
			  <td width="190"><input name="searchText" type="text" class="field-blue-01-180x20" maxlength="50" /></td>
			  <td>
				<input name="search" type="submit"  style="border:0 none;background:url('images/buttons/search_orgs.gif');width:108px; height:22px"  onclick="javascript:searchOrg()" class="button-01" value=""  /></td>
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
          <td height="20" align="left" valign="top">
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
          <td height="10" align="left" class="back-white">
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr bgcolor="#f5f8f4">
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="30" valign="middle" class="text-blue-01-bold" align="right"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
              <td valign="middle" class="text-blue-01-bold" width="40">&nbsp;</td>
              <td valign="middle" class="text-blue-01-bold" width="299">Name</td>
              <td valign="middle" class="text-blue-01-bold">Location</td>
              </tr>
            <tr>
              <td colspan="6" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
		  
                <div style="height:200px; overflow:auto;">
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <%if(organization != null){if(organization.length > 0){ for(int i=0;i<organization.length;i++){ 
					  String orgName = organization[i].getName() ;
					  orgName = orgName.replaceAll("'","\\\\'");%>
                    <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
                      <td width="15" height="20" valign="top">&nbsp;</td>
                      <td width="25" valign="middle"><input name="radiobutton" type="radio" value="radiobutton" onClick="javascript:setParentTextBox('<%=organization[i].getEntityId()%>', '<%=orgName%>', '<%=organization[i].getType()%>')" /></td>
                      <td width="40" valign="middle" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
                      <td valign="middle" class="text-blue-01" width="300"><%=organization[i].getName()%></td>
                      <td valign="middle" class="text-blue-01"><%=organization[i].getCountry()%></td>
                    </tr>
                  <% } } else {%>
                  
                    <tr>
                      <td valign="middle" colspan="5" class="text-blue-01-red"> No result Found</td>
                    </tr>
                    <tr>
                      <td valign="middle" colspan="5" class="text-blue-01-red">&nbsp;</td>
                    </tr>
                   <% } }%>
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
          <td height="10" align="left" valign="top" class="back-white"><input name="Submit334" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onclick="javascript:window.close()" /><span class="text-blue-01">
            </span></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
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
<div>
</form>
</body>
</html>