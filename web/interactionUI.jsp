<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.attendee.Attendee"%>
<%@ page import="java.util.Set"%>
<%@ page import="com.openq.interactionData.InteractionData"%>
<%@ page import="com.openq.interaction.Interaction"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%

OptionLookup educationalObjectiveAssessmentLookup[] = null;
    if (session.getAttribute("EDUCATIONAL_OBJECTIVE_ASSESSMENT") != null) {
    	educationalObjectiveAssessmentLookup = (OptionLookup[]) session.getAttribute("EDUCATIONAL_OBJECTIVE_ASSESSMENT");

    }
    isAlreadySelected = false;
    String SURVEY_UNAVAILABLE_MESSAGE = "Currently there are no surveys available";

 %>
<!-- Code for BMS custom interaction form -->

<!-- Clinical Trial Visit Section starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("SELECT_STUDY"))) { %>
   <tr>
     <td>
     <div id="clinicalTrialVisitSectionContent" class="colSection" style="display:none">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="clinicalTrialVisitImg" class="toggleImg" src="images/buttons/plus.gif"
            	   onclick="javascript:toggleSection('clinicalTrialVisit')"/>&nbsp;&nbsp;Clinical Trial Visit
         </div>
         <div id="clinicalTrialVisitContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                   <td class="text-blue-01" width="13%">Study : </td>
                   <td class="text-blue-01">
                   		<%String selectStudyIMPACTNumberLOVName = PropertyReader.getLOVConstantValueFor("SELECT_STUDY_IMPACT_NUMBER");
                   		String selectStudySiteLOVName = PropertyReader.getLOVConstantValueFor("SELECT_STUDY_SITE");
                   		String currentUserTAs = (String) session.getAttribute(Constants.CURRENT_USER_TAS);
                   		%>
                   		<script>populateChildLOVById("<%=currentUserTAs%>", "selectStudyIMPACTNumberLOV", true, "<%=selectStudyIMPACTNumberLOVName%>");</script>
	               		<select id="selectStudyIMPACTNumberLOV" name="selectStudyIMPACTNumberLOV" class="field-blue-13-300x100" disabled
	               				onChange='clearTextArea("clinicalTrialVisitNotes", true);
	               						 populateChildLOV(this, "selectStudySiteLOV", true, "<%=selectStudySiteLOVName%>")'
	               				onclick="showToolTip(this);"
								onmouseover="showToolTip(this);"
								onmouseout="UnTip();">
	               			<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
	               		</select>
		        	</td>
		        	<td class="text-blue-01" width="5%"></td>
		            <td class="text-blue-01"  valign="top" width="12%">&nbsp;</td>
		            <td class="text-blue-01">&nbsp;</td>
		        </tr>
		        <tr>
                    <td class="text-blue-01" width="13%">Site : </td>
	                <td class="text-blue-01">
		               <select id="selectStudySiteLOV" name="selectStudySiteLOV" class="field-blue-13-300x100" disabled
		               	       onclick="showToolTip(this);"
			               	   onchange="clearTextArea('clinicalTrialVisitNotes', false);"
							   onmouseover="showToolTip(this);"
							   onmouseout="UnTip();">
		               		<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
		               </select>
			        </td>
			        <td class="text-blue-01" width="5%">
			        <a href="#" onclick="javascript:isStudyValueSelected()"
			        	class="text-blue-01-link">Search Sites</a>
			        </td>
               		<td class="text-blue-01"  valign="top" width="12%">
	                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
	                    <tr><td align="center" valign="top">&nbsp;</td></tr>
	                    <tr>
	                    	<td align="center" valign="top">
	                    		<div id="clinicalTrialVisitAdd" style="display:block">
				                	<input type="button" name="addSelectStudyButton" value=""
				                	       onclick=" limitChars( document.addInteractionForm.clinicalTrialVisitNotes, 'clinicalTrialVisitNotesCharLimit', -1, true); addLOVPairAndText('selectStudyIMPACTNumberLOV', 'selectStudySiteLOV', 'clinicalTrialVisitNotes', 'selectStudyMultiSelect');"
				                	       style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
				            	</div>
				            	<div id="clinicalTrialVisitSave" style="display:none">
				                	<input type="button" name="saveEditedNoteButton" value=""
				                	       onclick="limitChars( document.addInteractionForm.clinicalTrialEditNotes, 'clinicalTrialEditNotesCharLimit', -1, true); saveEditedNote('selectStudyMultiSelect','clinicalTrialEditNotes','clinicalTrialMultiselectId','clinicalTrialEditNotesId','clinicalTrialVisitAdd','clinicalTrialVisitSave','clinicalTrialVisitDelete','clinicalTrialVisitCancel');"
				                	       style="background: transparent url(images/buttons/save.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
				            	</div>
				            </td>
	                    </tr>
	                    <tr>
	                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
	                    </tr>
	                    <tr>
	                        <td align="center" valign="top">
	                        	<div id="clinicalTrialVisitDelete" style="display:block">
				                	<input type="button" name="deleteSelectStudyButton" value="" onclick="deleteFromMultipleSelect('selectStudyMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%;  width: 73px; height: 22px;"/>
				            	</div>
				            	<div id="clinicalTrialVisitCancel" style="display:none">
				                	<input type="button" name="cancelEditNoteButton" value="" onclick="showEditNoteSection(false,'clinicalTrialMultiselectId','clinicalTrialEditNotesId','clinicalTrialVisitAdd','clinicalTrialVisitSave','clinicalTrialVisitDelete','clinicalTrialVisitCancel');" style="background: transparent url(images/buttons/cancel.gif) repeat scroll 0%;  width: 74px; height: 22px;"/>
				            	</div>
				            </td>
	                    </tr>
	                    </table>
	                 </td>
   	            	<td class="text-blue-01">
	   	            	<div id="clinicalTrialMultiselectId" style="display:block">
		              		<select id="selectStudyMultiSelect" name="selectStudyMultiSelect" multiple class="field-blue-55-360x100"
		    				        onclick="showToolTip(this);"
		          					onmouseover="showToolTip(this);"
		          					onmouseout="UnTip();"
		          					onDblclick="editNotes(this,'clinicalTrialEditNotes','clinicalTrialMultiselectId','clinicalTrialEditNotesId','clinicalTrialVisitAdd','clinicalTrialVisitSave','clinicalTrialVisitDelete','clinicalTrialVisitCancel');">
		                     <%     InteractionData [] selectStudyMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.SELECT_STUDY_MULTISELECT_IDS) : null;
								    if (selectStudyMultiselectValue != null ){
										for(int i=0; i<selectStudyMultiselectValue.length; i++){
		                      					if(selectStudyMultiselectValue[i].getLovId() != null && selectStudyMultiselectValue[i].getLovId().getId() != 0
		                    							&& selectStudyMultiselectValue[i].getSecondaryLovId() != null && selectStudyMultiselectValue[i].getSecondaryLovId().getId() != 0){
						              					String id = selectStudyMultiselectValue[i].getLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
						              								selectStudyMultiselectValue[i].getSecondaryLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
						              								selectStudyMultiselectValue[i].getData();
		                    							String optValues = selectStudyMultiselectValue[i].getLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
		                    											   selectStudyMultiselectValue[i].getSecondaryLovId().getOptValue()  + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
		   					              								selectStudyMultiselectValue[i].getData();
		                    							long parentLOVId = selectStudyMultiselectValue[i].getLovId().getParentId();
		                    				%>
												<script>addTOMultipleSelectByValue('selectStudyMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
		                                    <%}}
		               					}
		             				%>
		                    </select>
		               </div>
		               <div id="clinicalTrialEditNotesId" style="display:none">
		               		<textarea id="clinicalTrialEditNotes" name="clinicalTrialEditNotes" class="field-blue-55-360x100" onkeyup="limitChars( this, 'clinicalTrialEditNotesCharLimit', -1, false);"></textarea>
		               		<div id="clinicalTrialEditNotesCharLimit" class="text-11px-red" ><script>document.write(_oracleMaxCharacterLimitMessage)</script></div>
                       </div>
		          	</td>
            	</tr>
            	<tr>
	            	<td class="text-blue-01" width="13%">&nbsp;</td>
	 				<td class="text-blue-01">&nbsp;</td>
	 				<td class="text-blue-01" width="5%"></td>
		  			<td class="text-blue-01">&nbsp;</td>
		  			<td class="text-blue-01" id="noteEditMessageTD"><%=Constants.EDIT_NOTE_MESSAGE%></td>
            	</tr>
            	<tr>
            	<td class="text-blue-01" width="13%">Scope Document Notes : </td>
 				<td class="text-blue-01">
	 				<div id="clinicalTrialVisitNotesId" style="display:block">
		           	 	<textarea id="clinicalTrialVisitNotes" name="clinicalTrialVisitNotes" class="field-blue-13-300x100" onkeyup="limitChars( this, 'clinicalTrialVisitNotesCharLimit', -1, false);" readonly></textarea>
		  			    <div id="clinicalTrialVisitNotesCharLimit" class="text-11px-red" ><script>document.write(_oracleMaxCharacterLimitMessage)</script></div>
		  			</div>
	  			</td>
	  			<td class="text-blue-01" width="5%"></td>
	  			<td class="text-blue-01">&nbsp;</td>
       		</tr>
     	</table>
    </div>
    </div>
    </div>
    </td>
  </tr>
<%}%>
<!-- Clinical Trial Visit Section ends here -->

<!-- Educational Dialog starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("EDUCATIONAL_DIALOG"))) { %>
   <tr>
     <td>
     <div id="educationalDialogSectionContent" class="colSection" style="display:none">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="educationalDialogImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleSection('educationalDialog')"/>&nbsp;&nbsp;Educational Dialogue
         </div>
         <div id="educationalDialogContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                   <td class="text-blue-01" width="12%">Educational Dialogue : </td>
                   <td class="text-blue-01">
	               		<select id="educationalObjectivesLOV" name="educationalObjectivesLOV" class="field-blue-13-300x100" onclick="showToolTip(this);"
								onmouseover="showToolTip(this);"
								onmouseout="UnTip();">
	               			<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
	               		</select>
		        	</td>
		        	<td class="text-blue-01"  valign="top" width="15%">&nbsp;</td>
		            <td class="text-blue-01">&nbsp;</td>
		        </tr>
		        <tr>
                   <td class="text-blue-01" width="12%">MSL Assessment of <%=DBUtil.getInstance().doctor%> Understanding of Data : </td>
    				<td class="text-blue-01">
		               <select id="educationalObjectiveAssessmentLOV" name="educationalObjectiveAssessmentLOV" class="field-blue-13-300x100"
		               	       onclick="showToolTip(this);"
							   onmouseover="showToolTip(this);"
							   onmouseout="UnTip();">
	                      <option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
			                 <%
	                            if (educationalObjectiveAssessmentLookup != null && educationalObjectiveAssessmentLookup.length > 0) {
	                                OptionLookup lookup = null;
	                                isAlreadySelected = false;
	                                for (int i = 0; i < educationalObjectiveAssessmentLookup.length; i++) {
	                                    lookup = educationalObjectiveAssessmentLookup[i];
	                             		String selected = "" ;
	                              		if(lookup.isDefaultSelected())
	                              			selected = "selected";

	                        %>
	                        <option id="<%=lookup.getId()%>"
	                        		value="<%=lookup.getOptValue()%>"
	                        		title="<%=lookup.getOptValue()%>"
	                        <% if(!isAlreadySelected) {%><%=selected%> <%}%>><%=lookup.getOptValue()%></option>
	                        <%
	                                }
	                            }
	                        %>
		               </select>
			        </td>
	                 <td class="text-blue-01"  valign="top" width="15%">
		                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
		                    <tr><td align="center" valign="top">&nbsp;</td></tr>
		                    <tr><td align="center" valign="top">
					                <input type="button" name="addEducationalObjectiveButton"  value="" onclick="addLOVPair('educationalObjectivesLOV', 'educationalObjectiveAssessmentLOV', 'educationalObjectivesMultiSelect');" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
					            </td>
		                    </tr>
		                    <tr>
		                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
		                    </tr>
		                    <tr>
		                        <td align="center" valign="top">
					                <input type="button" name="deleteEducationalObjectiveButton" value="" onclick="deleteFromMultipleSelect('educationalObjectivesMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%;  width: 73px; height: 22px;"/>
					            </td>
		                    </tr>
		                    </table>
		              </td>
                 	  <td class="text-blue-01">
	              		<select id="educationalObjectivesMultiSelect" name="educationalObjectivesMultiSelect" multiple class="field-blue-55-360x100"
	     		                onclick="showToolTip(this);"
	           					onmouseover="showToolTip(this);"
	           					onmouseout="UnTip();">
	                     <%    InteractionData [] educationalObjectivesMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.EDUCATIONAL_OBJECTIVES_MULTISELECT_IDS) : null;
							    if (educationalObjectivesMultiselectValue != null ){
									for(int i=0; i<educationalObjectivesMultiselectValue.length; i++){
	                      					if(educationalObjectivesMultiselectValue[i].getLovId() != null && educationalObjectivesMultiselectValue[i].getLovId().getId() != 0
	                    							&& educationalObjectivesMultiselectValue[i].getSecondaryLovId() != null && educationalObjectivesMultiselectValue[i].getSecondaryLovId().getId() != 0){
					              					String id = educationalObjectivesMultiselectValue[i].getLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	                    										educationalObjectivesMultiselectValue[i].getSecondaryLovId().getId();
	                    							String optValues = educationalObjectivesMultiselectValue[i].getLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	        														   educationalObjectivesMultiselectValue[i].getSecondaryLovId().getOptValue();
	                    							long parentLOVId = educationalObjectivesMultiselectValue[i].getLovId().getParentId();
	                    				%>
											<script>addTOMultipleSelectByValue('educationalObjectivesMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
	                                    <%}}
	               					}
	             				%>
	                    </select>
		          	</td>
            	</tr>
     	</table>
    </div>
    </div>
    </div>
    </td>
  </tr>
<%}%>
<!-- Educational Dialog ends here -->


<!-- Medical Plan Activity Section starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("MEDICAL_PLAN_ACTIVITY"))) { %>
   <tr>
     <td>
     <div id="medicalPlanActivitySectionContent" class="colSection" style="display:block">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="medicalPlanActivityImg" class="toggleImg" src="images/buttons/minus.gif" 
               onclick="javascript:toggleSection('medicalPlanActivity')"/>&nbsp;&nbsp;Medical Plan Alignment
         </div>
         <div id="medicalPlanActivityContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                   <td class="text-blue-01" width="12%">Approved Products: </td>
                   <td class="text-blue-01">
	               		<% String userTA = (String) session.getAttribute(Constants.CURRENT_USER_TA); %>
	               		
	               		<select id="approvedProductLOV" name="approvedProductLOV" class="field-blue-13-300x100"
	               								onChange='populateChildLOV(this, "dialogObjectivesLOV", true, "<%=dialogObjectivesLOVName%>")'
												onclick="showToolTip(this);"
												onmouseover="showToolTip(this);"
												onmouseout="UnTip();">
										   <option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
											<%
												if (productsLookup != null && productsLookup.length > 0) {
													OptionLookup lookup = null;
													isAlreadySelected = false;
													for (int i = 0; i < productsLookup.length; i++) {
														lookup = productsLookup[i];
														String selected = "" ;
														if(lookup.isDefaultSelected())
															selected = "selected";

											%>
											<script>
												var optionvalue = document.createElement("option");
												optionvalue.setAttribute("id", "<%=lookup.getId()%>");
												optionvalue.setAttribute("value", "<%=lookup.getOptValue()%>");
												optionvalue.setAttribute("name", "<%=lookup.getId()%>"); // store the productLOVId for the child lov in the name attribute
												optionvalue.setAttribute("title", "<%=lookup.getOptValue()%>");
												optionvalue.appendChild(document.createTextNode("<%=lookup.getOptValue()%>"));
												optionvalue.selected = "<%=selected%>";
												var approvedProductLOV = document.getElementById("approvedProductLOV");
												approvedProductLOV.appendChild(optionvalue);
											</script>
										   <%}}%>
										</select>
	               </td>
		        	<td class="text-blue-01"  valign="top" width="15%">&nbsp;</td>
		            <td class="text-blue-01">&nbsp;</td>
		        </tr>
		        <tr><td>&nbsp;</td><tr>
		        <tr>
		        <td class="text-blue-01" width="12%">Communication Topic: </td>
		        <td colspan="3" class="text-blue-01">
		        	<table cellpadding="0" cellspacing="0"> <tr> <td>
		        	<select id="dialogObjectivesLOV" name="dialogObjectivesLOV" class="field-blue-13-850x100" onclick="showToolTip(this);"
										onChange='populateChildLOV(this, "medicalObjectiveTd", true, "<%=medicalObjectivesLOVName%>","","","",true)'
										onmouseover="showToolTip(this);"
										onmouseout="UnTip();"
										<% if ((userTA.equals(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA_CVMET"))) ||
						 							(userTA.equals(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA_ONCOLOGY")))) {%>
														disabled="disabled"
												<% } %>
										>
			               			<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
			           </select>
			           </td></tr></table>
		        </td>
		        </tr>
		      	<tr>
		        <td colspan="4">
		        
				</td>
		        </tr>
		        
		        <tr><td>&nbsp;</td></tr>
		        
		        <tr>
                   <td colspan="2">
                   <table id="medicalObjectiveTable" width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<div id="medicalObjectiveSectionContent" class="colSection" >
							<table>
								<tr>
									<td width="23%" class="text-blue-01">Medical Objective:</td>
									<td width="100%" id="medicalObjectiveTd" class="text-blue-01" style="display:block; background-color:#f2f0de"></td>
								</tr>
							</table>
						</div>
						</td>
					</tr>
					</table>
                   </td>
    				<td class="text-blue-01"  valign="top" width="15%">
		                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
		                    <tr><td align="center" valign="top">&nbsp;</td></tr>
		                    <tr><td align="center" valign="top">
					                <input type="button" name="addMedicalPlanActivityButton"  value="" 
					                onclick="addLOVPairAndLOVAsText('approvedProductLOV', 'dialogObjectivesLOV', 'medicalObjectiveTd', 'medicalPlanMultiSelect')" 
					                style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
					     		</td>
		                    </tr>
		                    <tr>
		                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
		                    </tr>
		                    <tr>
		                        <td align="center" valign="top">
					                <input type="button" name="deleteMedicalPlanActivityButton" value="" 
						                onclick="deleteFromMultipleSelect('medicalPlanMultiSelect');" 
						                style="background: transparent url(images/prodelete.jpg) repeat scroll 0%;  width: 73px; height: 22px;"/>
					         	</td>
		                    </tr>
		                    </table>
		              </td>
                 	  <td class="text-blue-01">
	              		<select id="medicalPlanMultiSelect" name="medicalPlanMultiSelect" multiple class="field-blue-55-360x100"
	     		                onclick="showToolTip(this);"
	           					onmouseover="showToolTip(this);"
	           					onmouseout="UnTip();">
	                     <%     InteractionData [] medicalPlanActMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.MEDICAL_PLAN_ACTIVITY) : null;
								if (medicalPlanActMultiselectValue != null ){
									for(int i=0; i<medicalPlanActMultiselectValue.length; i++){
	                      					if(medicalPlanActMultiselectValue[i].getLovId() != null && medicalPlanActMultiselectValue[i].getLovId().getId() != 0
	                    							&& medicalPlanActMultiselectValue[i].getSecondaryLovId() != null && medicalPlanActMultiselectValue[i].getSecondaryLovId().getId() != 0
	                    							&& medicalPlanActMultiselectValue[i].getTertiaryLovId() != null && medicalPlanActMultiselectValue[i].getTertiaryLovId().getId() != 0){
					              					String id = medicalPlanActMultiselectValue[i].getLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	                    										medicalPlanActMultiselectValue[i].getSecondaryLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	                    										medicalPlanActMultiselectValue[i].getTertiaryLovId().getId();
	                    							String optValues = medicalPlanActMultiselectValue[i].getLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	        														   medicalPlanActMultiselectValue[i].getSecondaryLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
	        														   medicalPlanActMultiselectValue[i].getTertiaryLovId().getOptValue();
	                    							long parentLOVId = medicalPlanActMultiselectValue[i].getLovId().getParentId();
	                    				%>
											<script>addTOMultipleSelectByValue('medicalPlanMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
	                                    <%}}
	               					}
	             				%>
	                    </select>
		          	</td>
            	</tr>
     	</table>
    </div>
    </div>
    </div>
    </td>
  </tr>
<%}%>
<!--Medical Plan Activities Section ends here -->



<!-- Unsolicted Off Label starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("UNSOLICTED_OFF_LABEL"))) { %>
<tr>
  <td>
  <div id="unsolictedOffLabelSectionContent" class="colSection" style="display:none">
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="unsolictedOffLabelImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleSection('unsolictedOffLabel')"/>&nbsp;&nbsp;Unsolicited Off-Label Question Received
      </div>
      <div id="unsolictedOffLabelContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">
			<tr>
         		<td class="text-blue-01" width="15%">Product : </td>
         		<td class="text-blue-01">
         		<% String unsolicitedOffLabelTopicLOVName = PropertyReader.getLOVConstantValueFor("UNSOLICITED_OFF_LABEL_TOPIC"); %>
                <select id="unsolicitedOffLabelProductLOV" name="unsolicitedOffLabelProductLOV" class="field-blue-13-300x100"
                		onChange='populateChildLOV(this, "unsolicitedOffLabelTopicLOV", true, "<%=unsolicitedOffLabelTopicLOVName%>"),clearTextArea("unsolicitedOffLabelSubTopicVisitNotes", true)'
                		onclick="showToolTip(this);"
						onmouseover="showToolTip(this);"
						onmouseout="UnTip();">
                   <option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
                    <%
                        if (offLabelProductsLookup != null && offLabelProductsLookup.length > 0) {
                            OptionLookup lookup = null;
                            isAlreadySelected = false;
                            for (int i = 0; i < offLabelProductsLookup.length; i++) {
                                lookup = offLabelProductsLookup[i];
                         		String selected = "" ;
                          		if(lookup.isDefaultSelected())
                          			selected = "selected";

                    %>
                    <option id="<%=lookup.getId()%>"
                    		title="<%=lookup.getOptValue()%>"
                    		value="<%=lookup.getOptValue()%>"
                    <% if (interaction != null && interaction.getType() != null
                    		&& interaction.getType().getId() == lookup.getId()) {
                    	isAlreadySelected = true;
                    %> selected <% }
                    else if(!isAlreadySelected) {%><%=selected%> <%}%> ><%=lookup.getOptValue()%></option>
                    <%
                            }
                        }
                    %>
                </select>
         		</td>
         		    <td class="text-blue-01"  valign="top" width="15%">&nbsp;</td>
               		<td class="text-blue-01">&nbsp;</td>
         		</tr>
         		<tr>
         		<td>&nbsp;</td>
         		</tr>
         		<tr>
         			<td class="text-blue-01" width="15%">Topic : </td>
         			<td class="text-blue-01">
	                 <%String unsolicitedOffLabelSubTopicLOVName = PropertyReader.getLOVConstantValueFor("UNSOLICITED_OFF_LABEL_SUB_TOPIC"); %>
	            		<select id="unsolicitedOffLabelTopicLOV" name="unsolicitedOffLabelTopicLOV" class="field-blue-13-300x100" disabled
	            				onChange='populateChildLOV(this, "sourceReferencedLOV", true, "<%=sourceReferencedLOVName%>"),clearTextArea("unsolicitedOffLabelSubTopicVisitNotes", true)'
                				onclick="showToolTip(this);"
								onmouseover="showToolTip(this);"
								onmouseout="UnTip();">
							<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
						</select>
              		</td>
	                <td class="text-blue-01" width="5%"></td>
	  				<td class="text-blue-01">&nbsp;</td>
                </tr>
                
           		<tr style="visibility:hidden;">
                	<td class="text-blue-01" width="15%">Sub-Topic : </td>
               		<td class="text-blue-01">
	               		<select name="unsolicitedOffLabelSubTopicLOV" name="unsolicitedOffLabelSubTopicLOV" class="field-blue-13-300x100" disabled
	               				onclick="showToolTip(this);"
								onmouseover="showToolTip(this);"
								onmouseout="UnTip();">
							<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
						</select>
               		</td>
               		<td class="text-blue-01"  valign="top" width="15%">&nbsp;</td>
               		<td class="text-blue-01">&nbsp;</td>
            	</tr>
            	
            	<tr>
		        <td class="text-blue-01" width="12%">Source Referenced: </td>
		        <td colspan="3" class="text-blue-01">
		        	<table cellpadding="0" cellspacing="0"> <tr> <td>
			        	<select id="sourceReferencedLOV" name="sourceReferencedLOV" class="field-blue-13-850x100" disabled
			        			onChange='clearTextArea("unsolicitedOffLabelSubTopicVisitNotes", false)'
			        			onclick="showToolTip(this);"
								onmouseover="showToolTip(this);"
								onmouseout="UnTip();">
			            	<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
			           </select>
			           </td></tr>
			        </table>
		        </td>
		      	<tr><td>&nbsp;</td></tr>
		        
            	
            	<tr>
            		<td class="text-blue-01" width="13%">Enter Question Received : </td>
 					<td class="text-blue-01">
	 					<div id="unsolicitedOffLabelSubTopicVisitNotesId">
		           		 	<textarea id="unsolicitedOffLabelSubTopicVisitNotes" name="unsolicitedOffLabelSubTopicVisitNotes" class="field-blue-13-300x100" onkeyup="limitChars( this, 'unsolicitedOffLabelSubTopicVisitNotesCharLimit', -1, false);" readonly></textarea>
		  				    <div id="unsolicitedOffLabelSubTopicVisitNotesCharLimit" class="text-11px-red" ><script>document.write(_oracleMaxCharacterLimitMessage)</script></div>
		  				</div>
	  				</td>
	  				<td class="text-blue-01"  valign="top" width="15%">
	                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
	                    <tr><td align="center" valign="top">&nbsp;</td></tr>
	                    <tr>
	                    	<td align="center" valign="top">
				            	<div id="unsolicitedOffLabelAdd" style="display:block"> 
				            	    <input type="button" name="addUnsolicitedOffLabelButton"  value="" 
				                	onclick="addLOVTripletAndText('unsolicitedOffLabelProductLOV', 'unsolicitedOffLabelTopicLOV', 'sourceReferencedLOV', 'unsolicitedOffLabelSubTopicVisitNotes', 'unsolicitedOffLabelTriplet', false);"
				               		style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; width: 73px; height: 22px;"/>
				               	</div>
				               	<div id="unsolicitedOffLabelSave" style="display:none">
				                	<input type="button" name="saveEditedNoteButton" value=""
				                	       onclick="limitChars( document.addInteractionForm.unsolicitedOffLabelSubTopicEditNotes, 'unsolicitedOffLabelSubTopicEditNotesCharLimit', -1, true); saveEditedNoteForQuartet('unsolicitedOffLabelTriplet','unsolicitedOffLabelSubTopicEditNotes','unsolicitedOffLabelMultiselectId','unsolicitedOffLabelSubTopicEditNotesId','unsolicitedOffLabelAdd','unsolicitedOffLabelSave','unsolicitedOffLabelDelete','unsolicitedOffLabelCancel');"
				                	       style="background: transparent url(images/buttons/save.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
				            	</div>
				            </td>
	                    </tr>
	                    <tr>
	                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
	                    </tr>
	                    <tr>
	                        <td align="center" valign="top">
	                        	<div id="unsolicitedOffLabelDelete" style="display:block">
				            	    <input type="button" name="deleteUnsolicitedOffLabelButton" value="" onclick="deleteLOVTriplet('unsolicitedOffLabelTriplet');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
				            	</div>
				            	<div id="unsolicitedOffLabelCancel" style="display:none">
				                	<input type="button" name="cancelEditNoteButton" value="" onclick="showEditNoteSection(false,'unsolicitedOffLabelMultiselectId','unsolicitedOffLabelSubTopicEditNotesId','unsolicitedOffLabelAdd','unsolicitedOffLabelSave','unsolicitedOffLabelDelete','unsolicitedOffLabelCancel');" style="background: transparent url(images/buttons/cancel.gif) repeat scroll 0%;  width: 74px; height: 22px;"/>
				            	</div>
				            </td>
				            
	                    </tr>
	                    </table>
	                 </td>
           		     <td class="text-blue-01">
           		     <div id="unsolicitedOffLabelMultiselectId" style="display:block">
             			<select id="unsolicitedOffLabelTriplet" name="unsolicitedOffLabelTriplet" multiple class="field-blue-55-360x100"
     		                	onclick="showToolTip(this);"
           						onmouseover="showToolTip(this);"
           						onmouseout="UnTip();"
           						onDblclick="editNotesForQuartet(this,'unsolicitedOffLabelSubTopicEditNotes','unsolicitedOffLabelMultiselectId','unsolicitedOffLabelSubTopicEditNotesId','unsolicitedOffLabelAdd','unsolicitedOffLabelSave','unsolicitedOffLabelDelete','unsolicitedOffLabelCancel');">
                        <% InteractionData [] unsolictedOffLabelTripletValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.UNSOLICTED_OFF_LABEL_TRIPLET_IDS) : null;
						    if (unsolictedOffLabelTripletValue != null ){
								for(int i=0; i<unsolictedOffLabelTripletValue.length; i++){
											String id = unsolictedOffLabelTripletValue[i].getLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
            											unsolictedOffLabelTripletValue[i].getSecondaryLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
            											unsolictedOffLabelTripletValue[i].getTertiaryLovId().getId() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
            											(null!=unsolictedOffLabelTripletValue[i].getData()?unsolictedOffLabelTripletValue[i].getData():"");
            								String optValues = 	unsolictedOffLabelTripletValue[i].getLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
																unsolictedOffLabelTripletValue[i].getSecondaryLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
																unsolictedOffLabelTripletValue[i].getTertiaryLovId().getOptValue() + Constants.DELIMITER_TO_SEPARATE_SUBVALUES  +
																(null!=unsolictedOffLabelTripletValue[i].getData()?unsolictedOffLabelTripletValue[i].getData():"");
                        				%>
		                    	            <option id = "<%=id%>"
		                    	            		title="<%=optValues%>"
		                    	            		value="<%=optValues%>"><%=optValues%>
		                    	            </option>
                                        <%}
                   					}
                 				%>
                   		</select>
                   		</div>
                   		<div id="unsolicitedOffLabelSubTopicEditNotesId" style="display:none">
		               		<textarea id="unsolicitedOffLabelSubTopicEditNotes" name="unsolicitedOffLabelSubTopicEditNotes" class="field-blue-55-360x100" onkeyup="limitChars( this, 'unsolicitedOffLabelSubTopicEditNotesCharLimit', -1, false);"></textarea>
		               		<div id="unsolicitedOffLabelSubTopicEditNotesCharLimit" class="text-11px-red" ><script>document.write(_oracleMaxCharacterLimitMessage)</script></div>
                       </div>
                   	</td>
	  				
       			</tr>
       			<tr>
	            	<td class="text-blue-01" width="13%">&nbsp;</td>
	 				<td class="text-blue-01">&nbsp;</td>
	 				<td class="text-blue-01" width="5%"></td>
		  			<td class="text-blue-01" id="noteEditMessageTD"><%=Constants.UNSOLICITED_EDIT_NOTE_MESSAGE%></td>
            	</tr>
    		</table>
    	</div>
    </div>
    </div>
    </td>
  </tr>

<%}%>
<!-- Unsolicted Off Label ends here -->

<!-- Speaker Training starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("SPEAKER_TRAINING"))) { %>
   <tr>
     <td>
     <div id="speakerTrainingSectionContent" class="colSection" style="display:none">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="speakerTrainingImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleSection('speakerTraining')"/>&nbsp;&nbsp;Speaker Training
         </div>
         <div id="speakerTrainingContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
            <!-- same as old code -->
             <tr>
                 <td class="text-blue-01" width="15%">Speaker Training : </td>
                 <td class="text-blue-01">
	               <select id="speakerDecksLOV" name="speakerDecksLOV" class="field-blue-13-300x100" disabled
	               	       onclick="showToolTip(this);"
						   onmouseover="showToolTip(this);"
						   onmouseout="UnTip();">
	               	<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
	               </select>
		        </td>
                <td class="text-blue-01"  valign="top" width="15%">
                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                    <tr><td align="center" valign="top">&nbsp;</td></tr>
                    <tr><td align="center" valign="top">
			                <input type="button" name="addSpeakerTrainingButton"  value="" onclick="addTOMultipleSelect('speakerDecksLOV', 'speakerTrainingMultiSelect');" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    <tr>
                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
			                <input type="button" name="deleteSpeakerTrainingButton" value="" onclick="deleteFromMultipleSelect('speakerTrainingMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    </table>
                 </td>
	            <td class="text-blue-01">
              		<select id="speakerTrainingMultiSelect" name="speakerTrainingMultiSelect" multiple class="field-blue-55-360x100"
              		     	onclick="showToolTip(this);"
           					onmouseover="showToolTip(this);"
           					onmouseout="UnTip();">
                     <%  	InteractionData [] speakerDecksMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.SPEAKER_DECKS_MULTISELECT_IDS) : null;
							    if (speakerDecksMultiselectValue != null ){
									for(int i=0; i<speakerDecksMultiselectValue.length; i++){
                    					if(speakerDecksMultiselectValue[i].getLovId() != null && speakerDecksMultiselectValue[i].getLovId().getId() != 0){
	                    					long id = speakerDecksMultiselectValue[i].getLovId().getId();
	                    					String optValues = speakerDecksMultiselectValue[i].getLovId().getOptValue();
	                    					long parentLOVId = speakerDecksMultiselectValue[i].getLovId().getParentId();
                              	   %>
									<script>addTOMultipleSelectByValue('speakerTrainingMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
                                   <% }}
               					}
             				%>
                    </select>
		          </td>
	     </table>
	      </div>
	     </div>
	     </div>
	    </td>
	   </tr>

<%}%>
<!-- Speaker Training ends here -->

<!-- Disease State starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("DISEASE_STATE"))) { %>
   <tr>
     <td>
     <div id="diseaseStateSectionContent" class="colSection" style="display:none">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="diseaseStateImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('diseaseState')"/>&nbsp;&nbsp;Disease State
         </div>
         <div id="diseaseStateContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
            <!-- same as old code -->
             <tr>
                <td class="text-blue-01" width="15%">Proactive Decks : </td>
                <td class="text-blue-01">
                   		<%String diseaseStateLOVName = PropertyReader.getLOVConstantValueFor("DISEASE_STATE");
                   		  String currentUserTAs = (String) session.getAttribute(Constants.CURRENT_USER_TAS);
                   		%>
                   		<script>populateChildLOVById("<%=currentUserTAs%>", 'diseaseStateLOV', true, "<%=diseaseStateLOVName%>");</script>
	               		<select id="diseaseStateLOV" name="diseaseStateLOV" class="field-blue-13-300x100" disabled>
	               			<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
	               		</select>
		        </td>
                <td class="text-blue-01"  valign="top" width="15%">
                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                    <tr><td align="center" valign="top">&nbsp;</td></tr>
                    <tr><td align="center" valign="top">
			                <input type="button" name="addDiseaseStateButton"  value="" onclick="addTOMultipleSelect('diseaseStateLOV', 'diseaseStateMultiSelect');" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    <tr>
                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
			                <input type="button" name="deleteDiseaseStateButton" value="" onclick="deleteFromMultipleSelect('diseaseStateMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    </table>
                 </td>
	            <td class="text-blue-01">
              		<select id="diseaseStateMultiSelect" name="diseaseStateMultiSelect" multiple class="field-blue-55-360x100"
              		     	onclick="showToolTip(this);"
           					onmouseover="showToolTip(this);"
           					onmouseout="UnTip();">
                     <%  	InteractionData [] diseaseStateMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.DISEASE_STATE_MULTISELECT_IDS) : null;
							    if (diseaseStateMultiselectValue != null ){
									for(int i=0; i<diseaseStateMultiselectValue.length; i++){
                    					if(diseaseStateMultiselectValue[i].getLovId() != null && diseaseStateMultiselectValue[i].getLovId().getId() != 0){
	                    					long id = diseaseStateMultiselectValue[i].getLovId().getId();
	                    					String optValues = diseaseStateMultiselectValue[i].getLovId().getOptValue();
	                    					long parentLOVId = diseaseStateMultiselectValue[i].getLovId().getParentId();
                              	   %>
									<script>addTOMultipleSelectByValue('diseaseStateMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
                                   <% }}
               					}
             				%>
                    </select>
		          </td>
	     </table>
	      </div>
	     </div>
	     </div>
	    </td>
	   </tr>

<%}%>
<!-- Disease State ends here -->

<!-- Product Presentation starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("PRODUCT_PRESENTATION"))) { %>
   <tr>
     <td>
     <div id="productPresentationSectionContent" class="colSection" style="display:none">
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="productPresentationImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleSection('productPresentation')"/>&nbsp;&nbsp;Product Presentation
         </div>
         <div id="productPresentationContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
            <!-- same as old code -->
             <tr>
                <td class="text-blue-01" width="15%">Proactive Decks : </td>
                <td class="text-blue-01">
                   		<%String productPresentationLOVName = PropertyReader.getLOVConstantValueFor("PRODUCT_PRESENTATION");
                   		  String currentUserTAs = (String) session.getAttribute(Constants.CURRENT_USER_TAS);
                   		%>
                   		<script>populateChildLOVById("<%=currentUserTAs%>", 'productPresentationLOV', true, "<%=productPresentationLOVName%>");</script>
	               		<select id="productPresentationLOV" name="productPresentationLOV" class="field-blue-13-300x100" disabled>
	               			<option id="<%=DEFAULT_LOV_ID %>" value="<%=DEFAULT_LOV_VALUE %>" selected><%=DEFAULT_LOV_DISPLAY_VALUE %></option>
	               		</select>
		        </td>
                <td class="text-blue-01"  valign="top" width="15%">
                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                    <tr><td align="center" valign="top">&nbsp;</td></tr>
                    <tr><td align="center" valign="top">
			                <input type="button" name="addProductPresentationButton"  value="" onclick="addTOMultipleSelect('productPresentationLOV', 'productPresentationMultiSelect');" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    <tr>
                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
			                <input type="button" name="deleteProductPresentationButton" value="" onclick="deleteFromMultipleSelect('productPresentationMultiSelect');" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    </table>
                 </td>
	            <td class="text-blue-01">
              		<select id="productPresentationMultiSelect" name="productPresentationMultiSelect" multiple class="field-blue-55-360x100"
              		     	onclick="showToolTip(this);"
           					onmouseover="showToolTip(this);"
           					onmouseout="UnTip();">
                     <%  	InteractionData [] productPresentationMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.PRODUCT_PRESENTATION_MULTISELECT_IDS) : null;
							    if (productPresentationMultiselectValue != null ){
									for(int i=0; i<productPresentationMultiselectValue.length; i++){
                    					if(productPresentationMultiselectValue[i].getLovId() != null && productPresentationMultiselectValue[i].getLovId().getId() != 0){
	                    					long id = productPresentationMultiselectValue[i].getLovId().getId();
	                    					String optValues = productPresentationMultiselectValue[i].getLovId().getOptValue();
	                    					long parentLOVId = productPresentationMultiselectValue[i].getLovId().getParentId();
                              	   %>
									<script>addTOMultipleSelectByValue('productPresentationMultiSelect', "<%=id%>", "<%=optValues%>", "<%=parentLOVId%>");</script>
                                   <% }}
               					}
             				%>
                    </select>
		          </td>
     </table>
      </div>
     </div>
     </div>
    </td>
   </tr>

<%}%>
<!-- Product Presentation ends here -->

<!-- Profiling starts here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("PROFILING"))) { %>
<tr>
  <td>
  <div id="profilingSectionContent" class="colSection" class="colContent" style="display:none">
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="profilingImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleSection('profiling')"/>&nbsp;&nbsp;Profiling
      </div>
      <div id="profilingContent" class="colContent">
       <table width="auto"  border="0" cellspacing="0" cellpadding="0">
        <tr>
		<td>
				  <%if(!(featuresProfile!=null && featuresProfile.getProperty("SURVEY")!=null && featuresProfile.getProperty("SURVEY").equalsIgnoreCase("false"))){
				            if(allSurveys!=null&&allSurveys.length>0) {%>
				                 <select id="surveySelect2" name="surveySelect" readonly
				                 class="field-blue-12-220x20"
				                 onclick="showToolTip(this);"
								 onmouseover="showToolTip(this);"
								 onmouseout="UnTip();">
				                   <%for(int i=0;i<allSurveys.length;i++){
								   %>
				                    <option value=<%=allSurveys[i].getId() %>  class="blueTextBox" ><%=allSurveys[i].getName() %></option>
				                  <%} %>
				                  </select>
				                 &nbsp;
            					<input name="viewsurvey" type="button"  style="background: transparent url(images/buttons/survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 75px; height: 22px;" value="" onclick="openSurvey(2)"/>&nbsp;
            					 <%} else{%>
            					 	<font face ="verdana" size ="2" color="red"><%=SURVEY_UNAVAILABLE_MESSAGE %></font>
            					 <%} %>
            				<%} %>
			</td>
			</tr>
                </table>

     </div>
     </div>
     </div>
     </td>
   </tr>

<%}%>
<!-- Profiling ends here -->

<!-- Medical Info Request Followup Starts Here -->
<%if("true".equalsIgnoreCase(prop1.getProperty("MEDICAL_INFO_REQUEST_FOLLOWUP"))) { %>
 <tr>
  <td>
   <div id="MIRFSectionContent" class="colSection" style="display:none">
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="MIRFImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('MIRF')"/>&nbsp;&nbsp;Medical Info Request Follow-up
      </div>
      <div id="MIRFContent" class="colContent">
     <table width="auto"  border="0" cellspacing="0" cellpadding="0">
       <tr>
          <td class="text-blue-01" width="15%">Please enter MIRF# </td>
          <td class="text-blue-01">&nbsp;</td>
          <td style="padding : 38px" width="190" class="text-blue-01" valign="middle">
       		<input type="text" name="MIRFText" id="MIRFText" class="text-blue-01" maxlength="10" title="Please enter only alphanumeric or hyphen" onkeyup="valid(this,'noSpecialExceptHyphen')" />
 	      </td>
         <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

         <td class="text-blue-01"  valign="top" width="15%">
                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                    <tr><td align="center" valign="top">&nbsp;</td></tr>
                    <tr><td align="center" valign="top">
			                <input type="button" name="addMIRFButton"  value="" onclick="javascript:copySelectedMIRFinfo(document.addInteractionForm.MIRFText, document.addInteractionForm.MIRFMultiSelect);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%;  width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    <tr>
                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
			                <input type="button" name="deleteMIRFButton" value="" onclick="javascript:deleteMIRMultipleSelect();" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; width: 73px; height: 22px;"/>
			            </td>
                    </tr>
                    </table>
            </td>
            <td class="text-blue-01">
              		<select id="MIRFMultiSelect" name="MIRFMultiSelect" multiple class="field-blue-55-360x100"
              		     	onclick="showToolTip(this);"
           					onmouseover="showToolTip(this);"
           					onmouseout="UnTip();">
                     <%  	InteractionData [] MIRFMultiselectValue = interaction != null ? interaction.getInteractionDataArrayOnType(Constants.MIRF_MULTISELECT_IDS) : null;
							    if (MIRFMultiselectValue != null ){
									for(int i=0; i<MIRFMultiselectValue.length; i++){
                    					String data = MIRFMultiselectValue[i].getData();

                              	   %>
									<script>addTOMultipleSelectMIRF('MIRFMultiSelect', "<%=data%>","<%=data%>");</script>>
                                   <% }
               					}
             				%>
                    </select>
		     </td>
         </tr>
       </table>
     </div></div></div>
     </td>
   </tr>
<%}%>
<!-- Medical Info Request Followup Starts Here -->
