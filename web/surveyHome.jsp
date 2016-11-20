	<%@ include file="adminHeader.jsp" %>
	<%@ page import="com.openq.survey.NewSurvey"%>
	
	
	<table  border=0 cellspacing=0 cellpadding=0 width=99% height="450">
	 <tr>
		<td width="22%" align="left" valign="top" height="450">
				<div class="expertsegmentationdiv">
					<div class="leftsearchbgpic">
						<div class="leftsearchtext">Surveys</div>
					</div>
					<iframe id="backgr1" name="tree" src="survey_create_node_tree.jsp" width="100%" height="500"
                                        frameborder="2" scrolling="auto" ></iframe>
				</div>
		</td>	
		
		<%
		String action = null;
		boolean checkAction = false;
		try
		{
			action = (String)session.getAttribute("ACTIONSTRING");
			checkAction=action.equalsIgnoreCase("showLaunchedSurveys");
		}
		catch(Exception err)
		{
			// remove the print statement ..		
			//System.out.println(err.getMessage()+"   "+action + "    " + checkAction +"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		}		
		if(checkAction)
		{
		%>	
		<td valign="top">
		     <div class="producttext">
					<iframe id="backgr1" frameborder="0" name="main" width="100%" height="100%" src="show_launched_surveys.jsp"></iframe>
					 
              </div>
		</td>
		<% 
		session.removeAttribute("ACTIONSTRING");
		}
		else
		{
		%>
		<td valign="top">
		     <div class="producttext">
					<% 
					NewSurvey survey = (NewSurvey)request.getSession().getAttribute("currentSurvey");
					System.out.println("currsurvey at jsp"+survey);
					if(survey!=null)
					{
					%>
					<iframe id="backgr1" frameborder="0" name="main" width="100%" height="100%" src="editAddSurvey.jsp"></iframe>
					<%} else {%>
	                   <iframe id="backgr1" frameborder="0" name="main" width="100%" height="100%" src="createSurvey.jsp"></iframe>
					 <%}%>  
              </div>
		</td>
		<%}%>
	</tr>
</table>
	
    <%@ include file="footer.jsp" %>