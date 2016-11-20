<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.amgen.orx.types.EoList"%>
<%@ page import="com.openq.eav.expert.MyExpertList"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.orx.BestORXRecord"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="com.openq.web.controllers.Constants" %>

<%@ include file = "UserCheck.jsp" %>
<%
	java.util.Properties featuresExpertList = DBUtil.getInstance().featuresProp;
	List searchHcpResults = (List) request.getAttribute("SEARCH_HCP_RESULTS");
	request.removeAttribute("SEARCH_HCP_RESULTS");
	OptionLookup [] state = (OptionLookup []) request.getSession().getAttribute("state");
	OptionLookup [] therapeuticArea = (OptionLookup[]) request.getSession().getAttribute("therapeuticArea");
	OptionLookup [] attendeeType = (OptionLookup[]) request.getSession().getAttribute("attendeeType");
	OptionLookup [] stateAbbriviation = (OptionLookup []) request.getSession().getAttribute("stateAbbriviation");
	OptionLookup [] title = (OptionLookup []) request.getSession().getAttribute("title");
%>

<script src="<%=COMMONJS%>/validation.js"></script>
<script src="./js/utilityFunctions.js"></script>
<script language="javascript">
	function deleteAllRowsFromTable(tableId){
	     var table = document.getElementById(tableId);
	     if(table != null &&
	     	table != undefined &&
	     	table.rows != null &&
	     	table.rows != undefined){
		     for(var i = table.rows.length - 1; i > -1; i--){
		      	table.deleteRow(i);
		     }
		 }
	}
    function submitSearch(){
        if(searchORX.lastnamesearch.value == ''){
            alert("Last Name and 1 additional search criteria is required");
            return;
        }
           if(searchORX.firstnamesearch.value != '' || document.searchORX.searchstate.options[document.searchORX.searchstate.selectedIndex].value != 'Any'||document.searchORX.citysearch.value!=''){
           if(document.searchORX.searchstate.options[document.searchORX.searchstate.selectedIndex].value == 'Any' )
           		document.searchORX.searchstate.options[document.searchORX.searchstate.selectedIndex].value = '';
			searchORX.firstnamesearch.value = checkAndReplaceApostrophe(searchORX.firstnamesearch.value);
			searchORX.lastnamesearch.value  = checkAndReplaceApostrophe(searchORX.lastnamesearch.value);
			searchORX.citysearch.value  = checkAndReplaceApostrophe(searchORX.citysearch.value);
			document.searchORX.action = "<%=CONTEXTPATH%>/search_hcp.htm?action=<%=Constants.SEARCH_HCP%>";
			openProgressBar();
            document.searchORX.submit();
           }else{
               alert("Last Name and 1 additional search criteria is required");
          }
    }
	function setParentTextBox() {
		var arrayOfCheckedAttendee = new Array();
		var isRadioChecked = false;
        if (searchORX.checkedAttendee != null){
			for (var i = 0;i < searchORX.checkedAttendee.length;i++){
				if (searchORX.checkedAttendee[i].checked){
					isRadioChecked = true;
					arrayOfCheckedAttendee.push(searchORX.checkedAttendee[i].value);
					break;
				}
			}
			if(!isRadioChecked && searchORX.checkedAttendee.checked){
				isRadioChecked = true;
				arrayOfCheckedAttendee.push(searchORX.checkedAttendee.value);
			}
			if(isRadioChecked){
				deleteAllRowsFromTable('resultTable');
				deleteAllRowsFromTable('resultOtherCompanyTable');
				document.forms['searchORX'].reset();
				if(window.opener.addORXName(arrayOfCheckedAttendee)) {
					alert('<%=DBUtil.getInstance().doctor%> added successfully');
				}
			}else{
				alert('Please select an <%=DBUtil.getInstance().doctor%> first');
			}
		}
	}

	function trimAll(sString){
		while (sString.substring(0,1) == ' '){
			sString = sString.substring(1, sString.length);
		}
		while (sString.substring(sString.length-1, sString.length) == ' '){
			sString = sString.substring(0,sString.length-1);
		}
		return sString;
	}

   function setParentListBox() {
		var arrayOfcheckedAttendee = new Array();
    	var j = 0;
		if (searchORX.checkedAttendee != null){
			for (var i = 0;i < searchORX.checkedAttendee.length;i++){
				if (searchORX.checkedAttendee[i].checked == true){
					arrayOfcheckedAttendee.push(searchORX.checkedAttendee[i].value);
				}
			}
			if(searchORX.checkedAttendee.length == null){
				arrayOfcheckedAttendee.push(searchORX.checkedAttendee.value);
			}
		}
		window.opener.addORXName(arrayOfcheckedAttendee);
	}
</script>


<%@page import="com.openq.eav.expert.ExpertDetails"%><html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><%=DBUtil.getInstance().hcp%> Search</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body onUnload="javascript:checkForProgressBar()">
<form name="searchORX" method="post" onSubmit="javascript:openProgressBar()">
<input type="hidden" name="parentFormName" value=""/>
<div class="producttext" style=width:100%>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">

    <td class="">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>

        </tr>
        <tr>
	   <td height="20" align="left" valign="top">
		<div class="myexpertlist" style=width:100%>
          	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Search <%=DBUtil.getInstance().hcp%></td>
            </tr>
            </table>
		</div>
	    </td>
        </tr>
        <tr>
          <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td align="left" valign="top" class="back-white">
          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top" class="text-blue-01-bold">Last Name <font size="2" color="red">*</font></td>
              <td width="190" valign="top" class="text-blue-01-bold">First Name</td>
            </tr>
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top"><input name="lastnamesearch" type="text" class="field-blue-01-180x20" maxlength="50"/></td>
              <td width="190" valign="top"><input name="firstnamesearch" type="text" class="field-blue-01-180x20" maxlength="50"/></td>
			</tr>
			<tr>
			  <td width="10" height="20">&nbsp;</td>
			  <td width="190" valign="top" class="text-blue-01-bold">City</td>
			  <td valign="middle" class="text-blue-01-bold" width="100">State/Prov.</td>
			</tr>
			<tr>
			  <td width="10" height="20">&nbsp;</td>
			  <td width="190" valign="top"><input name="citysearch" type="text" class="field-blue-01-180x20" maxlength="50"/></td>
			  <td valign="middle" class="text-blue-01-bold" width="100"><select name="searchstate" class="field-blue-12-220x20">
			  <option value="Any">Any</option>
				<%for(int i=0;i<stateAbbriviation.length;i++){
             		String selected = "" ;
              		if(stateAbbriviation[i].isDefaultSelected())
              			selected = "selected";
				%>
              		<option value="<%=stateAbbriviation[i].getOptValue()%>" <%=selected%>><%=stateAbbriviation[i].getOptValue()%></option>
				<% } %>
				</select>
			  </td>
            </tr>
    	    <tr>
        	     <td class="back-white" colspan="4">&nbsp;</td>
	        </tr>
            <tr>
			  <td width="10" height="20">&nbsp;</td>
              <td width="190" valign="top"><input name="Submit332" type="button"  style="border:0;background : url(images/buttons/search_expert.gif);width:90px; height:22px;" class="button-01" onClick="javascript:submitSearch()"/></td>
              <td width="190" valign="top">&nbsp;</td>
              <td width="100" valign="top">&nbsp;</td>
            </tr>

          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="">
		<div class="myexpertplan">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Synergy Search Results</td>
            </tr>
          </table>
	       </div>
	</td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="">
            <tr bgcolor="#f5f8f4">

              <td width="25" valign="middle" class="text-blue-01-bold">&nbsp;</td>

              <td valign="middle" class="text-blue-01-bold" width="110">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="150"><%if(featuresExpertList!=null && featuresExpertList.getProperty("DISPLAY_TIER")!=null){%>
      <%=featuresExpertList.getProperty("DISPLAY_TIER")%><%}else {%>Tier<%}%>
      </td>
              <td valign="middle" class="text-blue-01-bold" width="100">Location</td>


            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
                <div style="height:200px; overflow:auto;">
                  <table id ="resultTable" width="100%"  border="0" cellspacing="0" cellpadding="0">

         <% final String RESULT_NOT_FOUND_MESSAGE = "No result found";
      		/* flag to show or hide the no result found message for the
      			"Customer Exchange Hub Search Results" section. This section is not in use
      			therefore, the search result will always be null. But, the message will only
      			appear after a user has performed a search
      		*/
			boolean noResultForExchangeHub = false;
     		if(null != searchHcpResults && searchHcpResults.size() > 0){
     		    noResultForExchangeHub = true;
     		    ExpertDetails expert = new ExpertDetails();
         		for(int i=0; i<searchHcpResults.size(); i++) {
         		   expert = (ExpertDetails) searchHcpResults.get(i);
         		%>

         	  <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
              <td width="25" valign="middle" class="text-blue-01"><input name="checkedAttendee" type="radio" value="<%=("kol;"+expert.getId() + ";" +expert.getLastName()+ ", " + expert.getFirstName()).replaceAll("'","\'")%>"></td>

              <td valign="middle" width="110" class="text-blue-01"><%=expert.getLastName() + ", " + expert.getFirstName()%></td>
              <td valign="middle" width="150" class="text-blue-01"><%=expert.getMslOlType() != null ? expert.getMslOlType() : "N.A"%></td>
              <td valign="middle" width="100" class="text-blue-01"><%=expert.getAddressCity() != null ? expert.getAddressCity() + ", " + expert.getAddressState() : "N.A"%></td>
            </tr>

            <% }
         	} else { %>
            <tr class="back-white-02-light">
              <td width="15" height="20" valign="top">&nbsp;</td>
              <td><font face ="verdana" size ="2" color="red"><b><%=RESULT_NOT_FOUND_MESSAGE %></b></font></td>
            </tr>
            <% }%>
            </table>

         </div></td>
         </tr>
        <tr>
          <td height="20" align="left" valign="top" class="">
		<div class="myexpertlist" style=width:100%>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width="2%" height="20">&nbsp;</td>
              <td width="2%">&nbsp;</td>
              <td width="2%"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="myexperttext">Customer Exchange Hub Search Results</td>
            </tr>
          </table>

		</div>
		</td>
        </tr>
         <tr>
         <td height="10" align="left" class="back-white">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="">
            <tr bgcolor="#f5f8f4">

              <td width="25" valign="middle" class="text-blue-01-bold">&nbsp;</td>

              <td valign="middle" class="text-blue-01-bold" width="110">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="150"><%if(featuresExpertList!=null && featuresExpertList.getProperty("DISPLAY_TIER")!=null){%>
      <%=featuresExpertList.getProperty("DISPLAY_TIER")%><%}else {%>Tier<%}%>
      </td>
              <td valign="middle" class="text-blue-01-bold" width="100">Location</td>


            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
                <div style="height:100px; overflow:auto;">
                  <table id = "resultOtherCompanyTable" width="100%"  border="0" cellspacing="0" cellpadding="0">
			     	<tr class="back-white-02-light">
	                      <td width="15" height="20" valign="top">&nbsp;</td>
						  <td>
						  	<% if(noResultForExchangeHub){%>
						  	<font face ="verdana" size ="2" color="red">
						  	<b>

						   			<%= RESULT_NOT_FOUND_MESSAGE%>
						   </b>
						   </font>
						   <%} %>
						  </td>
	                </tr>
                  </table>
                </div>
                  <tr>
          <td height="10" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
            <td class="text-blue-01" width="20"><input name="Submit33" type="button"  style="border:0;background : url(images/buttons/add_expert.gif);width:80px; height:23px;" class="button-01" value="" onClick="javascript:setParentTextBox()" /></td>
                <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01"><input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onClick="javascript:window.close()" /></td>
            </tr>

          </table></td>
        </tr>


        <tr>
          <td align="left" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>


        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
</table>
</div>
</form>
</body>
</html>
