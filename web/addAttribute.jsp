<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.web.controllers.helpers.AttributeTypeForm" %>
<%@ page import="com.openq.eav.metadata.MetadataUtil"%>

<%
	AttributeTypeForm formValues = (AttributeTypeForm) request.getSession().getAttribute(Constants.ATTRIBUTE_FORM_OBJECT);
	String deleteMessage = (String) request.getSession().getAttribute("deleteMessage");
	
	String errorMessage = null;
	if(request.getAttribute("errorMessage")!=null) {
	    errorMessage = (String)request.getAttribute("errorMessage");
	}
%>

<HTML>
<HEAD>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
	<TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
	<script  src="js/validation.js" language="JavaScript"></script>
	<script language="javascript">

		function deleteAttribute() {
			document.AddAttributeForm._action.value = "delete";
			document.AddAttributeForm.submit();
		}

		function validate() {
			var name = document.AddAttributeForm.attributeName.value;
			var description = document.AddAttributeForm.description.value;
			
			if (!name) {
				alert('Please specify attribute name.');
				return;
			}
			if (!description) {
				alert('Please specify attribute description.');
				return;
			}
			//alert(document.AddAttributeForm._action.value);
			var tDropDown = document.AddAttributeForm.typeDropdown;
			var lDropDown = document.AddAttributeForm.listOfValuesDropdown;
			document.AddAttributeForm.selectedType.value = tDropDown.options[tDropDown.selectedIndex].value;
			document.AddAttributeForm.selectedOptionId.value = lDropDown.options[lDropDown.selectedIndex].value;
			document.AddAttributeForm.submit();
		}

		function ontypeDropdown(refresh) {
			// get selected option
			if (refresh && <%=deleteMessage%> == null) {
			  var thisform = document.refreshPageForm;
			  thisform.action = 'metadataEdit.htm?errorMessage='+'<%=errorMessage%>';
			  thisform.target="_top";
			  thisform.submit();
			  return;
			}

			var tDropDown = document.AddAttributeForm.typeDropdown;
			var type = tDropDown.options[tDropDown.selectedIndex].value;
			
			// if selected option == Dropdown or Multi-Select, enable list of values
			// else disable
			
			if (type == 4 || type == 5) {
				document.AddAttributeForm.listOfValuesDropdown.disabled = false;
			} else {
				document.AddAttributeForm.listOfValuesDropdown.disabled = true;
			}
			
			// if selected option is not text, dropdown, multi-select, disable 'searchable' & text size
			// else enable
			if (type != 0 && type != 4 && type != 5) {
				document.AddAttributeForm.searchable.disabled = true;
			} else {
				document.AddAttributeForm.searchable.disabled = false;
			}
			
			if (type != 0) {
				document.AddAttributeForm.textSize.disabled = true;
			} else {
				document.AddAttributeForm.textSize.disabled = false;
			}
		}
				
		function addOption(toObject, fromObject)
		{
				var k;
				to=toObject.options.length;
				if (to>=1)
							
				myval=fromObject;
				for  (var j=0;j<to;j++)
					{
						toval=toObject.options[j].text;					
						k=(myval==toval? true:false);		 	
						if(k) break;
					}
				
				if(!k)
				{
					addIt(toObject,fromObject);
				}
		}
	
		function addIt(object,fromObject)
		{
				text=fromObject;
				var defaultSelected = true;
				var selected = true;
				var optionName = new Option(text,text,defaultSelected, selected)
				object.options[object.length] = optionName;
		}
	
	
		function deleted(fromObject)
		{
			l = fromObject.options.length;
			for (var i=fromObject.options.length-1; i>-1; i--) {
				if (fromObject.options[i].selected) {
					fromObject.options[i] = null;
				}
			}
			for (var j=0;j<fromObject.options.length;j++) {
				fromObject.options[j].selected = true; 
			}
		}
		
		function setOptions(viewMultiSelect, editMultiSelect, viewTextBox, editTextBox) {
			if (viewMultiSelect.options.length > 0) {
				
				text1 = viewMultiSelect.options[0].value;			
				for (var i=1; i<viewMultiSelect.options.length; i++) {
					text1 += "," + viewMultiSelect.options[i].value;
				}
				viewTextBox.value = text1;
			}
			
			if (editMultiSelect.options.length > 0) {
				
				text2 = editMultiSelect.options[0].value;			
				for (var i=1; i<editMultiSelect.options.length; i++) {
					text2 += "," + editMultiSelect.options[i].value;
				}
				editTextBox.value = text2;
			}
			
			//document.updateEntityForm.submit();
		}
		
		function addAllowedGroup(toObject, fromObject, hiddenField) {
			// First add the group to the list of allowed groups visible on the UI
			addOption(toObject, fromObject);
			
			// Now recreate the list of groups and put it in the hidden field
			setAllowedGroupList(toObject, hiddenField);
		}

		function addSelectedGroupAndType(allowedComboList, groupList, typeList, hiddenField) {
			var k;
			to=allowedComboList.options.length;		
					
			myval=groupList + ":" + typeList;
				
			for  (var j=0;j<to;j++)
			{
				toval=allowedComboList.options[j].text;					
				k=(myval==toval? true:false);		 	
				if(k) break;
			}
				
			if(!k)
			{
				addIt(allowedComboList,myval);
			}
				
			// Now recreate the list of groups and put it in the hidden field
			setAllowedGroupList(allowedComboList, hiddenField);
		}
		
		function deleteAllowedGroup(fromObject, hiddenField) {
			//First of all delete the value from the drop-down
			deleted(fromObject);
			
			// Now recreate the list of groups and put it in the hidden field
			setAllowedGroupList(fromObject, hiddenField);
		}
		
		function setAllowedGroupList(toObject, hiddenField) {
			allowedList = "";			
			for (var i=0; i<toObject.options.length; i++) {
				allowedList += toObject.options[i].value;
				if(toObject.options.length - i > 1 )
					allowedList += ",";
			}
			
			hiddenField.value = allowedList;
		}
	
	</script>
</HEAD>

<body leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" class="" onLoad="javascript:ontypeDropdown('<c:out escapeXml="false" value="${refresh}"/>')">

<form name="AddAttributeForm" action="addAttribute.htm" method="POST">
		<!-- Add attribute-->
		&nbsp;<br>
<div class="producttext" style=width:100%>
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<TBODY>
	  <% if(deleteMessage != null){ %>
			 <tr>
			  	<td>Cannot delete the attribute</td>
			 </tr>
	  <% }%>
			  <tr>
			    <td height="14" align="left" valign="top">
			<div class="myexpertlist" style=width:100%>
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle" style="color:#4C7398">
			        <td width="2%" height="14">&nbsp;</td>
			        <td width="2%"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="myexperttext" height="14"><c:out escapeXml="false" value="${buttonLabel}"/> Attribute</td>
			      </tr>
			    </table>
			 </div>
			
			  </tr>
			
			    <tr>
			    <td height="14" align="left" valign="top" class="">
			  <div class="myexpertplan">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle" style="color:#4C7398">
			        <td width="2%" height="14">&nbsp;</td>
			        <td width="2%"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="myexperttext">Attribute Details</td>
			      </tr>
			    </table>
			 </div>
			</td>
			  </tr>
			  <tr>
			    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			  </tr>
			  <tr>
			    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
			  </tr>
			
			  <tr>
			    <td height="50" align="left" valign="top" class="back-white">
			      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr>
			        <td width="10" class="text-blue-01">&nbsp;</td>
			        <td class="text-blue-01-bold">Name <sup>*</sup> &nbsp;&nbsp;</td>
			        <td class="text-blue-01" align="left"><input name="attributeName" type="text" value="<%=formValues.name%>" maxlength="50"  class="field-blue-16-150x20"></td>
			        <td class="text-blue-01-bold">Description <sup>*</sup> &nbsp;&nbsp;</td>
			        <td class="text-blue-01" align="left">&nbsp;<input name="description" type="text" value="<%=formValues.desc%>" maxlength="50"  class="field-blue-16-150x20"></td>
			        <td>&nbsp;</td>
			      </tr>
			      <tr>
			        <td width="10" class="text-blue-01">&nbsp;</td>
			        <td class="text-blue-01-bold">Type&nbsp;&nbsp;</td>
			        <td class="text-blue-01" align="left"><select name="typeDropdown" onchange="javascript:ontypeDropdown()" class="field-blue-16-150x20" >
			        <%
						int valueOffset = ((formValues.typeOptions.length == MetadataUtil.ENTITY_TYPE_COUNT) ? MetadataUtil.BASIC_TYPE_COUNT : 0);
						for (int i=0; i<formValues.typeOptions.length; i++)
						{
			        %>
						<option value="<%=(i+valueOffset)%>"><%=formValues.typeOptions[i]%></option>
					<%  } %>
					</select>
			        </td>
			        <td class="text-blue-01-bold">List of Values&nbsp;&nbsp;</td>
			        <td class="text-blue-01" align="left">&nbsp;<select name="listOfValuesDropdown" class="field-blue-16-150x20">
			        <%
						for (int k=0; k<formValues.optionList.length; k++)
						{
			        %>
			        	<option value="<%=formValues.optionList[k].getId()%>" <%=formValues.optionList[k].getId() == formValues.selectedOption ? "selected" : ""%> ><%=formValues.optionList[k].getName()%></option>
			        <% } %>
			        </select>
			        </td>
			        <td>&nbsp;</td>
			      </tr></table>
			  </td></tr>
			  <tr>
				    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
				  </tr>
				</TBODY>
				</TABLE>
				
				<!-- display options -->
		&nbsp;<br>
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top">
				<div class="myexpertplan">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle" style="color:#4C7398">
			        <td width="2%" height="20">&nbsp;</td>
			        <td width="2%"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="myexperttext">Display Options</td>
			      </tr>
				</div>
			    </table>
			   </td>
			  </tr>
			  <tr>
			    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			  </tr>
			  <tr>
			    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
			  </tr>
			
			  <tr>
			    <td height="50" align="left" valign="top" class="back-white">
			      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr>
			        <td  class="text-blue-01" width="1%">&nbsp;</td>
			        <td  class="text-blue-01-bold" align="left" width="12%">Text Size&nbsp;&nbsp;</td>
			        <td  class="text-blue-01" align="left" width="33%">
						&nbsp;<select name="textSize" class="field-blue-16-150x20">
							<option value="Small" <%=(formValues.selectedSize.equals("Small") ? "selected" : "")%>>Small</option>

							<option value="Large" <%=(formValues.selectedSize.equals("Large") ? "selected" : "")%>>Large</option>
						</select>
			        </td>
			        <td  class="text-blue-01-bold" align="left" width="20%">Mandatory?&nbsp;&nbsp;</td>
			        <td  class="text-blue-01" align="left" width="32%"><input name="mandatory" type="checkbox" <%=formValues.mandatory ? "checked" : ""%>></td>
			        <td width="1%">&nbsp;</td>
			      </tr>

			      <tr>
			        <td class="text-blue-01" width="1%">&nbsp;</td>
			        <td class="text-blue-01-bold"  align="left" width="12%">Viewable?&nbsp;&nbsp;</td>
			        <td align="left" width="33%"><input name="viewable" type="checkbox" <%=formValues.viewable ? "checked" : ""%>></td>
			        <td class="text-blue-01-bold"  align="left" width="12%">Searchable?&nbsp;&nbsp;</td>
			        <td align="left" width="33%"><input name="searchable" type="checkbox" <%=formValues.searchable ? "checked" : ""%>></td>
			        <td colspan=3>&nbsp;</td>
			      </tr>
				  </table>
			  </td></tr>
			  <tr>
				    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
				  </tr>
				  <tr>
				    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
				  </tr>
				</TBODY>
				</TABLE>
				
				<!-- permission options -->
		&nbsp;<br>
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top">
			    <div class="myexpertplan">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle" style="color:#4C7398">
			        <td width="2%" height="20">&nbsp;</td>
			        <td width="2%"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="myexperttext">Group Permissions</td>
			      </tr>
			    </table>
			    </div>
			   </td>
			  </tr>
			  <tr>
			    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
			  </tr>
			  <tr>
			    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
			  </tr>
			
			  <tr>
			    <td height="50" align="left" valign="top" class="back-white">
			      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
					
				  <tr>
						<td  class="text-blue-01-bold">&nbsp;&nbsp;Restrict Groups/User Types Allowed to Create</td>
				  </tr>
			      <tr>
			        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="120" class="text-blue-01" valign="top">
                        	<c:out escapeXml="false" value="${createGroups}"/>
                        </td>
                        
                        <td width="150" align="center" valign="top">
                         	<c:out escapeXml="false" value="${createUserTypes}"/>
                        </td>
                        
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/add-int.gif);width:73px; height:22px;" 
								onClick="javascript:addSelectedGroupAndType(document.AddAttributeForm.selectedAllowedCreatorsList, document.AddAttributeForm.createGroups.value, document.AddAttributeForm.createUserTypes.value, document.AddAttributeForm.allowedCreatorGroups)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="images/transparent.gif" width="10" height="5"></td>
                            </tr>                            
                            <tr> 
                              <td height="5"><img src="images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" onClick="javascript:deleteAllowedGroup(document.AddAttributeForm.selectedAllowedCreatorsList, document.AddAttributeForm.allowedCreatorGroups)"></td>
                            </tr>
                         </table>
                        </td>
                         
                        <td class="text-blue-01">
		        			<c:out escapeXml="false" value="${selectedAllowedCreatorsList}"/>
		        			<c:out escapeXml="false" value="${allowedCreatorGroups}"/>
                        </td>
                      </tr>
                      </table></td>
                  </tr>
					
				  <tr>
						<td  class="text-blue-01-bold">&nbsp;&nbsp;Restrict Groups/User Types Allowed to View</td>
				  </tr>
			      <tr>
			        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="120" class="text-blue-01" valign="top">
                        	<c:out escapeXml="false" value="${viewGroups}"/>
                        </td>
                        
                        <td width="150" align="center" valign="top">
                         	<c:out escapeXml="false" value="${viewUserTypes}"/>
                        </td>
                        
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/add-int.gif);width:73px; height:22px;" 
								onClick="javascript:addSelectedGroupAndType(document.AddAttributeForm.selectedAllowedReadersList, document.AddAttributeForm.viewGroups.value, document.AddAttributeForm.viewUserTypes.value, document.AddAttributeForm.allowedReaderGroups)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" onClick="javascript:deleteAllowedGroup(document.AddAttributeForm.selectedAllowedReadersList, document.AddAttributeForm.allowedReaderGroups)"></td>
                            </tr>
                         </table>
                        </td>
                        
                        <td class="text-blue-01">
		        			<c:out escapeXml="false" value="${selectedAllowedReadersList}"/>
		        			<c:out escapeXml="false" value="${allowedReaderGroups}"/>
                        </td>
                      </tr>
                      </table></td>
                  </tr>
                    
                  <tr>
						<td  class="text-blue-01-bold">&nbsp;&nbsp;Restrict Groups/User Types Allowed to Edit</td>
				  </tr>
			      <tr>
			        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="120" class="text-blue-01" valign="top">
                        	<c:out escapeXml="false" value="${editGroups}"/>
                        </td>
                        
                        <td  width="150" align="center" valign="top">
                         	<c:out escapeXml="false" value="${editUserTypes}"/>
                        </td>
                        
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/add-int.gif);width:73px; height:22px;" 
								onClick="javascript:addSelectedGroupAndType(document.AddAttributeForm.selectedAllowedEditorsList, document.AddAttributeForm.editGroups.value, document.AddAttributeForm.editUserTypes.value, document.AddAttributeForm.allowedEditorGroups)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" onClick="javascript:deleteAllowedGroup(document.AddAttributeForm.selectedAllowedEditorsList, document.AddAttributeForm.allowedEditorGroups)"></td>
                            </tr>
                         </table>
                        </td>
                        
                        <td class="text-blue-01">
		        			<c:out escapeXml="false" value="${selectedAllowedEditorsList}"/>
		        			<c:out escapeXml="false" value="${allowedEditorGroups}"/>
                        </td>
                      </tr>
                      </table></td>
			      </tr>
    
                  <tr>
						<td  class="text-blue-01-bold">&nbsp;&nbsp;Restrict Groups/User Types Allowed to Delete</td>
				  </tr>
			      <tr>
			        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="120" class="text-blue-01" valign="top">
                        	<c:out escapeXml="false" value="${deleteGroups}"/>
                        </td>
                     
                        <td width="150" align="center" valign="top">
                         	<c:out escapeXml="false" value="${deleteUserTypes}"/>
                        </td>
                     
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/add-int.gif);width:73px; height:22px;" 
								onClick="javascript:addSelectedGroupAndType(document.AddAttributeForm.selectedAllowedDeletorsList, document.AddAttributeForm.deleteGroups.value, document.AddAttributeForm.deleteUserTypes.value, document.AddAttributeForm.allowedDeletorGroups)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" onClick="javascript:deleteAllowedGroup(document.AddAttributeForm.selectedAllowedDeletorsList, document.AddAttributeForm.allowedDeletorGroups)"></td>
                            </tr>
                         </table>
                        </td>
                        
                        <td class="text-blue-01">
		        			<c:out escapeXml="false" value="${selectedAllowedDeletorsList}"/>
		        			<c:out escapeXml="false" value="${allowedDeletorGroups}"/>
                        </td>
                        </tr>
                      </table></td>
                  </tr>
				  </table>
				  </td></tr>

			      
			      <tr>
				    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
				  </tr>
				  <tr>
				    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
				  </tr>
				  <tr>
				    <td height="10" align="left" valign="top" class="back-white"><img src="images/transparent.gif" width="10" height="10"></td>
				  </tr>
				  <tr>
				    <td height="30" align="left" valign="top" class="back-white">
				     <table  cellspacing="0" cellpadding="0">
				      <tr valign="top">
				        <td width="10" height="30" >&nbsp;</td>				       
						  <td>
						  <input name="_action" type="hidden" value='<c:out escapeXml="false" value="${action}"/>'/>
						  <input name="parentId" type="hidden" value='<c:out escapeXml="false" value="${parentId}"/>'/>
						  <input name="parentIsList" type="hidden" value='<c:out escapeXml="false" value="${parentIsList}"/>'/>
						  <input name="attrId" type="hidden" value='<c:out escapeXml="false" value="${attrId}"/>'/>
						  <input name="selectedType" type="hidden" value=""/><!-- Ignored in case of edit -->
						  <input name="selectedOptionId" type="hidden" value=""/> <!-- Ignored in case of edit -->
						  <input name="Add" type="button" onclick="javascript:validate()" value=''  style='border:0;background : url(images/buttons/edit_attribute.gif);width:110px; height:23px;' >
						  </td>
						  <td>&nbsp;</td>
				          <td width="10">
				          <%
				          if (formValues.isLeaf)
				          {
				          %>
				          <input name="Delete" type="button" onclick="javascript:deleteAttribute()" class="button-01" value="" style="border:0;background : url(images/buttons/delete_attribute.gif);width:126px; height:22px;">
				          </td>
				          <% } %>
				          <td>&nbsp;</td>
				          </form>
				          <td width="10">
				          <% if (formValues.showAddAttributeForm) {
						  %>
				          <form name="newAttributeForm" action="addAttribute.htm" method="POST">
				          		<input name="_action" type="hidden" value="new"/>
								<input name="parentId" type="hidden" value="<%=formValues.entityTypeId%>"/>
								<input name="parentIsList" type="hidden" value="<%=formValues.isArrayList%>"/>
							    <input name="Add" type="submit" value=""  style='border:0;background : url(images/buttons/add_attribute.gif);width:107px; height:22px;' >
						  </form>
						  <% } %>
						 </td>
				        <td>&nbsp;</td>
				      </tr>
				    </table>
				   </td>
				  </tr>
				  <tr>
				  <td>&nbsp;</td>
				  </tr>
			</TBODY>
		</TABLE>
		</div>
<form name="refreshPageForm" method="post"></form>
</body>
</html>
