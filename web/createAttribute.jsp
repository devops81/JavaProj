<%@ page language="java" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<HTML>
<HEAD>
	<script  src="js/validation.js" language="JavaScript"></script>
	<TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>

<body leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" class="">

<script language="javascript">
	function addOption(toObject,fromObject)
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
		
		document.updateEntityForm.submit();
	}

</script>

<form name="updateEntityForm" method="POST">

	<input type="hidden" name="entityId" value='<c:out escapeXml="false" value="${entityTypeId}"/>' />

		&nbsp;<br>
		   <div class="producttext">
			<div class="myexpertlist">	
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<TBODY>
			  <tr>
			    <td height="20" align="left" valign="top">
			     <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			      <tr align="left" valign="middle" style="color:#4C7398">
			        <td width="2%" height="20">&nbsp;</td>
			        <td width="2%"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
			        <td class="myexperttext">Details of <c:out escapeXml="false" value="${entityName}"/></td>
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
			        <td width="50" class="text-blue-01-bold" align="right">Type&nbsp;&nbsp;</td>
			        <td width="150" class="text-blue-01" align="left"><c:out escapeXml="false" value="${dataTypeSelect}"/>
			        </td>
			        <td width="20" class="text-blue-01-bold">Name&nbsp;&nbsp;</td>
			        <td width="250" class="text-blue-01" align="left"><input name="entityName" type="text" value='<c:out escapeXml="false" value="${entityName}"/>' class="field-blue-01-180x20" maxlength="50"></td>
			        <td width="20"  class="text-blue-01-bold">Description&nbsp;&nbsp;</td>
			        <td width="250" class="text-blue-01" align="left"><input name="entityDescription" type="text" value='<c:out escapeXml="false" value="${entityDesc}"/>' class="field-blue-01-180x20" maxlength="50"></td>
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
						  <td><input name="Update" type="submit" value='' style="border:0;background : url(images/buttons/update.gif);width:74px; height:22px;" >&nbsp;&nbsp;&nbsp;
						  <input name="_action" type="hidden" value="new" />
						  <input name="entityTypeId" type="hidden" value='<c:out escapeXml="false" value="${entityTypeId}"/>' />
						  <input name="isList" type="hidden" value='<c:out escapeXml="false" value="${isList}"/>' />
						  <input name="Add" type="submit" value='' style="border:0;background : url(images/buttons/add_attribute.gif);width:107px; height:22px;"></td>
				          <td width="10">&nbsp;</td>
				          <td>&nbsp;</td>
				        <td width="10">&nbsp;</td>
				      </tr>
				    </table>
				   </td>
				  </tr>
				</TBODY>
				</TABLE>
			</div>
				
</form>
</body>
</html>