<%@ page contentType="text/javascript" %>
<%@ page import="com.openq.event.EventEntity"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.interaction.Interaction"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.openq.web.controllers.InteractionConstants"%>
<%@ page import="com.openq.web.controllers.ColorCodeConstants"%>
<%@ page import="java.util.HashSet"%><%@ page import="java.util.Iterator"%><%@ page import="java.util.List"%><%@ page import="com.openq.event.KolCalendar"%>
<jsp:directive.page import="java.util.ArrayList;"/>

<%

	EventEntity [] eventEntity = (EventEntity []) request.getSession().getAttribute("eventEntity");
	HashSet accepted = (HashSet) request.getSession().getAttribute("accepted");
	HashSet attended = (HashSet)  request.getSession().getAttribute("attended");
	HashSet invited = (HashSet)  request.getSession().getAttribute("invited");

    HashSet interactions = (HashSet) request.getSession().getAttribute("INTERACTIONS");
    OptionLookup[] interactionTypes = (OptionLookup []) session.getAttribute("INTERACTION_TYPES");
    
    HashMap interactionTypesColor = new HashMap();
     
    if (interactionTypes != null) {
        String colour = "";
        int colourArrayLength = InteractionConstants.interactionLegends.length;
        int j = 0;
        for (int i = 0; i < interactionTypes.length; i++) {
                j = i%colourArrayLength;
                colour = InteractionConstants.interactionLegends[j];
             interactionTypesColor.put(interactionTypes[i].getOptValue(), colour);
        }
    }

    List pref = (List) request.getSession().getAttribute("preference");
	String actionKey = "viewEvent";
	ArrayList unavailableDates=null;

	if(session.getAttribute("unavailableDates")!=null){
	   unavailableDates=(ArrayList)session.getAttribute("unavailableDates");
	}
    boolean disablePopup = false;
    boolean checkAvail=false;
    String expertColorCode[] = {"#008000","#99CC00","#FF0000","#993300","#0000FF","FFFF00"};
    String prefCode[] = {"1st Preference","2nd Preference","Unavailable"};
    if (request.getParameterValues("disablePopup") != null )
    {
         disablePopup = Boolean.valueOf(request.getParameter("disablePopup")).booleanValue();
    }
    if (request.getParameterValues("checkAvail") != null )
    {
         checkAvail = Boolean.valueOf(request.getParameter("checkAvail")).booleanValue();
    }
    HashMap lookupId2ColorMap = (HashMap) session.getAttribute("LOOKUPID_COLORMAP");
%>

//////////////////// Agenda file for CalendarXP 9.0 /////////////////
// This file is totally configurable. You may remove all the comments in this file to minimize the download size.
/////////////////////////////////////////////////////////////////////

//////////////////// Define agenda events ///////////////////////////
// Usage -- fAddEvent(year, month, day, message, action, bgcolor, fgcolor, bgimg, boxit, html, etc);
// Note:
// 1. the (year,month,day) identifies the date of the agenda event.
// 2. the message param will be shown as tooltip and in the status bar.
// 3. setting the action param to null will disable that date with a line-through effect.
// 4. bgcolor is the background color.
// 5. fgcolor is the font color. Setting it to ""(empty string) will hide the date.
// 6. bgimg is the url of the background image file in use with the specific date.
// 7. if boxit is set other than false or null value, the date will be drawn in a box using boxit value as the color, or bgcolor if boxit is true.
// 8. html is the HTML string to be injected into the agenda cell, e.g. an <img> tag.
// 9. etc is any object you would like to associate with the date, so that you can retrieve it later via the fGetEvent().
// ** REMEMBER to unlock corresponding bits of the gAgendaMask option in the theme.
/////////////////////////////////////////////////////////////////////

// fAddEvent(2003,12,2," Click me to active your email client. ","popup('mailto:any@email.address.org?subject=email subject')","#87ceeb","dodgerblue",null,true);
// fAddEvent(2004,4,1," Let's google. ","popup('http://www.google.com','_top')","#87ceeb","dodgerblue",null,"gold");
// fAddEvent(2004,9,23, "Hello World!\nYou can't select me.", null, "#87ceeb", "dodgerblue");

<%

    if(!disablePopup && eventEntity != null)
    {
    	if(checkAvail)
    	{

    	  for(int i=0;i<unavailableDates.size();i++){
    	 %>
    	  			fAddEvent(
    	  						<%=unavailableDates.get(i).toString().split("-")[0]%>,
    	  						<%=unavailableDates.get(i).toString().split("-")[1]%>,
    	  						<%=unavailableDates.get(i).toString().split("-")[2]%>,
    	  						"Unavailable",
    	  						"javascript:parent.availCheck()",
    	  						"Red",
    	  						"dodgerblue"
    	  					);
    	<%}
    	}else{
		      for(int i=0; i<eventEntity.length; i++){
		                String colorkey = eventEntity[i].getTa().getId()+"";
		                if( eventEntity[i].getTherapy() != null ){
		                    colorkey = eventEntity[i].getTherapy().getId()+"";
		                }
		                Date eventBeginDate = eventEntity[i].getEventdate();
                        Date eventEndDate = eventEntity[i].getEndDate();
						if(eventEndDate!=null){
							Date beginD = new GregorianCalendar(Integer.parseInt(eventBeginDate.toString().split("-")[0]), 
						    Integer.parseInt(eventBeginDate.toString().split("-")[1])-1,Integer.parseInt(eventBeginDate.toString().split("-")[2])).getTime();
	                        Date endD = new GregorianCalendar(Integer.parseInt(eventEndDate.toString().split("-")[0]), 
						    Integer.parseInt(eventEndDate.toString().split("-")[1])-1,Integer.parseInt(eventEndDate.toString().split("-")[2])).getTime();
							long diff = endD.getTime() - beginD.getTime();
							String numDays = (diff / (1000 * 60 * 60 * 24))+"";
							 if(numDays!=null)
							 {
							    int number = Integer.parseInt(numDays);
								for(int k=1;k<=number;k++){
									SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");  
									Calendar cal = new GregorianCalendar(Integer.parseInt(eventBeginDate.toString().split("-")[0]), 
						            Integer.parseInt(eventBeginDate.toString().split("-")[1])-1,Integer.parseInt(eventBeginDate.toString().split("-")[2]));
									cal.add(Calendar.DATE, k);	//Adding 1 day to current date
									String newdate = dateformat.format(cal.getTime());
								%>
								fAddEvent(
		                                    <%=newdate.split("-")[0]%>,
		                                    <%=newdate.split("-")[1]%>,
		                                    <%=newdate.split("-")[2]%>,
		                                    "<%=eventEntity[i].getTitle()%>",
		                                    <%  if(disablePopup) { %>
		                                            "javascript:void(0)",
		                                    <%  } else { %>
		                                                "popup('../eventsList.htm?eventmiddate=<%=newdate%>', 'eventDetails')",
		                                    <%  } %>
		                                    "<%=lookupId2ColorMap.get(colorkey)%>", "dodgerblue");
								<%}
							  }
						}
						
						%>
                          fAddEvent(
                          <%=eventBeginDate.toString().split("-")[0]%>,
                          <%=eventBeginDate.toString().split("-")[1]%>,
                          <%=eventBeginDate.toString().split("-")[2]%>,
                          "<%=eventEntity[i].getTitle()%>",
                          <%  if(disablePopup) { %>
                                  "javascript:void(0)",
                          <%  } else { %>
                                      "popup('../eventsList.htm?eventmiddate=<%=eventEntity[i].getEventdate()%>', 'eventDetails')",
                          <%  } %>
                          "<%=lookupId2ColorMap.get(colorkey)%>", "dodgerblue");    
		             <%
		        }
		 }
    }
    else
    {
      if(accepted != null && accepted.size() >0){
	      Iterator i = accepted.iterator();
	      EventEntity e = null;
	      while (i.hasNext()){
	         e = (EventEntity)i.next();
	         %>
	                    fAddEvent(
	                                    <%=e.getEventdate().toString().split("-")[0]%>,
	                                    <%=e.getEventdate().toString().split("-")[1]%>,
	                                    <%=e.getEventdate().toString().split("-")[2]%>,
	                                    "<%=e.getTitle()%>",
	                                    "popup('../eventsList.htm?eventdate=<%=e.getEventdate()%>', 'eventDetails')",
	                                    "<%=expertColorCode[4]%>", "dodgerblue");
	         <%
	       }
      }
      if(attended != null && attended.size() >0){
	      Iterator i = attended.iterator();
	      EventEntity e = null;
	      while (i.hasNext()){
	         e = (EventEntity)i.next();
	         %>
	                    fAddEvent(
	                                    <%=e.getEventdate().toString().split("-")[0]%>,
	                                    <%=e.getEventdate().toString().split("-")[1]%>,
	                                    <%=e.getEventdate().toString().split("-")[2]%>,
	                                    "<%=e.getTitle()%>",
	                                    "popup('../eventsList.htm?eventdate=<%=e.getEventdate()%>', 'eventDetails')",
	                                    "<%=expertColorCode[3]%>", "dodgerblue");
	         <%
	       }
      }
      if(invited != null && invited.size() >0){
	      Iterator i = invited.iterator();
	      EventEntity e = null;
	      while (i.hasNext()){
	         e = (EventEntity)i.next();
	         %>
	                    fAddEvent(
	                                    <%=e.getEventdate().toString().split("-")[0]%>,
	                                    <%=e.getEventdate().toString().split("-")[1]%>,
	                                    <%=e.getEventdate().toString().split("-")[2]%>,
	                                    "<%=e.getTitle()%>",
	                                    "popup('../eventsList.htm?eventdate=<%=e.getEventdate()%>', 'eventDetails')",
	                                    "<%=expertColorCode[5]%>", "dodgerblue");
	         <%
	       }
      }
      if(pref != null && pref.size() >0){
    	  Iterator i = pref.iterator();
	      KolCalendar k = null;
	      int m = 0;
	      while (i.hasNext()){
	         k = (KolCalendar)i.next();
	         int prefInt = Integer.parseInt(k.getType());
	
	         %>
	                    fAddEvent(
	                                    <%=k.getPreferenceDate().toString().split("-")[0]%>,
	                                    <%=k.getPreferenceDate().toString().split("-")[1]%>,
	                                    <%=k.getPreferenceDate().toString().split("-")[2]%>,
	                                    "<%=prefCode[prefInt]%>","javascript:void(0)",
	                                    "<%=expertColorCode[prefInt]%>", "dodgerblue");
	         <%
           }
	       }
      if(interactions != null && interactions.size() >0) {
      Iterator it = interactions.iterator();
      Interaction i = null;
      while (it.hasNext()) {
             i = (Interaction)it.next();
             
             %>
                        fAddEvent(
                                        <%=i.getInteractionDate().toString().split("-")[0]%>,
                                        <%=i.getInteractionDate().toString().split("-")[1]%>,
                                        <%=i.getInteractionDate().toString().split("-")[2]%>,
                                        "<%=i.getType().getOptValue()%>","javascript:void(0)",
                                        "<%=(interactionTypesColor.get(i.getType().getOptValue()))%>", "dodgerblue");
             <%
             
      }
      }

    }
%>

///////////// Recurring Events /////////////////////////
// fHoliday() provides you a flexible way to create recurring events easily.
// Once defined, it'll be used by the calendar engine to render each date cell.
// An agenda array [message, action, bgcolor, fgcolor, bgimg, boxit, html, etc]
// is expected as return value, which are similar to the params of fAddEvent().
// Returning null value will result in default style as defined in the theme.
// ** REMEMBER to unlock corresponding bits of the gAgendaMask option in the theme.
////////////////////////////////////////////////////////
function fHoliday(y,m,d) {
	var rE=fGetEvent(y,m,d), r=null;

	// you may have sophisticated holiday calculation set here, following are only simple examples.
	if (m==1&&d==1)
		r=[" Jan 1, "+y+" \n Happy New Year! ",gsAction,"skyblue","red"];
	else if (m==12&&d==25)
		r=[" Dec 25, "+y+" \n Merry X'mas! ",gsAction,"skyblue","red"];
	else if (m==7&&d==1)
		r=[" Jul 1, "+y+" \n Canada Day ",gsAction,"skyblue","red"];
	else if (m==7&&d==4)
		r=[" Jul 4, "+y+" \n Independence Day ",gsAction,"skyblue","red"];
	else if (m==11&&d==11)
		r=[" Nov 11, "+y+" \n Veteran's Day ",gsAction,"skyblue","red"];
	else if (m==1&&d<25) {
		var date=fGetDateByDOW(y,1,3,1);	// Martin Luther King, Jr. Day is the 3rd Monday of Jan
		if (d==date) r=[" Jan "+d+", "+y+" \n Martin Luther King, Jr. Day ",gsAction,"skyblue","red"];
	}
	else if (m==2&&d<20) {
		var date=fGetDateByDOW(y,2,3,1);	// President's Day is the 3rd Monday of Feb
		if (d==date) r=[" Feb "+d+", "+y+" \n President's Day ",gsAction,"skyblue","red"];
	}
	else if (m==9&&d<15) {
		var date=fGetDateByDOW(y,9,1,1);	// Labor Day is the 1st Monday of Sep
		if (d==date) r=[" Sep "+d+", "+y+" \n Labor Day ",gsAction,"skyblue","red"];
	}
	else if (m==10&&d<15) {
		var date=fGetDateByDOW(y,10,2,1);	// Thanksgiving is the 2nd Monday of October
		if (d==date) r=[" Oct "+d+", "+y+" \n Thanksgiving Day (Canada) ",gsAction,"skyblue","red"];
	}
	else if (m==11&&d>15) {
		var date=fGetDateByDOW(y,11,4,4);	// Thanksgiving is the 4th Thursday of November
		if (d==date) r=[" Nov "+d+", "+y+" \n Thanksgiving Day (U.S.) ",gsAction,"skyblue","red"];
	}
	else if (m==5&&d>20) {
		var date=fGetDateByDOW(y,5,5,1);	// Memorial day is the last Monday of May
		if (d==date) r=[" May "+d+", "+y+" \n Memorial Day ",gsAction,"skyblue","red"];
	}


	return rE?rE:r;	// favor events over holidays
}