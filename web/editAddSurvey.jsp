<%@ include file="imports.jsp"%>
<%@ page import="com.openq.survey.NewSurvey"%>
<% NewSurvey survey = (NewSurvey)request.getSession().getAttribute("currentSurvey");
String surveyQuestionObjs = (String)request.getSession().getAttribute("jsonQuestions");
if(surveyQuestionObjs!=null){
surveyQuestionObjs = surveyQuestionObjs.replaceAll("\\'","\\\\\'");
}
System.out.println("At client end"+surveyQuestionObjs);
String savedMessage = (String)request.getSession().getAttribute("savedMessage");
%>
<link rel="stylesheet" type="text/css" media="all"
	href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
<script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
<script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<script type="text/javascript" src="js/newcalendar.js"></script>
<script type="text/javascript" src="js/surveyBasics.js"></script>
<script type="text/javascript" src="js/utilities/JSON.js"></script>
<script type="text/javascript" src="js/utilities/JSONError.js"></script>
<script type="text/javascript" src="js/AjaxRequestObject.js"></script>
<script type="text/javascript">

function setEffectiveDate(){
    var effectiveDateDIV = document.getElementById('effectiveDateDIV');
    if(effectiveDateDIV.style.display == 'none'){
      effectiveDateDIV.style.display = 'block';
    }else{
        effectiveDateDIV.style.display = 'none';
    }
} 
function dateValidation(fieldName1, fieldName2)
    {
    var sDate= document.getElementById(fieldName1);
    var eDate= document.getElementById(fieldName2);
   	if(Date.parse(sDate.value)>Date.parse(eDate.value))
   	{
   		alert("Start Date should not be greater than End Date");
   		return 'false';
   	}
   	else if(Date.parse(eDate.value)>=Date.parse(sDate.value))
   	{
   		return 'true';
   	}
   	alert("Invalid Date");
  		return 'false';
    }

function deletecurrSurvey()
{
  //alert('before delete')
if (confirm("Are you sure you want to delete this survey??"))
	{
	  deleteAllQuestions()
	  document.forms['editAddSurveyForm'].action ="<%=CONTEXTPATH%>/survey.htm?action=deleteSurvey&surveyId="+currSurveyId;
	  document.forms['editAddSurveyForm'].target = "_parent";
	  document.forms['editAddSurveyForm'].submit();
	}
}

function launchThisSurvey(setEffDate)
{
	
	this.setEffDate=setEffDate;
	//alert(setEffDate);
	if(setEffDate=="true")
	{
		var check= dateValidation('sel1','sel2');
		if(check=="false")
		{
		return 0;
		}
		setEffectiveDate();  // to toggle the date div
	}
	else if(setEffDate=="false")
	{
		var check= dateValidation('surveyModifyStartDate_1','surveyModifyEndDate_1');
		if(check=="false")
		{
			return 0;
		}
	}
	
	if(!questionsStack.length>0)
	{
	  alert('Please enter some questions before launching the survey');
      
	}
 else
	{
	//alert(currSurvey.state);
	currSurvey.state='Launched';
	//alert(currSurvey.state);
	newSaveSurvey(setEffDate);
  }
}
function newSaveSurvey(setEffDate)
{
 this.setEffDate=setEffDate;
 //alert(currSurvey.state)

  if(!questionsStack.length>0)
	{
	  alert('Please enter some questions before saving the survey');
      
	}
  else
	{
	  var questionJSONText = JSON.encode(questionsStack)
	  var surveyJSONText = JSON.encode(currSurvey)
	  var url = "<%=CONTEXTPATH%>/survey.htm?action=saveSurvey&dataSent=''&survey="+(surveyJSONText)+"&dateFlag="+setEffDate;
	 document.forms['editAddSurveyForm'].surveyObj.value=surveyJSONText
     document.forms['editAddSurveyForm'].questionObj.value=questionJSONText

	 document.forms['editAddSurveyForm'].action =url;
	 document.forms['editAddSurveyForm'].target = "_parent";
	 document.forms['editAddSurveyForm'].submit();
     //alert('after submit') 
   }
}

function saveNewSurvey()
{
  if(!questionsStack.length>0)
	{
	  alert('Please enter some questions before saving the survey');
      
	}
  else
	{  
	  var myJSONText = JSON.encode(questionsStack)
	  //alert(currSurveyId)
      //alert(currSurveyTitle)
	  //alert('New JSON')
	  //alert(myJSONText)
	  //alert('WOW')
	  var url = "<%=CONTEXTPATH%>/survey.htm?action=submitData&dataSent="+escape(myJSONText)
		  +"&surveyId="+currSurveyId+"&surveyTitle="+currSurveyTitle;
	  request.open("GET",url,true);
	  //request.setRequestHeader("Content-Type","text/x-json");
	  request.onreadystatechange = showconfirmation;
	  request.send(null);
	  //firebug.watchXHR(request);
	 }

}



function showconfirmation()
{
	if (request.readyState == 4) {
    if (request.status == 200) 
	{
		try
	   {
        //alert(request.responseText)
		var testObject=JSON.decode(request.responseText)//.parseJSON();      
	     //alert(testObject.questionObjects.length)
         //alert(testObject.surveyTitle)
          
		 var questionObjects = testObject.questionObjects;
		 /*deleteAllQuestions()
         //alert(questionsStack.length)
		 for(var i=0;i<questionObjects.length;i++)
		 {
		   addQuestion(questionObjects[i].questionText,questionObjects[i].questionType,
			   questionObjects[i].answerOptions)
		   if(questionObjects[i].questionType=='agreement')
			 {
		      drawAgreementQuestionAtIndex(questionsStack[i],i+1)
			 }
           else
			{
		     drawMultiOptQuestionAtIndex(questionsStack[i],i+1)  
		   }
		  }
		 */   
	  
	  }
	   catch(e)
	   {
	      //alert('parseException'+e)
	   }
	
	}
  }
}

function drawEditQuestion(questionObjects)
{
//alert('at client')
//alert(questionObjects)
if(questionObjects!=null){
try
	   {
        var testObject=JSON.decode(questionObjects)//.parseJSON();      
	    //alert(testObject.questionObjects.length)
        var questionObjects = testObject.questionObjects;
		deleteAllQuestions()
        //alert(questionsStack.length)
		 for(var i=0;i<questionObjects.length;i++)
		 {
		   addQuestion(questionObjects[i].questionText,questionObjects[i].questionType,
			   questionObjects[i].answerOptions,questionObjects[i].mandatory)
		  switch (questionObjects[i].questionType)
          {
				case 'multioptmultisel':
								 drawMultiOptQuestionAtIndex(questionsStack[i],(i+1))			  
					  break;

			   case 'agreement':
								 drawAgreementQuestionAtIndex(questionsStack[i],(i+1))			  
					  break;
			   case 'simpleText':
								  drawSimpleTextAtIndex(questionsStack[i],(i+1))
					  break;
			   case 'numText':
								  drawNumericTextAtIndex(questionsStack[i],(i+1))
					  break;
			   case 'agreement5':
								  drawAgreementQuestion5AtIndex(questionsStack[i],(i+1))
					  break;
			   case 'multioptsinglesel':
								 drawMultiOptSingleQuestionAtIndex(questionsStack[i],(i+1))			  
					  break;
				 default:
					  alert('Invalid  Question  type');
          }

		  
		}
		    
	  
	}
	   catch(e)
	   {
	      //alert('parseException'+e)
	   }
}
}

function createNewSurveys()
{
  if(!questionsStack.length>0)
	{
	  alert('Please enter some questions before closing the current survey');
      
	}
  else
  {
     var url = "<%=CONTEXTPATH%>/survey.htm";
	 document.forms['editAddSurveyForm'].action =url;
	 document.forms['editAddSurveyForm'].target = "_parent";
	 document.forms['editAddSurveyForm'].submit();
  }
}
</script>
<HEAD>
  <TITLE> openQ 2.0 - openQ Technologies Inc.</TITLE>
</HEAD>
<BODY>
<form id="editAddSurveyForm" name="editAddSurveyForm" method="POST" AUTOCOMPLETE="OFF">
<input id="surveyObj" name="surveyObj" type="hidden"/>
<input id="questionObj" name="questionObj" type="hidden"/>
<table width="100%" border="0">
    <tr>
	    <td>
		    <table id="surveyTable" name="surveyTable" width="100%" height='100%' border="0">
			  <%if(savedMessage!=null&&!(savedMessage).equals("")) {%>
			     <tr>
				 <td width="100%" class="text-blue-01-red">
                 <%=savedMessage%>
				 </td> 
				 </tr>
			  <%}%>
			  <tr>
			    <td width="100%">
				 <div id="surveyTitle" class="colTitle">
                 <%=survey!=null?survey.getName():""%> 
				 <script> createSurvey('<%=survey!=null?survey.getName():""%>',
				 '<%=survey!=null?survey.getId()+"":""%>');
				 createSurveyObject('<%=survey.getId()%>','<%=survey.getName()%>','<%=survey.getType()%>'
				 ,'<%=survey.getState()%>','<%=survey.getActive()%>','<%=survey.getSurveyStartDate()%>','<%=survey.getSurveyEndDate()%>');
				 
				 </script>
				 </div>
                </td>
			  </tr>
			</table>
		 </td>
	</tr>
</table>
<div id="effectiveDateDIV" style="display:none">
      <table id="effDateTable">
        <tr>
            <td width="11%"><span class="text-blue-01-bold">Choose Start Date:</span></td>
            <td width="11%"><span class="text-blue-01-bold">Choose End Date:</span></td>
      </tr>
      <tr>
          <td width="11%"><input type="text" readonly="true" size="15"
                class="field-blue-01-180x20" name="surveyStartDate" id="sel1"
                value="mm/dd/yyyy"><a href="#"
                onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22"
                border="0" align="top"></a>
            
          </td>

          <td width="11%"><input type="text" readonly="true" size="15"
                    class="field-blue-01-180x20" name="surveyEndDate" id="sel2"
                    value="mm/dd/yyyy"><a href="#"
                    onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img
                    src="images/buttons/calendar_24.png" width="22" height="22"
                    border="0" align="top"></a>
                
          </td>
          <td>
	&nbsp;<input name="showSurvey" type="button" value ="LAUNCH"  value="" onClick="launchThisSurvey('true')" />
	</td>
      </tr>
    </table>
 </div>
<table id="surveyOpsTable" name="surveyOpsTable" width="100%">
<tr>
<td >
<input name="saveSurvey" type="button" style="background: transparent url(images/buttons/save_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 101px; height: 22px;" value="" onClick="newSaveSurvey('true')"/>
&nbsp;&nbsp;
<input name="launchSurvey" type="button" value="Launch Survey" onClick="setEffectiveDate()"/>
&nbsp;&nbsp;
<input name="deleteSurvey" type="button"  value="Delete Survey" onClick="deletecurrSurvey()"/>
&nbsp;&nbsp;
<input name="createSurvey" type="button"  value="Create New Survey" onClick="createNewSurveys()"/>
</td>
</tr>
<tr>
<td>
<div id="questionSelectorDiv">
</div>
</td>
</tr>
</table>

<script>drawQuestionSelectorDiv()</script>
<script>drawEditQuestion('<%=surveyQuestionObjs%>');</script>
<% if(survey.getState()!=null&&survey.getState().equals("Launched")) {%>
<script> displayLaunchSurvey()</script>
<%}%>
</form>
</BODY>
</HTML>
