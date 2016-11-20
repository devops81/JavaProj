package com.openq.utils;

import com.openq.kol.InteractionsDTO;
import com.openq.user.User;

import java.util.HashMap;

public class PlanNotificationEmail {


    public InteractionsDTO interactionsDTO;
    public User u;
    public HashMap activityHash;

    private String header = "<Html><Title>Plan Notification Mail</Title><Body><font size=2 face=\"Verdana\">";

    private String part1= "";
    private String part2 = "";

    private String part8 =  "<br>"
            + "<br>Thank You.<br><br>openQ KOL Management System<br><br>";
            /*+ "Please Click on one of the button:"
               + "<form action='" + baseURL + "updateEventStatus.htm'>"
               + "<input type='hidden' name='attendeeId' value='" + attendeeId + "'/>"
               + "<input type='hidden' name='status' value='Accepted'/>"
               + "<input name='accept' type='Submit' value='Accept'/></form>";*/

    private String part9 ="<br> ";

    private String part10="</font></Body></html>";



    public String returnCompleteHTMLString()
    {
        StringBuffer html=new StringBuffer();
        part1= "Dear  " + interactionsDTO.getOwner() + ",";
        String act = "";
        act = (String) activityHash.get(interactionsDTO.getActivity());
        if (act != null && act.equals(""))
            act = "an Activity";


        // We would like to infrom you that Nichols, Craighas existing plan of action has been updated with a new activity: Activity Name: New developments in oncology  Activity Date: 07/31/07


        if ( u != null)
            part2= "We would like to infrom you that " + u.getLastName() + ", " + u.getFirstName() + " existing plan of action has been updated with a new activity: Activity Name: "+ act +" in oncology  Activity Date " + interactionsDTO.getDueDate() + ".  Please access the system to see more details.";
        else
              part2= "An expert has request consideration for "+ act +" due on " + interactionsDTO.getDueDate() + ".  Please access the system to see more details.";

        System.out.println(part2);
        html.append(header);
        html.append(part1);
        html.append("");
        html.append(part2);
        html.append(part8);
        html.append(part9);
        html.append(part10);

        return(html.toString());
    }

}
