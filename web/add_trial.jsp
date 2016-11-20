<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.eav.trials.TrialsConstants"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.utils.PropertyReader"%>

<script type="text/javascript">

function addTrial() {
if (window.frames['addNewTrial'].checkRequiredFields()) {
	window.frames['addNewTrial'].editProfileAttributesForm.action.value = "createTrial";
	window.frames['addNewTrial'].editProfileAttributesForm.target = "_top";
	window.frames['addNewTrial'].editProfileAttributesForm.submit();
	}
}


</script>


<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
   <div class="producttext" style=width:95%>
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=100%>
		<tr>		
			<td valign="top" align="center" class="">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		   <tr>
		   <td height="20" align="left" valign="top" class="">
			<div class="myexpertlist" style=width:100%>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		          <tr align="left" valign="middle" style="color:#4C7398">
		              <td width="2%">&nbsp;</td>
		              <td width="2%"><img src="images/icon_search.gif" width="14" height="14" /></td>
		              <td width="2%" class="myexperttext">Add Trial</td>
		            </tr>
		      </table>
			</div>
		   </td>
 		   </tr>
			<tr>
			<td height="350" align="left" valign="top" class="back-white"><iframe src='editProfileAttributes.htm?attributeId=<%=TrialsConstants.TRIAL_INFO_ATTRIB_ID%>&entityId=-1&parentId=-1' height="100%" vspace=0 hspace=0 width="100%" name="addNewTrial" id="addNewTrial" frameborder="0" scrolling="auto"></iframe></td>
		    </tr>
		    <tr>
			  <td class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
		    </tr>
		    <tr height="30">
		      <td class="back-white" valign="middle">&nbsp;<input type="button" name="saveTrials" style="border:0;background : url(images/buttons/save_trial.gif);width:94px; height:22px;" value="" onclick="javascript:addTrial()"/></td>
		    </tr>
		</table>
	</td></tr>
</table>
</div>
<%@ include file="footer.jsp" %>

</body>
</html>
