<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ include file="header.jsp" %>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="java.util.*"%>
<%@ page import="com.openq.utils.TimeTracker"%>
<%@ page import="com.openq.web.controllers.ColorCodeConstants"%>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
<% HashMap lookupId2ColorMap = (HashMap) session.getAttribute("LOOKUPID_COLORMAP");
  
   String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
   boolean isOTSUKAJVUser = false;
   if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
   		isOTSUKAJVUser = true;
   }
%>
<HEAD>
<SCRIPT src = "<%=COMMONJS%>/listbox.js" language = "Javascript"></SCRIPT>
<SCRIPT src = "<%=COMMONJS%>/validation.js" language = "Javascript"></SCRIPT>
<script type="text/javascript" src="js/outlook/ExportToOutlook.js"></script>
<script language="javascript" src="js/populateChildLOV.js"></script>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
<script language="javascript">
	function filterEvents(action){
	  var thisform = document.scheduleForm;
	  // create a JSON array of the therapy ids
	  var jsObject = new Object();
	  var therapyIdsArray = new Array();
	  var therapyLOV = document.getElementById("therapy");
	  if( therapyLOV != undefined && therapyLOV != null ){
		  var therapyIdsArrayIndex = 0;
		  for(var i=therapyLOV.length-1; i>=0; i--){
			  if(therapyLOV.options[i].selected){
				   therapyIdsArray[therapyIdsArrayIndex] = therapyLOV.options[i].id;
				   therapyIdsArrayIndex++;
			  }
		  }
	  }
	  jsObject["therapyIdsArray"] = therapyIdsArray;
	  thisform.parametersJSONString.value = dojo.toJson(jsObject);
	  thisform.action = "<%=CONTEXTPATH%>/event_schedule.htm?action=" + action;
	  thisform.submit();
	}

	function resetValues()
	{
	   var thisform = document.scheduleForm;
	   thisform.action = "<%=CONTEXTPATH%>/event_schedule.htm?action=<%=ActionKeys.ALL_MEDICAL_MEETINGS %>&reset=yes";
	   thisform.submit();
	}
</script>
</HEAD>
<%
        int monthToDisplay =0;
		int yearToDisplay =0;
		int monthDays[]={31,28,31,30,31,30,31,31,30,31,30,31};
        OptionLookup eventTherapy[] = (OptionLookup[]) session.getAttribute("EVENT_THERAPY");

		    GregorianCalendar currentDate =new GregorianCalendar();

			int month0=0;
			int year0=0;

			//after clicking on the control
		    if(monthToDisplay !=0){

				currentDate.set(Calendar.MONTH,monthToDisplay-1);
				currentDate.set(Calendar.YEAR,yearToDisplay);

				month0 = ((currentDate .get(Calendar.MONTH))+1);
				year0 =currentDate.get(Calendar.YEAR);
			}

			boolean leapYear = currentDate.isLeapYear(currentDate.get(Calendar.YEAR));

			currentDate.add(Calendar.MONTH,-1);
			currentDate.set(Calendar.DATE,1);


//Previous month
			int month1 = ((currentDate .get(Calendar.MONTH))+1);
		 	int day1 =currentDate .get(Calendar.DATE);
		 	int year1 =currentDate.get(Calendar.YEAR);

			//to get the end of the month
			int toAdd=0;
			if(leapYear && month1==2){
				toAdd = 29;
			}else {

				toAdd = monthDays[month1-1];
			}
			currentDate.set(Calendar.DATE,toAdd);

			int month2 =month1;
		 	int day2 =currentDate .get(Calendar.DATE);
		 	int year2 =currentDate.get(Calendar.YEAR);

//next Month

            currentDate.add(Calendar.MONTH,2);//adding 2 as one month is already reduced from the current

			int month3 = ((currentDate .get(Calendar.MONTH))+1);
		 	int day3 =currentDate .get(Calendar.DATE);
		 	int year3 =currentDate.get(Calendar.YEAR);

			//to get the end of the next month
			if(leapYear && month3==2){
				toAdd = 29;
			}else {
				toAdd = monthDays[month3-1];
			}
			currentDate.set(Calendar.DATE,toAdd);
			int month4 =month3;
		 	int day4 =currentDate .get(java.util.Calendar.DATE);
		 	int year4 =currentDate.get(Calendar.YEAR);

 %>

<%!
    public String getEventsDetails(HttpServletRequest request, int month)
    {
        String monthS = month + "";
        EventEntity [] eventEntity = (EventEntity []) request.getSession().getAttribute("eventEntity");
        StringBuffer sb = new StringBuffer("");
        if(eventEntity != null && eventEntity.length > 0)
		{
			for(int i = 0; i < eventEntity.length; i++ )
			{
				if( eventEntity[i].getEventdate().toString().split("-")[1].endsWith(monthS) )
				{
					String startTimeString = "09:00 AM";
					long duration = 120;
					sb.append(eventEntity[i].getEventdate().toString()).append("-");
					if ( eventEntity[i].getStartTime() != null )
					{
						startTimeString = eventEntity[i].getStartTime();
						if ( eventEntity[i].getEndTime() != null )
						{
							duration = TimeTracker.getDifference(startTimeString, eventEntity[i].getEndTime());
						}
					}
					sb.append(startTimeString).append("-");
					sb.append(duration).append("-");
					sb.append(eventEntity[i].getTitle()).append("-");
					sb.append(eventEntity[i].getDescription() != null ? eventEntity[i].getDescription() : "Not Available");
					sb.append("|");
				}
			}
		}
        String outlookInput = sb.toString().replaceAll("\"","&#34"); // Escape double-quote in HTML
        outlookInput = outlookInput.replaceAll("'","&#146"); // Escape "'" in HTML
        outlookInput = outlookInput.replaceAll("\\p{Cntrl}", ""); // Remove non-printable characters
        return outlookInput;
    }

%>

<%
	OptionLookup taLookup[] = null;
	if (session.getAttribute("EVENT_THERAPAEUTIC_AREA") != null) {
	    taLookup = (OptionLookup[]) session.getAttribute("EVENT_THERAPAEUTIC_AREA");
	}
	boolean isAlreadySelected = false;
%>
 <BODY>
 <form name="scheduleForm" method="POST">
<input type="hidden" name="parametersJSONString" value=""/>
  <div>
    <div class="producttext">
         <table width="100%"border="0" cellspacing="0" cellpadding="0">
          <tr>
                <td align="center" width="3%" valign="top">&nbsp;</td>

				<td align="center" width="12%" valign="top">
					<table>
					<tr>
						<td class="text-blue-01" width="15%">
							Therapeutic Area:
						</td>
					</tr>
					<tr>
						<td>
						        <% String eventTherapyLOVName = PropertyReader.getLOVConstantValueFor("THERAPY"); 
						              long selectedTAId = -1;
                                %>
							<select id="ta" name="ta" class="field-blue-56-180x100" onChange='populateChildLOV(this, "therapy", true, "<%=eventTherapyLOVName%>")'>
						        <%
						            if (taLookup != null && taLookup.length > 0) {
						                String selectedTaString = (String)request.getSession().getAttribute("taSelected");
		                                 long selectedTa = -1;
		                                 if(selectedTaString != null){
		                                     selectedTa = Long.parseLong(selectedTaString.trim());
		                                 }
						                OptionLookup tasLookup = null;
						                isAlreadySelected = false;
						                for (int i = 0; i < taLookup.length; i++) {
						                    tasLookup = taLookup[i];
						                    if(i == 0){
						                        selectedTAId = tasLookup.getId();
						                    }
						                    String selected = "" ;
						                    if(tasLookup.isDefaultSelected()){
						                        selected = "selected";
						                        selectedTAId = tasLookup.getId();
						                    }
						        %>
						        <option id="<%=tasLookup.getId()%>" value="<%=tasLookup.getId()%>"
						        <%if( selectedTa == tasLookup.getId()) {
						                isAlreadySelected = true;
						                selectedTAId = tasLookup.getId();
						                %> selected <%}
						                else if(!isAlreadySelected){%><%=selected%> <%} %>><%=tasLookup.getOptValue()%></option>
						        <%
						                }
						            }
						        %>
							</select>
						</td>
					</tr>
					<tr><td width="15%">&nbsp;</td></tr>
					<tr>
						<td class="text-blue-01", width="15%">
							Product:
						</td>
					</tr>
					<tr>
						<td>
							<select id="therapy" name="therapy" multiple class="field-blue-56-180x100" ></select>
                            <script>populateChildLOVById("<%=selectedTAId%>", "therapy", true, "<%=eventTherapyLOVName%>");</script>
					    </td>
					</tr>
					</table>
				</td>
				<td align="center" width="3%" valign="top">&nbsp;</td>
				<td align="center" width="19%" valign="top"><iframe width=174 height=189 name="[<%=year1%>,<%=month1%>]:normal:agenda.jsp" id="[<%=year1%>,<%=month1%>]:normal:agenda.jsp" src="calendar/calendar1.htm" scrolling="no" frameborder="0"></iframe></td>
				<td align="center" width="19%" valign="top"><iframe width=171 height=165 name="gToday:normal:agenda.jsp" id="gToday:normal:agenda.jsp" src="calendar/calendar.htm" scrolling="no" frameborder="0"></iframe></td>
				<td align="center" width="19%" valign="top"><iframe width=171 height=165 name="[<%=year3%>,<%=month3%>]:normal:agenda.jsp" id="[<%=year3%>,<%=month3%>]:normal:agenda.jsp" src="calendar/calendar2.htm" scrolling="no" frameborder="0"></iframe></td>
				<td align="center" width="6%" valign="top">&nbsp;</td>
		</tr>
		<tr height=30>


				<td align="center" width="3%" valign="top">&nbsp;</td>
				<td align="center" width="12%" valign="top">
				<table>
				<tr>
				<td valign="middle">
					<input type="button" name="Filter" value="" onClick = filterEvents('<%=ActionKeys.FILTERED_MEDICAL_MEETINGS %>');
				style="border:0;background : url(images/buttons/filter.jpg);width:65px; height:22px;"/>
				</td>
				<td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="3" height="5"></td>
				<td valign="middle">
				<input type="button" name="Reset" value="" onClick = resetValues();
					style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;"/>
				</td>
				</tr>
				</table>
				</td>
				<td align="center" width="3%" valign="top">&nbsp;</td>
				<td align="center" width="19%" valign="bottom" style="cursor:hand" onclick="exportEvents('<%=(getEventsDetails(request,month4-2))%>')"> <img src='images/calendarAdd.jpg' border=0 height="20" title="Export Medical Meetings"/></td>
				<td align="center" width="19%" valign="bottom" style="cursor:hand" onclick="exportEvents('<%=(getEventsDetails(request,month4-1))%>')"> <img src='images/calendarAdd.jpg' border=0 height="20" title="Export Medical Meetings"/></td>
			    <td align="center" width="19%" valign="bottom" style="cursor:hand" onclick="exportEvents('<%=(getEventsDetails(request, month4))%>')"> <img src='images/calendarAdd.jpg' border=0 height="20" title="Export Medical Meetings"/></td>
			    <td align="center" width="6%" valign="top">&nbsp;</td>
		</tr>
		</table>
		<table>
			<tr><td>&nbsp;</td></tr>
			<tr>
			<td align="left" width="5%" valign="top">
			<input type="button" name="addProg" value=""
				style="border:0;background : url(images/buttons/search_event.gif);width:168px; height:22px;"
					onClick="parent.location='event_search.htm'"/>
			</td>
			</tr>
		</table>
		<table width="100%" align="left">
        <tr>
        <td>
        <table id="taLegendTable" width="100%">
                <%if( taLookup != null ) {
                        for (int j = 0; j < taLookup.length; j++) {
                            if (j == 0 || j % 10 == 0) {
                %>
                <tr>
                <%
                    }
                %>
                    <td width="2%" id="<%=taLookup[j].getId()%>" bgcolor="<%=lookupId2ColorMap.get(taLookup[j].getId()+"")%>" />
                    <td width="8%" class="text-blue-01"><%=taLookup[j].getOptValue()%> </td>
                 <%
                     if ((j != 0 && j % 9 == 0) || j == taLookup.length - 1) {
                         for(int i=j; i<9; i++){%>
                            <td width="2%">&nbsp;</td>
                            <td width="8%" class="text-blue-01">&nbsp;</td>
                        <% } %>
                 </tr>
                <%
                    }
                  }
              }
                %>
            </table>
            </td>
            </tr>
                <tr>
                   <td>
                    <table id="therapyLegendTable" width="100%">
                            <%
                                if( eventTherapy != null ){
                                      for (int j = 0; j < eventTherapy.length; j++) {
                                          if (j == 0 || j % 10 == 0) {
                            %>
                            <tr>
                            <%
                                }
                            %>
                                <td width="2%" id="<%=eventTherapy[j].getId()%>" bgcolor="<%=lookupId2ColorMap.get(eventTherapy[j].getId()+"")%>" />
                                <td width="8%" class="text-blue-01"><%=eventTherapy[j].getOptValue()%> </td>
                             <%
                                 if ((j != 0 && j % 9 == 0) || j == eventTherapy.length - 1) {
                                     for(int i=j; i<9; i++){%>
                                     <td width="2%">&nbsp;</td>
                                     <td width="8%" class="text-blue-01">&nbsp;</td>
                                 <% } %>
                              </tr>
                            <%
                                }
                                }
                            }
                            %>
                        </table>
                    </td>
                </tr>
        </table>
    </div>
    <div class="myexpertlist">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                        <tbody>
                            <tr class="colTitle">
                                <td width="1%"><img src="images/buttons/calendar_24.png"/></td>
                                <td width="50%" align="left">
                                    <div class="myexperttext">Medical Meetings</div>
                                </td>
                            </tr>
                        </tbody>
               </table>
         </div>
   <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	  <tr>
		<td width="100%" colspan="6"><iframe height="100%" width="100%" name="eventDetails" src="eventsList.jsp" scrolling="yes" frameborder="0"></iframe></td>
	  </tr>
    </table>
    
    <table>
    <tr>
		<td width="5%" align="left" valign="top">
				
			<input <%=((isOTSUKAJVUser) ?"disabled":"")%> type="button" name="addProg" value=""
      	    	style="border:0;background : url(images/buttons/<%=((isOTSUKAJVUser)?"create_new_event_disabled.gif":"create_new_event.gif")%>);width:190px; height:22px;"  
            	onclick="parent.location='event_add.htm'"/>
            					
		</td>
	</tr>
	</table>

    <div class="clear"></div>
	</div>


</form><p>&nbsp;<p>&nbsp;<p>&nbsp;
<!--
  Following is a dummy form which is used by the calendar widget to set the selected date.
  Note the name of the form and the the input field are fixed. If they are changed the
  calendar widget would start showing javascript errors.
-->
<form name="demoForm">
  <input type="hidden" name="dateField"/>
</form>
<%

if(session.getAttribute("materials")!=null){
 session.removeAttribute("materials");
}
if(session.getAttribute("eventId")!=null){
 session.removeAttribute("eventId");
}
if(session.getAttribute("INVITED_USERS")!=null){
	session.removeAttribute("INVITED_USERS");
}
 session.removeAttribute("EVENT_DETAILS");
 %>
<%@

include file="footer.jsp" %>