var questionsStack = new Array() //Global array to hold questions
var currSurveyTitle
var currSurveyId
var currSurvey
/*This function is the class definition of the basic question
  members -> Question:Questiontext
             Type: QuestionType
			 AnswerOptions: AnswerOptions
*/
function question(questionText,questionType,answerOptions,mandatory)
{
  this.questionText = questionText;
  this.questionType = questionType;
  this.answerOptions = answerOptions;
  this.mandatory=mandatory;
 
}

/*This function creates a global survey Object
*/
function survey(id,title,type,state,active)
{
  this.id=id;
  this.title=title;
  this.type=type;
  this.state=state;
  this.active=active;
}
// : vaibhav
function survey(id,title,type,state,active,startDate,endDate)
{
  this.id=id;
  this.title=title;
  this.type=type;
  this.state=state;
  this.active=active;
  this.startDate=startDate;
  this.endDate=endDate;
}

/*This function creates a survey obj
*/
function createSurveyObject(id,title,type,state,active,startDate,endDate)
{
  currSurvey = new survey(id,title,type,state,active,startDate,endDate);
  /*alert('survey Object created')
  alert('survey title'+currSurvey.title)
  alert('survey id'+currSurvey.id)
  alert('survey type'+currSurvey.type)
  alert('survey active'+currSurvey.active)*/
  //alert(currSurvey.startDate);
}

/*This function adds all the questions into a universal array
*/
function addToQuestionsStack(questionObject)
{
  questionsStack.push(questionObject)
}

/* This function is used to add a question to the survey
*/
function addQuestion(questionText,questionType,answerOptions,mandatory)
{
   var newQuestionObject = new question(questionText,questionType,answerOptions,mandatory)
   addToQuestionsStack(newQuestionObject)
}
/*This function deletes a question
*/
function deleteQuestion(id)
{
  questionsStack.splice(id,1)
}

/*function create the surveyObj
*/
function createSurvey(title,surveyId)
{
//alert(title)
//alert(surveyId)
currSurveyTitle=title
currSurveyId=surveyId	
}

function drawCurrentlyAddedQuestion()
{
  /*if(questionsStack!=null)
	  alert(questionsStack.length)*/
var lastAddedQuestion = questionsStack[questionsStack.length-1];
switch(lastAddedQuestion.questionType)
	{
			case 'multioptmultisel':
			  //drawMultiOptMultiSelQuestion(lastAddedQuestion,questionsStack.length);
			  drawMultiOptQuestionAtIndex(lastAddedQuestion,questionsStack.length);
			  break;
			case 'multioptsinglesel':
			  //alert('MultioptionSingleselect');
			  //drawMultiOptSingleSelQuestion(lastAddedQuestion,questionsStack.length);
			  drawMultiOptSingleQuestionAtIndex(lastAddedQuestion,questionsStack.length)
			  break;
			case 'agreement':
			  //alert('Agreement');
			  //drawAgreementScalesQuestion(lastAddedQuestion,questionsStack.length);
			  drawAgreementQuestionAtIndex(lastAddedQuestion,questionsStack.length)
			  break;
            case 'simpleText':
				//drawSimpleTextQuestion(lastAddedQuestion,questionsStack.length);
			    drawSimpleTextAtIndex(lastAddedQuestion,questionsStack.length)
			    break;
            case 'numText':
				//drawNumericTextQuestion(lastAddedQuestion,questionsStack.length);
			    drawNumericTextAtIndex(lastAddedQuestion,questionsStack.length)
			    break;
            case 'agreement5':
			  //alert('Agreement');
			  //drawAgreementScales5Question(lastAddedQuestion,questionsStack.length);
			  drawAgreementQuestion5AtIndex(lastAddedQuestion,questionsStack.length)
			  break;
			default:
			  alert('Invalid type');
    }
  
}

/*This function renders the multioption multiselect question
*/
function drawMultiOptMultiSelQuestion(questionObject,questionNumber)
{
	  //alert('drawMultiOptMultiSelQuestion')
	  var surveyTable = document.getElementById("surveyTable");//Survey table is where the new questions are appended
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')//Create the question div which will hold all about the question
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')//A hidden var holding the question no. might come handy
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table') //A table inside the div to display questiontext n answeropts
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)//question text
	  oCell.appendChild(oText);
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      
	  for(var i=0;i<answerOptions.length;i++)//draw ans options
	  {
		  oRow = oTable.insertRow(lastRow+i);
         //alert(oRow)
		 oCell = oRow.insertCell(0);
		 oCell.className = 'text-blue-01'
		 var oDiv = document.createElement('DIV')
         var oCheckBox = document.createElement('INPUT') 
         oCheckBox.type='checkbox'
         var oDivText = document.createTextNode(' '+answerOptions[i])
	     oDiv.appendChild(oCheckBox)
		 oDiv.appendChild(oDivText)
	     oCell.appendChild(oDiv)	 
	  }
	  
     oRow = oTable.insertRow(lastRow+i)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event. Edit a question
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";//Delete a question
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv)
}

/*This function is called to edit a question 
*/
function editQuestions(qNumber)
{
var qObject = questionsStack[qNumber-1];//The questionObj to be edited
//alert('edit'+qNumber+'qtext'+qObject.questionText)
var answerOptions = qObject.answerOptions
oDiv = document.getElementById('question'+qNumber)//The div where the question to be edited is present.
oTable = document.getElementById('questionTable'+qNumber)
oDiv.removeChild(oTable)//Remove the elements of the questionDiv which are displayed currently
oTable = document.createElement('table')//A new edit table appended on to div 
oTable.width='100%'
oTable.name='editQuestion'+qNumber
oTable.id='editQuestion'+qNumber
var oRow = oTable.insertRow(0)
var oCell = oRow.insertCell(0)
var odivTitle = document.createElement("DIV");//Create a div element for the title
odivTitle.className ='colTitle';
var odivTitletext = document.createTextNode(" Edit Question no."+qNumber);//Adding the text element.
odivTitle.appendChild(odivTitletext);
oCell.appendChild(odivTitle)
oRow = oTable.insertRow(1)
oCell = oRow.insertCell(0)
oCell.className='text-blue-01'
var otextArea = document.createElement('textarea');//Create a textArea element
otextArea.cols = '80'
otextArea.rows = '6';
var questionTypeText=qObject.questionType
if(questionTypeText=='agreement'||questionTypeText=='agreement5')
{
otextArea.cols = '80'
otextArea.rows = '2';

}
otextArea.name = 'questionTextArea';
otextArea.id = 'questionTextArea';
otextArea.className="text-blue-01";
otextArea.value=qObject.questionText
oCell.appendChild(otextArea)
var oCheckBox = document.createElement('INPUT')
oCheckBox.type='checkbox'
oCheckBox.id='mandatoryFlag'
oCheckBox.name='mandatoryFlag'
oCell.appendChild(oCheckBox)
if(qObject.mandatory=='true')
{
  oCheckBox.checked=true
  //oCheckBox.setAttribute("checked",true);  
}
oCell.appendChild(document.createTextNode('mandatory'))
var lastRow
switch (questionTypeText)
      {
		case 'multioptmultisel':
			   lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'optionTable';
			   oNewTable.name = 'optionTable';
			   var oNewRow
			   var oNewCell
				var oNewlastRow = 0   
			   for(var i=0;i<answerOptions.length;i++)
		        {
			      oNewRow = oNewTable.insertRow(oNewlastRow);
			      oNewCell =  oNewRow.insertCell(0);
				  var oNewTextEl = document.createElement('input');
				   oNewTextEl.type='text';
				   oNewTextEl.size=30;
                   oNewTextEl.value=answerOptions[i]
				   oNewTextEl.name='optionTextEl';
				   oNewTextEl.id = 'optionTextEl';
				   oNewTextEl.className='text-blue-01';
				   oNewCell.appendChild(oNewTextEl);
				   var obutton = document.createElement("BUTTON");//Creat the button element
                   obutton.name="deleteQuestion";
				   obutton.id="deleteQuestion"+i
                   obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
                   obutton.onclick = new Function("deleteOption('"+oNewRow.rowIndex+"')");//Add the onclick event.
                   oNewCell.appendChild(obutton)
				   oNewlastRow = oNewTable.rows.length
				 }
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addOption";
			   obutton.className="addOptionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addAnswerOptions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("saveEditMuSeMuOpQuestion('"+qNumber+"')")//Add the onclick event.
               cright.appendChild(obutton);
               break;
		 case 'multioptsinglesel':
			  //alert('MultioptionSingleselect');
		      lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'optionTable';
			   oNewTable.name = 'optionTable';
			   var oNewRow
			   var oNewCell
				var oNewlastRow = 0   
			   for(var i=0;i<answerOptions.length;i++)
		        {
			      oNewRow = oNewTable.insertRow(oNewlastRow);
			      oNewCell =  oNewRow.insertCell(0);
				  var oNewTextEl = document.createElement('input');
				   oNewTextEl.type='text';
				   oNewTextEl.size=30;
                   oNewTextEl.value=answerOptions[i]
				   oNewTextEl.name='optionTextEl';
				   oNewTextEl.id = 'optionTextEl';
				   oNewTextEl.className='text-blue-01';
				   oNewCell.appendChild(oNewTextEl);
				   var obutton = document.createElement("BUTTON");//Creat the button element
                   obutton.name="deleteQuestion";
				   obutton.id="deleteQuestion"+i
                   obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
                   obutton.onclick = new Function("deleteOption('"+oNewRow.rowIndex+"')");//Add the onclick event.
                   oNewCell.appendChild(obutton)
				   oNewlastRow = oNewTable.rows.length
				 }
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addOption";
			   obutton.className="addOptionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addAnswerOptions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("saveEditMuSeSiOpQuestion('"+qNumber+"')")//Add the onclick event.
               cright.appendChild(obutton);

			  break;
		 case 'agreement':
			   //alert('Agreement');
               lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'subQuestionTable';
			   oNewTable.name = 'subQuestionTable';
			   var oNewRow
			   var oNewCell
				var oNewlastRow = 0   
			   for(var i=0;i<answerOptions.length;i++)
		        {
			     oNewRow = oNewTable.insertRow(oNewlastRow);
			     oNewCell =  oNewRow.insertCell(0);
				 oNewTextEl = document.createElement('textarea');//Create a textArea element
			     oNewTextEl.cols = '60'
			     oNewTextEl.rows = '3';
                 oNewTextEl.name='subQuestionTextEl';
			     oNewTextEl.id = 'subQuestionTextEl';
			     oNewTextEl.className='text-blue-01';
			     oNewTextEl.value=answerOptions[i]
				 oNewCell.appendChild(oNewTextEl);
				 var obutton = document.createElement("BUTTON");//Creat the button element
                 obutton.name="deleteQuestion";
				 obutton.id="deleteQuestion"+i
                 obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
                 obutton.onclick = new Function("deleteSubQuestion('"+oNewRow.rowIndex+"')");//Add the onclick event.
                 oNewCell.appendChild(obutton)
				 oNewlastRow = oNewTable.rows.length
				 }
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addAgreementSubQuestion";
			   obutton.className="agreementAddQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addSubQuestions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveAgreementQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("saveEditAgreementQuestion('"+qNumber+"')");//Add the onclick event.
               cright.appendChild(obutton);

			  break;
          case 'simpleText':
			    lastRow = oTable.rows.length;
			    oRow = oTable.insertRow(lastRow);
			    cleft = oRow.insertCell(0);
			    var obutton = document.createElement("BUTTON");//Creat the button element
                obutton.name="saveSimpleTextQuestion";
                obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
                obutton.onclick = new Function("saveEditSimpleTextQuestion('"+qNumber+"')");//Add the onclick event.
		        cleft.appendChild(obutton);
		       break;
          case 'numText':
			    lastRow = oTable.rows.length;
			    oRow = oTable.insertRow(lastRow);
			    cleft = oRow.insertCell(0);
			    var obutton = document.createElement("BUTTON");//Creat the button element
                obutton.name="saveSimpleTextQuestion";
                obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
                obutton.onclick = new Function("saveEditNumericTextQuestion('"+qNumber+"')");//Add the onclick event.
		        cleft.appendChild(obutton);
		       break;
         case 'agreement5':
			   //alert('Agreement');
               lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'subQuestionTable';
			   oNewTable.name = 'subQuestionTable';
			   var oNewRow
			   var oNewCell
				var oNewlastRow = 0   
			   for(var i=0;i<answerOptions.length;i++)
		        {
			     oNewRow = oNewTable.insertRow(oNewlastRow);
			     oNewCell =  oNewRow.insertCell(0);
				 oNewTextEl = document.createElement('textarea');//Create a textArea element
			     oNewTextEl.cols = '60'
			     oNewTextEl.rows = '3';
                 oNewTextEl.name='subQuestionTextEl';
			     oNewTextEl.id = 'subQuestionTextEl';
			     oNewTextEl.className='text-blue-01';
			     oNewTextEl.value=answerOptions[i]
				 oNewCell.appendChild(oNewTextEl);
				 var obutton = document.createElement("BUTTON");//Creat the button element
                 obutton.name="deleteQuestion";
				 obutton.id="deleteQuestion"+i
                 obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
                 obutton.onclick = new Function("deleteSubQuestion('"+oNewRow.rowIndex+"')");//Add the onclick event.
                 oNewCell.appendChild(obutton)
				 oNewlastRow = oNewTable.rows.length
				 }
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addAgreementSubQuestion";
			   obutton.className="agreementAddQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addSubQuestions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveAgreementQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("saveEditAgreement5Question('"+qNumber+"')");//Add the onclick event.
               cright.appendChild(obutton);

			  break;
		 default:
			  alert('Invalid  Question  type');
			}
oDiv.appendChild(oTable)
//removeDivElements(oDiv)
}



/*This function Saves the edited multio sel multi opt question
*/
function saveEditMuSeMuOpQuestion(qNumber)
{
   //alert('here in saveEdit')
  var questionTextObj = document.getElementById('questionTextArea');
  var optionsObjects = document.getElementsByName('optionTextEl');
  var optionTable = document.getElementById('optionTable')
  var mandatoryFlag = document.getElementById('mandatoryFlag');
 var answerOptions = new Array();
  for(var i=0;i<optionsObjects.length;i++) //Get the new ans. options
	{
	  answerOptions.push(optionsObjects[i].value)
	}
questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
questionsStack[qNumber-1].answerOptions = answerOptions;//replace questionOptions
questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
//alert('Objects edited')
//alert(questionsStack[qNumber-1].questionText)
removeEditQuestionDiv(qNumber)//Remove the current Edit question div
drawMultiOptQuestionAtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question
}

/*This function Saves the edited Agreement question
*/
function saveEditAgreementQuestion(qNumber)
{
 //alert('here in saveEdit Agree')
  var questionTextObj = document.getElementById('questionTextArea');
  var subQuestionObjects = document.getElementsByName('subQuestionTextEl');
  var answerOptions = new Array();
  for(var i=0;i<subQuestionObjects.length;i++)
	{
	  answerOptions.push(subQuestionObjects[i].value);
	}
questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
questionsStack[qNumber-1].answerOptions = answerOptions;//replace questionOptions
 var mandatoryFlag = document.getElementById('mandatoryFlag');
 questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
//alert('Objects edited')
//alert(questionsStack[qNumber-1].questionText)
removeEditQuestionDiv(qNumber)//Remove the current Edit question div
drawAgreementQuestionAtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question

}

/*This function removes the edit div which was displayed for editing the question
*/

function removeEditQuestionDiv(qNumber)
{
oDiv = document.getElementById('question'+qNumber)//The div where the question to be edited is present.
oTable = document.getElementById('editQuestion'+qNumber)
oDiv.removeChild(oTable)//remove the editQuestion div
}

/*This function removes the questionDiv for a questionObj -Used while redrawing
*/
function removeQuestionDiv(qNumber)
{
oDiv = document.getElementById('question'+qNumber)//The div where the question to be edited is present.
oTable = document.getElementById('questionTable'+qNumber)
oDiv.removeChild(oTable)
oDiv.parentNode.removeChild(oDiv)

}
/*This function draws a multiOptimultiSelQuestion at a given index
*/
function drawMultiOptQuestionAtIndex(questionObject,qNumber)
{
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{

	  var oTable = document.createElement('Table')//Proceed to add the question to the questionDIv
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
		{
	      oCell.appendChild(document.createTextNode('*')) 
		}
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  oRow = oTable.insertRow(lastRow+i);
         //alert(oRow)
		 oCell = oRow.insertCell(0);
		 oCell.className = 'text-blue-01'
		 var oDiv = document.createElement('DIV')
         //document.createElement('INPUT')
		var oCheckBox = document.createElement("<input type='checkbox' name='"+(qNumber)+"mums' id='"+(qNumber)+"mums' value='"+answerOptions[i]+"'>")	 
         //oCheckBox.type='checkbox'
		 //oCheckBox.id=(qNumber)+'mums'
         //oCheckBox.name=(qNumber)+'mums'
         //oCheckBox.value=answerOptions[i]
         var oDivText = document.createTextNode(' '+answerOptions[i])
	     oDiv.appendChild(oCheckBox)
		 oDiv.appendChild(oDivText)
	     oCell.appendChild(oDiv)	 
	  }
	if(currSurvey.state=='Saved')
   {
	 
	  
     oRow = oTable.insertRow(lastRow+i)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
   }
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)

	}
  
  }

/*This function draws a Agreement Question at a given index
*/

function drawAgreementQuestionAtIndex(questionObject,qNumber)
{
  //alert('gonna draw'+qNumber)
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
	  {
	   oCell.appendChild(document.createTextNode('*')) 
	  }
	  oRow = oTable.insertRow(1)
      var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      oRow = oTable.insertRow(lastRow);
      oCell = oRow.insertCell(0);
	  oCell.className = 'text-blue-01'
	  var osubQTable = document.createElement('Table')
      osubQTable.id ='subQuestionsTable'+qNumber
	  osubQTable.name='subQuestionsTable'+qNumber
      osubQTable.width='100%'
      osubQTable.classname='text-blue-01'
	  var osubQTableRow = osubQTable.insertRow(0)
	  osubQTableRow.className='text-blue-01'
	  var osubQTableCell = osubQTableRow.insertCell(0)
	  osubQTableCell.width='60%'
	  var osubQText = document.createTextNode(' ')
	  osubQTableCell.appendChild(osubQText)	  
	  osubQTableCell = osubQTableRow.insertCell(1)
      osubQTableCell.width='7%'
      osubQTableCell.className='text-blue-01'
      var divEl = document.createElement('div')
      divEl.className='text-blue-01'
	  var el1 = document.createTextNode('Strongly Agree')
	  divEl.appendChild(el1)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(2)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el2 = document.createTextNode('Agree')
	  divEl.appendChild(el2)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(3)
      osubQTableCell.width='7%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el3 = document.createTextNode('Strongly Disagree')
	  divEl.appendChild(el3)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(4)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el4 = document.createTextNode('Disagree')
	  divEl.appendChild(el4)
	  osubQTableCell.appendChild(divEl)
      var lastRow = osubQTable.rows.length
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  osubQTableRow = osubQTable.insertRow(lastRow+i);
          osubQTableCell = osubQTableRow.insertCell(0);
		  osubQTableCell.className = 'text-blue-01'
		  osubQText = document.createTextNode('subQ '+(i+1)+'.'+answerOptions[i])
          osubQTableCell.appendChild(osubQText)
          var el1 = document.createElement("<input type='radio' name='"+(qNumber)+"agQ"+(i+1)+"' id='"+(qNumber)+"agQ"+(i+1)+"' value='Strongly Agree'>")
		  var el2 = document.createElement("<input type='radio' name='"+(qNumber)+"agQ"+(i+1)+"' id='"+(qNumber)+"agQ"+(i+1)+"' value='Agree'>")
		  var el4 = document.createElement("<input type='radio' name='"+(qNumber)+"agQ"+(i+1)+"' id='"+(qNumber)+"agQ"+(i+1)+"' value='Disagree'>")
          var el3 = document.createElement("<input type='radio' name='"+(qNumber)+"agQ"+(i+1)+"' id='"+(qNumber)+"agQ"+(i+1)+"' value='Strongly Disagree'>")
		  osubQTableCell = osubQTableRow.insertCell(1)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el1)
		  osubQTableCell = osubQTableRow.insertCell(2)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el2)
		  osubQTableCell = osubQTableRow.insertCell(3)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el3)
		  osubQTableCell = osubQTableRow.insertCell(4)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el4) 
	  }
	 oCell.appendChild(osubQTable) 
     if(currSurvey.state=='Saved')
   {
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
   } 
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)
	}  
}

/*This function deletes a subQuestion
*/
function deleteSubQuestion(i)
{
   var subQuestionTableObj = document.getElementById('subQuestionTable') 
   var rowObj = subQuestionTableObj.rows[i]
   for(var i=0;i<rowObj.cells.length;i++)
   {
      rowObj.deleteCell(i)//Delete all cells of the rowObj
   } 	   
  
 }

/*Delete an Option in the addAnswerOptions section
*/
function deleteOption(i)
{
   //var optionObj = document.getElementById('optionTextEl'+i)
   //var  buttonObj = document.getElementById("deleteQuestion"+i)
   var optionTableObj = document.getElementById('optionTable') 
   var rowObj = optionTableObj.rows[i]
   for(var i=0;i<rowObj.cells.length;i++)
   {
      rowObj.deleteCell(i)//Delete all cells of the rowObj
   } 	   
   //optionObj.parentNode.removeChild(optionObj)
   //buttonObj.parentNode.removeChild(buttonObj)
   //var optionTable = document.getElementById('optionTable') optionTable.removeChild(optionObj)
 }

function deleteAllQuestions()
{
//alert('funct call')
for (var j=1;j<=questionsStack.length;j++ )//Remove all the question divs beneath to redraw
{
  removeQuestionDiv(j)
}

questionsStack.splice(0,questionsStack.length)
//alert('objs deleted')
}

/*This function is called when a question is to be deleted
*/
function deleteQuestions(qNumber)
{
//alert('del'+qNumber)
//alert('before del'+questionsStack.length)
for (var j=qNumber;j<=questionsStack.length;j++ )//Remove all the question divs beneath to redraw
{
  removeQuestionDiv(j)
}
questionsStack.splice(qNumber-1,1)//Remove the questionObj from array
//alert('after del'+questionsStack.length)
if(questionsStack.length>0)
 {
   for(var i=(qNumber-1);i<questionsStack.length;i++)//Redraw only the questionDivs beneath the deleted Question
	 {
		switch (questionsStack[i].questionType)
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
}

/**This function is called once a questionType is selected. It removes the elements in the "Select question type" div 
Better name needed
*/

function addEnterAndRemoveQuestionDiv()//Make it QuestionTypeSelected
{
  var divObj = document.getElementById("questionSelectorDiv"); //get the div object
  var questionType = document.getElementById("surveyType"); 
  var questionTypeText = questionType.options[questionType.selectedIndex].value;//get the selected element
  removeQuestionSelector(document);//Remove the question selector div
  addEnterQuestionDiv(document,questionTypeText); //Add the Enter question div
}

/*This function removes the Question Selector Div
*/
function removeQuestionSelector(doc)
{
  var divObj = document.getElementById("questionSelectorDiv"); //get the div object
  if (divObj != null) {
    if (divObj.childNodes) {
      for (var i = 0; i < divObj.childNodes.length; i++) {
        var childNode = divObj.childNodes[i];
        divObj.removeChild(childNode);//remove all the elements.
        
	  }
    }
  }
}

/** This function displays the elements for the questionTypeSelector. Mostly called after save.
*/

function drawQuestionSelectorDiv()
{
var divObj = document.getElementById("questionSelectorDiv");//Get the div object
var oTable = document.createElement("TABLE");//Create a new table
oTable.width = "100%";
var oRow = oTable.insertRow(0);//Insert a new row.
var cleft = oRow.insertCell(0);//Insert a cell into the row.
var odiv = document.createElement("DIV");//Create a div element for the title
odiv.className ='colTitle';
var otext = document.createTextNode(" Add New Question ");//Adding the text element.
odiv.appendChild(otext);
cleft.appendChild(odiv);//Append the div to the cell
var lastRow = oTable.rows.length;//Total rows of the table
oRow = oTable.insertRow(lastRow);//Append the new row at the end of the table
cleft = oRow.insertCell(0);
cleft.className ="text-blue-01";
cleft.width = "90%";
otext = document.createTextNode("  Type  ");
var oselect = document.createElement("SELECT"); //Create the select element
oselect.className = "field-blue-12-220x20";
oselect.id = "surveyType";
oselect.name = "surveyType";
var oOption = document.createElement("OPTION");//Create the option element
oOption.text = 'Likert4Scale';
oOption.value = 'agreement'
oselect.add(oOption);//Add option to the select element
oOption = document.createElement("OPTION");
oOption.text = 'Likert5Scale';
oOption.value = 'agreement5'
oselect.add(oOption);
oOption = document.createElement("OPTION");
oOption.text = 'MultipleChoiceMultiSelect';
oOption.value ='multioptmultisel'
oselect.add(oOption);
oOption = document.createElement("OPTION");
oOption.text = 'MultipleChoiceSingleSelect';
oOption.value = 'multioptsinglesel'
oselect.add(oOption);
oOption = document.createElement("OPTION");
oOption.text = 'NumericText';
oOption.value = 'numText'
oselect.add(oOption);
oOption = document.createElement("OPTION");
oOption.text = 'SimpleText';
oOption.value = 'simpleText'
oselect.add(oOption);
cleft.appendChild(otext);
cleft.appendChild(oselect);
lastRow = oTable.rows.length;
oRow = oTable.insertRow(lastRow);
cleft = oRow.insertCell(0);
cleft.className ="text-blue-01";
cleft.width = "90%";
var obutton = document.createElement("BUTTON");//Creat the button element
obutton.name="addQuestion";
obutton.className="addQuestionButton"//New style added in css since style cannot be used against the button DOM element
obutton.onclick = addEnterAndRemoveQuestionDiv;//Add the onclick event.
cleft.appendChild(obutton);
divObj.appendChild(oTable);

}


/** This function adds the answer options into the optionTable for entering multiple options.
*/
function addAnswerOptions()
{
var tableObj = document.getElementById('optionTable');
var lastRow = tableObj.rows.length;
if(lastRow>0)
{
  var oNewRow = tableObj.insertRow(lastRow-1);
  var oNewCell = oNewRow.insertCell(0);
  var oNewTextEl = document.createElement('input');
  oNewTextEl.type='text';
  oNewTextEl.size=30;
  oNewTextEl.name='optionTextEl';
  oNewTextEl.id = 'optionTextEl';
  oNewTextEl.className='text-blue-01';
  oNewCell.appendChild(oNewTextEl);
  var obutton = document.createElement("BUTTON");//Creat the button element
	obutton.name="deleteQuestion";
	obutton.id="deleteQuestion"
	obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
	obutton.onclick = new Function("deleteOption('"+oNewRow.rowIndex+"')");//Add the onclick event.
	oNewCell.appendChild(obutton)
 }

}

/**This function saves the MultipleOptionMultiSelectQuestion
*/
function saveMuSeMuOpQuestion()
{
//alert(document.getElementById('questionTextArea'))
var questionTextObj = document.getElementById('questionTextArea');
var optionsObjects = document.getElementsByName('optionTextEl');
var answerOptions = new Array();
if(optionsObjects.length>0)
{
for(var i=0;i<optionsObjects.length;i++)
	{
	  answerOptions.push(optionsObjects[i].value);
	}
var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'multioptmultisel',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}
else
 {
   alert('Please enter Answer options')
 }
}



/** This function creates a new div element to accept the question from the user.
*/
function addEnterQuestionDiv(doc,questionTypeText)
{
var divObj = doc.getElementById("questionSelectorDiv");//Get the div object
var oTable = document.createElement("TABLE");//Create a new table
oTable.width = "100%";
var oRow = oTable.insertRow(0);//Insert a new row.
var cleft = oRow.insertCell(0);//Insert a cell into the row.
var odiv = document.createElement("DIV");//Create a div element for the title
odiv.className ='colTitle';
var otext = document.createTextNode(" Enter the Question ");//Adding the text element.
odiv.appendChild(otext);
cleft.appendChild(odiv);//Append the div to the cell
var lastRow = oTable.rows.length;//Total rows of the table
oRow = oTable.insertRow(lastRow);//Append the new row at the end of the table
cleft = oRow.insertCell(0);
cleft.className ="text-blue-01";
cleft.width = "90%";
var otextArea = document.createElement('textarea');//Create a textArea element
otextArea.cols = '80'
otextArea.rows = '6';
if(questionTypeText=='agreement'||questionTypeText=='agreement5')
{
 otextArea.value='Do you agree with the following?'
 otextArea.cols = '80'
 otextArea.rows = '2';
  
}
otextArea.name = 'questionTextArea';
otextArea.id = 'questionTextArea';
otextArea.className="text-blue-01";
cleft.appendChild(otextArea);//Append the textArea to the cell.
var oCheckBox = document.createElement('INPUT') 
oCheckBox.type='checkbox'
oCheckBox.id = 'mandatoryFlag'
oCheckBox.name = 'mandatoryFlag'
cleft.appendChild(oCheckBox)
cleft.appendChild(document.createTextNode('Mandatory'))
 switch (questionTypeText)
      {
		case 'multioptmultisel':
			   lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'optionTable';
			   oNewTable.name = 'optionTable';
			   var oNewRow = oNewTable.insertRow(0);
			   var oNewCell = oNewRow.insertCell(0);
               var oNewTextEl = document.createElement('input');
			   oNewTextEl.type='text';
			   oNewTextEl.size=30;
			   oNewTextEl.name='optionTextEl';
			   oNewTextEl.id = 'optionTextEl';
			   oNewTextEl.className='text-blue-01';
			   oNewCell.appendChild(oNewTextEl);
			   var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="deleteQuestion";
			   obutton.id="deleteQuestion"
               obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("deleteOption('"+oNewRow.rowIndex+"')");//Add the onclick event.
               oNewCell.appendChild(obutton)
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addOption";
			   obutton.className="addOptionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addAnswerOptions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveMuSeMuOpQuestion;//Add the onclick event.
               cright.appendChild(obutton);
               break;
		 case 'multioptsinglesel':
			  //alert('MultioptionSingleselect');
			  lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'optionTable';
			   oNewTable.name = 'optionTable';
			   var oNewRow = oNewTable.insertRow(0);
			   var oNewCell = oNewRow.insertCell(0);
               var oNewTextEl = document.createElement('input');
			   oNewTextEl.type='text';
			   oNewTextEl.size=30;
			   oNewTextEl.name='optionTextEl';
			   oNewTextEl.id = 'optionTextEl';
			   oNewTextEl.className='text-blue-01';
			   oNewCell.appendChild(oNewTextEl);
			   var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="deleteQuestion";
			   obutton.id="deleteQuestion"
               obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("deleteOption('"+oNewRow.rowIndex+"')");//Add the onclick event.
               oNewCell.appendChild(obutton)
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addOption";
			   obutton.className="addOptionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addAnswerOptions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveMuSeSiOpQuestion;//Add the onclick event.
               cright.appendChild(obutton);
			  break;
		 case 'agreement':
			   //alert('Agreement');
		       lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'subQuestionTable';
			   oNewTable.name = 'subQuestionTable';
			   var oNewRow = oNewTable.insertRow(0);
			   var oNewCell = oNewRow.insertCell(0);
			   var subQTitle = document.createTextNode(' Please enter the Sub Questions ')
			   oNewCell.className='text-blue-01'
			   oNewCell.appendChild(subQTitle)
			   lastRow = oNewTable.rows.length;
			   oNewRow = oNewTable.insertRow(lastRow);
			   oNewCell = oNewRow.insertCell(0);
               oNewTextEl = document.createElement('textarea');//Create a textArea element
			   oNewTextEl.cols = '60'
			   oNewTextEl.rows = '3';
               oNewTextEl.name='subQuestionTextEl';
			   oNewTextEl.id = 'subQuestionTextEl';
			   oNewTextEl.className='text-blue-01';
			   oNewCell.appendChild(oNewTextEl);
			   var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="deleteQuestion";
			   obutton.id="deleteQuestion"
               obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("deleteSubQuestion('"+oNewRow.rowIndex+"')");//Add the onclick event.
               oNewCell.appendChild(obutton)
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addAgreementSubQuestion";
			   obutton.className="agreementAddQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addSubQuestions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveAgreementQuestion;//Add the onclick event.
               cright.appendChild(obutton);
			   break;
         case 'agreement5':
			   lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   var oNewTable = document.createElement("TABLE");//A new table since we might add more rows to the option
			   oNewTable.id= 'subQuestionTable';
			   oNewTable.name = 'subQuestionTable';
			   var oNewRow = oNewTable.insertRow(0);
			   var oNewCell = oNewRow.insertCell(0);
			   var subQTitle = document.createTextNode(' Please enter the Sub Questions ')
			   oNewCell.className='text-blue-01'
			   oNewCell.appendChild(subQTitle)
			   lastRow = oNewTable.rows.length;
			   oNewRow = oNewTable.insertRow(lastRow);
			   oNewCell = oNewRow.insertCell(0);
               oNewTextEl = document.createElement('textarea');//Create a textArea element
			   oNewTextEl.cols = '60'
			   oNewTextEl.rows = '3';
               oNewTextEl.name='subQuestionTextEl';
			   oNewTextEl.id = 'subQuestionTextEl';
			   oNewTextEl.className='text-blue-01';
			   oNewCell.appendChild(oNewTextEl);
			   var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="deleteQuestion";
			   obutton.id="deleteQuestion"
               obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = new Function("deleteSubQuestion('"+oNewRow.rowIndex+"')");//Add the onclick event.
               oNewCell.appendChild(obutton)
			   cleft.appendChild(oNewTable);
               lastRow = oNewTable.rows.length;
			   oRow = oNewTable.insertRow(lastRow);
               cleft = oRow.insertCell(0);
			   cright = oRow.insertCell(1);
               var obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="addAgreementSubQuestion";
			   obutton.className="agreementAddQuestion"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = addSubQuestions;//Add the onclick event.
               cleft.appendChild(obutton);
               obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveAgreement5Question;//Add the onclick event.
               cright.appendChild(obutton);
			   break;
         case 'simpleText': 
		       //alert('simpleText') 
			   lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveSimpleTextQuestion;//Add the onclick event.
               cleft.appendChild(obutton);
		       break;
         case 'numText':
			   //alert('numText')
			   lastRow = oTable.rows.length;
			   oRow = oTable.insertRow(lastRow);
			   cleft = oRow.insertCell(0);
			   obutton = document.createElement("BUTTON");//Creat the button element
               obutton.name="saveQuestion";
               obutton.className="saveQuestionButton"//New style added in css since style cannot be used against the button DOM element
               obutton.onclick = saveNumericTextQuestion;//Add the onclick event.
               cleft.appendChild(obutton);
		       break;
		 default:
			  alert('Invalid  Question  type');
			}

divObj.appendChild(oTable);

}


function addSubQuestions()
{

var tableObj = document.getElementById('subQuestionTable');
var lastRow = tableObj.rows.length;
if(lastRow>0)
{
  var oNewRow = tableObj.insertRow(lastRow-1);
  var oNewCell = oNewRow.insertCell(0);
  var otextArea = document.createElement('textarea');//Create a textArea element
  otextArea.cols = '60'
  otextArea.rows = '3';
  otextArea.name='subQuestionTextEl';
  otextArea.id = 'subQuestionTextEl';
  otextArea.className='text-blue-01';
  oNewCell.appendChild(otextArea);
  var obutton = document.createElement("BUTTON");//Creat the button element
	obutton.name="deleteQuestion";
	obutton.id="deleteQuestion"
	obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
	obutton.onclick = new Function("deleteSubQuestion('"+oNewRow.rowIndex+"')");//Add the onclick event.
	oNewCell.appendChild(obutton)

 }


}



/*This function saves an agreement Type question
*/
function saveAgreementQuestion()
{
var questionTextObj = document.getElementById('questionTextArea');
var subQuestionObjects = document.getElementsByName('subQuestionTextEl');
var answerOptions = new Array();
if(subQuestionObjects.length>0)
{
		for(var i=0;i<subQuestionObjects.length;i++)
			{
			  answerOptions.push(subQuestionObjects[i].value);
			}
var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'agreement',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}
else
{
  alert('please enter Sub Questions')
}

}


/*This function draws the agreement scales question
*/
function drawAgreementScalesQuestion(questionObject,questionNumber)
{

//alert('drawAgreementScalesQuestion')
	  var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  oCell.appendChild(oText);
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      oRow = oTable.insertRow(lastRow);
      oCell = oRow.insertCell(0);
	  oCell.className = 'text-blue-01'
	  var osubQTable = document.createElement('Table')
      osubQTable.id ='subQuestionsTable'
	  osubQTable.name='subQuestionsTable'
      osubQTable.width='100%'
      osubQTable.classname='text-blue-01'
	  var osubQTableRow = osubQTable.insertRow(0)
	  osubQTableRow.className='text-blue-01'
	  var osubQTableCell = osubQTableRow.insertCell(0)
	  osubQTableCell.width='60%'
	  var osubQText = document.createTextNode(' ')
	  osubQTableCell.appendChild(osubQText)	  
	  osubQTableCell = osubQTableRow.insertCell(1)
      osubQTableCell.width='7%'
      osubQTableCell.className='text-blue-01'
      var divEl = document.createElement('div')
      divEl.className='text-blue-01'
	  var el1 = document.createTextNode('Strongly Agree')
	  divEl.appendChild(el1)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(2)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el2 = document.createTextNode('Agree')
	  divEl.appendChild(el2)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(3)
      osubQTableCell.width='7%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el3 = document.createTextNode('Strongly Disagree')
	  divEl.appendChild(el3)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(4)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el4 = document.createTextNode('Disagree')
	  divEl.appendChild(el4)
	  osubQTableCell.appendChild(divEl)
      var lastRow = osubQTable.rows.length
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  osubQTableRow = osubQTable.insertRow(lastRow+i);
          osubQTableCell = osubQTableRow.insertCell(0);
		  osubQTableCell.className = 'text-blue-01'
		  osubQText = document.createTextNode('subQ '+(i+1)+'.'+answerOptions[i])
          osubQTableCell.appendChild(osubQText)
          var el1 = document.createElement('INPUT')
		  var el2 = document.createElement('INPUT')
		  var el3 = document.createElement('INPUT')
		  var el4 = document.createElement('INPUT')
		  el1.type='radio'
		  el2.type='radio'
		  el3.type='radio'
		  el4.type='radio'
		  osubQTableCell = osubQTableRow.insertCell(1)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el1)
		  osubQTableCell = osubQTableRow.insertCell(2)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el2)
		  osubQTableCell = osubQTableRow.insertCell(3)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el3)
		  osubQTableCell = osubQTableRow.insertCell(4)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el4) 
	  }
	 oCell.appendChild(osubQTable) 
     oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv)


}
/*This function saves a simple Text Question
*/
function saveSimpleTextQuestion()
{
//alert('saveSimpleTextQuestion')
var questionTextObj = document.getElementById('questionTextArea');
var answerOptions = new Array();
var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'simpleText',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}
/*This function draws a simpleText Question
*/

function drawSimpleTextQuestion(questionObject,questionNumber)
{
	//alert('drawSimpleText')
	
  	  var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  oCell.appendChild(oText);
      oRow = oTable.insertRow(oTable.rows.length)
      oCell = oRow.insertCell(0);
      oCell.className = 'text-blue-01'
	  var otextArea = document.createElement('textarea');//Create a textArea element
      otextArea.cols = '80'
      otextArea.rows = '2';
	  otextArea.disabled=true;
      oCell.appendChild(otextArea);
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv)     
}

/*This function draws a simpleText Question at a specified index
*/
function drawSimpleTextAtIndex(questionObject,qNumber)
{
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{
	  var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
	  {
	      oCell.appendChild(document.createTextNode('*')) 
	  }
      oRow = oTable.insertRow(oTable.rows.length)
      oCell = oRow.insertCell(0);
      oCell.className = 'text-blue-01'
	  var otextArea = document.createElement('textarea');//Create a textArea element
      otextArea.id= qNumber+'simpleText'
	  otextArea.name = qNumber+'simpleText'
      otextArea.cols = '80'
      otextArea.rows = '2';
	  //otextArea.disabled=true;
      oCell.appendChild(otextArea);
	  if(currSurvey.state=='Saved')
	{
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
    }
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)
	    
	}
}

/*This function saves the edited SimpleText question
*/

function saveEditSimpleTextQuestion(qNumber)
{
  var questionTextObj = document.getElementById('questionTextArea');
  var answerOptions = new Array();
  questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
   var mandatoryFlag = document.getElementById('mandatoryFlag');
  questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
  removeEditQuestionDiv(qNumber)//Remove the current Edit question div
  drawSimpleTextAtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question
}

/*This function saves a Numeric Text question
*/
function saveNumericTextQuestion()
{
//alert('saveNumericTextQuestion')
var questionTextObj = document.getElementById('questionTextArea');
var answerOptions = new Array();
var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'numText',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}

/*This function draws a Numeric text question
*/
function drawNumericTextQuestion(questionObject,questionNumber)
{
//alert('drawSimpleText')
	
  	  var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  oCell.appendChild(oText);
	  oRow = oTable.insertRow(oTable.rows.length)
      oCell = oRow.insertCell(0);
      oCell.className = 'text-blue-01'
	  var otextElem = document.createElement('input');//Create a Input element
      otextElem.type='text';
	  otextElem.disabled=true;
      oCell.appendChild(otextElem);
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv) 
}

/*This function saves a edited Numeric Text Question
*/
function saveEditNumericTextQuestion(qNumber)
{
  var questionTextObj = document.getElementById('questionTextArea');
  var answerOptions = new Array();
  questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
   var mandatoryFlag = document.getElementById('mandatoryFlag');
  questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
  removeEditQuestionDiv(qNumber)//Remove the current Edit question div
  drawNumericTextAtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question
}

/*This function draws a numeric text question at a given index
*/
function drawNumericTextAtIndex(questionObject,qNumber)
{
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{
	  var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
	  {
	      oCell.appendChild(document.createTextNode('*')) 
	  }
      oRow = oTable.insertRow(oTable.rows.length)
      oCell = oRow.insertCell(0);
      oCell.className = 'text-blue-01'
	  var otextArea = document.createElement('input');//Create a textNode
      otextArea.type='text'
	  otextArea.id=qNumber+'numericText'
      otextArea.name=qNumber+'numericText'
	  //otextArea.disabled=true;
      oCell.appendChild(otextArea);
	  if(currSurvey.state=='Saved')
	{
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
    }
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)
	    
	}
}

/* This function removes the save and delete survey buttons and displays the launch survey button
*/

function displayLaunchSurvey()
{
//	alert("diisplayLaunchSurvey called");
  var tableObj = document.getElementById('surveyOpsTable')
 if(tableObj!=null){
  var rowObj = tableObj.rows[0];
  if(rowObj!=null)
 {
   for(var i=0;i<rowObj.cells.length;i++)
	{
       rowObj.deleteCell(i);
    }
  var oCell = rowObj.insertCell(0);

  obutton = document.createElement("BUTTON");//Creat the button element
  obutton.name="createSurvey";
  obutton.value="Create New Survey"
  obutton.onclick = new Function("createNewSurveys()");
  oCell.appendChild(obutton)
	
  }

removeQuestionSelector(document);
  // creating a new row
  var len=0
  
  if(tableObj.rows!=null)
  {
   len= tableObj.rows.length;
   }
  var oRow1= tableObj.insertRow(len);
  var oRow2= tableObj.insertRow(tableObj.rows.length);
  var oCellR1_1=oRow1.insertCell(0);
  var oCellR1_2=oRow1.insertCell(1);
  oCellR1_1.width="28%";
  oCellR1_2.width="28%";
  oCellR1_1.className="text-blue-01-bold";
  var oText = document.createTextNode("Start Date");
	oCellR1_1.appendChild(oText);
	oCellR1_2.className="text-blue-01-bold";
	var oText = document.createTextNode("End Date");
	  oCellR1_2.appendChild(oText);
  var oCell0= oRow2.insertCell(0);
  var oCell1= oRow2.insertCell(1);
  var oCell2= oRow2.insertCell(2);
  var oButton= document.createElement("BUTTON");
 
  oCell0.width="11%";
  var fieldName1="surveyModifyStartDate";
  var fieldName2="surveyModifyEndDate";
  var k=1;
  var sDate='mm/dd/yyyy';
  var eDate='mm/dd/yyyy';
  var dummy= currSurvey.startDate;
  if(dummy==null || dummy==undefined||dummy=='null')
  {
	  sDate='mm/dd/yyyy';
  }
  else
  {
  	sDate=currSurvey.startDate;
  }
  if(currSurvey.endDate==null || currSurvey.endDate==undefined||currSurvey.endDate=='null')
  {
	  eDate='mm/dd/yyyy';
  }
  else
  {
  	eDate=currSurvey.endDate;
  }
  
  oCell0.innerHTML="<input type=\"text\" readonly=\"true\" class=\"field-blue-01-180x20\" name=\""  + fieldName1 + "\" value='"+sDate+" 'id=\"" + fieldName1 + "_" + k + "\"><a href=\"#\" onclick=\"return showCalendar(\'" + fieldName1 + "_" + k + "\', '%m/%d/%Y', '24', true);\"><img src=\"images/buttons/calendar_24.png\" width=\"22\" height=\"22\" border=\"0\" align=\"top\" > </a>";
  oCell1.innerHTML="<input type=\"text\" readonly=\"true\" class=\"field-blue-01-180x20\" name=\""  + fieldName2 + "\" value='"+eDate+"' id=\"" + fieldName2 + "_" + k + "\"><a href=\"#\" onclick=\"return showCalendar(\'" + fieldName2 + "_" + k + "\', '%m/%d/%Y', '24', true);\"><img src=\"images/buttons/calendar_24.png\" width=\"22\" height=\"22\" border=\"0\" align=\"top\" > </a>";
  oButton.name="Save Changes";
  oButton.value="Save Changes";
  oButton.onclick= new Function("launchThisSurvey('false')");
  oCell2.appendChild(oButton);
  }
}


/*This function modifies the state of the current survey
*/
function surveyActiveState(active)
{
currSurvey.active=active;
//alert('new active'+currSurvey.active)
//alert('survey state'+currSurvey.state)
newSaveSurvey();
}


function saveAgreement5Question()
{
var questionTextObj = document.getElementById('questionTextArea');
var subQuestionObjects = document.getElementsByName('subQuestionTextEl');
var answerOptions = new Array();
if(subQuestionObjects.length>0)
{
		for(var i=0;i<subQuestionObjects.length;i++)
			{
			  answerOptions.push(subQuestionObjects[i].value);
			}
var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'agreement5',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}
else
{
  alert('please enter Sub Questions')
}

}



function drawAgreementScales5Question(questionObject,questionNumber)
{

//alert('drawAgreementScalesQuestion')
	  var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  oCell.appendChild(oText);
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      oRow = oTable.insertRow(lastRow);
      oCell = oRow.insertCell(0);
	  oCell.className = 'text-blue-01'
	  var osubQTable = document.createElement('Table')
      osubQTable.id ='subQuestionsTable'
	  osubQTable.name='subQuestionsTable'
      osubQTable.width='100%'
      osubQTable.classname='text-blue-01'
	  var osubQTableRow = osubQTable.insertRow(0)
	  osubQTableRow.className='text-blue-01'
	  var osubQTableCell = osubQTableRow.insertCell(0)
	  osubQTableCell.width='60%'
	  var osubQText = document.createTextNode(' ')
	  osubQTableCell.appendChild(osubQText)	  
	  osubQTableCell = osubQTableRow.insertCell(1)
      osubQTableCell.width='7%'
      osubQTableCell.className='text-blue-01'
      var divEl = document.createElement('div')
      divEl.className='text-blue-01'
	  var el1 = document.createTextNode('Strongly Agree')
	  divEl.appendChild(el1)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(2)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el2 = document.createTextNode('Agree')
	  divEl.appendChild(el2)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(3)
      osubQTableCell.width='7%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el0 = document.createTextNode('Neutral')
	  divEl.appendChild(el0)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(4)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el3 = document.createTextNode('Strongly Disagree')
	  divEl.appendChild(el3)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(5)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el4 = document.createTextNode('Disagree')
	  divEl.appendChild(el4)
	  osubQTableCell.appendChild(divEl)
      var lastRow = osubQTable.rows.length
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  osubQTableRow = osubQTable.insertRow(lastRow+i);
          osubQTableCell = osubQTableRow.insertCell(0);
		  osubQTableCell.className = 'text-blue-01'
		  osubQText = document.createTextNode('subQ '+(i+1)+'.'+answerOptions[i])
          osubQTableCell.appendChild(osubQText)
          var el1 = document.createElement('INPUT')
		  var el2 = document.createElement('INPUT')
		  var el3 = document.createElement('INPUT')
		  var el4 = document.createElement('INPUT')
          var el5 = document.createElement('INPUT')
		  el1.type='radio'
		  el2.type='radio'
		  el3.type='radio'
		  el4.type='radio'
          el5.type='radio' 
		  osubQTableCell = osubQTableRow.insertCell(1)
		  osubQTableCell.width='5%'
          osubQTableCell.align='center'
		  osubQTableCell.appendChild(el1)
		  osubQTableCell = osubQTableRow.insertCell(2)
		  osubQTableCell.width='5%'
		  osubQTableCell.align='center'
		  osubQTableCell.appendChild(el2)
		  osubQTableCell = osubQTableRow.insertCell(3)
		  osubQTableCell.width='5%'
		  osubQTableCell.align='center'
		  osubQTableCell.appendChild(el3)
		  osubQTableCell = osubQTableRow.insertCell(4)
		  osubQTableCell.width='5%'
		  osubQTableCell.align='center'
		  osubQTableCell.appendChild(el4)
		  osubQTableCell = osubQTableRow.insertCell(5)
		  osubQTableCell.width='5%'
		  osubQTableCell.align='center'
		  osubQTableCell.appendChild(el5)	  
	  }
	 oCell.appendChild(osubQTable) 
     oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv)


}


function saveEditAgreement5Question(qNumber)
{
 //alert('here in saveEdit Agree')
  var questionTextObj = document.getElementById('questionTextArea');
  var subQuestionObjects = document.getElementsByName('subQuestionTextEl');
  var answerOptions = new Array();
  for(var i=0;i<subQuestionObjects.length;i++)
	{
	  answerOptions.push(subQuestionObjects[i].value);
	}
questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
questionsStack[qNumber-1].answerOptions = answerOptions;//replace questionOptions
 var mandatoryFlag = document.getElementById('mandatoryFlag');
  questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
//alert('Objects edited')
//alert(questionsStack[qNumber-1].questionText)
removeEditQuestionDiv(qNumber)//Remove the current Edit question div
drawAgreementQuestion5AtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question

}



function drawAgreementQuestion5AtIndex(questionObject,qNumber)
{
  //alert('gonna draw'+qNumber)
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{
      var oTable = document.createElement('Table')
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
	  {
	      oCell.appendChild(document.createTextNode('*')) 
	  }
	  oRow = oTable.insertRow(1)
      var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      oRow = oTable.insertRow(lastRow);
      oCell = oRow.insertCell(0);
	  oCell.className = 'text-blue-01'
	  var osubQTable = document.createElement('Table')
      osubQTable.id ='subQuestionsTable'+qNumber
	  osubQTable.name='subQuestionsTable'+qNumber
      osubQTable.width='100%'
      osubQTable.classname='text-blue-01'
	  var osubQTableRow = osubQTable.insertRow(0)
	  osubQTableRow.className='text-blue-01'
	  var osubQTableCell = osubQTableRow.insertCell(0)
	  osubQTableCell.width='60%'
	  var osubQText = document.createTextNode(' ')
	  osubQTableCell.appendChild(osubQText)	  
	  osubQTableCell = osubQTableRow.insertCell(1)
      osubQTableCell.width='7%'
      osubQTableCell.className='text-blue-01'
      var divEl = document.createElement('div')
      divEl.className='text-blue-01'
	  var el1 = document.createTextNode('Strongly Agree')
	  divEl.appendChild(el1)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(2)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el2 = document.createTextNode('Agree')
	  divEl.appendChild(el2)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(3)
      osubQTableCell.width='7%'
	  osubQTableCell.classname='text-blue-01'
      divEl = document.createElement('div')
      var el0 = document.createTextNode('Neutral')
	  divEl.appendChild(el0)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(4)
      osubQTableCell.width='7%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el3 = document.createTextNode('Strongly Disagree')
	  divEl.appendChild(el3)
	  osubQTableCell.appendChild(divEl)
	  osubQTableCell = osubQTableRow.insertCell(5)
      osubQTableCell.width='3%'
	  osubQTableCell.classname='text-blue-01'
	  divEl = document.createElement('div')
      var el4 = document.createTextNode('Disagree')
	  divEl.appendChild(el4)
	  osubQTableCell.appendChild(divEl)
      var lastRow = osubQTable.rows.length
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  osubQTableRow = osubQTable.insertRow(lastRow+i);
          osubQTableCell = osubQTableRow.insertCell(0);
		  osubQTableCell.className = 'text-blue-01'
		  osubQText = document.createTextNode('subQ '+(i+1)+'.'+answerOptions[i])
          osubQTableCell.appendChild(osubQText)
          var el1 = document.createElement("<input type='radio' name='"+(qNumber)+"ag5Q"+(i+1)+"' id='"+(qNumber)+"ag5Q"+(i+1)+"' value='Strongly Agree'>")
		  var el2 = document.createElement("<input type='radio' name='"+(qNumber)+"ag5Q"+(i+1)+"' id='"+(qNumber)+"ag5Q"+(i+1)+"' value='Agree'>")
		  var el3 = document.createElement("<input type='radio' name='"+(qNumber)+"ag5Q"+(i+1)+"' id='"+(qNumber)+"ag5Q"+(i+1)+"' value='Neutral'>")
		  var el4 = document.createElement("<input type='radio' name='"+(qNumber)+"ag5Q"+(i+1)+"' id='"+(qNumber)+"ag5Q"+(i+1)+"' value='Strongly Disagree'>")
          var el5 = document.createElement("<input type='radio' name='"+(qNumber)+"ag5Q"+(i+1)+"' id='"+(qNumber)+"ag5Q"+(i+1)+"' value='Disagree'>")
		  //el1.type='radio'
		  //el2.type='radio'
		  //el3.type='radio'
		  //el4.type='radio'
		  //el5.type='radio'
		  osubQTableCell = osubQTableRow.insertCell(1)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el1)
		  osubQTableCell = osubQTableRow.insertCell(2)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el2)
		  osubQTableCell = osubQTableRow.insertCell(3)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el3)
		  osubQTableCell = osubQTableRow.insertCell(4)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el4)
		  osubQTableCell = osubQTableRow.insertCell(5)
		  osubQTableCell.width='5%'
		  osubQTableCell.appendChild(el5) 	  
	  }
	 oCell.appendChild(osubQTable) 
     if(currSurvey.state=='Saved')
   {
	 oRow = oTable.insertRow(oTable.rows.length)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
   } 
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)
	}  
}


function saveMuSeSiOpQuestion()
{
var questionTextObj = document.getElementById('questionTextArea');
var optionsObjects = document.getElementsByName('optionTextEl');
var answerOptions = new Array();
if(optionsObjects.length>0)
{
for(var i=0;i<optionsObjects.length;i++)
	{
	  answerOptions.push(optionsObjects[i].value);
	}


var mandatoryFlag = document.getElementById('mandatoryFlag')
//alert(mandatoryFlag.checked+'')
addQuestion(questionTextObj.value,'multioptsinglesel',answerOptions,mandatoryFlag.checked+'')
removeQuestionSelector(document);
drawCurrentlyAddedQuestion();
//addQuestionTypeSelectorElements(document);
drawQuestionSelectorDiv();
}
else
 {
   alert('Please enter Answer options')
 }

}


function drawMultiOptSingleSelQuestion(questionObject,questionNumber)
{
	  //alert('drawMultiOptMultiSelQuestion')
	  var surveyTable = document.getElementById("surveyTable");//Survey table is where the new questions are appended
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      var oQuestionDiv = document.createElement('DIV')//Create the question div which will hold all about the question
      oQuestionDiv.name = 'question'+questionNumber
      oQuestionDiv.id = 'question'+questionNumber 
      var oHiddenQNo = document.createElement('INPUT')//A hidden var holding the question no. might come handy
      oHiddenQNo.value=questionNumber
      oHiddenQNo.type='hidden'
	  oQuestionDiv.appendChild(oHiddenQNo)
      var oTable = document.createElement('Table') //A table inside the div to display questiontext n answeropts
      oTable.width='100%'
	  oTable.name='questionTable'+questionNumber
	  oTable.id='questionTable'+questionNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(questionNumber+'.'+questionObject.questionText)//question text
	  oCell.appendChild(oText);
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      
	  for(var i=0;i<answerOptions.length;i++)//draw ans options
	  {
		  oRow = oTable.insertRow(lastRow+i);
         //alert(oRow)
		 oCell = oRow.insertCell(0);
		 oCell.className = 'text-blue-01'
		 var oDiv = document.createElement('DIV')
         var oCheckBox = document.createElement('INPUT') 
         oCheckBox.type='radio'
         var oDivText = document.createTextNode(' '+answerOptions[i])
	     oDiv.appendChild(oCheckBox)
		 oDiv.appendChild(oDivText)
	     oCell.appendChild(oDiv)	 
	  }
	  
     oRow = oTable.insertRow(lastRow+i)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+questionNumber+"')")//Add the onclick event. Edit a question
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";//Delete a question
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+questionNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
     lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     oQuestionDiv.appendChild(oTable)
	 surveyCell.appendChild(oQuestionDiv)
}


function saveEditMuSeSiOpQuestion(qNumber)
{
   //alert('here in saveEdit')
  var questionTextObj = document.getElementById('questionTextArea');
  var optionsObjects = document.getElementsByName('optionTextEl');
  var optionTable = document.getElementById('optionTable')
  /*for(var j=0;j<optionsObjects.r.length;j++)
	{
       alert(optionTable.rows[j].cells[0].optionTextEl.value)
	}*/
  var answerOptions = new Array();
  for(var i=0;i<optionsObjects.length;i++) //Get the new ans. options
	{
	  //alert(optionsObjects[i].value);
	  answerOptions.push(optionsObjects[i].value)
	}
questionsStack[qNumber-1].questionText = questionTextObj.value; //replace the questionText
questionsStack[qNumber-1].answerOptions = answerOptions;//replace questionOptions
 var mandatoryFlag = document.getElementById('mandatoryFlag');
  questionsStack[qNumber-1].mandatory = mandatoryFlag.checked+'';
//alert('Objects edited')
//alert(questionsStack[qNumber-1].questionText)
removeEditQuestionDiv(qNumber)//Remove the current Edit question div
drawMultiOptSingleQuestionAtIndex(questionsStack[qNumber-1],qNumber)//Render the edited question
}


function drawMultiOptSingleQuestionAtIndex(questionObject,qNumber)
{
  var divObj = document.getElementById('question'+qNumber)
  var exists= new Boolean(true);
  //alert(divObj)
  if(divObj==null||divObj==undefined)//Incase we are deleting the qdivs and are re drawing we need to create the deleted div el.
	{
      var surveyTable = document.getElementById("surveyTable");
	  var surveylastRow = surveyTable.rows.length;//Total rows of the table
	  var surveyRow = surveyTable.insertRow(surveylastRow);//Append the new row at the end of the table
	  var surveyCell = surveyRow.insertCell(0)
      divObj = document.createElement('DIV')
      divObj.name = 'question'+qNumber
      divObj.id = 'question'+qNumber 
      var oHiddenQNo = document.createElement('INPUT')
      oHiddenQNo.value=qNumber
      oHiddenQNo.type='hidden'
	  divObj.appendChild(oHiddenQNo)
	  exists = new Boolean(false)
	   if(!exists.valueOf())
	   {
	    surveyCell.appendChild(divObj)
	   }
	  }
  if(divObj!=null||divObj!=undefined)
	{

	  var oTable = document.createElement('Table')//Proceed to add the question to the questionDIv
      oTable.width='100%'
	  oTable.name='questionTable'+qNumber
	  oTable.id='questionTable'+qNumber
	  var oRow = oTable.insertRow(0)
      var oCell = oRow.insertCell(0)
	  oCell.className = 'text-blue-01'
	  var oText = document.createTextNode(qNumber+'.'+questionObject.questionText)
	  oCell.appendChild(oText);
	  if(questionObject.mandatory=='true')
	   {
	      oCell.appendChild(document.createTextNode('*')) 
	   }
	  var answerOptions = questionObject.answerOptions
      var lastRow = oTable.rows.length
      
	  for(var i=0;i<answerOptions.length;i++)
	  {
		  oRow = oTable.insertRow(lastRow+i);
         //alert(oRow)
		 oCell = oRow.insertCell(0);
		 oCell.className = 'text-blue-01'
		 var oDiv = document.createElement('DIV')
         var oCheckBox = document.createElement("<input type='radio' name='"+(qNumber)+"muss' id='"+(qNumber)+"muss' value='"+answerOptions[i]+"'>"); 
         //oCheckBox.type='radio'
         var oDivText = document.createTextNode(' '+answerOptions[i])
	     oDiv.appendChild(oCheckBox)
		 oDiv.appendChild(oDivText)
	     oCell.appendChild(oDiv)	 
	  }
	if(currSurvey.state=='Saved')
   {
	 
	  
     oRow = oTable.insertRow(lastRow+i)
     oCell = oRow.insertCell(0);
     var obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="editQuestion";
     obutton.className="editQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("editQuestions('"+qNumber+"')")//Add the onclick event.
     oCell.appendChild(obutton)
     var spaceText = document.createTextNode("  ")
	 oCell.appendChild(spaceText)
	 obutton = document.createElement("BUTTON");//Creat the button element
     obutton.name="deleteQuestion";
     obutton.className="deleteQuestion"//New style added in css since style cannot be used against the button DOM element
     obutton.onclick = new Function("deleteQuestions('"+qNumber+"')");//Add the onclick event.
     oCell.appendChild(obutton)
   }
	 lastRow = oTable.rows.length
	 oRow = oTable.insertRow(lastRow)
     oCell = oRow.insertCell(0);
	 oCell.className ='back-blue-02-light'
     oDiv = document.createElement('DIV')
	 oDiv.className='back-blue-02-light'
     oCell.appendChild(oDiv)
     divObj.appendChild(oTable)

	}

}
/* The logger function - not used now
*/

function log(message) {
    if (!log.window_ || log.window_.closed) {
        var win = window.open("", null, "width=400,height=200," +
                              "scrollbars=yes,resizable=yes,status=no," +
                              "location=no,menubar=no,toolbar=no");
        if (!win) return;
        var doc = win.document;
        doc.write("<html><head><title>Debug Log</title></head>" +
                  "<body></body></html>");
        doc.close();
        log.window_ = win;
    }
    var logLine = log.window_.document.createElement("div");
    logLine.appendChild(log.window_.document.createTextNode(message));
    log.window_.document.body.appendChild(logLine);
}
