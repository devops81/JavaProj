// JScript File

var formattedDate;
var olAppointmentItem = 1; //fixed for different properties of outlook object
var objOutlook;


function exportEvents(eventList)
{
    try
    {
    		var objOutlook = new ActiveXObject( "Outlook.Application" );
    }
    catch(e)
    {
     		alert("Sorry, you have either not have not enabled Active X or this machine currently does not have outlook available.");
     		return false;
    }
    var duration = 120; //number of minutes (duration in Outlook being in minutes)

    var event = eventList.split("|");
    for(i = 0; i < event.length -1; i++)
    {
         var eventDetails = event[i].split("-");
         formattedDate = eventDetails[0] + "/" + eventDetails[1] + "/" + eventDetails[2] + " " + eventDetails[3];
         var objAppointment = objOutlook.CreateItem(olAppointmentItem);

         objAppointment.Subject = eventDetails[5];
         objAppointment.Body = "This is an appointment being exported into Outlook using a KOL Management web-application. \n\nMedical Meeting Description: " + eventDetails[6] ;
         objAppointment.Start = formattedDate;
         objAppointment.Duration = eventDetails[4];
         objAppointment.ReminderSet = false;
         objAppointment.Save();
     }
     alert("The medical meetings for the month are exported to your Outlook Calendar. Please check for details"); 
}
