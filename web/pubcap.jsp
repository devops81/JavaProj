<%@ include file="adminHeader.jsp" %>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
 <%
	String currentSubLink = null;
	if (null !=  session.getAttribute("CURRENT_SUB_LINK")){
	  currentSubLink = (String)session.getAttribute("CURRENT_SUB_LINK");
	} 
%>
<div class="producttext" style=width:98%>	
<div class="submenu" align="center">
   <table  class="" border=0 cellspacing=0 cellpadding=0 width="100%" height="81%">
	   	<td height="467">
			<table class="" border=0 cellspacing=0 cellpadding=0 width="100%" height=100%>
			<tr class="myexpertlist" align="left" valign="middle">
		        <td class="myexperttext" height="22"><img src="images/icon_search.gif" height="14" width="14"> Profile Capture 
				2.0 - Ovid Search</td></tr>
		</td>
		<td class="back-menu" height="20">
		<div class="submenu2">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
	    	<tbody>
		   <tr class="submenu2">
		   	<td width="27" align="left" class="text-black-link"><img src="images/icon_menu_expert_search.gif" width="22" height="20"></td>
		  	<td width="2%" height="20">
			   <div onclick="javascript:changePlanStyle('yes')" id="planTdId">
				<a id="planAnchorId" class="text-black-link" target="pubcap" href="pubschedule.htm">
				<span class="exbold" align="center"> Capture&nbsp;&nbsp;</span></a>
			   </div>
			</td>

			<td width="40"><img src="images/transparent.gif" width="7" height="7"></td>
	      	<td width="30" class="text-black-link"><img src="images/icon_menu_event_search.gif" width="22" height="20"></td>
		  	<td width="10%" height="20">
			   <div id="planTdId" onclick="changePlanStyle('yes')">
				<a id="planAnchorId" class="text-white-link" target="pubcap" href="pubdatasource.htm">
				<span class="exbold" align="center"> Data Sources</span></a>
			   </div>
			</td>

   		  	<td width="40" align="center"><img src="images/transparent.gif" width="7" height="7"></td>
	        	<td width="27" align="left"><img src="images/icon_menu_expert_search.gif" width="22" height="20"></td>
		  	<td width="10%" >
			    <div id="planTdId" onclick="changePlanStyle('yes')">
			  	<a id="planAnchorId" class="text-white-link" target="pubcap" href="pubresults.htm">
		  		<span class="exbold" align="center"> Results</span></a>
			</td>
	    	    	<td>&nbsp;</td>
        	   </tr>
		  </div>
       	</tbody>
     	     </div>
   </table>
    </td>
  </div>
         </tr>
		<tr>       
			<td valign=top>
				<iframe id="backgr2" frameborder="0" name="pubcap" width="120%" height="100%" src="pubschedule.htm"></iframe>
			</td>
		</tr>
	</table>
  </table>	
</div>
	
    <%@ include file="footer.jsp" %>	