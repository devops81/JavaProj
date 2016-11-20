<%@ page import="java.util.*"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>

<%
        System.out.println("in available calendar");
        int monthToDisplay =0;
		int yearToDisplay =0;
		int monthDays[]={31,28,31,30,31,30,31,31,30,31,30,31};
		String ColorCode[]={"#9900CC","#009900","#3300FF","FFFF00","FF3300",
                         "00FF33","0099CC","0099CC","FFCCFF","CC0033"};
        OptionLookup eventTypesLookup[] = null;
	    if (session.getAttribute("EVENT_TYPES") != null)
          eventTypesLookup = (OptionLookup[]) session.getAttribute("EVENT_TYPES");

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
//next to next month		 	
 			currentDate.add(Calendar.MONTH,1);//adding 2 as one month is already reduced from the current

			int month5 = ((currentDate .get(Calendar.MONTH))+1);
		 	int day5 =currentDate .get(Calendar.DATE);
		 	int year5 =currentDate.get(Calendar.YEAR);

			//to get the end of the next month
			if(leapYear && month5==2){
				toAdd = 29;
			}else {
				toAdd = monthDays[month3-1];
			}
			currentDate.set(Calendar.DATE,toAdd);
			int month6 =month5;
		 	int day6 =currentDate .get(java.util.Calendar.DATE);
		 	int year6 =currentDate.get(Calendar.YEAR);

 %>
       <table>
          <tr>
			    
		        <td align="center" width="15%" valign="top"><iframe width=174 height=150 name="gToday:normal:agenda.jsp?checkAvail=true:gfFlat" id="gToday:normal:agenda.jsp?checkAvail=true:gfFlat" src="calendar/calendar1.htm" scrolling="no" frameborder="0"></iframe>&nbsp;&nbsp;</td>
				<td align="center" width="10%" valign="top"><iframe width=171 height=150 name="[<%=year3%>,<%=month3%>]:normal:agenda.jsp?checkAvail=true:gfFlat" id="[<%=year3%>,<%=month3%>]:normal:agenda.jsp?checkAvail=true:gfFlat" src="calendar/calendar.htm" scrolling="no" frameborder="0"></iframe></td>
				<td align="center" width="16%" valign="top">
				<iframe width=171 height=150 name="[<%=year5%>,<%=month5%>]:normal:agenda.jsp?checkAvail=true:gfFlat" id="[<%=year5%>,<%=month5%>]:normal:agenda.jsp?checkAvail=true:gfFlat" src="calendar/calendar2.htm" scrolling="no" frameborder="0"></iframe></td>
				<td>&nbsp;</td>
				
			</tr>		
		</table>	