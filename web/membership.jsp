<html>
<head>
	<link href="css/openq.css" rel="stylesheet" type="text/css">
</head>
<script language="javascript">
	function showHideButtons() {
		parent.editDeleteForm.editButton.value = 'Edit';
		if (document.deleteTableRowForm._table)
		{
			// this is a table with rows
			parent.editDeleteForm.deleteRow.style.display = 'block';
			parent.editDeleteForm.addRow.style.display = 'block';
		}
		else
		{
			parent.editDeleteForm.deleteRow.style.display = 'none';
			parent.editDeleteForm.addRow.style.display = 'none';
		}
	}
</script>
<body onLoad="javascript:showHideButtons()">
<form name="deleteTableRowForm" >
	  <!--input type="hidden" name="_table" value="table" /-->
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">	  
      <tr class="back-grey-02-light">
       			<td width="1%">&nbsp;</td>
	  				
				<td width="1%" height="20">&nbsp;</td>
				    
				<td height="25" align="left" width="px" align="left" valign="middle" class="text-blue-01-bold">
				Name
				</td>
	  				
				<td width="1%" height="20">&nbsp;</td>
				    
				<td height="25" align="left" width="px" align="left" valign="middle" class="text-blue-01-bold">
				Specialty
				</td>
	  				
				<td width="1%" height="20">&nbsp;</td>
				    
				<td height="25" align="left" width="px" align="left" valign="middle" class="text-blue-01-bold">
				Location
				</td>
	  				
	  </tr>
	  
      <tr  title='Last Modified: 2006-11-25, Modified By: Magdlen, James, Data Source: openQ Inc.'>
       		<td width="1%" class="text-blue-01"><!--input type="checkbox" name="rowsToDelete" value="50034" /--></td>
		  
			<td width="1%" height="20" class="text-blue-01">&nbsp;</td>	    
			<td height="25" align="left" align="left" valign="middle" class="text-blue-01">
				&nbsp;
			</td>
		  
			<td width="1%" height="20" class="text-blue-01">&nbsp;</td>	    
			<td height="25" align="left" align="left" valign="middle" class="text-blue-01">
				
			</td>
		  
			<td width="1%" height="20" class="text-blue-01">&nbsp;</td>	    
			<td height="25" align="left" align="left" valign="middle" class="text-blue-01">
				
			</td>
		  
	  </tr>
	  
	</table>


</form>
</body>
</html>
