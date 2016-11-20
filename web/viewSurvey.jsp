<%@page import="java.util.Map"%>
 <%@ page import="java.util.HashMap"%>
<%


Map questionsMap = null;
if(request.getSession().getAttribute("questionsMap")!=null)
{
  questionsMap = (HashMap)request.getSession().getAttribute("questionsMap");
}

String surveyTitle ="Title";
if(request.getSession().getAttribute("surveyTitle")!=null)
{
  surveyTitle=(String)request.getSession().getAttribute("surveyTitle");
}
 String surveyId=null;
 if(request.getSession().getAttribute("NEWSURVEY_ID")!=null)
 {
   surveyId = (String)request.getSession().getAttribute("NEWSURVEY_ID");
 }

 %>

<%@page import="com.openq.survey.QuestionDetails"%>
<%@page import="com.openq.kol.DBUtil"%>
<HTML>
<HEAD>
  <TITLE>BMS Synergy</TITLE>
  <LINK href="css/openq.css" type=text/css rel=stylesheet>

</HEAD>

  <script type="text/javascript">
   function submitSurvey()
   {

      document.viewSurvey.action="viewSurvey.htm?action=submitSurvey";
      var flag=false;
      var selectElement = document.getElementById('interactionAttendee');
      if(selectElement!=null&&selectElement.length>0&&selectElement.selectedIndex!=-1)
      {}
      else
       {
       alert('Please add the Attendees');
       window.close();

       }
      var thisform = document.viewSurvey;
      var totalQuestions = thisform.totalQuestions.value;
      document.viewSurvey.submit();
      window.close();
      }




   function populateAttendeeDropDown()
   {
	   var attendeeInfoArray=window.opener.getAddedAttendeesArray();
	   for(var i=0;i<attendeeInfoArray.length;i++)
	{
	   var name=attendeeInfoArray[i].split("_")[2];
	   document.viewSurvey.interactionAttendee.options[i] = new Option(name,attendeeInfoArray[i]);
	}
   }

   </script>

<body onload="populateAttendeeDropDown()">
<form name="viewSurvey" id="viewSurvey" method="POST" >
<input name="surveyId" id="surveyId" type="hidden" value=<%=surveyId %>>
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
    <input name="totalQuestions" id="totalQuestions" type="hidden"  value="<%if (questionsMap!=null) {%><%=questionsMap.size() %><%} %>" >
    <div class="back-grey-02-light" id="one">
      <table width="100%" border="0" cellspacing="1" cellpadding="1">
       <tr class="colTitle">
         <td> Title : <%=surveyTitle %>
         <input name="actionValue" id="actionValue" type="hidden" value="">
         </td>
		 <td align="right">
		 Select <%=DBUtil.getInstance().doctor%>  <select name="interactionAttendee" id="interactionAttendee" class="field-blue-01-180x20" >
              </select>
		  &nbsp;&nbsp;</td>
       </tr>
	  </table>
    </div>
    </td>
   </tr>
   <tr class="back-grey-01-dark">
      <td>
      &nbsp;</td>
   </tr>
 <% if(questionsMap!=null&&questionsMap.size()>0){
     for(int i=1;i<=questionsMap.size();i++)
     {
       Object[] objectArray = (Object[])questionsMap.get(i+"");
      if(objectArray!=null)
      {
        if(objectArray[0].equals("4")||objectArray[0].equals("3"))
          {


 %>
      <tr>
      <td>
        <div class="colTitle">
          <table class="colTitle">
              <tr class="colTitle">
                <td >
                    <%=objectArray[2] %>
                 <input name="question<%=i %>Id" type="hidden" value="<%=objectArray[1] %>">
                 <input name="question<%=i %>Type" id="question<%=i %>Type" type="hidden" value="<%=objectArray[0] %>">
                 </td>
                 <% if(objectArray[0].equals("3"))
                  {%>
                 <td>
                 <input name="answer<%=i %>" id="answer<%=i %>" value=""/>
                 </td>
                </tr>
                <% } else { %>
                 </tr>
                 <tr class="colTitle">
                 <td>
                   <textarea name="answer<%=i %>" id="answer<%=i %>" cols="70"/></textarea>
                 </td>
                </tr>
                <% } %>
          </table>
        </div>
      </td>
      </tr>
     <tr class="back-grey-01-dark">
      <td>&nbsp;</td>
     </tr>


 <%   }
         else if(objectArray[0].equals("5"))
         {
            String questionText = (String)objectArray[2];
            QuestionDetails[] subQuestions = (QuestionDetails[])objectArray[3];
            if(questionText!=null&&!questionText.equals("")&&subQuestions!=null&&subQuestions.length>0)
            {
              %>

              <tr>
                <td>
                <input name="question<%=i %>Id" type="hidden" value="<%=objectArray[1] %>">
                <input name="question<%=i %>Type" type="hidden" value="<%=objectArray[0] %>">
                <input name="question<%=i %>options" type="hidden" value="<%=subQuestions.length %>">
                    <div class="colTitle">
                      <table class="colTitle">
                          <tr class="colTitle">
                            <td >
                              <%=questionText %>
                            </td>
                          </tr>
                          <tr class="colTitle">
                           <td>
                             <table width="900">
                               <tr>
                                  <td width="505">&nbsp; </td>
                                   <td class="colTitle" width="383">Strongly Agree&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Agree&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disagree&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Strongly Disagree </td>
                               </tr>
                      <% for (int j=0;j<subQuestions.length;j++)
                      { %>
                               <tr>
                                <td width="505" class="colTitle"><%=subQuestions[j].getText() %></td>
                                <td width="383">
                                <input name="answer<%=i %>subQuestion<%=j %>Id" type="hidden" value="<%=subQuestions[j].getId() %>">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <input name="answer<%=i %>Radio<%=j %>" type="radio" value="StronglyAgree">
                                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                 <input name="answer<%=i %>Radio<%=j %>" type="radio" value="Agree">
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  <input name="answer<%=i %>Radio<%=j %>" type="radio" value="Disagree">
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  <input name="answer<%=i %>Radio<%=j %>" type="radio" value="Stronglydisagree">
                                 </td>
                               </tr>
                       <%} %>
                          </table>
                        </td>
                      </tr>
              </table>
        </div>
      </td>
      </tr>
       <tr class="back-grey-01-dark">
       <td>&nbsp;</td>
        </tr>


            <% }


         }

         else if(objectArray[0].equals("1")||objectArray[0].equals("7")||objectArray[0].equals("2"))
         {
            String questionText = (String)objectArray[2];
            String[] subQuestions = (String[])objectArray[3];
            if(questionText!=null&&!questionText.equals("")&&subQuestions!=null&&subQuestions.length>0)
            {
             %>
               <tr>
                <td>
                <input name="question<%=i %>Id" type="hidden" value="<%=objectArray[1] %>">
                <input name="question<%=i %>Type" type="hidden" value="<%=objectArray[0] %>">
                <input name="question<%=i %>Options" type="hidden" value="<%=subQuestions.length %>">
                    <div class="colTitle">
                      <table class="colTitle">
                          <tr class="colTitle">
                            <td >
                              <%=questionText %>
                            </td>
                          </tr>
                         </table>
                        </div>
                      </td>
                     </tr>
                   <% for (int j=0;j<subQuestions.length;j++)
                      { %>
                      <tr>
                        <td>
                          <div class="colTitle">
                            <table class="colTitle">
                              <tr class="colTitle">
                                  <td >
                                 <% if(objectArray[0].equals("2")){%>
                                 <input name="answerCheck<%=i %>" type="checkbox"  value="<%=subQuestions[j] %>"> <%=subQuestions[j] %> <br>
                                 <%}else {%>
                                 <input name="answerRadio<%=i %>" type="radio" value="<%=subQuestions[j] %>"> <%=subQuestions[j] %> <br>
                                  <%} %>
                                  </td>
                                </tr>
                              </table>
                             </div>
                            </td>
                           </tr>
                      <%} %>
                      <tr class="back-grey-01-dark">
                        <td>&nbsp;</td>
                      </tr>
         <%}
         }
            else if(objectArray[0].equals("6"))
            {
               String questionText = (String)objectArray[2];
               QuestionDetails[] subQuestions = (QuestionDetails[])objectArray[3];
               if(questionText!=null&&!questionText.equals("")&&subQuestions!=null&&subQuestions.length>0)
               {
                 %>

                 <tr>
                   <td>
                   <input name="question<%=i %>Id" type="hidden" value="<%=objectArray[1] %>">
                   <input name="question<%=i %>Type" type="hidden" value="<%=objectArray[0] %>">
                   <input name="question<%=i %>options" type="hidden" value="<%=subQuestions.length %>">
                       <div class="colTitle">
                         <table class="colTitle">
                             <tr class="colTitle">
                               <td >
                                 <%=questionText %>
                               </td>
                             </tr>
                             <tr class="colTitle">
                              <td>
                                <table width="900">

                         <% for (int j=0;j<subQuestions.length;j++)
                         { %>
                                  <tr>
                                   <td width="505" class="colTitle"><%=subQuestions[j].getText() %></td>
                                   <td width="383">
                                   <input name="answer<%=i %>subQuestion<%=j %>Id" type="hidden" value="<%=subQuestions[j].getId() %>">
                                   <input name="answer<%=i %>Text<%=j %>" type="text" value="">
                                    </td>
                                  </tr>
                          <%} %>
                             </table>
                           </td>
                         </tr>
                 </table>
           </div>
         </td>
         </tr>
          <tr class="back-grey-01-dark">
          <td>&nbsp;</td>
           </tr>

         <% }

    }
   }



 }
}
 %>

 <tr class="back-grey-01-dark">
 <td align="right">
 <input name="savesurvey" type="button"  style="background: transparent url(images/buttons/submit_survey.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 112px; height: 22px;" value=""  onclick="submitSurvey()">
  &nbsp;&nbsp;</td>
 </tr>
  </table>
  </form>
</body>
</html>
