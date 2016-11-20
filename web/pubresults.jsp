<html>
<%@ page import="com.openq.publication.data.OlPublicationSummaryDTO" %>
<%@ page import="com.openq.kol.DBUtil"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">


<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript">
	function help() {
		alert("For demonstration purpose only. All links are just placeholders.");
	}

</script>
<SCRIPT TYPE="text/javascript">
<!--
function popup(mylink, windowname)
{
if (! window.focus)return true;
var href;
if (typeof(mylink) == 'string')
   href=mylink;
else
   href=mylink.href;
window.open(href, windowname, 'fullscreen=yes,scrollbars=yes,resizable = 1');
return false;
}
//-->
</SCRIPT>


<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
    <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
    }

    -->
</style>
<%
OlPublicationSummaryDTO [] olPublicationSummaryDTO;
olPublicationSummaryDTO = (OlPublicationSummaryDTO [])request.getSession().getAttribute("olPublicationSummaryDTOArray");

%>
</head>

<body class="back-blue-02-light" >
<div align="center">
<table class="back-white" border="0" cellpadding="0" cellspacing="0" width="100%" height="422">
	<tr>
     <td class="myexpertplan" align="left" height="22" valign="top">
     <table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
      <tbody>
	<tr align="left" valign="middle" style="color:#4C7398">
        <td height="22" width="2%">&nbsp;</td>
        <td width="2%" height="22"><img src="images/icon_my_expert.gif" height="14" width="14"></td>
        <td class="myexperttext" height="22">Profile Capture - Publications 
		Results <i>(Hover over Links For More Details)</i></td>
      </tr>
     </tbody></table></td>
    </tr>
	
    <tr>
    <td height="340">    <div style="position:relative;width: 99%;height: 340px;overflow-x:scroll;overflow-y:scroll" align=center>

    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
		<tbody><tr class="" align="left" valign="middle">
			<td align="center" height="25" width="3%">&nbsp;</td>
			<td class="text-blue-01-bold" width="3%">SL.No.</td>
			<td class="text-blue-01-bold" height="25" width="1%">&nbsp;</td>
			<td class="text-blue-01-bold-link" height="25" width="10%">
			<a class="text-blue-01-bold-link" title="LastName, FirstName Intial" href="#">
			<%=DBUtil.getInstance().doctor%> Name </a></td>
			<td class="text-blue-01-bold-link" width="11%"><a class="text-blue-01-bold-link" title="Commited Publications" href="#">
			Publications in Profile </a></td>
			<td class="text-blue-01-bold-link" height="25" width="11%"><a class="text-blue-01-bold-link" title="UnCommited Publications" href="#">
			Total Uncommitted Publications&nbsp;</a></td>
			<td class="text-blue-01-bold-link" height="25" width="11%"><a class="text-blue-01-bold-link" title="Last Captured Publications" href="#">
			New Publications</a></td>
			<td class="text-blue-01-bold-link" height="25" width="11%"><a class="text-blue-01-bold-link" title="Last Captured Date" href="#">
			Last Profile Capture </a></td>
			<td class="text-blue-01-bold-link" height="25" width="12%"><a class="text-blue-01-bold-link" title="Last Profile Update Date" href="#">
			Last Profile Update</a></td>
			<td class="text-blue-01-bold" height="25" width="10%" align="center">&nbsp;
			</td>
		
		</tr>
	<%if (olPublicationSummaryDTO !=null && olPublicationSummaryDTO.length>0){
	 for(int i=0; i<olPublicationSummaryDTO.length;i++){ 
	     if(i%2==0) {
	%>
		<tr align="left" valign="middle">
	<% }else { %>
		<tr class="back-blue-02-light" align="left" valign="middle">
	<% }%>
			<td align="center" height="19" width="3%">&nbsp;</td>
			<td align="left" width="2%"><img src="images/icon_my_expert.gif" height="14" width="14"></td>
			<td class="text-blue-01" align="center" width="3%"><%=i+1 %> </td>
			<td class="text-blue-01" align="center" height="19" width="1%">&nbsp;</td>
			<td class="text-blue-01" align="left" height="19" width="25%">
			<a class="text-blue-01-link" title="Show all Publications" target="_blank" href="pubexpert.htm?page=<%=olPublicationSummaryDTO[i].getExpertId()%>" onClick="return popup(this, 'bhaskar')">
			<%=olPublicationSummaryDTO[i].getExpertName() %></a></td>
			<td class="text-blue-01" width="11%"><%=olPublicationSummaryDTO[i].getPublicationInProfile() %></td>
			<td class="text-blue-01" height="19" width="11%"><%=olPublicationSummaryDTO[i].getTotalUncommitedPublications() %></td>
			<td class="text-blue-01" height="19" width="11%"><%=olPublicationSummaryDTO[i].getNewPublications() %></td>
			<td class="text-blue-01" height="19" width="11%"><%=olPublicationSummaryDTO[i].getLastCapture() %></td>
			<td class="text-blue-01" height="19" width="12%"><%if(olPublicationSummaryDTO[i].getLastUpdate() !=null) %><%=olPublicationSummaryDTO[i].getLastUpdate() %> </td>
			<td class="text-blue-01" align="center" height="19" width="10%">&nbsp;</td>
		</tr>
		<% } }%>
	
	</tbody></table>
	</div>
    </td></tr>
    <tr>
    <td>    <table>	<form name="refresh" >
		<tr align="left" valign="middle"><input type="button" style="border:0 none;background : url('images/buttons/refresh.gif');width:80px; height:22px"  onclick="javascript:submit()">
			<td align="center">
                </td>
			<td align="center">&nbsp;
               </td>

			<td align="center" width="0"></td>
		</tr>
		</form>
    </table>
    </td></tr>
</table>
</div>
</body>

</html>