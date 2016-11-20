<html>
<%@ page import="com.openq.publication.data.Publications" %>
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
window.open(href, windowname, 'width=800,height=600,scrollbars=yes,resizable = 1');
return false;
}
//-->
</SCRIPT>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
 <style>   <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
    }
-->
    
</style>
<%
Publications [] olPublicationsDTO;
olPublicationsDTO = (Publications [])request.getSession().getAttribute("olPublicationSummaryDTOArray");
String olName = (String)request.getSession().getAttribute("olName");
String olLocation = (String)request.getSession().getAttribute("olLocation");
String olSpeciallity =(String) request.getSession().getAttribute("olSpeciality");
String olUpdate =(String) request.getSession().getAttribute("lastUpdate");
String olUpdater =(String) request.getSession().getAttribute("lastUpdater");
%>

<title>Publication Results</title>

</head>

<body class="back-blue-02-light"   >
<div align=center>
<form name="OlPublications" method="Post" AUTOCOMPLETE="OFF">
<table class="back-white" border="0" cellpadding="0" cellspacing="0" width="100%" height="382">
  <tr>
          <td class="back-blue-01-dark" align="left" height="2" valign="top" colspan="3">
          <img src="transparent.gif" height="2" width="2"></td></tr>
        

        <tr>
     <td class="back_horz_head" align="left" height="22" valign="top" colspan="3">
     <table border="0" cellpadding="0" cellspacing="0" width="100%" height="22">
      <tbody><tr align="left" valign="middle">
        <td height="22" width="10">&nbsp;</td>
        <td width="25" height="22">
		<img src="images/icon_my_expert.gif" height="14" width="14"></td>
        <td class="text-white-bold" height="22">Profile Capture - <%=DBUtil.getInstance().doctor%> Details</td>
      </tr>
     </tbody></table></td>
    </tr>
    <tr>
    <td class="back-blue-02-light" colspan="3">
	<div align="center">
		<table border="0" cellpadding="0" width="100%" style="border-collapse: collapse" bordercolor="#111111">
                        <tr class="back-blue-02-light" >
                            <td height="31" align="left" width="145">
                                </td>
                            <td height="31" align="left" width="7">
                                </td>
                            <td height="31" align="left" width="194">
                                <a class="text-blue-01-bold" href="#"
                                  >
								<%=DBUtil.getInstance().doctor%> Name</a></td>
                            <td height="31" align="center" width="306">
                            <p class="text-blue-01-bold" align="left"><span style="font-weight: 400">
							&nbsp;<%=olName %>   (<%=olPublicationsDTO.length %> 
							Pubs)</span></td>
                            <td class="text-blue-01-bold" height="31" align="left" width="194">
                                &nbsp;</td>
                            <td class="text-blue-01-bold" height="31" align="left" width="916">
                            &nbsp;</td>
                        </tr>
                        <tr class="back-white">
                            <td class="text-blue-01-bold" height= "31" align="left" width="145">
                                </td>
                            <td class="text-blue-01-bold" height= "31" align="left" width="7">
                                </td>
                            <td class="text-blue-01-bold" height= "31" align="left" width="194">
                                Location</td>
                            <td class="text-blue-01-bold" height="31" align="left" width="306">
                            <span style="font-weight: 400">&nbsp;<%=olLocation %></span></td>
                              <td class="text-blue-01-bold" height="31" align="left" width="194">
                                Specialty</td>
                            <td class="text-blue-01-bold" height="31" align="left" width="916">
                            <span style="font-weight: 400">&nbsp;<%=olSpeciallity  %> </span>
                            </td>
                        </tr>
                        <tr class="back-blue-02-light">
                            <td class="text-blue-01-bold" height="1" align="left" width="145">
                                </td>
                            <td class="text-blue-01-bold" height="1" align="left" width="7">
                                </td>
                            <td class="text-blue-01-bold" height="1" align="left" width="194">
                                </td>
                            <td class="text-blue-01-bold" height="1" align="left" width="916" colspan="3">
                            </td>
                        </tr>
                    </table></div>
	</td></tr>
   <tr class="back_horz_head" align="left" valign="middle">
        <td height="22" width="10">&nbsp;</td>
        <td width="25" height="22">
		<img src="images/icon_my_expert.gif" height="14" width="14"></td>
        <td class="text-white-bold" height="22">Profile Capture - <%=DBUtil.getInstance().doctor%> 
		Publications <i>(Hover over Links For More Details) </i></td>
      </tr>
    
    <td colspan="3" height="270" align="center" valign="top" class="back-white"> 

     
    <div style="position:relative;width: 99%;height: 426px;overflow-x:scroll;overflow-y:scroll" align=center>
    <table border="1" width="100%" cellspacing="0" cellpadding="0">
		<tr class="back-grey-02-light">
			<td class="text-blue-01-bold" width="11" height="19">SL.No.</td>
			<td class="text-blue-01-bold" width="45" height="19">&nbsp;Commit</td>
			<td class="text-blue-01-bold" width="351" height="19">&nbsp; Title</td>
			<td class="text-blue-01-bold" width="162" height="19">&nbsp;Journal</td>
			<td class="text-blue-01-bold" width="210" height="19">&nbsp;Citation</td>
			<td class="text-blue-01-bold" width="71" height="19">&nbsp;Year</td>
			<td class="text-blue-01-bold"  width="100" height="19">&nbsp; ISSN</td>
			<td class="text-blue-01-bold"  width="121" height="19">&nbsp;Unique 
			Identifier</td>
		</tr>
		
		<tr class="back-blue-03-medium"  height="1">
   			<td align="center" height="1" width="11" colspan="5"></td>
		</tr>
		 

<% 
if ( olPublicationsDTO != null && olPublicationsDTO.length > 0 )
{
for (int i=0; i<olPublicationsDTO.length;i++)
{

	if(i%2==0) {
%>
		<tr align="left" valign="middle">
<%   }else { %>
		<tr class="back-blue-02-light" align="left" valign="middle">
<%  } %>
<td width="11" align="center"><%=i+1 %></td>
			<td width="45" align="center"><input type="checkbox" name="checkcomitvalue<%=olPublicationsDTO[i].getPublicationId() %>"  <% if(olPublicationsDTO[i].getCommit_flag()>0){%>checked="checked"<% }%> />
			</td>
			<td width="351">
			<a class="text-blue-01-link" title="Show Abstract" target="_blank" href="pubdetails.htm?page=<%=olPublicationsDTO[i].getPublicationId()%>" onClick="return popup(this, 'bhaskarg')">
			<%=(olPublicationsDTO[i].getTitle()!= null ?olPublicationsDTO[i].getTitle():" NA ")  %></a></td>
			<td width="162"><%=(olPublicationsDTO[i].getJournalName()!=null?olPublicationsDTO[i].getJournalName():" NA ") %></td>
			<td width="210"><%=(olPublicationsDTO[i].getSource()!= null?olPublicationsDTO[i].getSource():" NA ") %></td>
			<td width="71">
			<%if(olPublicationsDTO[i].getYearOfPublication()>0){%>
			<%=olPublicationsDTO[i].getYearOfPublication() %>
			   <% }else {if(olPublicationsDTO[i].getDateOfPublication()!=null){ %>
			 <%=olPublicationsDTO[i].getDateOfPublication()  %>
			 <%}else {%> &nbsp;<%}}%>
			</td>
			<td width="100"><%=(olPublicationsDTO[i].getIssn()!=null?olPublicationsDTO[i].getIssn():" NA ")  %></td>
			<td width="121"><%=olPublicationsDTO[i].getUniqueId()  %></td>
		</tr>
			
	<%	}
	
	}%>		
	<tr>
			<td width="11" align="center">&nbsp;</td>
			<td width="45" align="center">&nbsp;</td>
			<td width="351">&nbsp;</td>
			<td width="162">&nbsp;</td>
			<td width="210">&nbsp;</td>
			<td width="71">&nbsp;</td>
			<td width="100">&nbsp;</td>
			<td width="121">&nbsp;</td>
		</tr>
	</table></div>
    
    </td></tr>
    <tr>
    <td colspan="3"><font size="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font><br>
&nbsp;&nbsp;&nbsp;&nbsp; <input type="submit" name="commit" class="button-01" value="  Commit  "/>&nbsp;&nbsp;&nbsp;
                <input type="submit" name="refresh" class="button-01" value="Refresh" />&nbsp;&nbsp; <input type="button" value="  Close  "  class="button-01" onclick="window.close()"></td></tr>
</table></form></div>

</body>
    <%@ include file="footer.jsp" %>