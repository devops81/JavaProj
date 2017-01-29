/* This file will be used to store the commonly used Javascript functions.
 * This will help us in managing the code.
 */


/* Deepak : submit the form by pressing the Enter key
 * The function accepts the name of the function to be called as the parameter.
 * Eg. submitFormByEnterKey(testDate) will execute testDate function if the
 * keypressed is Enter
 */
function submitFormByEnterKey(functionObj){
	  if (window.event && window.event.keyCode == 13){
		  functionObj();
	  }else{
		  return true;
	  }
}
/* This function escapes the single-quotes for sql operations
 * 
 */
function checkAndReplaceApostrophe(value){
	if(value.indexOf("'") != -1){
		value = value.replace(/'/g,"''");
	}
	return value.trim();
}

var progressBarWindow ;
function openProgressBar() {
	progressBarWindow = window.showModelessDialog('main.jsp','Locations','dialogHeight:150px;dialogWidth:500px;scroll:no;resizable:no;status:no;center:yes;help:no;unadorned:yes');
}

function checkForProgressBar(){
	if(progressBarWindow != null){
		if(!progressBarWindow.closed){
			progressBarWindow.close();
		}
	}
}
String.prototype.trim = function () {
	return this.replace(/^\s*/, '').replace(/\s*$/, ''); 
}
/*
 * Global variable to store the maximum number of characters oracle allows in varchar2 column
 */
var _oracleMaxCharacterLimit = 4000;
var _oracleMaxCharacterLimitMessage = 'You can enter maximum of ' + _oracleMaxCharacterLimit + ' characters only.';
/*
 * This function limits the number of characters in a text area
*/
function limitChars(textarea, infodiv, maxcharacters, showAlert){
	var text = textarea.value;	
	var textlength = text.length;
	var info = document.getElementById(infodiv);
	if( maxcharacters == -1 ){
		maxcharacters = _oracleMaxCharacterLimit;
	}
	if(textlength > maxcharacters){
		info.innerHTML = 'You can enter maximum of ' + maxcharacters + ' characters only.';
		textarea.value = text.substr(0, maxcharacters);
		if( showAlert ){
			alert( 'You have entered ' + textlength + ' characters. Only the first ' + _oracleMaxCharacterLimit + ' characters will be saved.' );
		}
		return false;
	}else{
		info.innerHTML = 'You can enter '+ ( maxcharacters - textlength ) +' more characters.';
		return true;
	}
}
/*
 * In alpha mode. Not tested properly
 */
function attachCharLimit( thisform ){
	if( undefined != thisform ){

		var allTextAreasInDocument = thisform.getElementsByTagName( 'textarea' );
		for(var i=allTextAreasInDocument.length-1; i>-1; i--) {
			var textarea = allTextAreasInDocument[i];
			var messageDiv = document.createElement('div');
			var messageDivId = new Date().getTime() + 'CharLimit';
			messageDiv.id = messageDivId;
			messageDiv.className= 'text-11px-red';
			messageDiv.innerHTML = 'You can enter maximum of ' + _oracleMaxCharacterLimit + ' characters only.';
			textarea.parentNode.appendChild( messageDiv );
			textarea.onkeyup = function() { limitChars( this, _oracleMaxCharacterLimit, messageDivId); };
		}
	}	
}
/*
 * In alpha mode. Not tested properly
 */
function validateTextAreaDataSize( thisform ){
	if( undefined != thisform ){

		var allTextAreasInDocument = thisform.getElementsByTagName( 'textarea' );
		for(var i=allTextAreasInDocument.length-1; i>-1; i--) {
			var textarea = allTextAreasInDocument[i];
			var textlength = textarea.length;
			if(textlength > _oracleMaxCharacterLimit){
				var response = confirm('Only first ' + _oracleMaxCharacterLimit + ' characters will be saved. Do you want to continue?');
				if( !response ){
					return false;
				}
			}
		}
		return true;
	}	
}