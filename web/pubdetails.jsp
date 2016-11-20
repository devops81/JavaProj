<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--
 *
 * To Populate  all the imports files for URLs and Packages
 *
 -->
<%@ page import="com.openq.publication.data.Publications" %>

<%
Publications publicationsDTO;
publicationsDTO = (Publications )request.getSession().getAttribute("pubDetail");
%>







<html>
<head>
<title>Publication Detailts</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="css/openq.css" rel="stylesheet" type="text/css">
<script  src="js/validation.js" language="JavaScript"></script>
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
</head>

<body class="back-blue-02-light">
<form name="DuplicateExpertForm" method="POST" AUTOCOMPLETE="OFF">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td colspan="3" height="10" align="left" valign="top"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td height="20" width="100%" align="left" valign="top" class="back_horz_head">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">

			<tr align="left" valign="middle">
				<td width="1%" height="20">&nbsp;</td>
				<td width="3%"><img src="images/icon_my_expert_brown.gif" width="14" height="14"></td>
				<td class="text-white-bold">Title</td>
			</tr>
			<tr>
				<td colspan="3" height="1" align="left" valign="top"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>

		</table>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td width="100%" height=54  class="back-white">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
			<tr>

				<td height="4"><img src="images/transparent.gif" width="10" height="4"></td>
			</tr>
			<tr>
				<td colspan="3" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>
		</table>
		<div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll" >
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" height=100%>
			<tr>
				<td width="2%">&nbsp;</td>
				<td align="center" class="text-blue-01">  <%=publicationsDTO.getTitle() %></td>
			</tr>
		</table>

		</div>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>

		<td colspan="3" height="10"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td colspan="3" height="10" align="left" valign="top"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td height="20" width="100%" align="left" valign="top" class="back_horz_head">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">

			<tr align="left" valign="middle">
				<td width="1%" height="20">&nbsp;</td>
				<td width="3%"><img src="images/icon_my_expert_brown.gif" width="14" height="14"></td>
				<td class="text-white-bold">Authors</td>
			</tr>
			<tr>
				<td colspan="3" height="1" align="left" valign="top"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>

		</table>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td width="100%" height=54  class="back-white">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
			<tr>

				<td height="4"><img src="images/transparent.gif" width="10" height="4"></td>
			</tr>
			<tr>
				<td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>
		</table>
		<div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll" >
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" height=100%>
			<tr>
				<td width="2%">&nbsp;</td>
				<td align="center" class="text-blue-01">   <%=publicationsDTO.getAuthors() %></td>
			</tr>
		</table>

		</div>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="10" align="left" valign="top"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td height="20" width="100%" align="left" valign="top" class="back_horz_head">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">

			<tr align="left" valign="middle">
				<td width="1%" height="20">&nbsp;</td>
				<td width="3%"><img src="images/icon_my_expert_brown.gif" width="14" height="14"></td>
				<td class="text-white-bold">Institutions</td>
			</tr>
			<tr>
				<td colspan="3" height="1" align="left" valign="top"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>

		</table>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td width="100%" height=54  class="back-white">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
			<tr>

				<td height="4"><img src="images/transparent.gif" width="10" height="4"></td>
			</tr>
			<tr>
				<td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>
		</table>
		<div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll" >
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" height=100%>
			<tr>
				<td width="2%">&nbsp;</td>
				<td align="center" class="text-blue-01">   <%=publicationsDTO.getInstitution() %></td>
			</tr>
		</table>

		</div>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="10" align="left" valign="top"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td colspan="3" height="10" align="left" valign="top"><img src="images/transparent.gif" width="10" height="10"></td>
	</tr>
	<tr>
		<td width="1%">&nbsp;</td>
		<td height="20" width="100%" align="left" valign="top" class="back_horz_head">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr align="left" valign="middle">
				<td width="1%" height="20">&nbsp;</td>
				<td width="3%"><img src="images/icon_my_expert_brown.gif" width="14" height="14"></td>
				<td class="text-white-bold">Abstract</td>

			</tr>
		</table>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="1" align="left" valign="top"><img src="images/transparent.gif" width="1" height="1"></td>
	</tr>
	<tr>

		<td width="1%">&nbsp;</td>
		<td height="210" align="left" valign="top" class="back-white">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
			<tr>
				<td height="4"><img src="images/transparent.gif" width="10" height="4"></td>
			</tr>
			<tr>
				<td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			</tr>

		</table>
		<div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll;" >
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-white" height="100%">
			<tr align="justify">
				<td width="2%">&nbsp;</td>
				<td align="justify" class="text-blue-01">  <%=publicationsDTO.getAbstractPublication() %></td>
				<td width="1%">&nbsp;</td>
			</tr>

			<tr>
				<td colspan="3" height="10"><img src="images/transparent.gif" width="10" height="10"></td>
			</tr>
		</table>
		</div>
		</td>
		<td width="1%">&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" height="1">&nbsp;</td>
		<td>
		</td>
		<td></td>
	</tr>
	<tr>
		<td width="1%" height="30">&nbsp;</td>

		<td class="back-white">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="1%">&nbsp;</td>
				<td align="center"><input type="button" value="  Close  "  class="button-01" onclick="window.close()"></td>
			</tr>
		</table>
		</td>
		<td>&nbsp;</td>

	</tr>
</table>
</form>
</body>
</html>