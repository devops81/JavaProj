<%@ include file="header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
<%@ page import="java.util.HashMap" %>
<%@page import ="java.util.Map"%>
<%@page import ="java.util.Set"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.eav.data.DataService"%>
<%@ page import="com.openq.utils.PropertyReader"%>
<%@ page import="java.lang.System"%>
<%@ page import="com.openq.web.controllers.InteractionConstants"%>
<%@ page import="com.openq.authentication.UserDetails" %>
<%
    String kolid = (String) request.getAttribute("KOL_ID");
    String expertId = (String) request.getAttribute("EXPERT_ID");
    String rootParentId = (String) request.getAttribute("ROOT_PARENT_ID");

    String currentKOLName = (String)(request.getSession().getAttribute(Constants.CURRENT_KOL_NAME) == null ? "" : request.getSession().getAttribute(Constants.CURRENT_KOL_NAME).toString().replaceAll("'","\\\\'"));

    String userId = (String)((UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER)).getId();

    String sel = null;
    if (null != session.getAttribute("SELECTED_PLAN")){
        sel = (String)session.getAttribute("SELECTED_PLAN");

    }

    OptionLookup[] interactionTypes = (OptionLookup[]) session.getAttribute("INTERACTION_TYPES");
    HashMap interactionTypesColor = new HashMap();

    if (interactionTypes != null) {
        String colour = "";
        int colourArrayLength = InteractionConstants.interactionLegends.length;
        int j = 0;
        for (int i = 0; i < interactionTypes.length; i++) {
                j = i%colourArrayLength;
                colour = InteractionConstants.interactionLegends[j];
             interactionTypesColor.put(interactionTypes[i].getOptValue(), colour);
        }
    }

    String userType = null;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();

    }
    String photos_url = CONTEXTPATH+"/olpic";

    java.util.Properties profileTabProp = DBUtil.getInstance().profileTabProp;

    boolean isEventsEnabled = false;
    String eventsEnabledPropVal = (String) session.getAttribute("isEventsFeatureEnabled");
    if((eventsEnabledPropVal != null) && ("true".equalsIgnoreCase(eventsEnabledPropVal)))
      isEventsEnabled = true;

    boolean isInteractionsEnabled = false;
    String interactionsEnabledPropVal = (String) session.getAttribute("isInteractionsFeatureEnabled");
    if((interactionsEnabledPropVal != null) && ("true".equalsIgnoreCase(interactionsEnabledPropVal)))
      isInteractionsEnabled = true;

    boolean isPlanEnabled = false;
    String planEnabledPropVal = (String) session.getAttribute("isStrategyFeatureEnabled"); // the plan feature is tied to the strategy feature
    if((planEnabledPropVal != null) && ("true".equalsIgnoreCase(planEnabledPropVal)))
      isPlanEnabled = true;

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
%>

<script language="javascript">

  dojo.require("dojo.fx");

    var globalSelectedIndex = 0;
    var selectedYear, selectedMonth, selectedDay;

    var myHandlers = {
    resetMenu : function(){
      dojo.style(dojo.byId('availabilityMenu'), "display", "none");
    }
  };

    function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1)
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

  function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }

  function showAvailabilityMenu(offsetX, offsetY, year, month, day){
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    var calFrame = dojo.byId('calendarFrame');
    var menuX = findPosX(calFrame) + offsetX + 20;
    var menuY = findPosY(calFrame) + offsetY;

    dojo.style(dojo.byId('availabilityMenu'), "display", "block");
    dojo.style(dojo.byId('availabilityMenu'), "width", "auto");
    dojo.style(dojo.byId('availabilityMenu'), "height", "auto");
    dojo.style(dojo.byId('availabilityMenu'), "top", menuY);
    dojo.style(dojo.byId('availabilityMenu'), "left", menuX);

    dojo.fx.wipeIn({
      node: dojo.byId('availabilityMenu'),
      duration: 300
    }).play();
  }

  function CreateEvent(kolName,id){

	        var thisform = document.interactionForm;
	        thisform.action = '<%=CONTEXTPATH%>/event_add.htm?eventdate='+selectedMonth+"-"+selectedDay+"-"+selectedYear+"&kolName="+kolName+"&kolId="+id;
	         thisform.submit();
	}

  function viewEvents(){
    window.open('event_add.htm?eventdate='+selectedYear+'-'+selectedMonth+'-'+selectedDay, 'eventDetails',"top=200,left=200,width=400,height=200,scrollbars=1,resizable=1");
  }

  function pageOnLoad(){
	setNotifyIcon();
    dojo.connect(document,"onclick", myHandlers, "resetMenu");
  }

  dojo.addOnLoad(pageOnLoad);

	function toggleAlertMode() {
		var iconName = document.getElementById('_alertIcon').src.toString();
	      var thisForm = document.editDeleteForm;
	      var action;
	      var flag = 0;
	      if (iconName.indexOf('disabled') > 0) {
	          if (confirm("Please confirm that you would like to receive e-mail when profile/interaction changes for "+'<%=currentKOLName%>'+". Press OK to confirm.")) {
	              document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
	              alert("E-mail alerts for Profile changes activated.");

	              setCookie( <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>, "enabled", 15);
	              action = "registerNotify";
	              flag = 1;

	              //alert(document.getElementById('_alertIcon').src);
	          }
	      } else {
	          if (confirm("Please confirm that you would not like to receive e-mail when profile/interaction changes for "+'<%=currentKOLName%>'+ ". Press OK to confirm.")) {
	              document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
	              alert("E-mail alerts for Profile changes de-activated.");
	              eraseCookie( <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>);
	              action = "deregisterNotify";
	              flag = 1;
	              //alert(document.getElementById('_alertIcon').src);
	          }
	      }

	      try{
	          if (window.XMLHttpRequest) {
	                  xmlHttp = new XMLHttpRequest();
	          } else if (window.ActiveXObject) {
	                  xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	          }
	      }catch (e){
	        alert("Your browser does not support AJAX!");
	        return false;
	      }
	      if(flag==1) {
	          var URL = "innerProfilePage.htm?action="+ action + "&fromExpertFullProfile=true&kolId=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>"
	          xmlHttp.open("GET", URL, true);
	          xmlHttp.onreadystatechange = function(){};
	          xmlHttp.send(null);

	      }
	}

	function addToMyTLList() {

		try{
            if (window.XMLHttpRequest) {
                    xmlHttp = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                    xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
        }catch (e){
          alert("Your browser does not support AJAX!");
          return false;
        }

		var URL = "searchKol.htm?fromExpertFullProfile=true&checkIds=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>";
		xmlHttp.open("GET", URL, true);
        xmlHttp.onreadystatechange = function(){responseProcessor(xmlHttp)};
        xmlHttp.send(null);
	}

	function responseProcessor(xmlHttp){
        //If the readystate is 4 then check for the request status.
            if (xmlHttp.readyState == 4) {
                if (xmlHttp.status == 200) {
                    // update the HTML DOM based on whether or not message is valid
                        alert(xmlHttp.responseText);
                }
            }
      }

    function changeStyle(selectedIndex, total)
    {
        for (var i = 0; i < total; i++)
        {
            if (i == selectedIndex)
            {
                if (document.getElementById("sec" + i)) {
                    document.getElementById("sec" + i).className = "submenu1";
                    document.getElementById("att" + i).className = "text-white-link";
                }
            }
            else
            {
                if (document.getElementById("sec" + i)) {
                    document.getElementById("sec" + i).className = "submenu2";
                    document.getElementById("att" + i).className = "text-black-link";
                }
            }
        }
        globalSelectedIndex = selectedIndex;

        changeInteractionStyle('no');
        changeAmgenContactStyle('no');
        changePlanStyle('no');
        changeEventStyle('no');
        changeTrialStyle('no');
		changeStrengthStyle('no');
		changeSummaryStyle('no');

     }

    function changeInteractionStyle(selected) {


        if (selected == "yes")
        {
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu1";
                document.getElementById("interactionAnchorId").className = "text-white-link";
            }
			if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }
            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-black-link";
            }
            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-black-link";
            }
			if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
            }

            changeTrialStyle('no');
            changeStrengthStyle('no');

        }
        else
        {
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
        }
    }

    function changeAmgenContactStyle(selected) {
        if (selected == "yes")
        {
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu1";
                document.getElementById("amgenContactAnchorId").className = "text-white-link";
            }
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }

            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-black-link";
            }
            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-black-link";
            }
			if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
           }
           if (document.getElementById("relatedorgId")) {
                    document.getElementById("relatedorgId").className = "submenu1";
                    document.getElementById("relatedorgAnchorId").className = "text-white-link";
           }

           changeTrialStyle('no');
           changeStrengthStyle('no');

        }
        else
        {
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
        }
    }

    function changeTrialStyle(selected) {
        if (selected == "yes")
        {
            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu1";
                document.getElementById("trialAnchorId").className = "text-white-link";
            }
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }

			if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
            }

            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-black-link";
            }

        }
        else
        {
            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-white-link";
            }
        }
    }
    function changeStrengthStyle(selected) {
        if (selected == "yes")
        {
            if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu1";
                document.getElementById("strengthAnchorId").className = "text-white-link";
            }
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }
			if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-black-link";
            }
            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
            }

            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-black-link";
            }

        }
        else
        {
            if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
        }
    }


     function changePlanStyle(selected) {
        if (selected == "yes")
        {
            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu1";
                document.getElementById("planAnchorId").className = "text-white-link";
            }

            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-white-link";
            }
			if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
            }
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }

        }
        else
        {
            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-black-link";
            }
        }
    }

    function changeSummaryStyle(selected) {
        if (selected == "yes")
        {
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu1";
                document.getElementById("summaryAnchorId").className = "text-white-link";
            }

            if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-white-link";
            }
            if (document.getElementById("planTdId")) {
                document.getElementById("planTdId").className = "submenu2";
                document.getElementById("planAnchorId").className = "text-white-link";
            }
			if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            }
            if (document.getElementById("sec" + globalSelectedIndex)) {
                document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
            }
            globalSelectedIndex = 0;
            if (document.getElementById("interactionTdId")) {
                document.getElementById("interactionTdId").className = "submenu2";
                document.getElementById("interactionAnchorId").className = "text-black-link";
            }
            if (document.getElementById("amgenContactId")) {
                document.getElementById("amgenContactId").className = "submenu2";
                document.getElementById("amgenContactAnchorId").className = "text-black-link";
            }
             if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
            }


        }
        else
        {
            if (document.getElementById("summaryTdId")) {
                document.getElementById("summaryTdId").className = "submenu2";
                document.getElementById("summaryAnchorId").className = "text-black-link";
            }
        }
    }
    //function setClass(){


    //}

    function changeEventStyle(selected) {
            if (selected == "yes")
            {
                if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu1";
                    document.getElementById("eventsAnchorId").className = "text-white-link";
                }
                if (document.getElementById("trialTdId")) {
                document.getElementById("trialTdId").className = "submenu2";
                document.getElementById("trialAnchorId").className = "text-black-link";
            	}

				if (document.getElementById("strengthTdId")) {
                document.getElementById("strengthTdId").className = "submenu2";
                document.getElementById("strengthAnchorId").className = "text-black-link";
            	}
                if (document.getElementById("sec" + globalSelectedIndex)) {
                    document.getElementById("sec" + globalSelectedIndex).className = "submenu2";
                    document.getElementById("att" + globalSelectedIndex).className = "text-black-link";
                }
                globalSelectedIndex = 0;
                if (document.getElementById("interactionTdId")) {
                    document.getElementById("interactionTdId").className = "submenu2";
                    document.getElementById("interactionAnchorId").className = "text-black-link";
                }
                if (document.getElementById("planTdId")) {
                    document.getElementById("planTdId").className = "submenu2";
                    document.getElementById("planAnchorId").className = "text-black-link";
                }
                if (document.getElementById("amgenContactId")) {
                    document.getElementById("amgenContactId").className = "submenu2";
                    document.getElementById("amgenContactAnchorId").className = "text-black-link";
                }
                if (document.getElementById("summaryTdId")) {
	                document.getElementById("summaryTdId").className = "submenu2";
	                document.getElementById("summaryAnchorId").className = "text-black-link";
	            }

                changeTrialStyle('no');
                changeStrengthStyle('no');
            }
            else
            {
                if (document.getElementById("eventId")) {
                    document.getElementById("eventId").className = "submenu2";
                    document.getElementById("eventsAnchorId").className = "text-black-link";
                }
            }
        }


    function hideExpertInfo(sectionName) {
		 if (document.getElementById("sec" + indexOfPub)) {
                    document.getElementById("sec" + indexOfPub).className = "submenu2";
                    document.getElementById("att" + indexOfPub).className = "text-black-link";
		 }
        if ("Interactions" == sectionName) {
            document.getElementById("expertInfoPanel").style.display = "none";
            document.getElementById("rightContent").style.width="100%";
        } else {
            document.getElementById("expertInfoPanel").style.display = "block";
            document.getElementById("rightContent").style.width="auto";
        }
    }

  function resizeIFramesFullProfile(){
    var frame = document.getElementById('inner');
    frame.height = frame.Document.body.scrollHeight;
  }

  function resizeIFramesFullProfile(i){
    var frame = document.getElementById('inner');
    frame.height = frame.Document.body.scrollHeight;
//    highlightMainTab(3,5)
  }

  function hideSubMenuDiv(secId){
       //window.frames["inner"].document.getElementById("subMenu1").style.display="none";
       document.getElementById("subMenu"+secId).style.display="none";


  }

  function showSubMenuDiv(secId){
       var sectionId=dojo.byId(secId);
       var menuX=findPosX(sectionId);
       var menuY=findPosY(sectionId)

       var offsetY=29;//this is the height of a tab in px
       var offsetX=0;
       document.getElementById('subMenu'+secId).style.display="block";
       document.getElementById('subMenu'+secId).style.left=menuX+offsetX;
       document.getElementById('subMenu'+secId).style.top=menuY+offsetY;

  }

  function highlightSubMenu(divId){
	  //alert('HighLight Called ');
    document.getElementById(divId).className="submenu1"
  }

  function dehighlightSubMenu(divId){
	  //alert('DeHighLight Called ');
    document.getElementById(divId).className="submenu2"
  }

  function highlightMainTab(secId,length){
    changeStyle(secId,length);
    document.getElementById("subMenusec"+secId).style.display="none";

  }

  function setNotifyIcon() {
      if (getCookie(  <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>)) {
          document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
      } else {
          document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
      }
  }

</script>
<%
  HashMap leftNavMap = (HashMap) request.getSession().getAttribute("leftNavMap");
  String ol_fName = "", ol_lName = "", ol_mName = "", ol_specialty1 = "", ol_specialty2 = "", ol_specialty3 = "", ol_specialty4 = "", ol_specialty5 = "", ol_specialty6 = "", ol_gender = "", ol_global = "", ol_prefix = "", ol_suffix = "";
  String ol_photo = "";
  String [] ol_tierInfo = null;
  String ol_all_speciality = null;
  String ol_imageName = "noimage.jpg";
  if (leftNavMap != null) {
    ol_fName = (String) leftNavMap.get((String)session.getAttribute("firstname"));
    ol_lName = (String) leftNavMap.get((String)session.getAttribute("lastname"));
    ol_mName = (String) leftNavMap.get((String)session.getAttribute("middlename"));



    //ol_imageName = "Photo_"+ol_fName +"_"+ol_lName+".jpg";
    ol_imageName = (String) leftNavMap.get((String)session.getAttribute("image"));


    ol_specialty1 = (String) leftNavMap.get((String)session.getAttribute("specialty1"));
    ol_specialty2 = (String) leftNavMap.get((String)session.getAttribute("specialty2"));
    ol_specialty3 = (String) leftNavMap.get((String)session.getAttribute("specialty3"));
    ol_specialty4 = (String) leftNavMap.get((String)session.getAttribute("specialty4"));
    ol_specialty5 = (String) leftNavMap.get((String)session.getAttribute("specialty5"));
    ol_specialty6 = (String) leftNavMap.get((String)session.getAttribute("specialty6"));

   ol_all_speciality = ol_specialty1;
		ol_all_speciality += (ol_all_speciality != null && !(ol_all_speciality.trim().length()==0) && ol_specialty2 != null && !(ol_specialty2.trim().length()==0)? ", " + ol_specialty2 : (ol_specialty2 != null ? ol_specialty2 : ""));
		ol_all_speciality += (ol_all_speciality != null && !(ol_all_speciality.trim().length()==0) && ol_specialty3 != null && !(ol_specialty3.trim().length()==0)? ", " + ol_specialty3 : (ol_specialty3 != null ? ol_specialty3 : ""));
		ol_all_speciality += (ol_all_speciality != null && !(ol_all_speciality.trim().length()==0) && ol_specialty4 != null && !(ol_specialty4.trim().length()==0)? ", " + ol_specialty4 : (ol_specialty4 != null ? ol_specialty4 : ""));
		ol_all_speciality += (ol_all_speciality != null && !(ol_all_speciality.trim().length()==0) && ol_specialty5 != null && !(ol_specialty5.trim().length()==0)? ", " + ol_specialty5 : "");

		ol_all_speciality += (ol_all_speciality != null && !(ol_all_speciality.trim().length()==0) && ol_specialty6 != null && !(ol_specialty6.trim().length()==0)? ", " +ol_specialty6:(ol_specialty6 != null ? ol_specialty6 : ""));

    ol_gender = (String) leftNavMap.get((String)session.getAttribute("gender"));
    ol_prefix = (String) leftNavMap.get((String)session.getAttribute("prefix"));
    ol_suffix = (String) leftNavMap.get((String)session.getAttribute("suffix"));

    ol_tierInfo = (String []) leftNavMap.get("tierInfo");
  }
  
%>
<body>
<%
      //EntityAttribute [] attributes = (EntityAttribute []) request.getSession().getAttribute("attributes");
      AttributeType [] attributes = (AttributeType []) request.getSession().getAttribute("attrTypes");
      HashMap map = (HashMap) request.getSession().getAttribute("attributesMap");
      HashMap attrEntityMap=(HashMap) request.getAttribute("attrEntityMap");
      int colspan = 1;
      HashMap subAttrMap=(HashMap)request.getAttribute("subAttrMap");


    %>
<% for(int i=0;i<attributes.length;i++){
    AttributeType[] subAttr=(AttributeType[])subAttrMap.get(attributes[i]);
   	HashMap subAttrEntityMap=(HashMap)attrEntityMap.get(attributes[i]);
%>
<div id="subMenusec<%=i %>" style="display:none;width:200px;position:absolute;left:315px;top:180px" onMouseOver="javascript:parent.showSubMenuDiv('sec<%=i %>')" onMouseOut="javascript:hideSubMenuDiv('sec<%=i%>')" >
          <% for(int j=0;j<subAttr.length;j++){
                EntityAttribute entityAttr=(EntityAttribute)subAttrEntityMap.get(subAttr[j]);
                if(subAttr[j].isShowable()){
          %>
          <div id="subAttrDiv<%=j %><%=i %>" class="submenu2" style="text-align:left;padding-top:7px" onMouseOver="javascript:highlightSubMenu('subAttrDiv<%=j %><%=i %>')"  onMouseOut="javascript:dehighlightSubMenu('subAttrDiv<%=j %><%=i %>')">&nbsp;
		 		<% if(subAttr[j].getName().equalsIgnoreCase("Org. Affiliations")){%>
			 		<a style="text-decoration:none" onClick="javascript:highlightMainTab('<%=i %>','<%=attributes.length %>')" href="related_org.jsp?kolId=<%=kolid%>&selected='Affiliations'&parentId=<%=entityAttr.getParent().getId()%>&currentKOLName=<%=currentKOLName%>"" target="inner"  id="href<%=i%>" >
			 		  <span  class="exnormal" style="padding-top:6pt;text-align:left"><%=subAttr[j].getName() %></span>
			 		</a>
		 		<%}else{
		 				if("Surveys".equalsIgnoreCase(subAttr[j].getName())){%>
		 				<a style="text-decoration:none" onClick="javascript:highlightMainTab('<%=i %>','<%=attributes.length %>')" href="relatedSurvey.htm?kolId=<%=kolid%>&selected='Survey'&parentId=<%=entityAttr.getParent().getId()%>&currentKOLName=<%=currentKOLName%>"" target="inner"  id="href<%=i%>" >
			 		  <span  class="exnormal" style="padding-top:6pt;text-align:left"><%=subAttr[j].getName() %></span>
			 		</a>

		 		<%}else{%>


		 		<a style="text-decoration:none" onClick="javascript:highlightMainTab('<%=i%>','<%=attributes.length %>')" href='innerProfilePage.htm?rootParentId=<%=rootParentId%>&attributeId=<%=subAttr[j].getAttribute_id()%>&entityId=<%=entityAttr.getMyEntity().getId()%>&selected=<%=attributes[i].getName()%>&parentId=<%=entityAttr.getParent().getId()%>&displayName=<%=subAttr[j].getName()%>&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>'
		                   target="inner">
		 		<span  class="exnormal" style="padding-top:6pt;text-align:left"><%=subAttr[j].getName() %></span></a>
		 		<%}} %>
		  </div>
		  <%    }
		     }
		  %>
</div>
<%} %>

<div id="availabilityMenu" style="position: absolute; display: none; text-align: left; left:7px; top:17px"></div>
                    <!--
                      Following is a dummy form which is used by the calendar widget to set the selected date.
                      Note the name of the form and the the input field are fixed. If they are changed the
                      calendar widget would start showing javascript errors.
                    -->
                    <form name="demoForm">
                      <input type="hidden" name="dateField"/>
                    </form>
<form name="interactionForm" method="POST" AUTOCOMPLETE="OFF" onload="javascript:setClass()">

<div class="contentmiddle" style="vertical-align:top;">
  <div class="reportcontentleft" id="expertInfoPanel">
       <div class="koldetails" >
	        <div class="manpic"><img align="center" onerror="javascript:document.getElementById('_OlImage').src = 'photos/noimage.jpg';" id="_OlImage" src="<%=photos_url%>/photos/<%=ol_imageName%>" width="202" height="172"/></div>
	        <div class="profileguesttext" style="text-align:center;">
	           <%
	            if (ol_fName != null || ol_mName != null || ol_lName != null) {
	          %>
	            <span class="text-blue-01-bold_profile"><%=ol_prefix == null ? "" : ol_prefix%> <%=ol_fName == null ? "" : ol_fName%> <%=ol_mName == null ? "" : ol_mName%> <%=ol_lName == null ? "" : ol_lName%> <%=ol_suffix == null ? "" : ol_suffix%></span><br>
	           <% } else {%>
	             <span class="text-blue-01-bold_profile"><c:out escapeXml="false" value="${kolUser.firstName}"/> <c:out escapeXml="false" value="${kolUser.middleName}"/> <c:out escapeXml="false" value="${kolUser.lastName}"/></span>
	           <% } %>
	            <span class="text-blue-01-bold_profile"><c:out escapeXml="false" value="${kolUser.location}"/></span>
	        </div>

	        <div align="center">
                    <table width="217" border="0">
                     <tr>
                     <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                      { %>
                     <td valign="top" align="right" width="43" style="cursor:hand">
                     <a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>
                     <img src='images/vCard.jpg' border=0 height="32" title="Download Vcard"></a>
                     </td>
                     <% } %>

                      <td width="15" height="30"> &nbsp;
                     </td>

                 <%
                 if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") &&
                         !isSAXAJVUser && !isOTSUKAJVUser)
                 { %>
                 <td valign="top" align="right" width="13" style="cursor:hand"
                     onClick="javascript:window.open('printFullProfile.htm?rootParentId=<%=rootParentId%>&currentKOLName=<%=currentKOLName%>')">
                     <img src='images/print_profile.gif' border=0 height="32" title="Printer friendly format"/>
                 </td>
                 <% } %>

                 <td width="15" height="30">
                    &nbsp;</td>

                 <td valign="top" align="right" width="5" style="cursor:hand" onClick="addToMyTLList()">
                    <img src='images/addpic.jpg' border=0 height="32" title="Add to My List"/></td>
                 <td width="15" height="30">
                    &nbsp;</td>
                 <td valign="top" align="top" width="45" onclick="toggleAlertMode()" style="cursor:hand"><img id='_alertIcon' border=0 src='images/alert-disabled.gif' height=32 alt='Alert me when data changes for this <%=DBUtil.getInstance().doctor%>.'/>
                </td>
              </tr>

              <tr>
                 <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") )
                 { %>
                <td valign="top" align="right"  height="30" width="43" style="cursor:hand"><a class="text-blue-link" href='expertfullprofile.htm?action=<%=ActionKeys.DOWNLOAD_VCARD %>'>Vcard</a></td>
                 <% } %>


                  <td width="22" height="30">&nbsp;</td>
                 <% if ( request.getParameter("currentKOLName") != null && !request.getParameter("currentKOLName").equals("") &&
                         !isSAXAJVUser && !isOTSUKAJVUser)
                 { %>
                <td valign="top" align="right"  height="30" width="36" style="cursor:hand" onClick="javascript:window.open('printFullProfile.htm?rootParentId=<%=rootParentId%>&currentKOLName=<%=currentKOLName%>')"><a class="text-blue-link" href="#">Profile</a></td>
                 <% } %>

                 <td width="14" height="30">&nbsp;</td>
                 <td valign="top" align="right"  height="30" width="5" style="cursor:hand" onClick="javascript:addToMyTLList()"><a class="text-blue-link" href="#" >Add</a></td>
                 <td width="15" height="30">&nbsp;</td>
                 <td height="30" valign="top" align="right" width="5" onclick="javascript:toggleAlertMode()" style="cursor:hand"><a class="text-blue-link" href="#">Notify</a></td>
                 <td width="5" height="30">&nbsp;</td>
              </tr>
                     </table>

                 </div>

            <%
                // Render the availablity-related fields only if events are enabled
                if(isEventsEnabled) {
            %>
	        <div class="leftsearchbgpic">
                 <div class="contentleft">
             		<div class="leftprofiletext">Availability</div>
            	</div>
         </div>
	        <div class="profileguesttext" style="text-align:center;">
              <table width="217" align="center">

			  </table>
              <table width="195" align="center">
                <tr>
                  <td id=calendarFrame valign="top" align="center" colspan="2" height="179">
                    <iframe width="193" height=163 name="gToday:normal:agenda.jsp?disablePopup=true&source=1expert"
                                                         id="gToday:normal:agenda.jsp?disablePopup=true&source=1expert"
                                                         src="calendar/calendar.htm?abc=calendar&source=1expert&kolid=<%=kolid%>" scrolling="no" frameborder="0"></iframe>
                 </td>
	</tr>
	<tr>
		<td><span class="text-blue-09-bold">Events:</span></td>
	</tr>
                <tr>
                  <td style= "display:none" valign="top" width="114" height="5px">
                    &nbsp;&nbsp;
                    <img src="images/008000.gif"/>
                    <span class="text-blue-09">1st Preference</span>                  </td>
                  <td style= "display:none" valign="top" width="100" height="5px">
                    <img src="images/accepted.gif"/>
                    <span class="text-blue-09">Accepted</span></td>
                    <td valign="top" width="104">
                    <img src="images/invited.gif"/>
                    <span class="text-blue-09">Invited</span></td>
                    <td valign="top" width="75">
                    <img src="images/rejected.gif"/>
                    <span class="text-blue-09">Attended</span></td>
                </tr>

                <tr>
                  <td style= "display:none"  valign="top" width="100">

                    <img src="images/FF0000.gif"/>
                    <span class="text-blue-09">Unavailable</span>                  </td>

                </tr>
	<tr>
		<td><span class="text-blue-09-bold">Interactions:</span></td>
	</tr>

	<%
	    for (int i = 0; interactionTypes != null && i < interactionTypes.length; i += 2) {
	%>
	<tr>
		<td>
		<div
			style="FONT-SIZE: 10px; FLOAT: left; WIDTH: 11px; HEIGHT: 1px;background-color: <%=interactionTypesColor.get(interactionTypes[i].getOptValue())%>;padd">&nbsp;
		</div>
		<div style="padding-left: 10px"><span class="text-blue-09"><%=interactionTypes[i].getOptValue()%></span>
		</div>
		</td>

		<%
		    if ((i + 1) < interactionTypes.length) {
		%>
		<td>
		<div
			style="FONT-SIZE: 10px; FLOAT: left; WIDTH: 11px; HEIGHT: 1px;background-color: <%=interactionTypesColor.get(interactionTypes[i + 1].getOptValue())%>;padd">&nbsp;
		</div>
		<div style="padding-left: 10px"><span class="text-blue-09"><%=interactionTypes[i + 1].getOptValue()%></span>
		</div>
		</td>
		<td>&nbsp;</td>
		<%
		    }
		%>
	</tr>
	<%
	    }
	%>
              </table>
	        </div>
            <%
              }
            %>
      </div><!-- KOL Details -->
  </div><!--content left ends here-->
    <div class="contentright" id="rightContent">

      <div class="submenu" >
	      <table width="100%" cellspacing="0" cellpadding="0" height="36">
	      	<tr width="100%" >
	      	   <td  align ="left" >
				       <div onClick="javascript:changeSummaryStyle('yes')" id="summaryTdId">
				          &nbsp;
				            <a id="summaryAnchorId"
				                   href="printSummaryProfile.htm?kolid=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<c:out escapeXml="false"
                             	   value="${parentId}"/>&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>"
				                   target="inner" onClick="hideExpertInfo('Summary')" class="text-black-link" >
				            <span class="exnormal" >Summary</span>
				        </a>

				      </div>
   			  </td>

	            <%
	                for (int i = 0; i < attributes.length; i++) {
	                  // TODO: Putting in the following condition check to prevent existing "Trials" EAV attribute
	                  // in OL Profile from being rendered for genentech-demo. We will instead use the new OL-trial-map

	            %>
	     	  <td align="center">

		         <div align="left" id="sec<%=i%>" onMouseOver="javascript:showSubMenuDiv('sec<%=i%>')" onMouseOut="javascript:hideSubMenuDiv('sec<%=i%>')">
		                     &nbsp;

		           <a style="text-decoration:none" id="att<%=i%>"  target="_top" onClick="hideExpertInfo('<%=attributes[i].getName()%>')"
		                   class='<%=((i != 0) ? "text-black-link" : "text-white-link")%>'>
		             <span class="exnormal" align="center" >
		           <%=attributes[i].getName()%></span>
		           </a>
		         </div>

	          </td>

		            <%  // } // end if
		              }
		            %>

		        <!-- Strengths Tab -->

		          <% //to control the visibility of non EAV summary tab Strength
		             boolean viewStrength=true;
		             String strengthVisibility= profileTabProp.getProperty("TRIAL");
		          	 String[] allowedUserForStrength=strengthVisibility.split(",");
		             for(int i=0;i<allowedUserForStrength.length;i++){
		                if(allowedUserForStrength[i].equalsIgnoreCase(userType)){
		                     viewStrength=true;
		                     break;
		                }
		             }
		             if(viewStrength != false){
		           %>
		            <td  align ="left" style="display: none" >
				       <div  onClick="javascript:changeStrengthStyle('yes')" id="strengthTdId">
				          &nbsp;
				            <a id="strengthAnchorId"
				                   href="reportsViewer.htm?&kolId=<%=kolid%>&reportName=Strength-Report&reportOnly=true&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>"
				                   target="inner" onClick="hideExpertInfo('Strength')" class="text-black-link" >
				            <span class="exnormal" >Strength</span>
				        </a>

				      </div>
	      			</td>
	      		<%} %>
		        <!-- End Clinical Trials Tab -->

                <%
                  // Render the events tab only if events are enabled
                  if(isEventsEnabled && !isSAXAJVUser && !isOTSUKAJVUser) {
                %>

				   <td  align ="left"  >
				       <div onClick="javascript:changeEventStyle('yes')" id="eventId">
				          &nbsp;
				           <a id="eventsAnchorId" href="event_search.htm?action=<%=ActionKeys.SHOW_EVENTS_BY_EXPERT%>&kolId=<%=kolid%>"
					target="inner" onClick="hideExpertInfo('Events')"
					class="text-black-link">
				            <span class="exnormal" >Medical Meetings</span>
				        </a>

				      </div>
   			  </td>
                  <%
                    }
                  %>


		         <% //to control the visibility of non EAV summary tab PLAN
		         	 boolean viewPlan=false;
                  if(isPlanEnabled) { // Render the plan tab only if the plan feature is enabled in features.properties
		          	 String planVisibility= profileTabProp.getProperty("PLAN");
		             String[] allowedUserForPlan=planVisibility.split(",");
		             for(int i=0;i<allowedUserForPlan.length;i++){
		                if(allowedUserForPlan[i].equalsIgnoreCase(userType)){
		                     viewPlan=true;
		                     break;
		                }
		             }
		         if(viewPlan){ %>
	              <td  align ="left" >
			       <div onClick="javascript:changePlanStyle('yes')" id="planTdId">
			          <!-- td onclick="javascript:changePlanStyle('yes')" id="planTdId"-->&nbsp;
			                <a id="planAnchorId"  class="text-black-link" href="javascript:printUnavailableMessage()">
			                <span class="exnormal" >Medical Strategy</span>
			                </a>
			      </div>
	      		</td>
               <%
                    }
                  }
               %>
	           <%   //to control the visibility of non EAV summary tab INTERACTION
	           		boolean viewInteraction=false;
                       if(isInteractionsEnabled) { // Render the interactions tab only if the interactions feature is enabled in features.properties
		          	 String interactionVisibility= profileTabProp.getProperty("INTERACTION");
		             String[] allowedUserForInteraction=interactionVisibility.split(",");
		             for(int i=0;i<allowedUserForInteraction.length;i++){
		                if(allowedUserForInteraction[i].equalsIgnoreCase(userType)){
		                     viewInteraction=true;
		                     break;
		                }
		             }
		             if(viewInteraction){

	           			if(!(((String)request.getSession().getAttribute(Constants.CURRENT_KOL_ID_SET)).equalsIgnoreCase("YES"))){%>
				           <td  align ="left"  >
					           <div onClick="javascript:changeInteractionStyle('yes')" id="interactionTdId">
					                <!-- td onclick="javascript:changeInteractionStyle('yes')" id="interactionTdId"-->&nbsp;
					                <a id="interactionAnchorId"
					                   href="search_interaction_main.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>&selected='Interaction'&kolId=<%=kolid%>&expertId=<%=expertId%>"
					                   onClick="hideExpertInfo('Interactions')" class="text-black-link">
					            <span class="exnormal" >Interactions</span>
                                 </a>
                               </div>
              </td>
                <%
                        }
                      }
                    }
                %>

	            	<%//to control the visibility of non EAV summary tab CONTACTS
	            	boolean viewContacts=false;
		          	 String contactsVisibility= profileTabProp.getProperty("CONTACTS");
		             String[] allowedUserForContacts=contactsVisibility.split(",");
		             for(int i=0;i<allowedUserForContacts.length;i++){
		                if(allowedUserForContacts[i].equalsIgnoreCase(userType)){
		                     viewContacts=true;
		                     break;
		                }
		             }
		             if(viewContacts){

	            	 %>
			            <td style="display:none" align ="left" style="display: none">
				           <div onClick="javascript:changeAmgenContactStyle('yes')" id="amgenContactId">&nbsp;
				                <!-- td valign="middle" width="120" align="center" onclick="javascript:changeAmgenContactStyle('yes')" id="amgenContactId"-->
				                <a id="amgenContactAnchorId" href="contacts.htm?kolId=<%=kolid%>&selected='Contacts'&parentId=<c:out escapeXml="false" value="${parentId}"/>&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>"
				                   target="inner" onClick="hideExpertInfo('Contacts')" class="text-black-link">
				            <span class="exnormal" >BMS Affiliations</span>
				           </a>
				           </div>
			           </td>
			         <%
			          }
			          %>
            </tr>

        </table>
      </div><!--submenue ends here-->
<div  class="reset producttext">

    <%		String fromInteraction = null;
              if(request.getAttribute("fromInteractionLink") != null)
                fromInteraction = (String)request.getAttribute("fromInteractionLink");
                String fromHome = null;
                if (null != session.getAttribute("fromHome")){
                     fromHome = (String)request.getAttribute("fromHome");;
                }
                if(fromInteraction != null && "yes".equals(fromInteraction)){
       %>
              <script type="text/javascript">

                javascript:hideExpertInfo("Interaction");
              </script>
              <iframe src='search_interaction_main.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>'
                        height="950" width="100%" name="inner" id="inner" frameborder="0" scrolling="auto" target="_parent" onload="javascript:resizeIFramesFullProfile();"></iframe>
              <%  }else if (sel !=null && "yes".equals(sel)){  %>
                <iframe src='searchInteraction.htm?action=<%=ActionKeys.DEV_PLAN_HOME%>'
                        height="950" width="100%" name="inner" id="inner" frameborder="0" scrolling="auto" target="_parent" onload="javascript:resizeIFramesFullProfile();"></iframe>

                <%}
                else{

                if(request.getAttribute("go")==null){%>
	                <iframe src='printSummaryProfile.htm?kolid=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&entityId=<c:out escapeXml="false"
                             value="${parentId}"/>&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>'
                            height="600" width="100%" name="inner" id="inner" frameborder="0"
	                        scrolling="no" onload="javascript:resizeIFramesFullProfile();"></iframe>

            <%  }else{
                   for(int i=0;i<attributes.length;i++){
                      if(attributes[i].getName().equalsIgnoreCase("publications")){%>
                         <iframe src='innerProfilePage.htm?rootParentId=<%=rootParentId%>&attributeId=<%=attributes[i].getAttribute_id()%>&entityId=<%=(map.get(attributes[i]) != null ? ((EntityAttribute) map.get(attributes[i])).getMyEntity().getId() + "": "")%>&parentId=<c:out escapeXml="false" value="${parentId}"/>&currentKOLName=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_NAME)%>'
	                        height="600" width="100%" name="inner" id="inner" frameborder="0"
	                        scrolling="auto" onload="javascript:resizeIFramesFullProfile(2);"></iframe>
               <% }

                   }
            }
            }  %>



  </div>
</div><!--content right-->
</div><!--content middle-->
</div>
</form>
<%@ include file="footer.jsp" %>

</body>
<%
    String from = "from";
    if(request.getAttribute("FROM") != null &&
            !"".equals(request.getAttribute("FROM"))) {
        from = (String) request.getAttribute("FROM");
    }
%>
<script type="text/javascript">

      var j=1;
      var indexOfPub=0;
</script>
      <%
        if(request.getAttribute("go")!=null){%>

           <%for(int i=0;i<attributes.length;i++){%>
             <%if(attributes[i].getName().equalsIgnoreCase("publications")){
              %>
			  <script type="text/javascript">
               document.getElementById("sec<%=i%>").className = "submenu1";
               document.getElementById("sec0").className="submenu2";
               document.getElementById("summaryTdId").className="submenu2";
               var indexOfPub=<%=i%>;
              </script>
      <%     }
      		}
      }else{%>
              <script type="text/javascript">
                 document.getElementById("summaryTdId").className = "submenu1";
                 document.getElementById("sec0").className="submenu2"
              </script>
       <%

         }  %>
     <script type="text/javascript">
      document.getElementById("att0").className = "text-white-link";
      while(document.getElementById("sec" + j)!=null){

           if(indexOfPub!=j){
              document.getElementById("sec" + j).className = "submenu2";
	          document.getElementById("att" + j).className = "text-black-link";
	         }

          j++
       }
       if (document.getElementById("interactionTdId")) {
            document.getElementById("interactionTdId").className = "submenu2";
            document.getElementById("interactionAnchorId").className = "text-black-link";
       }
       if (document.getElementById("planTdId")) {
             document.getElementById("planTdId").className = "submenu2";
             document.getElementById("planAnchorId").className = "text-black-link";
       }
       if (document.getElementById("eventId")) {
             document.getElementById("eventId").className = "submenu2";
             document.getElementById("eventsAnchorId").className = "text-black-link";
       }
       if (document.getElementById("trialTdId")) {
             document.getElementById("trialTdId").className = "submenu2";
             document.getElementById("trialAnchorId").className = "text-black-link";
       }
       if (document.getElementById("strengthTdId")) {
             document.getElementById("strengthTdId").className = "submenu2";
             document.getElementById("strengthAnchorId").className = "text-black-link";
       }
       if (document.getElementById("amgenContactId")) {
             document.getElementById("amgenContactId").className = "submenu2";
             document.getElementById("amgenContactAnchorId").className = "text-black-link";
       }

    if('<%=from%>' == 'fromSearchHome') {
        changeInteractionStyle('yes');
        hideExpertInfo('Interactions');
        var form = document.interactionForm;
        form.action="interaction.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>";
        form.target = "inner";
        form.submit();
    }

    var planSel = "<%=sel%>";

    if (planSel == "yes"){
       changePlanStyle('yes');
       hideExpertInfo('Plan');
       var form = document.devPlans;
       if (form){
           form.action="searchInteraction.htm?action=<%=ActionKeys.DEV_PLAN_HOME%>";
           form.target = "inner";
           form.submit();
       }
    }

</script>

<% session.removeAttribute("SELECTED_PLAN");%>
