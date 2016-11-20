<%@ include file="adminHeader.jsp" %>
  <LINK href="css/openq.css" type=text/css rel=stylesheet>
 <%
  String currentSubLink = null;
  if (null !=  session.getAttribute("CURRENT_SUB_LINK")){
    currentSubLink = (String)session.getAttribute("CURRENT_SUB_LINK");
  }
%>

<div class="producttext" style=width:95%;height=170>
<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
<tbody><tr align="left" valign="top">

<td class="" width="10">&nbsp;</td>
<td class="">
<table border="0" cellpadding="0" cellspacing="0" width=100%" height="408">

<tbody>
<tr>
    <td align="left" height="10" valign="top">
    <img src="images/transparent.gif" height="10" width="10"></td>
</tr>

<tr>
    <td align="left" height="1" valign="top"></td>
</tr>

<tr>
   <td align="left" height="24" valign="top">
    <div class="myexpertlist" style=width:100%>
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tbody><tr align="left" valign="middle" style="color:#4C7398">
                <td height="20" width="2%">&nbsp;&nbsp;<img border="0" src="images/alert2.jpg" width="22" height="16"></td>
        <td class="myexperttext1">Alerts</td>
        
            </tr>
        </tbody>
	</table>
    </div>
    </td>
</tr>


<tr>
    <td  align="left" height="373" valign="top">
<iframe id="backgr2" frameborder="0" name="alert" width="100%" height="98%" src="alert.htm?action=alertsStatus" scrolling="yes"></iframe>
    </td>
</tr>


</tbody></table>
</td>
</tr>
</tbody></table>
</div>


    <%@ include file="footer.jsp" %>