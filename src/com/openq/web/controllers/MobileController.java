package com.openq.web.controllers;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.BaseCommandController;

import com.openq.attendee.Attendee;
import com.openq.attendee.IAttendeeService;
import com.openq.eav.data.BooleanAttribute;
import com.openq.eav.data.DateAttribute;
import com.openq.eav.data.EavTableRowComparator;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.NumberAttribute;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.expert.IExpertListService;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.eav.option.OptionLookup;
import com.openq.interaction.IInteractionService;
import com.openq.interaction.Interaction;
import com.openq.interactionData.IInteractionDataService;
import com.openq.interactionData.InteractionData;
import com.openq.user.IUserService;
import com.openq.user.User;


/**
 * This class is used to handle all requests that are sent by the mobile client
 * 
 * @author Amit Arora 
 */
public class MobileController extends BaseCommandController {
		
	private static Logger logger = Logger.getLogger(MobileController.class);
	
	private IUserService userService;
	private IDataService dataService;
	private IMetadataService metadataService;
	private IExpertListService expertlistService;
	private IInteractionService interactionService;
	private IAttendeeService attendeeService;
	private IOptionServiceWrapper optionServiceWrapper;
	private IInteractionDataService interactionDataService;

	private DataAccessor dataAccessor;
	private DataTransformer dataTransformer;	
	
	public MobileController() {
		dataAccessor = new DataAccessor();
		dataTransformer = new DataTransformer();
	}
	
	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public IExpertListService getExpertlistService() {
		return expertlistService;
	}

	public void setExpertlistService(IExpertListService expertlistService) {
		this.expertlistService = expertlistService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}
	
	public IInteractionDataService getInteractionDataService() {
		return interactionDataService;
	}

	public void setInteractionDataService(
			IInteractionDataService interactionDataService) {
		this.interactionDataService = interactionDataService;
	}
	
	public DataAccessor getDataAccessor() {
		return dataAccessor;
	}

	public DataTransformer getDataTransformer() {
		return dataTransformer;
	}

	/**
	 * This routine is used to handle incoming requests from the mobile clients
	 */
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String action = req.getParameter("action");
		String userGroupIdString = (String) req.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);
		if(action.equals("expProfile")) {
			String expertName = req.getParameter("expName");
			
	
			logger.debug("Retrieving profile for expert : " + expertName);
			
			// The client would replace all spaces with underscores, so convert them back to spaces
			String name = expertName.replace('_', ' ');
			
			try {
				User expert = dataAccessor.getExpertWithName(name);
				String xmlProfile = dataTransformer.getXMLProfileForExpert(expert);
				byte[] profileBytes = xmlProfile.getBytes();
				
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				DataOutputStream dos = new DataOutputStream(baos);
				
				dos.write(profileBytes);
				
				byte[] data = baos.toByteArray();
				
				res.setStatus(HttpServletResponse.SC_OK);
				res.setContentLength(data.length);
				res.setContentType("application/octet-stream");
				
				OutputStream os = res.getOutputStream();
				os.write(data);
				os.close();
				
				logger.debug("Sent expert profile : " + expertName + " to client");
			}
			catch(Exception e) {
				res.setStatus(HttpServletResponse.SC_NO_CONTENT);
			}
		}
		else if(action.equals("submitInteraction")) {
			try {
				String attendee = req.getParameter("attendee");
				long dateTime = Long.parseLong(req.getParameter("date"));
				long staffId = Long.parseLong(req.getParameter("staffId"));
				Date d = new Date(dateTime);
				String interactionType = req.getParameter("interactionType");
				String scientificTopic = req.getParameter("scientificTopic");
				
				logger.debug("Adding interaction: " + interactionType + " with expert: " + attendee + " on " + d);
				
				// Submit the interaction to the backend
				dataAccessor.submitInteraction(staffId, interactionType, dateTime, attendee, scientificTopic,userGroupId);
				
				String respString = "Success";
				
				res.setContentType("text/plain");
			    res.setContentLength(respString.length());
				PrintWriter out = res.getWriter();
	
				out.println(respString);
				out.close();
				
				logger.debug("Successfully submitted interaction");
			}
			catch(Exception e) {
				res.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
			}
		}		
		else if(action.equals("updatedExpertList")) {
			try {

				String staffId = req.getParameter("staffId");
				
				logger.debug("Getting expert list for staff id : " + staffId);
				
				if((staffId != null) && (!staffId.trim().equals(""))) {
					String myExpertList = dataAccessor.getOLListForStaff(staffId);
					
					res.setContentType("text/plain");
				    res.setContentLength(myExpertList.length());
					PrintWriter out = res.getWriter();
		
					out.println(myExpertList);
					out.close();
					
					logger.debug("Sent expert list for staff id : " + staffId);
				}
				else {
					res.setStatus(HttpServletResponse.SC_NO_CONTENT);
				}
			}
			catch(Exception e) {
				res.setStatus(HttpServletResponse.SC_NO_CONTENT);
			}
		}
		
		return null;
	}

	public IAttendeeService getAttendeeService() {
		return attendeeService;
	}

	public void setAttendeeService(IAttendeeService attendeeService) {
		this.attendeeService = attendeeService;
	}

	public IInteractionService getInteractionService() {
		return interactionService;
	}

	public void setInteractionService(IInteractionService interactionService) {
		this.interactionService = interactionService;
	}

	public IOptionServiceWrapper getOptionServiceWrapper() {
		return optionServiceWrapper;
	}

	public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
		this.optionServiceWrapper = optionServiceWrapper;
	}
	
	/**
	 * This inner class is used to encapsulate all interaction with the existing
	 * webapp to retrieve EAV/other data
	 * 
	 * @author Amit
	 */
	public class DataAccessor {
		/**
		 * This routine is used to get the list of OLs who are assigned to the 
		 * specified staff member
		 * 
		 * @param staffId
		 * @return
		 */
		public String getOLListForStaff(String staffId) {
			User[] experts = expertlistService.getOLFromContacts(staffId);
			
			String myExpertList = "";
			
			for(int i=0; i<experts.length; i++) {
				myExpertList += experts[i].getFirstName().trim() + " " +experts[i].getLastName().trim() + "|" + experts[i].getLastUpdateTime();
				if(i != (experts.length - 1))
					myExpertList += ",";
			}
			
			return myExpertList;
		}
		
		/**
		 * This routine is used to submit a new interaction using the specified data 
		 * 
		 * @param staffId
		 * @param interactionType
		 * @param date
		 * @param attendees
		 * @param scientificTopic
		 * 
		 * @return
		 * 
		 * @throws Exception
		 */
		public long submitInteraction(long staffId, String interactionType, long date, String attendees, String scientificTopic,long userGroupId) throws Exception {
			Interaction interaction = null;
			try {
				User[] matchingStaff = userService.getUserForStaffId("" + staffId);
				if(matchingStaff.length == 0)
					throw new IllegalArgumentException("Couldn't find user with staffId : " + staffId);
				
				User staffUser = matchingStaff[0];
				
				logger.debug("Found user id : " + staffUser.getId());
				
				// The mobile client replaces spaces with _ while submitting, so replace those back
				interactionType = interactionType.replaceAll("_", " ");
							
				// Set the interaction type
				OptionLookup interactionTypeOption = getOptionLookupForValue("Interaction Type", interactionType,userGroupId);
				if(interactionTypeOption == null) {
					throw new IllegalArgumentException("Invalid interaction type : " + interactionType);
				}
				
				logger.debug("Found interaction type : " + interactionType);
				
				
				// Identify the attendee list
				StringTokenizer st = new StringTokenizer(attendees, ",");
				ArrayList attendeeList = new ArrayList();
				
				while(st.hasMoreTokens()) {
					// The mobile client replaces space with "_" while submitting, so replace that
					attendeeList.add(st.nextToken().trim().replaceAll("_", " "));
				}

				logger.debug("Found : " + attendeeList.size() + " attendees");
				
				String[] kolIdList = null;
				if (attendeeList != null && attendeeList.size() > 0) {
					kolIdList = new String[attendeeList.size()];
					String attendeeName = null;
					for (int l = 0; l < attendeeList.size(); l++) {
						attendeeName = (String) attendeeList.get(l);
						
						// Get the user with the given name
						User expert = getExpertWithName(attendeeName);
						
						kolIdList[l] = "" + expert.getId();
					}
				}
				
				// Find the scientific topic
				// Replace the "_" inserted by the client with " "
				scientificTopic = scientificTopic.replaceAll("_", " ");
				
				// TODO: Do not use any hard-coded field names
				// The field names are present in multiple Java classes, properties files and config files
				// thereby causing huge confusion
				OptionLookup scientificTopicOption = getOptionLookupForValue("Scientific Topics", scientificTopic,userGroupId);
				if(scientificTopicOption == null) {
					throw new IllegalArgumentException("Invalid scientific topic : " + scientificTopic);
				}
				
				logger.debug("Found the scientific topic : " + scientificTopic);
				
				// Now create the interaction object and set various fields on it
				interaction = new Interaction();
				interaction.setUserId(staffUser.getId());
				interaction.setStaffId(staffId);
				interaction.setType(interactionTypeOption);
				interaction.setInteractionDate(new Date(date));
				interaction.setKolIdArr(kolIdList);
				interaction.setCreateTime(new Date(System.currentTimeMillis()));
				interaction.setUpdateTime(new Date(System.currentTimeMillis()));
				interaction.setDeleteFlag("N");
				
				interactionService.saveInteraction(interaction);
				
				logger.debug("Saved interaction with basic attributes");
				
				// Update the attendee list
				// Check if this is done later in order to pick up the new interaction id?
				Attendee[] attendeeArr = new Attendee[attendeeList.size()];
				if (attendeeList != null && attendeeList.size() > 0) {
					String attendeeName = null;
					Attendee attendee = null;
					for (int l = 0; l < attendeeList.size(); l++) {
						attendeeName = (String) attendeeList.get(l);
						
						
						// Get the user with the given name
						User expert = getExpertWithName(attendeeName);
						
						// Create an Attendee object
						attendee = new Attendee();
						attendee.setAttendeeType(Attendee.KOL_ATTENDEE_TYPE);
						attendee.setUserId(expert.getId());
						attendee.setName(attendeeName);
						attendee.setInteraction(interaction);
						
						attendeeArr[l] = attendee;
					}
				}
				attendeeService.updateAttendees(interaction.getId(), attendeeArr);
				
				logger.debug("Updated attendees on the interaction");
				
				
				InteractionData interactionData = new InteractionData();
				interactionData.setLovId(scientificTopicOption);
				interactionData.setType("Scientific Topics"); // There is a bug in the Alpharma deployment, hence hard-coding the type
				interactionData.setInteraction(interaction);
				
				interactionDataService.saveInteractionData(interactionData);
				
				logger.debug("Saved scientific topic");
							
				return interaction.getId();
				
			}
			catch(Exception e) {
				e.printStackTrace();
				throw e;
			}
		}
		
		/**
		 * This routine is used to get the OptionLookup object that is of the type
		 * optionName and has the specified value
		 */
		private OptionLookup getOptionLookupForValue(String optionName, String value,long userGroupId) {
			OptionLookup options[] = optionServiceWrapper.getValuesForOptionName(optionName,userGroupId);
			if (options != null && options.length > 0) {
				OptionLookup lookup = null;
				for (int i = 0; i < options.length; i++) {
					lookup = options[i];
					if (lookup.getOptValue().trim().equalsIgnoreCase(value)) {
						return lookup;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * This routine is used to get the user object for the expert with the 
		 * specified name
		 * 
		 * @param expertName
		 * @return
		 */
		private User getExpertWithName(String expertName) {
			User[] allExperts = userService.getAllExperts();
			for(int i=0; i<allExperts.length; i++) {
				String name = null;
				if(allExperts[i].getFirstName() != null) {
					name = allExperts[i].getFirstName().trim();
				}
				
				if(allExperts[i].getLastName() != null) {
					if(name != null)
						name = name + " " + allExperts[i].getLastName().trim();
					else
						name = allExperts[i].getLastName().trim();
				}
				
				if((name != null) && (name.equals(expertName))) {
					return allExperts[i];
				}
			}
			
			throw new IllegalArgumentException("No expert found with name : " + expertName);
		}
	}
	
	/**
	 * This inner class is used to transform existing EAV objects into an XML
	 * representation. A String format corresponding to the same can then be
	 * transmitted to the client for synchronization 
	 * 
	 * @author Amit
	 */
	public class DataTransformer {
		private final String[][] specialCharMapping = {{"&", "&amp;"}};
		
		/**
		 * This routine is used to get an XML representation (in String format)
		 * of the profile for the specified expert
		 * 
		 * @param expert
		 * @return
		 */
		public String getXMLProfileForExpert(User expert) {
			StringBuffer buff = new StringBuffer();
			prettyPrint(buff, "<Object>\n", 0);
			EntityAttribute[] entAtt = removeDuplicateAttribs(dataService.getAllEntityAttributes(expert.getKolid()));
			for(int j=0; j<entAtt.length; j++) {
				prettyPrint(buff, "<attribute>\n", 0);
				prettyPrint(buff, "<name>" + entAtt[j].getAttribute().getName() + "</name>\n", 1);
				prettyPrint(buff, "<type>Object</type>\n", 1);
				prettyPrint(buff, "<value>\n", 1);
				printEntityAttribute(entAtt[j], buff, 2);
				prettyPrint(buff, "</value>\n", 1);
				prettyPrint(buff, "</attribute>\n", 0);
			}
			prettyPrint(buff, "</Object>\n", 0);
			
			return escapeSpecialChars(buff.toString());
		}
		
		/**
		 * This routine is used to get the XML representation corresponding to the specified
		 * EntityAttribute and add it to the specified buffer
		 * 
		 * @param attrib
		 * @param buff
		 * @param level
		 */
		private void printEntityAttribute(EntityAttribute attrib, StringBuffer buff, int level) {
			
			/*for(int i=0; i<level; i++)
				System.out.print("\t");
			
			System.out.println("[Entity]: " + attrib.getAttribute().getName() + ", " + attrib.getMyEntity().getType().getEntity_type_id());
			
			AttributeType[] attribDefn = metadataService.getAllAttributes(attrib.getMyEntity().getType().getEntity_type_id());
			
			//System.out.println("Got : " + attribDefn.length + " attributes");
			
			// traverse all attributes 
			for(int i=0; i<attribDefn.length; i++) {
				//System.out.print("Processing attribute : " + attribDefn[i].getName());
				
				if(attribDefn[i].isArraylist()) {
					//System.out.println(" of type arraylist");
					printArrayListAttrib(attrib.getMyEntity().getId(), attribDefn[i].getAttribute_id(), attribDefn[i].getName(), level + 1);
				}
				else if(attribDefn[i].isEntity()) {
					//System.out.println(" of type entity");
					EntityAttribute[] attribObj = dataService.getAllEntityAttributes(attrib.getMyEntity().getId());
					for(int j=0; j<attribObj.length; j++) {
						printEntityAttribute(attribObj[i], level + 1);
					}
				}
				else {
					
					
					String attribType = MetadataUtil.getTypeFromEntityTypeId((int)attribDefn[i].getType(), false);
					if((attribType.equals("Text")) || (attribType.equals("Dropdown"))) {
						StringAttribute stringAttrib = dataService.getAttribute(attrib.getMyEntity().getId(), attribDefn[i].getAttribute_id());
						for(int j=0; j<level; j++)
								System.out.print("\t");
							
						System.out.println(attribDefn[i].getName() + ": " + stringAttrib.getValue());
					}
					else {
						// process other data types over here
						System.out.println("[" + attribType + "] : " + attribDefn[i].getName());
					}
				}
			}*/
			
			/*for(int i=0; i<level; i++)
				System.out.print("\t");
			
			System.out.println("[Entity]: " + attrib.getAttribute().getName() + ", " + attrib.getMyEntity().getType().getEntity_type_id());*/
			
			prettyPrint(buff, "<Object>\n", level);
			
			// First look at all the entity attributes. Print them recursively
			EntityAttribute[] entitySubAttribs = removeDuplicateAttribs(dataService.getAllEntityAttributes(attrib.getMyEntity().getId()));
			
			if(entitySubAttribs != null) {
				for(int i=0; i<entitySubAttribs.length; i++) {
					prettyPrint(buff, "<attribute>\n", level + 1);
					prettyPrint(buff, "<name>" + entitySubAttribs[i].getAttribute().getName() + "</name>\n", level + 2);
					
					if(!entitySubAttribs[i].getAttribute().isArraylist()) {
						prettyPrint(buff, "<type>Object</type>\n", level + 2);
						prettyPrint(buff, "<value>\n", level + 2);
						printEntityAttribute(entitySubAttribs[i], buff, level + 3);
						prettyPrint(buff, "</value>\n", level + 2);
					}
					else {
						prettyPrint(buff,"<type>List</type>\n", level + 2);
						prettyPrint(buff, "<value>\n", level + 2);
						printArrayList(attrib.getMyEntity().getId(), entitySubAttribs[i], buff, level + 3);
						prettyPrint(buff,"</value>\n", level + 2);
					}
					prettyPrint(buff, "</attribute>\n", level + 1);
				}
			}
			
			// Now retrieve all String attributes, and print them
			StringAttribute[] stringSubAttribs = dataService.getStringAttribute(attrib.getMyEntity());
			for(int i=0; i<stringSubAttribs.length; i++) {
				prettyPrintBasicAttrib(buff, level, stringSubAttribs[i].getAttribute().getName(), stringSubAttribs[i].getValue());
			}
			
			// Now retrieve all Boolean attributes, and print them
			BooleanAttribute[] booleanSubAttribs = dataService.getBooleanAttribute(attrib.getMyEntity());
			for(int i=0; i<booleanSubAttribs.length; i++) {
				prettyPrintBasicAttrib(buff, level, booleanSubAttribs[i].getAttribute().getName(), 
													(booleanSubAttribs[i].getValue().booleanValue()?"Yes":"No"));
			}
			
			// Now retrieve all Number attributes, and print them
			NumberAttribute[] numberSubAttribs = dataService.getNumberAttribute(attrib.getMyEntity());
			for(int i=0; i<numberSubAttribs.length; i++) {
				prettyPrintBasicAttrib(buff, level, numberSubAttribs[i].getAttribute().getName(), Long.toString(numberSubAttribs[i].getValue()));
			}
			
			// Now retrieve all Date attributes, and print them
			DateAttribute[] dateSubAttributes = dataService.getDateAttribute(attrib.getMyEntity());
			for(int i=0; i<dateSubAttributes.length; i++) {
				prettyPrintBasicAttrib(buff, level, dateSubAttributes[i].getAttribute().getName(), dateSubAttributes[i].getValue().toString());
			}
			
			prettyPrint(buff, "</Object>\n", level);
		}
		
		/**
		 * This routine is used to print a basic (leaf-node) attribute in the OL profile. The
		 * routine appends attribute data in XML format to the provided buffer. 
		 * 
		 * @param buff
		 * @param level
		 * @param attribName
		 * @param value
		 */
		private void prettyPrintBasicAttrib(StringBuffer buff, int level, String attribName, String value) {
			prettyPrint(buff,"<attribute>\n", level + 1);
			prettyPrint(buff, "<name>" + attribName + "</name>\n", level + 2);
			prettyPrint(buff, "<type>String</type>\n", level + 2);
			prettyPrint(buff, "<value>" + value + "</value>\n", level + 2);
			prettyPrint(buff,"</attribute>\n", level + 1);
		}
		
		/**
		 * This routine is used to get the XML representation corresponding to the EAV
		 * attribute which is of type list and add it to the specified buffer
		 * 
		 * @param parentId
		 * @param attrib
		 * @param buff
		 * @param level
		 */
		private void printArrayList(long parentId, EntityAttribute attrib, StringBuffer buff, int level) {
			/*for(int i=0; i<level; i++)
				System.out.print("\t");
			System.out.println("[ArrayList] : " + attrib.getAttribute().getName() + ", " + attrib.getId());*/
			
			prettyPrint(buff,"<List>\n", level);
			
			EntityAttribute [] entityArray = dataService.getEntityAttributes(parentId, attrib.getAttribute().getAttribute_id());
			
			if(entityArray != null) {
		        for (int i=0; i<entityArray.length; i++) {
		        	EavTableRowComparator comparator = new EavTableRowComparator();
		            comparator.setDataService(dataService);
		            SortedMap map = new TreeMap(comparator);
		            //HashMap map = new HashMap();
		
		            Entity myEntity = entityArray[i].getMyEntity();
		            map.put(entityArray[i], dataService.getAllAttributeValues(myEntity));
		     
		            prettyPrint(buff, "<Object>\n", level + 1);
		            
		            Iterator iter = map.keySet().iterator();
		    		while(iter.hasNext()) {
		    			ArrayList valueList = (ArrayList) map.get(iter.next());
		    			for(int j=0; j<valueList.size(); j++) {
		    				Object subAttrib = valueList.get(j);
		    				if(subAttrib instanceof StringAttribute) {
		    					StringAttribute strAtt = (StringAttribute) subAttrib;
		    					prettyPrintBasicAttrib(buff, level + 1, strAtt.getAttribute().getName(), strAtt.getValue());
		    				}
		    				else if(subAttrib instanceof BooleanAttribute) {
		    					BooleanAttribute boolAtt = (BooleanAttribute) subAttrib;
		    					prettyPrintBasicAttrib(buff, level + 1, boolAtt.getAttribute().getName(), 
		    													(boolAtt.getValue().booleanValue()?"Yes":"No"));
		    				}
		    				else if(subAttrib instanceof NumberAttribute) {
		    					NumberAttribute numAtt = (NumberAttribute) subAttrib;
		    					prettyPrintBasicAttrib(buff, level + 1, numAtt.getAttribute().getName(), 
		    									Long.toString(numAtt.getValue()));
		    				}
		    				else if(subAttrib instanceof DateAttribute) {
		    					DateAttribute dateAtt = (DateAttribute) subAttrib;
		    					prettyPrintBasicAttrib(buff, level + 1, dateAtt.getAttribute().getName(), dateAtt.getValue().toString());
		    				}
		    			}
		    		}
		    		
		    		prettyPrint(buff, "</Object>\n", level + 1);
		        }
			}
			
			prettyPrint(buff, "</List>\n", level);
		}
		
		/**
		 * This is a helper routine that is used to add the specified text to the
		 * buffer, after indenting it to the specified level 
		 * 
		 * @param buff
		 * @param text
		 * @param level
		 */
		private void prettyPrint(StringBuffer buff, String text, int level) {
			for(int i=0; i<level; i++)
				buff.append("    ");
			
			buff.append(text);
		}
		
		/**
		 * This routine is used to remove duplicate attributes of the same type
		 * 
		 * @param attribs
		 * @return
		 */
		private EntityAttribute[] removeDuplicateAttribs(EntityAttribute[] attribs) {
			HashMap listAttribs = new HashMap();
	        
			for(int i=0; i<attribs.length; i++) {
				listAttribs.put(new Long(attribs[i].getAttribute().getAttribute_id()), attribs[i]);
			}
						
			return (EntityAttribute[]) listAttribs.values().toArray(new EntityAttribute[listAttribs.size()]);
		}
		
		/**
		 * This routine is used to escape some special charactes which are not
		 * allowed in XML format. These characters are replaced with their
		 * escaped counterparts.
		 * 
		 * @param rawText
		 * @return
		 */
		private String escapeSpecialChars(String rawText) {
			String retVal = rawText;
			for(int i=0; i<specialCharMapping.length; i++) {
				retVal = retVal.replaceAll(specialCharMapping[i][0], specialCharMapping[i][1]);
			}
			
			return retVal;
		}
	}
}