/* These delimiters are used in populating the child LOVs through Ajax.
 * There values should match the values of the following variables
 * defined in com.openq.web.controllers.Constants.java
 *  public static final String DELIMITER_TO_SEPARATE_VALUES = "`";
 *  public static final String DELIMITER_TO_SEPARATE_SUBVALUES = "~";
 *
 * var jsGlobalVarDelimiterToSeparateValues = DELIMITER_TO_SEPARATE_VALUES value and
 * var jsGlobalVarDelimiterToSeparateSubValues = DELIMITER_TO_SEPARATE_SUBVALUES value
 * For eg. their current values are :
 *  var jsGlobalVarDelimiterToSeparateValues = "`";
 *  var jsGlobalVarDelimiterToSeparateSubValues = "~";
 */
// The default delimiters are ` and ~
var jsGlobalVarDelimiterToSeparateValues = "`"; // will store the delimiter used to separated the values or ids
var jsGlobalVarDelimiterToSeparateSubValues = "~"; // will store the delimiter used to separated the subvalues or subids
function ajaxFunction(URL, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, isAsynchronousCall, defaultSelectedValue, displayAsTextFlag){
	var xmlHttp;
	var callTypeFlag = true; // is an Asynchronous Call
	if(isAsynchronousCall != null){
		callTypeFlag = isAsynchronousCall;
	}
	try{
    	if (window.XMLHttpRequest) {
	       		xmlHttp = new XMLHttpRequest();
	    } else if (window.ActiveXObject) {
	   	   		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	    }
	}catch (e){
      alert("Your browser does not support AJAX!");
      return false;
	}
	  xmlHttp.open("GET", URL, callTypeFlag);
	  xmlHttp.onreadystatechange = function(){responseProcessor(xmlHttp, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue, displayAsTextFlag)};
	  xmlHttp.send(null);
}

function populateChildrenLOVs(selectedLOV, childLOVHTMLElementIds, removeExistingValuesFlag, childrenLOVNames, 
 lovValuesToBeExcluded, isAsynchronousCall, defaultSelectedValue) {
	if (selectedLOV != null) {
		var childLOVHTMLElementIdArray = childLOVHTMLElementIds.split(',');
		var childrenLOVNamesArray = childrenLOVNames.split(',');
		if(childLOVHTMLElementIdArray.length == childrenLOVNamesArray.length) {
			for (var i=0; i< childLOVHTMLElementIdArray.length; i++) 
				removeExistingChildLOV(childLOVHTMLElementIdArray[i]);
			
			var selectedIndex = selectedLOV.selectedIndex;
		   	var selectedLOVId = selectedLOV.options[selectedIndex].id;
		   	
		   	if("getAllChildLOVs" == selectedLOVId){
		   		selectedLOVId = "";
		   		for(var i=selectedLOV.length-1; i>0; i--){
		 			if("getAllChildLOVs" != selectedLOV.options[i].id){
		 				selectedLOVId = selectedLOVId + "," + selectedLOV.options[i].id ;
		 			}
		 		}
		 		selectedLOVId = selectedLOVId.substring(1);
		   	}
			for (i=0;i<childLOVHTMLElementIdArray.length;i++) {
				var URL = "populateChildLOV.htm?childLOVName="+childrenLOVNamesArray[i]+"&parentId="+selectedLOVId+"&lovValuesToBeExcluded="+lovValuesToBeExcluded;
	   			ajaxFunction(URL, childLOVHTMLElementIdArray[i], removeExistingValuesFlag, selectedLOVId, isAsynchronousCall, defaultSelectedValue);
			}
		}
	}
}



 function populateChildLOV(selectedLOV, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName, 
 lovValuesToBeExcluded, isAsynchronousCall, defaultSelectedValue, displayAsText){
  	// TODO : Default selected implementation in child LOV
	var displayAsTextFlag = false;
	if (displayAsText != null) {
		displayAsTextFlag = displayAsText;
	}
	
	if(selectedLOV != null){

		if (displayAsTextFlag) {
		// if the child LOVs are to be displayed as text, then no need to remove child lovs instead remove child text
			var childDOMElement = document.getElementById(childLOVHTMLElementId);
			childDOMElement.innerText = "";
			childDOMElement.title = "";
		}
		else {
		// Remove the child LOV's if the child lov's are to be displayed as LOV's
			if(removeExistingValuesFlag){ // remove all the values from child LOVs cascade
				deleteChildRecordsCascade(selectedLOV);
			}else{
				var childLOV = document.getElementById(childLOVHTMLElementId);
				childLOV.disabled = true; // disable the selection in child LOV until new values are populated
				// Now, delete all the lovs below the child lov
				deleteChildRecordsCascade(childLOV);
			}
		}
		
	   	var selectedIndex = selectedLOV.selectedIndex;
	   	var selectedLOVId = selectedLOV.options[selectedIndex].id;
	   	
	   	if("getAllChildLOVs" == selectedLOVId){
	   		selectedLOVId = "";
	   		for(var i=selectedLOV.length-1; i>0; i--){
	 			if("getAllChildLOVs" != selectedLOV.options[i].id){
	 				selectedLOVId = selectedLOVId + "," + selectedLOV.options[i].id ;
	 			}
	 		}
	 		selectedLOVId = selectedLOVId.substring(1);
	   	}
   		var URL = "populateChildLOV.htm?childLOVName="+childLOVName+"&parentId="+selectedLOVId+"&lovValuesToBeExcluded="+lovValuesToBeExcluded;
	   	ajaxFunction(URL, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, isAsynchronousCall, defaultSelectedValue, displayAsTextFlag);
	}
  }
  function populateChildLOVById(selectedLOVId, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName, defaultSelectedValue){
  	// TODO : Default selected implementation in child LOV
	if(selectedLOVId != null){
   		var URL = "populateChildLOV.htm?childLOVName="+childLOVName+"&parentId="+selectedLOVId;
	   	ajaxFunction(URL, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, true, defaultSelectedValue);
	}
  }
  function populateLOVByOptionId(selectedOptionId, childLOVHTMLElementId, isAsynchronousCall, defaultSelectedValue){
		if(selectedOptionId != null){
	   		var URL = "populateChildLOV.htm?selectedOptionId="+selectedOptionId;
		   	ajaxFunction(URL, childLOVHTMLElementId, true, selectedOptionId, isAsynchronousCall, defaultSelectedValue);
		}
  }
  function responseProcessor(xmlHttp, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue, displayAsTextFlag){
  	//If the readystate is 4 then check for the request status.
	    if (xmlHttp.readyState == 4) {
	        if (xmlHttp.status == 200) {
	        	// update the HTML DOM based on whether or not message is valid
					if (!displayAsTextFlag) {
						createNewChildLOV(xmlHttp.responseText, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue);
					}
					else {
						displayTextForChildLOV(xmlHttp.responseText, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue);
					}
			}
	    }
  }
  
  function displayTextForChildLOV(newChildLOVIds, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue) {
  	var childDOMElement = document.getElementById(childLOVHTMLElementId);
  	if(newChildLOVIds != null && childDOMElement != null){
   		var newChildLOVArray = newChildLOVIds.split(jsGlobalVarDelimiterToSeparateValues);
   		if(newChildLOVArray != null && newChildLOVArray != ""){
			childDOMElement.innerText = "";
			childDOMElement.title = "";
			for(var i=0; i<newChildLOVArray.length; i++){
	  			if(newChildLOVArray[i].indexOf(jsGlobalVarDelimiterToSeparateSubValues) > 0){
	  				var idValueArray = newChildLOVArray[i].split(jsGlobalVarDelimiterToSeparateSubValues);
		   			childDOMElement.innerText = idValueArray[1];
		   			childDOMElement.title = idValueArray[0];
		   			childDOMElement.disabled = false;
		   		}
		   	}
		}
  	}
  }
  
  function createNewChildLOV(newChildLOVIds, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId, defaultSelectedValue){
  	var childLOV = document.getElementById(childLOVHTMLElementId);
  	if(newChildLOVIds != null && childLOV != null){
   		var newChildLOVArray = newChildLOVIds.split(jsGlobalVarDelimiterToSeparateValues);
   		if(newChildLOVArray != null && newChildLOVArray != ""){
			/* Though we do remove all the child lovs when the populatChildLOV function is
			 * called, yet, there are cases when a child lov is populated by 2 events in
			 * succession and in that case it has duplicate entries.
			 * E.g : If you change a Interaction Type and before the child lov is populated
			 * you click on any intent of interaction radio button. Then, the child lovs
			 * gets populated due to 2 onchange events and hence has duplicate values.
			 * To avoide this we will delete all the existing values from the immediate
			 * child lov if the removeExistingValuesFlag is true.
			 */
			if(removeExistingValuesFlag){
				removeExistingChildLOV(childLOVHTMLElementId);
			}
			childLOV.disabled = false;
	  		for(var i=0; i<newChildLOVArray.length; i++){
	  			if(newChildLOVArray[i].indexOf(jsGlobalVarDelimiterToSeparateSubValues) > 0){
	  				var idValueArray = newChildLOVArray[i].split(jsGlobalVarDelimiterToSeparateSubValues);
		   			var optionvalue = document.createElement("option");
					optionvalue.setAttribute("id", idValueArray[0]);
					optionvalue.setAttribute("value", idValueArray[1]);
					optionvalue.setAttribute("name", selectedLOVId); // store the parent productLOVId for the child lov in the name attribute
					optionvalue.setAttribute("title", idValueArray[1]);
					optionvalue.appendChild(document.createTextNode(idValueArray[1]));
					if(defaultSelectedValue != undefined &&
							(idValueArray[0].toLowerCase() == defaultSelectedValue.toLowerCase() ||
							idValueArray[1].toLowerCase() == defaultSelectedValue.toLowerCase())){
						optionvalue.setAttribute("selected", true);
					}
					childLOV.appendChild(optionvalue);
				}
			}
		}

  	}
 }
 
 function removeExistingChildLOV(existingChildLOVId){
 	var childLOV = document.getElementById(existingChildLOVId);
 	if(childLOV != null && childLOV != undefined){
		childLOV.disabled = true;
		/* we will not delete the element with id = -1 because it is usually the following message :
		   "Please select a value".
		 */
		 if (childLOV.length > 0) {
		 	for(var i=childLOV.length-1; i>=0; i--){
		 		if(childLOV.options[i].id != -1 && childLOV.options[i].id != "" && childLOV.options[i].id !="getAllChildLOVs"){
		 			childLOV.remove(i);
		 		}
		 	}
		 }
		 else {
		 /* This is the case when, the child element is not a LOV, its a text displayed, 
		 		so we just need to clear the text.
		 */
		 childLOV.innerText = "";
		 childLOV.title = "";
		 }
	}
 }
 function removeExistingChildLOVById(existingChildLOV, parentLovId){
 	var childLOV = document.getElementById(existingChildLOV);
 	if(childLOV != null && childLOV != undefined){
 		/* we will not delete the first record which is usually the following message :
		   "Please select a value".
		 */
	 	for(var i=childLOV.length-1; i>0; i--){
			if(parentLovId == childLOV.options[i].name) // parent productLOVId is stored in the child's name attribute
	 			childLOV.remove(i);
	 	}
	}
 }
 function addTOMultipleSelect(LOVName, multiSelectName){
	var selectedLOV = document.getElementById(LOVName);
	var targetMultiSelect = document.getElementById(multiSelectName);
	var selectedValue = "";
	var selectedId = "";
	var parentLOVId = "";
	if( selectedLOV != null && selectedLOV.options[selectedLOV.selectedIndex].id != -1 ){
		selectedValue = selectedLOV.options[selectedLOV.selectedIndex].value;
		selectedId = selectedLOV.options[selectedLOV.selectedIndex].id;
		parentLOVId = selectedLOV.options[selectedLOV.selectedIndex].name; // parent productLOVId is stored in the child's name attribute
	}
	var duplicateFlag = false;
	if(targetMultiSelect != null){
		for(k=0; k<targetMultiSelect.length; k++){
			if(targetMultiSelect.options[k].id == selectedId){
				duplicateFlag = true;
				break;
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			return false;
		}
		if(selectedValue != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", selectedId);
			optionvalue.setAttribute("value", selectedValue);
			optionvalue.setAttribute("name", parentLOVId); // parent productLOVId is stored in the child's name attribute
			optionvalue.appendChild(document.createTextNode(selectedValue));
			targetMultiSelect.appendChild(optionvalue);
		}
	}
	return true;
}
 function addTOMultipleSelectByValue(multiSelectName, selectedId, selectedValue, parentLOVId){
	var targetMultiSelect = document.getElementById(multiSelectName);
	if(targetMultiSelect != null){
		for(k=0; k<targetMultiSelect.length; k++){
			if(targetMultiSelect.options[k].id == selectedId)
				return false;
		}
		if(selectedValue != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", selectedId);
			optionvalue.setAttribute("value", selectedValue);
			optionvalue.setAttribute("name", parentLOVId); // parent productLOVId is stored in the child's name attribute
			optionvalue.appendChild(document.createTextNode(selectedValue));
			targetMultiSelect.appendChild(optionvalue);
		}
	}
	return true;
}

//function to add values to multiselect for non-LOV types
function addTOMultipleSelectMIRF(multiSelectName,selectedValue,selectedId){
	var targetMultiSelect = document.getElementById(multiSelectName);
		if(selectedValue != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("value", selectedValue);
			optionvalue.setAttribute("id", selectedId);
			optionvalue.appendChild(document.createTextNode(selectedValue));
			targetMultiSelect.appendChild(optionvalue);
		}

	return true;
}

function deleteFromMultipleSelect(multiSelectName){
	var deletedIds = "";
	var selectedMultiSelect = document.getElementById(multiSelectName);
	for (var i=selectedMultiSelect.options.length-1; i>-1; i--) {
		if (selectedMultiSelect.options[i].selected) {
			deletedIds = deletedIds + jsGlobalVarDelimiterToSeparateValues + selectedMultiSelect.options[i].name; // parent productLOVId is stored in the child's name attribute
			selectedMultiSelect.options[i] = null;
		}
	}
	if(deletedIds != "")
		deletedIds = deletedIds.substring(1);

	return deletedIds;
}
function deleteFromMultipleSelectById(multiSelectName, parentLovId){
	var selectedMultiSelect = document.getElementById(multiSelectName);
	for (var i=selectedMultiSelect.options.length-1; i>-1; i--) {
		if(selectedMultiSelect.options[i].name == parentLovId) // parent productLOVId is stored in the child's name attribute
				selectedMultiSelect.options[i] = null;
	}
}
function deleteAllSelectedValuesInSection(sectionID){
	// delete the surveys if the survey section is hidden
	if(sectionID == 'profilingSection'){
		deleteAllSurveys();
		return;
	}
	var section = document.getElementById(sectionID + "Content");
	var allElementsInSection = section.getElementsByTagName("*");
    for(var i=allElementsInSection.length-1; i>-1; i--) {
        var element = allElementsInSection[i];
        if(element.type == "select-multiple") {
			for (var i=element.options.length-1; i>-1; i--) {
					element.options[i] = null;
			}
        }else if(element.type == "checkbox") {
        	element.checked = false;
        }
    }
}
/* Change in requirement 18/11/2008 : On UI only topic and sub-topic will show.
   But, in the DB Interaction type, topic and sub-topic will be stored.
   We will pass a flag isInteractionTriplet to the function.
   If the flag is true, then we will not show the Interaction Type lov value in the UI
*/
function addLOVTriplet(rootLOV, levelOneLOV, levelTwoLOV, multiSelectName, isInteractionTriplet) {
	var rootLOV = document.getElementById(rootLOV);
	var levelOneLOV = document.getElementById(levelOneLOV);
	var levelTwoLOV = document.getElementById(levelTwoLOV);
	var multiSelect = document.getElementById(multiSelectName);
	var triplet = "";
	var tripletId = "";
	if( rootLOV != null && levelOneLOV != null && levelTwoLOV != null &&
		rootLOV.options[rootLOV.selectedIndex].id != -1 &&
		levelOneLOV.options[levelOneLOV.selectedIndex].id != -1 &&
		levelTwoLOV.options[levelTwoLOV.selectedIndex].id != -1){
		if(isInteractionTriplet){
		triplet = levelOneLOV.options[levelOneLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
			      levelTwoLOV.options[levelTwoLOV.selectedIndex].value;
		}else {
				triplet = rootLOV.options[rootLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
				levelOneLOV.options[levelOneLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
			    levelTwoLOV.options[levelTwoLOV.selectedIndex].value;
		}
		tripletId = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  levelOneLOV.options[levelOneLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
			      levelTwoLOV.options[levelTwoLOV.selectedIndex].id;
	}

	var duplicateFlag = false;
	if(multiSelect != null){
		for(k=0; k<multiSelect.length; k++){
			if(multiSelect.options[k].id == tripletId){
				duplicateFlag = true;
				break;
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			return false;
		}
		if(triplet != "" && tripletId != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", tripletId);
			optionvalue.setAttribute("value", triplet);
			optionvalue.appendChild(document.createTextNode(triplet));
			multiSelect.appendChild(optionvalue);

			// Triplet has got a section mapped to it
			if(javascriptTripletSectionMap.get(tripletId) != null){
				// show the section
				showHiddenSection(javascriptTripletSectionMap.get(tripletId));
			}
		}
	}

}
function deleteLOVTriplet(multiSelectName){
	var multiSelect =  document.getElementById(multiSelectName);
	var tripletsToDelete = "";
	for (var i=multiSelect.options.length-1; i>-1; i--) {
		if (multiSelect.options[i].selected) {
			var selectedValue = multiSelect.options[i].value;
			var selectedId = multiSelect.options[i].id;
			var sectionToHide = javascriptTripletSectionMap.get(selectedId);
			// delete the selected row
			multiSelect.options[i] = null;
			if(sectionToHide != null){
				var hideSectionFlag = hideSectionCheck(multiSelect, sectionToHide);
				if(hideSectionFlag){
					// hide the section
					hideOpenSection(sectionToHide);
					// Discard the values in all the multiselects in the section
					deleteAllSelectedValuesInSection(sectionToHide);
				}
			}
			tripletsToDelete = tripletsToDelete + jsGlobalVarDelimiterToSeparateValues + selectedValue;
		}
	}
}
function getCommaSeparatedMultiselectIds(multiSelectId){
	var multiSelect =  document.getElementById(multiSelectId);
	if( multiSelect != null && multiSelect != undefined ){
		var tripletsIds = "";
		for (var i=0; i<multiSelect.options.length; i++)
				tripletsIds = tripletsIds + jsGlobalVarDelimiterToSeparateValues + multiSelect.options[i].id;
		if(tripletsIds != "")
			tripletsIds = tripletsIds.substring(1);
		return tripletsIds;
	}
}
function addLOVPair(firstLOV, secondLOV, multiSelectName) {
	var firstLOV = document.getElementById(firstLOV);
	var secondLOV = document.getElementById(secondLOV);
	var multiSelect = document.getElementById(multiSelectName);
	var pairValue = "";
	var pairId = "";
	var parentLOVId = "";
	var firstId = "";
	if( firstLOV != null && secondLOV != null &&
		firstLOV.options[firstLOV.selectedIndex].id != -1 &&
		secondLOV.options[secondLOV.selectedIndex].id != -1){
		firstId = firstLOV.options[firstLOV.selectedIndex].id;
		pairValue = firstLOV.options[firstLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
			      secondLOV.options[secondLOV.selectedIndex].value;
		pairId =  firstLOV.options[firstLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
			      secondLOV.options[secondLOV.selectedIndex].id;
		parentLOVId = firstLOV.options[firstLOV.selectedIndex].name; // parent productLOVId is stored in the child's name attribute
	}

	var duplicateFlag = false;
	var duplicateEduObj = false;
	if(multiSelect != null){
		for(k=0; k<multiSelect.length; k++){
			var multiselectId = multiSelect.options[k].id;
			// do  not allow same objective with different assessments
			if(multiSelectName == 'educationalObjectivesMultiSelect'){
				var objAssessArray = multiselectId.split(jsGlobalVarDelimiterToSeparateSubValues);
				if(objAssessArray != null && objAssessArray != undefined){
					if(firstId == objAssessArray[0]){
						duplicateEduObj = true;
						break;
					}
				}

			}
			if(multiselectId == pairId){
				duplicateFlag = true;
				break;
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			return false;
		}
		if(duplicateEduObj){
			alert("Cannot add same Educational Dialogue with multiple assessments");
			return false;
		}
		if(pairValue != "" && pairId != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", pairId);
			optionvalue.setAttribute("value", pairValue);
			optionvalue.setAttribute("name", parentLOVId); // parent productLOVId is stored in the child's name attribute
			optionvalue.appendChild(document.createTextNode(pairValue));
			multiSelect.appendChild(optionvalue);
		}
	}
}
// recursive function to delete all the child lovs
function deleteChildRecordsCascade(parentLOV){
	if(parentLOV != null && parentLOV != undefined
		&& parentLOV.onchange != undefined){
		/* get the text in the onchange property.
		   We will get the function called onchange and from the
		   function we will extract the 2nd parameter which
		   is the id of the child element */
		var onChangeText = parentLOV.onchange.toString();
		/* the function called onChange is
		   populateChildLOV(selectedLOV, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName)
		   if we split this text considering comma as the delimiter, then
		   the 2nd cell or arr[1] will contain the childLOVHTMLElementId.
		   By this childLOVHTMLElementId, we can get it's child and so on */
		var onChangeTextArray = onChangeText.split(',');
		var childLOVHTMLElementId = onChangeTextArray[1];
		// trim the id, remove all the whitespaces at both the ends
		childLOVHTMLElementId = childLOVHTMLElementId.replace(/^\s+|\s+$/g, '');
		/* the id that we get is a string and is enclosed in single quotes
		  getElementById is not working with this string enclosed in single quotes.
		  Therefore, we will remove the single quotes from both ends of the string
		  by extracting the string from the 2nd character till the length-1 character
		*/
		childLOVHTMLElementId = childLOVHTMLElementId.substring(1, childLOVHTMLElementId.length-1)
		removeExistingChildLOV(childLOVHTMLElementId);
		var nextChildLOV = document.getElementById(childLOVHTMLElementId);
		if(nextChildLOV != null && nextChildLOV != undefined){
			deleteChildRecordsCascade(nextChildLOV);
		}
	}
}
function hideSectionCheck(selectedMultiSelect, sectionToHideId){
	if(selectedMultiSelect != null && selectedMultiSelect != undefined){
		var hideSectionFlag = true;
		for (var i=selectedMultiSelect.options.length-1; i>-1; i--) {
			var mappedSection = javascriptTripletSectionMap.get(selectedMultiSelect.options[i].id);
			if(mappedSection == sectionToHideId){
				hideSectionFlag = false;
				break;
			}
		}
		return hideSectionFlag;
	}
	return false;
}

function addLOVTripletAndText(rootLOVId, levelOneLOVId, levelTwoLOVId, textAreaId, multiSelectId) {
	var rootLOV = document.getElementById(rootLOVId);
	var levelOneLOV = document.getElementById(levelOneLOVId);
	var levelTwoLOV = document.getElementById(levelTwoLOVId);
	var textArea = document.getElementById(textAreaId);
	var multiSelect = document.getElementById(multiSelectId);
	var quartet = "";
	var quartetId = "";
	var uniquePair = "";
	if( rootLOV != null && levelOneLOV != null &&
		rootLOV.options[rootLOV.selectedIndex].id != -1 &&
		levelOneLOV.options[levelOneLOV.selectedIndex].id != -1 &&
		levelTwoLOV.options[levelTwoLOV.selectedIndex].id != -1){
		quartet = rootLOV.options[rootLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		levelOneLOV.options[levelOneLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		levelTwoLOV.options[levelTwoLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		textArea.value;

		quartetId = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  levelOneLOV.options[levelOneLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  levelTwoLOV.options[levelTwoLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  textArea.value;

		uniquePair = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
		  levelOneLOV.options[levelOneLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
		  levelTwoLOV.options[levelTwoLOV.selectedIndex].id;
	}else{
	    alert('Please select a Product, Topic and Source Reference');
	    return false;
	}

	var duplicateFlag = false;
	if(multiSelect != null){
		for(k=0; k<multiSelect.length; k++){
			var multiselectId = multiSelect.options[k].id;
			var idsArray = multiselectId.split(jsGlobalVarDelimiterToSeparateSubValues);
			if(idsArray != null &&
					idsArray != undefined && idsArray.length > 2){
				var multiSelectUniquePair = idsArray[0] + jsGlobalVarDelimiterToSeparateSubValues + idsArray[1] +  jsGlobalVarDelimiterToSeparateSubValues + idsArray[2];
				if(multiSelectUniquePair == uniquePair){
					duplicateFlag = true;
					break;
				}
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			// clear the scope document notes text area
			textArea.value = '';
			limitChars( textArea, textArea.id+'CharLimit', -1, false);
			return false;
		}
		if(textArea.value == ''){
			alert('Please enter the Question');
			return false;
		}
		if(quartet != "" && quartetId != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", quartetId);
			optionvalue.setAttribute("value", quartet);
			optionvalue.appendChild(document.createTextNode(quartet));
			multiSelect.appendChild(optionvalue);
			// clear the scope document notes text area
			textArea.value = '';
			limitChars( textArea, textArea.id+'CharLimit', -1, false);
		}
	}

}


function addLOVPairAndText(rootLOVId, levelOneLOVId, textAreaId, multiSelectId) {
	var rootLOV = document.getElementById(rootLOVId);
	var levelOneLOV = document.getElementById(levelOneLOVId);
	var textArea = document.getElementById(textAreaId);
	var multiSelect = document.getElementById(multiSelectId);
	var triplet = "";
	var tripletId = "";
	var uniquePair = "";
	if( rootLOV != null && levelOneLOV != null &&
		rootLOV.options[rootLOV.selectedIndex].id != -1 &&
		levelOneLOV.options[levelOneLOV.selectedIndex].id != -1){
		triplet = rootLOV.options[rootLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		levelOneLOV.options[levelOneLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		textArea.value;

		tripletId = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  levelOneLOV.options[levelOneLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  textArea.value;

		uniquePair = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
		  levelOneLOV.options[levelOneLOV.selectedIndex].id;
	}else{
	    if(rootLOVId == "unsolicitedOffLabelProductLOV"){
	    	alert('Please select Product and Topic');
	    }else{
			alert('Please select Study and Site');
		}
		return false;
	}

	var duplicateFlag = false;
	if(multiSelect != null){
		for(k=0; k<multiSelect.length; k++){
			var multiselectId = multiSelect.options[k].id;
			var idsArray = multiselectId.split(jsGlobalVarDelimiterToSeparateSubValues);
			if(idsArray != null &&
					idsArray != undefined && idsArray.length > 2){
				var multiSelectUniquePair = idsArray[0] + jsGlobalVarDelimiterToSeparateSubValues + idsArray[1];
				if(multiSelectUniquePair == uniquePair){
					duplicateFlag = true;
					break;
				}
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			// clear the scope document notes text area
			textArea.value = '';
			limitChars( textArea, textArea.id+'CharLimit', -1, false);
			return false;
		}
		if(textArea.value == ''){
			if(textAreaId != "unsolicitedOffLabelSubTopicVisitNotes"){
				alert('Please add Scope Document Notes');
			}else
				alert('Please enter the Question');
			return false;
		}
		if(triplet != "" && tripletId != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", tripletId);
			optionvalue.setAttribute("value", triplet);
			optionvalue.appendChild(document.createTextNode(triplet));
			multiSelect.appendChild(optionvalue);
			// clear the scope document notes text area
			textArea.value = '';
			limitChars( textArea, textArea.id+'CharLimit', -1, false);
		}
	}

}

function addLOVPairAndLOVAsText(rootLOVId, levelOneLOVId, LOVAsTextId, multiSelectId) {
	var rootLOV = document.getElementById(rootLOVId);
	var levelOneLOV = document.getElementById(levelOneLOVId);
	var LOVAsTextElement = document.getElementById(LOVAsTextId);
	var multiSelect = document.getElementById(multiSelectId);
	var triplet = "";
	var tripletId = "";
	var uniquePair = "";
	if( rootLOV != null && levelOneLOV != null &&
		rootLOV.options[rootLOV.selectedIndex].id != -1 &&
		levelOneLOV.options[levelOneLOV.selectedIndex].id != -1 &&
		LOVAsTextElement != null && LOVAsTextElement.innerText != ""){
		triplet = rootLOV.options[rootLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		levelOneLOV.options[levelOneLOV.selectedIndex].value + jsGlobalVarDelimiterToSeparateSubValues +
		LOVAsTextElement.innerText;

		tripletId = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  levelOneLOV.options[levelOneLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
				  LOVAsTextElement.title;

		uniquePair = rootLOV.options[rootLOV.selectedIndex].id + jsGlobalVarDelimiterToSeparateSubValues +
		  levelOneLOV.options[levelOneLOV.selectedIndex].id;
	}else{
		if(rootLOVId == "approvedProductLOV" && 
			(rootLOV == null || rootLOV.options[rootLOV.selectedIndex].id == -1 || 
			levelOneLOV == null || levelOneLOV.options[levelOneLOV.selectedIndex].id == -1)){
	    	alert('Please select an Approved Product and a Communication Topic');
	    }
	    if (rootLOVId == "approvedProductLOV" && 
	    	rootLOV != null && levelOneLOV != null &&
			rootLOV.options[rootLOV.selectedIndex].id != -1 &&
			levelOneLOV.options[levelOneLOV.selectedIndex].id != -1 && 
			(LOVAsTextElement == null || LOVAsTextElement.innerText == "")) {
			alert('No Medical Objective exists for the selected Communication Topic.');
		}
	    return false;
	}

	var duplicateFlag = false;
	if(multiSelect != null){
		for(k=0; k<multiSelect.length; k++){
			var multiselectId = multiSelect.options[k].id;
			var idsArray = multiselectId.split(jsGlobalVarDelimiterToSeparateSubValues);
			if(idsArray != null &&
					idsArray != undefined && idsArray.length > 2){
				var multiSelectUniquePair = idsArray[0] + jsGlobalVarDelimiterToSeparateSubValues + idsArray[1];
				if(multiSelectUniquePair == uniquePair){
					duplicateFlag = true;
					break;
				}
			}
		}
		if(duplicateFlag){
			alert("Value already selected");
			// clear the scope document notes text area
			LOVAsTextElement.innerText = '';
			LOVAsTextElement.title = '';
			return false;
		}
		if(triplet != "" && tripletId != ""){
			var optionvalue = document.createElement("option");
			optionvalue.setAttribute("id", tripletId);
			optionvalue.setAttribute("value", triplet);
			optionvalue.appendChild(document.createTextNode(triplet));
			multiSelect.appendChild(optionvalue);
			// clear the scope document notes text area
			LOVAsTextElement.innerText = '';
			LOVAsTextElement.title = '';
		}
	}

}

function populateChildLOVByDeleteStatus(selectedLOV, childLOVHTMLElementId, removeExistingValuesFlag, childLOVName, allowDeletedValues){
  	// TODO : Default selected implementation in child LOV
	if(selectedLOV != null){

		if(removeExistingValuesFlag){ // remove all the values from child LOVs cascade
			deleteChildRecordsCascade(selectedLOV);
		}else{
			var childLOV = document.getElementById(childLOVHTMLElementId);
			childLOV.disabled = true; // disable the selection in child LOV until new values are populated
			// Now, delete all the lovs below the child lov
			deleteChildRecordsCascade(childLOV);
		}
	   	var selectedIndex = selectedLOV.selectedIndex;
	   	var selectedLOVId = selectedLOV.options[selectedIndex].id;
	   	if("getAllChildLOVs" == selectedLOVId){
	   		selectedLOVId = "";
	   		for(var i=selectedLOV.length-1; i>0; i--){
	 			if("getAllChildLOVs" != selectedLOV.options[i].id){
	 				selectedLOVId = selectedLOVId + "," + selectedLOV.options[i].id ;
	 			}
	 		}
	 		selectedLOVId = selectedLOVId.substring(1);
	   	}
   		var URL = "populateChildLOV.htm?childLOVName="+childLOVName+"&parentId="+selectedLOVId+"&allowDeletedValues="+allowDeletedValues;
	   	ajaxFunction(URL, childLOVHTMLElementId, removeExistingValuesFlag, selectedLOVId);
	}
  }