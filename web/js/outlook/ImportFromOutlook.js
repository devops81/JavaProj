// JScript File

var formattedDate;
var timeOfAppointment;
var outlookFolderCalendar = 9; //fixed for different properties of outlook object

function GetOutloookAppointments()
{       
    try
    {
        var objOutlook = new ActiveXObject( "Outlook.Application" );
    }
    catch(e)
    {
        alert("Outlook needs to be installed on the machine for data to export.");
        return false;
    }    
    var objNameSpace  = objOutlook.GetNamespace("MAPI");
    var outlookFolder =  objNameSpace.GetDefaultFolder(outlookFolderCalendar);
    var myOutlookItems = outlookFolder.Items    
          
    if(myOutlookItems.Count > 0)    
    {
        var dateOfAppointment = myOutlookItems(1).Start;
        var subjectOfAppointment = myOutlookItems(1).Subject;
        var bodyOfAppointment = myOutlookItems(1).Body;
        var durationOfAppointment = myOutlookItems(1).Duration;        
            
        SetFormattedDate(dateOfAppointment);
        alert("FIRST of the Imported Appointment(s) from your Outlook:\n \n Date:"+formattedDate+"\n Time:"+timeOfAppointment+"\n Subject:"+subjectOfAppointment+"\n Body:"+bodyOfAppointment+"\n Duration(min):"+durationOfAppointment);
        return true;
    }
    else
    {
        alert("No appointment was found in your Outlook.");
        return false;
    }
}

function SetFormattedDate(dateToFormat)
{
    var useDate = new Date(dateToFormat);     
    formattedDate =  useDate.toDateString();
    timeOfAppointment = useDate.toTimeString();
}