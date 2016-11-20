<%@ include file="adminHeader.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>

		<meta http-equiv="Content-Type" content="text/html;charset=windows-1252">
		<link href="css/openq.css" type=text/css rel=stylesheet>
		<title>BMS Synergy</title>
		<script language="javascript">
			function saveGlobalConstants(){
				var thisform = document.globalConstantsForm;
				thisform.globalConstantValue.value = document.getElementById("editConstantValue").value; // new value of the constant
				thisform.action = "<%=CONTEXTPATH%>/globalConstants.htm?action=saveGlobalConstants";
				thisform.submit();
			}
			function toggleLayer(whichLayer){
				var elem, vis, globalConstantId = null, globalConstantName = null, globalConstantValue = null, nameValuePair=null;
				var radioButtonChecked = false;
				var thisform = document.globalConstantsForm;
				if (null != thisform.selectedConstantRadio && thisform.selectedConstantRadio.length != undefined) {
					for (var i = 0;  i < thisform.selectedConstantRadio.length; i++) {
						if (thisform.selectedConstantRadio[i].checked) {
							radioButtonChecked = true;
							globalConstantId = thisform.selectedConstantRadio[i].id;
							nameValuePair = thisform.selectedConstantRadio[i].value;
							break;
						}
					}
				   } else {
					 if (null != thisform.selectedConstantRadio && thisform.selectedConstantRadio.checked) {
						radioButtonChecked = true;
						globalConstantId = thisform.selectedConstantRadio.id;
						nameValuePair = thisform.selectedConstantRadio.value;
					}
				}

				if(!radioButtonChecked){
					alert("Please select the option to edit");
					return 0;
				}else{
					// set the variables with the id, name and value of the selected option
					if(nameValuePair!=null){
						globalConstantName = nameValuePair.split(",")[0];
						globalConstantValue = nameValuePair.split(",")[1];
					}
				}

			  // hide/unhide the edit div
			  if( document.getElementById ) // this is the way the standards work
					elem = document.getElementById(whichLayer);
			  vis = elem.style;
			  // if the style.display value is blank we try to figure it out here
			  if(vis.display==''&&elem.offsetWidth!=undefined&&elem.offsetHeight!=undefined)
				vis.display = (elem.offsetWidth!=0&&elem.offsetHeight!=0)?'block':'none';
			  vis.display = (vis.display==''||vis.display=='block')?'none':'block';

			// change the pic to save if edit clicked or call the save change function if save button clicked
			var oldButtonStyle, newButtonStyle;
			if(document.getElementById )
				editSaveButton = document.getElementById("editSaveButton");
				if(editSaveButton!=null){  // toggle the button pic edit/save
					if(editSaveButton.style.background=="url(images/buttons/save.gif)"){ // save button clicked
						saveGlobalConstants(); // save button is visible which means changes need to be saved
					}else{
						editSaveButton.style.width="73px";
						editSaveButton.style.background="url(images/buttons/save.gif)";
					}

				}

			  if(globalConstantId!=null && globalConstantName!=null && globalConstantValue!=null)
				populateEditableConstant(globalConstantId, globalConstantName, globalConstantValue);
			}

			function populateEditableConstant(globalConstantId, globalConstantName, globalConstantValue){

				// set values for hidden parameters id and name to be passed to the controller. The value will be set after user clicks on save button
				document.getElementById("globalConstantId").value = globalConstantId;
				document.getElementById("globalConstantName").value = globalConstantName;

				// set the values in the editConstantValueDiv div
				document.getElementById("editConstantName").innerHTML = globalConstantName;
				document.getElementById("editConstantValue").value = globalConstantValue;

			}
		</script>
	</head>
	<body>
		<form name="globalConstantsForm" method="post">
		<br><br><br>
			<div class="producttext" style=width:95%;height=350>
			  <br> <br> <br>
				<table width="100%">
					<tr>
						<td width="25%">&nbsp;</td>
						<td width="50%">

							<table border="1" cellpadding="0" cellspacing="0" height="50%" width="100%">
								<tbody>
									<tr>
										<td align="left" height="24" valign="top">
											<div class="myexpertlist" style=width:100%>
												<table border="0" cellpadding="0" cellspacing="0" width="200%">
													<tbody>
														<tr align="left" valign="middle" style="color:#4C7398">
															<td height="20" width="2%">&nbsp;&nbsp;
																<img border="0" src="images/pic1.jpg" width="22" height="16">
															</td>
															<td class="myexperttext1">Global Settings</td>
														</tr>
													</tbody>
												</table>
											</div>
										</td>
									</tr>
									</tbody>
									<div align="center"  >
									</table>
									<table border="0" cellpadding="0" cellspacing="0" height="50%" width="100%">

									<tr height="8%">
									    <td width="5%"></td>
										<td class="myexperttext1">
											Name
										</td>
										<td class="myexperttext1">
											Value
										</td>
										<br>
									</tr>
									<c:forEach var="globalConstant" items="${allGlobalConstants}">
										<tr>
											<td >
												<input type="radio" id='<c:out value="${globalConstant.id}"/>' name="selectedConstantRadio" value='<c:out value="${globalConstant.name}"/>,<c:out value="${globalConstant.value}"/>'/>
											</td>
											<td class="globalconstants">
												<c:out value="${globalConstant.name}"/>
											</td>
											<td class="globalConstants">
												<c:out value="${globalConstant.value}"/>
											</td>
										</tr>
									</c:forEach>
								</table>
								<div id="editConstantValueDiv" style="display:none">
									<table border="0">
										<tr>
											<!-- values assigned by populateEditableConstant function -->
											<input type="hidden" name="globalConstantId" value=''/>
											<input type="hidden" name="globalConstantName" value=''/>
											<input type="hidden" name="globalConstantValue" value=''/>
											<td width="5%">
											<td id="editConstantName" class="globalconstants">
												<!-- The value is substituted dynimacally by the javascript -->
											</td>

											<td class="globalConstants">
												<input id="editConstantValue" type="text" name="editConstantsValue" value=''/>(Please enter only numbers for monetary settings.)
											</td>
										</tr>
									</table>
								</div>
								<input type="button" id="editSaveButton" class="button-01"  style="border:0;background:url(images/buttons/edit.gif);width:60px; height:22px;" onclick="toggleLayer('editConstantValueDiv')"/>
							</div>
						</td>
							<td width="25%">&nbsp;</td>
					</tr>
				</table>
		</div>
		</form>
	  </body>
	  <body>
	   <div>
		<table>
			<tr>
				<td>
					<%@ include file="footer.jsp" %>
</html>