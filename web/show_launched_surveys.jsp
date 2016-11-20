<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<jsp:directive.page import="com.openq.web.controllers.Constants;"/>




<% 	 
	HashMap launchedSurveyMap= (HashMap)request.getSession().getAttribute("LaunchedSurveys");
	HashSet nameSurvey = new HashSet(launchedSurveyMap.keySet());
	Map entityGroupMap = (Map) session.getAttribute("SURVEY_PERMISSION_MAP");// coming from addSurveyController--> surveyHome.jsp
    session.removeAttribute("SURVEY_PERMISSION_MAP");
%>
<script language="javascript" src="js/groupLevelSecurity.js"></script>
<HTML>
<HEAD>
	<TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>
<BODY>

<div class="contentmiddle">
  <div class="producttext" style=width:100%;height=300;overflow:auto>
    <div class="myexpertlist">
	<table width="100%;height:100">
        <tr style="color:#4C7398">
			<td width="25%" class="text-blue-01-bold">Survey Name</td>
          	<td width="25%" class="text-blue-01-bold">Permitted User Groups</td>
          	<td width="10%" class="text-blue-01-bold">Change User Groups</td>
   
        </tr>
      </table>
    </div>
    <table width="100%" cellspacing="0" scrolling="yes" id="displayOptionTable">
    <%
		Iterator itr = nameSurvey.iterator();
		String nameKey = null;
		Long surveyIdLong=null;
		int i=0;
		while (itr.hasNext())
		 {				
		 	String permittedGroups = "";
			try {
				nameKey = itr.next() + "";
				surveyIdLong = (Long)launchedSurveyMap.get(nameKey);
			   	if(entityGroupMap != null && entityGroupMap.containsKey(surveyIdLong) && entityGroupMap.get(surveyIdLong) != null)
               		permittedGroups = entityGroupMap.get(surveyIdLong)+""; 
			} catch (Exception err) {
				System.out.println("######################"
				+ err.getMessage() + "   " + nameKey + "  "
				+ surveyIdLong);
			}
	%>
    
   
      
						<tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
                          <td width="10" height="20" valign="top">&nbsp;</td>
                          <td width="20">&nbsp;</td>
                          <td class="text-blue-01"><%=nameKey%></td>
                            <td width="25%" class="text-blue-01" id="permittedGroupsTd<%=surveyIdLong%>" value="<%=permittedGroups%>"><%=permittedGroups%></td>
				            <td width="10%" class="text-blue-01">
				            	<img src="images/configure.gif" onclick="showGroupChangerPopup('<%=surveyIdLong%>','<%=Constants.SURVEY_PERMISSION_ID%>')" style="cursor: pointer;">
				            </td>
                          <%//} %>
                        </tr>                    
    	
    <%
    i++;
	}
	%>
		</table> 
    </div>

</BODY>
</HTML>
