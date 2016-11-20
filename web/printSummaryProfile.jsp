<%@ page import="java.util.Map" %>
<%@ page import ="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.openq.utils.PropertyReader" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.data.Entity" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.data.IDataService" %>
<%@ page import="com.openq.eav.metadata.IMetadataService" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
<%@ page import="com.openq.web.ActionKeys" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.expert.ExpertDetails"%>
<%@ page import="com.openq.interaction.Interaction"%>
<%@ page import="com.openq.contacts.Contacts"%>
<%@ page import="com.openq.eav.org.Organization"%>
<%@ page import="com.openq.user.User"%>
<%@ include file="imports.jspf"%>
<%@ include file="commons.jspf"%>
<%
    String entityIdString = request.getParameter("entityId");
    String print=request.getParameter("print");
    String tab=request.getParameter("tab");
    String kolName = request.getParameter(Constants.CURRENT_KOL_NAME);
    String kolId =(String)session.getAttribute(Constants.CURRENT_KOL_ID);
    String currentKOLName = (String)(request.getSession().getAttribute(Constants.CURRENT_KOL_NAME) == null ? "" : request.getSession().getAttribute(Constants.CURRENT_KOL_NAME).toString().replaceAll("'","\\\\'"));
   
    String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
 	long userGroupId = -1;
 	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString));
 		userGroupId = Long.parseLong(userGroupIdString);

    boolean commFlag = false;
    IDataService dataService = (IDataService) request.getSession().getAttribute("dataService");
    IMetadataService metadataService = (IMetadataService) request.getSession().getAttribute("metadataService");
    String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
   	boolean isSAXAJVUser = false;
   	if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
   			isSAXAJVUser = true;
   	}

   	String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
	boolean isOTSUKAJVUser = false;
	if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
			isOTSUKAJVUser = true;
	}


    long entityId = Long.parseLong(entityIdString);
    Entity entity = dataService.getEntity(entityId);
    EntityAttribute [] attributes = dataService.getAllEntityAttributes(entityId);

    //long startTime = System.currentTimeMillis();
    //User user = dataService.setUserFields1(entityId);
    //long endTime = System.currentTimeMillis();
    //System.out.println("Time taken here(earlier): "+ (endTime - startTime));

    //LocationView locationview = user.getUserLocation();
    ExpertDetails expDetails = (ExpertDetails)request.getSession().getAttribute("expDetails");
    Map interactionObjsMap = (Map)request.getSession().getAttribute("expertInteractions");
   Contacts [] contact = (Contacts [])request.getSession().getAttribute("contacts");
  Organization [] relatedOrgs = (Organization[])request.getSession().getAttribute("relatedOrgs");
  String societies = (String)request.getSession().getAttribute("societies");
  String patents = (String)request.getSession().getAttribute("patents");
  String honors = (String)request.getSession().getAttribute("honors");
  String industryactivites = (String)request.getSession().getAttribute("industryactivites");
  String presentation = (String)request.getSession().getAttribute("presentation");
  //String OL_Type = (String) request.getSession().getAttribute("OL_Type");;
  String olSelectCriteria=(String)request.getSession().getAttribute("olSelectCriteria");;
  String sphereOfInfluence = (String)request.getSession().getAttribute("sphereOfInfluence");;
  String region = (String)request.getSession().getAttribute("region");;
  String subRegion = (String)request.getSession().getAttribute("subRegion");;
  String taAffiliations= (String)request.getSession().getAttribute("taAffiliations");
  String fullProfileDate = (String)request.getSession().getAttribute("fullProfileDate");
  String basicProfileDate =(String)request.getSession().getAttribute("basicProfileDate");
  String bestDayForContact = (String)request.getSession().getAttribute("bestDayForContact");
  String bestTimeForContact = (String)request.getSession().getAttribute("bestTimeForContact");
  String bmsTrials = (String)request.getSession().getAttribute("bmsTrials");
  String publicaton = (String)request.getSession().getAttribute("publication");
  String allTrials = (String)request.getSession().getAttribute("allTrials");
  String editorialBoards = (String)request.getSession().getAttribute("editorialBoards");
  String committees = (String)request.getSession().getAttribute("committees");
  String profAttributes = (String)request.getSession().getAttribute("attributes");

 if(olSelectCriteria != null && olSelectCriteria != "")
	olSelectCriteria = olSelectCriteria.substring(0,olSelectCriteria.length()-1);
 else
	olSelectCriteria="";

HashMap leftNavMap = (HashMap) request.getSession().getAttribute("leftNavMap");
String ol_fName = (String) leftNavMap.get((String)session.getAttribute("firstname"));
String ol_lName = (String) leftNavMap.get((String)session.getAttribute("lastname"));
String ol_mName = (String) leftNavMap.get((String)session.getAttribute("middlename"));
String ol_prefix = (String) leftNavMap.get((String)session.getAttribute("prefix"));
String ol_suffix = (String) leftNavMap.get((String)session.getAttribute("suffix"));

	List publicationList = (List)session.getAttribute("PUBLICATION_LIST");
	List speakerContractList = (List) session.getAttribute("SPEAKERCONTRACT_LIST");
	List societiesList = (List) session.getAttribute("SOCIETIES_LIST");
	List editorialBoardsList = (List) session.getAttribute("EDITORIALBOARD_LIST");
    String TLStatusAlreadySet = "false";
    if(expDetails != null && 
            expDetails.getMslOlType() != null && 
            !"".equals(expDetails.getMslOlType())){
        if(Constants.TL_TYPE_TL.equalsIgnoreCase(expDetails.getMslOlType()) ||
                 Constants.TL_TYPE_HCP.equalsIgnoreCase(expDetails.getMslOlType())){
            TLStatusAlreadySet = "true";
        }
    }
    String sphereOfInfluenceTD = "attr_" + request.getAttribute("sphereOfInfluenceAttrId") + "TD";
    String regionTD = "attr_" + request.getAttribute("regionAttrId") + "TD";
    String subRegionTD = "attr_" + request.getAttribute("subRegionAttrId") + "TD";
    String selectionCriteriaEntityId = (String) request.getAttribute("selectionCriteriaEntityId");
    String parameterString = "&entityId=" + selectionCriteriaEntityId +"&kolid="+ expDetails.getKolid()+"&attributeId=" + Constants.SELECTION_CRITERIA_ATTRIBUTEID + "&parentId=" + 
    request.getAttribute("BMSInfoTypeEntity") + "&tabName=" + PropertyReader.getEavConstantValueFor("OL_SELECTION_CRITERIA") + 
    "&entityAttr=-1&currentKOLName=" + currentKOLName + "&targetWindow=window.opener";
%>


<HTML>
<HEAD>
    <TITLE><%=DBUtil.getInstance().doctor%> Profile</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
<script type="text/javascript">
    dojo.require("dijit.layout.ContentPane");
    function toggleAlertMode(selectedTabName) {
		var iconObject = document.getElementById(selectedTabName+'_alertIcon')
   if(icon!=null&&icon!=undefined)
	{
		var iconName = iconObject.src.toString();
		if(iconName!=null && iconName.length>0)
		{

			if (iconName.indexOf('disabled') > 0) {
				if (confirm("Please confirm that you would like to recieve e-mail when '" + selectedTabName + "' of " + " <%=kolName%> changes. Press OK to confirm.")) {
				//	document.getElementById(selectedTabName+'_alertIcon').src = 'images/alert-enabled.gif';
					alert("E-mail alerts for '" + selectedTabName + "' of <%=kolName%> activated.");
					setCookie(selectedTabName, "enabled", 15);
					//alert(document.getElementById('_alertIcon').src);
				}
			} else {
				if (confirm("Please confirm that you would not like to recieve e-mail when '" + selectedTabName + "' of " + " <%=kolName%> changes. Press OK to confirm.")) {
					document.getElementById(selectedTabName+'_alertIcon').src = 'images/alert-disabled.gif';
					alert("E-mail alerts for '" + selectedTabName + "' of <%=kolName%> de-activated.");
					eraseCookie(selectedTabName);
					//alert(document.getElementById('_alertIcon').src);
				}
			}
		}
	 }
	}

   function setNotifyIcon(tabName) {
        var iconObject = document.getElementById(tabName+'_alertIcon')
	  if(iconObject!=null&&iconObject!=undefined)
	 {
		if (getCookie(tabName)) {
		iconObject.src = 'images/alert-enabled.gif';
      } else {
        iconObject.src = 'images/alert-disabled.gif';
      }
    }
   }
    dojo.addOnLoad(function(){
      setNotifyIcon('Contact Info');
      //setNotifyIcon('MD Characteristic');
      setNotifyIcon('Area of Intrests');
      setNotifyIcon('Current Relationship');
    });
</script>
<script type="text/javascript" src="js/cookieHelper.js">
</script>
<script type="text/javascript" src="js/subsection.js">
</script>
</head>
<BODY class="reset" scroll="auto">
<%if(print!=null){ %>
<table width="100%">

    <TD vAlign=center align=right><A class=text-blue-01-bold
                                     onclick=window.print(); href="#">
        <IMG height=16 src="images/print_icon.gif" width=16
             align=middle border=0>&nbsp;Print</A> </TD>
</table>
<%} %>
<%if(tab==null||tab.equalsIgnoreCase("contactInfo")) {


%>
<table width="100%">
    <td>
        <div style="width: 98%" class="reset colOuter">
            <div class="colTitle">
                <table width=100% class="colTitle">
                    <tr>
                        <td width=80%>
                            <%if(print==null ){ %>
                            <img id="contImg" class="toggleImg" onclick="javascript:toggleSection('cont')" src="images/buttons/minus.gif"/>&nbsp;&nbsp;
                            <%} %>
                            Summary</td>
                        <%if(print==null ){ %>
                        <td><!-- commenting out notify icon<img src="images/alert-disabled.gif" id="Contact Info_alertIcon" style="width: 16px; height;16px; vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:toggleAlertMode('Contact Info')" >Notify</a>&nbsp;&nbsp;-->
                            <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=contactInfo&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%}%>
                    </tr>
                </table>
            </div>
            <div id="contContent" class="colContent">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                	<tr>
						<td class="text-blue-01" valign="top" align="left">
							<%=ol_prefix == null ? "" : ol_prefix%> <%=ol_fName == null ? "" : ol_fName%> <%=ol_mName == null ? "" : ol_mName%> <%=ol_lName == null ? "" : ol_lName%> <%=ol_suffix == null ? "" : ol_suffix%>
						</td>
					</tr>
				  	<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
                 	<tr>
						<td class="text-blue-01-bold" style="width:25%;" valign="top">
							Phone :
						</td>
						<td class="text-blue-01" style="width:25%;" valign="top">
							<%=(expDetails!=null)?((expDetails.getPrimaryPhone() != null && !expDetails.getPrimaryPhone().equals("") )? expDetails.getPrimaryPhone(): ""):""%>
						</td>
						<td valign="top" class="text-blue-01-bold" style="width:20%;">
						   Email  :
						</td>
						<td class="text-blue-01" style="width:30%;" valign="top">
						<%=(expDetails!=null)?((expDetails.getPrimaryEmail() != null && !expDetails.getPrimaryEmail().equals("") )?
						 expDetails.getPrimaryEmail(): ""):""%>
						 </td>
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
							Specialty :
						</td>
						<% if (expDetails != null) {
				 				String speciality = "";
	            				if(expDetails.getPrimarySpeciality()!= null && !expDetails.getPrimarySpeciality().equals("")){
	            					speciality = expDetails.getPrimarySpeciality();
	            			}
	            			if(expDetails.getSecondarySpeciality()!= null && !expDetails.getSecondarySpeciality().equals("")){
	            				if(speciality.equals(""))
	            					speciality = expDetails.getSecondarySpeciality();
	            				else	
	            					speciality = speciality + ", " + expDetails.getSecondarySpeciality();
	            			}
	            			if(expDetails.getTertiarySpeciality()!= null && !expDetails.getTertiarySpeciality().equals("")){
	            				if(speciality.equals(""))
	            					speciality = expDetails.getTertiarySpeciality();
	            				else
	            					speciality = speciality +", " + expDetails.getTertiarySpeciality();
	            			}
	            		%>
						<td class="text-blue-01" valign="top">
							<%=speciality%>	            			
						</td>
						<%}%>							
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
							Address :
						</td>
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="text-blue-01">
										<%=(expDetails != null)?((expDetails.getAddressLine1() != null && !expDetails.getAddressLine1().equals("") )? expDetails.getAddressLine1(): ""):""%>
									</td>
								</tr>
								<tr>
									<td class="text-blue-01">
										<%=(expDetails != null)?((expDetails.getAddressLine2() != null && !expDetails.getAddressLine2().equals("") )? expDetails.getAddressLine2(): ""):""%>
									</td>
								</tr>
								<tr>
									<td class="text-blue-01">
										<%=(expDetails != null)?((((expDetails.getAddressCity()==null)?"":expDetails.getAddressCity().trim())+
				 						((expDetails.getAddressCountry()==null ||
				 								expDetails.getAddressCountry().trim().equalsIgnoreCase("United States") ||
				 								expDetails.getAddressCountry().trim().equalsIgnoreCase("USA")||
				 								expDetails.getAddressCountry().trim().equalsIgnoreCase("United states of America") )?
				 										",  "+expDetails.getAddressState():", "+expDetails.getAddressCountry()))):""%>
									</td>
								</tr>
								<tr>
									<td class="text-blue-01">
										<%=(expDetails != null)?((expDetails.getAddressPostalCode() != null &&
				 						!expDetails.getAddressPostalCode().equals("") )? expDetails.getAddressPostalCode(): ""):""%>
									</td>
								</tr>
							</table>
						</td>
						<td class="text-blue-01-bold" valign="top">
							Thought Leader Criteria :
						</td>
						<td id="olSelectCriteriaTD" class="text-blue-01" valign="top">
							<%=olSelectCriteria%>
						</td>
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>				 
				 	<tr>
						<td class="text-blue-01-bold" valign="top">
							Best Day and Time to Contact:
						</td>
						<td class="text-blue-01" valign="top">
							<%if((bestDayForContact==null || bestDayForContact.equals("")) &&
				 			(bestTimeForContact==null||bestTimeForContact.equals(""))){%>
				 				N-A	
							<%} else {%>
				 			<%=bestDayForContact%> <%=bestTimeForContact%>
							<%}%>										
						</td>
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td valign="top" class="text-blue-01-bold">
				  			BMS Contacts :
						</td>
						<td valign="top">
							<table width="auto" border="0" cellspacing="0" cellpadding="0">
								<% if(contact!=null&&contact.length>0){
				 					for(int n = 0;n<contact.length;n++){
				 						if(contact[n].getContactName()!=null){
					 						long contactId =contact[n].getContactId();
				 				%>	
								<tr>
									<td class="text-blue-01">
										<%=contact[n].getContactName()%>,
									</td>	
								</tr>
								<tr>
                        			<td class="text-blue-01">		
										<%=(contact[n].getRole()==null?"N.A":contact[n].getRole())%>,
									</td>		
								</tr>
								<tr>
                        			<td class="text-blue-01">		
										<%=(contact[n].getPhone()==null?"N.A":contact[n].getPhone())%>
									</td>	
								</tr>					
								<%}}}
								%>
							</table>
						</td>				 				 
						<td valign="top" class="text-blue-01-bold">
							Affiliations :
						</td>	
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="0">
					 		<%if(relatedOrgs!=null){
					    		for(int o=0;o<relatedOrgs.length;o++){
						    		String position = relatedOrgs[o].getPosition()!=null?relatedOrgs[o].getPosition(): "N-A";
					  		%>
								<tr>
									<td class="text-blue-01">
										<%=relatedOrgs[o].getName()%>,
					    				<%=(relatedOrgs[o].getPosition()!=null?relatedOrgs[o].getPosition():"N-A")%>
									</td>
								</tr>
				    		<%}}
				    		%>
							</table>
						</td>
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
							Thought Leader Type :
						</td>
						<td class="text-blue-01" valign="top" id="attr_<%=Constants.TL_TYPE_ATTRIBUTEID %>TD">
							<%=(expDetails != null)?((expDetails.getMslOlType() != null && !expDetails.getMslOlType().equals("") )? expDetails.getMslOlType(): ""):""%>
						</td>				
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
							Sphere of Influence :
						</td>
						<td class="text-blue-01" valign="top" id="<%=sphereOfInfluenceTD%>">
							<%=sphereOfInfluence%>
						</td>				
						<td class="text-blue-01-bold" valign="top">
							Attributes :
						</td>
						<td class="text-blue-01" valign="top">
							<%=profAttributes%>
						</td>				
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
							TA Affiliations :
						</td>
						<td class="text-blue-01" valign="top">
							<%=taAffiliations%>
						</td>				
						<td class="text-blue-01-bold" valign="top">
							Region :
						</td>
						<td class="text-blue-01" valign="top" id="<%=regionTD%>">
							<%=region%>
						</td>				
					</tr>
					<tr>
						<td class="text-blue-01" valign=top>&nbsp;</td>                 	
                 	</tr>
					<tr>
						<td class="text-blue-01-bold" valign="top">
						     Sub Region :
						</td>
						<td class="text-blue-01" valign="top" id="<%=subRegionTD%>">
							<%=subRegion%>
						</td>										
					</tr>
				</table>
		    </div>
        </div>
    </td>
</table>
<%} %>


<%  if(tab==null||tab.equalsIgnoreCase("Report")){  %>
<table width="100%">
    <td>
        <div style="width=98%" class="reset colOuter">
            <div class="colTitle" class=>
                <table width=100% class="colTitle">
                    <tr>
                        <td width=80%>
                            <%if(print==null){ %>
                            <img id="reportImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('report')" />&nbsp;&nbsp;
                            <%} %>
                            Professional Activity Details</td>
                        <%if(print==null){ %>
                        <td><!--img src="images/alert-disabled.gif" id="MD Characteristic_alertIcon" style="width: 16px; height: 16px; vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:toggleAlertMode('MD Characteristic')">Notify</a>&nbsp;&nbsp;
                            --><img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=Report&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%} %>
                    </tr>
                </table>
            </div>
            <div id="reportContent" class="colContent">
				<table width="100%">
				<tr>
				<td>
				<table width="100%" >
				<tr>
				<%if(!isSAXAJVUser && !isOTSUKAJVUser){%>
				<td width="5%" name="societies" align="center" class="text-blue-01">
				 <input name="bmsTrialsCheckBox" type="checkbox" class="text-blue-01"
				 <%if(bmsTrials!=null){%>
				 checked="checked"
				 <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">BMS Trials</td>
                <%}%>
				<td width="5%" name="patents" align="center" class="text-blue-01">
				 <input name="allTrialsCheckBox" type="checkbox" class="text-blue-01"
				 <%if(allTrials!=null){%>
				 checked="checked"
				  <%} %>
				  onclick="return false">
				  </td>
				 <td class="text-blue-01">All Trials</td>
				<td name="honors" align="center" class="text-blue-01">
				 <input name="publicatonCheckBox" type="checkbox" class="text-blue-01"
				 <%if(publicaton!=null){%>
				 checked="checked"
				  <%} %>
				  onclick="return false">
				  </td>
				 <td class="text-blue-01">Publications</td>
			   <td name="industryactivites" align="center" class="text-blue-01">
				 <input name="edBoardCheckBox" type="checkbox" class="text-blue-01"
				 <%if(editorialBoards!=null){%>
				 checked="checked" <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">Editorial Boards</td>
				<td name="presentation" align="center" class="text-blue-01">
				 <input name="committeesCheckBox" type="checkbox"
				 <%if(committees!=null){%>
				 checked="checked" <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">Committess</td>
				</tr>
				<tr>
			    </tr>
				<tr>
				<td width="5%" name="societies" align="center" class="text-blue-01">
				 <input name="societiesCheckBox" type="checkbox" class="text-blue-01"
				 <%if(societies!=null){%>
				 checked="checked"
				 <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">Societies</td>
                <td width="5%" name="patents" align="center" class="text-blue-01">
				 <input name="patentsCheckBox" type="checkbox" class="text-blue-01"
				 <%if(patents!=null){%>
				 checked="checked"
				  <%} %>
				  onclick="return false">
				  </td>
				 <td class="text-blue-01">Patents</td>
				<td name="honors" align="center" class="text-blue-01">
				 <input name="honorsCheckBox" type="checkbox" class="text-blue-01"
				 <%if(honors!=null){%>
				 checked="checked"
				  <%} %>
				  onclick="return false">
				  </td>
				 <td class="text-blue-01">Honors</td>
			   <td name="industryactivites" align="center" class="text-blue-01">
				 <input name="indActCheckBox" type="checkbox" class="text-blue-01"
				 <%if(industryactivites!=null){%>
				 checked="checked" <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">Industry Activities</td>
				<td name="presentation" align="center" class="text-blue-01">
				 <input name="presentationCheckBox" type="checkbox"
				 <%if(presentation!=null){%>
				 checked="checked" <%} %>
				 onclick="return false">
				 </td>
				 <td class="text-blue-01">Presentation</td>
				</tr>
				<tr>
				</tr>
				</table>
				</td>
				</tr>
				<tr>
				<td>
				<table>
				<tr>
				<td class="text-blue-01-bold">
				Last Profile Update :
				</td>
				<td class="text-blue-01">
				Full: <%=fullProfileDate%>&nbsp;
				</td>
				<td class="text-blue-01">
				Basic: <%=basicProfileDate%>&nbsp;
				</td>
				<td class="text-blue-01">
				&nbsp;
				</td>
				<td class="text-blue-01">
				&nbsp;
				</td>
				</tr>
				</td>
				</table>
				</td>
				</tr>
				</table>
            </div>
        </div>
    </td>
</table>

<% }  %>
<%
if(tab==null||tab.equalsIgnoreCase("recentInteractions")){%>
<table width="100%">
    <td>
        <div style="width=98%" class="reset colOuter">
            <div class="colTitle" >
                <table width='100%' class="colTitle">
                    <tr>
                        <td width='80%'>
                            <%if(print==null){ %>
                            <img id="recentInteractionsImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('recentEvents')" />&nbsp;&nbsp;
                            <%} %>
                            Recent Interactions</td>
                        <%if(print==null){ %>
                        <td><!-- commenting out notify icon<img src="images/alert-disabled.gif" id="Area of Intrests_alertIcon" style="width: 16px; height: 16px; vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:toggleAlertMode('Area of Intrests')">Notify</a>&nbsp;&nbsp;-->
                            <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=aoi&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%} %>
                    </tr>
                </table>

            </div>
            <div id="recentEventsContent" class="colContent">
                <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
                   <tr class="back-grey-02-light">
                    <td width="10" height="20">&nbsp;</td>
	                 <td width="31%" class="text-blue-01-bold">Interaction Date</td>
	                 <td width="20" class="text-blue-01-bold">&nbsp;</td>
	                 <td width="31%" class="text-blue-01-bold">Interaction Topic</td>
	                 <td width="20" class="text-blue-01-bold">&nbsp;</td>
	                 <td class="text-blue-01-bold">BMS Employee</td>
	               </tr>

	   <%
		if (interactionObjsMap!= null )
       {
	    List interactionObjList = (List)interactionObjsMap.get("InteractionList");
		Map interactionBMSUserMap = (Map)interactionObjsMap.get("InteractionBMSUserNames");
		Map interactionIdFirstTopicMap = (Map) interactionObjsMap.get("interactionIdFirstTopicMap");
	    for(int j=0;j<interactionObjList.size();j++)
           {
        	  Interaction interaction = (Interaction)interactionObjList.get(j);
        	  String val2 = "";
        	  Long interactionIdObj = new Long(interaction.getId());
        	  if(interactionIdFirstTopicMap.size() > 0 &&
        			  interactionIdFirstTopicMap.containsKey(interactionIdObj)){
        		  val2 = (String) interactionIdFirstTopicMap.get(interactionIdObj);
        	  }
        	  String val1 = interaction.getInteractionDate().toString();
        	  String attendeeNames = "";
			  interaction.getUserId();
			  if(interactionBMSUserMap!=null&&interactionBMSUserMap.get(interaction.getId()+"")!=null)
				  {
			        attendeeNames = (String)interactionBMSUserMap.get(interaction.getId()+"");
				  }
			  String val3 = attendeeNames;

            %>
	     <tr <%=(j%2 != 0) ? "class='back-grey-02-light'" : ""%>>
		 <td height="20">&nbsp;</td>
	     <td class="text-blue-01" valign=top ><%=(val1 != null && !val1.equals("null") ? val1 : "")%></td>
	     <td class="text-blue-01" valign=top>&nbsp;</td>
	     <td class="text-blue-01" valign=top ><%=(val2 != null && !val2.equals("null") ? val2 : "")%></td>
	     <td class="text-blue-01" valign=top>&nbsp;</td>
	     <td class="text-blue-01" valign=top ><%=(val3 != null && !val3.equals("null") ? val3 : "")%></td>
	    </tr>

		<%}%>
		<tr class="back-grey-02-light">
           <td width="10" height="20">&nbsp;</td>
	       <td width="31%" class="text-blue-01-bold">Last Medical Inquiry :</td>
	       <td width="20" class="text-blue-01-bold">&nbsp;</td>
	       <td width="31%" class="text-blue-01-bold">&nbsp;</td>
	       <td width="20" class="text-blue-01-bold">&nbsp;</td>
	       <td class="text-blue-01-bold">&nbsp;</td>
	       </tr>
		<tr>
          <td height="20" colspan="6"><img src="images/transparent.gif" width="10" height="10"></td>
        </tr>

 <%}%>
          </table>
        </div>
	</div>
    </td>
</table>

<%}%>

<%
if((tab==null||tab.equalsIgnoreCase("SpeakerContract"))&& (!isSAXAJVUser) && (!isOTSUKAJVUser))
 {%>
     <table width="100%">
    <td>
        <div style="width=98%" class="reset colOuter">
            <div class="colTitle" class=>
                <table width=100% class="colTitle">
                    <tr>
                        <td width=80%><%if(print==null){ %>
                            <img id=speakerContractImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('speakerContract')"/>&nbsp;&nbsp;
                            <%} %>
                                  BMS Contract(s)</td>
                            <%if(print==null){ %>
                        <td>
                            <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;"
                            	onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=currentRelationship&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%}%>
                    </tr>
                </table>
            </div>
            <div id="speakerContractContent" class="colContent">

                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="back-grey-02-light">
                <td width="10"></td>
                 <td class="text-blue-01-bold" height="20">
                 Product/Disease State
                 </td>
                 <td class="text-blue-01-bold">
                 Active
                 </td>
                 <td class="text-blue-01-bold">
                 Start Date
                 </td>
                 <td class="text-blue-01-bold">
                 End Date
                 </td>
                </tr>
<% if(speakerContractList!=null && speakerContractList.size()>0)
	{
	 for(int i=0;i< speakerContractList.size();i++)
	{
	   Map speakerContract = (Map)speakerContractList.get(i);

        if(speakerContract!=null)
        {%>
          <tr <%=(i%2 != 0) ? "class='back-grey-02-light'" : ""%>>
          <td width="10"></td>
          <td class="text-blue-01" height="20">
          <%=speakerContract.get("iPlanProduct")==null?"":(String)speakerContract.get("iPlanProduct") %>
          </td>
          <td class="text-blue-01">
          <%=speakerContract.get("iPlanActive")==null?"":(String)speakerContract.get("iPlanActive") %>
          </td>
          <td class="text-blue-01">
          <%=speakerContract.get("iPlanStartDate")==null?"":(String)speakerContract.get("iPlanStartDate") %>
          </td>
          <td class="text-blue-01">
          <%=speakerContract.get("iPlanEndDate")==null?"":(String)speakerContract.get("iPlanEndDate") %>
          </td>
          </tr>
          <%}
	  }
 }
  else
  {%>
      <tr>
      <td>&nbsp;</td>
      <td class="text-blue-01-red">
      No rows found
      </td>
      </tr>
  <%}%>
 </table>
 </div>
 </td>
 </table>
 <%}
 %>

 <%
 if(tab==null||tab.equalsIgnoreCase("Societies"))
  {%>
      <table width="100%">
     <td>
         <div style="width=98%" class="reset colOuter">
             <div class="colTitle" class=>
                 <table width=100% class="colTitle">
                     <tr>
                         <td width=80%><%if(print==null){ %>
                             <img id=societiesImg" class="toggleImg" src="images/buttons/minus.gif" " +
                             		"onclick="javascript:toggleSection('societies')"/>&nbsp;&nbsp;
                             <%} %>
                                   Societies</td>
                             <%if(print==null){ %>
                         <td>
                             <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                             <a href="#" style="color: #4C7398; font-weight: normal;"
                             	onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=currentRelationship&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                         <%}%>
                     </tr>
                 </table>
             </div>
             <div id="societyContent" class="colContent">

             <table width="100%" border="0" cellspacing="0" cellpadding="0">
             <tr class="back-grey-02-light">
             <td width="1%"></td>
              <td class="text-blue-01-bold" height="20" width="37%">
              Societies Description
              </td>
              <td class="text-blue-01-bold" width="27%">
              Societies Board
              </td>
              <td class="text-blue-01-bold" width="20%">
              Societies Title
              </td>
              <td class="text-blue-01-bold" width="15%">
              Societies Years
              </td>
             </tr>
 <% if(societiesList!=null && societiesList.size()>0)
 	{
 	 for(int i=0;i< societiesList.size();i++)
 	{
 	   Map society = (Map)societiesList.get(i);

         if(society != null)
         {%>
           <tr <%=(i%2 != 0) ? "class='back-grey-02-light'" : ""%>>
           <td width="10"></td>
           <td class="text-blue-01" height="20">
           <%=society.get("societiesDescription")==null?"":(String)society.get("societiesDescription") %>
           </td>
           <td class="text-blue-01">
           <%=society.get("societiesBoard")==null?"":(String)society.get("societiesBoard") %>
           </td>
           <td class="text-blue-01">
           <%=society.get("societiesTitle")==null?"":(String)society.get("societiesTitle") %>
           </td>
           <td class="text-blue-01">
           <%=society.get("societiesYears")==null?"":(String)society.get("societiesYears") %>
           </td>
           </tr>
           <%}
 	  }
  }
   else
   {%>
       <tr>
       <td>&nbsp;</td>
       <td class="text-blue-01-red">
       No rows found
       </td>
       </tr>
   <%}%>
  </table>
  </div>
  </td>
  </table>
  <%}
  %>

  <%
  if(tab==null||tab.equalsIgnoreCase("EditorialBoards"))
   {%>
       <table width="100%">
      <td>
          <div style="width=98%" class="reset colOuter">
              <div class="colTitle" class=>
                  <table width=100% class="colTitle">
                      <tr>
                          <td width=80%><%if(print==null){ %>
                              <img id=societiesImg" class="toggleImg" src="images/buttons/minus.gif" " +
                              		"onclick="javascript:toggleSection('editorialBoards')"/>&nbsp;&nbsp;
                              <%} %>
                                    Editorial Boards</td>
                              <%if(print==null){ %>
                          <td>
                              <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                              <a href="#" style="color: #4C7398; font-weight: normal;"
                              	onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=currentRelationship&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                          <%}%>
                      </tr>
                  </table>
              </div>
              <div id="editorialBoardContent" class="colContent">

                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr class="back-grey-02-light">
                  <td width="1%"></td>
                   <td class="text-blue-01-bold" height="20" width="37%">
                   Editorial Board Journal
                   </td>
                   <td class="text-blue-01-bold" width="27%">
                   Editorial Board Dates
                   </td>
                   <td class="text-blue-01-bold" width="35%">
                   Editorial Board Position
                   </td>
                   </tr>
  <% if(editorialBoardsList!=null && editorialBoardsList.size()>0)
  	{
  	 for(int i=0;i< editorialBoardsList.size();i++)
  	{
  	   Map editorialBoard = (Map)editorialBoardsList.get(i);

          if(editorialBoard != null)
          {%>
            <tr <%=(i%2 != 0) ? "class='back-grey-02-light'" : ""%>>
            <td width="10"></td>
            <td class="text-blue-01" height="20">
            <%=editorialBoard.get("editorialBoardJournal")==null?"":(String)editorialBoard.get("editorialBoardJournal") %>
            </td>
            <td class="text-blue-01">
            <%=editorialBoard.get("editorialBoardDates")==null?"":(String)editorialBoard.get("editorialBoardDates") %>
            </td>
            <td class="text-blue-01">
            <%=editorialBoard.get("editorialBoardPosition")==null?"":(String)editorialBoard.get("editorialBoardPosition") %>
            </td>
            </tr>
            <%}
  	  }
   }
    else
    {%>
        <tr>
        <td>&nbsp;</td>
        <td class="text-blue-01-red">
        No rows found
        </td>
        </tr>
    <%}%>
   </table>
   </div>
   </td>
   </table>
   <%}
   %>



 <%//if(tab==null||tab.equalsIgnoreCase("BMS Event History"))
 if (false) // Disabling the Medical Meetings Section for BMS 2.2 release.
 {%>
     <table width="100%">
    <td>
        <div style="width=98%" class="reset colOuter">
            <div class="colTitle" class=>
                <table width=100% class="colTitle">
                    <tr>
                        <td width=80%><%if(print==null){ %>
                            <img id=eventImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('event')"/>&nbsp;&nbsp;
                            <%} %>
                                  Medical Meetings</td>
                            <%if(print==null){ %>
                        <td><!-- commenting out notify icon<img src="images/alert-disabled.gif" id="Current Relationship_alertIcon" style="width: 16px; height: 16px; vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal; " onclick="javascript:toggleAlertMode('Current Relationship')">Notify</a>&nbsp;&nbsp;-->
                            <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=currentRelationship&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%}%>
                    </tr>
                </table>
            </div>
            <div id="eventContent" class="colContent">

                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <jsp:include page ='event_search.htm'>
                                <jsp:param name="action" value='<%=ActionKeys.SHOW_EVENTS_BY_EXPERT%>'/>
                                <jsp:param name="fromProfSummary" value='true' />
							</jsp:include>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </td>
</table>
<%}%>
<%
if(tab==null||tab.equalsIgnoreCase("Publications"))
 {%>
     <table width="100%">
    <td>
        <div style="width=98%" class="reset colOuter">
            <div class="colTitle" class=>
                <table width=100% class="colTitle">
                    <tr>
                        <td width=80%><%if(print==null){ %>
                            <img id=pubImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('pub')"/>&nbsp;&nbsp;
                            <%} %>
                                  Publications</td>
                            <%if(print==null){ %>
                        <td><!-- commenting out notify icon<img src="images/alert-disabled.gif" id="Current Relationship_alertIcon" style="width: 16px; height: 16px; vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal; " onclick="javascript:toggleAlertMode('Current Relationship')">Notify</a>&nbsp;&nbsp;-->
                            <img src="images/printIcon.gif" style="vertical-align: middle; display:inline;"></img>
                            <a href="#" style="color: #4C7398; font-weight: normal;" onclick="javascript:window.open('printSummaryProfile.htm?kolid=<%=session.getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId %>&tab=currentRelationship&print=true&currentKOLName=<%=currentKOLName%>')">Print</a></td>
                        <%}%>
                    </tr>
                </table>
            </div>
            <div id="pubContent" class="colContent">

                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="back-grey-02-light">
                 <td width="1%">&nbsp;</td>
                 <td class="text-blue-01-bold" height="20" width="60%">
                 Title
                 </td>
                 <td class="text-blue-01-bold" width="25%">
                 Journal
                 </td>
                 <td class="text-blue-01-bold" width="14%">
                 Date
                 </td>
                </tr>
<% if(publicationList.size()>0)
	{
	 for(int i=publicationList.size()-1;i>=0;i--)
	{
	   Map publication = (Map)publicationList.get(i);

        if(publication != null)
        {%>
          <tr <%=(i%2 != 0) ? "class='back-grey-02-light'" : ""%>>
          <td width="1%">&nbsp;</td>
          <td class="text-blue-01" height="20">
          <%=publication.get("pubTitle")==null?"":(String)publication.get("pubTitle") %>
          </td>
          <td class="text-blue-01">
          <%=publication.get("pubJournal")==null?"":(String)publication.get("pubJournal") %>
          </td>
          <td class="text-blue-01">
          <%=publication.get("pubDate")==null?"":(String)publication.get("pubDate") %>
          </td>
          </tr>
          <%}
	  }
 }
  else
  {%>
      <tr>
      <td>&nbsp;</td>
      <td class="text-blue-01-red">
      No rows found
      </td>
      </tr>
  <%}%>
 </table>
 </div>
 </td>
 </table>
 <%}
 %>
 <%if(print==null){%>
 <table width="100%">
 <tr>
 <td width="50%">&nbsp;</td>
 <td valign="top" align="right" style="cursor:hand"
                     onClick="javascript:void(window.open('printSummaryProfile.htm?kolid=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId%>&currentKOLName=<%=currentKOLName%>&print=true'))">
                     <img src='images/print_icon.gif' border=0 height="32" title="Printer friendly format"/>

</td>
</tr>
<tr>
<td width="90%">&nbsp;</td>
<td valign="top" align="right">
<a class="text-blue-link" href="javascript:void(window.open('printSummaryProfile.htm?kolid=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<%=entityId%>&currentKOLName=<%=currentKOLName%>&print=true'))" >Print</a>
</td>
</tr>
</table>
<%}%>
<script>
if('<%=TLStatusAlreadySet%>' == 'false'){
    window.open('selectionCriteriaPopup.htm?<%=parameterString%>', 'TLSelectionCriteria','width=700,height=600,top=100,left=100,resizable=1,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=1');
}
</script>
</body>
</html>
<%
    request.getSession().removeAttribute("dataService");
    request.getSession().removeAttribute("metadataService");
%>
