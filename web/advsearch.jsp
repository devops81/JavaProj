<%@ page language="java" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.forms.AdvancedSearchForm" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.util.*"%>

<%
    if (request.getSession().getAttribute(Constants.CURRENT_USER) == null) {
        response.sendRedirect("login.htm");
    }

    session.setAttribute("refreshed_event_add","false");
    User searchResult[] = null;
    List resultList = new ArrayList();
    if (null != session.getAttribute("ADV_SEARCH_RESULT") &&
            !"".equals(session.getAttribute("ADV_SEARCH_RESULT"))) {
        searchResult = (User[]) session.getAttribute("ADV_SEARCH_RESULT");

        if(searchResult != null && searchResult.length>0) {
            User userObj = null;
            for(int i=0;i<searchResult.length;i++) {
                userObj = searchResult[i];
                if(userObj != null) {
                    resultList.add(userObj);
                }
            }
        }

		if(resultList != null && !resultList.isEmpty()) {
            Collections.sort(resultList, new Comparator() {
            public int compare(Object o1, Object o2) {
                User dto1 = (User) o1;
                User dto2 = (User) o2;
                int result = -1;
                if(dto1 != null && dto1.getLastName() != null && dto2 != null && dto2.getLastName() != null) {
                   result = dto1.getLastName().toUpperCase().compareTo(dto2.getLastName().toUpperCase());
                }
                return result;
            }
        });
        }
    }
    AdvancedSearchForm advancedSearchForm = null;
    if (null != session.getAttribute("ADV_SEARCH_FROM") &&
            !"".equals(session.getAttribute("ADV_SEARCH_FROM"))) {
        advancedSearchForm = (AdvancedSearchForm) session.getAttribute("ADV_SEARCH_FROM");
    }

    OptionLookup[] taArray = null;
    if (null != session.getAttribute("THERAPAUTIC_AREA") &&
            !"".equals(session.getAttribute("THERAPAUTIC_AREA"))) {
        taArray = (OptionLookup[]) session.getAttribute("THERAPAUTIC_AREA");
    }
    OptionLookup[] tierArray = null;
    if (null != session.getAttribute("TIER") &&
            !"".equals(session.getAttribute("TIER"))) {
        tierArray = (OptionLookup[]) session.getAttribute("TIER");
    }
    OptionLookup[] topicArray = null;
    if (null != session.getAttribute("TOPIC_EXPERTIS") &&
            !"".equals(session.getAttribute("TOPIC_EXPERTIS"))) {
        topicArray = (OptionLookup[]) session.getAttribute("TOPIC_EXPERTIS");
    }
    OptionLookup[] specialtyArray = null;
    if (null != session.getAttribute("SPECIALTY") &&
            !"".equals(session.getAttribute("SPECIALTY"))) {
        specialtyArray = (OptionLookup[]) session.getAttribute("SPECIALTY");
    }
    OptionLookup[] platformArray = null;
    if (null != session.getAttribute("PLATFORM") &&
            !"".equals(session.getAttribute("PLATFORM"))) {
        platformArray = (OptionLookup[]) session.getAttribute("PLATFORM");
    }
    OptionLookup[] publicationArray = null;
    if (null != session.getAttribute("PUBLICATION") &&
            !"".equals(session.getAttribute("PUBLICATION"))) {
        publicationArray = (OptionLookup[]) session.getAttribute("PUBLICATION");
    }
    OptionLookup countryLookup[] = null;
    if (session.getAttribute("COUNTRY_LIST") != null) {
        countryLookup = (OptionLookup[]) session.getAttribute("COUNTRY_LIST");
    }

    OptionLookup stateLookup[] = null;
    if (session.getAttribute("STATE_LIST") != null) {
        stateLookup = (OptionLookup[]) session.getAttribute("STATE_LIST");
    }
   String fromKOLStrategy = null;
   if (null != session.getAttribute("fromKOLStrategy")){
       fromKOLStrategy = (String)session.getAttribute("fromKOLStrategy");
   }
    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
		message = (String) session.getAttribute("MESSAGE");
	}
    OptionLookup[] research = null;
    if(session.getAttribute("RESEARCH") != null) {
        research = (OptionLookup[]) session.getAttribute("RESEARCH");
    }

    OptionLookup[] posAmgenScience = null;
    if(session.getAttribute("POS_AMGEN_SCIENCE") != null) {
        posAmgenScience = (OptionLookup[]) session.getAttribute("POS_AMGEN_SCIENCE");
    }
    String fromOLAlignment = null;
   if (null != session.getAttribute("fromOLAlignment")){
       fromOLAlignment = (String)session.getAttribute("fromOLAlignment");
   }
   String fromEvents = null;
   if (null != session.getAttribute("fromEvents")){
       fromEvents = (String)session.getAttribute("fromEvents");
   }
    String resetCon = null;
    if (session.getAttribute("RESET") != null) {
		resetCon = (String) session.getAttribute("RESET");
	}
   String staffIdOL = null != session.getAttribute("STAFFID") ? (String)   session.getAttribute("STAFFID") : null;
   String userName =  null != session.getAttribute("USERNAME") ? (String) session.getAttribute("USERNAME") : null;
   String email = null != session.getAttribute("EMAIL") ? (String)  session.getAttribute("EMAIL") : null;
   String phone = null != session.getAttribute("PHONE") ? (String)  session.getAttribute("PHONE") : null;
   boolean isAlreadySelected = false;
%>
<%@ include file="header.jsp" %>
<HTML>
<HEAD>
<style>
tr {}
.coloronmouseover
{
BACKGROUND-COLOR: #E2EAEF
}
.coloronmouseout
{
BACKGROUND-COLOR: #ffffff
}</style>

    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
    <style type="text/css">
        <!--
        .style1 {
            COLOR: #0080ff
        }

        -->
    </style>
</HEAD>
<script language="javascript">

    function addAttendee(username, phone, email, staffid) {
        document.advancedSearchForm.amgenContact.value = username;
        document.advancedSearchForm.staffId.value = staffid;

    }
    function resetVals() {
        var thisform = document.advancedSearchForm;
        <%if (null != fromKOLStrategy && "true".equalsIgnoreCase(fromKOLStrategy)){%>
          thisform.action="<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&reset=yes&fromKOLStrategy=true";
        <%}else if(null != fromOLAlignment && "true".equalsIgnoreCase(fromOLAlignment)){%>
           thisform.action="<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&reset=yes&fromOLAlignment=true&staffId=<%=staffIdOL%>&userName=<%=userName%>&email=<%=email%>&phone=<%=phone%>";
        <%}else if(null != fromEvents && "true".equalsIgnoreCase(fromEvents)){%>
           thisform.action="<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&reset=yes&fromEvents=true";
        <%}else{%>
           thisform.action="<%=CONTEXTPATH%>/users.htm?action=<%=ActionKeys.ADV_SEARCH_HOME%>&reset=yes";
        <%}%>

        thisform.submit();
    }

    function help() {
        alert("For demonstration purpose only. All links are just placeholders.");
    }

   function openWindow() {
        employeesearch = window.open('employee_search.htm', 'employeesearch', 'width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
        if(employeesearch != null && employeesearch.document != null &&
                employeesearch.document.employee_search != null && employeesearch.document.employee_search.parentFormName != null) {
            employeesearch.document.employee_search.parentFormName.value = "advSearch";
        }
    }

    function sendtoChild(data) {
        employeesearch.document.employee_search.parentFormName.value = data;
    }

    function searchOL() {
        if(window.event.keyCode == 0 || window.event.keyCode == 13) {
            var thisform = document.advancedSearchForm;
            if(thisform != null && thisform.zip != null && (isNaN(thisform.zip.value) ||
                    (thisform.zip.value != null && thisform.zip.value != "" && thisform.zip.value.length < 5))) {
                alert("Please enter 5 digit numbers only.")
                return false;
            }
            thisform.action = "<%=CONTEXTPATH%>/advancedSearch.htm?action=<%=ActionKeys.ADV_SEARCH_USER%>";
            thisform.keyWord.value = checkAndReplaceApostrophe(thisform.keyWord.value);
			thisform.lastName.value = checkAndReplaceApostrophe(thisform.lastName.value);
			thisform.firstName.value = checkAndReplaceApostrophe(thisform.firstName.value);
			thisform.organisation.value = checkAndReplaceApostrophe(thisform.organisation.value);
			thisform.address.value = checkAndReplaceApostrophe(thisform.address.value);
			thisform.amgenContact.value = checkAndReplaceApostrophe(thisform.amgenContact.value);
            openProgressBar();
            thisform.submit();
        }
    }

 function addExpertToOLSegment(){

		  var thisform = document.advancedSearchForm;
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
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

        document.advancedSearchForm.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.KOL_ADD_EXPERTS%>&fromKOLStrategy=true";
	//	document.searchKOL.target = "_top";
		document.advancedSearchForm.submit();
     }

   function addExpertsToList(){
       var thisform = document.advancedSearchForm;

          var flag = false ;
		  if (null != thisform.ids && thisform.ids.length != undefined){

		  for (var i = 0;  null != thisform.ids && i < thisform.ids.length; i++) {

            if (thisform.ids[i].checked) {
                    flag = true;
                    break;
                }
           }
          }
          else{
          	 if (thisform.ids.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

     document.advancedSearchForm.action = "<%=CONTEXTPATH%>/OLAlignment.htm?action=<%=ActionKeys.KOL_ADD_EXPERTS%>&fromOLAlignment=true";
	 document.advancedSearchForm.submit();

   }
   function addExpertsToAttendeeList(){
       var thisform = document.advancedSearchForm;
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
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

     document.advancedSearchForm.action = "<%=CONTEXTPATH%>/event_add.htm?action=<%=ActionKeys.KOL_ADD_EXPERTS%>&fromEvents=false";
	 document.advancedSearchForm.submit();

   }

    function addORXName(valueFromChild) {
        var thisform = document.advancedSearchForm;
        for (var i = 0; i < valueFromChild.length; i++) {
            thisform.organisation.value = valueFromChild[i].split(";")[2];
            thisform.orgEntityId.value = valueFromChild[i].split(";")[1];
        }
    }
</script>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
<form name="advancedSearchForm" onKeyPress="searchOL()" method="post" onSubmit="javascript:openProgressBar()">
<input type="hidden" name="staffId"/>
<input type="hidden" name="orgEntityId" value="<%=advancedSearchForm != null && advancedSearchForm.getOrgEntityId() != null ? advancedSearchForm.getOrgEntityId().replaceAll("''","'"):""%>"/>
<div class="contentmiddle">
   <div class="producttext">
		 <div class="myexpertlist">
			 <table width="100%">
					<tbody>
						<tr style="color: rgb(76, 115, 152);">
						    <td width="1%" align="left">
							   <img src="images/searchpic.jpg">
                            </td>
						    <td width="50%" align="left">
									<div class="myexperttext">Advanced Search (scroll down for more search options)</div>
							</td>

							</tr>
						</tbody>
				</table>
		 </div>


<div style="height:200; overflow:auto;">
<!--table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-white">
    <tr>
        <td height="10" colspan="9"></td>
    </tr>
</table-->
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-white">
    <tr>
        <td height="10" colspan="9"></td>
    </tr>
    <tr>
	    <td height="10" width="1%"></td>
        <td width="22%" class="boldp">Keyword Search:&nbsp;</td>
        <td width="1%" class="boldp">&nbsp;</td>
        <td valign="top" colspan=6><input name="keyWord" type="text" class="field-blue-01-180x20" maxlength="50"
                                value="<%=advancedSearchForm != null && advancedSearchForm.getKeyWord() != null ? advancedSearchForm.getKeyWord().replaceAll("''","'"):""%>">        </td>
        <!--td class="boldp" colspan=6>&nbsp;</td-->
        <!--td width="180" class="boldp">&nbsp;</td>
        <td width="20" class="boldp">&nbsp;</td>
        <td width="180" class="boldp">&nbsp;</td>
        <td class="boldp">&nbsp;</td-->
    </tr>
    <tr>
        <td height="10" colspan="9"></td>
    </tr>
    <tr>
	    <td height="10">&nbsp;</td>
        <td width="22%" class="boldp">Last Name:</td>
        <td width="1%" class="boldp">&nbsp;</td>
        <td width="20%" class="boldp">First Name:</td>
        <td width="2%" class="boldp">&nbsp;</td>
        <td width="20%" class="boldp">Affiliated Organization:</td>
        <td width="2%" class="boldp">&nbsp;</td>
        <td width="25%" class="boldp">&nbsp;</td>
        <td class="boldp" width="8%">&nbsp;</td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td valign="top"><input name="lastName" type="text" class="field-new-01-180x20" maxlength="50"
                                value="<%=advancedSearchForm != null && advancedSearchForm.getLastName() != null ? advancedSearchForm.getLastName().replaceAll("''","'"):""%>">
        </td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="firstName" type="text" class="field-new-01-180x20" maxlength="50"
                                value="<%=advancedSearchForm != null && advancedSearchForm.getFirstName() != null ? advancedSearchForm.getFirstName().replaceAll("''","'"):""%>">
        </td>
        <td valign="top">&nbsp;</td>
        <td valign="top" colspan="3"><input name="organisation" type="text" class="field-new-01-180x20" maxlength="50" value="<%=advancedSearchForm != null && advancedSearchForm.getOrganisation() != null ? advancedSearchForm.getOrganisation().replaceAll("''","'"):""%>" readonly>
		&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:window.open('interactionOrgSearch.htm?action=fromAdvSearch','searchOrg','width=720,height=450,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-link">Lookup Organizations</a>
        </td>
        <td valign="top" width="8%">&nbsp;</td>
    </tr>
    <tr>
        <td height="10" colspan="9"></td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td class="boldp">Address:</td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp">Country:</td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp">State/Prov.: </td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp" width="8%">&nbsp;</td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td class="boldp"><input name="address" type="text" class="field-new-01-180x20" maxlength="50"
                                        value="<%=advancedSearchForm != null && advancedSearchForm.getAddress() != null ? advancedSearchForm.getAddress().replaceAll("''","'"):""%>">
        </td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp"><SELECT name="country" class="field-new-01-180x20">
		 <OPTION value="-1" selected>Any</OPTION>
			  <%
			     if (countryLookup != null && countryLookup.length > 0) {
                     OptionLookup lookup = null;
                     isAlreadySelected = false;
                     for (int i = 0; i < countryLookup.length; i++) {
                     lookup = countryLookup[i];
                		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
              %>
              <option value="<%=lookup.getOptValue()%>"
              <%if(advancedSearchForm != null && advancedSearchForm.getCountry() != null
            		  && lookup.getOptValue().equals(advancedSearchForm.getCountry())) {
            	  isAlreadySelected = true;
            		  %> selected <% }
            		  else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
              <%
				  }
                }
              %>
				</SELECT> </td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp"><select name="state" class="field-new-01-180x20">
		 <OPTION value="-1" selected>Any</OPTION>
                 <%
                if (stateLookup != null && stateLookup.length > 0) {
                    OptionLookup lookup = null;
                    isAlreadySelected = false;
                    for (int i = 0; i < stateLookup.length; i++) {
                        lookup = stateLookup[i];
                		String selected = "" ;
                  		if(lookup.isDefaultSelected())
                  			selected = "selected";
            %>
            <option value="<%=lookup.getOptValue()%>"
            <%if(advancedSearchForm != null && advancedSearchForm.getState() != null
            		&& lookup.getOptValue().equals(advancedSearchForm.getState())) {
            		isAlreadySelected = true;
            		%> selected% <% }
            		else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
            <%
                    }
                }
            %>
                </select>       </td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp">&nbsp;</td>
        <td class="boldp" width="8%">&nbsp;</td>
    </tr>
    <tr>
        <td height="10" colspan="9"></td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td class="boldp">Postal Code:</td>
        <td colspan="7" class="boldp">&nbsp;&nbsp;Assigned <%=DBUtil.getInstance().customer%> Contact</td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td class="boldp"><input name="zip" type="text" class="field-new-01-180x20" maxlength="5"
                                        value="<%=advancedSearchForm != null && advancedSearchForm.getZip() != null ? advancedSearchForm.getZip():""%>">
        </td>
        <td colspan="7" class="boldp">&nbsp;&nbsp;<input name="amgenContact" type="text" class="field-new-01-180x20" maxlength="50"
                                           value="<%=advancedSearchForm != null && advancedSearchForm.getAmgenContact() != null ? advancedSearchForm.getAmgenContact().replaceAll("''","'"):""%>" readonly="true">&nbsp;&nbsp;&nbsp;<a href="#"  onClick="javascript:openWindow();" class="text-blue-01-link">Lookup Company Owner
</a>
                    </td>
    </tr>
    <tr>
        <td height="10" colspan="9" valign="top"></td>
    </tr>
    <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td colspan="8" class="boldp">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="180" align="right" class="boldp"></td>
                    <td width="20" align="right" class="boldp">&nbsp;</td>
                    <td width="180">&nbsp;</td>
                    <td width="20">&nbsp;</td>
                    <td width="180">&nbsp;<td width="20" class="text-blue-01">&nbsp;</td>
                    <td class="text-blue-01">&nbsp;<!-- (Last Name, First Name) --></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height="10" colspan="9" valign="top"></td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-white">
<tr>
    <td width="1%" height="20" valign="top">&nbsp;</td>
    <td width="22%" class="boldp">Therapeutic Area</td>
    <td width="23%" class="boldp">&nbsp;&nbsp;Tier</td>
    <td width="21%" class="boldp">Topic Expertise</td>
    <td width="32%" class="boldp">Specialty</td>
    <td class="boldp" width="1%">&nbsp;</td>
</tr>
<tr>
    <td height="2%" valign="top">&nbsp;</td>
    <td class="boldp"><SELECT name="ta" class="field-new-01-180x20">
        <OPTION value="-1" selected>Any</OPTION>
        <%
            if (taArray != null && taArray.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < taArray.length; i++) {
                    lookup = taArray[i];
            		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
        %>

        <option value="<%=lookup.getOptValue()%>"
        <%if(advancedSearchForm != null && advancedSearchForm.getTa() != null
        		&& lookup.getOptValue().equals(advancedSearchForm.getTa())) {
        	isAlreadySelected = true;
        		%>selected<% }
        		else if(!isAlreadySelected){ %><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </SELECT></td>
    <td class="boldp">&nbsp;&nbsp;<SELECT name="tier" class="field-new-01-180x20">
        <OPTION value="-1" selected>Any</OPTION>
        <%
            if (tierArray != null && tierArray.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < tierArray.length; i++) {
                    lookup = tierArray[i];
            		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
        %>

        <option value="<%=lookup.getOptValue()%>"
        <%if(advancedSearchForm != null && advancedSearchForm.getTier() != null
        		&& lookup.getOptValue().equals(advancedSearchForm.getTier())) {
        	isAlreadySelected = true;
        		%> selected <% }
        		else if(!isAlreadySelected) { %><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </SELECT></td>
    <td class="boldp"><SELECT name="topicExpertis" class="field-new-01-180x20">
        <OPTION value="-1" selected>Any</OPTION>
        <%
            if (topicArray != null && topicArray.length > 0) {
                OptionLookup lookup = null;
                isAlreadySelected = false;
                for (int i = 0; i < topicArray.length; i++) {
                    lookup = topicArray[i];
            		String selected = "" ;
              		if(lookup.isDefaultSelected())
              			selected = "selected";
        %>

        <option value="<%=lookup.getOptValue()%>"
        <%if(advancedSearchForm != null && advancedSearchForm.getTopicExpertis() != null
        		&& lookup.getOptValue().equals(advancedSearchForm.getTopicExpertis())) {
        	isAlreadySelected = true;
        		%>selected <% }
        		else if(!isAlreadySelected){%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
        <%
                }
            }
        %>
    </SELECT></td>
    <td class="boldp">
	<input name="specialty" type="text" class="field-new-01-180x20" maxlength="50"
                                           value="<%=advancedSearchForm != null && advancedSearchForm.getSpecialty() != null ? advancedSearchForm.getSpecialty().replaceAll("''","'"):""%>">


	</td>
    <td class="boldp" width="1%">&nbsp;</td>
</tr>
<tr>
    <td height="10" colspan="6" valign="top"></td>
</tr>

</table>

</div></td>
</tr>


<tr>
    <td class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1"></td>
    <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="10" class="back-white"></td>
</tr>
<tr>
    <td height="10" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td class="text-blue-01" width="20"> <input type="button" onClick="javascript:searchOL();" style="background: transparent url(images/buttons/search_expert.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 90px; height: 22px;" value="" name="SearchO1"/>
														   </td>
                <td class="text-blue-01" width="20">&nbsp;</td>
                <td class="text-blue-01" valign=top>												<input type="button" onClick="javascript:resetVals();" style="background: transparent url(images/buttons/reset.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 65px; height: 22px;" value="" name="Reset"/>
												</td>
            </tr>
        </table>
    </td>
</tr>
</div><!--end of producttext div-->

<div class="producttext">
      <div class="myexpertlist">
			 <table width="100%" border=0>
					<tbody>
						<tr style="color: rgb(76, 115, 152);">
						    <td width="1%" align="left">
							   <img src="images/searchpic.jpg">
                            </td>
						    <td width="50%" align="left">
									<div class="myexperttext">Search Results (scroll down for more search results)</div>
							</td>
							 <%
                					if(session.getAttribute("ADV_SEARCH_RESULT") != null) {
							 %>
									<%--<td width="10% align="right"><a href="expert_map.htm?expertsToDisplay=AdvSearchResults"><img align="right" src="<%=COMMONIMAGES%>/world.gif" width="20%" title="Geo mapping"
                                                            height="28" border="0"/></a></td>
							        <td width="5% align="right"><a href="papervision.jsp"><img align="right" src="<%=COMMONIMAGES%>/print_profile.gif" title="Index Cards" border="0"/></a></td>
							--%><%
								}
							%>

					  </tr>
			   </tbody>
		</table>
	  </div>

            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <% if ( (null != fromKOLStrategy  && "true".equalsIgnoreCase(fromKOLStrategy))  ||
                    (null != fromOLAlignment &&  "true".equalsIgnoreCase(fromOLAlignment))||
                    (null != fromEvents &&  "true".equalsIgnoreCase(fromEvents))) {%>
                <td width="30" >&nbsp;</td>
                <%}%>
                <td width="20" class="text-white-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td width="120" class="text-blue-01-bold">Title</td>

                <td width="241" class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%> Name </td>
                <td width="328" class="text-blue-01-bold">&nbsp;&nbsp;&nbsp;Specialty</td>
                <td width="256" class="text-blue-01-bold">&nbsp;&nbsp;Location</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
  <td height="110"  width="100%" valign="top" class="back-white">
      <div style="position:relative; height:100; overflow:auto;">
         <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
             <% if (!"".equals(message)) { %>
             <tr align="left" class="back-white">
                <td>&nbsp;
                     <font face ="verdana" size ="2" color="red">
                     <b><%=message%></b>
                     </font>
                <td>
             </tr>
             <% } %>

<%
    User userDTO = null;
    boolean flag = false;
    if ("".equals(message) && null != resultList && resultList.size() > 0) {
        flag = true;
        String expName;
        for (int i = 0; i < resultList.size(); i++) {
            userDTO = (User) resultList.get(i);
            expName = null;
            if(userDTO.getLastName() != null && !"".equals(userDTO.getLastName())) {
                expName = userDTO.getLastName();
            }
            if(userDTO.getFirstName() != null && !"".equals(userDTO.getFirstName())) {
                expName +=", "+userDTO.getFirstName();
            }
            if(userDTO.getMiddleName() != null && !"".equals(userDTO.getMiddleName())) {
                expName +=" "+userDTO.getMiddleName();
            }

%>
<tr>
    <td height="10" align="left" width="100%" valign="top" class=<%=(i % 2 == 0) ? "back-white-02-light" : "back-grey-02-light"%> onmouseover="this.className='coloronmouseover'" onMouseout="this.className='<%=(i % 2 == 0) ? "back-white-02-light" : "back-grey-02-light"%>'"> &nbsp;<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                  <% if (( null != fromKOLStrategy  && "true".equalsIgnoreCase(fromKOLStrategy)||
                  (null != fromEvents && "true".equalsIgnoreCase(fromEvents)))) {%>
                   <td width="30" algin="center" height="20"><input type="checkbox" name="checkIds" value="<%=userDTO.getId()%>"></td>
                  <%} else if (null != fromOLAlignment && "true".equalsIgnoreCase(fromOLAlignment)){%>
                     <td width="20" algin="center" height="20"><input type="checkbox" name="ids" value="<%=userDTO.getId()%>"></td>
                <%}%>
                <td width="20" class="text-white-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td width="120" align="left"
                    class="text-blue-01"><%= userDTO.getTitle()!= null ? userDTO.getTitle().trim() : ""%></td>
                <td width="253" align="left"
                    class="text-blue-01"><A class=text-blue-01-link target='_top' href='expertfullprofile.htm?kolid=<%=userDTO.getId()%>&entityId=<%=userDTO.getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=userDTO.getLastName()%>, <%=userDTO.getFirstName()%>'><%= expName != null?expName:""%></a></td>
                <td width="306" align="left"
                    class="text-blue-01"><%= userDTO.getSpeciality() != null ? userDTO.getSpeciality().trim() : ""%></td>
                <td width="245" align="left"
                    class="text-blue-01">&nbsp;&nbsp;&nbsp;&nbsp;<%= userDTO.getLocation() != null ? userDTO.getLocation().trim() : ""%></td>
            </tr>
        </table>
      </td>
</tr>

<%
        }
    }
%>
   </table>
   </div>
</tr>
<tr>
    <td class="back-blue-03-medium"><table width="100%" border="0">
      <tr>
        <td width="7">&nbsp;<td><%--<tr>
    <td height="10" class="back-white"></td>

</tr>--%>
<tr>
    <td height="10" align="left" valign="top" class="back-white" width="7"></td>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>

<%--<tr>
    <td height="1" align="left" valign="top" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                             width="1" height="1"></td>
</tr>--%>
 <tr>

   <% if (null != fromKOLStrategy  && "true".equalsIgnoreCase(fromKOLStrategy)) {%>
      <TD>&nbsp;</TD>
      <TD height="30" class="back-white">&nbsp;&nbsp<INPUT class=button-01 type="button" style="border:0;background : url(images/buttons/add_expert.gif);width:80px; height:22px;" value="" name="addOL"  <%if (!flag) {%> disabled <%}%>onClick="addExpertToOLSegment()" ></TD>
      <%} else if (null != fromOLAlignment && "true".equalsIgnoreCase(fromOLAlignment)){%>
 </tr>
 <span class="back-white">
 <INPUT class=button-01 type="button" style="border:0;background : url(images/button2.jpg);width:153; height:23px;"  value="" name="addOL2"  <%if (!flag) {%> disabled <%}%> onClick="addExpertsToList()" >
 </span>
 <tr>
   <TD height="30" class="back-white" width="7">&nbsp;</TD>
   <TD height="30" class="back-white">&nbsp;&nbsp;</TD>
   <%} else if (null != fromEvents && "true".equalsIgnoreCase(fromEvents)){%>
 </tr>
 <span class="back-white">
&nbsp;&nbsp; <INPUT class=button-01 type="button"  style="border:0;background : url(images/buttons/add_attendee.gif);width:127; height:22px;" value="" name="addOLForEvents"  <%if (!flag) {%> disabled <%}%> onClick="addExpertsToAttendeeList()" >
 </span>
 <tr>
   <TD height="30" class="back-white" width="7">&nbsp;</TD>
   <TD height="30" class="back-white">&nbsp;&nbsp;</TD>
   <%}%>
 </tr>
</table>
</td>
</tr></td>
        </tr>
    </table>
      <img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1"></td>
    <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
</tr>

</table>
</div>
</div>

</form>
</body>
<%
    session.removeAttribute("MESSAGE");


%>
<%@ include file="footer.jsp" %>
</html>