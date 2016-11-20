<%@ include file="imports.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date"%>
<%@ page import="java.util.HashMap"%>
<%@page import="com.openq.survey.QuestionDetails"%>
<%@page import="com.openq.kol.DBUtil"%>
<%@page import="com.openq.survey.NewSurvey"%>
<%@page import="com.openq.web.controllers.Constants"%>
<%@page import="java.text.SimpleDateFormat"%>
<% 
Map questionsMap = null;
String surveyTitle ="Title";
if(request.getSession().getAttribute("surveyTitle")!=null)
{
  surveyTitle=(String)request.getSession().getAttribute("surveyTitle");
}
 String surveyId=null;
  NewSurvey survey = null;
  if(request.getSession().getAttribute("currentSurvey")!=null)
  {
  survey = (NewSurvey)request.getSession().getAttribute("currentSurvey");
  surveyId=survey.getId()+"";
  }
String surveyQuestionObjs = (String)request.getSession().getAttribute("jsonQuestions");
if(surveyQuestionObjs!=null){
surveyQuestionObjs = surveyQuestionObjs.replaceAll("\\'","\\\\\'");
}
String answersFilled = (String)request.getSession().getAttribute("answersFilled");
String edit="false";
if(answersFilled!=null){
answersFilled = answersFilled.replaceAll("\\'","\\\\\'");
edit = "true";
}
String expertId = null;
if(request.getSession().getAttribute("expertId")!=null)
{
 expertId = (String)request.getSession().getAttribute("expertId");
}
String specialitySurvey = (String)request.getAttribute("specialitySurvey");
System.out.println("specialitySurvey is"+specialitySurvey);
String isProfilepage = (String)request.getSession().getAttribute("page");
System.out.println("page"+isProfilepage+"\n");
String currentUserName = (String)request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
SimpleDateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
Date today = Calendar.getInstance().getTime();        
String reportDate = df.format(today);

%>  

<HTML>
<HEAD>
  <TITLE>openQ Medical Relationship Management System</TITLE>
  <LINK href="css/openq.css" type=text/css rel=stylesheet>
  
</HEAD>   
   
<script type="text/javascript" src="js/surveyBasics.js"></script>
<script type="text/javascript" src="js/utilities/JSON.js"></script>
<script type="text/javascript" src="js/utilities/JSONError.js"></script>
<script type="text/javascript" src="js/AjaxRequestObject.js"></script>
  <script type="text/javascript">
   var answersStack = new Array();
   
   function likertObject(text,answer)
   {
     this.text = text
	 this.answer = answer
   }
   function checkMandatoryQuestions()
   {
     if(questionsStack!=null&&questionsStack.length>0)
	 {
	    //alert('total no. of questions'+questionsStack.length)
        for(var i=0;i<questionsStack.length;i++) 
		{
		   switch(questionsStack[i].questionType)
	       {
			case 'multioptmultisel':
				   //alert('QNo:'+(i+1));
				   var qNumber=(i+1);
				   var ocheckBox = document.getElementsByName((qNumber)+'mums')
			       var mumsQuestion = new Array()
				   for(var k=0;k<ocheckBox.length;k++)
							{
						      if(ocheckBox[k].checked)
							  {
							    //alert(ocheckBox[k].value)
							    mumsQuestion.push(ocheckBox[k].value) 
								}
							}
                      answersStack[i] = mumsQuestion;
					if(questionsStack[i].mandatory=='true'&&!mumsQuestion.length>0)
					 {
					   alert('Please fill the answers for all the mandatory questions ('+qNumber+')')
                       if(answersStack.length>0)
						   {
					        answersStack.splice(0,answersStack.length)
						   }
					   return false;
					 }  
					break;
			case 'multioptsinglesel':
			     
			       //alert('QNo:'+(i+1))
					var qNumber=(i+1)
				    var ocheckBox = document.getElementsByName((qNumber)+'muss')
			         var mussQuestion = new Array()
						for(var k=0;k<ocheckBox.length;k++)
							{
						      if(ocheckBox[k].checked)
							  {
							    //alert(ocheckBox[k].value)
							    mussQuestion.push(ocheckBox[k].value)
							   }
							}
					  answersStack[i] = mussQuestion;
                    if(questionsStack[i].mandatory=='true'&&!mussQuestion.length>0)
					 {
					   alert('Please fill the answers for all the mandatory questions ('+qNumber+')')
                       if(answersStack.length>0)
						   {
					        answersStack.splice(0,answersStack.length)
						   }
					   return false;
					 }
					   
					break;
			case 'agreement':
                 var qNumber=(i+1)
				 //alert('QNo:'+qNumber)
				 var likert4Question = new Array();
			     for(var j=0;j<questionsStack[i].answerOptions.length;j++)
				 {
			       //alert('subQNo:'+(j+1))
                   var subAnswer = '';
                   var ocheckBox = document.getElementsByName((qNumber)+"agQ"+(j+1));
                    for(var k=0;k<ocheckBox.length;k++)
							{
						      if(ocheckBox[k].checked)
							  {
							    //alert(ocheckBox[k].value)
							    subAnswer = new likertObject(questionsStack[i].answerOptions[j],ocheckBox[k].value)
								//subAnswer =ocheckBox[k].value;
							     
							   }
							}
				  if(questionsStack[i].mandatory=='true'&&subAnswer==null)
				  {
				     alert('Please fill the answers for all the mandatory questions ('+qNumber+')')
                     if(answersStack.length>0)
					 {
					    answersStack.splice(0,answersStack.length)
				      }
					 return false; 
				   }
				 
				 likert4Question.push(subAnswer);
				 }
				 answersStack[i] = likert4Question;
			    break;
            case 'simpleText':
				var qNumber=(i+1)
				var simpleTextQuestion = new Array();
			    var textAreaEl = document.getElementById(qNumber+'simpleText');
			     //alert('QNo:'+qNumber+'Ans:'+textAreaEl.value)
			     if(textAreaEl.value!=null)
			     {
			     textAreaEl.value = textAreaEl.value.replace(/[\n\r\t]/g, ' ')
			     }
			     simpleTextQuestion.push(textAreaEl.value)
                 answersStack[i] = textAreaEl.value;
				 if(questionsStack[i].mandatory=='true'&&simpleTextQuestion[0]=='')
				  {
				    alert('Please fill the answers for all the mandatory questions ('+qNumber+')')
				    if(answersStack.length>0)
				    {
					    answersStack.splice(0,answersStack.length)
				        return false;
					 }				  
				 }
		         
				 break;
            case 'numText':
                var qNumber=(i+1)
				var textAreaEl = document.getElementById(qNumber+'numericText');
			     //alert('QNo:'+qNumber+'Ans:'+textAreaEl.value)
			     var answerTextQuestion = new Array();
				 answerTextQuestion.push(textAreaEl.value)
                 if(answerTextQuestion[0]!=''&&isNaN(parseInt(answerTextQuestion[0])))
				 {
				   alert('Please enter only numbers for the numeric type question ('+qNumber+')')
                   if(answersStack.length>0)
				    {
					    answersStack.splice(0,answersStack.length)
				        
					 } 
				   return false;
				  }
				  answersStack[i]=textAreaEl.value;
                 if(questionsStack[i].mandatory=='true'&&answerTextQuestion[0]=='')
				  {
				    alert('Please fill the answers for all the mandatory questions ('+qNumber+')')
				    if(answersStack.length>0)
				    {
					    answersStack.splice(0,answersStack.length)
				        return false;
					 }				  
				 }
				 break;
            case 'agreement5':
			    //alert('agreement5')    
			     var qNumber=(i+1)
				 //alert('QNo:'+qNumber)
				 var likert5Question = new Array();
			     for(var j=0;j<questionsStack[i].answerOptions.length;j++)
				 {
			       //alert('subQNo:'+(j+1))
                   var subAnswer = '';
                   var ocheckBox = document.getElementsByName((qNumber)+"ag5Q"+(j+1));
                    for(var k=0;k<ocheckBox.length;k++)
							{
						      if(ocheckBox[k].checked)
							  {
							    //alert(ocheckBox[k].value)
							    //subAnswer =ocheckBox[k].value;
							   subAnswer = new likertObject(questionsStack[i].answerOptions[j],ocheckBox[k].value)
							   }
							}
				  if(questionsStack[i].mandatory=='true'&&subAnswer==null)
				  {
				     alert('Please fill the answers for all the mandatory questions  ('+qNumber+')')
                     if(answersStack.length>0)
					 {
					    answersStack.splice(0,answersStack.length)
				      }
					 return false; 
				   }
				 
				 likert5Question.push(subAnswer);
				 }
                answersStack[i] = likert5Question;
			   break;
			default:
			  alert('Default');
            }
		   
		}
      return true;		 
    }
		
 }
   
   
 function cancelEditSurvey()
 {
   window.close();
 }  
   
   function submitSurvey(editMode)
   {
      if(!checkMandatoryQuestions())
	   {
	     return;
	   }
      else
	 {
	   for(var i=0;i<answersStack.length;i++)
	  {
	    questionsStack[i].answers = answersStack[i];
	  }
	   <%if(specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey")){
		 %>
            var questionsFilled = new Object()
		    questionsFilled.questions = questionsStack
			questionsFilled.surveyId = currSurvey.id 
			questionsFilled.expertId =0
			var questionsFilledArray = new Array()
			questionsFilledArray.push(questionsFilled)   
		    var myJSONText = JSON.encode(questionsFilledArray)
		    var thisform = document.viewSurveyNew
			if(thisform!=null)
			{
		      thisform.filledSurveyValue.value=myJSONText
			  thisform.action = "<%=CONTEXTPATH%>/survey.htm?action=<%=ActionKeys.SAVE_SPECIALTY_SURVEY%>";		  
			  thisform.submit()
			}   
		   alert('The survey has been saved succesfully')
	       window.close();
		   <%} else 
	 {
			  %> 
	  var surveyFilledArray = window.opener.getSurveyArray()
      //alert('surveyId'+currSurvey.id)
	  var selectElement = document.getElementById('interactionAttendee');
      //alert('selected <%=DBUtil.getInstance().doctor%>' + selectElement.options[selectElement.selectedIndex].value.split("_")[1])
      var expertId = selectElement.options[selectElement.selectedIndex].value.split("_")[1]

	  if(surveyFilledArray!=null&&editMode=='false')
	  {
          var exists = new Boolean(false);              
	    for(var k=0;k<surveyFilledArray.length;k++)
			{
		      //alert(surveyFilledArray[k])
			  if(currSurvey.id+'|'+expertId==surveyFilledArray[k])
				{
			      alert('Sorry this survey has already been filled for this expert. Please open it in edit mode  if there are changes');
                  //alert(window);
				  //window.close();
				  return;
				  //exists = new Boolean(true);
				}
			}

	  }

	  
	  //alert(answersStack.length)

      //alert('Answers')
      //alert(myJSONText)
      if(editMode=='true')
      {
	    var questionsEdited = new Object()
		questionsEdited.questionObjects = questionsStack	
		var myJSONText = JSON.encode(questionsEdited)
		//log('************toBeSaved')
        //log(myJSONText)  
		window.opener.setEditSurveyFilled(currSurvey.id,expertId,myJSONText);
	    alert('The survey has been saved succesfully')
		window.close();   
	  }
	 else
     {
       //alert('not edit Mode')
	    var questionsEdited = new Object()
		questionsEdited.questionObjects = questionsStack	
		var myJSONText = JSON.encode(questionsEdited)
		//log('************toBeSaved')
        //log(myJSONText)
	    window.opener.setNewSurvey(currSurvey,selectElement.options[selectElement.selectedIndex].value,myJSONText);
	    alert('The survey has been saved succesfully')
	    window.close();
		}
	 <%}%>
	 }
    }
     
function fillMultiOptQuestionAtIndex(index,answers,type)
{
  for(var i=0;i<answers.length;i++)
   {
     //alert
	 ////log(answers[i])
      var ocheckBox = document.getElementsByName((index)+type)
	  for(var k=0;k<ocheckBox.length;k++)
	  {
	    if(ocheckBox[k].value==answers[i])
			{
		      ocheckBox[k].checked=true
			  //log(' answer:'+answers[i]) 
			}
	  }
   }
}

function fillAgreementQuestionAtIndex(index,answers,type)
{
 //alert

 ////log('fill Agreement'+type)
  var questionObject = questionsStack[index-1]
  var answerOptions = questionObject.answerOptions
  for(var i=0;i<answers.length;i++)
  {
    //alert(answers[i].text+'  '+answers[i].answer)
	for(var j=0;j<answerOptions.length;j++)
		{
		 //alert
		 ////log(answerOptions[j])
	      if(answerOptions[j]==answers[i].text)
			  {
			       var ocheckBox = document.getElementsByName((index)+type+(j+1));
                    for(var k=0;k<ocheckBox.length;k++)
					 {
						//log('SubQ :'+answers[i].text+'Ans:  '+answers[i].answer)
						  if(ocheckBox[k].value==answers[i].answer)
						   {
					         ocheckBox[k].checked= (true)
						   }
					 }
              }
		}
  
  }
}

function fillNumericQuestionAtIndex(index,answers,type)
{
	var textAreaEl = document.getElementById(index+type);
	textAreaEl.value=answers
    //log('answer'+answers)
}
function drawEditQuestion(questionObjects)
{
//alert
	//log('at client')
//alert
		//log(questionObjects)
if(questionObjects!=null){
try
	   {
        
		var testObject=JSON.decode((questionObjects))//.parseJSON();      
	    //log(testObject.questionObjects.length)
        var questionObjects = testObject.questionObjects;
		deleteAllQuestions()
        //log(questionsStack.length)
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
	      alert('parseException'+e)
	   }
 }
}
   
function fillAnswers(questionObject,expertId)
{
  //alert(questionObject)
 //log('Going to fill Answers with this object****************')
 //log(questionObject)
 //log('$$$$$$$$$$$$$')
 if(expertId!=null)
 {
 //log('expertId:'+expertId)
  var oSelect = document.viewSurveyNew.interactionAttendee;
  //alert(oSelect.options.length)
  for(var l=0;l<oSelect.options.length;l++)
  	{
	  //alert(oSelect.options[l].value.split("_")[1])
      if(oSelect.options[l].value.split("_")[1]==expertId)
		  {
	        //oSelect.options[l].selected = true
            oSelect.selectedIndex=l;
			oSelect.disabled=true
		  }
	} 
 }
  if(questionObject!=null){
   try{
   var testObject=JSON.decode(questionObject)//.parseJSON();
   var questionObjects = testObject.questionObjects;
   for(var i=0;i<questionObjects.length;i++)
     {
        //log('Qnumber :'+(i+1)+'type'+questionObjects[i].questionType)
		if(questionObjects[i].answers!=null||questionObjects[i].answers!=undefined){
		switch (questionObjects[i].questionType)
          {
				case 'multioptmultisel':
								 fillMultiOptQuestionAtIndex((i+1),questionObjects[i].answers,'mums')			  
					  break;

			   case 'agreement':
								fillAgreementQuestionAtIndex((i+1),questionObjects[i].answers,"agQ")			  
					  break;
			   case 'simpleText':
								   fillNumericQuestionAtIndex((i+1),questionObjects[i].answers,'simpleText')
					  break;
			   case 'numText':
								   fillNumericQuestionAtIndex((i+1),questionObjects[i].answers,'numericText')
					  break;
			   case 'agreement5':
								fillAgreementQuestionAtIndex((i+1),questionObjects[i].answers,"ag5Q")
					  break;
			   case 'multioptsinglesel':
								   fillMultiOptQuestionAtIndex((i+1),questionObjects[i].answers,'muss')		  
					  break;
				 default:
					  alert('Invalid  Question  type');
          }
		}
	 }
   }catch (e)
	   {}    
  }	   
}
   var specialitySurvey ='false'
   function populateAttendeeDropDown(expertId)
   {
      <%if(specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey")){%>
         specialitySurvey ='true'
	     return 0
	  <%} else {%>
	   var attendeeInfoArray=window.opener.getAddedAttendeesArray();
	   if(attendeeInfoArray.length<1)
	   {
	     alert('No attendees selected. Please select attendees')
         window.close(); 
	   }
  	   for(var i=0;i<attendeeInfoArray.length;i++)
	{
	   var name=attendeeInfoArray[i].split("_")[2];
	   document.viewSurveyNew.interactionAttendee.options[i] = new Option(name,attendeeInfoArray[i]);
	   if(expertId!=null||expertId!='null')
	   { 
	     if(attendeeInfoArray[i].split("_")[1]==expertId)
		 {
		   document.viewSurveyNew.interactionAttendee.selectedIndex = i;
           document.viewSurveyNew.interactionAttendee.disabled=true
		 }

	   }
	}
	disableAllElements();
	<%}%>
   }
   
   
   function disableAllElements(){
	// var allElementsInDocument = document.getElementsByTagName("*"); // for whole page
	<%if("profile".equalsIgnoreCase((String)request.getSession().getAttribute("page"))){%>
	
	var allElementsInDocument = document.viewSurveyNew.getElementsByTagName("*");
    for(var i=allElementsInDocument.length-1; i>-1; i--) {
        var element = allElementsInDocument[i];
        if(element.id == 'closeSurvey' 
        	 ){ // do not disable search buttons
        	continue;
        }
        element.onclick = function(){return false}; // disable all onclick events
        if(element.type == 'select-one' || // drop-down
            //element.type == 'select-multiple' ||
            element.type == 'radio' ||
            element.type == 'checkbox' ||
            element.type == 'button' ||
            element.type == 'text' ||
            element.type == 'textarea' ||
            element.type == 'input'){
		 		element.disabled = true;
		 }
    }
    <%}%>
}
   
   </script>

<body onload="populateAttendeeDropDown('<%=expertId%>')">
<form name="viewSurveyNew" id="viewSurveyNew" method="POST" AUTOCOMPLETE="OFF">
<input id="filledSurveyValue" name="filledSurveyValue" type="hidden" value=""/>
<div class="outerdiv">
    <div class="banner">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td class="logo"></td>
        <td class="logoright"></td>
      </tr>
    </table>
 </div>
<table id="mainTable" width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr class="back-grey-02-light">
    <td >
      <div class="back-grey-02-light" id="one">
        <table width="100%" border="0" cellspacing="1" cellpadding="1">
         <tr class="colTitle">
			 <td> Title : <%=surveyTitle %>
			 </td>
			  <%if(!(specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey"))){%>
			 <td align="right">
			 Select <%=DBUtil.getInstance().doctor%>  <select name="interactionAttendee" id="interactionAttendee" class="field-blue-01-180x20" >
				  </select>
			  &nbsp;&nbsp;</td>
			  <%}%>
		</tr>
        <tr>
		   <%if(specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey")){%>
		     <td>&nbsp;</td>
		</tr>
	    <tr>
		 <td class="text-blue-01"> <b>Medical Employee Name: </b> <%=currentUserName!=null?currentUserName:"N/A"%>
		 </td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		</tr>
		 <tr>
		 <td class="text-blue-01"> <b>Date :</b><%=reportDate%>
			  </td>
          <%}%>
		 </tr>
	  </table>
    </div>
   </td>
  </tr>
  <tr>
     <td>
	     <table id="surveyTable" name="surveyTable" width="100%" height='100%' border="0">
		 </table>

<script>
createSurveyObject('<%=survey.getId()%>','<%=survey.getName()%>','<%=survey.getType()%>'
				 ,'<%=survey.getState()%>','<%=survey.getActive()%>');
</script>
<% if(answersFilled!=null) {%>
<script>
drawEditQuestion('<%=answersFilled%>')
fillAnswers('<%=answersFilled%>','<%=expertId%>')
</script>
<%} else {%>
<script>
drawEditQuestion('<%=surveyQuestionObjs%>')
</script>
<%}%>
<script>
displayLaunchSurvey()
</script>
	 </td> 
  </tr>
 <tr class="back-grey-01-dark">
	<td>
		<div id="questionSelectorDiv">
		</div>
	</td>
 </tr>
 <tr class="back-grey-01-dark">
 <td align="right">
 <%
 if(request.getSession().getAttribute("page")==null&&!
 (specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey"))){
 if(edit!=null&&edit.equals("true")){%>
 
 <input name="cancelsurvey" type="button"  style="background: transparent url(images/buttons/cancel_edit.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 101px; height: 22px;" value=""  onclick="cancelEditSurvey()">
  &nbsp;&nbsp;
 
 <%}} 
   if(request.getSession().getAttribute("page")==null){%>
 <input name="savesurvey" type="button"  style="background: transparent url(images/buttons/submit_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 112px; height: 22px;" value=""  onclick="submitSurvey('<%=edit%>')">
  &nbsp;&nbsp;
  <%} 
  if((request.getSession().getAttribute("page")!=null
  &&"profile".equalsIgnoreCase((String)request.getSession().getAttribute("page")))
  ||(specialitySurvey!=null&&specialitySurvey.equalsIgnoreCase("specialitySurvey"))){ %>

 <input id="closeSurvey" name="closeSurvey" type="button"  style="background: transparent url(images/buttons/close_window.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 112px; height: 22px;" value=""  onclick="javascript:window.close()">
  &nbsp;&nbsp;
 
  <%} %>
  </td>
 </tr> 
  </table>
  </form>
</body>
</html>
 