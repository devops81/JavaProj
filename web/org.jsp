<%@ page language="java" %>
<jsp:directive.page import="com.openq.utils.MutableInteger"/>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.forms.AdvancedSearchForm" %>
<%@ page import="com.openq.eav.org.Organization"%>
<%@ page import="java.util.*"%>
<%@ page import="com.openq.utils.StringUtil"%>
<%
  String filterAttrib = request.getParameter("filter");
  HashMap orgsFound = (HashMap)session.getAttribute("orgs");
  Map trialsStats = (Map)session.getAttribute("orgs_stats");
  MutableInteger countOrg= (MutableInteger)session.getAttribute("ORG_RESULT_COUNT");
  Integer totalPageCountOrgInteger=(Integer)session.getAttribute("ORG_TOTAL_NUMBER_OF_PAGES");
  int totalPageCountOrg=0;
  if(null!=totalPageCountOrgInteger)
  {
  	totalPageCountOrg=totalPageCountOrgInteger.intValue();
  }
  else
  {
  	totalPageCountOrg=0;
  }
  Integer currentPageInteger=(Integer)session.getAttribute("ORG_CURRENT_PAGE");
  int currentPage=0;
  if(null!=currentPageInteger)
  {
  	currentPage=currentPageInteger.intValue();
  }
  else
  {
  	currentPage=0;
  }
  List filteredResultSet = null;
  
  
  if(orgsFound != null){
    filteredResultSet = new ArrayList(orgsFound.keySet());
    for(Iterator itr=filteredResultSet.iterator(); itr.hasNext();){
      Set attribSet = (Set)orgsFound.get(itr.next());
      if(filterAttrib != null && !attribSet.contains(filterAttrib))
        itr.remove();
    }
  }
  int maxCount = 0;
  if(trialsStats != null) {
    for(Iterator itr = trialsStats.values().iterator(); itr.hasNext(); ) {
      Integer count = (Integer) itr.next();
      if(maxCount < count.intValue()) maxCount = count.intValue();
    }
  }
%>


<div style="height: 100%;  overflow: hidden;" id="orgPaneContainer">
  <div class="reset colOuter" style=" width:100%;height: 100%;" id="orgPaneContent">
    <div class="colTitle">
      <span style="float:left;">
        <% if( orgsFound!=null && orgsFound.size()>0 ) { %>
              Organizations (<%=filteredResultSet.size() %> results)
        <% } else { %>
              Organizations
        <% } %>
      </span>
      <span style="float: right;">
        <img src="images/closeSearchPane.gif" style="cursor: pointer;" onclick="javascript:dojo.byId('orgCheckBox').click()" title="Close"></img>
      </span>
      <div style="clear: both;"></div>
    </div>
    <div class="colToolbar">
      <span style="float: left; margin-right: 10px; cursor: pointer;">
        <span id="orgTagCloudLink"
          onclick="javascript:showTagCloud('orgTagCloud');">
          <span style="margin-right: 0px;">Filter <%= filterAttrib!=null? "("+filterAttrib+")":"" %></span>
		   <img src="images/drop-down-icon.gif" style="border: 0px;"></img>
        </span>
      </span>
    

	     <span id="orgAdd">
		    <span style="float: right;margin-left: 10px; cursor: pointer;">
        <span style="margin-left: 0px;">
		 <a class="text-blue-01-link" href="javascript:addOrg()">Add Org
		 </a>
		</span>
	 </span>
	 </span>
      <div style="clear: both;"></div>
    </div>
    <% 
    if(countOrg!=null && countOrg.getNumber()>0)
    {
    %>
    <div class="colToolbar" name ="pagesOrg" id="pagesOrg" style="display:block">
     <% 
    }
    else if(countOrg!=null && countOrg.getNumber()<=0)
    {
    %>
    <div class="colToolbar" name ="pagesOrg" id="pagesOrg" style="display:none">
    <%} %>
    <Table name="pagesTable" id= "pagesTableOrg">
     <tr>
    <% 
    if(countOrg!=null && countOrg.getNumber()>0)
	 {
	    
		    int count=currentPage-8;
		    int upperLimit=currentPage+8;
		    while(count<upperLimit)
		    {
		    	if(count>=0 && count<totalPageCountOrg)
		    	{
		    %>
		    	<td class="text-blue-link">
		    	<%
		    	if(count == currentPage){
			    	 %>
		    	    <strong><a href="#" onclick="ExpertSearch(<%=count%>,'False')"><%=(count +1)%></a></strong>
		    	    <%}
	    	    else{
		    	     %>
		    	    <a href="#" onclick="ExpertSearch(<%=count%>,'False')"><%=(count +1)%></a>		     
					</td>
					<%}
				}
			count = count + 1; 
		    }
		}
	%>
	</tr>
    </Table>
    </div><%--
    <%if(totalPageCountOrg>0)
    {
    %>
	   "javascript:addPages(<%= totalPageCountOrg%>,<%=Constants.MAX_NUM_USERS_PER_PAGE %>);"
   <%
   }
    %>
    --%>
    <%
     if(countOrg!=null && countOrg.getNumber()>0)
    {
    %>
    <div name= "nextPageOrg" id="nextPageOrg" class="colToolbar" style="display:block" >
    <% 
    }
    else
    {
    %>
    <div name= "nextPageOrg" id="nextPageOrg" class="colToolbar" style="display:none" >
     <%} %>
      <table>
      <tr>
      <td>
      <div>
      <a class="text-blue-link" onclick="javascript:ExpertSearch('True','False');" href=#><</a>
      </div>
      </td>
      <td>
      <div>
      <a class="text-blue-link" onclick="javascript:ExpertSearch('False','False');" href=#>></a>
      </div>
      </td>
      <td>
      <div class="text-blue-link" >
      <%
      if(countOrg!=null)
      {
      %>
      	Total Organizations found =<%=countOrg.getNumber() %>
      <%
      }
      %>
      </div>
      </td>
      </tr>
      </table>
      </div>
    
	
	
	<% if(trialsStats != null) { %>
    <div style="border: 1px solid #ECEADE; display: none; text-align: center; padding:2px;" id="orgTagCloud">
      <ul style="font-size: 1.5em; margin: 5px;">
        <% for(Iterator itr = trialsStats.entrySet().iterator(); itr.hasNext(); ) { 
            Map.Entry entry = (Map.Entry) itr.next();
            double count = ((Integer)entry.getValue()).doubleValue();
            int size = (int)Math.round((count / maxCount) * 100);
            if(size < 60) size = 60;
          %>
            <li style="display: inline; margin-right: 3px;">
              <a class="text-blue-01-link" style="font-size: <%=size%>%;" onclick="javascript:dijit.byId('orgPane').setHref('org.jsp?filter=<%=entry.getKey()%>')" href="#">
                <%=entry.getKey()%>
              </a>
            </li>
          <% 
           } 
        %>
      </ul>
      <div><a class="text-blue-01-link" onclick="javascript:dijit.byId('orgPane').setHref('org.jsp')" href="#">See All</a></div>
    </div>
    <% } %>
    <div class="listContent" style="overflow-y:scroll; height: 70%;">
      <table width="100%">
	  <% if(filteredResultSet==null || filteredResultSet.size()==0)
	  {%>
	  <tr bgcolor='white' class="text-blue-01" width="100%">
                 <td><font color="black">No Results to display</font></td>
               </tr>
               
	  
	  <%}%>
      <% if(filteredResultSet != null && filteredResultSet.size()>0) { 
          Iterator iterator = filteredResultSet.iterator();
          while(iterator.hasNext())
          {
            Organization u = (Organization) iterator.next();
            Set matchedAttributes = (Set)orgsFound.get(u);
            if(filterAttrib != null && !matchedAttributes.contains(filterAttrib)) continue;
            %>
            <tr bgcolor='#faf9f2' width="100%">
              <td><b>
                <A class="listHeading" style="FONT-WEIGHT: bold;" target='_top' href='institutions.htm?entityId=<%=u.getEntityId()%>'>
                <span id=<%=u.getEntityId() %>><%=u.getName() %></span>
                </A>
              </b></td>
            </tr>
            <tr bgcolor='white' class="text-blue-01">
              <td><font color="black">Matches : <%=StringUtil.join(matchedAttributes)%></font></td>
            </tr>
            <div dojoType="dijit.Tooltip" class="openq" connectId=<%=u.getEntityId()%>>
              <div style="overflow: hidden; background-color: #fffffa; padding: 0px; margin: 0px;">
                <div class="text-black-01" style="text-align: left; padding-left: 5px;">
                  <div class="text-blue-01"><%=u.getName() %></div>
                  <div>
                    <% if(u.getState() != null && u.getState().length() != 0) { %>
                      <%=u.getState() %>,
                    <% } %>
                    <% if(u.getCountry() != null && u.getCountry().length() != 0) { %>
                      <%=u.getCountry() %>
                    <% } %>                    
                  </div>
                </div>
              </div>
            </div>
            <%
          }
         } %>
      </table>
    </div>
  </div>
</div>