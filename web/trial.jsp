<%@ page language="java" %>

<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.forms.AdvancedSearchForm" %>
<%@ page import="com.openq.eav.trials.ClinicalTrials"%>
<%@ page import="java.util.*"%>
<%@page import="com.openq.utils.StringUtil"%>

<%
  String filterAttrib = request.getParameter("filter");
  HashMap trialsFound = (HashMap)session.getAttribute("trials");
  Map trialsStats = (Map)session.getAttribute("trials_stats");
  List filteredResultSet = null;
  
  if(trialsFound != null){
    filteredResultSet = new ArrayList(trialsFound.keySet());
    for(Iterator itr=filteredResultSet.iterator(); itr.hasNext();){
      Set attribSet = (Set)trialsFound.get(itr.next());
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

<div style="height: 100%;  overflow: hidden;" id="trialPaneContainer">
  <div class="reset colOuter" style="height: 100%;" id="trialPaneContent">
    <div class="colTitle">
      <span style="float:left;">
        <% if( trialsFound!=null && trialsFound.size()>0 ) { %>
              Trials (<%=filteredResultSet.size() %> results)
        <% } else { %>
              Trials
        <% } %>
      </span>
      <span style="float: right;">
        <img src="images/closeSearchPane.gif" style="cursor: pointer;" onclick="javascript:dojo.byId('trialCheckBox').click()" title="Close"></img>
      </span>
      <div style="clear: both;"></div>
    </div>
    <div class="colToolbar">
      <span style="float: left; margin-right: 10px; cursor: pointer;">
        <span id="trialTagCloudLink"
          onclick="javascript:showTagCloud('trialTagCloud');">
          <span style="margin-right: 0px;">Filter <%= filterAttrib!=null? "("+filterAttrib+")":"" %></span>
          <img src="images/drop-down-icon.gif" style="border: 0px;"></img>
        </span>
      </span>
      <div style="clear: both;"></div>
    </div>
    <% if(trialsStats != null) { %>
    <div style="border: 1px solid #ECEADE; display: none; text-align: center; padding:2px;" id="trialTagCloud">
      <ul style="font-size: 1.5em; margin: 5px;">
        <% for(Iterator itr = trialsStats.entrySet().iterator(); itr.hasNext(); ) { 
            Map.Entry entry = (Map.Entry) itr.next();
            double count = ((Integer)entry.getValue()).doubleValue();
            int size = (int)Math.round((count / maxCount) * 100);
            if(size < 60) size = 60;
          %>
            <li style="display: inline; margin-right: 3px;">
              <a class="text-blue-01-link" style="font-size: <%=size%>%;" onclick="javascript:dijit.byId('trialPane').setHref('trial.jsp?filter=<%=entry.getKey()%>')" href="#">
                <%=entry.getKey()%>
              </a>
            </li>
          <% 
           } 
        %>
      </ul>
      <div><a class="text-blue-01-link" onclick="javascript:dijit.byId('trialPane').setHref('trial.jsp')" href="#">See All</a></div>
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
            ClinicalTrials u = (ClinicalTrials) iterator.next();
            Set matchedAttributes = (Set)trialsFound.get(u);
            if(filterAttrib != null && !matchedAttributes.contains(filterAttrib)) continue;
            %>
            <tr bgcolor='#faf9f2'>
              <td><b>
                <A class="listHeading" style="FONT-WEIGHT: bold;" target='_top' href='trials.htm?entityId=<%=u.getId()%>'>
                  <span id="<%=u.getId()%>"><%=u.getOfficialTitle() %></span>
                </A>
              </b></td>
            </tr>
            <tr bgcolor='white' class="text-blue-01">
              <td><font color="black">Matches : <%=StringUtil.join(matchedAttributes)%></font></td>
            </tr>
            <div dojoType="dijit.Tooltip" class="openq" connectId=<%=u.getId()%>>
              <div style="overflow: hidden; background-color: #fffffa; padding: 0px; margin: 0px;">
                <div class="text-black-01" style="text-align: left; padding-left: 5px;">
                  <div class="text-blue-01"><%=u.getOfficialTitle() %></div>
                  <div>
                    <% if(u.getPhase() != null && u.getPhase().length() != 0) { %>
                      Phase: <%=u.getPhase() %>
                    <% } %>
                  </div>
                  <div>
                    <% if(u.getStatus() != null && u.getStatus().length() != 0) { %>
                      Status: <%=u.getStatus() %>
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