<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants"%>
<%
String selectionCriteriaJSONArray = (String) request.getAttribute("selectionCriteriaJSONArray");
String attributeId = (String) request.getParameter("attributeId");
String entityId = (String) request.getParameter("entityId");
String entityAttr = (String) request.getParameter("entityAttr");
String parentId = (String) request.getParameter("parentId");
String tabName = (String) request.getParameter("tabName");
String currentKOLName = (String) request.getParameter("currentKOLName");
String TLStatusAttr = (String) request.getAttribute("TLStatusAttr");
String TLStatusValue = (String) request.getAttribute("TLStatusValue");
String SOIAttr = (String) request.getAttribute("SOIAttr");
String SOIValue = (String) request.getAttribute("SOIValue");
String targetWindow = (String) request.getParameter("targetWindow");
String region = (String) request.getAttribute("regionOfTL");
%>
<html>
<head>
<script language="javascript"></script>
<script type="text/javascript" src="js/utilities/JSON.js"></script>
<script type="text/javascript" src="js/utilities/JSONError.js"></script>
<script>
function ajaxFunction(URL, isAsynchronousCall){
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
      xmlHttp.onreadystatechange = function(){responseProcessor(xmlHttp)};
      xmlHttp.send(null);
}
  function responseProcessor(xmlHttp){
    //If the readystate is 4 then check for the request status.
        if (xmlHttp.readyState == 4) {
            if (xmlHttp.status == 200) {
                 setNewValuesInParent(); // set the values in the parent form
                 alert('Settings saved successfully');
                 window.close();
             }
        }
  }
function saveChanges(){
    var thisform = document.selectionCriteriaForm;
    thisform.saveButton.style.backgroundImage = 'url(images/buttons/save_disabled.gif)';
    thisform.saveButton.disabled = true;
    thisform.cancelButton.disabled = true;
    document.getElementById('progressbarOverlayDiv').style.display = 'block';
    document.getElementById('progressbarDiv').style.display = 'block';
    var inputs = document.getElementsByTagName('input');
    var URL = 'editProfileAttributes.htm?fromSelectionCriteriaPopup=true&action=save&attributeId=<%=attributeId%>&entityId=<%=entityId%>&entityAttr=<%=entityAttr%>&parentId=<%=parentId%>&tabName=<%=tabName%>&currentKOLName=<%=currentKOLName%>';
    for(var i=0; i<inputs.length; i++){
        if(inputs[i].name.indexOf('attr_') == 0){
        	URL = URL + '&' + inputs[i].name + '=' + inputs[i].value;
        }
    }
   ajaxFunction(URL, true);
}
function addRow(targetTable, attributeId, question, answer, type, selectionCriteriaAttName){
      var lastRow = targetTable.rows.length;
      var row = targetTable.insertRow(lastRow);
      
      if('<%=region%>' == '<%=Constants.TL_REGION_INTERCON%>'){
      	if(type =='National'){
      		
      		var cell1 = row.insertCell(0);
      		var input = document.createElement('input');
      		input.type = 'radio';
      		input.name = 'attr_' + attributeId;;
      		input.title = 'Click to select International';
      		input.id = type;
      		input.value = ('International');
      		input.onclick = function(){calculateNewValuesIntercon();};
      		input.defaultChecked = (answer == 'Yes' ? true : false);
      		cell1.appendChild(input);
      		
      		var cell1 = row.insertCell(1);
      		var div = document.createElement('div');
      		div.className = 'text-blue-01';
      		var textNode = document.createTextNode('Int');
      		div.appendChild(textNode);
      		cell1.appendChild(div);
      		
      		var cell1 = row.insertCell(2);
      		var input = document.createElement('input');
      		input.type = 'radio';
      		input.name = 'attr_' + attributeId;;
      		input.title = 'Click to select National';
      		input.id = type;
      		input.value = ('National');
      		input.onclick = function(){calculateNewValuesIntercon();};
      		input.defaultChecked = (answer == 'Yes' ? true : false);
      		cell1.appendChild(input);
      		
      		var cell1 = row.insertCell(3);
      		var div = document.createElement('div');
      		div.className = 'text-blue-01';
      		var textNode = document.createTextNode('Nat');
      		div.appendChild(textNode);
      		cell1.appendChild(div);
      		      		
      		var cell1 = row.insertCell(4);
      		var input = document.createElement('input');
      		input.type = 'radio';
      		input.name = 'attr_' + attributeId;;
      		input.title = 'Click to select No';
      		input.id = type;
      		input.value = ('No');
      		input.onclick = function(){calculateNewValuesIntercon();};
      		input.defaultChecked = (answer == 'Yes' ? true : false);
      		cell1.appendChild(input);
      		
      		var cell1 = row.insertCell(5);
      		var div = document.createElement('div');
      		div.className = 'text-blue-01';
      		var textNode = document.createTextNode('N/A');
      		div.appendChild(textNode);
      		cell1.appendChild(div);
      		
      		var cell2 = row.insertCell(6);
      		cell2.id = input.name + '_QuesTD';
      		cell2.className = 'text-blue-01';
      		cell2.innerText = question;
      		cell2.name = selectionCriteriaAttName;
      	}else{
      		var cell1 = row.insertCell(0);
      		var input = document.createElement('input');
      		input.type = 'checkbox';
      		input.name = 'attr_' + attributeId;;
      		input.title = 'Click once for Yes (Checked)\nClick again for No (Unchecked)';
      		input.id = type;
      		input.value = ( answer == null || answer == '' ? 'No' : answer);
      		input.onclick = function(){calculateNewValuesIntercon();};
      		input.defaultChecked = (answer == 'Yes' ? true : false);
      		cell1.appendChild(input);

      		row.insertCell(1);
			row.insertCell(2);      		
      		row.insertCell(3);
      		row.insertCell(4);
      		row.insertCell(5);
      		
      		var cell2 = row.insertCell(6);
      		cell2.id = input.name + '_QuesTD';
      		cell2.className = 'text-blue-01';
      		cell2.innerText = question;
      		cell2.name = selectionCriteriaAttName;
      	}
      }else{
      	var cell1 = row.insertCell(0);
      	var input = document.createElement('input');
      	input.type = 'checkbox';
      	input.name = 'attr_' + attributeId;;
      	input.title = 'Click once for Yes (Checked)\nClick again for No (Unchecked)';
      	input.id = type;
      	input.value = ( answer == null || answer == '' ? 'No' : answer);
      	input.onclick = function(){calculateNewValuesIntercon();};
      	input.defaultChecked = (answer == 'Yes' ? true : false);
      	cell1.appendChild(input);
      	var cell2 = row.insertCell(1);
      	cell2.id = input.name + '_QuesTD';
      	cell2.className = 'text-blue-01';
      	cell2.innerText = question;
      	cell2.name = selectionCriteriaAttName;
      
      	var thisform = document.selectionCriteriaForm;
      	if(input.checked){
        	  if(input.id == 'National'){
        		    thisform.nationalCount.value = parseInt(thisform.nationalCount.value) + 1;
        	  }
          	thisform.totalCount.value = parseInt(thisform.totalCount.value) + 1;
      	}
      	setNewValues();
      
      }
}
function calculateNewValuesIntercon(){
	var thisform = document.selectionCriteriaForm;
	var input = document.getElementsByTagName('input');
	var nationalCount = 0;
    var totalCount = 0;
	var internationalCount =0;  
	var SOIAttr = thisform.attr_<%=SOIAttr%>;
    var TLStatusAttr = thisform.attr_<%=TLStatusAttr%>;
        	
	for(var i=0;i<input.length;i++){
		if(input[i].checked == true &&(input[i].type =='radio' || input[i].type =='checkbox') && input[i].name !=''){
			var selectedValue = input[i].value;
			if(input[i].type =='checkbox')
				selectedValue =  (input[i].checked ? 'Yes' : 'No');
			var selectedId = input[i].id;
			if('<%=region%>' == '<%=Constants.TL_REGION_INTERCON%>'){
				if(selectedValue !='No'){
     				if(selectedValue == 'International'){   
            			internationalCount = internationalCount + 1;
        			}else if(selectedValue == 'National'){   
            				nationalCount = nationalCount + 1;
        			}		
        			totalCount = totalCount + 1;
    			}		
    
   	 		}else if(selectedValue == 'Yes'){
        		if(selectedId == 'National'){
            		nationalCount = nationalCount + 1;
        		}
        		totalCount = totalCount + 1;
    		
			}
						

		}	
	}
	
	if('<%=region%>' == '<%=Constants.TL_REGION_INTERCON%>'){
		if(internationalCount >=4){
			SOIAttr.value = 'International';
		}else if((internationalCount + nationalCount) >=3){
			SOIAttr.value = 'National';
		}else if((internationalCount + nationalCount) ==2 && totalCount >=4){
			SOIAttr.value = 'National';
		}else if(totalCount >=3){
			SOIAttr.value = 'Local';
		}else {
			SOIAttr.value = 'N/A';
		} 
	}else {
	   	if(nationalCount >= 4){
    		SOIAttr.value = 'National';
  		 }else if(totalCount >= 4){
    		SOIAttr.value = 'Regional A';
    	}else if(totalCount == 3){
    		SOIAttr.value = 'Regional B';
   	 	}else{
    		SOIAttr.value = 'N/A';
    	}

    	if(totalCount >= 3){
        	TLStatusAttr.value = '<%=Constants.TL_TYPE_TL%>';
    	}else{
        	TLStatusAttr.value = '<%=Constants.TL_TYPE_HCP%>';
    	}
		
	}
	var SOIDiv = document.getElementById('SOIDiv');
    SOIDiv.innerText = 'Sphere of Influence=' + SOIAttr.value;
    
    var TLStatusDiv = document.getElementById('TLStatusDiv');
    TLStatusDiv.innerText = 'TL Status=' + TLStatusAttr.value;
    
				

}
function calculateNewValues(checkboxObj){
    var thisform = document.selectionCriteriaForm;
    checkboxObj.value = (checkboxObj.checked ? 'Yes' : 'No');
    var nationalCountObj = thisform.nationalCount;
    var totalCountObj = thisform.totalCount;
    
    var nationalCount = parseInt(nationalCountObj.value);
    var totalCount = parseInt(totalCountObj.value);
    
    if(checkboxObj.checked){
        if(checkboxObj.id == 'National'){
            nationalCountObj.value = nationalCount + 1;
        }
        totalCountObj.value = totalCount + 1;
    }else{
        if(checkboxObj.id == 'National' && nationalCount > 0){
            nationalCountObj.value = nationalCount - 1;
        }
        if(totalCount > 0){
            totalCountObj.value = totalCount - 1;
        }
    }
    setNewValues();
}

function setNewValues(){
    var thisform = document.selectionCriteriaForm;
    var nationalCountObj = thisform.nationalCount;
    var totalCountObj = thisform.totalCount;
    var SOIAttr = thisform.attr_<%=SOIAttr%>;
    if(nationalCountObj.value >= 4){
       SOIAttr.value = 'National';
    }else if(totalCountObj.value >= 4){
       SOIAttr.value = 'Regional A';
    }else if(totalCountObj.value == 3){
       SOIAttr.value = 'Regional B';
    }else{
        SOIAttr.value = 'N/A';
    }
    var SOIDiv = document.getElementById('SOIDiv');
    SOIDiv.innerText = 'Sphere of Influence=' + SOIAttr.value;
    
    var TLStatusAttr = thisform.attr_<%=TLStatusAttr%>;
    if(totalCountObj.value >= 3){
        TLStatusAttr.value = '<%=Constants.TL_TYPE_TL%>';
    }else{
        TLStatusAttr.value = '<%=Constants.TL_TYPE_HCP%>';
    }
    var TLStatusDiv = document.getElementById('TLStatusDiv');
    TLStatusDiv.innerText = 'TL Status=' + TLStatusAttr.value;
}
function setNewValuesInParent(){
    var inputs = document.getElementsByTagName('input');
    var targetWindow = <%=targetWindow%>;
    var olSelectCriteria = '';
    for(var i=0; i<inputs.length; i++){
        if(inputs[i].name.indexOf('attr_') == 0){
            var targetObject = targetWindow.document.getElementById(inputs[i].name + 'TD');
            if(targetObject != null && targetObject != undefined){
                targetObject.innerText = inputs[i].value;
            }
            if(inputs[i].value == 'Yes'){
            	olSelectCriteria = olSelectCriteria + document.getElementById(inputs[i].name + '_QuesTD').name + ',';
            }
        }
    }
    var olSelectCriteriaTargetObj = targetWindow.document.getElementById('olSelectCriteriaTD');
    if(olSelectCriteriaTargetObj != null &&
    		olSelectCriteriaTargetObj != undefined){
		
        olSelectCriteriaTargetObj.innerText = olSelectCriteria.slice(0, -1);
    }
}
</script>
 </head>
 <title>Thought Leader Criteria</title>
 <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
 <body>   
    <form name="selectionCriteriaForm" method="post">
    <input type="hidden" name="nationalCount" value="0"/>
    <input type="hidden" name="totalCount" value="0"/>
    <input type="hidden" name="attr_<%=SOIAttr%>" value="<%=SOIValue%>"/>
    <input type="hidden" name="attr_<%=TLStatusAttr%>" value="<%=TLStatusValue%>"/>
    <div class="progressbaroverlay" id="progressbarOverlayDiv"></div>
    <div id="progressbarDiv" style="display:none; left: 50%; top: 50%;">
        <img style="position:absolute; top:40%; left:40%" border="0" src="images/progress_bar.gif" >
    </div>
    <div id="selectionCriteriaDiv">
    <table width="100%">
    <tr>
        <td width="100%">
            <div>
                <div class="myexpertlist">
                    <table>
                       <tr>
                        <td class="text-blue-01">
                          <p>Please select the Thought Leader Criteria attributes which apply.<br>
                             Click Save to complete this entry, or Cancel to exit this screen.
                          </p>
                        </td>
                        <td>&nbsp;</td>
                      </tr>
                     </table>
                </div>
                    <div class="myexpertplan">
                        <table>
                            <tr>
                               <td>
                                   <table>
                                      <tr>
                                          <td class="text-blue-01">Legend:</td>
                                          <td class="text-blue-01"><input type="checkbox" checked disabled/>=Yes</td>
                                          <td class="text-blue-01"><input type="checkbox" disabled/>=No</td>
                                      </tr>
                                   </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
            </div>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <table id="questionTable" class="myexpertlist" width="100%" cellspacing="0">
            </table>
        </td>
     </tr>
     <tr>
        <td width="100%">
            <div class="myexpertplan"  align="left">
                 &nbsp;&nbsp;<input name="saveButton" type="button" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" class="button-01" value="" onClick="saveChanges()" />
                 &nbsp;&nbsp;<input name="cancelButton" type="button" style="border:0;background : url(images/buttons/cancel.gif);width:74px; height:22px;" class="button-01" value="" onClick="javascript:window.close()" />
            </div>
        </td>
    </tr>
    </table>
    <table width="100%">
     <tr>
      <td class="text-blue-01">
          <div id="TLStatusDiv">TL Status=<%=TLStatusValue%></div>
      </td>
      <td class="text-blue-01">
        <div id="SOIDiv">Sphere of Influence=<%=SOIValue%></div>
      </td>
      <td width="50%">&nbsp;</td>
    </tr>
    </table>
    </div>
     </form>  
     <script>
        var selectionCriteriaJSONArray = <%=selectionCriteriaJSONArray%>;
        if(selectionCriteriaJSONArray != null){
            var questionTable = document.getElementById('questionTable');
            for(var i=0; i<selectionCriteriaJSONArray.length; i++){
                var attributeId = selectionCriteriaJSONArray[i].attributeId;
                var question = selectionCriteriaJSONArray[i].question;
                var answer = selectionCriteriaJSONArray[i].answer;
                var type = selectionCriteriaJSONArray[i].type;
                var selectionCriteriaAttName = selectionCriteriaJSONArray[i].selectionCriteriaAttName;
                addRow(questionTable, attributeId, question, answer, type, selectionCriteriaAttName);
            }
        }
     </script>    
    </body>
    </html>