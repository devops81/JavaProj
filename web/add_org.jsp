<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.utils.PropertyReader"%>

<script type="text/javascript">

function addOrg() {
if (window.frames['addNewOrg'].checkRequiredFields()) {
	window.frames['addNewOrg'].editProfileAttributesForm.action.value = "createOrg";
	window.frames['addNewOrg'].editProfileAttributesForm.submit();
	}
}


</script>


<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>
   <br>
   <br>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
   <div class="producttext" style=width:100%>

	<table border=0 cellspacing=0 cellpadding=0 width=100% height=100%>
		<tr>		
			<td height="250" align="center" valign="top" class="">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		   <tr>
		   <td width="1300" height="20" align="left" valign="top" class="">
			<div class="myexpertlist" style=width:100%>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		          <tr align="left" valign="middle" style="color:#4C7398">
		              
		              <td width="1%"><img src="images/icon_search.gif" width="14" height="14" /></td>
		              <td width="96%" align=justify class="myexperttext">Add Organization</td>
	              </tr>
		      </table>
			</div>
		   </td>
 		   </tr>
			<tr>
			<td height="404" align="left" valign="top" class="back-white"><iframe src='editProfileAttributes.htm?attributeId=<%=PropertyReader.getEavConstantValueFor("ORG_PROFILE")%>&entityId=-1&parentId=-1' height="100%" vspace=0 hspace=0 width="100%" name="addNewOrg" id="addNewOrg" frameborder="0" scrolling="auto"></iframe></td>
		    </tr>
		    <tr>
			  <td class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
		    </tr>
		    <tr height="40">
		      <td class="back-white" valign="middle">&nbsp;<input name="Submit334" type="button" style="border:0 none;background : url('images/buttons/save_organization.gif');width:139px; height:23px" class="button-01" value="" onClick="javascript:addOrg()"/></td>
		    </tr>
		</table>
	</td></tr>
</table>
</div>
<%@ include file="footer.jsp" %>

</body>
</html>
