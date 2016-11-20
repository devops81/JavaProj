<!-- Form for editing an attribute -->

<!-- for a given attributeId this allows users to edit attribute properties such as: name, desc, mandatory, etc..  -->

<%@ page language="java" %>
<%@ page import="com.openq.web.controllers.Constants" %>

<HTML>
<HEAD>
	<TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>

<body leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" class="back-blue-02-light">

<form name="AddAttributeForm" method="POST">
		<!-- Add attribute-->
		&nbsp;<br>
			<TABLE cellSpacing=0 cellPadding=0 width="90%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top" class="back_horz_head">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle">
			        <td width="10" height="20">&nbsp;</td>
			        <td width="25"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="text-white-bold">Add New Attribute</td>
			      </tr>
			    </table>
			   </td>
			  </tr>
			  <tr>
			    <td height="20" align="left" valign="top" class="back-blue-03-medium">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle">
			        <td width="10" height="20">&nbsp;</td>
			        <td width="25"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="text-white-bold">Attribute Details</td>
			      </tr>
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
			        <td width="10" class="text-blue-01">&nbsp;</td>
			        <td width="50" class="text-blue-01-bold" align="right">Type&nbsp;&nbsp;</td>
			        <td width="150" class="text-blue-01" align="left"><select name="datatype"  class="field-blue-15-110x20">
							<option value="Text">Text</option>
							<option value="Number">Number</option>
							<option value="Date">Date</option>
							<option value="Yes/No">Yes/No</option>
							<option value="Dropdown">Dropdown</option>
							<option value="Multi-Select">Multi-Select</option>
							<option value="Tab">Tab</option>
							<option value="Table">Table</option>
						</select></td>
			        <td width="20" class="text-blue-01-bold">Name&nbsp;&nbsp;</td>
			        <td width="250" class="text-blue-01" align="left"><input name="attributeName" type="text" class="field-blue-01-180x20" maxlength="50"></td>
			        <td width="20"  class="text-blue-01-bold">Description&nbsp;&nbsp;</td>
			        <td width="250" class="text-blue-01" align="left"><input name="description" type="text" class="field-blue-01-180x20" maxlength="50"></td>
			        <td>&nbsp;</td>
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
				    <td height="30" align="left" valign="top" class="back-white">
				     <table border="0" cellspacing="0" cellpadding="0">
				      <tr>
				        <td width="10" height="30">&nbsp;</td>				       
						  <td class="text-blue-01-bold" width="150">Select 'List of Value' </td>
				          <td width="10"><select name="listOfValues"  class="field-blue-15-110x20">
							<option value="Countries">Countries</option>
							<option value="Timezone">Timezone</option>
						</select></td>
				          <td>&nbsp;</td>
				        <td width="10">&nbsp;</td>
				      </tr>
				    </table>
				   </td>
				  </tr>
				</TBODY>
				</TABLE>
				
				<!-- display options -->
			<TABLE cellSpacing=0 cellPadding=0 width="90%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top" class="back-blue-03-medium">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle">
			        <td width="10" height="20">&nbsp;</td>
			        <td width="25"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="text-white-bold">Display Options</td>
			      </tr>
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
			        <td width="10" class="text-blue-01">&nbsp;</td>
			        <td width="150" class="text-blue-01-bold" align="right">Is Mandatory?&nbsp;&nbsp;</td>
			        <td width="50" class="text-blue-01" align="left"><input name="mandatory" type="checkbox" class="field-blue-01-180x20" checked></td>
			        <td width="250" class="text-blue-01-bold">Is Searchable?&nbsp;&nbsp;</td>
			        <td width="50" class="text-blue-01" align="left"><input name="searchable" type="checkbox" class="field-blue-01-180x20" ></td>
			        <td width="150"  class="text-blue-01-bold">Is Viewable?&nbsp;&nbsp;</td>
			        <td width="50" class="text-blue-01" align="left"><input name="viewable" type="checkbox" class="field-blue-01-180x20" checked></td>
			        <td>&nbsp;</td>
			      </tr>
			      <tr>
			        <td  class="text-blue-01">&nbsp;</td>
			        <td  class="text-blue-01-bold" align="right">Text Size&nbsp;&nbsp;</td>
			        <td  class="text-blue-01" align="center">
						<select name="textSize"  class="field-blue-15-110x20">
							<option value="Small">Small</option>
							<option value="Medium">Medium</option>
							<option value="Large">Large</option>
						</select>
			        </td>
			        <td  class="text-blue-01-bold" align="right">Column Width (px)&nbsp;&nbsp;</td>
			        <td  class="text-blue-01" align="center"><input type="text" name="columnWidth" value="40"/></td>
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
			<TABLE cellSpacing=0 cellPadding=0 width="90%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top" class="back-blue-03-medium">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle">
			        <td width="10" height="20">&nbsp;</td>
			        <td width="25"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="text-white-bold">Group Permissions</td>
			      </tr>
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
			        <td class="text-blue-01-bold">&nbsp;&nbsp;Groups Allowed to View</td>
			      </tr>
			      <tr>
			        <td width="10" class="text-blue-01">
			            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="190" class="text-blue-01" valign="top">
                        	<input name="DropValue" type="text" class="field-blue-01-180x20" maxlength="50" >
                        </td>
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value=" Add   " 
								onClick="javascript:addOption(forms[0].OptionList,forms[0].DropValue)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="http://demo.openq.com:80/amgen/images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="Delete" onClick="javascript:deleted(forms[0].OptionList)"></td>
                            </tr>
                         </table>
                        </td>
                        <td class="text-blue-01">
	                        <select name="OptionList" multiple class="field-blue-13-260x100">
		        			</select>
                        </td>
                      </tr>
                      </table>
			        </td>
			        </tr>
					<tr>
						<td  class="text-blue-01-bold">&nbsp;&nbsp;Groups Allowed to Edit</td>
					</tr>
			        <tr>
			        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			            <tr>
                        <td height="20">&nbsp;</td>
                        <td width="190" class="text-blue-01" valign="top">
                        	<input name="DropValue" type="text" class="field-blue-01-180x20" maxlength="50" >
                        </td>
                        <td class="text-blue-01"  valign="top">
                         <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit3" type="button" class="button-01" value=" Add   " 
								onClick="javascript:addOption(forms[0].OptionList,forms[0].DropValue)"></td>
                            </tr>
                            <tr> 
                              <td height="5"><img src="http://demo.openq.com:80/amgen/images/transparent.gif" width="10" height="5"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top">
                                <input name="Submit32" type="button" class="button-01" value="Delete" onClick="javascript:deleted(forms[0].OptionList)"></td>
                            </tr>
                         </table>
                        </td>
                        <td class="text-blue-01">
	                        <select name="OptionList" multiple class="field-blue-13-260x100">
		        			</select>
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
				    <td height="30" align="left" valign="top" class="back-white">
				     <table border="0" cellspacing="0" cellpadding="0">
				      <tr>
				        <td width="10" height="30">&nbsp;</td>				       
						  <td><input name="saveAttribute" type="submit" class="button-01" value="Add New Attribute"></td>
				          <td width="10">&nbsp;</td>
				          <td>&nbsp;</td>
				        <td width="10">&nbsp;</td>
				      </tr>
				    </table>
				   </td>
				  </tr>
				</TBODY>
				</TABLE>
</form>
</body>
</html>