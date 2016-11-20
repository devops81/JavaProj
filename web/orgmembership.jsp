<html>
<head>
	<link href="css/openq.css" rel="stylesheet" type="text/css">
</head>
	<script language="javascript">

	function changeStyle(selectedIndex, total) {
		for(var i=0;i<total;i++)
		{	
			if (i==selectedIndex)
			{				
				if(document.getElementById("tab"+i))
				{
					document.getElementById("tab"+i).className = "menu-active";	
					document.getElementById("href"+i).className="text-white-link";
				}
			} 
			else
			{
				if(document.getElementById("tab"+i))
				{		
					document.getElementById("tab"+i).className = "text-blue-02";				
					document.getElementById("href"+i).className="text-black-link";
				}
			}
		}
		window.frames['addEditTableRowFrame'].location.href = 'blank.html';	
		document.getElementById("rowForAddEditTable").style.display = 'none';
		document.getElementById("dividerLineForAddEditTable").style.display = 'none';
	}
	
	</script>

<body class="back-blue-02-light">

<form name="editDeleteForm">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="0" align="left" valign="top" class="back_horz_head">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="middle">
          <td width="10" height="5">&nbsp;</td>
          <td width="25"><img src="images/icon_my_expert.gif" width="14" height="14"></td>
          <td class="text-white-bold">Membership</td>
		  <td class="text-white-bold" align="right" width="150" valign="middle"><a href="#"></a>
		  </td>	
		  <td width="30" height="20">&nbsp;</td>
        </tr>
    </table></td>
  </tr>
  
  <!-- sub tabs start here -->
  
  <!-- sub tabs end here -->

  <!-- show basic attributes -->
  <tr class="back-white">
	<td height="300" valign=top width="100%"><iframe src='membership.jsp' height="100%" vspace=0 hspace=0 width="100%" name="showBasicAttrs" id="showBasicAttrs" frameborder="0" scrolling="auto"></iframe></td>
  </tr>

  <!-- footer for profile view -->
  <tr>
    <td colspan="10" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
  </tr>
   
  <!--tr class="back-white">
    <td height="30"><table border="0" cellspacing="0" cellpadding="0">
	      <tr>
	         <td width="5" height="30">&nbsp;</td>
	         <td valign="middle"><input name="deleteRow" type="button" class="button-01" value="Delete" onClick="deleteTableRows();"></td>
			 <td width="5" height="30">&nbsp;</td>
	         <td valign="middle"><input name="editButton" type="button" class="button-01" value="Edit" onClick="editValues();"></td>
	         <td width="5" height="30">&nbsp;</td>
	         <td valign="middle"><input name="addRow" type="button" class="button-01" value="Add" onClick="addTableRow();"></td>
	         <td width="5" height="30">&nbsp;</td>
	         <td valign="middle"><input name="cancelEditSave" type="button" class="button-01" style="display:none" value="Cancel" onClick="cancelEditOrSave();"></td>
	         <td valign="middle">&nbsp;</td>
	      </tr>
	    </table>
	 </td>
  </tr-->
   
  <tr>
    <td width="5" height="30">&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>