	function dosubmit()
	{}
	function deleteOption(object,index)
	{
		object.options[index] = null;
	}




     function changeExpenseVenue() {
        if(document.getElementById("expenseType")) {
            var selText = document.getElementById("expenseType").options[document.getElementById("expenseType").selectedIndex].innerText;
            if(selText != "No Expense") {
                document.getElementById("expenseVenue").disabled=false;
            } else {
                document.getElementById("expenseVenue").options.selectedIndex = 0;
                document.getElementById("expenseVenue").disabled=true;
            }
        }
    }

    function LTrim(str) {

        for (var k=0; k<str.length && str.charAt(k)<=" " ; k++) ;
        return str.substring(k,str.length);
      }
	function RTrim(str) {
	 for (var j=str.length-1; j>=0 && str.charAt(j)<=" " ; j--) ;
	 return str.substring(0,j+1);
	}
	function Trim(str) {
	 return LTrim(RTrim(str));
	}

    function changeExpenseAmount() {
        var selText = document.getElementById("expenseVenue").options[document.getElementById("expenseVenue").selectedIndex].innerText;
        if(!document.getElementById("expenseType").disabled && selText != "-NA-") {
            document.getElementById("amount").disabled = false;
        }
        if(selText == "-NA-") {
            document.getElementById("amount").value ="";
            document.getElementById("amount").disabled = true;
        }
        var selText1 = document.getElementById("expenseType").options[document.getElementById("expenseType").selectedIndex].innerText;
        if(selText1 == "No Expense") {
		   document.getElementById("amount").value=0;
           document.getElementById("amount").disabled=true;
        } else {
           document.getElementById("amount").disabled=false;
		}
    }
    function populateAttendeeList() {
        var thisform = document.addInteractionForm;

		if (thisform.otherAttendeeName.value == "") {
			alert("Please add Other Attendee")
			return false;
		}

		var attendeeListLen = thisform.attendeeList.length;

		thisform.attendeeList.options[attendeeListLen] = new Option(thisform.otherAttendeeName.value+"(Other)", "other_"+ thisform.otherAttendeeName.value);

		thisform.attendeeList.options[attendeeListLen].selected=true;

		thisform.otherAttendeeName.value = "";

	}

//populating attendee names from OL search, employee search and ORX search

	function addOL(valueFromChild, valueIdFromChild){

		var count = 1;

		var thisform = document.addInteractionForm;
		var TL=document.addInteractionForm.TL.value;
		var attendeeListLen = thisform.attendeeList.length;

			thisform.attendeeList.options[attendeeListLen] = new Option(valueFromChild+"("+TL+")", "kol_"+ valueIdFromChild);
			thisform.attendeeList.options[attendeeListLen].selected=true;

		thisform.otherAttendeeName.value = "";
	}

	function addAttendee(username, phone, email, staffid){

		var thisform = document.addInteractionForm;

		var attendeeListLen = thisform.attendeeList.length;

		var newOptionVal1 = username+"(Employee)";
        var newOptionVal2 = "emp_"+ staffid + "_" + username;
        if(!toCheckIfExist(newOptionVal2)){
			thisform.attendeeList.options[attendeeListLen] = new Option(newOptionVal1, newOptionVal2);
			thisform.attendeeList.options[attendeeListLen].selected=true;
		}
	}
	//Added Function For Event
	function addEvent(eventId, eventName, eventDate, eventCity, eventState){

		var thisform = document.addInteractionForm;

		var attendeeListLen = thisform.attendeeList.length;
		thisform.eventId.value = eventId;
		thisform.selectedEvent.value = eventName;
		thisform.eventDate.value = eventDate;
		thisform.eventLocation.value = eventCity;


	}
	//Event Ended


	function addStudyOptionValue(studyOptionValue) {
		var thisform = document.addInteractionForm;
		var studyOption = document.getElementById("selectStudyIMPACTNumberLOV");
		for (var i=0;i<studyOption.length;i++) {
			if (studyOption.options[i].text == studyOptionValue) {
			studyOption.options[i].selected = true;
			}
		}
	}

    function addORXName(valueFromChild) {

	var thisform = document.addInteractionForm;

    for(var i=0;i<valueFromChild.length;i++)
    {
    	if(valueFromChild[i].split(";")[0] == 'kol'){

			/*var attendeeListLen = thisform.attendeeList.length;
			var attendeeListLen = thisform.attendeeList.length;
    		thisform.attendeeList.options[attendeeListLen] = new Option(valueFromChild[i].split(";")[2]+"(TL)", "kol_"+ valueFromChild[i].split(";")[1]+ "_" +valueFromChild[i].split(";")[2]);*/
    		var TL=document.addInteractionForm.TL.value;
    		var newOptionVal1 = valueFromChild[i].split(";")[2]+"("+TL+")";
            var newOptionVal2 = "kol_"+ valueFromChild[i].split(";")[1]+ "_" +valueFromChild[i].split(";")[2];
            var attendeeListLen = thisform.attendeeList.length;
            if(!toCheckIfExist(newOptionVal2)){
			   thisform.attendeeList.options[attendeeListLen] = new Option(newOptionVal1,newOptionVal2);
			   thisform.attendeeList.options[attendeeListLen].selected=true;
			   return true;
			}
            else {
            	alert("This "+TL+" is already present in the Attendee List");
            	return false;
            }
           /* thisform.attendeeList.options[attendeeListLen].selected=true;*/
    	}
    	else if(valueFromChild[i].split(";")[0] == 'orx'){
			var attendeeListLen = thisform.attendeeList.length;
			var newOptionVal1 = valueFromChild[i].split(";")[2];
            var newOptionVal2 = "orx_"+ valueFromChild[i].split(";")[1]+ "_" +valueFromChild[i].split(";")[2] + "_" +valueFromChild[i].split(";")[3];
            if(!toCheckIfExist(newOptionVal2)){
                thisform.attendeeList.options[attendeeListLen] = new Option(newOptionVal1, newOptionVal2);
                thisform.attendeeList.options[attendeeListLen].selected=true;
            }
            else {
            	alert("This Orx is already present in the Attendee List");
            }
    	}
    	else if(valueFromChild[i].split(";")[0] == 'otr'){
			var attendeeListLen = thisform.attendeeList.length;
            var newOptionVal1 = valueFromChild[i].split(";")[1]+", "+valueFromChild[i].split(";")[2]+"(Other)";
			var newOptionVal2 = "otr_"+ valueFromChild[i].split(";")[1]+ "_"+valueFromChild[i].split(";")[2];
            if(!toCheckIfExist(newOptionVal2)){
			   thisform.attendeeList.options[attendeeListLen] = new Option(newOptionVal1,newOptionVal2);
			   thisform.attendeeList.options[attendeeListLen].selected=true;
			}
            else {
            	alert("This Otr is already present in the Attendee List");
            }
    	} else if(valueFromChild[i].split(";")[0] == 'org'){
			var newOptionVal1 = valueFromChild[i].split(";")[2]+"(ORG)";
			var newOptionVal2 = "org_"+ valueFromChild[i].split(";")[1]+ "_"+valueFromChild[i].split(";")[2];
			var attendeeListLen = thisform.attendeeList.length;
			if(!toCheckIfExist(newOptionVal2)){
			   thisform.attendeeList.options[attendeeListLen] = new Option(newOptionVal1,newOptionVal2);
			   thisform.attendeeList.options[attendeeListLen].selected=true;
			   return true;
			}
			else {
				alert("This Organization is already present in the Attendee List");
            	return false;
            }
		}
    }
}

function toCheckIfExist(newOptionValue){
	var thisform = document.addInteractionForm;
	var attendeeListLen = thisform.attendeeList.length;
	var bFlag = false;
	for(var count=0;count<attendeeListLen;count++){
	    if(thisform.attendeeList.options[count].value == newOptionValue){
		   bFlag = true;
		   break;
	    }
	}
	return bFlag;
}
    function deleteSelect() {
        var thisform = document.addInteractionForm;
        deleted(thisform.attendeeList);

        var arr = thisform.attendeeList.options;
        if(arr != null && arr.length > 0) {
            for(var i=0;i<arr.length;i++) {
                arr[i].selected = true;
            }
        }
    }

    //function for deleting attendee info
    function deleteSelectAttendeeInfo() {
        var thisform = document.addInteractionForm;
        deleted(thisform.attendeeInfo);

        var arr = thisform.attendeeInfo.options;
        if(arr != null && arr.length > 0) {
            for(var i=0;i<arr.length;i++) {
                arr[i].selected = true;
            }
        }
    }
    //function for deleting the MIRFMulitSelect
    function deleteMIRMultipleSelect() {
        var thisform = document.addInteractionForm;
        deleted(thisform.MIRFMultiSelect);

        var arr = thisform.MIRFMultiSelect.options;
        if(arr != null && arr.length > 0) {
            for(var i=0;i<arr.length;i++) {
                arr[i].selected = true;
            }
        }
    }

    function populateKols(kolObject, requestArray) {
        var thisform = document.addInteractionForm;
		var attendeeListLen = thisform.attendeeList.length;
		var TL=document.addInteractionForm.TL.value;

        if (kolObject != null && requestArray != null) {
            var objs = "";
            if (kolObject.indexOf(",") != -1) {
                objs = kolObject.split(",");
            } else {
                objs = kolObject;
            }

            var val = "";
            var requestVar = "";
            if (objs != null && kolObject.indexOf(",") != -1) {
                for (var i = 0; i < objs.length; i++) {
                    val = objs[i];

                    if (requestArray.length > 0) {
                        for (var j = 0; j < requestArray.length; j++) {
                            requestVar = requestArray[j];
                            if (val == requestVar.id) {
                                document.forms['addInteractionForm'].attendeeList.options[attendeeListLen+i] = new Option(requestVar.name+"("+TL+")", "kol_"+val+"_"+requestVar.name);

								document.forms['addInteractionForm'].attendeeList.options[attendeeListLen+i].selected=true;
                            }
                        }
                    }
                }
            } else {
                if (requestArray.length > 0) {
                    var count = 0;
                    for (var j = 0; j < requestArray.length; j++) {
                        requestVar = requestArray[j];
                        if (objs == requestVar.id) {

							document.forms['addInteractionForm'].attendeeList.options[attendeeListLen+count] = new Option(requestVar.name+"("+TL+")", "kol_"+objs+"_"+requestVar.name);

							document.forms['addInteractionForm'].attendeeList.options[attendeeListLen+count].selected=true;
                            count++;
                        }
                    }
                }
            }
        }
    }

	function toCheckExpenseForExpenseType(){
		var thisform     = document.addInteractionForm;
		var noOfAttendee = thisform.attendeeList.length;
		var expTypeInd   = thisform.expenseType.selectedIndex;
		var expTypeText  = thisform.expenseType.options[expTypeInd].text;
		var expTypeValue = thisform.expenseType.options[expTypeInd].value;
		var expAmount    = thisform.amount.value;
		//alert(noOfAttendee+"|"+expTypeInd+"|"+expTypeText+"|"+expTypeValue+"|"+expAmount);
		if(noOfAttendee > 0){
			if(expTypeText == "Other HCP Meal" || expTypeValue == "1574"){
				var amountPerAttendee = expAmount/noOfAttendee;
				//alert(amountPerAttendee);
				if(amountPerAttendee > 30){
				   if(confirm("Expenses Amount is high Press 'OK' if want to continue with saving")){
				      return true;
				   }else{
					   return false;
				}
			  }
			}

			if(expTypeText == "HCP Dinner" || expTypeValue == "1573"){
				var amountPerAttendee = expAmount/noOfAttendee;
				//alert(amountPerAttendee);
				if(amountPerAttendee > 125){
				   if(confirm("Expenses Amount is high Press 'OK' if want to continue with saving")){
				      return true;
				   }else{
					   return false;
				}
			  }
			}

		}
		return true;

	}



	function searchInteractions() {
		var thisform = document.addInteractionForm;
		thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm";
		thisform.submit();
	}
	function searchMyInteractions() {
		var thisform = document.addInteractionForm;
		thisform.action = "<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.PROFILE_INTERACTION%>&kolid=<%=kolid%>&expertId=<%=expertId%>";

		thisform.submit();
	}

	function show_calendar(sName) {
		gsDateFieldName = sName;
		// pass in field name dynamically

		var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0,dialog=yes,minimizable=no";
		if (document.layers) // NN4 param
			winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0,dialog=yes,minimizable=no";

		var win = window.open("Popup/PickerWindow.html", "_new_picker", winParam);
        if(win != "")
           win.focus();

    }
function searchHCP(){

    var winParam = window.open('search_hcp.htm','searchHCP','width=800,height=768,top=50,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
    if (winParam != "")
      winParam.focus ();
}

   function copySelectedFromTextArea(text_area, select_box){

       var text=LTrim(RTrim(text_area.value));
       var length=select_box.length;
       var k=false;
	if(text=='')
{
alert("Please enter some text");
text_area.focus();
return 0;
}
       for( var i=0;i<length;i++)
          {
            if(select_box.options[i].value==text)
              {
		alert("This topic already exist in other topic disscussed");
		text_area.value="";
              k=true;
              break;
              }
          }
          if(!k)
          {

       var newOption=new Option(text,text);
       select_box.options[length]=newOption;
	text_area.value=""
       }

       }



	function addOption(object,text,value)
		{
				var defaultSelected = true;
				var selected = true;
				var optionName = new Option(text, value, defaultSelected, selected)
				object.options[object.length] = optionName;
		}

	function copySelected(fromObject,toObject)
	{
	var k;
	 l=fromObject.options.length
	 to=toObject.options.length
		for (var j=0;j<toObject.options.length;j++)
		{
			toObject.options[j].selected=false;
		}


		 for (var i=0;i<l;i++)
		 {
			if (fromObject.options[i].selected)
			{
				myval=(fromObject.options[i].value)
				for  (var j=0;j<to;j++)
					{
						toval=(toObject.options[j].value)
						k=(myval==toval? true:false);
						if(k) break;
					}
				if(!k)
					{
						addOption(toObject,fromObject.options[i].text,fromObject.options[i].value);
					}
			}
		}
		/*
		for (var j=0;j<toObject.options.length;j++)
		{
			toObject.options[j].selected=true;
		}
		*/

	}
	function moveSelected(fromObject,toObject)
	{
	var k;
	 l=fromObject.options.length
	 to=toObject.options.length

		for (var j=0;j<toObject.options.length;j++)
		{
			toObject.options[j].selected=false;
		}


		 for (var i=0;i<l;i++)
		 {
			if (fromObject.options[i].selected)
			{
				myval=(fromObject.options[i].value)

				for  (var j=0;j<to;j++)
					{
						toval=(toObject.options[j].value)

						k=(myval==toval? true:false);
						if(k) break;
					}
				if(!k)
					{
						addOption(toObject,fromObject.options[i].text,fromObject.options[i].value);
					}

			}
		}
		deleted(fromObject);
	}

	function deleted(fromObject)
	{

		 l=fromObject.options.length

		for (var i=fromObject.options.length-1;i>-1;i--) {
		if (fromObject.options[i].selected)
		deleteOption(fromObject,i);
		}
	}

	function selectAll(toObject)
	{
			for (var j=0;j<toObject.options.length;j++)
		{
			toObject.options[j].selected=true;
		}
	}


	function deleteRegion(formObj)
	{
		var text;

		if(formObj.select1.options.selectedIndex  < 0) {
			alert('Please select a Region to delete');
			formObj.select1.focus();
			return false;
		}


		for (var i=formObj.select1.options.length-1;i>-1;i--) {
		  if (formObj.select1.options[i].selected) {
		    text=formObj.select1.options[i].text;
			to=formObj.Regions.options.length;
		    formObj.Regions.options[to] = new Option(text,text);
		    deleteOption(formObj.select1,i);
	 	  }
		}
	}

function addOptions(toObject, fromObject, msgForObject, flag, field)
{
	var k;
	var to=toObject.options.length;

	if (to >= 1) {
		myval=fromObject.value;
		if(flag == "true") {
			myval += " ( " + field.value + " )";
		}
	}

	for  (var j=0;j<to;j++)
	{
		toval=toObject.options[j].text;
		k=(myval==toval? true:false);
		if(k) break;
	}

	if(!k)
	{
		addIt(toObject, fromObject, flag, field);
	}
}


function addIt(object, fromObject, flag, field)
{
	text=fromObject.value;

	if(flag == "true")
		text += " ( " + field.value + " )";

	var defaultSelected = true;
	var selected = true;
	var optionName = new Option(text,text,defaultSelected, selected)
	object.options[object.length] = optionName;
}


function deleteOptions(fromObject)
{

	l=fromObject.options.length;
	for (var i=fromObject.options.length-1;i>-1;i--) {
		if (fromObject.options[i].selected) {
			fromObject.options[i] = null;
		}
	}

	for (var j=0;j<fromObject.options.length;j++) {
		fromObject.options[j].selected = true;
	}

}

function addInteractionOptions(toObject, fromObject, msgForObject, flag, field)
{
    var k = false;
	var to=toObject.options.length;
    var newMyVal = null;

    var myva = null;
    if (to >= 1 && fromObject.options != null && fromObject.options.length > 0) {
		myval=fromObject.options[fromObject.selectedIndex].innerText;
        newMyVal = fromObject.options[fromObject.selectedIndex].innerText;
        if(flag == "true") {
			myval += " ( " + field.options[field.selectedIndex].innerText + " )";
		}
	}

    var newToVal = null;
    var toval = null;
    if(to > 0) {
        for  (var j=0;j<to;j++)
        {
            toval=toObject.options[j].text;
            if(toval.indexOf("(") != -1) {
                newToVal = toval.substring(0,toval.indexOf("("));
            }

            k=(myval==toval? true:false);
            if(k) break;
            else if(newToVal != null && newMyVal != null &&
                    trimAll(newToVal) == trimAll(newMyVal)) {
                k = true;
                break;
            }
        }
    }
    if(!k)
	{
		addInteractionIt(toObject, fromObject, flag, field);
	}
}

function addInteractionOptionandText(toObject, fromObject,  flag, fromtext1,fromtext2)
{
    var k = false;
	var to=toObject.options.length;
    var newMyVal = null;
    LTrim(RTrim(fromtext1));
    LTrim(RTrim(fromtext2));
    var myva = null;
    if (to >= 1 && fromObject.options != null && fromObject.options.length > 0) {
		myval=fromObject.options[fromObject.selectedIndex].innerText;
        newMyVal = fromObject.options[fromObject.selectedIndex].innerText;
        if(flag == "true") {
			myval += " ( " + fromtext1+ ","+fromtext2+" )";
		}
	}

    var newToVal = null;
    var toval = null;
    if(to > 0) {
        for  (var j=0;j<to;j++)
        {
            toval=toObject.options[j].text;
            if(toval.indexOf("(") != -1) {
                newToVal = toval.substring(0,toval.indexOf("("));
            }

            k=(myval==toval? true:false);
            if(k) break;
            else if(newToVal != null && newMyVal != null &&
                    trimAll(newToVal) == trimAll(newMyVal)) {
                k = true;
                break;
            }
        }
    }
    if(!k)
	{
		addInteractionItforText(toObject, fromObject, flag, fromtext1,fromtext2);
	}
}

function addInteractionIt(object, fromObject, flag, field)
{
    if(fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
        text=fromObject.options[fromObject.selectedIndex].innerText;
    }

    if(flag == "true" && fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
		text += " ( " + field.options[field.selectedIndex].innerText + " )";
        var defaultSelected = true;
        var selected = true;

        var optionName = new Option(text,fromObject.value+"_"+field.value,defaultSelected, selected)
        object.options[object.length] = optionName;
    }
}

function addInteractionItforText(object, fromObject, flag, fromtext1,fromtext2)
{
    if(fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
        text=fromObject.options[fromObject.selectedIndex].innerText;
    }

    if(flag == "true" && fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
		text += " ( " + fromtext1+ ","+fromtext2 + " )";
        var defaultSelected = true;
        var selected = true;

        var optionName = new Option(text,fromObject.value+"@"+fromtext1+"@"+fromtext2,defaultSelected, selected)
        object.options[object.length] = optionName;
    }
}

    function trimAll(sString)
    {
        while (sString.substring(0, 1) == ' ')
        {
            sString = sString.substring(1, sString.length);
        }
        while (sString.substring(sString.length - 1, sString.length) == ' ')
        {
            sString = sString.substring(0, sString.length - 1);
        }
        return sString;
    }
  //New function to copy from dropdown menu and textfield copy
  function copySelectedAttendeeInfo(text_area, text_field, select_box){

  	    if(text_area != null && text_area.options != null && text_area.options.length > 0) {

       		var text=LTrim(RTrim(text_area.options[text_area.selectedIndex].innerText));
       	}
       else
       {
       		text = "";
       		k = true;
       	}
       var textFieldInfo = LTrim(RTrim(text_field.value));

       var length=select_box.length;

       var k=false;
	if(textFieldInfo=='')
	{
		alert("Please enter some Number of Attendees");
		text_field.focus();
		return 0;
	}
	else if(textFieldInfo <= 0)
	{
		alert("There should be one or more number of attendees");
		text_field.focus();
		return 0;
	}
	/**
	else if(!textFieldInfo.match(/[0-9]/))
	{
		alert("Please enter only numbers for Number of attendees ");
		text_field.focus();
		return 0;
	}
	*/
	//alert("length: " + length);
	var i = 0;
	    while( i < length)
	    {
	    	//get index upto hiphen

	    	var string1 = select_box.options[i].innerText;
	    	//alert(string1);
	       	var tokens = string1.split("-");
	       //	alert("token: " +tokens[0]);
	       //	alert("text: " + text);
	        if(tokens[0]==text)
	        {
				alert("This type of attendee already exists");
				k=true;
	            break;
	        }
	        i=i+1;
	    }

   // alert("after else");
    if(!k)
    {
       //var newOptionString = text + "-" + textFieldInfo;
       var newOptionValue = text + "-" + textFieldInfo;
       //alert("text_area_value: " + text_area.value);
       var newOptionValueId = text_area.value + "-" +textFieldInfo;
       var newOption=new Option(newOptionValue, newOptionValueId);

     	if(length == null)
     		length = 0;
     	//alert("length:" +length);
     	//alert(newOptionString);
     	//select_box.options[length].innerHTML=newOptionString;
     	//alert("newOption: " + newOption);
     	select_box.options[length]=newOption;
		newOption.selected = true;
		text_field.value="";
    }


 }

//function to copy from a textbox to a multiselect
function copySelectedMIRFinfo(text_field, select_box){
  var length=select_box.length;
  var textFieldInfo = LTrim(RTrim(text_field.value));
  if(textFieldInfo=='')
	{

		text_field.focus();
		return 0;
	}

	var newOptionValue = textFieldInfo;
    var newOptionValueId = textFieldInfo;
    var newOption=new Option(newOptionValue, newOptionValueId);

    if(length == null)
     	length = 0;

    select_box.options[length]=newOption;
    select_box.options[length].id =newOptionValueId;
    newOption.selected = true;
	text_field.value="";
}

function addhcpConcerns(toObject, fromObject, msgForObject, flag, field)
{
    var k = false;
	var to=toObject.options.length;
    var newMyVal = null;
    var myva = null;
    if (to >= 1 && fromObject.options != null && fromObject.options.length > 0) {
		myval=fromObject.options[fromObject.selectedIndex].innerText;
        newMyVal = fromObject.options[fromObject.selectedIndex].innerText;
        if(flag == "true") {
			myval += " ( " + field.value + " )";
		}

	}

    var newToVal = null;
    var toval = null;
    if(to > 0) {
        for  (var j=0;j<to;j++)
        {
            toval=toObject.options[j].text;
            if(toval.indexOf("(") != -1) {
                newToVal = toval.substring(0,toval.indexOf("("));
            }

            k=(myval==toval? true:false);
            if(k) break;
            else if(newToVal != null && newMyVal != null &&
                    trimAll(newToVal) == trimAll(newMyVal)) {
                k = true;
                break;
            }
        }
    }
    if(!k)
	{
		addInteractionItHcpComments(toObject, fromObject, msgForObject, flag, field);
	}

  	    field.value = "";
		fromObject.selectedIndex = 0;
}


function addInteractionItHcpComments(object, fromObject, msgForObject, flag, field)
{

    if(fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
        text=fromObject.options[fromObject.selectedIndex].innerText;
    }

    if(flag == "true" && fromObject != null && fromObject.options != null && fromObject.options.length > 0) {
		if(msgForObject== "Tool")
			text+=" ( " + field.options[field.selectedIndex].innerText + " )";
		else
			text += " ( " + field.value + " )";
        var defaultSelected = true;
        var selected = true;

        var optionName = new Option(text,fromObject.value+"_"+field.value,defaultSelected, selected)
        object.options[object.length] = optionName;
    }
}




