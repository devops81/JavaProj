<%@ include file="header.jsp" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.web.ActionKeys" %>
<%@ page import="com.openq.alerts.data.AlertQueue" %>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.openq.report.Report"%>
<%@page import="java.util.ArrayList"%>

<%
  OptionLookup [] stateAbbriviation = (OptionLookup [])request.getSession().getAttribute("stateAbbriviation");
  Report report1 = null;
  Report report2 = null;
  Collection reports = (Collection)session.getAttribute("reportsList");
  Collection dashlets = new ArrayList();
  for(Iterator itr = reports.iterator(); itr.hasNext();){
    Report report = (Report) itr.next();
    String reportName = report.getName();
    if(reportName.indexOf("-Dashlet")<0) continue;
    dashlets.add(report);
    if(report1==null) {
      report1 = report;
      continue;
    }
    else if (report2==null) {
      report2 = report;
    }
  }
  if(report2 == null){
 	report2 = report1;
  }
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

<script type="text/javascript">

function popup(){
 window.open("survey.html","survey",config='height=400,width=600, toolbar=no, menubar=no, scrollbars=yes, resizable=no,  location=no, directories=no, status=no');  
}

function hideDefault(input){
  if(typeof(input.defaultValue)=="undefined")
    input.defaultValue = input.value;
    if(input.value == input.defaultValue)
         input.value = "";

}

function showDefault(input){
  if(input.value == "" && typeof(input.defaultValue) != "undefined")
    input.value = input.defaultValue;
}
function checkInput() {

    if (document.home.searchText.value == null || document.home.searchText.value == "" || document.home.searchText.value == '<%= Constants.SEARCH_TEXT_MESSAGE %>')
  {
    alert('Please enter keyword');
    return;
  }
  else if(document.home.searchText.value.length <2)
  {
  	alert('Minimum number of characters required is 2');
  }
  else
  {
  openProgressBar();
  document.home.searchText.value = checkAndReplaceApostrophe(document.home.searchText.value);
    document.home.submit();
  }
}

function checkOrg(){

  if(document.home.organization.value != ''&& document.home.organization.value!='<Organization>'){
    openProgressBar();
    document.home.organization.value = checkAndReplaceApostrophe(document.home.organization.value);
    document.home.submit();
  }else{
    alert("Please enter Orginzation name ");
  }
}

</script>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js" djConfig="parseOnLoad: true"></script>

<script type="text/javascript">
  dojo.require("dojo.dnd.source"); 
  dojo.require("dojo.parser");
  dojo.require("dojo.cookie");
  dojo.require("dijit.layout.ContentPane");
  dojo.require("dojo.fx");
  dojo.require("dojox.fx.easing");

  function getLoadingMsg(){
    return loadingMessageHtml;
  }

  var reportsNameArray = new Array();
  <%
    for(Iterator itr=dashlets.iterator();itr.hasNext();){
      Report report = (Report)itr.next();
      %>
  reportsNameArray["<%=report.getReportID()%>"] = "<%=report.getName().replaceAll("-Dashlet","")%>";
      <%
    }
  %>
  var report1IDDef = <%=report1==null ? -1 : report1.getReportID()%>;
  var report2IDDef = <%=report2==null ? -1 : report2.getReportID()%>;
  var report1TitleDef = "<%=report1==null? "Report Not Found" : report1.getName().replaceAll("-Dashlet","")%>";
  var report2TitleDef = "<%=report2==null? "Report Not Found" : report2.getName().replaceAll("-Dashlet","")%>";
  var reportPaneName = "";
  var loadingMessageHtml = "<div class=\"text-blue-01\" style=\"padding: 3px 0px; text-align: center; vertical-align: middle;\"><img src=\"images/loading_blue.gif\"/> \&nbsp;Loading...</div>";
  var noReportsFoundHTML = "<div class=\"text-blue-01\" style=\"padding: 3px 0px; text-align: center; vertical-align: middle;\">No reports found. Please contact application administrator for adding reports.</div>";
  var reportURL = "reportsViewer.htm?startDate=&endDate=&reportOnly=true&page=home&reportID=";

  function initPage(){
    var reportPane1 = dijit.byId("reportPane1");
    var report1ID = dojo.cookie("reportPane1");
    if(!report1ID)
      report1ID = report1IDDef;
    var report1Title = dojo.cookie("reportPane1title");
    if(!report1Title)
      report1Title = report1TitleDef;
    updateReport("reportPane1", report1ID, report1Title);

    dojo.connect(reportPane1, "onLoad", null, function(){
      var reportPane2 = dijit.byId("reportPane2");
      var report2ID = dojo.cookie("reportPane2");
      if(!report2ID)
        report2ID = report2IDDef;
      var report2Title = dojo.cookie("reportPane2title");
      if(!report2Title)
        report2Title = report2TitleDef;
      updateReport("reportPane2", report2ID, report2Title);
    });
  }

  function updateReport(p_reportPaneName, p_reportID, p_reportTitle){
    var reportPane = dojo.byId(p_reportPaneName);
    var l_reportTitle = p_reportTitle;
    reportPane.innerHTML = loadingMessageHtml;

    if(p_reportID > 0) {
      reportPane = dijit.byId(p_reportPaneName);
      reportPane.setHref(reportURL+p_reportID);
    } else {
      reportsNotFound();
    }

    var reportTitle = dojo.byId(p_reportPaneName+"title");
    reportTitle.innerHTML = l_reportTitle;
  }

  function reportsNotFound(){
    var reportPane = dojo.byId("reportPane1");
    var reportTitle = dojo.byId("reportPane1title");
    reportPane.innerHTML = noReportsFoundHTML;
    reportTitle.innerHTML = "Report Not Found";

    reportPane = dojo.byId("reportPane2");
    reportTitle = dojo.byId("reportPane2title");
    reportPane.innerHTML = noReportsFoundHTML;
    reportTitle.innerHTML = "Report Not Found";
  }

  function showReportChanger(reportPane) {
    reportPaneName = reportPane;
    dojo.style(dojo.byId('reportoverlaydiv'), "opacity", "0.4");
    dojo.style(dojo.byId('reportoverlaydiv'), "display", "block");
    dojo.style(dojo.byId('reportchanger'), "display", "block");
  }

  function hideReportChanger() {
    dojo.style(dojo.byId('reportoverlaydiv'), "display", "none");
    dojo.style(dojo.byId('reportchanger'), "display", "none");
  }

  function wipeOutReportChanger() {
    var reportID = reportForm.report.options[reportForm.report.selectedIndex].value;
    var reportTitle = reportsNameArray[reportID];
    dojo.cookie(reportPaneName, reportID, { expires: 365 });
    dojo.cookie(reportPaneName+"title", reportTitle, { expires: 365 });
    updateReport(reportPaneName,reportID, reportTitle);
    var fadeAnim = dojo.fadeOut({
      node: dojo.byId('reportoverlaydiv'),
      duration: 1000
    });
    dojo.connect(fadeAnim, "onEnd", null, function(evt){
      dojo.style(dojo.byId('reportoverlaydiv'), "display", "none");
    });
    fadeAnim.play();
    var wipeOutAnim = dojo.animateProperty({
      node: dojo.byId('reportchanger'),
      duration: 1000,    
      properties: {
        height: {
          end: 1 // 0 causes IE to display the whole panel
        }
      }
    });
    dojo.connect(wipeOutAnim, "beforeBegin", null, function(){
      dojo.style(dojo.byId('reportchanger'), "overflow", "hidden");
    });
    dojo.connect(wipeOutAnim, "onEnd", null, function(){
      dojo.style(dojo.byId('reportchanger'), "display", "none");
      dojo.style(dojo.byId('reportchanger'), "overflow", "");
      dojo.style(dojo.byId('reportchanger'), "height", "");
    });
    wipeOutAnim.play();
  }

  dojo.addOnLoad(initPage);
</script>
<style type="text/css">
        .target {border: 1px dotted gray; width: 300px; height: 300px;padding: 5px;}
        .source {border: 1px dotted skyblue;height: 200px; width: 300px;}
        .bluesquare {height:50px;width:100%;background-color:skyblue}
        .redsquare {height:50px;width:100%;background-color:red}
		.greensquare {height:50px;width:100%;background-color:green}
</style>


<script type="text/javascript" src="js/mootools.v1.11.js"></script>
<script type="text/javascript" src="js/Observer.js"></script>
<script type="text/javascript" src="js/Autocompleter.js"></script>
 <!-- <script type="text/javascript">

    window.addEvent('domready', function(){

      var searchInput = $('searchText');

      var tokens = [  ['Adam',''],  ['Albain',''],  ['Andrew',''],  ['Antonio',''], ['Bandra',''],  ['Breast And Bowel Surgery',''],  ['Breast Cancer',''], ['Brufsky',''], ['Budman',''],  ['Burstein',''],  ['Carlson',''], ['Citron',''],  ['Claudine',''],  ['Craig',''], ['Daniel',''],  ['Dennis',''],  ['Edith',''], ['Eric',''],  ['Gabriel',''], ['Gary',''],  ['George',''],  ['Gluck',''], ['Gradishar',''], ['Gralow',''],  ['Harold',''],  ['Hematology',''],  ['Hope',''],  ['Hortobagyi',''],  ['Hyman',''], ['Internal Medicine',''], ['Isaacs',''],  ['Julie',''], ['Kathy',''], ['Kurla',''], ['Larry',''], ['Lyman',''], ['Marc',''],  ['Mark',''],  ['Medical Oncology',''],  ['Medicine',''],  ['Miller',''],  ['Muss',''],  ['Nichols',''], ['Nina',''],  ['Norman ',''], ['Norton',''],  ['Oncology',''],  ['Pegram',''],  ['Perez',''], ['Ray',''], ['Robert',''],  ['Rugo',''],  ['Schwartz',''],  ['Seidman',''], ['Slamon',''],  ['Sledge',''],  ['Socinski ',''], ['Stefan',''],  ['Victor',''],  ['Vogel',''], ['William',''], ['Winer',''], ['Wolff',''], ['Wolmark',''], ['alert',''], ['best',''],  ['expert',''],  ['man','']]
      var completer1 = new Autocompleter.Local(searchInput, tokens, {
        'delay': 100,
        'filterTokens': function() {
          var regex = new RegExp('^' + this.queryValue.escapeRegExp(), 'i');
          return this.tokens.filter(function(token){
            return (regex.test(token[0]) || regex.test(token[1]));
          });
        },
        'injectChoice': function(choice) {
          var el = new Element('li')
            .setHTML(this.markQueryValue(choice[0]))
            .adopt(new Element('span', {'class': 'example-info'}).setHTML(this.markQueryValue(choice[1])));
          el.inputValue = choice[0];
          this.addChoiceEvents(el).injectInside(this.choices);
        }
      });

  });

  </script>-->
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
  <div class="overlaydiv" id="reportoverlaydiv">
    </div>
    <div class="columnchanger1" id="reportchanger" style="left: expression((document.body.clientWidth-352)/2 + 'px'); top: expression((document.body.clientHeight-128)/2 + 'px');">
    <div class="columnchangeheader">
    	<div class="changemessage"><b>Select Report</b>
    	</div>
        <div class="closebutton" onclick="javascript: hideReportChanger();">X
        </div>
    </div>
    <div class="columnchangecontent">
    	<div>&nbsp;
    	</div>
        <div class="text-blue-01">Please select the report that you want to show up:
        </div>
        <form name="reportForm">
        <table class="columnselection">
          <tr>
            <td>
              <select name="report" class="field-blue-01-220x20">
                <%
                  for(Iterator itr = dashlets.iterator(); itr.hasNext();){
                    Report report = (Report) itr.next();
                    String reportName = report.getName();
                    reportName = reportName.replaceAll("-Dashlet","");
                %>
                <option value="<%=report.getReportID()%>"><%=reportName%></option>
                <% } %>
              </select>
            </td>
            <td align="center"><input class="field-blue-05-70x20" type="button" name="update" value="Update" onclick="javascript:wipeOutReportChanger();"></td>
          </tr>
        </table>
        </form>
    </div>
  </div>
<form name="home" method="post" action="searchKol.htm?action=<%=ActionKeys.EXPERT_SEARCH%>"   onsubmit="javascript:openProgressBar()" >
<table  border=0 cellspacing=0 cellpadding=0 width=100%>
<tr>
<td width="100%" align="left" valign="top">

<div ><!-- dojoType="dojo.dnd.Source" jsId="c1"> for removing movable divs-->
 	<div  style="float:left;"  id="leftDiv"> <!-- class="dojoDndItem" dndType="left" -->  
    	<div id="expSearchDiv"  class="expertsearchdiv">
        	<div  class="leftsearchbgpic"><!-- style="cursor:move;" R.M.C -->
            	<div class="leftsearchtext">Name Search
            	</div>
          	</div>
          	<div class="firstname">
      			<div class="searchtextdiv">
        			<input type="text" border="#c3c3c3" name="searchText" id="searchText" value="<%= Constants.SEARCH_TEXT_MESSAGE %>" class="blueTextBox" onFocus="return hideDefault(this);" onBlur="return showDefault(this);"
        				   onkeypress="submitFormByEnterKey(checkInput)"/>
        	    	<br />
      			</div>
         		<!--input type="text" border="#c3c3c3" value="<Enter Keyword>" class="blueTextBox" name="searchText"  dojoType="ComboBox" value="this should never be seen - it is replaced!"
           		dataUrl="js/dojo/tests/widget/comboBoxData.js" style="width: 150px;" maxListLength="15"/-->
          	</div>
       		<div class="searchButton" align="left" >
           		<input type="button" name="Search1" value=""
				style="border:0;background : url(images/buttons/search_expert.gif);width:90px; height:22px;"
				onclick="javascript:checkInput();"
				/>
	  		</div>
       		  <%
                // Check if this is OQ-professional version then don't enable the Org Search
                boolean isProfVersion = false;
                String profVersionPropVal = (String) session.getAttribute("isProfVersion");
                if((profVersionPropVal != null) && ("true".equalsIgnoreCase(profVersionPropVal)))
                  isProfVersion = true;
          		%>
          
       		<div class="leftsearchbgpic">
           		<div class="leftsearchtext">Organization Search
           		</div>
       		</div>
       		<div class="firstname">
          		<input <%=((isSAXAJVUser || isProfVersion || isOTSUKAJVUser) ?"disabled":"")%> type="text" border="#c3c3c3" value="<Organization>" class="blueTextBox" name="organization"  onFocus="return hideDefault(this);" onBlur="return showDefault(this);"
          				onkeypress="submitFormByEnterKey(checkOrg)"/>
       		</div>
          	<div class="searchButton" align="left">
          		<input <%=( (isSAXAJVUser || isProfVersion || isOTSUKAJVUser) ?"disabled":"")%> type="button" name="Search2" value=""
      	    	style="border:0;background : url(images/buttons/<%=((isSAXAJVUser||isProfVersion||isOTSUKAJVUser)?"search_orgs_disabled.gif":"search_orgs.gif")%>);width:109px; height:24px;"  
            	onclick="javascript:checkOrg();"/>
          	</div>
      	</div>
      	<div class="paddingdiv" >
      	</div>
      	<div id="alertDiv" class="expertsearchdiv">
        	<div class="leftsearchbgpic">
     			<div class="leftsearchtext">Alerts <img src="images/alertspic.jpg"/>
     			</div>
       		</div>
          	<div class="alertSection">
   	 	  	<div class="alertTitleText">
            	<table>
                    <%
                     AlertQueue[] queue = (AlertQueue[])session.getAttribute(Constants.ALERT_QUEUE);
                     for( int i = 0; i < queue.length && i <3; i++ )
                     {
                        int j = queue.length-i-1;
                        String name = (queue[j].getAlert().getName() == null) ? "" : queue[j].getAlert().getName();
                        String message = (queue[j].getMessage() == null)? "" :queue[j].getMessage();
                    %>
                    <tr>
                        <td class=text-blue-01 align="left"><b><%=name %> : </b><%=message %></td>
                    </tr>
                    <%}%>
               </table>
      		   <div class="clear">
      		   </div>
          	</div>
            <div class="seeallalert">
           		<a class="text-blue-link" href="#" onClick="javascript:window.open('all_alerts.jsp','alerts','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');"><b>See all Alerts</b></a>
            </div>
      	</div>
   </div><!-- leftDiv ends here -->  
</div> 
    
     <!-- div id="topWidgetPane" style="width: 100%"-->
    <div id="centreDiv" style="float:left;" > <!-- class="dojoDndItem" dndType="center" (removing movable divs) -->
	    <div id="centreDiv" style="padding: 0px 5px 0px 5px;  float: left; width: expression((document.body.clientWidth-312-230-30) + 'px') ;">
	       <div  class="myexpertlist"><!-- style="cursor:move;" for removing draggin (move) cursor --> 
	        <table width="100%">
        		<tr style="color:#4C7398">
        			<td width="50%" align="left">
                        <%
                          if(isProfVersion) {
                        %>
                          <div class="myexperttext">All <%=DBUtil.getInstance().doctor%> List</div>
                        <%
                          } else {
                        %>
                          <div class="myexperttext">My List</div>
                        <%
                          }
                        %>    
	        		</td>
	        	</tr>
	        </table>
	       </div> 		
		   <iframe src='expertlist.htm?message=+<%=request.getParameter("message") == null? "" : request.getParameter("message")%>' name="rightPane" height="600px" width="100%"  frameborder="0" scrolling="no" style="background-color:#fcfcf8;"></iframe>
	    </div>
<!-- 	</div> -->
	<div id="rightDiv" style="float:left;" > <!-- class="dojoDndItem" dndType="left" for R.M.D(removing movable div) -->   
	    <div style="padding: 0px 5px 0px 5px; float: left; width: 312px;">
	        <div id="report1" style="padding: 3px 3px 3px 3px; border: 1px solid #E2EAEF; background: #F8FAFB;">
	           <div style="padding: 5px 5px 5px 5px; background-color: #E2EAEF; text-align: left; width: 300px;">
	              <table width="100%" style="vertical-align: middle;">
                	<tr>
	                  <td style="font: 12px Verdana; font-weight: bold; ">
	                  <div  id="reportPane1title">...</div> <!-- style="cursor:move;" R.M.C (removing move cursor)-->
	                  </td>
	                  <td style="width: 18px"><img src="images/configure.gif" onclick="javascript:showReportChanger('reportPane1')" style="cursor: pointer;"></td>
	                </tr>
	              </table>
               </div>
	           <div id="reportPane1" dojoType="dijit.layout.ContentPane" cacheContent="false" style="padding: 2px 0px;" onDownloadStart="getLoadingMsg">
	              <div class="text-blue-01" style="padding: 3px 0px; text-align: center; vertical-align: middle;"><img src="images/loading_blue.gif"/> &nbsp;Loading...</div>
       		 	  </div>
	           </div>
	           <div id="report2" style="padding: 3px 3px 3px 3px; border: 1px solid #E2EAEF; background: #F8FAFB;">
	            <div style="padding: 5px 5px 5px 5px; background-color: #E2EAEF; text-align: left; width: 300px;">
	              <table width="100%" style="vertical-align: middle;">
	                <tr>
	                  <td style="font: 12px Verdana; font-weight: bold; "><div id="reportPane2title">...</div></td>
	                  <td style="width: 18px"><img src="images/configure.gif" onclick="javascript:showReportChanger('reportPane2')" style="cursor: pointer;"></td>
	                </tr>
	              </table>
             	</div>
	            <div id="reportPane2" dojoType="dijit.layout.ContentPane" cacheContent="false" style="padding: 2px 0px;" onDownloadStart="getLoadingMsg">
            	    <div class="text-blue-01" style="padding: 3px 0px; text-align: center; vertical-align: middle;"><img src="images/loading_blue.gif"/> &nbsp;Loading...
	                </div>
           	  	</div>
            </div>
        </div>
  	</div> <!-- right div ends here -->
			<!-- /div-->
 <!-- </div> dojo type dnd div ends here-->
 
      </td>
          </tr>
          
        
  </table>
</form>
  <%@ include file="footer.jsp" %>
</body>