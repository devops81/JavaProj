
<jsp:directive.page import="com.openq.utils.MutableInteger"/>
<%@ include file = "imports.jsp" %>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.utils.StringUtil" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.forms.AdvancedSearchForm" %>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Properties"%>
<%@ page import="com.openq.web.ActionKeys" %>
<%@ page import="com.openq.kol.DBUtil"%>

<%
  java.util.Properties featuresPub = DBUtil.getInstance().featuresProp;	
  String filterAttrib = request.getParameter("filter");
  Map expertsFound = (Map)session.getAttribute("experts");
  Map expertsStats = (Map)session.getAttribute("experts_stats");
  String OLAdded = null;
  if(session.getAttribute("OLAdded")!=null) {
      OLAdded = (String)session.getAttribute("OLAdded");
  }
  MutableInteger countUsers= (MutableInteger)session.getAttribute("USER_RESULT_COUNT");
  int totalPageCount=0;
  Integer totalPageCountInteger=(Integer)session.getAttribute("TOTAL_NUMBER_OF_PAGES");
	if(null!=totalPageCountInteger)
  	{
  		totalPageCount=totalPageCountInteger.intValue();
  	}
  	else
  	{
  		totalPageCount=0;
  	}
  	
  
 
  int currentPage=0;
  Integer currentPageInteger=(Integer)session.getAttribute("CURRENT_PAGE");
  if(null!=currentPageInteger)
  {
  	 currentPage=currentPageInteger.intValue();
  }
  else
  {
  	currentPage=0;
  }
  String flagCheck = "false";
  if(session.getAttribute("fromEvent")!=null)
  {
  	flagCheck = (String)session.getAttribute("fromEvent");
  }
  
  String flagCheckOLAlignment = "false";
  if(session.getAttribute("fromOLAlignment")!=null)
  {
  	flagCheckOLAlignment = (String)session.getAttribute("fromOLAlignment");
  }
  
  List filteredResultSet = null;

  if(expertsFound != null){
    filteredResultSet = new ArrayList(expertsFound.keySet());
    for(Iterator itr=filteredResultSet.iterator(); itr.hasNext();){
      Set attribSet = (Set)expertsFound.get(itr.next());
      if(filterAttrib != null && !attribSet.contains(filterAttrib))
        itr.remove();
    }
  }

  int maxCount = 0;
  if(expertsStats != null) {
    for(Iterator itr = expertsStats.values().iterator(); itr.hasNext(); ) {
      Integer count = (Integer) itr.next();
      if(maxCount < count.intValue()) maxCount = count.intValue();
    }
  }
%>
<style>
</style>
<%@page import="com.openq.kol.DBUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<script type="text/javascript">
  dojo.require("dojo.parser");
  dojo.require("dijit.Tooltip");
  
 

  
</script>
<% if(filteredResultSet!=null && filteredResultSet.size()>0){
	      	
	      	Collections.sort(filteredResultSet, new java.util.Comparator() {
			public int compare(Object o1, Object o2) {
			User dto1 = (User) o1;
			User dto2 = (User) o2;
			return dto1.getLastName().toUpperCase().compareTo(
				dto2.getLastName().toUpperCase());
			}
		});
	      
	             
	             for(int i=0;i<filteredResultSet.size();i++)
				 {
				    
				    User u = (User) filteredResultSet.get(i);
	                
	        %>
				<div id="<%=i%>Content" onMouseOver="javascript:showQuickContactDiv('<%=i%>')"  onMouseOut="javascript:hideQuickContactDiv('<%=i%>')" style="position:absolute;  display:none; width:135px; height:80px; top=147px; left=720px; padding-bottom:2px;">
						  <table width=100% bgColor="#E2EAEF" cellpadding="0" cellspacing="0"  style="padding-bottom:5px;opacity:0.2" >
							 
							  <tr><td>&nbsp;
				            	<a target=_top href="event_add.htm?kolName=<%=u.getLastName()%>,<%=u.getFirstName()%>&kolId=<%=u.getId()%>"  class="text-blue-01-link">Schedule Medical Meeting</a>
				          	  </td></tr>
				          	  
				          	  <tr><td height="24">&nbsp;
				          	    <a target="_top" href='event_search.htm?&go=true&kolId=<%=u.getId()%>&kolName=<%=u.getLastName()%>,<%=u.getFirstName()%>', class="text-blue-01-link">
								Past Medical Meetings</a>
				          	  </td></tr>
				          	  <tr><td>&nbsp;
				          	    <a href='searchInteraction.htm?action=<%=ActionKeys.SEARCH_INTERACTION%>&kol_name=<%=u.getLastName()%>,<%=u.getFirstName()%>&go=true&kolId=<%=u.getId()%>', target="_top" class="text-blue-01-link">
				          	    Past Interactions</a>
				          	  </td></tr>
				          	  <tr><td>&nbsp;
				          	    <a target=_top href='expertfullprofile.htm?fromInteraction=yes&kolid=<%=u.getId()%>&entityId=<%=u.getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=u.getLastName()%>, <%=u.getFirstName()%>' class="text-blue-01-link">New Interaction</a>
				          	  </td></tr>  
				          	    <%if(!(featuresPub!=null && featuresPub.getProperty("EAV_PUBLICATIONS")!=null && featuresPub.getProperty("EAV_PUBLICATIONS").equalsIgnoreCase("false"))){ 
				      			 %>
				          	    <tr><td>&nbsp;
				          	    <a target='_top' href="expertfullprofile.htm?kolid=<%=u.getId()%>&entityId=<%=u.getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=u.getLastName()%>, <%=u.getFirstName()%>&go=true" class="text-blue-01-link">Publications</a>
				          	  </td></tr>
				          	  <% }%>
				          	    <tr><td>&nbsp;
				          	    <a target='_top' href="expertfullprofile.htm?kolid=<%=u.getId()%>&entityId=<%=u.getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=u.getLastName()%>, <%=u.getFirstName()%>" class="text-blue-01-link">Profile</a>
				          	  </td></tr>              	  
				          	  </table>
				</div>		
				<% 
					}
				} %> 
				
<div style="height: 100%; overflow: hidden;" id="expertPaneContainer">
  <div class="reset colOuter" style="height: 100%;" id="expertPaneContent">
    
    <div class="colTitle">
    
      <span style="float:left;">
      <%if(countUsers!=null && filteredResultSet != null && filteredResultSet.size()> 0){
      %>
        Total Pages : <%=totalPageCount%>,
      	Total <%=DBUtil.getInstance().doctor%>s found : <%=countUsers.getNumber() %> , 
      	Showing <%=filteredResultSet.size() %> <%=DBUtil.getInstance().doctor%>s per page
      <%}%>
      </span>
      <span style="float: right;">
        <img src="images/closeSearchPane.gif" style="cursor: pointer;" onclick="javascript:dojo.byId('expertCheckBox').click()" title="Close"></img>
      </span>
      <div style="clear: both;"></div>
    </div>
        <% 
    if(totalPageCount>0){%>
    <div class="colToolbar" name ="pages" id="pages" style="display:block">
    <% 
    }
    else if(totalPageCount<=0)
    {
    %>
     <div class="colToolbar" name ="pages" id="pages" style="display:none">
     <%} %>
    <Table name="pagesTable" id= "pagesTable">
    <tr>
    <% if(totalPageCount>0){
		Integer prevLinkObj = (Integer) session.getAttribute(Constants.PREV_SEARCH_RESULTS_START_LINK);
		int prevLink = prevLinkObj != null ? prevLinkObj.intValue() : -1;
		Integer nextLinkObj = (Integer) session.getAttribute(Constants.NEXT_SEARCH_RESULTS_START_LINK);
		int nextLink = nextLinkObj != null ? nextLinkObj.intValue() : -1;
		int count = 0;
		if(prevLink > -1 && nextLink > -1){
			count = (prevLink + nextLink)/2;
		}
	%><td class="text-blue-link">
		<%if(prevLink >= 0){ %>
			<a class="text-blue-link" onclick="javascript:ExpertSearch(<%=prevLink%>,'True', '<%= Constants.PREV_SEARCH_RESULTS_START_LINK%>');" href=#>Prev</a>
		<%}
		   	while(count < nextLink){
			   if(count>=0 && count<totalPageCount){%>
	 				<%if(count == currentPage){%>
			    	    <strong><a href="#" onclick="ExpertSearch(<%=count%>,'True', null)"><%=(count +1)%></a></strong>
			    	<%}else{%>
			    	    <a href="#" onclick="ExpertSearch(<%=count%>,'True')"><%=(count +1)%></a>		     
					<%}%>
				<%}
			count = count + 1; 
		    }
		if(nextLink > 0 && nextLink < totalPageCount){%>
		 <a class="text-blue-link" onclick="javascript:ExpertSearch(<%=nextLink%>,'True', '<%= Constants.NEXT_SEARCH_RESULTS_START_LINK%>');" href=#>Next</a>
	  </td>
	  <%}}%>
	</tr>
    </Table>
    </div>
    <div class="colToolbar">
      <span style="float: left; margin-right: 10px; cursor: pointer; ">
        <span id="expertTagCloudLink"
          onclick="javascript:showTagCloud('expertTagCloud');">
          <span style="margin-right: 0px;">Filter <%= filterAttrib!=null? "("+filterAttrib+")":"" %></span>
          <img src="images/drop-down-icon.gif" style="border: 0px;" href="papervision.jsp" title=""></img>
        </span>
         
        
        
      </span>
      
      <span style="float: right; margin-right: 10px;">
      <a href="javascript:runGeoMap();">
          <img src="images/world.gif" style="border: 0px;" width="12px" height="12px" title="Geo mapping"></img>
      </a>    
      </span>
      <span style="float: right; margin-right: 5px;">
        <%
          if(filteredResultSet != null) {
            // Set the session attribute for papervision 3d
            session.setAttribute("ADV_SEARCH_RESULT", filteredResultSet.toArray(new User[0]));
          }
        %>
        <%--<a href="papervision.jsp">
          <img src="images/print_profile.gif" style="border: 0px;" href="papervision.jsp" width="12px" height="12px" title="Index cards"></img>
        </a>
      --%></span>
      <% if(expertsFound!=null && expertsFound.size()>0){ %>
      <span style="float: right; margin-right: 5px;">
		<a href="reportsViewer.htm?reportName=SearchReport&searchReport=yes&searchResults=yes">
          <img src="images/xls_icon.gif" style="border: 0px;" href="olsearchdata.htm" width="12px" height="12px" title="Export to Excel"></img>
        </a>
        </span>
        <%} %>

      <div style="clear: both;"></div>
    </div>
    <% if(expertsStats != null) { %>
    <div style="border: 1px solid #ECEADE; text-align: center; padding:2px; display: none;" id="expertTagCloud">
      <ul style="font-size: 1.5em; margin: 5px;">
        <% for(Iterator itr = expertsStats.entrySet().iterator(); itr.hasNext(); ) {
            Map.Entry entry = (Map.Entry) itr.next();
            double count = ((Integer)entry.getValue()).doubleValue();
            int size = (int)Math.round((count / maxCount) * 100);
            if(size < 60) size = 60;
          %>
            <li style="display: inline; margin-right: 3px;">
              <a class="text-blue-01-link" style="font-size: <%=size%>%;" onclick="javascript:dijit.byId('expertPane').setHref('expert.jsp?filter=<%=entry.getKey()%>')" href="#">
                <%=entry.getKey()%>
              </a>
            </li>
          <%
           }
        %>
      </ul>
      <div><a class="text-blue-01-link" onclick="javascript:dijit.byId('expertPane').setHref('expert.jsp')" href="#">See All</a></div>
    </div>
    <% } %>
    <div id="listContent" class="listContent" style="overflow-y:scroll; height: 70%;">
    
      <table width="100%">
	  <% if(filteredResultSet==null || filteredResultSet.size()==0)
	  {%>
	  <tr bgcolor='white' class="text-blue-01" width="100%">
                 <td><font color="black">No Results to display</font></td>
               </tr>
               
	  
	  <%}%>
	  <% if(OLAdded!=null && OLAdded.equals("true")) { %>
	  <tr bgcolor='white' class="text-blue-01" width="100%">
	             <td></td>
                 <td><font color="red"><b><%=DBUtil.getInstance().doctor%>(s) added to Contact List</font></td>
               </tr>
	  <%} %>
        <% if(filteredResultSet!=null && filteredResultSet.size()>0){
        
        Collections.sort(filteredResultSet, new java.util.Comparator() {
			public int compare(Object o1, Object o2) {
			User dto1 = (User) o1;
			User dto2 = (User) o2;
			return dto1.getLastName().toUpperCase().compareTo(
				dto2.getLastName().toUpperCase());
			}
		});
            for(int i=0;i<filteredResultSet.size();i++)
             {
               User u = (User) filteredResultSet.get(i);
               Set matchedKeywords = (Set)expertsFound.get(u);
               if(filterAttrib != null && !matchedKeywords.contains(filterAttrib)) continue;
               if(matchedKeywords == null) matchedKeywords = new HashSet();
               String ol_imageName = "Photo_"+u.getFirstName() +"_"+u.getLastName()+".jpg";
               %>
               <tr bgcolor='#faf9f2' id=expertName<%=i%> onMouseOver="javascript:showGoDiv('<%=i %>')" onMouseOut="javascript:hideGoDiv('<%=i %>')" width="100%">
                  <%if (flagCheck.equalsIgnoreCase("true")&& flagCheckOLAlignment.equalsIgnoreCase("false")){ %>
                 <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkIds" value="<%=u.getId()+";"+u.getLastName()+";"+u.getFirstName()%>"></td>
                 <% }else if (flagCheckOLAlignment.equalsIgnoreCase("true")){ %>
                 <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="ids" value="<%=u.getId()%>"></td>
                 <%} else {%>
                 <td width="5%" height="20" align="center" valign="middle"><input type="checkbox" name="checkIds" value="<%=u.getId()%>"></td>
                 <%} %>
                 <td>
                
                 <b><u>
                   <A id=<%=u.getId()%> class="listHeading" style="FONT-WEIGHT: bold;" target='_top' href="expertfullprofile.htm?kolid=<%=u.getId()%>&entityId=<%=u.getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=u.getLastName()%>, <%=u.getFirstName()%>">
                     <%=u.getLastName()%>, <%=u.getFirstName() %> <%if(u.getTier()!=null){ %> ( <%=u.getTier() %>)<%} %>  
                   </A></u></b>
                 </td>
                 <td width="15%">
		          <div >
					<div id="quickContactDiv<%=i %>" style="display:none"  onMouseOver="javascript:showContentDiv('<%=i%>','false')" onMouseOut="javascript:hideContentDiv('<%=i%>')">    			
		    			<a href='#' class="text-blue-01-link">Go</a>
					</div>
										
		          </div>	
          		</td>
               </tr>
               <tr bgcolor='white' class="text-blue-01" width="100%">
                 
                 <td width="5%" height="20" align="center" valign="middle"></td>
                 
                 <td><font color="black">Matches : <%=StringUtil.join(matchedKeywords)%></font></td>
               </tr>
               <div dojoType="dijit.Tooltip" class="openq" connectId=<%=u.getId()%>>
                 <div style="overflow: hidden; background-color: #fffffa; padding: 0px; margin: 0px;">
                   <div style="float: left;">
                     <img align="center"
                       onerror="javascript:document.getElementById('_OlImage<%=u.getId()%>').src = 'photos/noimage.jpg';"
                       id="_OlImage<%=u.getId()%>"
                       src="<%=CONTEXTPATH%>/olpic/photos/<%=ol_imageName%>" width="50" height="60"/>
                   </div>
                   <div class="text-black-01" style="float: left; text-align: left; padding-left: 5px;">
                     <div>
                       <div class="text-blue-01"><%=u.getLastName()%>, <%=u.getFirstName() %></div>
                       <% if(u.getLocation() != null && u.getLocation().length() !=0) {
                         String temp = "";
                         if(u.getUserAddress()!=null){
                         	 if(u.getUserAddress().getCity() != null)
                         		temp=temp+u.getUserAddress().getCity();
                         	
                         	if(u.getUserAddress().getCountry()!=null && u.getUserAddress().getCountry().getOptValue()!=null&&(u.getUserAddress().getCountry().getOptValue().equalsIgnoreCase("USA")||u.getUserAddress().getCountry().getOptValue().equals("United States")) && u.getUserAddress().getState()!=null)          
                         	{
                         		temp = temp + ",  "+u.getUserAddress().getState().getOptValue();
                         	}
                         	else
                         	{
                          		if(u.getUserAddress().getCountry()!=null && u.getUserAddress().getCountry().getOptValue()!=null)
                         		temp =temp + "," +u.getUserAddress().getCountry().getOptValue();
                          	}
                          }
                         
                         
                         %>
                         
                         <div><%=temp.trim().replaceAll("^, ","")%></div>
                       <% } %>
                     </div>
                    <div style="margin-top: 5px;">
                       <div>MSL <%=DBUtil.getInstance().doctor%> Type : <%=u.getMslOlType()%> </div>
                    </div>
					 <div style="margin-top: 5px;">
                       <% if(u.getSpeciality() != null && u.getSpeciality().length()!=0&&!u.getSpeciality().equalsIgnoreCase("NA")) { %>
                         <div>Speciality: <%= u.getSpeciality().length() > 20 ? (u.getSpeciality().substring(0,20)+"...") :u.getSpeciality()%></div>
                       <% } %>
                       <% if(u.getPhone() != null && u.getPhone().length() !=0) { %>
                         <div>Phone: <%=u.getPhone()%></div>
                       <% } %>
                     </div>
                     <div style="margin-top: 5px;">
                       <% if(u.getPubCount() != 0) { %>
                         <div># of Publications: <%=u.getPubCount()%></div>
                       <% } %>
                       <% if(u.getLastInteraction() != null) { %>
                         <div>Last interaction date: <%=u.getLastInteraction().getInteractionDate()%></div>
                       <% } %>
                     </div>
                  </div>
                   <div style="clear: both;">&nbsp;</div>
                 </div>
               </div>
             <%
             }             
           } %>
      </table>
      
      </div>
      <%if (flagCheck.equalsIgnoreCase("true") && flagCheckOLAlignment.equalsIgnoreCase("false")){ %>
      <div>
	   <table>
      	<tr>
      		<td width="10">
				<input name="add" type="button" style="border:0;background : transparent url(images/buttons/add-int.gif);width:73px; height:22px;" onClick="javascript:addAttendeeToEvent()" class="button-01">
			</td>
      	</tr>
      </table>
    </div>
    <%} else if (flagCheckOLAlignment.equalsIgnoreCase("true")){ %>
      <div>
	   <table>
      	<tr>
      		<td width="10">
				<input name="addOLALignment" type="button" style="border:0;background : transparent url(images/buttons/add-int.gif);width:73px; height:22px;" onClick="javascript:addOLAlignment()" class="button-01">
				
			</td>
      	</tr>
      </table>
    </div>
    <%} else { 
    if (filteredResultSet!=null && filteredResultSet.size()>0) {%>
    <div>
       <input type='checkbox' name='checkall' onclick='javascript:checkedAll();'>Select All on This Page
       <table>
       <tr></tr>
        <tr>
            <td width="10">
                <input type="button" onClick="javascript:addOLsToExpertList();" class="button-01"  id="addExpert" value="" style="border:0;background : url(images/buttons/add_to_my_ol_list.gif);width:112px; height:22px;">
            </td>
        </tr>
       </table>

    </div>
   <%}}%>
  </div>
</div>
<% session.removeAttribute("OLAdded"); %>