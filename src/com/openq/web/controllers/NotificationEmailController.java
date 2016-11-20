package com.openq.web.controllers;

import java.io.FileOutputStream;
import java.io.PrintStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.utils.EventNotificationMailSender;

public class NotificationEmailController extends AbstractController
{

	String fname = "", lname = "", prefix = "Dr. ";

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
													HttpServletResponse res)
																			throws Exception
	{

		System.out.println("We are in NotifyUpdateController");
		// long attributeId = Long.parseLong(request.getParameter("attributeId"));
    String attributeIdString = request.getParameter("attributeId");
    String kolName = request.getParameter("currentKOLName");
    String[] names = kolName.split(", ");
    lname = names[0];
    fname = names[1];

    if(attributeIdString!=null&&!attributeIdString.equals(""))
    {
      try
      {
        
        AttributeType attr = metadataService.getAttributeType(Long.parseLong(attributeIdString.trim()));
        if(attr!=null)
        {
          System.out.println(attr.getName()+"Name of The tab\n");     
          String htmlString = generateHtmlString(attr.getName());
          //createFile(htmlString);
          EventNotificationMailSender eventMail = new EventNotificationMailSender();
          eventMail.send(htmlString);
        }
      }
      catch (Exception e)
      {      
         System.out.println(e.getMessage());
      }
    }
    else
    {
      
      String htmlString = generateHtmlString(" Profile tab");
      //createFile(htmlString);
      EventNotificationMailSender eventMail = new EventNotificationMailSender();
      eventMail.send(htmlString);
    
    }
    
    // AttributeType[] attributes = metadataService.getAllShowableAttributes(entityType);
		// for(int i=0;i<attributes.length;i++)
		// System.out.println("Showable Attributes "+i+" : "+attributes[i].getName());
		//
		// HashMap valueMap = new HashMap();
		// ArrayList values = new ArrayList();
		//		
		// for (int i = 0; i < attributes.length; i++) {
		// System.out.println(" The attribute Id is: "+ attributes[i].getAttribute_id());
		//			
		// if (attributes[i].getType() == EavConstants.STRING_ID) {
		// StringAttribute str = dataService.getStringAttribute(
		// entityId, attributes[i].getAttribute_id());
		// valueMap.put(attributes[i],(str==null?"":str.toString()));
		//				
		// }
		// if (attributes[i].getType() == EavConstants.DATE_ID)
		// values.add("");
		//			
		// if (attributes[i].getType() == EavConstants.BOOLEAN_ID)
		// values.add("");
		//			
		// }
		//		
		//		
		// String htmlString = generateHtmlString(entityType, valueMap,
		// parentAttribute);


		
		return (new ModelAndView("notificationEmailSuccessView"));
	}

	private String generateHtmlString(String tabName)
	{

		StringBuffer sb = new StringBuffer();
		sb.append("<html> ");
		sb.append("<head> ");
		sb.append("<title>Expert Profile Details Edited Notification</title> ");
		sb.append("</head> ");
		sb.append("<body> ");
		sb
				.append("Dear Recipient,<br><br>This is an auto generated email to notify you the <font color='#006699'>"
						+ tabName + "</font> tab of");
		sb
				.append(" <font color='#006699'>"
						+ prefix
						+ " "
						+ fname
						+ " "
						+ lname
						+ "</font> profile has been edited.<br><br>Please log onto the application for the details.");
		sb.append("<br><br><br>Thanks,<br>Administrator");
		return sb.toString();
	}

	/**
	 * Utility method to locally save the html string as a .htm file and see the preview of email template.
	 * 
	 * @param htmlString
	 */
	private void createFile(String htmlString)
	{
		FileOutputStream out; // declare a file output object
		PrintStream p; // declare a print stream object

		try {
			// Create a new file output stream
			// connected to "myfile.txt"
			out = new FileOutputStream("d:\\emailTemplate.htm");

			// Connect print stream to the output stream
			p = new PrintStream(out);

			p.println(htmlString);
			System.out.println("The file is created");

			p.close();
		} catch (Exception e) {
			System.err.println("Error writing to file");
		}
	}

	//	
	// private String generateHtmlString(long entityType, HashMap valueMap,
	// AttributeType parentAttr)
	// {
	//		
	// StringBuffer sb = new StringBuffer();
	// sb.append("<html> ");
	// sb.append("<head> ");
	// sb.append("<title>Expert Profile Details Edited Notification</title> ");
	// sb.append("</head> ");
	// sb.append("<body> ");
	// sb.append("Dear Otavio,<br>&nbsp;&nbsp;This is an auto generated email to notify you the profile of");
	// sb.append(" <font color='#006699'>"+prefix+" "+fname+" "+lname+"</font> has been edited.<br><br><br><br>");
	// sb.append("<table width=\"58%\" border=\"0\" align=\"left\"> ");
	// sb.append("<tr><B>").append(parentAttr.getName())
	// .append("</B><hr></tr>");
	// Iterator itr = valueMap.keySet().iterator();
	// while (itr.hasNext()) {
	// AttributeType key = (AttributeType) itr.next();
	// sb.append("<tr>");
	// sb.append("<td ><font color='#006699'>").append(key.getName()).append("</font></td>");
	// sb.append("<td>").append((String) valueMap.get(key))
	// .append("<br></td>");
	// sb.append("</tr>");
	//			
	// }
	// sb.append("</table> ");
	// sb.append("</body> </html> ");
	// return sb.toString();
	// }

	IDataService dataService;

	IMetadataService metadataService;

	public IDataService getDataService()
	{
		return dataService;
	}

	public void setDataService(IDataService dataService)
	{
		this.dataService = dataService;
	}

	public IMetadataService getMetadataService()
	{
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService)
	{
		this.metadataService = metadataService;
	}

}
