<%@ page language="java" %>
<%@ page import="com.openq.eav.option.OptionLookup,
                 com.openq.user.User" %>
<%@ page import="com.openq.eav.org.Organization"%>
<%@ page import="java.util.*"%>
<%

    String userType = null;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();

    }
    OptionLookup countryLookup[] = null;
    if (session.getAttribute("COUNTRY_LIST") != null) {
        countryLookup = (OptionLookup[]) session.getAttribute("COUNTRY_LIST");
    }

    OptionLookup stateLookup[] = null;
    if (session.getAttribute("STATE_LIST") != null) {
        stateLookup = (OptionLookup[]) session.getAttribute("STATE_LIST");
    }

    OptionLookup orgLookup[] = null;
    if (session.getAttribute("ORGNIZATION_TYPE") != null) {
        orgLookup = (OptionLookup[]) session.getAttribute("ORGNIZATION_TYPE");
    }


    OptionLookup majorSegmentLookup[] = null;
    if (session.getAttribute("MAJOR_SEGMENT") != null) {
        majorSegmentLookup = (OptionLookup[]) session.getAttribute("MAJOR_SEGMENT");
    }

    OptionLookup minorSegmentLookup[] = null;
    if (session.getAttribute("MINOR_SEGMENT") != null) {
        minorSegmentLookup = (OptionLookup[]) session.getAttribute("MINOR_SEGMENT");
    }
    ArrayList resultList = new ArrayList();
    Organization[] orgSearchResult = null;
    if (session.getAttribute("ORGANIZATION_ADV_SEARCH_RESULT") != null) {
        orgSearchResult = (Organization[]) session.getAttribute("ORGANIZATION_ADV_SEARCH_RESULT");

        if(orgSearchResult != null && orgSearchResult.length>0) {
            for(int i=0;i<orgSearchResult.length;i++) {
                resultList.add(orgSearchResult[i]);
            }
        }
        if(resultList != null && !resultList.isEmpty()) {
            Collections.sort(resultList, new java.util.Comparator() {
            public int compare(Object o1, Object o2) {
                Organization dto1 = (Organization) o1;
                Organization dto2 = (Organization) o2;
                return dto1.getName().toUpperCase().compareTo(dto2.getName().toUpperCase());
            }
        });
        }
        if(resultList != null && resultList.size()>0) {
            orgSearchResult = new Organization[resultList.size()];
            for(int r=0;r<resultList.size();r++) {
                orgSearchResult[r] = (Organization) resultList.get(r);
            }
        }
    }

    String orgNameSelected = null;
    if(session.getAttribute("ORGNAME_SELECTED") != null &&
            !"".equals(session.getAttribute("ORGNAME_SELECTED"))) {
        orgNameSelected = (String) session.getAttribute("ORGNAME_SELECTED");
    }

    String acroNymSelected = null;
    if(session.getAttribute("ACRONAME_SELECTED") != null &&
            !"".equals(session.getAttribute("ACRONAME_SELECTED"))) {
        acroNymSelected = (String) session.getAttribute("ACRONAME_SELECTED");
    }

    String countrySelected = null;
    if(session.getAttribute("COUNTRY_SELECTED") != null &&
            !"".equals(session.getAttribute("COUNTRY_SELECTED"))) {
        countrySelected = (String) session.getAttribute("COUNTRY_SELECTED");
    }

    String stateSelected = null;
    if(session.getAttribute("STATE_SELECTED") != null &&
            !"".equals(session.getAttribute("STATE_SELECTED"))) {
        stateSelected = (String) session.getAttribute("STATE_SELECTED");
    }

    String typeSelected = null;
    if(session.getAttribute("TYPE_SELECTED") != null &&
            !"".equals(session.getAttribute("TYPE_SELECTED"))) {
        typeSelected = (String) session.getAttribute("TYPE_SELECTED");
    }

    String majorSelected = null;
    if(session.getAttribute("MAJOR_SELECTED") != null &&
            !"".equals(session.getAttribute("MAJOR_SELECTED"))) {
        majorSelected = (String) session.getAttribute("MAJOR_SELECTED");
    }

    String minorSelected = null;
    if(session.getAttribute("MINOR_SELECTED") != null &&
            !"".equals(session.getAttribute("MINOR_SELECTED"))) {
        minorSelected = (String) session.getAttribute("MINOR_SELECTED");
    }
    String message = null;
    if (session.getAttribute("MESSAGE") != null) {
		message = (String) session.getAttribute("MESSAGE");
	}
	String fromOrgAlignment = "false";
    if (request.getParameter("fromOrgAlignment")!=null){
	fromOrgAlignment = request.getParameter("fromOrgAlignment");
	}
    boolean isAlreadySelected = false;
%>
<%@ include file="header.jsp" %>
<html>
<head>
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
<script type="text/javascript" src="js/utilityFunctions.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Openq 3.1</title>
<!--link type="text/css" rel="stylesheet" href="css/style.css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>
<script type="text/javascript">

    function submitSearch() {
        if(window.event.keyCode == 0 || window.event.keyCode == 13) {
            var thisform = document.advancedOrgSearchForm;

            if(true) {

				thisform.orgName.value = checkAndReplaceApostrophe(thisform.orgName.value);
				thisform.acroNym.value = checkAndReplaceApostrophe(thisform.acroNym.value);
                thisform.action = "<%=CONTEXTPATH%>/advOrgSearch.htm?action=<%=ActionKeys.ADV_SEARCH_ORG_MAIN%>&fromOrgAlignment=<%=fromOrgAlignment%>";
			    openProgressBar();
                thisform.submit();

            } else {
                alert("Please select/enter specific search criteria")
                return false;
            }
        }
    }

    function resetFields() {
        var thisform = document.advancedOrgSearchForm;
        thisform.action="<%=CONTEXTPATH%>/advanced_org_search.htm?action=<%=ActionKeys.ADV_SEARCH_ORG%>&reset=yes";
        thisform.submit();
    }

    function addOrgToAlignment(){
	  var thisform = document.advancedOrgSearchForm;
	  var flag = false ;
	  if (null != thisform.orgSegmentId && thisform.orgSegmentId.length != undefined){
		  for (var i = 0;  null != thisform.orgSegmentId && i < thisform.orgSegmentId.length; i++) {
			if (thisform.orgSegmentId[i].checked) {
				flag = true;
				break;
			}
		  }
	  }else{
			if (thisform.orgSegmentId.checked) {
				flag = true;
			}
	  }

   	  if (!flag) {
    		alert("Please select at least one Organization.");
			return;
	  }else{
			thisform.action="<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.ADD_ORG_TO_ALIGNMENT%>";
	 	    thisform.submit();
 	 }
   }

</script>

<body>
<form name="advancedOrgSearchForm" method="post" onKeyPress="submitSearch()">


	<div class="contentmiddle">
		<div class="producttext">
			<div class="myexpertlist">
				<table width="100%">
					<tbody>
						<tr style="color: rgb(76, 115, 152);">
							<td width="50%" align="left">
								<div class="myexperttext">Search Organization</div>
							</td>

						</tr>
					</tbody>
				</table>
			</div>
			<div class="table" align="left">
				<table width="80%" height="50%" cellspacing="0">
					<tbody>
						<tr>
							<td width=10>&nbsp;</td>
						</tr>
						<tr>
						    <td width="2%"/>
							<td class="boldp" width="25%">Organization Name</td>

							<td class="boldp" width="25%">Acronym/Abbreviation</td>
							<td class="boldp" width="25%">&nbsp;</td>
							<td width="23%"/>
						</tr>
						<tr>
						    <td/>
							<td align="left">
								<input class="field-new-01-180x20" type="text" align="" name="orgName"  value="<%= orgNameSelected != null && !"".equals(orgNameSelected)?orgNameSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td>
								<input class="field-new-01-180x20" type="text" name="acroNym"  value="<%= acroNymSelected != null && !"".equals(acroNymSelected)?acroNymSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td/>
							<td/>
						</tr>
                                    <tr>
						    <td/>
							<td class="boldp">Country</td>
							<td class="boldp">State/Prov. </td>
							<td class="boldp">Organization Type</td>
							<td class="boldp"/>
						</tr>
						<tr>
						    <td/>
							<td align="left">
								<select class="field-new-01-180x20" name="country">
									<option value="">Any</option>
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
										 <option value="<%=lookup.getId()%>" <%if(countrySelected != null && !"".equals(countrySelected) &&
										Long.parseLong(countrySelected) == lookup.getId()) {
											 isAlreadySelected = true;
										%> selected <% }
										else if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
									<%
										 }
										}
									%>
								</select>
							</td>
							<td>
								<select class="field-new-01-180x20" name="state">
									<option value="">Any</option>
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

										<option value="<%=lookup.getId()%>"
										<%if(stateSelected != null && !"".equals(stateSelected) &&
										 Long.parseLong(stateSelected) == lookup.getId()) {
											isAlreadySelected = true;
										 %> selected <% }
										 else if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
									<%
										  }
									   }
									%>

								</select>
							</td>
							<td>
								<select class="field-new-01-180x20" name="orgnizationType">
									<option value="">Any</option>
										<%
											if (orgLookup != null && orgLookup.length > 0) {
											OptionLookup lookup = null;
											isAlreadySelected = false;
											for (int i = 0; i < orgLookup.length; i++) {
												lookup = orgLookup[i];
				                         		String selected = "" ;
				                          		if(lookup.isDefaultSelected())
				                          			selected = "selected";
										%>
											<option value="<%=lookup.getId()%>"
											<%if(typeSelected != null && !"".equals(typeSelected) &&
											 Long.parseLong(typeSelected) == lookup.getId()) {
												isAlreadySelected = true;
											 %> selected <% }
											 else if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
										 <%
												}
											   }
										 %>

								</select>
						   </td>
						   <td/>
					  </tr>
                      <tr>
					       <td/>
						   <td class="boldp" >    Major Segment</td>
						   <td class="boldp">Minor Segment</td>
						   <td/>
						   <td/>
					 </tr>
					 <tr>
                           <td/>
						   <td align="left" height="25%">
								<select class="field-new-01-180x20" name="majorSegment">
										<option value="">Any</option>
										 <%
											if (majorSegmentLookup != null && majorSegmentLookup.length > 0) {
											 OptionLookup lookup = null;
											 isAlreadySelected = false;
											for (int i = 0; i < majorSegmentLookup.length; i++) {
												 lookup = majorSegmentLookup[i];
					                         		String selected = "" ;
					                          		if(lookup.isDefaultSelected())
					                          			selected = "selected";
										 %>
											<option value="<%=lookup.getId()%>"
											<%if(majorSelected != null && !"".equals(majorSelected) &&
											Long.parseLong(majorSelected) == lookup.getId()) {
												isAlreadySelected = true;
											%> selected <% }
											else if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
										 <%
											  }
											}
										 %>
								</select>
					   </td>
							<td>
								<select class="field-new-01-180x20" name="minorSegment">
										<option value="">Any</option>
										<%
											if (minorSegmentLookup != null && minorSegmentLookup.length > 0) {
											 OptionLookup lookup = null;
											 isAlreadySelected = false;
											 for (int i = 0; i < minorSegmentLookup.length; i++) {
												lookup = minorSegmentLookup[i];
				                         		String selected = "" ;
				                          		if(lookup.isDefaultSelected())
				                          			selected = "selected";
										%>
											<option value="<%=lookup.getId()%>"
											<%if(minorSelected != null && !"".equals(minorSelected) &&
											 Long.parseLong(minorSelected) == lookup.getId()) {
												isAlreadySelected = true;
											 %> selected <% }
											 else if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
										<%
												}
											}
									%>
								</select>
							</td>
							<td/>
							<td/>
					</tr>
				</tbody>
			 </table>
		</div>
			<div class="table" align="left">
				<table width="65%" cellspacing="0">
					<tbody>
						<tr>
							<td width=10>&nbsp;</td>
						</tr>
						<tr>
							<td width="2%" align="left">&nbsp;</td>
                            			<td width="19%" height="20%" align="left">
								<div class="iconbgimage">
								     <input type="button" class="button-01" onClick="javascript:submitSearch();" style="border:0;background : url(images/buttons/search_orgs.gif);width:108px; height:22px;" value="" name="SearchOrg"/>
								</div>
							</td>
							<td width="26%" align="left">
								<div class="iconbgimage">
								     <input type="button" class="button-01" onClick="javascript:resetFields();" style="border:0;background : url(images/buttons/reset.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width:65px; height:22px;" value="" name="Reset"/>
								</div>
                            <td width="45%"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	</div><!--end of product text-->
	<div class="producttextdown">
		<div class="myexpertlist">
			<table width="100%">
				<tbody>
					<tr style="color: rgb(76, 115, 152);">
						<td width="50%" align="left">
							<div class="myexperttext">Organization Search Results</div>
						</td>

					</tr>
				</tbody>
			</table>
		</div>
		<div class="table">
				<table width="100%' height="20%" cellspacing="0">
					   <tbody>
							<tr><td class="expertListHeader">&nbsp;&nbsp;</td>
								<td  height="22" class="expertListHeader">
								    Name
								</td>
								<td class="expertListHeader">&nbsp;&nbsp;</td>
								<td class="expertListHeader" >Acronym/Abbreviation</td>
								<td class="expertListHeader" >Type</td>
								<td class="expertListHeader" >Location</td>
						 </tr>
							 <tr align="left" class="back-white">
							    <%if(message!=null){%>
								 <td>&nbsp;
									<font face ="verdana" size ="2" color="red">
										<b><%=message%></b>
								   </font>
								 <td>
							</tr>
							 <% } %>
								<%
									if (orgSearchResult != null && orgSearchResult.length > 0) {
									 Organization organization = null;
									for (int i = 0; i < orgSearchResult.length; i++) {
										organization = (Organization) orgSearchResult[i];
								 %>
							        <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>' onMouseOver="this.className='coloronmouseover'" onMouseout="this.className='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'">
							         <%
							         System.out.println("fromorgalignment="+fromOrgAlignment);
							         System.out.println("orgsearchresult.length="+orgSearchResult.length);
							         System.out.println("user type="+userType);
							         if(fromOrgAlignment.equalsIgnoreCase("true") && message==null && (orgSearchResult != null && orgSearchResult.length > 0) && (userType != null && ("Front End Admin".equals(userType) || "Supervisor".equalsIgnoreCase(userType)))){%>
			                        <td width="25" valign="middle"><input id="orgSegmentId" name="orgSegmentId" type="checkbox" value="<%=organization.getEntityId()%>" ></td>
            			            <%}%>
									<td>&nbsp;&nbsp;</td>	<td valign=middle width="200pt"><a class=text-blue-01-link href="<%=CONTEXTPATH%>/institutions.htm?entityId=<%=organization.getEntityId()%>"> <%=organization != null			&& organization.getName() != null && !"".equals(organization.getName()) ?
												organization.getName():""%></a></td>
										<td>&nbsp;&nbsp;</td>
										<td valign="top" class="boldp" ><%=organization != null &&
												organization.getAcronym() != null && !"".equals(organization.getAcronym()) ?
												organization.getAcronym():""%></td>
										<td valign="top" class="boldp" ><%=organization != null &&
												organization.getType() != null && !"".equals(organization.getType()) ?
												organization.getType():""%></td>
										<td valign="top" class="boldp"><%=organization != null &&
												 organization.getCity() != null ? organization.getCity():"N.A"%><%=null != organization && null != organization.getState() ? ", "+organization.getState(): "N.A"%><%=null != organization && null != organization.getCountry() && !"".equals(organization.getCountry().trim()) ? ", "+organization.getCountry(): ", N.A"%></td>
									</tr>
								<%     }
									}	%>
                  </tbody>
                  <tr>
                  	<td>
                  	 	<%if(fromOrgAlignment.equalsIgnoreCase("true") && message==null && (orgSearchResult != null && orgSearchResult.length > 0)
                  	 	 && (userType != null && ("Front End Admin".equalsIgnoreCase(userType) || "Supervisor".equalsIgnoreCase(userType)))){%>
         				<td><INPUT type="button" class=button-01  value="Add To List" name="addOrgToAlignmentButton" onClick="addOrgToAlignment();"></td>
			         	<%}%>
        			</td>
        		</tr>
		  </table>
	  </div>
	  </div>  <!--Producttext down-->
						<div class="producttextdown">
							<div class="table">
								<div align="left"></div>
						  </div>
						</div>
  </div><!--contentmiddle-->

</form>
<div align="left">
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="button" onClick="javascript:document.addOrganization.submit();" style="background: transparent url(images/buttons/add_organization.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 136px; height: 22px;" value="" name="AddOrg"/>

</div>
<form name="addOrganization" action="add_org.jsp">
</form>
<%
    session.removeAttribute("MESSAGE");

%>
<p>&nbsp;
<p>&nbsp;
<p>&nbsp;
<p>&nbsp;
<p>&nbsp;
<p>&nbsp;
<%@ include file="footer.jsp" %></html>