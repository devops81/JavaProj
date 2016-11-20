

<%@ include file="adminHeader.jsp" %>

<html>
  <head>
    <style type='text/css'>
      @import "js/dojo-release-0.9.0/dijit/themes/tundra/tundra.css";
      @import "js/dojo-release-0.9.0/dojo/dojo.css";
    </style>
    <style type="text/css">
      .reset {
        padding: 0;
        margin: 0;
        font: 11px Verdana, Arial, Helvetica, sans-serif; 
        text-transform: none; 
        color: #006699; 
        text-decoration: none;
      }

      .colOuter {
        border: 1px solid #ECEADE;
        padding: 2px;
        margin: 5px;
        overflow: hidden;
      }

      .colTitle {
        background-color: #F3F0DF;
        color: #4C7398;
        padding: 7px;
        font-size: 12px;
        font-weight: bold;
      }

      .colToolbar {
        background-color: #F3F0DF;
        color: #4C7398;
        padding: 7px;
        font-weight: bold;
        margin-top: 1px;
      }

      .listHeading {
        FONT-WEIGHT: bold;
        FONT: 11px Verdana, Arial, Helvetica, sans-serif; 
        TEXT-TRANSFORM: none; 
        COLOR: #006699; 
        TEXT-DECORATION: underline;
      }

      .colContent {
        width:92%;
        padding-top:30px;
        margin-left:25px;
        color:#4c7398;
        font-size: 12px;
        padding: 5px;
      }

      .listContent {
        width:100%;
        padding: 7px;
        color:#4c7398;
        font-size: 12px;
      }

      .toggleImg {
        cursor: pointer;
      }   

      .openq .dijitSplitContainerSizerH {
        background:none;
        border:none;
        width:7px;
      }

      .openq .dijitSplitContainerSizerH .thumb {
        background:url("images/splitContainerSizerDotsH-thumb.png") no-repeat;
        left:1px;
        width:5px;
        height:36px;
      }
    </style>
    <script type="text/javascript">
           
    function toggleAll()
    {
     //alert('toggle all');
    }
    
    function hideDefault(input){
        if(typeof(input.defaultValue)=="undefined")
          input.defaultValue = input.value;
        if(input.value == input.defaultValue)
          input.value = "";
      }

      function showDefault(input){
        if(input.value == "" && typeof(input.defaultValue) != "undefined")
          input.value = input.defaultValue;
     }
    
    var questionsCount= 0;//this variable holds the number of questions currently added.
    var simpleTextCount=0;
    var multipleChoiceSingleQuestions=0;
    var agreementQuestionsCont=0;
    var ratingQuestionsCont=0;
    function createSurveys()//This function creates a survey Title
    {
      if(titleAdded<1)
      {
      var tbl = document.getElementById('rightTable');
      var lastRow = tbl.rows.length;
      var row = tbl.insertRow(lastRow);
      var cleft = row.insertCell(0);
      var labDiv = document.createElement('div');
      labDiv.className = 'colTitle';
      labDiv.innerHTML="<%@ include file='title.jsp'%>";
      cleft.appendChild(labDiv);
     }
      else
     {
      alert('sorry you have already added the title');
      return;
     } 
   }
    
    var titleAdded = 0;
    function saveTitle()//This function saves the title.
    {
        var titleValue = document.getElementById('surveyTitle');
        if(titleValue!=null||!titleValue=="")
        {
        var tbl = document.getElementById('surveyTable');
        var lastRow = tbl.rows.length;
        var row = tbl.insertRow(lastRow);
        var cleft = row.insertCell(0);
        cleft.align='center';
        var labDiv = document.createElement('div');
        labDiv.className = 'colTitle';
        labDiv.appendChild(document.createTextNode(titleValue.value));
        cleft.appendChild(labDiv);
        questionsCount=1;
        removeQuestionDiv();
        titleAdded=1;
        document.addSurvey.surveysTitle.value = titleValue.value;
        insertEndRow();
    }
    else
    {
      alert('Please enter valid text');
    }
  }  
    var questionNumber=0;
    var questionsType = 0; 
    function addQuestions()
    {
      
      if(questionsCount<1)
       {
         alert('Please Create a Survey first');
         return;
       }
      
      var selectElement = document.getElementById('questionSelect');
      if(selectElement.selectedIndex!=-1&&selectElement.options[selectElement.selectedIndex].text!="Please Select")
        {    
              questionNumber=selectElement.selectedIndex;
               var tbl = document.getElementById('rightTable');
               var lastRow = tbl.rows.length;
               var row = null;
               if(tbl.rows.length!=null&&tbl.rows.length>1)
               {
                tbl.deleteRow(lastRow-1);  
                row = tbl.insertRow(lastRow-1);
               }
               else 
               {
                 var row = tbl.insertRow(lastRow);
               }
               var cleft = row.insertCell(0);
               var labDiv = document.createElement('div');
               labDiv.className = 'colTitle';
               //labDiv.innerHTML = "<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr><td align='right'><div  id='multipleChoiceDiv' style='visibility:visible'  class='leftsearchtext'>Question:</div></td><td width='70%'><textarea name='multipleChoiceDiv' cols='' rows='2' class='experttext'></textarea></tr><tr><td width=50%><table width='100%'><tr><td  align='center'><input name='addMultipleQuestion' type='button' value='Add Answer Options' onClick='javascript:addMultipleOptions()'/></td></tr></table></td></tr><tr><td align='center'><input name='saveQuestion' type='button' value='Save' onClick='javascript:saveMultipleQuestion()'/></td><td>&nbsp;</td></tr></table>";
               if(questionNumber==1||questionNumber==7||questionNumber==2)
               {
                questionsType=questionNumber;
               labDiv.innerHTML="<%@ include file='addMultipleOptions.jsp'%>";  
               }
               else if(questionNumber==4||questionNumber==3)
               {
                questionsType=questionNumber;  
               labDiv.innerHTML="<%@ include file='simpleText.jsp'%>";
               }
               else if(questionNumber==5)
               {
               questionsType=questionNumber;
               labDiv.innerHTML="<%@ include file='agreementScales.jsp'%>";
               }
               else if(questionNumber==6)
               {
               questionsType=questionNumber;
               labDiv.innerHTML="<%@ include file='ratingNumQuestion.jsp'%>";
               }
               cleft.appendChild(labDiv);
               document.getElementById('questionId').value=""+questionNumber;
               prevOptionsCount = optionsCount;    
               prevAgreementOptionsCount = agreementOptionsCount;
               prevRatingOptionsCount = ratingOptionsCount;
           }
      else
      {
        alert('Please select a question type before selecting a question');
      }
    
    }
   
   
    var optionsCount = 0; 
    var agreementOptionsCount=0;
    var prevOptionsCount = 0;
    var prevAgreementOptionsCount = 0;
    var prevRatingOptionsCount=0;
    var ratingOptionsCount=0;
    function saveMultipleQuestion()//This function saves a Multiple choice question
    {
      var questionValue = document.getElementById('multipleChoiceId');
      if(questionValue!=null)
      {
        if(optionsCount>0&&(optionsCount-prevOptionsCount)>0)
        {
          var tbl = document.getElementById('surveyTable');
          var lastRow = tbl.rows.length;
          var row = tbl.insertRow(lastRow);
          var cleft = row.insertCell(0);
          var labDiv = document.createElement('div');
          labDiv.className = 'colTitle';
          labDiv.appendChild(document.createTextNode(questionsCount+". "+questionValue.value));
          var elHidden = document.createElement('input');
          elHidden.type='hidden';
          elHidden.id='MUSS'+multipleChoiceSingleQuestions;
          elHidden.name='MUSS'+multipleChoiceSingleQuestions;
          elHidden.value=(questionsCount+"."+questionValue.value);
          //alert(elHidden.value);
          document.forms[0].appendChild(elHidden);
          var elHiddenType = document.createElement('input');
          elHiddenType.type='hidden';
          elHiddenType.id='MUSS'+multipleChoiceSingleQuestions;
          elHiddenType.name='MUSS'+multipleChoiceSingleQuestions+'Type';
          elHiddenType.value=questionsType;
          //alert(elHidden.value);
          document.forms[0].appendChild(elHiddenType);
          
          var elHiddenOpt = document.createElement('input');
          elHiddenOpt.type='hidden';
          elHiddenOpt.id='MUSS'+multipleChoiceSingleQuestions+'optionCount';
      elHiddenOpt.name='MUSS'+multipleChoiceSingleQuestions+'optionCount';
      elHiddenOpt.value=(optionsCount-prevOptionsCount);
      //alert(elHiddenOpt.value);
      document.forms[0].appendChild(elHiddenOpt);
          
          cleft.appendChild(labDiv);
          lastRow = lastRow+1;
          var rownew = tbl.insertRow(lastRow);
          var cellLeft = rownew.insertCell(0);
          var labDivParent = document.createElement('div');
          for(var i=prevOptionsCount;i<optionsCount;i++)
          {
              var labDiv = document.createElement('div');
              var el = document.createElement('input');
              if(questionsType==2)
              {
               el.type='checkbox';
              }
              else
              {
               el.type = 'radio';
              
              }
              el.name = 'radioButton'+questionsCount;
              el.value=document.getElementById('optionsText'+ i).value;
              //alert(el.name);
              el.id = 'optionsText' + i;
              labDiv.className = 'colTitle';
              labDiv.appendChild(el);
              labDiv.appendChild(document.createTextNode(document.getElementById('optionsText'+ i).value));
              labDivParent.appendChild(labDiv);
              var elHiddenOptions = document.createElement('input');
              elHiddenOptions.type='hidden';
              elHiddenOptions.id='MUSS'+multipleChoiceSingleQuestions+'option'+(i-prevOptionsCount);
              elHiddenOptions.name='MUSS'+multipleChoiceSingleQuestions+'option'+(i-prevOptionsCount);
              elHiddenOptions.value=document.getElementById('optionsText'+ i).value;
              document.forms[0].appendChild(elHiddenOptions);
              
          }
          cellLeft.appendChild(labDivParent);
        
        }
       else
       {
         alert('Please select answer options for the question');
         return;
       } 
      }
     questionsCount=questionsCount+1;
     multipleChoiceSingleQuestions = multipleChoiceSingleQuestions+1;
     document.addSurvey.mussQ.value = multipleChoiceSingleQuestions;
     removeQuestionDiv(); 
     insertEndRow(); 
    }
    
  var numOfRatingOptions=0
  function AddRatingNumQuestions()
  {
    tbl = document.getElementById('ratingNumSubQues');
    lastRow = tbl.rows.length;
    var rowNew = tbl.insertRow(lastRow);
    var cellLeft = rowNew.insertCell(0);
    var el= document.createElement('input');
    el.type='text';
    el.name='ratingNumQText'+numOfRatingOptions;
    el.id ='ratingNumQText'+numOfRatingOptions;
    numOfRatingOptions = numOfRatingOptions+1;
    el.size='25';
    ratingOptionsCount=ratingOptionsCount+1;      
    cellLeft.align='center';
    cellLeft.appendChild(el);    
  
  }
  
  function saveRatingNum()
  {
    var questionValue = document.getElementById('ratingNumTextArea');
      if(questionValue!=null)
      {
        if(numOfRatingOptions>0&&(numOfRatingOptions-prevRatingOptionsCount)>0)
        {
          var tbl = document.getElementById('surveyTable');
          var lastRow = tbl.rows.length;
          var row = tbl.insertRow(lastRow);
          var cleft = row.insertCell(0);
          var labDiv = document.createElement('div');
          labDiv.className = 'colTitle';
          labDiv.appendChild(document.createTextNode(questionsCount+". "+questionValue.value));
          var elHidden = document.createElement('input');
          elHidden.type='hidden';
          elHidden.id='RNUM'+ratingQuestionsCont;
          elHidden.name='RNUM'+ratingQuestionsCont;
          elHidden.value=(questionsCount+"."+questionValue.value);
          //alert(elHidden.value);
          document.forms[0].appendChild(elHidden);
          var elHiddenOpt = document.createElement('input');
          elHiddenOpt.type='hidden';
          elHiddenOpt.id='RNUM'+ratingQuestionsCont+'optionCount';
          elHiddenOpt.name='RNUM'+ratingQuestionsCont+'optionCount';
          elHiddenOpt.value=(ratingOptionsCount-prevRatingOptionsCount);
          //alert(elHiddenOpt.value);
          document.forms[0].appendChild(elHiddenOpt);
          cleft.appendChild(labDiv);
          lastRow = lastRow+1;
          var rownew = tbl.insertRow(lastRow);
          var cellLeft = rownew.insertCell(0);
          var cellRight = rownew.insertCell(1);
          var innertbl     = document.createElement("table");
          var innertblBody = document.createElement("tbody");
          var innerRow = document.createElement("tr");
          innertblBody.appendChild(innerRow);
          innertbl.appendChild(innertblBody);
          cellLeft.appendChild(innertbl);
          var innerCellL = innerRow.insertCell(0);
          var innerCellR = innerRow.insertCell(1);
          innerCellL.className='colTitle';
          innerCellR.className='colTitle';               
          var labDivLeftParent = document.createElement('div');
          var labDivRightParent = document.createElement('div');
          for(var i=prevRatingOptionsCount;i<ratingOptionsCount;i++)
          {
              var labDiv = document.createElement('div');
              labDiv.className = 'colTitle';
              labDiv.appendChild(document.createTextNode(document.getElementById('ratingNumQText'+ i).value));
              var elHiddenOptions = document.createElement('input');
              elHiddenOptions.type='hidden';
              elHiddenOptions.id='RNUM'+ratingQuestionsCont+'option'+(i-prevRatingOptionsCount);
              elHiddenOptions.name='RNUM'+ratingQuestionsCont+'option'+(i-prevRatingOptionsCount);
              //alert('RNUM'+ratingQuestionsCont+'option'+(i-prevRatingOptionsCount));
              elHiddenOptions.value=document.getElementById('ratingNumQText'+ i).value;
              document.forms[0].appendChild(elHiddenOptions);
              labDivLeftParent.appendChild(labDiv);              
              var labDivR = document.createElement('div');
              var el = document.createElement('input');
              el.type='text';
              labDivR.appendChild(el);
              labDivRightParent.appendChild(labDivR);
          }
          innerCellL.appendChild(labDivLeftParent);
          innerCellR.appendChild(labDivRightParent);
        }
        else
        {
          alert('Please add the subquestions');
          return;
        }
      }
      
     questionsCount=questionsCount+1;
     ratingQuestionsCont = ratingQuestionsCont+1;
     document.addSurvey.rnumQ.value = ratingQuestionsCont;
     removeQuestionDiv(); 
     insertEndRow();
  }
  
  function loopThroughForm()
  {
     var thisform = document.addSurvey;
     //alert(thisform.surveysTitle.value);
     alert('The survey titled '+thisform.surveysTitle.value+' has been saved successfully');
     thisform.submit();
  } 
  
  function insertEndRow()
  {
          var tbl = document.getElementById('surveyTable');
          var lastRow = tbl.rows.length;
          var row = tbl.insertRow(lastRow);
          var cleft = row.insertCell(0);
          cleft.className='back-grey-02-light';
          cleft.innerHTML='&nbsp;'; 
  }
  
  function saveAgreementScaleQuestions()
  {
  var questionValue = document.getElementById('multipleChoiceId');
  if(questionValue!=null)
      {
        
          if(agreementOptionsCount>0&&(agreementOptionsCount-prevAgreementOptionsCount)>0)
        {
          
          //alert(questionValue.value);
          var tbl = document.getElementById('surveyTable');
          var lastRow = tbl.rows.length;
          var row = tbl.insertRow(lastRow);
          var cleft = row.insertCell(0);
          var labDiv = document.createElement('div');
          labDiv.className = 'colTitle';
          labDiv.appendChild(document.createTextNode(questionsCount+"."+questionValue.value));
          var elHidden = document.createElement('input');
          elHidden.type='hidden';
          elHidden.id='agreementQuestion'+agreementQuestionsCont;
          elHidden.name='agreementQuestion'+agreementQuestionsCont;
          elHidden.value=(questionsCount+"."+questionValue.value);
          //alert(elHidden.value);
          document.forms[0].appendChild(elHidden);
          var elHiddenOpt = document.createElement('input');
              elHiddenOpt.type='hidden';
              elHiddenOpt.id='agreementQuestion'+agreementQuestionsCont+'optionCount';
          elHiddenOpt.name='agreementQuestion'+agreementQuestionsCont+'optionCount';
          elHiddenOpt.value=(agreementOptionsCount-prevAgreementOptionsCount);
          //alert(elHiddenOpt.value);
          document.forms[0].appendChild(elHiddenOpt);
              cleft.appendChild(labDiv);
          lastRow = lastRow+1;
          var rownew = tbl.insertRow(lastRow);
          var cellL = rownew.insertCell(0);
          var cellR = rownew.insertCell(1);
          var innertbl     = document.createElement("table");
          var innertblBody = document.createElement("tbody");
          var innerRow = document.createElement("tr");
          innertblBody.appendChild(innerRow);
          innertbl.appendChild(innertblBody);
          cellL.appendChild(innertbl);               
          var innerCellL = innerRow.insertCell(0);
          var innerCellR = innerRow.insertCell(1);
          innerCellL.className='colTitle';
          var labDivNew = document.createElement('div');
          labDivNew.className = 'colTitle';
          var el1 = document.createTextNode("Strongly Agree");
          var el2 = document.createTextNode("Agree");
          var el3 = document.createTextNode("Disgree");
          var el4 = document.createTextNode("Strongly Disagree");
          //labDivNew.appendChild(el1);
          //labDivNew.appendChild(el2);
          //labDivNew.appendChild(el3);
          //labDivNew.appendChild(el4); 
          labDivNew.innerHTML='Strongly Agree&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Agree&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disagree&nbsp&nbsp;&nbsp;&nbsp;&nbsp;Strongly Disagree';
          innerCellR.appendChild(labDivNew);
            
          //rownew.insertCell(0);
          
          /*var labDivNew = document.createElement('div');
          labDivNew.className = 'colTitle';
          var el1 = document.createTextNode(" Strongly Agree ");
          var el2 = document.createTextNode(" Agree   ");
          var el3 = document.createTextNode(" Disgree  ");
          var el4 = document.createTextNode(" Strongly Disagree ");
          labDivNew.appendChild(el1);
          labDivNew.appendChild(el2);
          labDivNew.appendChild(el3);
          labDivNew.appendChild(el4);
          cellLeft.appendChild(labDivNew);*/
        for(var i=prevAgreementOptionsCount;i<agreementOptionsCount;i++)
        {
          lastRow = lastRow+1;    
          var rowQ1 = tbl.insertRow(lastRow);
          var cellLeftQ1=rowQ1.insertCell(0);
          var innertblQ     = document.createElement("table");
          var innertblBodyQ = document.createElement("tbody");
          var innerRowQ = document.createElement("tr");
          innertblBody.appendChild(innerRowQ);
          innertbl.appendChild(innertblBodyQ);
          cellLeftQ1.appendChild(innertblQ);
          var innerCellLQ = innerRowQ.insertCell(0);
          var innerCellRQ = innerRowQ.insertCell(1);               
          innerCellLQ.className='colTitle';
          innerCellRQ.className='colTitle';
          var labDivQ1 = document.createElement('div');
          labDivQ1.className = 'colTitle';
          var elQ1 = document.createTextNode(document.getElementById('optionsAgText'+ i).value);
          labDivQ1.appendChild(elQ1);
          var elHiddenOptions = document.createElement('input');
          elHiddenOptions.type='hidden';
          elHiddenOptions.id='agreementQuestion'+agreementQuestionsCont+'option'+(i-prevAgreementOptionsCount);
          elHiddenOptions.name='agreementQuestion'+agreementQuestionsCont+'option'+(i-prevAgreementOptionsCount);
          elHiddenOptions.value=document.getElementById('optionsAgText'+ i).value;
          document.forms[0].appendChild(elHiddenOptions);
          innerCellLQ.appendChild(labDivQ1);
          var labDivRQ1 = document.createElement('div');
          labDivRQ1.className = 'colTitle';
          var elRQ1 = document.createElement('input');
          elRQ1.type='radio';
          elRQ1.name = 'checkBoxSA';
          elRQ1.id = 'checkBoxSA';
          var elRQ1t = document.createTextNode("                          ");
          var elRQ2 = document.createElement('input');
          elRQ2.type='radio';
          elRQ2.name = 'checkBoxA';
          elRQ2.id = 'checkBoxA';
          var elRQ2t = document.createTextNode("              ");
          var elRQ3 = document.createElement('input');
          elRQ3.type='radio';
          elRQ3.name = 'checkBoxDA';
          elRQ3.id = 'checkBoxDA';
          var elRQ3t = document.createTextNode("                 ");
          var elRQ4 = document.createElement('input');
          elRQ4.type='radio';
          elRQ4.name = 'checkBoxSDA';
          elRQ4.id = 'checkBoxSDA';
          var elRQ4t = document.createTextNode("               ");
          labDivRQ1.appendChild(elRQ4t)
          labDivRQ1.appendChild(elRQ1);
          labDivRQ1.appendChild(elRQ1t);
          labDivRQ1.appendChild(elRQ2);
          labDivRQ1.appendChild(elRQ2t)
          labDivRQ1.appendChild(elRQ3);
          labDivRQ1.appendChild(elRQ3t)
          labDivRQ1.appendChild(elRQ4);
          innerCellRQ.appendChild(labDivRQ1);
        } 
      }
     else
      {
         alert('Please add the subquestions');
         return; 
      }
    
    }
   questionsCount=questionsCount+1;
   agreementQuestionsCont=agreementQuestionsCont+1;
   document.addSurvey.agreementQ.value=agreementQuestionsCont;
     
   removeQuestionDiv();
   insertEndRow();
 }
  
   
   
    function addAnswerOptions()//This function adds the answer options to the Multiple select question
    {
      var tbl = document.getElementById('multipleAnswers');
      var lastRow = tbl.rows.length;
      var rownew = tbl.insertRow(lastRow);
      var cellLeft = rownew.insertCell(0);
      var cellRight = rownew.insertCell(1);
      
      var el = document.createElement('input');
      el.type = 'text';
      if(questionsType==1||questionsType==7||questionsType==2)
      {
        cellRight.align='center';
        el.name = 'optionsText' + optionsCount;
        el.id = 'optionsText' + optionsCount;
        optionsCount=optionsCount+1;
        el.size = 25;
      }
      else if(questionsType==5)
      {
        el.name = 'optionsAgText' + agreementOptionsCount;
        el.id = 'optionsAgText' + agreementOptionsCount;
        agreementOptionsCount=agreementOptionsCount+1;
        el.size = 50;
      }
      
      cellRight.appendChild(el);
       
     
    }
    function saveSimpleQuestion()//This function saves a simple Text question Entered.
    {
      var questionArea = document.getElementById('simpleTextQuestion');
      if(questionArea!=null)
      {
      var tbl = document.getElementById('surveyTable');
      var lastRow = tbl.rows.length;
      var row = tbl.insertRow(lastRow);
      var cleft = row.insertCell(0);
      var labDiv = document.createElement('div');
      labDiv.className = 'colTitle';
      labDiv.appendChild(document.createTextNode(questionsCount+". "+questionArea.value));
      var elHidden = document.createElement('input');
      elHidden.type='hidden';
      elHidden.id='simpleText'+simpleTextCount;
      elHidden.name='simpleText'+simpleTextCount;
      elHidden.value=(questionsCount+". "+(questionArea.value));
      var elHiddenType = document.createElement('input');
      elHiddenType.type='hidden';
      elHiddenType.id='simpleText'+simpleTextCount+'Type';
      elHiddenType.name='simpleText'+simpleTextCount+'Type';
      elHiddenType.value=questionsType;
      
      //alert((questionsCount+". "+(questionArea.value)));
      document.forms[0].appendChild(elHidden);
      document.forms[0].appendChild(elHiddenType);
      cleft.appendChild(labDiv);
      lastRow = lastRow+1;
      var rowNew = tbl.insertRow(lastRow);
      var cleftNew = rowNew.insertCell(0);
      var labDivNew = document.createElement('div');
      labDivNew.className = 'colTitle';

      if(questionsType==4)
      {
        var el = document.createElement('textarea');
        el.cols='40';
        el.name = 'simpleTextA'+questionsCount;
        el.id = 'simpleTextA' +questionsCount;
        labDivNew.appendChild(el);
      }
      else
      {
        var el = document.createElement('input');
        el.type="text";
        el.size='12';
        el.name = 'simpleTextA'+questionsCount;
        el.id = 'simpleTextA' +questionsCount;
        labDivNew.appendChild(el);
      }
      
      cleftNew.appendChild(labDivNew); 
      }
     questionsCount=questionsCount+1;
     simpleTextCount = simpleTextCount+1;
     document.addSurvey.simpleTextQ.value=simpleTextCount;
     removeQuestionDiv();
     insertEndRow();
    }

   function removeQuestionDiv()//This function removes the last temporary Div created for adding questions
   {
     var tbl = document.getElementById('rightTable');
     var lastRow = tbl.rows.length;
     var row = null;
     if(tbl.rows.length!=null&&tbl.rows.length>1)
     {
      //alert(lastRow+'last');
      tbl.deleteRow(lastRow-1);  
      
     } 
     
   }
   
    
    </script>
</head>
  <body class="tundra">
    <form name="addSurvey" id="addSurvey" method="POST">
    <input type="hidden" name="simpleTextQ" id="simpleTextQ" value="0">
    <input type="hidden" name="agreementQ" id="agreementQ" value="0">
    <input type="hidden" name="mussQ" id="mussQ" value="0">
    <input type="hidden" name="rnumQ" id="rnumQ" value="0">
    <input type="hidden" name="surveysTitle" id="surveysTitle" value="">
    
    <input type="hidden" name="questionId" value="0">
      <table  id="MainTable" width="100%" border="0">
  <tr>
    <td>
	<div class="expertsearchdiv" align="left" style="height:1000px">
       <div class="leftsearchbgpic">
                <div class="leftsearchtext">Create Survey</div>
       </div>
       <div class="colContent">
                <div style="padding: 1px"> 
                       <p></p>
                       <p></p> 
                 <table align="left"  width="90%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center"><input name="createSurvey" type="button"  style="background: transparent url(images/buttons/create_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 112px; height: 22px;" value="" onClick="createSurveys()" /></td>
                  </tr>
                  <tr>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center">
                    <select id="questionSelect" name="questionSelect" readonly style="width:150px;" size="1" > 
                    <option value="-1"  class="blueTextBox" >Please Select</option>
                    <option value="1"  class="blueTextBox"  >Multiple Choice Single Select</option>
                    <option value="2"  class="blueTextBox" >Multiple Choice Multi Select</option>
                    <option value="3"  class="blueTextBox" >Numeric Text</option>
                    <option value="4"  class="blueTextBox" >Open Text</option>
                    <option value="5"  class="blueTextBox"  >Agreement Scales</option>
                    <option value="6"  class="blueTextBox"  >Rating Numeric</option>
                    <option value="7"  class="blueTextBox" >Rating Select</option>
                    
                    </select>
                    </td>
                  </tr>
                  <tr>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center">
                    <input name="addQuestion" type="button" style="background: transparent url(images/buttons/add_question.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 103px; height: 22px;" value="" onClick="addQuestions()"/>
                    </td>
                  </tr>
                  <tr>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="center">
                    <input name="saveSurvey" type="button" style="background: transparent url(images/buttons/save_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 101px; height: 22px;" value="" onClick="loopThroughForm()"/>
                    </td>
                  </tr>
                 </table>
           </div>   
	</div>
	</td>
    <td align="left"  valign="top">
    
    <table class="openq" width="950" border="0" id="rightTable">
    <tr>
    <td width="925"> 
       <table id="surveyTable" class="colTitle"  cellspacing="0" cellpadding="0" width="100%">
    </table>
    </td>
    <td width="25">&nbsp;</td>
    </tr>
    </table>
    </td>
</tr>
</table>
</div>
    
    </form>
    </body>
    </html>
    