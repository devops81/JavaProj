<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ include file = "UserCheck.jsp" %>
<%@ page import="com.openq.siteSearch.SiteEntity"%>
<%@page import="com.openq.utils.PropertyReader"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>

<%
	SiteEntity[] siteSearchResult = null;
	String siteSearchMessage = "";
	String isSiteSaved = "false";
	String siteOptionValue = "";
	String studyOptionValue = "";
	String studyOptValueFromInteraction = "";

	String selectStudySiteLOVName = PropertyReader.getLOVConstantValueFor("SELECT_STUDY_SITE");

	if (request.getSession().getAttribute("siteSearchResult") != null)
		siteSearchResult = (SiteEntity []) request.getSession().getAttribute("siteSearchResult");

    if (request.getAttribute("SITE_SEARCH_MESSAGE")!=null)
    	siteSearchMessage = (String) request.getAttribute("SITE_SEARCH_MESSAGE");

    if (request.getAttribute("isSiteSaved")!=null) {
    	isSiteSaved = "true";
    }

    if (request.getAttribute("siteValue") != null) {
    	siteOptionValue = (String)request.getAttribute("siteValue");
    }

    if (request.getAttribute("studyValue") != null) {
    	studyOptionValue = (String)request.getAttribute("studyValue");
    }
    if (request.getSession().getAttribute("studyOptValueFromInteraction") != null)
    	studyOptValueFromInteraction = (String) request.getSession().getAttribute("studyOptValueFromInteraction");

    OptionLookup [] stateLookupArray = (OptionLookup[]) session.getAttribute("SITE_SEARCH_STATE");
    HashMap siteParamMap = new HashMap();
    if(request.getAttribute("SITE_SEARCH_PARAMETER_MAP") != null ){
        siteParamMap = (HashMap) request.getAttribute("SITE_SEARCH_PARAMETER_MAP");
    }
%>
<script language="javascript">

	function validateSearchCriteria() {
		var thisForm = document.site_search;
		if (!((thisForm.centerName != null &&
						thisForm.centerName.value != null && thisForm.centerName.value != "") &&
						(thisForm.city != null && thisForm.city.value != null && thisForm.city.value != "") &&
						(thisForm.state != null && thisForm.state.value != null && thisForm.state.value != ""))) {
			alert("Please enter values for all the required fields");
		}
		else {
			thisForm.submit();
		}

	}
    function associateSite() {
    	var thisForm = document.site_search;
    	var siteSelectedVal;
    	var isSiteSelected;
    	var count = 0;

    	var siteSelected = document.getElementsByName("siteSelected");

    	for (; count<siteSelected.length; count++) {
    		if (siteSelected[count].checked) {
    			isSiteSelected = true;
    			break;
    		}
    	}

    	if (isSiteSelected) {
    		siteSelectedVal = "<%= studyOptValueFromInteraction%>"+'~'+siteSelected[count].value;
    		thisForm.action = "site_search.htm?do=<%=ActionKeys.ASSOCIATE_SITE%>&siteSelectedValue="+siteSelectedVal;
        	thisForm.submit();
    	}
    	else {
    		alert("Please select a Site to associate");
    	}

    }

    function closeWindowIfAssociated() {
    	if ( "true" == "<%=isSiteSaved%>") {
    		alert("Site '" + "<%=siteOptionValue%>"+ "' is now associated with Study '" + "<%=studyOptionValue%>" + "'");
    		window.opener.addStudyOptionValue("<%=studyOptionValue%>");
    		window.opener.clearTextArea("clinicalTrialVisitNotes", false);

    		window.opener.populateChildLOV(window.opener.document.getElementById("selectStudyIMPACTNumberLOV"),
    			"selectStudySiteLOV", true, "<%=selectStudySiteLOVName%>", "", false, "<%=siteOptionValue%>");
    		window.close();
    	}
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Site Search</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
</head>

<body onLoad="closeWindowIfAssociated()">
<form name="site_search" method="post" >
<div>
    <div class="producttext">
            <div class="myexpertlist">
                <div class="myexperttext">
                    <img src="images/searchpic.gif">&nbsp;&nbsp;Search Sites</div>
                <div class="clear"></div>
            </div>
    </div>

    <div style="padding-left: 20px;padding-top: 10px" align="left">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td height="10" colspan="6"></td>
    </tr>
    <tr>
        <td width="3%" height="20">&nbsp;</td>
        <td width="18%" class="text-blue-01">Center Name:(contains)* </td>
        <td width="20%" class="text-blue-01">
        <input type="text" name="centerName" id="centerName"
            class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("centerName") != null ? siteParamMap.get("centerName") : "") %>">
        </td>
        <td width="10%">&nbsp;</td>
        <td width="18%" class="text-blue-01">Address:</td>
        <td width="20%" class="text-blue-01">
        <input type="text" name="address" id="address"
            class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("address") != null ? siteParamMap.get("address") : "") %>">
        </td>
        <td width="11%" class="text-blue-01">&nbsp;</td>
    </tr>
    <tr>
		<td height="10" colspan="6"></td>
	</tr>

<tr>
    <td width="3%" height="20">&nbsp;</td>
	    <td width="18%" class="text-blue-01">Investigator First Name:</td>
	    <td width="20%" class="text-blue-01">
	    	<input type="text" name="firstName" id="firstName"
	    		class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("firstName") != null ? siteParamMap.get("firstName") : "") %>">
	    </td>
	    <td width="10%">&nbsp;</td>
	    <td width="18%" class="text-blue-01">City:(contains)*</td>
	    <td width="20%" class="text-blue-01">
		<input type="text" name="city" id="city"
			class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("city") != null ? siteParamMap.get("city") : "") %>">
	    </td>
	    <td width="11%" class="text-blue-01">&nbsp;</td>
    </tr>
    <tr>
		<td height="10" colspan="6"></td>
	</tr>
    <tr>
	    <td width="3%" height="20">&nbsp;</td>
	    <td width="18%" class="text-blue-01">Investigator Last Name:</td>
	    <td width="20%" class="text-blue-01">
	    	<input type="text" name="lastName" id="lastName"
	    		class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("lastName") != null ? siteParamMap.get("lastName") : "") %>">
	    </td>
	    <td width="10%">&nbsp;</td>
	    <td width="18%" class="text-blue-01">State/Province:*</td>
        <td width="20%" class="text-blue-01">
           <select name="state" id="state" class="field-blue-01-180x20">
            <%  boolean isAlreadySelected = false;
                if (stateLookupArray != null && stateLookupArray.length > 0) {
                    OptionLookup stateLookup = null;
                    for (int i = 0; i < stateLookupArray.length; i++) {
                        stateLookup = stateLookupArray[i];
                        String selected = "" ;
                        if(stateLookup.isDefaultSelected()){
                            selected = "selected";
                        }

            %>
            <option value="<%=stateLookup.getOptValue()%>"
            <%if(siteParamMap.get("state") != null && stateLookup.getOptValue().equals(siteParamMap.get("state"))){
                    isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected){%><%=selected%> <%} %>><%=stateLookup.getOptValue()%></option>
            <%
                    }
                }
            %>
           </select>
        </td>
	    <td width="11%" class="text-blue-01">&nbsp;</td>
    </tr>
    <tr>
		<td height="10" colspan="6"></td>
	</tr>
    <tr>
	    <td width="3%" height="20">&nbsp;</td>
	    <td width="18%" class="text-blue-01">Postal/Code:</td>
	    <td width="20%" class="text-blue-01">
        <input type="text" name="zipCode" id="zipCode"
            class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("zipCode") != null ? siteParamMap.get("zipCode") : "") %>">
	    </td>
		<td width="3%" height="20">&nbsp;</td>
	    <td width="18%" class="text-blue-01">Country:</td>
	    <td width="20%" class="text-blue-01">
        <input type="text" name="country" id="country"
            class="field-blue-01-180x20" maxlength="50" value="<%=(siteParamMap.get("country") != null ? siteParamMap.get("country") : "") %>">
	    </td>
    </tr>
    <tr>
    	<td height="25" colspan="6"></td>
	</tr>
	<tr>
		<td width="3%" height="20">&nbsp;</td>
	    <td width="18%">
	    <input name="Submit33" type="button" class="button-01" value="Search Sites"
				onClick="validateSearchCriteria()"/>
	    </td>
	    <td colspan="4"></td>
	</tr>
	<tr>
		<td height="10" colspan="6"></td>
	</tr>
    </table>
    </div>
    <br/>
    <div class="producttext" style="overflow:auto">
    	<div class="myexpertlist">
        	<div class="myexperttext">
            	<img src="images/searchpic.gif">&nbsp;&nbsp;Synergy Search Results</img>
            </div>
            <div class="clear"></div>
        </div>

        <table width="100%" cellspacing="0">
        	<tr bgcolor="#faf9f2">
        		<td width="3%" align="center">&nbsp;&nbsp;&nbsp;</td>
		        <td width="10%" class="expertListHeader">Investigator First Name</td>
		        <td width="10%" class="expertListHeader">Investigator Last Name</td>
		        <td width="12%" class="expertListHeader">Center Name</td>
		        <td width="10%" class="expertListHeader">Address</td>
		        <td width="10%" class="expertListHeader">City</td>
		        <td width="10%" class="expertListHeader">Stat/Prov</td>
		        <td width="10%" class="expertListHeader">Postal/Code</td>
		        <td width="10%" class="expertListHeader">Country</td>
		    </tr>
		    <% if (siteSearchMessage != null && !("".equals(siteSearchMessage))) { %>
	        <tr class="back-white">
	            <td width="3%" height="20">&nbsp;</td>
	            <td class="text-blue-01" colspan="9">
	            	<font face ="verdana" size ="2" color="red"><b><%=siteSearchMessage%></b></font>
	            </td>
	        </tr>
	        <% } %>
	        <% if (siteSearchResult != null && siteSearchResult.length > 0) {
	        	for(int i=0; i<siteSearchResult.length; i++) {
	        		SiteEntity siteEntity = (SiteEntity) siteSearchResult[i];
	        %>

	        <tr class='<%=(i%2==0)?"back-white-02-light":"back-grey-02-light"%>'>
	            <td width="3%">
	            <input name="siteSelected" type="radio"
	            	value="<%=(siteEntity.getCenterName()).replaceAll("'","\'")%>" />
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getFirstName()!= null)? siteSearchResult[i].getFirstName():""%>
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getLastName()!= null)? siteSearchResult[i].getLastName():""%>
	            </td>
	            <td width="12%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getCenterName()!= null)? siteSearchResult[i].getCenterName():""%>
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getAddress()!= null)? siteSearchResult[i].getAddress():""%>
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getCity()!= null)? siteSearchResult[i].getCity():""%>
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getProvinceCounty()!= null)? siteSearchResult[i].getProvinceCounty():""%>
	            </td>
	            <td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getPoastalCode()!= null)? siteSearchResult[i].getPoastalCode():""%>
	            </td>
				<td width="10%" class="text-blue-01" align="left">
	            <%= (siteSearchResult[i].getCountry()!= null)? siteSearchResult[i].getCountry():""%>
	            </td>
	        </tr>
	        <%} } %>


        </table>
    </div>
    <br/>
    <div class="producttext"  align="left">
         <div style="padding-left: 20px;padding-top: 10px" align="left">
         	<table>
         		<tr>
		     		<td>
		     			<input name="Submit33" type="button" class="button-01" value="Associate Site"
		     				onClick="associateSite()"/>
					</td>
         			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
         			<input name="Submit33" type="button"
         				style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;"
         					class="button-01" value="" onClick="javascript:window.close()" />
         			</td>

         	</table>
         </div>
    </div>
</div>
</form>
</body>
</html>
