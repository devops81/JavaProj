<%@ include file = "imports.jsp" %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.openq.geocode.ExpertGeocodeData" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.user.UserAddress" %>
<%@ page import="org.apache.taglibs.datagrid.DataGridParameters" %>
<%@ page import="com.openq.kol.DBUtil"%>

<%@ taglib uri="/tags/datagrid-1.0" prefix="ui" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<% 
  ExpertGeocodeData[] allExpertGeocodeData = (ExpertGeocodeData[]) session.getAttribute("allExpertGeocodeData");
  int pageIndex = (int) DataGridParameters.getDataGridPageIndex(request, "datagrid1");
  int orderIndex = (int) DataGridParameters.getDataGridOrderIndex(request, "datagrid1");
  String statusFilter = (String) session.getAttribute("statusFilter");
  if((statusFilter == null) || (statusFilter.equals("")))
  	statusFilter = "All";
%>

<HTML>
<HEAD>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
    <LINK href="css/datagrid.css" type=text/css rel=stylesheet>
</HEAD>

<script language="javascript">
	
   function geocodeExperts(contextURL){
   		var thisform = document.geocodeExpertsForm;
		var flag = false ;
		
		if (null != thisform.checkIds && thisform.checkIds.length != undefined){

		  for (var i = 0;  null != thisform.checkIds && i < thisform.checkIds.length; i++) {

            if (thisform.checkIds[i].checked) {
                    flag = true;
                    break;
                }
           }
          }
          else{
          	 if (thisform.checkIds.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select atleast one Expert");
                return false;
            }
            
            thisform.action=contextURL + "/geocode_experts.htm?action=geocode&p_datagrid_datagrid1_page_index=<%=pageIndex%>&p_datagrid_datagrid1_order_index=<%=orderIndex%>";
            thisform.submit();

   }
   
   function geocodeAllFilteredExperts(contextURL) {
   		var thisform = document.geocodeExpertsForm;
   		thisform.action=contextURL + "/geocode_experts.htm?action=geocodeAll&p_datagrid_datagrid1_page_index=<%=pageIndex%>&p_datagrid_datagrid1_order_index=<%=orderIndex%>";
   		thisform.submit();
   }
   
   function refExpData(contextURL) {
   		var thisform = document.geocodeExpertsForm;
   		thisform.action=contextURL + "/geocode_experts.htm?action=refresh&p_datagrid_datagrid1_page_index=<%=pageIndex%>&p_datagrid_datagrid1_order_index=<%=orderIndex%>";
   		thisform.submit();
   }
   
   function filterData(contextURL) {
   		var thisform = document.geocodeExpertsForm;
   		thisform.action=contextURL + "/geocode_experts.htm?action=filter&p_datagrid_datagrid1_page_index=<%=pageIndex%>&p_datagrid_datagrid1_order_index=<%=orderIndex%>";
   		thisform.submit();
   }
   
</script>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" align="center">

<!--table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="back_horz_head">
  <tr align="left" valign="middle">
    <td width="10" height="20">&nbsp;</td>
    <td width="25" class="text-white-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14"
                                                            height="14"></td>
    <td class="text-white-bold">All experts</td>
  </tr>
</table-->

<form name="geocodeExpertsForm" method="post">

  <c:if test="${confirmationMessage != null}">
	  <div align="center"><b><c:out value="${confirmationMessage}"/></b></div>
  </c:if>
<div class="myexpertlist">
  <table align="center" width="100%" cellpadding="2" cellspacing="2">
  	<tr style="color:#4C7398">
  		<td align="left" width="35%" class="myexperttext">Show <%=DBUtil.getInstance().doctor%>s with Geocoding Status</td>
  		<td align="left" width="25%" >
  			<select name="statusFilter">
  				<option <%=(statusFilter.equals("All")?"selected":"")%>>All</option>
  				<option <%=(statusFilter.equals("Geocoding Successful")?"selected":"")%>>Geocoding Successful</option>
  				<option <%=(statusFilter.equals("Geocoding Failed")?"selected":"")%>>Geocoding Failed</option>
  				<option <%=(statusFilter.equals("Geocoding Pending")?"selected":"")%>>Geocoding Pending</option>
  				<option <%=(statusFilter.equals("Not Geocoded")?"selected":"")%>>Not Geocoded</option>
  			</select>
  		</td>
  		<td align="right" width="40%">
  			<input class="button-01" type="button" name="filterExp" style="border:0;background : url(images/buttons/apply_filter.gif);width:101px; height:23px;" value="" onclick="javascript:filterData('<%=CONTEXTPATH%>')"/>
  		</td>
  	</tr>
  </table>
</div>

  <table align="center" width="100%" height="350">
   <tr>
     <td border="1" valign="top">
	   <ui:dataGrid items="${allExpertGeocodeData}" var="expertGeocodeData" name="datagrid1" cellPadding="5" cellSpacing="0"  scroll="true" width="100%" height="270" styleClass="datagrid">
              <columns>
                <column width="20%" order="true">
                  <header value="Name" hAlign="left"/>
                  <item   value="${expertGeocodeData.expert.lastName}, ${expertGeocodeData.expert.firstName}" hAlign="left"/>      
                </column>
                <column width="40%" order="true">
                  <header value="Address" hAlign="left"/>
                  <item   value="${expertGeocodeData.expert.userAddress.displayableAddress}" hAlign="left"/>
                </column>
                <column width="15%" order="true">
                  <header value="Geocoding Status" hAlign="left"/>
                  <item   value="${expertGeocodeData.geocodeStatus}" hAlign="left"/>
                </column>
                <column width="10%" order="true">
                  <header value="Latitude" hAlign="left"/>
                  <item   value="${expertGeocodeData.expert.latitude}" hAlign="left"/>      
                </column>
                <column width="10%" order="true">
                  <header value="Longitude" hAlign="left"/>
                  <item   value="${expertGeocodeData.expert.longitude}" hAlign="left"/>      
                </column>
                <column width="5%" order="true">
                  <header value="Selected" hAlign="left"/>
      			  <item   hAlign="center">
        				<![CDATA[
        					<input type="checkbox" name="checkIds" value="${expertGeocodeData.expert.id}"/>
        				]]>
      			  </item>
                </column>
              </columns>
    	      <header        styleClass="datagrid-header" show="true"/>
              <footer        styleClass="footer" show="false"/>
              <rows          styleClass="back-white-02-light"/>
              <alternateRows styleClass="back-grey-02-light"/>
              <paging        size="8" nextUrlVar="next" previousUrlVar="previous"/>
    	</ui:dataGrid>
      </td>
    </tr>
  </table>
  
  <hr>
    
  <table align="center" width="100%" style="font-family: arial; font-size: 10pt" cellspacing="0" cellpadding="0">
    	<tr>
    		<td align="left" width="50%">
    			<c:if test="${previous != null}">
					<a href="<c:out value="${previous}"/>"><img border="0" src="images/prev-button.jpg"/></a>
				</c:if>
			</td>
		<td align="right" width="50%">
				<c:if test="${next != null}">
					<a href="<c:out value="${next}"/>"><img border="0" src="images/next-button.jpg"/></a>
				</c:if>
		</td>
	</tr>
  </table>

<table cellspacing="5" align="center" width="50%">
  <tr>
    <td align="center">
	  <input class="button-01" style="border:0;background : url(images/buttons/run_geocode.gif);width:113px; height:23px;"  type="button" name="geocode" value="" onclick="javascript:geocodeExperts('<%=CONTEXTPATH%>')"/>
	</td>
	<td align="center">
		<input class="button-01" type="button" style="border:0;background : url(images/buttons/run_geocode_filtered_expert.gif);width:200px; height:22px;"  name="geocodeAll" value="" onclick="javascript:geocodeAllFilteredExperts('<%=CONTEXTPATH%>')"/>
	</td>
	<td align="center">
	  <input class="button-01" type="button" name="refExp" value="" style="border:0;background : url(images/buttons/refresh_data.gif);width:111px; height:22px;" onclick="javascript:refExpData('<%=CONTEXTPATH%>')"/>
	</td>
  </tr>
</table>

</form>

</body>

</html>