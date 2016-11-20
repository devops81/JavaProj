function showGroupChangerPopup(featureId, permissionOnFeature){
	var tdId = "permittedGroupsTd"+featureId;
	var td = document.getElementById(tdId);
	var permittedGroups = "";
	if(td != null)
		permittedGroups = td.value;

	window.open('selectGroupsForPermission.htm?permissionOnFeature='+permissionOnFeature+'&alreadySelectedGroups='+permittedGroups+"&featureId="+featureId,'SelectUserGroups','width=690,height=400,top=100,left=100,resizable=1,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=1');
}
function setNewGroupSecurity(featureId, newSelectedGroupNames){
	var tdId = "permittedGroupsTd"+featureId;
	var td = document.getElementById(tdId);
	if(td != null){
		td.value = newSelectedGroupNames;
		td.innerHTML = newSelectedGroupNames;
	}
}