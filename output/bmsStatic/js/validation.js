

/*
*************************Validation Functions*********************
*/


var regExpForMask = /\s*\(([0-9A-Za-z]){3}\)\s+([0-9A-Za-z]){3}\s*\-\s*([0-9A-Za-z]){4}\s*/;

function allow_only_digits()
{
    if ((window.event.keyCode<48 || window.event.keyCode >58) && (window.event.keyCode!=46))  {
		window.event.keyCode = "0";		
		alert("Please enter only digits");
    } 
}

function blur_check_number(textfeild)
{
		if(textfeild.value == null || textfeild.value=="")
		{
			return false;
		}
			
	    var descValid = textfeild.value.search(/[^0-9]/);
	
		if(descValid != -1)
		{
		  alert('Please enter only digits');
			
		  textfeild.focus();
	  	  return false;
		} 
		return true;
}

function blur_check_email(emailfield)
{

	if(emailfield.value == null || emailfield.value=="")
	{
			return false;
	}
	var first = emailfield.value.indexOf('@');
	if(first == -1 )
	{
		alert("email should have @ ")
		emailfield.focus();
		return false;
	}
	var next = emailfield.value.indexOf('@',first+1);
	if(next != -1 )
	{
		alert("email should have only one @ ")
		emailfield.focus();
		return false;
	}
	
	return true;

}
function textLimit(field, maxlen,name) {
	if(field.value != "") {
	  if (field.value.length > maxlen + 1) {
	    alert('Your input is exceeding the maximum size of 500 characters');
		field.focus();
	  }
//	  if (field.value.length > maxlen)
//	   field.value = field.value.substring(0, maxlen); 
	} 
}

function comparsion(fromVal,toVal)
{
	if (fromVal.value < toVal.value){
		alert("Maximum Score Should be Greater than To Minimum Score");
		return false;
	}
}

function CheckSpace(textfeild){
	    descValid = textfeild.value.search(/[A-Z]|[a-z]|[0-9]/);
		if(descValid == -1)
		{
		  alert('Please fill required values for'+textfeild);
			textfeild.value="";  
			textfeild.focus();
	  	  return false;
		}
}

function checkNullSearch(txtBox)
{		
	var myval =txtBox.value;	
	var len = myval.length;
	var validKW = myval.search(/\s*([0-9A-Za-z])\s*/);
	
    if (myval=="" || validKW == -1)
    {
	    alert("Please enter the required values for "+txtBox.name);
		txtBox.value="";
		txtBox.focus();	
	    return false;
    }
    return true;
}

function updateCheckStatus(obj) {
	if(obj.checked)
	  obj.value = "Yes"
	else
	  obj.value="No";
}

function updateCheckValue(obj,formName,attName){

	var thisform =eval("document."+formName);
	
	if(obj.checked)
	 eval("thisform."+attName).value="Yes"
	else
	 eval("thisform."+attName).value="No";
	
	
}

function avoidSpecialChars(){
	if ((event.keyCode > 32 && event.keyCode < 48) || 
		(event.keyCode > 57 && event.keyCode < 65) || 
		(event.keyCode > 90 && event.keyCode < 97)) {
		alert("Special Characters Not Allowed");
		event.returnValue = false;
       }
}


function CheckAlphaNum(textfeild){

		if(textfeild.value == null || textfeild.value=="")
		{
			//alert('Please enter '+textfeild.name);
			//textfeild.focus();
			return false;
		} 

		
	    var descValid = textfeild.value.search(/[^a-z^A-Z^0-9]/);
	
		if(descValid != -1)
		{
		    alert('Please provide valid value for '+textfeild.name);
			
			textfeild.focus();
	  	    return false;
		}
		return true;
}



function CheckName(textfeild){

		if(textfeild.value == null || textfeild.value=="")
		{
			//alert('Please enter '+textfeild.name);
			//textfeild.focus();
			return false;
		} 

		
	    var descValid = textfeild.value.search(/[^a-z^A-Z]/);
	
		if(descValid != -1)
		{
		    alert('Please provide valid value for '+textfeild.name);
			
			textfeild.focus();
	  	    return false;
		}
		return true;
}

function CheckNameWithDot(textfeild){

		if(textfeild.value == null || textfeild.value=="")
		{
			//alert('Please enter '+textfeild.name);
			//textfeild.focus();
			return false;
		} 

		
	    var descValid = textfeild.value.search(/[^a-z^A-Z^\.]/);
	
		if(descValid != -1)
		{
		    alert('Please provide valid value for '+textfeild.name);
			
			textfeild.focus();
	  	    return false;
		}
		return true;
}


// for mandatory phone fields After checkNullSearch() this function should be invoked
function CheckPhoneNumber(textfeild){

		if(textfeild.value == null || textfeild.value=="")
		{
			//alert('Please enter '+textfeild.name);
			//textfeild.focus();

			return true;
		} 
			
		var regExpForPhoneMask = /\s*\(([0-9]){3}\)\s+([0-9]){3}\s*\-\s*([0-9]){4}\s*/;	
		
		var descValid = regExpForPhoneMask.exec(textfeild.value);

		if(!descValid) {
		  alert('The value should match the pattern \"(xxx) xxx-xxxx\"');
		  textfeild.focus();
	  	  return false;
		}
		
		return true;
}

function CheckNumber(textfeild){

		if(textfeild.value == null || textfeild.value=="")
		{
			//alert('Please enter '+textfeild.name);
			return false;
		}
			
	    var descValid = textfeild.value.search(/[^0-9]/);
	
		if(descValid != -1)
		{
		  alert('Please provide valid value for '+textfeild.name);
			
		  textfeild.focus();
	  	  return false;
		} 
		return true;
}

function checkEmail(emailfield)
{

	var first = emailfield.value.indexOf('@');
	if(first == -1 )
	{
		alert("email should have @ ")
		emailfield.focus();
		return false;
	}
	var next = emailfield.value.indexOf('@',first+1);
	if(next != -1 )
	{
		alert("email should have only one @ ")
		emailfield.focus();
		return false;
	}
	
	return true;

}
function checkNull(txtBox,labelName)
{		
	var myval =txtBox.value;		
	var len = myval.length;
	var validKW = myval.search(/\s*([0-9A-Za-z])\s*/);	
	if(!(txtBox.disabled))
	{
	    if (myval=="" || validKW == -1)
	    {
		    alert("Please enter the required values for "+labelName);
			txtBox.value="";
			txtBox.focus();	
		    return false;
	    }
    }
    return true;
}

function compareDate(date,date1)
{
	//var date = new Date();
	//var date1 = new Date(strDate);
	if (date1.getYear()>date.getYear()){
	  return true;
	}else if (date1.getYear()==date.getYear()){
		if (date1.getMonth()>date.getMonth())
			return true;
		else if (date1.getMonth()==date.getMonth())
		{
			if(date1.getDate()>date.getDate() || date1.getDate()==date.getDate())
				return true;
			else
				return false;
		}
        else 
			return false;
	}else
		return false;
}

function IsValidTime(timeStr) {

		var timePat = /^(\d{2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;
		
		var matchArray = timeStr.match(timePat);
				if (matchArray == null)
						{
						alert("Time is not in a valid format.(Use HH:MM Format)");
						return false;
						}
		hour = matchArray[1];
		minute = matchArray[2];
		second = matchArray[4];
		ampm = matchArray[6];
		
		if (second=="") { second = null; }
		if (ampm=="") { ampm = null }
		
			if (hour < 0  || hour > 23) 
					{
					alert("Hour must be between 0 and 23");
					return false;
					}
				//if  (hour > 12 && ampm != null) {
				//alert("You can't specify AM or PM for military time.");
				//return false;
				//} 
		
				if (minute<0 || minute > 59) {
				alert ("Minute must be between 0 and 59.");
				return false;
				}
		
				if (second != null && (second < 0 || second > 59)) {
				alert ("Second must be between 0 and 59.");
				return false;
				}
		
		return true;
}

function timeCheck(start,end){
		var timePat = /^(\d{2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;
		var matchArray1 = start.match(timePat);
		var matchArray2 = end.match(timePat);
	
		hour1 = matchArray1[1];
		minute1 = matchArray1[2];
		second1 = matchArray1[4];
		ampm1 = matchArray1[6];
	
		hour2 = matchArray2[1];
		minute2 = matchArray2[2];
		second2 = matchArray2[4];
		ampm2 = matchArray2[6];
	
		if (hour1<hour2)
			return true;
		else if (hour1==hour2)
		{
			if(minute1<minute2)
				return true;
			else if(minute1==minute2)
		       return false;
			else 
				return false;
		}else
		return false;
}

function validateZIP(field)
			{
		var valid = "0123456789-";
		var hyphencount = 0;

			if (field.length!=5 && field.length!=10) {
			alert("Please enter your 5 digit or 5 digit+4 zip code.");
			return false;
			}
		for (var i=0; i < field.length; i++) {
			temp = "" + field.substring(i, i+1);
			if (temp == "-") hyphencount++;
				if (valid.indexOf(temp) == "-1") {
				alert("Invalid characters in your zip code.  Please try again.");
				return false;
				}
			if ((hyphencount > 1) || ((field.length==10) && ""+field.charAt(5)!="-")) {
			alert("The hyphen character should be used with a properly formatted 5 digit+four zip code, like '12345-6789'.   Please try again.");
			return false;
			   }
			}
		return true;
		}
		
function emailCheck(email) {

		var invalidChars = '\/\'\\ ";:?`#$&*<>,+=%!()[]\{\}^|';
		for (i=0; i<invalidChars.length; i++) {
		   if (email.indexOf(invalidChars.charAt(i),0) > -1) {
		      return false;
		   }
		}
		for (i=0; i<email.length; i++) {
		   if (email.charCodeAt(i)>127) {
		      return false;
		   }
		}

		var atPos = email.indexOf('@',0);
		var afterAtStrPos = email.indexOf('.',atPos);

		if (atPos == -1 || atPos == 0 || email.indexOf('@', atPos + 1) > - 1 
		      || email.indexOf('@.',0) != -1 || email.indexOf('.@',0) != -1
		      || email.indexOf('..',0) != -1 || email.indexOf('.',0) == 0 
		      || afterAtStrPos == -1 ) {
		   return false;
		}
		
		var suffix = email.substring(email.lastIndexOf('.')+1);
		if (suffix.length != 2 && suffix != 'com' && suffix != 'net' 
		         && suffix != 'org' && suffix != 'edu' 
		         && suffix != 'int' && suffix != 'mil' 
		         && suffix != 'gov' & suffix != 'arpa' 
		         && suffix != 'biz' && suffix != 'aero' 
		         && suffix != 'name' && suffix != 'coop' 
		         && suffix != 'info' && suffix != 'pro' 
		         && suffix != 'museum') {
		   return false;
		}
		return true;
} // end of emailCheck()



	function  isEmpty(controlObj,labelName){
		var val= controlObj.value;
		val = val.replace(/^\s*|\s(?=\s)|\s*$/g, "");
		controlObj.value = val;
		if(val == ""){
			alert( labelName +" should not be empty");
			controlObj.focus();
			return false;
		}
		return true;
	}

 function  isEmptyText(controlObj,name){
		var val= controlObj.value;
		val = val.replace(/^\s*|\s(?=\s)|\s*$/g, "");
		controlObj.value = val;
		if(val == ""){
			alert( name+" should not be empty");
			controlObj.focus();
			return false;
		}
		return true;
	}

function checkTextAreaLen(txtArea, maxLength, labelName)
{
	if (txtArea.value.length > maxLength)
	{
		alert(labelName+" can not contain more than "+maxLength+" characters");
		txtArea.focus();
		
		return false;
	}
	
	return true;
} // end of checkTextAreaLen()
// This code will not allow a user to keyin invalid values.

var r={
  'noSpecialExceptHyphen':/[^-a-z0-9]/ig, // no special characters allowed except -
  'special':/[\W]/g, // no special characters allowed
  'quotes':/['\''&'\"']/g, // no single or double quotes allowed
  'allowDecimals':/[^\d.]/g, // allow decimals allowed
  'allowOnlyNumbers':/[^\d]/g // allow decimals allowed
}

function valid(o,w){
  o.value = o.value.replace(r[w],'');
}

/***************************End of General Validationsssssss**************************************************/

