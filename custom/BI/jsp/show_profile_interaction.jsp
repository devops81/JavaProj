<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup, com.openq.user.IUserService, com.openq.user.User, com.openq.interaction.Interaction, com.openq.attendee.Attendee, java.text.SimpleDateFormat, com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.interactionData.InteractionData"%>
<%@ page import="java.util.*"%>
<%
    java.util.Properties prop1 = DBUtil.getInstance().interactionProp;
    OptionLookup interactionTypeLookup[] = null;
    if (session.getAttribute("INTERACTION_TYPE") != null) {
        interactionTypeLookup = (OptionLookup[]) session.getAttribute("INTERACTION_TYPE");
    }

    OptionLookup scientificTopicsLookup[] = null;
    if (session.getAttribute("SCIENTIFIC_TOPICS") != null) {
        scientificTopicsLookup = (OptionLookup[]) session.getAttribute("SCIENTIFIC_TOPICS");
    }

    OptionLookup interactionActivityLookup[] = null;
    if (session.getAttribute("INTERACTION_ACTIVITY") != null) {
        interactionActivityLookup = (OptionLookup[]) session.getAttribute("INTERACTION_ACTIVITY");
    }
    OptionLookup expenseTypeLookup[] = null;
    if (session.getAttribute("EXPENSE_TYPE") != null) {
        expenseTypeLookup = (OptionLookup[]) session.getAttribute("EXPENSE_TYPE");
    }

    OptionLookup expenseVenueLookup[] = null;
    if (session.getAttribute("EXPENSE_VENUE") != null) {
        expenseVenueLookup = (OptionLookup[]) session.getAttribute("EXPENSE_VENUE");
    }

    OptionLookup simLookup[] = null;
    if (session.getAttribute("SIM") != null) {
        simLookup = (OptionLookup[]) session.getAttribute("SIM");
    }

    OptionLookup siteFollowUpLookup[] = null;
    if (session.getAttribute("SITE_FOLLOW_UP") != null) {
        siteFollowUpLookup = (OptionLookup[]) session.getAttribute("SITE_FOLLOW_UP");
    }

    OptionLookup materialsLookup[] = null;
    if (session.getAttribute("MATERIALS") != null) {
        materialsLookup = (OptionLookup[]) session.getAttribute("MATERIALS");
    }

    OptionLookup plannedInteractionLookup[] = null;
    if (session.getAttribute("PLANNED_INTERACTION") != null) {
        plannedInteractionLookup = (OptionLookup[]) session.getAttribute("PLANNED_INTERACTION");
    }


    OptionLookup productsLookup[] = null;
    if (session.getAttribute("PRODUCTS") != null) {
        productsLookup = (OptionLookup[]) session.getAttribute("PRODUCTS");
    }

    OptionLookup statusLookup[] = null;
    if (session.getAttribute("STATUS") != null) {
        statusLookup = (OptionLookup[]) session.getAttribute("STATUS");
    }

    OptionLookup toolLookup[] = null;
    if (session.getAttribute("TOOL") != null) {
        toolLookup = (OptionLookup[]) session.getAttribute("TOOL");
    }

    OptionLookup ratingLookup[] = null;
    if (session.getAttribute("RATING") != null) {
        ratingLookup = (OptionLookup[]) session.getAttribute("RATING");
    }

    String message = "";
    if (session.getAttribute("MESSAGE") != null) {
        message = (String) session.getAttribute("MESSAGE");
    }

    Interaction interaction = null;
    if (session.getAttribute("INTERACTION_DETAILS") != null) {
        interaction = (Interaction) session.getAttribute("INTERACTION_DETAILS");
    }

    long interactionId = 0;
    if (interaction != null) {
        interactionId = interaction.getId();
    }

    String mode = "";
    if (session.getAttribute("MODE") != null) {
        mode = (String) session.getAttribute("MODE");
    }
    String kolId = "";
    String kolName = "";
    if (session.getAttribute(Constants.CURRENT_KOL_ID) != null) {
        kolId = (String) session.getAttribute(Constants.CURRENT_KOL_ID);
        //IUserService usrSvc = (IUserService) session.getAttribute("kolIntUserService");
        //kolName = usrSvc.getUser(Long.parseLong(kolId)).getUserName();
        //System.out.println("The kolId is: " + kolId);
    }


    if (session.getAttribute(Constants.CURRENT_KOL_NAME) != null) {
        kolName = (String) session.getAttribute(Constants.CURRENT_KOL_NAME);
    }


    String kolid = (String) request.getAttribute("KOL_ID");
    String expertId = (String) request.getAttribute("EXPERT_ID");

    String orgId = null;
    if (session.getAttribute("ORGID") != null ){
        orgId = (String) session.getAttribute("ORGID");
    }
    String orgName = null;
    if (session.getAttribute("ORGNAME") != null ){
        orgName = (String)session.getAttribute("ORGNAME");
    }

    String currentLink = null;
    if (null != session.getAttribute("ORG_LINK")){
        currentLink = (String) session.getAttribute("ORG_LINK");
    }
    String mainLink = null;
    if (null != session.getAttribute("CURRENT_LINK")){
        mainLink = (String) session.getAttribute("CURRENT_LINK");
    }

%>
<head>
    <link rel="stylesheet" type="text/css" media="all" href="jscalendar-1.0/skins/aqua/theme.css" title="Aqua" />
    <script type="text/javascript" src="jscalendar-1.0/calendar.js"></script>
    <script type="text/javascript" src="jscalendar-1.0/lang/calendar-en.js"></script>
    <script type="text/javascript" src="js/newcalendar.js"></script>

</head>
<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<SCRIPT src = "<%=COMMONJS%>/listbox.js" language = "Javascript"></SCRIPT>

<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js"></script>
<script language="javascript" src="js/subsection.js"></script>

<script language="javascript">
function searchInteractions() {
    var thisform = document.addInteractionForm;
    thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm";
    thisform.submit();
}

function saveInteraction() {
    if(window.event.keyCode == 0 || window.event.keyCode == 13) {
        var thisform = document.addInteractionForm;

        if (thisform.interactionDate.value == "") {
            alert("Please enter the Interaction Date");
            return false;
        }

        if (thisform.attendeeList.length > 0) {
            for (var i=0;i<thisform.attendeeList.length;i++) {
                thisform.attendeeList.options[i].selected = true;
            } // end of for loop
        }
        if (thisform.attendeeList.value == "") {
            alert("Please add the Attendees");
            return false;
        }

        if (thisform.scientificTopics!=null && thisform.scientificTopics.length > 0) {
            for (var i=0;i<thisform.scientificTopics.length;i++) {
                thisform.scientificTopics.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.interactionActivityList!=null &&thisform.interactionActivityList.length > 0) {
            for (var i=0;i<thisform.interactionActivityList.length;i++) {
                thisform.interactionActivityList.options[i].selected = true;
            } // end of for loop
        }
        if(document.getElementById("expenseVenue")!=null){
            var selText = document.getElementById("expenseVenue").options[document.getElementById("expenseVenue").selectedIndex].innerText;

            if (selText != '-NA-') {
                if(isNaN(thisform.amount.value) || thisform.amount.value <= 0) {
                    alert("Please enter positive non $0 Expense Amount");
                    return false;
                }
            }
        }


        if (thisform.materialsList!=null && thisform.materialsList.length > 0) {
            for (var i=0;i<thisform.materialsList.length;i++) {
                thisform.materialsList.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.otherTopics!=null && thisform.otherTopics.length > 0) {
            for (var i=0;i<thisform.otherTopics.length;i++) {
                thisform.otherTopics.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.Description!=null && thisform.Description.length > 0) {
            for (var i=0;i<thisform.Description.length;i++) {
                thisform.Description.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.otherInteractionActivities!=null && thisform.otherInteractionActivities.length > 0) {
            for (var i=0;i<thisform.otherInteractionActivities.length;i++) {
                thisform.otherInteractionActivities.options[i].selected = true;
            } // end of for loop
        }
        if (thisform.literature != null && thisform.literature.value != null &&
            thisform.literature.value.length > 4000) {
            alert("Literature is exceeding maximum size of  4000 charecters");
            return false;
        }


        if (thisform.productsList!=null && thisform.productsList.length > 0) {
            for (var i=0;i<thisform.productsList.length;i++) {
                thisform.productsList.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.toolAssessment!=null && thisform.toolAssessment.length > 0) {
            for (var i=0;i<thisform.toolAssessment.length;i++) {
                thisform.toolAssessment.options[i].selected = true;
            } // end of for loop
        }

        if (thisform.assessment!=null && thisform.assessment.length > 0) {
            if (thisform.assessment.length > 0) {
                for (var i=0;i<thisform.assessment.length;i++) {
                    thisform.assessment.options[i].selected = true;
                } // end of for loop
            }

            for (var i=0;i<thisform.assessment.length;i++) {
                thisform.assessment.options[i].selected = true;
            } // end of for loop
        }


        if (<%=interactionId%> == 0) {
        thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_ADD_INTERACTION%>";
    } else {
        thisform.action = "<%=CONTEXTPATH%>/interaction.htm?action=<%=ActionKeys.PROFILE_UPDATE_INTERACTION%>";
    }

        /*
              var stat = toCheckExpenseForExpenseType();
              if(!stat){
                  thisform.amount.focus();
                  return false;
              }
              */

        thisform.submit();
        return;
    }
}

function searchInteractions() {
    var thisform = document.addInteractionForm;
    thisform.action = "<%=CONTEXTPATH%>/search_interaction_main.htm";
    thisform.target = "_top";
    thisform.submit();
}

function searchMyInteractions() {
    var thisform = document.addInteractionForm;
    thisform.action = "<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.PROFILE_INTERACTION%>&kolid=<%=kolid%>&expertId=<%=expertId%>";

    thisform.submit();
}


var checkURL = false;

function popup(){
  window.open("survey.html","survey",config='height=400,width=600, toolbar=no, menubar=no, scrollbars=yes, resizable=no,  location=no, directories=no, status=no');  
 }

function toggleAll()
{
    var image = dojo.byId("allImg");
    if( checkURL){
        image.src="images/buttons/plus.gif";
        checkURL = false;
    } else {
        image.src="images/buttons/minus.gif";
        checkURL = true;
    }
    toggleAllSections(checkURL);
}

dojo.addOnLoad(function(){
  closeAllSections();
  setTimeout("openSection('intType')",300);
});
</script>

<body>
<form name="addInteractionForm" method="POST" AUTOCOMPLETE="OFF"  >
<input type="hidden" name="interactionId" value="<%=interactionId%>">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">

<% if (!"".equals(message)) { %>
<tr align="left" class="back-blue-02-light">
    <td>&nbsp;
        <font face ="verdana" size ="2" color="red">
            <b><%=message%></b>
        </font>
    <td>
</tr>
<% } %>

<tr align="left" valign="top">

<td>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">

<tr>
    <td height="10" align="left"  class="back-white"></td>
</tr>

<tr>
    <td>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table></td>
</tr>

<tr>
    <td height="10" align="left"  class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="10" height="20">&nbsp;</td>
            <% if (!"view".equalsIgnoreCase(mode)) { %>
            <td width="40" class="text-blue-01">
                <input type="button" onclick="saveInteraction()" style="background: transparent url(images/buttons/save_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 129px; height: 22px;"  name="sav_int" class="button-01"/></td>
            <td width="10">&nbsp;</td>
            <%
                String interactionsIconImageName = "interactions_expert.gif";
                String interactionsIconImageSize = "191";
                String interactionPageType = request.getParameter("intType");
                if (null != interactionPageType && interactionPageType.equalsIgnoreCase("org") ){
                    interactionsIconImageName = "interactions_for_org.gif";
                    interactionsIconImageSize = "224";
                }%>
            <td id ="myInt" width="10" class="text-blue-01"><input name="Submit332" type="button" class="button-01" style="border:0;background : url(images/buttons/<%=interactionsIconImageName%>);width:<%=interactionsIconImageSize%>px;height:23px;"  onClick="searchMyInteractions()"></td>
            <% }%>
            <td width="10">&nbsp;</td>


            <td class="text-blue-01">
                <input type="button" onclick="searchInteractions()" style="background: transparent url(images/buttons/search_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 144px; height: 22px;" value="" class="button-01" name="searc_int"/>
            	<input type="button" onclick="javascript:popup();" style="background: transparent url(images/buttons/evaluate.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 87px; height: 22px;"  name="evaluate" class="button-01"/>
            </td>
            <td>
                <DIV style="PADDING-RIGHT: 10px; FLOAT: right; font-size:10px">
                    <img id="allImg" class="toggleImg" src="images/buttons/plus.gif" onclick="javascript:toggleAll()"/> Expand/Collapse All &nbsp;&nbsp;
                </div>
            </td>

        </tr>
    </table></td>
</tr>

<tr>
    <td height="10" align="left"  class="back-white"></td>
</tr>

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
    <td width="10" rowspan="47" align="left" valign="top">&nbsp;</td>
</tr>

<tr>
    <td>
        <div class="reset colOuter">
            <div class="colTitle">
                <img id="intTypeImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('intType') "/>&nbsp;&nbsp;<%=prop1.getProperty("INTERACTION_TYPE_TITLE")%>
            </div>
            <div id="intTypeContent" class="colContent">



                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="10" height="20">&nbsp;</td>
                        <td width="50" class="text-blue-01">Type</td>
                        <td width="190">
                            <select name="interactionType" class="field-blue-01-180x20" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %>>
                                <%
                                    if (interactionTypeLookup != null && interactionTypeLookup.length > 0) {
                                        OptionLookup lookup = null;
                                        for (int i = 0; i < interactionTypeLookup.length; i++) {
                                            lookup = interactionTypeLookup[i];

                                %>
                                <option value="<%=lookup.getId()%>" <% if (interaction != null && interaction.getType() != null && interaction.getType().getId() == lookup.getId()) { %> selected <% } %> ><%=lookup.getOptValue()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </td>
                        <td width="40" class="text-blue-01">&nbsp;</td>
                        <td width="50" class="text-blue-01">Date *</td>
                        <td width="150" height="20">
                            <input type="text" size="15" name="interactionDate" readonly="true" class="field-blue-01-180x20" id="sel2"
                            <%
				if (interaction != null && interaction.getInteractionDate() != null) {
					java.util.Date interactionDate = interaction.getInteractionDate();
					SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
			%>
                                   value="<%=sdf.format(interactionDate)%>"
                            <% } %>
                            <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> ><a href="#" onclick="return showCalendar('sel1', '%m/%d/%Y', '24', true);"></td>
                        <td width="17%">&nbsp;<a href="#" onclick="return showCalendar('sel2', '%m/%d/%Y', '24', true);"><img src="images/buttons/calendar_24.png" width="22" height="22" border="0" align="top" ></a>
                        </td>
                        <td width="10">&nbsp;</td>
                        <td>
                            <% if (!"view".equalsIgnoreCase(mode)) { %>&nbsp;
                            <% } %>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div></div>
    </td>
</tr>

<tr>
<td height="20" align="left" valign="top" >

<div class="reset colOuter">
<div class="colTitle">
    <img id="attImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('att') "/>&nbsp;&nbsp;Attendee
</div>
<div id="attContent" class="colContent">

<table width="100%"  border="0" cellspacing="0" cellpadding="0">

<tr>
<td width="10" height="10" class="text-blue-01"></td>
<td class="text-blue-01"><table border="0" cellspacing="0" cellpadding="2">
<tr>
<td width="90" height="30" class="text-blue-01">Attendee List *
    <select name="attendeeList" multiple class="field-blue-18-400x100"
            <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >

        <%
            if (kolId != null && kolName!= null && !"".equals(kolName) && "".equalsIgnoreCase(mode) && (mainLink != null && mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("INTERACTIONS")) && (currentLink != null && !currentLink.equalsIgnoreCase("YES"))   ) {
        %>
        <option value="kol_<%=kolId%>_<%=kolName%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=kolName%>(expert)</option>
        <%
        } else if(orgId != null && orgName != null && "".equalsIgnoreCase(mode) && null != currentLink && currentLink.equalsIgnoreCase("YES")  && ( mainLink.equalsIgnoreCase("INTERACTIONS") || mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("ADVANCED_ORG_SEARCH")) ){
        %>
        <option value="org_<%=orgId%>_<%=orgName%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=orgName%>(ORG)</option>
        <%}%>
        <%
            Set attendeeList = null;
            int size = 0;

            if (interaction != null && interaction.getAttendees() != null) {
                attendeeList = interaction.getAttendees();

                Attendee attendee = null;
                size = attendeeList.size();
                Iterator attendeeIter = attendeeList.iterator();
                String attendeeName = "";
                String attendeeId = "";
                for(int i=0;i<size;i++) {
                    attendee = (Attendee) attendeeIter.next();
                    attendeeName = attendee.getName();
                    attendeeId = null;

                    if (attendee.getAttendeeType() == Attendee.KOL_ATTENDEE_TYPE) {
                        attendeeId = "kol_"+attendee.getUserId()+"_" + attendee.getName();
                        attendeeName += "(expert)";
                    } else if (attendee.getAttendeeType() == Attendee.OTHER_ATTENDEE_TYPE) {
                        attendeeName = attendee.getFirstName() + "_" + attendee.getLastName();
                        attendeeId = "otr_"+attendeeName + "("+attendee.getType()+")" + "("+attendee.getTa()+")" + "("+attendee.getTitle()+")" + "("+attendee.getState()+")("+attendee.getCity()+")("+attendee.getZip()+")";
                        attendeeName = attendee.getFirstName() + " " + attendee.getLastName();
                        attendeeName += "("+attendee.getType()+")" + "("+attendee.getTa()+")" + "("+attendee.getTitle()+")" + "("+attendee.getState()+")("+attendee.getCity()+")("+attendee.getZip()+ ")(Other)";
                    }else if(attendee.getAttendeeType() == Attendee.EMPLOYEE_ATTENDEE_TYPE){
                        attendeeId="emp_" + attendee.getUserId()+"_"+attendee.getName();
                        attendeeName = attendeeName + "(Employee)";
                    }else if(attendee.getAttendeeType() == Attendee.ORX_ATTENDEE_TYPE){
                        attendeeId="orx_" + attendee.getSsoid()+"_"+attendee.getName()+"_"+attendee.getSsname();
                        attendeeName = attendeeName;
                    }else if(attendee.getAttendeeType() == Attendee.ORG_ATTENDEE_TYPE){
                        attendeeId="org_" + attendee.getUserId()+"_"+attendee.getName();
                        attendeeName = attendeeName + "(ORG)";
                    }

                    if(orgId != null && orgName != null && "".equalsIgnoreCase(mode) &&
                            null != currentLink && currentLink.equalsIgnoreCase("YES")
                            && ( mainLink.equalsIgnoreCase("INTERACTIONS") || mainLink.equalsIgnoreCase("HOME")
                            || mainLink.equalsIgnoreCase("ADVANCED_ORG_SEARCH"))) {
                        if(orgId.equals(attendee.getUserId()+"")) {} else {
        %>

        <option value="<%=attendeeId%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=attendeeName%></option>

        <%    }

        } else if (kolId != null && kolName!= null && !"".equals(kolName) && "".equalsIgnoreCase(mode) && (mainLink != null && mainLink.equalsIgnoreCase("HOME") || mainLink.equalsIgnoreCase("INTERACTIONS")) && (currentLink != null && !currentLink.equalsIgnoreCase("YES")) ){
            if(kolId.equals(attendee.getUserId()+"")) {}else{
        %>
        <option value="<%=attendeeId%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=attendeeName%></option>
        <%
            }
        } else{%>
        <option value="<%=attendeeId%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=attendeeName%></option>
        <% }
        }
        }
        %>
    </select>
</td>

<td valign="bottom" style="padding-bottom:5px;"><table border="0" cellspacing="0" cellpadding="2">
    <% if (!"view".equalsIgnoreCase(mode)) { %>
    <tr>

        <td width="120" class="text-blue-01">&nbsp;</td>
        <td width="130" class="text-blue-01">Lookup Attendees:</td>
        <td width="355">&nbsp;</td>
    </tr>
    <tr>

        <td class="text-blue-01"></td>
        <td class="text-blue-01-link"><a href="#" onclick="javascript:searchHCP();" class="text-blue-01-link">Search <%=DBUtil.getInstance().hcp %></a></td>
        <td rowspan="3" align="left"  class="text-blue-01">(Do not add yourself as an attendee.  The name of the person creating an interaction is automatically included.)</td>
    </tr>
    <tr>

        <td class="text-blue-01">&nbsp;</td>
        <td class="text-blue-01-link">
            <a href="#" onclick="javascript:window.open('employee_search.htm?fromInteraction=yes','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no')">Employee</a>                 </td>
    </tr>
    <tr>
        <td class="text-blue-01">&nbsp;</td>
        <td class="text-blue-01"><a href="#" onclick="javascript:window.open('interaction_org_search.jsp','searchOrg','width=720,height=450,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');" class="text-blue-01-link">Organization</a></td>
        <td width="2">&nbsp;</td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td><span class="text-blue-01-link">
            <%--<a href="#" onclick="javascript:toCheckExpenseForExpenseType();" class="text-blue-01-link">Exp Check</a>--%>
        </span></td>
        <td>&nbsp;</td>
    </tr>
    <% } %>
</table></td>
</tr>
</table></td>
</tr>
<% if (!"view".equalsIgnoreCase(mode)) { %>
<tr>
    <td height="10" class="back-white">&nbsp;</td>
    <td height="10" class="back-white"><input name="Submit3222" type="button" style="border:0;background : url(images/buttons/delete_attendee.gif);width:128px; height:22px;" class="button-01" value="" onClick="deleteSelect();"></td>
</tr>
<% } %>
<tr>
    <td height="10" colspan="2" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
</table>
</div></div>
</td>
</tr>

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>

<!-- code starts from here -->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <!-- Code ends here -->
    <%@ include file = "interactionUI.jsp" %>
    <tr>
        <td height="10" align="left" valign="top"></td>
    </tr>
</table>

</div>



<%} if (!"view".equalsIgnoreCase(mode)) { %>
<table>  <tr>
    <td width="10" height="20">&nbsp;</td>
    <td width="40" class="text-blue-01">
        <input type="button" onclick="saveInteraction()" style="background: transparent url(images/buttons/save_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 129px; height: 22px;"  name="sav_int0" class="button-01"/>
    </td>
    <td width="10">&nbsp;</td>

    <%
        String interactionsIconImageName = "interactions_expert.gif";
        String interactionsIconImageSize = "191";
        String interactionPageType = request.getParameter("intType");
        if (null != interactionPageType && interactionPageType.equalsIgnoreCase("org") ){
            interactionsIconImageName = "interactions_for_org.gif";
            interactionsIconImageSize = "224";
        }%>
    <td id ="myInt" width="10" class="text-blue-01"><input name="Submit332" type="button" class="button-01" style="border:0;background : url(images/buttons/<%=interactionsIconImageName%>);width:<%=interactionsIconImageSize%>px;height:23px;"  onClick="searchMyInteractions()"></td>
    <td width="10">&nbsp;</td>
    <td width="10">&nbsp;</td>
    <td valign="top">
        <input type="button" onclick="searchInteractions()" style="background: transparent url(images/buttons/search_interaction.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 144px; height: 22px;" value="" class="button-01" name="searc_int0"/>&nbsp;
    </td>
</tr>
</table>
<% } %>
</form> </body>

<script type="text/javascript">
    if (document.getElementById("expenseType")) {
        var selText = document.getElementById("expenseType").options[document.getElementById("expenseType").selectedIndex].innerText;

        if (selText == "No Expense") {
            document.getElementById("expenseVenue").disabled = true;
        }
        if(document.getElementById("expenseVenue").disabled) {
            document.getElementById("amount").disabled = true;
        }
    }
</script>
<%
    session.removeAttribute("MESSAGE");
    session.removeAttribute("INTERACTION_DETAILS");
    session.removeAttribute("MODE");
%>