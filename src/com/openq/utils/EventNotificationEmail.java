package com.openq.utils;

import com.openq.event.EventEntity;

import java.io.FileWriter;
import java.text.SimpleDateFormat;

public class EventNotificationEmail {

    public String eventName;
    public String eventDate;
    public String description;
    public String activity;
    public String therapy;
    public String status;
    public String kolName;
    public EventEntity event;
    public String contactName=PropertyReader.getInstance().getServerConstantValueFor("DemoContactLastName") + ", " + PropertyReader.getInstance().getServerConstantValueFor("DemoContactFirstName");
    public long attendeeId;

    private String generateHtmlString()
    {

        StringBuffer sb = new StringBuffer();
        sb.append("<html> ");
        sb.append("<head> ");
        sb.append("<title>Event Notification</title> ");
        sb.append("<style type=\"text/css\"> ");
        sb.append("<!--    ");
        sb.append("body,td,th {");
        sb.append("font-family: Verdana, Arial, Helvetica, sans-serif; ");
        sb.append("font-size: 14px;    ");
        sb.append("}  ");
        sb.append(".style4 {color: #0099FF; font-weight: bold; font-size: small; } ");
        sb.append(".style5 {font-size: 14px}   ");
        sb.append(".style6 {font-size: 12px} ");
        sb.append(".style7 {font-weight: bold; color: #0099FF;}   ");
        sb.append("--> ");
        sb.append("</style> ");
        sb.append("</head> ");

        sb.append("<body> ");
        sb.append("<table width=\"58%\" border=\"0\" align=\"center\"> ");

        sb.append("<tr> <td height=\"51\" colspan=\"7\"> <img border=\"0\" src=\"").append("/images/e-mail.JPG").append("\" width=\"915\" height=\"175\"></td> </tr>");
        sb.append("<tr> ");
        sb.append("<td height=\"73\">&nbsp;</td> ");
        sb.append("<td colspan=\"4\" height=\"73\"> ");
        sb.append("<img src=\"" + "/images/logo.jpg\" width=\"147\" height=\"68\" /></td>  ");
        sb.append("<td width=\"40\" height=\"73\">&nbsp;</td> ");
        sb.append("</tr> ");
        sb.append("<tr>  ");
        sb.append("<td rowspan=\"8\">&nbsp;</td> ");
        sb.append("<td width=\"450\" valign=\"top\"><p><strong>  ");
        sb.append("<font size=\"2\">Dear Dr. ").append(kolName).append(" </font> ");
        sb.append("</strong><font size=\"2\">,<br /> ");
        sb.append("</font>  ");
        sb.append("<span class=\"style6\"> <font size=\"2\"><BR/>You have been invited to an Event at openQ. <br/>  ");
        sb.append("<BR/>The event details are:</font></span></p>  ");
        sb.append("</td>  ");
        sb.append("<td width=\"25\" rowspan=\"9\" valign=\"top\" bgcolor=\"#f8f3ef\">&nbsp;</td>   ");
        sb.append("<td width=\"260\" rowspan=\"9\" valign=\"top\" bgcolor=\"#f8f3ef\">    ");
        sb.append("<p><span class=\"style4\"> <span class=\"style5\">Your Response</span> </span><br /> ");
        sb.append("<br /> ");
        sb.append("<span class=\"style6\">Please note that in providing acceptance you&nbsp; are stating that you:</span></p> ");
        sb.append("<p><span class=\"style6\">Confirm that to the of your knowledge, the information which you have provided confirms attendance.<br /> ");
        sb.append("<br /> ");
        sb.append("Thank You.<br /> ");
        sb.append("<br />  ");
        sb.append("To accept this invitation, please click");
        sb.append("here:<br /> ");
        sb.append("<br />  ");

        sb.append("<a target='_acceptDecline' href='").append("/updateEventStatus.htm?attendeeId=").append(attendeeId)
                  .append("&status=Accepted&securityKey=_82614183sdjhXSHDGS3873'><span class=\"style7\">Yes, I am interested in '<b><i>")
                  .append(eventName).append("</i></b>' and would like to attend. </span></a><p>");

        sb.append("<br />   ");

        sb.append("<a target='_acceptDecline' href='").append("/updateEventStatus.htm?attendeeId=")
        .append(attendeeId).append("&status=Declined&securityKey=_82614183sdjhXSHDGS3873'><span class=\"style7\">Sorry, I can't make it to the event</span></span><br />");

        sb.append("<td width=\"28\" rowspan=\"7\" valign=\"top\" bgcolor=\"#f8f3ef\"><p><span class=\"style4\"> <br /> ");
        sb.append("  &nbsp;</span></p>   ");
        sb.append("<p><span class=\"style4\"> <span class=\"style5\">&nbsp;</span></span><br /> ");
        sb.append("</p></td> ");
        sb.append("<td rowspan=\"7\" valign=\"top\">&nbsp;</td> ");
        sb.append(" </tr>");

        sb.append("<tr> ");
        sb.append("<td valign=\"top\"><span class=\"style6\"><strong><font size=\"2\">Title</font></strong><font size=\"2\">:</font><span class=\"style7\"><font size=\"2\"> ");
        sb.append(event.getTitle()).append(" </font>");
        sb.append("</span></span></td>");
        sb.append("</tr>");


        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        sb.append("<tr><td valign=\"top\"><strong><font size=\"2\"><br /></font>");
        sb.append("<span class=\"style6\"><font size=\"2\">Event Date: </font> <span class=\"style7\">  ");
        sb.append("<font size=\"2\">").append(sdf.format(event.getEventdate())).append("</font> </span></span></strong></td> ");
        sb.append("</tr>");


        sb.append("<tr><td valign=\"top\"><strong><font size=\"2\"><br /></font>");
        sb.append("<span class=\"style6\"><font size=\"2\">Event Timings: </font> <span class=\"style7\">  ");
        sb.append("<font size=\"2\">").append(event.getStartTime()).append("-").append(event.getEndTime()).append("</font> </span></span></strong></td> ");
        sb.append("</tr>");

        sb.append("<tr> <td valign=\"top\"><strong><font size=\"2\"><br /> </font> ");
        sb.append("<span class=\"style6\"><font size=\"2\">Type: </font><span class=\"style7\"><font size=\"2\">");
        sb.append(event.getEvent_type().getOptValue() + " </font> ");
        sb.append("</span></span></strong></td>");
        sb.append("</tr>");

        sb.append("<tr><td valign=\"top\"><strong><font size=\"2\"><br /></font>");
        sb.append("<span class=\"style6\"><font size=\"2\">Location: </font> <span class=\"style7\">  ");
        sb.append("<font size=\"2\">").append(event.getCity() == null? "N.A.":event.getCity()).append(", " + event.getState().getOptValue()).append("</font> </span></span></strong></td> ");
        sb.append("</tr>");


        sb.append("<tr>  ");
        sb.append("<td valign=\"top\"><strong><font size=\"2\"><br /> ");
        sb.append("</font>   ");
        sb.append("<span class=\"style6\"><font size=\"2\">Role: </font><span class=\"style7\"><font size=\"2\">");

        sb.append("Speaker </font> </span></span></strong></td>");
        sb.append("</tr> ");
        sb.append("<tr>  ");
        sb.append("<td valign=\"top\"><span class=\"style6\"><strong><font size=\"2\"><br /> ");
        sb.append("Company Contact: </font><span class=\"style7\"><font size=\"2\">").append(contactName);
        sb.append("</font> </span></strong></span></td>");
        sb.append("</tr>");
        sb.append("<tr> ");
        sb.append("<td>&nbsp;</td> ");
        sb.append("<td valign=\"top\">&nbsp;</td> ");
        sb.append("</tr> ");
        sb.append("<tr>  ");
        sb.append("<td>&nbsp;</td> ");
        sb.append("<td colspan=\"4\">&nbsp;&nbsp; ");
        sb.append("<font color=\"#99CCFF\" size=\"1\">Copyright @ 2007 OpenQ. All Rights Reserved. | Contact Us | www.openq.com</font>&nbsp;&nbsp; ");
        sb.append("<img border=\"0\" src=\"" + "/images/logo1.gif\" width=\"60\" height=\"30\"></td> ");
        sb.append("<td>&nbsp;</td> ");
        sb.append("</tr>  ");
        sb.append("</table> ");
        sb.append("</body> </html> ");
        return sb.toString();
    }


    public String returnCompleteHTMLString()
    {
        return(generateHtmlString());
    }

}
