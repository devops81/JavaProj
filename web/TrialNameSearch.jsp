<%@ page language="java" %>
<%@ page import="com.openq.eav.option.OptionLookup,
                 com.openq.user.User" %>
<%@ page import="com.openq.eav.trials.ClinicalTrials"%>
<%@ page import="java.util.*"%>
<%

    String userType = null;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();
	
    }

    ArrayList resultList = new ArrayList();
    ClinicalTrials[] trialsSearchResult = null;
    if (session.getAttribute("TRIALS_ADV_SEARCH_RESULT") != null) {
        trialsSearchResult = (ClinicalTrials[]) session.getAttribute("TRIALS_ADV_SEARCH_RESULT");

        if(trialsSearchResult != null && trialsSearchResult.length>0) {
            for(int i=0;i<trialsSearchResult.length;i++) {
                resultList.add(trialsSearchResult[i]);
            }
        }
        if(resultList != null && !resultList.isEmpty()) {
            Collections.sort(resultList, new java.util.Comparator() {
            public int compare(Object o1, Object o2) {
                ClinicalTrials dto1 = (ClinicalTrials) o1;
                ClinicalTrials dto2 = (ClinicalTrials) o2;
                return dto1.getOfficialTitle().toUpperCase().compareTo(dto2.getOfficialTitle().toUpperCase());
            }
        });
        }
        if(resultList != null && resultList.size()>0) {
            trialsSearchResult = new ClinicalTrials[resultList.size()];
            for(int r=0;r<resultList.size();r++) {
                trialsSearchResult[r] = (ClinicalTrials) resultList.get(r);
            }
        }
    }

    String trialNameSelected = null;
    if(session.getAttribute("TRIALNAME_SELECTED") != null &&
            !"".equals(session.getAttribute("TRIALNAME_SELECTED"))) {
        trialNameSelected = (String) session.getAttribute("TRIALNAME_SELECTED");
    }

    String investigatorNameSelected = null;
    if(session.getAttribute("INVESTIGATORNAME_SELECTED") != null &&
            !"".equals(session.getAttribute("INVESTIGATORNAME_SELECTED"))) {
        investigatorNameSelected = (String) session.getAttribute("INVESTIGATORNAME_SELECTED");
    }
    
    String tumourTypeSelected = null;
    if(session.getAttribute("TUMOURTYPE_SELECTED") != null &&
            !"".equals(session.getAttribute("TUMOURTYPE_SELECTED"))) {
        tumourTypeSelected = (String) session.getAttribute("TUMOURTYPE_SELECTED");
    }
    
    String genentechInvestigatorIdSelected = null;
    if(session.getAttribute("GENENTECHINVESTIGATORID_SELECTED") != null &&
            !"".equals(session.getAttribute("GENENTECHINVESTIGATORID_SELECTED"))) {
        genentechInvestigatorIdSelected = (String) session.getAttribute("GENENTECHINVESTIGATORID_SELECTED");
    }
    
    String licenseNumberSelected = null;
    if(session.getAttribute("LICENSENUMBER_SELECTED") != null &&
            !"".equals(session.getAttribute("LICENSENUMBER_SELECTED"))) {
        licenseNumberSelected = (String) session.getAttribute("LICENSENUMBER_SELECTED");
    }
    
    String isGenentechCompoundSelected = null;
    if(session.getAttribute("ISGENENTECHCOMPOUND_SELECTED") != null &&
            !"".equals(session.getAttribute("ISGENENTECHCOMPOUND_SELECTED"))) {
        isGenentechCompoundSelected = (String) session.getAttribute("ISGENENTECHCOMPOUND_SELECTED");
    }
    
    String molecule1Selected = null;
    if(session.getAttribute("MOLECULE1_SELECTED") != null &&
            !"".equals(session.getAttribute("MOLECULE1_SELECTED"))) {
        molecule1Selected = (String) session.getAttribute("MOLECULE1_SELECTED");
    }
    
    String molecule2Selected = null;
    if(session.getAttribute("MOLECULE2_SELECTED") != null &&
            !"".equals(session.getAttribute("MOLECULE2_SELECTED"))) {
        molecule2Selected = (String) session.getAttribute("MOLECULE2_SELECTED");
    }
    
    String institutionSelected = null;
    if(session.getAttribute("INSTITUTION_SELECTED") != null &&
            !"".equals(session.getAttribute("INSTITUTION_SELECTED"))) {
        institutionSelected = (String) session.getAttribute("INSTITUTION_SELECTED");
    }

    String message = null;
    if (session.getAttribute("MESSAGE") != null) {
		message = (String) session.getAttribute("MESSAGE");
	}


%>
<%@ include file="header.jsp" %>
<html>
<head>
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
            var thisform = document.advancedTrialsSearchForm;

            if((thisform.trialName.value != "" && thisform.trialName.value != null) ||
               (thisform.investigatorName.value != "" && thisform.investigatorName.value != null) ||
               (thisform.tumourType.value != "" && thisform.tumourType.value != null) ||
               (thisform.genentechInvestigatorId.value != "" && thisform.genentechInvestigatorId.value != null) ||
               (thisform.licenseNumber.value != "" && thisform.licenseNumber.value != null) ||
               (thisform.isGenentechCompound.selectedIndex != 0) ||
               (thisform.molecule1.value != "" && thisform.molecule1.value != null) ||
               (thisform.molecule2.value != "" && thisform.molecule2.value != null) ||
               (thisform.institution.value != "" && thisform.institution.value != null)) {

				thisform.trialName.value = checkAndReplaceApostrophe(thisform.trialName.value);
				thisform.investigatorName.value = checkAndReplaceApostrophe(thisform.investigatorName.value);
				thisform.tumourType.value = checkAndReplaceApostrophe(thisform.tumourType.value);
				thisform.genentechInvestigatorId.value = checkAndReplaceApostrophe(thisform.genentechInvestigatorId.value);
				thisform.licenseNumber.value = checkAndReplaceApostrophe(thisform.licenseNumber.value);
				thisform.molecule1.value = checkAndReplaceApostrophe(thisform.molecule1.value);
				thisform.molecule2.value = checkAndReplaceApostrophe(thisform.molecule2.value);
				thisform.institution.value = checkAndReplaceApostrophe(thisform.institution.value);
                thisform.action = "<%=CONTEXTPATH%>/advTrialSearch.htm?action=<%=ActionKeys.ADV_SEARCH_TRIAL_MAIN%>";
			    openProgressBar();
                thisform.submit();

            } else {
                alert("Please select/enter specific search criteria")
                return false;
            }
        }
    }

    function resetFields() {
        var thisform = document.advancedTrialsSearchForm;
        thisform.action="<%=CONTEXTPATH%>/advanced_trial_search.htm?action=<%=ActionKeys.ADV_SEARCH_TRIAL%>&reset=yes";
        thisform.submit();
    }
</script>

<form name="advancedTrialsSearchForm" method="post" onKeyPress="submitSearch()">


	<div class="contentmiddle">
		<div class="producttext">
			<div class="myexpertlist">
				<table width="100%">
					<tbody>
						<tr style="color: rgb(76, 115, 152);">
							<td width="50%" align="left">
								<div class="myexperttext">Search Trial</div>
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
							<td class="boldp" width="20%" width="20%">Trial Title:</td>
							<td colspan="4">
							    <input class="field-new-01-180x20" type="text" align="" name="trialName"  value="<%= trialNameSelected != null && !"".equals(trialNameSelected)?trialNameSelected.replaceAll("''","'"):""%>"/>
							</td>
						</tr>
						<tr>
							<td width=10>&nbsp;</td>
						</tr>
						<tr>
						    <td width="2%"/>
							<td class="boldp" width="20%">Investigator Name</td>
							<td class="boldp" width="20%">Condition</td>
							<td class="boldp" width="20%">Company Investigator Id</td>
							<td class="boldp" width="20%">License Number</td>
							<td width="8%"/>
						</tr>
						<tr>
						    <td/>
							<td align="left">
								<input class="field-new-01-180x20" type="text" align="" name="investigatorName"  value="<%= investigatorNameSelected != null && !"".equals(investigatorNameSelected)?investigatorNameSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td>
								<input class="field-new-01-180x20" type="text" name="tumourType"  value="<%= tumourTypeSelected != null && !"".equals(tumourTypeSelected)?tumourTypeSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td>
								<input class="field-new-01-180x20" type="text" name="genentechInvestigatorId"  value="<%= genentechInvestigatorIdSelected != null && !"".equals(genentechInvestigatorIdSelected)?genentechInvestigatorIdSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td>
								<input class="field-new-01-180x20" type="text" name="licenseNumber"  value="<%= licenseNumberSelected != null && !"".equals(licenseNumberSelected)?licenseNumberSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td/>
						</tr>
						<tr>
							<td width=10>&nbsp;</td>
						</tr>
						<tr>
						    <td width="2%"/>
							<td class="boldp" width="20%">Company Compound(s)?</td>
							<td class="boldp" width="20%">Intervention 1</td>
                            <td class="boldp" width="20%">Intervention 2</td>
							<td class="boldp" width="20%">Institution</td>
							<td width="8%"/>
						</tr>
						<tr>
						    <td/>
						    <td align="left">
								<select name="isGenentechCompound">
								  <option <%=((isGenentechCompoundSelected != null) && (isGenentechCompoundSelected.equals("")))?"SELECTED":""%>></option>
								  <option <%=((isGenentechCompoundSelected != null) && (isGenentechCompoundSelected.equalsIgnoreCase("Yes")))?"SELECTED":""%>>Yes</option>
								  <option <%=((isGenentechCompoundSelected != null) && (isGenentechCompoundSelected.equalsIgnoreCase("No")))?"SELECTED":""%>>No</option>
								</select>
							</td>
							<td align="left">
								<input class="field-new-01-180x20" type="text" align="" name="molecule1"  value="<%= molecule1Selected != null && !"".equals(molecule1Selected)?molecule1Selected.replaceAll("''","'"):""%>"/>
							</td>
							<td align="left">
								<input class="field-new-01-180x20" type="text" align="" name="molecule2"  value="<%= molecule2Selected != null && !"".equals(molecule2Selected)?molecule2Selected.replaceAll("''","'"):""%>"/>
							</td>
							<td>
								<input class="field-new-01-180x20" type="text" name="institution"  value="<%= institutionSelected != null && !"".equals(institutionSelected)?institutionSelected.replaceAll("''","'"):""%>"/>
							</td>
							<td/>
					  </tr>
				</tbody>
			 </table>
		</div>
		<br/>
			<div class="table" align="left">
				<table width="65%" cellspacing="0" border=0>
					<tbody>
						<tr>
							<td width="10%" colspan=5/>
						</tr>
						<tr>
							<td width="9px" align="left">&nbsp;&nbsp;</td>
                            <td width="15%" height="20%" align="left">
								<div class="iconbgimage">
								     <input type="button" onClick="javascript:submitSearch();" style="border:0;background : url(images/buttons/search_trials.gif);width:111px; height:22px;" value="" name="SearchTrial"/>
								</div>
							</td>
							<td width="10px" align="left">&nbsp;</td>
							<td width="25%" align="left">
								<div class="iconbgimage">
								     <input type="button" onClick="javascript:resetFields();" style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;" value="" name="Reset"/>
								</div>
                            <td/>
							<td width="100%">&nbsp;</td>
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
						<td align="left">
							<div class="myexperttext">Trial Search Results</div>
						</td>
						<td width="100px">
							<div class="menuIcon"><img src="images/expertpic.gif"></div>
							<a class="text-blue-link" href="reportsUser.htm?sessionDSAttrib=TRIALS_ADV_SEARCH_RESULT&reportName=Trials%20Report">Report</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="table">
				<table width="97%' height="20%" cellspacing="0">
					   <tbody>
							<tr>
								<td height="22">
								    <span class="expertListHeader">Official Title</span>
								</td>
								<td class="expertListHeader" >Phase</td>
								<td class="expertListHeader" >Intervention(s)</td>
								<td class="expertListHeader" >Condition</td>
								<td class="expertListHeader" >License Number</td>
								<td class="expertListHeader" >Company ID</td>
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
									if (trialsSearchResult != null && trialsSearchResult.length > 0) {
									 ClinicalTrials trial = null;
									for (int i = 0; i < trialsSearchResult.length; i++) {
										trial = (ClinicalTrials) trialsSearchResult[i];
								 %>
							        <tr bgcolor='<%=(i%2==0?"#fcfcf8":"#faf9f2")%>'>
										<td align="LEFT" > <a class=text-blue-01-link href="<%=CONTEXTPATH%>/trials.htm?entityId=<%=trial.getId()%>"> <%=trial != null && trial.getOfficialTitle() != null && !"".equals(trial.getOfficialTitle()) ?
												trial.getOfficialTitle():""%></a></td>
										
										<td align="LEFT" class="boldp" ><%=trial != null &&
												trial.getPhase() != null && !"".equals(trial.getPhase()) ?
												trial.getPhase():""%></td>
										<td align="left" class="boldp" ><%=trial != null &&
												trial.getMolecules() != null && !"".equals(trial.getMolecules()) ?
												trial.getMolecules():""%></td>
										<td align="left" class="boldp" ><%=trial != null &&
												trial.getTumourType() != null && !"".equals(trial.getTumourType()) ?
												trial.getTumourType():""%></td>
										<td align="left" class="boldp" ><%=trial != null &&
												trial.getLicenseNumber() != null && !"".equals(trial.getLicenseNumber()) ?
												trial.getLicenseNumber():""%></td>
										<td align="left" class="boldp" ><%=trial != null &&
												trial.getGenentechInvestigatorId() != null && !"".equals(trial.getGenentechInvestigatorId()) ?
												trial.getGenentechInvestigatorId():""%></td>
									</tr>	
								<%     }
									}	%>
                  </tbody>
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
  &nbsp;&nbsp;&nbsp;
  <input type="button" onClick="javascript:document.addTrial.submit();" style="border:0;background : url(images/buttons/add_trial.gif);width:84px; height:22px;" value="" name="AddTrial"/>
  
</div>
<form name="addTrial" action="add_trial.jsp">
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
<%@ include file="footer.jsp" %>
</html>