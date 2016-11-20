package com.openq.utils;

import com.openq.event.EventEntity;

public class EventNotificationEMailForContact {

    public String eventName;

    public String eventDate;

    public String description;

    public String activity;

    public String therapy;

    public String status;

    public String kolName;

    public String kolPhotoName;

    public String eventOwner;

    public String contactName= PropertyReader.getInstance().getServerConstantValueFor("DemoContactFirstName") + " " + PropertyReader.getInstance().getServerConstantValueFor("DemoContactLastName");

    public String eventType;

    public String city;

    public String state;

    public String therapeuticArea;

    public EventEntity event;

    private String generateHtml()
    {
        String logo = "/images/logo.jpg";

        StringBuffer sb = new StringBuffer();

        String p =  "/photos/" + kolPhotoName;
        sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
        sb.append("<html xmlns=\"http://www.w3.org/1999/xhtml\">");
        sb.append("<head> ");
        sb.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" /> ");
        sb.append("<title>Email Notification Document</title>");
        sb.append("<style type=\"text/css\">");

        sb.append("body,td,th {");
	    sb.append("font-family: Verdana, Arial, Helvetica, sans-serif;");
	    sb.append("font-size: 12px;");
        sb.append("}");
        sb.append(".style2 {");
	    sb.append("color: #0099FF;");
	    sb.append("font-weight: bold;");
        sb.append("}");
        sb.append(".style3 {font-size: small}");
        sb.append(".style4 {color: #0099FF; font-weight: bold; font-size: 14px; }");
        sb.append(".style5 {font-size: 12px}");
        sb.append(".style6 {color: #0099FF; font-weight: bold; font-size: 12px; }");
        sb.append("</style>");
        sb.append("</head>");
        sb.append("<body bgcolor=\"#f4f8f9\"> ");
        sb.append("<table width=\"100%\" bgcolor=\"#f4f8f9\">");
        sb.append("<TD>");
        sb.append("<table width=\"80%\" align=\"center\" >");
        sb.append("<td bgcolor=\"#ffffff\">");
        sb.append("<table width=\"90%\" border=\"0\" align=\"center\" > ");
        sb.append("<tr> <td height=\"51\" colspan=\"3\"> <img border=\"0\" src=\"").append("/images/e-mail.JPG").append("\" width=\"915\" height=\"175\"></td> </tr>");
        sb.append("<tr>");
        sb.append("<td colspan=\"3\" height=\"51\"><img src=\"").append(logo).append("\" width=\"142\" /></td>");
        sb.append("<td height=\"51\">&nbsp;</td>");
        sb.append("<td width=\"18%\" height=\"51\">&nbsp;</td>");
        sb.append("</tr>");
        sb.append("<tr>  ");
        //sb.append("<td height=\"160\">&nbsp;</td>");
        sb.append("<td colspan=\"4\" rowspan=\"3\" valign=\"top\" bgcolor=\"#f8f3ef\"> ");
	    sb.append("<table bgcolor=\"#f8f3ef\" height=\"407\">");
        sb.append("<tr>  ");
        sb.append("<td colspan=\"3\" valign=\"top\" bgcolor=\"#f8f3ef\"><span class=\"style6\"> ");
	    sb.append("<font size=\"2\">Dear ").append(contactName).append("</font></span><p> ");
	    sb.append("<span class=\"style5\">You have been listed as the contact for <font color=\"#0099FF\">&nbsp; Dr. ").append(kolName).append(".</font><br /><br/> ");
        sb.append("The purpose of this email is to inform you that ").append(kolName).append(" has been requested <br />  ");
        sb.append("to the following event.</span></p> ");
	    sb.append("<p>&nbsp;</td> ");
        sb.append("</tr> ");
        sb.append("<tr> ");
        sb.append("<td colspan=\"3\" valign=\"top\" bgcolor=\"#f8f3ef\"><span class=\"style6\"> ");
	    sb.append("<font size=\"2\">Event:</font>&nbsp; <font color=\"#000000\">").append(event.getTitle()).append("&nbsp;&nbsp; | ").append(eventDate).append("</font></span></td> ");
        sb.append("</tr> ");
        sb.append("<tr> ");
        sb.append("<td width=\"342\" valign=\"top\" bgcolor=\"#f8f3ef\">  ");
	    sb.append("<p class=\"style3\">");
	    sb.append("<span class=\"style6\"><font size=\"2\">Description: </font> </span><font size=\"2\">  ");
	    sb.append(event.getDescription()==null? "N.A.": event.getDescription());
	    sb.append("</font></p> ");
        sb.append("<p class=\"style3\"><span class=\"style2\"><font size=\"2\">Event Creator: ");
		sb.append("</font> </span><font size=\"2\">").append(eventOwner).append(" </font> </p> ");
        sb.append("<p class=\"style3\"><span class=\"style2\"><font size=\"2\">Type: </font> </span> ");
		sb.append("<font size=\"2\">").append(event.getEvent_type().getOptValue()).append("</font></p> ");
        sb.append("<p class=\"style3\"><span class=\"style2\"><font size=\"2\">City: </font></span><font size=\"2\">");
        sb.append(event.getCity() == null? "N.A.":event.getCity()).append(", " + event.getState().getOptValue()).append("</font></p> ");
        sb.append("<p class=\"style3\"><span class=\"style2\"><font size=\"2\">Role: </font> </span> ");
		sb.append("<font size=\"2\">Speaker</font></p> ");
        sb.append("<p class=\"style3\"><strong><span class=\"style2\"><font size=\"2\">Contact</font></span><font size=\"2\">:  ");
		sb.append("</font></strong><font size=\"2\">").append(event.getOwner()).append("</font> </p> ");
        sb.append("</td>   ");
        sb.append("<td width=\"121\" valign=\"top\" bgcolor=\"#f8f3ef\"><span class=\"style3\"><br /> ");
        sb.append("  <img src=\"").append(p).append("\" width=\"121\" height=\"126\" /><br />  ");
        sb.append("  &nbsp;</span></td> ");
        sb.append(" <td width=\"162\" valign=\"top\" bgcolor=\"#f8f3ef\"><p class=\"style6\"><br /> ");
        sb.append("    <br />  Dr.  ");
        sb.append(kolName + "<br /> ");
        sb.append("Boston, MA </p></td> ");
        sb.append("</tr></table> &nbsp;&nbsp;&nbsp; ");
	    sb.append("<font color=\"#99CCFF\" size=\"1\">Copyright @ 2007 OpenQ. All Rights Reserved. | Contact Us | www.openq.com</font>&nbsp;&nbsp; ");
	    sb.append("<img border=\"0\" src=\"" + "/images/logo1.gif\" width=\"60\" height=\"30\"></td>   ");
        sb.append("</tr> ");
        sb.append("<tr>");
        sb.append("<td>&nbsp;</td>   ");
        sb.append("</tr> ");
        sb.append("<tr> ");
        sb.append("<td width=\"11%\">&nbsp;</td> ");
        sb.append("</tr> ");
        sb.append("<tr> ");
        sb.append("<td height=\"23\">&nbsp;</td> ");
        sb.append("<td colspan=\"3\" height=\"23\">&nbsp;</td>  ");
        sb.append("<td height=\"23\">&nbsp;</td> ");
        sb.append("</tr> ");
        sb.append("</table> ");
        sb.append("</td> ");
        sb.append("</table> ");
        sb.append("</TD>  ");

        sb.append("</TABLE> ");
        sb.append("</body>  ");
        sb.append("</html>");

        return sb.toString();
    }

    public String returnCompleteHTMLString()
    {
        return  generateHtml();
    }


}
