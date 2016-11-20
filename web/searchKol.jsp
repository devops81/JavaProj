
<jsp:directive.page import="com.openq.eav.org.Organization"/><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.expert.MyExpertList" %>
<%@ page import="com.amgen.orx.types.EoList"%>
<%@ page import="com.amgen.orx.types.EoList"%>
<%@ page import="org.apache.axis.types.Token"%>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.orx.BestORXRecord"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.alerts.data.AlertQueue"%>
<%@ page import="com.openq.kol.DBUtil"%>

<%
  java.util.Properties featuresPubInSearchKol = DBUtil.getInstance().featuresProp;
  BestORXRecord [] orxResult = (BestORXRecord[])request.getSession().getAttribute("orxResult");
  OptionLookup [] stateAbbriviation = (OptionLookup [])request.getSession().getAttribute("stateAbbriviation");
  String orgResult = (String) request.getSession().getAttribute("orgResult");
  String OLResult = (String) request.getSession().getAttribute("OLResult");
    String userType = null;
    if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
        userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getOptValue();

    }
    Organization [] orgs = null;
    if(request.getSession().getAttribute("orgsattr")!=null){
      orgs = (Organization [])request.getSession().getAttribute("orgsattr");
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
<style>
tr {}
.coloronmouseover
{
BACKGROUND-COLOR: #E2EAEF
}

.colorMouse
{
background-color: #DAD29C
}
.coloronmouseout
{
BACKGROUND-COLOR: #ffffff
}</style>


<script type="text/javascript">

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

function addExpertToKOLSegment(){
 var thisform = document.searchKOL;
      var flag = false ;
      if (null != thisform.checkIds && thisform.checkIds.length != undefined){



      for (var i = 0;  null != thisform.checkIds && i < thisform.checkIds.length; i++) {


            if (thisform.checkIds[i].checked) {
                    flag = true;
                    break;
                }
           }
          }
          else{
             if (thisform.checkIds.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select at least one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

        document.searchKOL.action = "<%=CONTEXTPATH%>/kol_setsegment.htm?action=<%=ActionKeys.KOL_ADD_EXPERTS%>&fromKOLStrategy=true";
    document.searchKOL.submit();

    }

 function addOLs()
 {

  var button1 =document.getElementById('addExpert');
  button1.disabled = true;
  var thisform = document.searchKOL;
  var flag = false ;
  if (null != thisform.checkIds && thisform.checkIds.length != undefined) {
    // array of check boxes
    for (var i = 0;  i < thisform.checkIds.length; i++) {
      if (thisform.checkIds[i].checked) {
        flag = true;
        break;
      }


        }
    } else {
    // single check box
    if (null != thisform.checkIds && thisform.checkIds.checked) {
      flag = true;
    }
  }

    if (!flag) {
    //alert("Please select at least one <%=DBUtil.getInstance().doctor%>");
        document.searchKOL.action = "<%=CONTEXTPATH%>/home.htm";

    }
    else
    {
       if(window.confirm("Are you sure you want to add this <%=DBUtil.getInstance().doctor%> to your List ?"))
        {

        }else{
          document.searchKOL.action = "<%=CONTEXTPATH%>/home.htm";
        }
            document.searchKOL.submit();
    }


 }
function checkInput() {

    if (document.searchKOL.searchText.value == null || document.searchKOL.searchText.value == "" || document.searchKOL.searchText.value == '<%= Constants.SEARCH_TEXT_MESSAGE %>')
  {
    alert('Please enter keyword');
    return;
  }
  else if(document.searchKOL.searchText.value.length <2)
  {
    alert('Minimum number of characters required is 2');
  }
  else
  {
  openProgressBar();
  document.searchKOL.searchText.value = checkAndReplaceApostrophe(document.searchKOL.searchText.value);
    document.searchKOL.submit();
  }
}



function checkOrg(){
  if(document.searchKOL.organization.value != '' && document.searchKOL.organization.value!='<Organization>'){
    document.searchKOL.organization.value = checkAndReplaceApostrophe(document.searchKOL.organization.value);
    document.searchKOL.submit();
  }else{
    alert("Please enter Orginzation name ");
  }
}
</script>
<script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js"></script>
<script type="text/javascript">
  dojo.require("dojo.parser");
  dojo.require("dojo.cookie");
  dojo.require("dijit.layout.ContentPane");
  dojo.require("dojo.fx");
  dojo.require("dojox.fx.easing");


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

function showGoDiv(secId){
document.getElementById("expertListRow"+secId).className='coloronmouseover';
//document.getElementById("quickContactDiv"+secId).style.display="block";

}

function hideGoDiv(secId){
if(secId%2==0){
    document.getElementById("expertListRow"+secId).className="white";
 }else{
    document.getElementById("expertListRow"+secId).className="#faf9f2";
 }
 //document.getElementById("quickContactDiv"+secId).style.display="none";
}
function showContentDiv(secId,fromContentDiv){
 var i=0;
 while(document.getElementById("quickContactDiv"+i)!=null){
  document.getElementById(i+"Content").style.display="none";
  i++;
 }

  var divId=dojo.byId("quickContactDiv"+secId);
  var offsetY=40;
  var menuX=findPosX(divId);
  var menuY=findPosY(divId);

  if(fromContentDiv=="true"){
   document.getElementById(secId+"Content").style.left=menuX-2;
   document.getElementById(secId+"Content").style.top=menuY+12;
  }else{
   document.getElementById(secId+"Content").style.left=menuX;
   document.getElementById(secId+"Content").style.top=menuY+6;
  }
  document.getElementById(secId+"Content").style.display="block";

}

function hideContentDiv(secId){
  document.getElementById(secId+"Content").style.display="none";
}




function showQuickContactDiv(secId){
  showGoDiv(secId);
  showContentDiv(secId,"true");
}
function hideQuickContactDiv(secId){
  hideGoDiv(secId);
  hideContentDiv(secId);
}

function enableAddOLButton()
{
var button1 =document.getElementById('addExpert');
  button1.disabled = false;
}
</script>
<script type="text/javascript" src="js/subsection.js">
</script>
<script type="text/javascript" src="js/mootools.v1.11.js"></script>
<script type="text/javascript" src="js/Observer.js"></script>
<script type="text/javascript" src="js/Autocompleter.js"></script>
  <script type="text/javascript"><%--

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

  --%></script>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" onload="javascript:closeAllSections('colContent')">
<form name="searchKOL" method="post" action="searchKol.htm?action=<%=ActionKeys.EXPERT_SEARCH%>" onload ="javascript:enableAddOLButton()" onSubmit="javascript:openProgressBar()" >
  <table  border=0 cellspacing=0 cellpadding=0 width=100%>
   <tr>
    <td width="22%" align="left" valign="top">
        <div class="expertsearchdiv">
          <div class="leftsearchbgpic">
            <div class="leftsearchtext">Name Search</div>
      </div>

           <div class="firstname">
            <div class="searchtextdiv">
        <input type="text" border="#c3c3c3" name="searchText" id="searchText" value="<%= Constants.SEARCH_TEXT_MESSAGE %>" class="blueTextBox" onFocus="return hideDefault(this);" onBlur="return showDefault(this);"
            onkeypress="submitFormByEnterKey(checkInput)"/>
        <br />
      </div>
          </div>
          <div class="searchButton" align="left">
            <input type="button" name="Search1" value=""
              style="border:0;background : url(images/buttons/search_expert.gif);width:90px; height:22px;"  onclick="javascript:checkInput();"/>
          </div>

          <%
                // Check if this is OQ-professional version then don't enable the Org Search
                boolean isProfVersion = false;
                String profVersionPropVal = (String) session.getAttribute("isProfVersion");
                if((profVersionPropVal != null) && ("true".equalsIgnoreCase(profVersionPropVal)))
                  isProfVersion = true;
          %>

          <div class="leftsearchbgpic">
            <div class="leftsearchtext">Organization Search</div>
          </div>
          <div class="firstname">
            <input <%=((isSAXAJVUser || isProfVersion || isOTSUKAJVUser) ?"disabled":"")%> type="text" border="#c3c3c3" value="<Organization>" class="blueTextBox" name="organization"  onFocus="return hideDefault(this);" onBlur="return showDefault(this);"
                onkeypress="submitFormByEnterKey(checkOrg)"/>
          </div>
          <div class="searchButton" align="left">
            <input <%=( (isSAXAJVUser || isProfVersion || isOTSUKAJVUser) ?"disabled":"" )%> type="button" name="Search2" value=""
              style="border:0;background : url(images/buttons/<%=((isSAXAJVUser || isProfVersion ||isOTSUKAJVUser) ?"search_orgs_disabled.gif":"search_orgs.gif")%>);width:108px; height:22px;"  onclick="javascript:checkOrg();"/></div>
          </div>
        </div>
        <div class="paddingdiv"></div>
        <div class="expertsearchdiv">
          <div class="leftsearchbgpic">
            <div class="leftsearchtext">Alerts <img src="images/alertspic.jpg"/></div>
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
            <div class="clear"></div>
          </div>
          <div class="seeallalert">
            <a class="text-blue-link" href="#" onClick="javascript:window.open('all_alerts.jsp','alerts','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');"><b>See all Alerts</b></a>
          </div>
        </div>
       </div>
      </td>
      <td valign="top" align="center" >

          <% if(OLResult != null){ %>
            <div class="producttext" height=200 overflow="auto">
                <div class="myexpertlist">
                  <table width="100%">
                  <tr style="color:#4C7398">
                    <td width="50%" align="left">
                      <div class="myexperttext">Search Results</div>
                    </td><%--
                      <td width="50%" align="right" class="atext" >
                         <div style="float:right"><a href="expert_map.htm?expertsToDisplay=OLSearchResults">
                            <img src="<%=COMMONIMAGES%>/world.gif" title="Geo mapping"
                                                                    height="28" border="0"/></a>
                          </div>
                     </td>
                   --%></tr>
                   </table>
                   </div>

                   <table width="100%" cellspacing="0">
                  <tr bgcolor="#faf9f2">
                    <td width="5%">&nbsp;</td>
                    <td width="15%" class="expertListHeader">Name</td>
                    <td width="20%" class="expertListHeader">Specialty</td>
                    <td width="20%" class="expertListHeader"><%if(featuresPubInSearchKol!=null && featuresPubInSearchKol.getProperty("DISPLAY_TIER")!=null){%>

      <%=featuresPubInSearchKol.getProperty("DISPLAY_TIER")%><%}else {%>Tier<%}%>
      </td>
                    <td width="15%" class="expertListHeader">Location</td>
                    <td width="25%"></td>
                  </tr>
                  <%
                boolean flag = false;
                int j=0;
              %>
              <c:forEach varStatus="status" items="${homeSearchResults}" var="myexpert">
              <% flag = true; %>


                 <TR vAlign="center"  bgcolor='<%=(j%2==0?"white":"#faf9f2")%>' align=left id="expertListRow<%=j %>" onMouseOver="javascript:showGoDiv('<%=j %>')" onMouseOut="javascript:hideGoDiv('<%=j %>')" style="border-bottom=1px"

                  <c:choose>
                      <c:when test='${(status.index)%2 eq 1}'>
                            bgcolor="#fcfcf8""
                      </c:when>
                    <c:otherwise>bgcolor="#faf9f2"</c:otherwise>
                </c:choose> >
              <TD align=middle width="5%" height=20>
                <INPUT type=checkbox value='<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>' name="checkIds"> </TD>


              <TD class=text-blue-01-link width="15%"><A class=text-blue-01-link href='expertfullprofile.htm?kolid=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>&entityId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&expertId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&currentKOLName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}" />'>
                          <c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}"/></A>
                        </TD>

              <TD class=text-blue-01 width="20%">
                 <c:out escapeXml="false" value="${homeSearchResults[status.index].primarySpeciality}"/><c:if test="${not empty homeSearchResults[status.index].secondarySpeciality}"><c:out escapeXml="false" value=", ${homeSearchResults[status.index].secondarySpeciality}"/></c:if><c:if test="${not empty homeSearchResults[status.index].tertiarySpeciality}"><c:out escapeXml="false" value=", ${homeSearchResults[status.index].tertiarySpeciality}"/></c:if>
              </TD>

              <TD class=text-blue-01 width="20%">
                          <c:out escapeXml="false" value="${homeSearchResults[status.index].mslOlType}"/>
                        </TD>

              <TD class=text-blue-01 width="15%">

              <c:choose>
              <c:when test="${homeSearchResults[status.index].addressCity !=null}">
                  <c:out escapeXml="false" value="${homeSearchResults[status.index].addressCity}"/>
                        <c:choose>
                            <c:when test ="${homeSearchResults[status.index].addressCountry !='United States' &&
                            homeSearchResults[status.index].addressCountry !='USA' &&
                            homeSearchResults[status.index].addressCountry !='United States of America' &&
                            homeSearchResults[status.index].addressCountry !=null &&
                            homeSearchResults[status.index].addressCountry !=' '}">
                                 ,<c:out escapeXml="false" value="${homeSearchResults[status.index].addressCountry}"/>
                            </c:when>
                            <c:otherwise>
                                ,&nbsp; <c:out escapeXml="false" value="${homeSearchResults[status.index].addressState}"/>
                            </c:otherwise>
                        </c:choose>
             </c:when>
                  <c:otherwise>
                    <c:out escapeXml="false" value="${homeSearchResults[status.index].addressCountry}"/>
                  </c:otherwise>
              </c:choose>

                        </TD>

              <TD width="25%" class=text-blue-01>

                                       <div >
                                            <div id="quickContactDiv<%=j %>" style="display:none"  onMouseOver="javascript:showContentDiv('<%=j%>','false')" onMouseOut="javascript:hideContentDiv('<%=j%>')">
                                                <a href='#' class="text-blue-01-link">Go</a>
                                            </div>
                                            <div id="<%=j%>Content" onMouseOver="javascript:showQuickContactDiv('<%=j%>')"  onMouseOut="javascript:hideQuickContactDiv('<%=j%>')" style="position:absolute;  display:none; width:135px; height:80px; top=47px; left=520px; padding-bottom:2px;  ">
                                              <table width=100% bgColor="#E2EAEF" cellpadding="0" cellspacing="0"  style="padding-bottom:5px;opacity:0.2" >

                                              <tr><td>&nbsp;
                                                <a target=_top href="event_add.htm?kolName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}"/>&kolId=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>" class="text-blue-01-link">Schedule Medical Meeting</a>
                                              </td></tr>

                                              <tr><td height="24">&nbsp;
                                                <a href='event_search.htm?&go=true&kolId=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>"&kolName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}"/>',target="_top" class="text-blue-01-link">
                                                Past Medical Meetings</a>
                                              </td></tr>
                                              <tr><td>&nbsp;
                                                <a href='searchInteraction.htm?action=<%=ActionKeys.SEARCH_INTERACTION%>&kol_name=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}"/>'&go=true&kolId=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>', target="_top" class="text-blue-01-link">Past Interactions</a>
                                              </td></tr>
                                              <tr><td>&nbsp;
                                                 <a href='expertfullprofile.htm?fromInteraction=yes&kolid=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>&entityId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&expertId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&currentKOLName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}"/>' class="text-blue-01-link">New Interaction</a>
                                              </td></tr>
                                                <%if(!(featuresPubInSearchKol!=null && featuresPubInSearchKol.getProperty("EAV_PUBLICATIONS")!=null && featuresPubInSearchKol.getProperty("EAV_PUBLICATIONS").equalsIgnoreCase("false"))){
                                                    %>
                                                <tr><td>&nbsp;
                                                <A class=text-blue-01-link href='expertfullprofile.htm?kolid=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>&entityId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&expertId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&go=true&currentKOLName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}" />'>Publications</a>
                                              </td></tr>
                                              <%} %>
                                                <tr><td>&nbsp;
                                                <A class=text-blue-01-link href='expertfullprofile.htm?kolid=<c:out escapeXml="false" value="${homeSearchResults[status.index].id}"/>&entityId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&expertId=<c:out escapeXml="false" value="${homeSearchResults[status.index].kolid}"/>&currentKOLName=<c:out escapeXml="false" value="${homeSearchResults[status.index].lastName}, ${homeSearchResults[status.index].firstName}" />'>Profile</a>
                                              </td></tr>
                                               <%j++; %>
                                              </table>
                                            <div>
                                          </div>
                                          </TD>



            </TR>
              </c:forEach>


           <TABLE cellSpacing=0 cellPadding=0 width="90%" border=0 height="" bgcolor="#fcfcf8">
        <tr >
          <td colspan="2" height="1" align="left" valign="top" class=""><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
                <% if (session.getAttribute("fromKOLStrategy") != null  )  { %>
                 <tr >
                     <td height="30" align="left" valign="center">&nbsp;<input name="add Expert" type="button" style="border:0 none;background : url('images/buttons/add_expert.gif');width:80px; height:22px" class="button-01" value="" <% if (!flag) {%> disabled <%}%> onClick="javascript:addExpertToKOLSegment()"> </td>
                     <td width="25">&nbsp;</td>
                  </tr>
        <% } else { %>
                     <tr>
                     <td width=20>&nbsp;</td>
                     </tr>
                <TR >

          <TD height="30">&nbsp;
          <%if (flag) {%><INPUT type="button" onClick="addOLs();" class="button-01"  id="addExpert" value="" style="border:0;background : url(images/buttons/add_expert.gif);width:80px; height:23px;><%} else {%>
            <span class="text-blue-01-red">No <%=DBUtil.getInstance().doctor%>(s) found.</span>
          <%}%>
          </TD>
        </TR>
                <%
                    }
                %>
                <!--tr class="back-white">
          <td colspan="2" height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr-->
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      </div>
      <br>
      <br>

       <% if (session.getAttribute("fromKOLStrategy") == null  )  { %>


        <div class="producttext" height=200 overflow="auto">
            <div class="myexpertplan">
              <table width="100%">
                <tr style="color:#4C7398">
                <td align="left">
                  <div class="myexperttext">Search Results from Other <%=DBUtil.getInstance().customer%> Systems</div>
                </td>
                </tr>
              </table>
            </div>
                   <table width="100%" cellspacing="0">
              <tr bgcolor="#f5f8f4">
                <td width="5%" align="right">&nbsp;</td>
                <td width="15%" class="expertPlanHeader">Name</td>
                <td width="25%" class="expertPlanHeader">Speciality</td>
                <td width="15%" class="expertPlanHeader">Phone</td>
                <td width="25%" class="expertPlanHeader">Location</td>
                <td width=15%>&nbsp;</td>
              </tr>


<% if(orxResult != null && orxResult.length > 0){ for(int i=0;i<orxResult.length && i <50;i++){ %>

        <tr bgcolor='<%=(i%2==0?"#fafbf9":"#f5f8f4")%>'>
          <TD align=middle width="5%" height=25>&nbsp;</TD>
          <TD class="expertListRow" width="15%"><%=((orxResult[i].getLastName()!= null) ?
                                         orxResult[i].getLastName(): "")%>, <%=((orxResult[i].getFirstName()!= null)
                                         ?
                                         orxResult[i].getFirstName(): "")%></TD>
          <TD class=expertListRow width="25%"><%=((orxResult[i].getSpecialty()!=null)
                                        ?
                                        orxResult[i].getSpecialty():"N.A")%>
                                        </TD>
          <TD class=expertListRow width="15%"><%=((orxResult[i].getPhone()!=null)
                                        ?
                                        orxResult[i].getPhone():"N.A")%>
                                    </TD>

          <TD class=expertListRow width="25%"><%=((orxResult[i].getLocality()!= null)
                                      ?
                                      orxResult[i].getLocality():"N.A") + "," +
                                      ((orxResult[i].getProvince()!= null)
                                      ?
                                      orxResult[i].getProvince():"")%></TD>
            <td><a href="add_guest_hcp.htm?ssname=<%=orxResult[i].getSsname()%>&ssoid=<%=orxResult[i].getSsoid()%>&hcpfirstname=<%=((orxResult[i].getFirstName()!= null)?orxResult[i].getFirstName():"")%>&hcplastname=<%=((orxResult[i].getLastName()!= null)?orxResult[i].getLastName():"")%>&speciality=<%=((orxResult[i].getSpecialty()!= null)?orxResult[i].getSpecialty():"")%>&address1=<%=((orxResult[i].getStreetAddress()!= null)?orxResult[i].getStreetAddress():"")%>&address2=<%=((orxResult[i].getLocation()!= null)?orxResult[i].getLocation():"")%>&country=<%=((orxResult[i].getCountry()!= null)?orxResult[i].getCountry():"")%>&state=<%=((orxResult[i].getProvince()!= null)?orxResult[i].getProvince():"")%>&zip=<%=((orxResult[i].getPostalCode()!= null)?orxResult[i].getPostalCode():"")%>&city=<%=((orxResult[i].getLocality()!= null)?orxResult[i].getLocality():"")%>" class="text-blue-01-link">Add Guest <%=DBUtil.getInstance().hcp%></a></td>


        </TR>


<% }} else { %>

        <tr class="back-white">
          <td colspan=6 height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
        <tr  height=30 valign=middle>
            <TD align=middle width="5%" height=25>&nbsp;</TD>
            <td width="15%" colspan=3 align="left"><span class="text-blue-01-red">No result found.</span></td>
            <td width="25%">&nbsp;</td>
            <td width=15%>&nbsp;</td>

        </tr>
<% } %>
        <tr class="back-white">
          <td colspan=6 height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
        <tr bgcolor="#f5f8f4" height=30 valign=middle>
            <TD align=middle width="5%" height=25>&nbsp;</TD>
            <td width="15%" ><a href="add_guest_hcp.htm" class="text-blue-01-link">Add Guest <%=DBUtil.getInstance().hcp%></a></td>
              <td width="25%" >&nbsp;</td>
            <td width="15%" >&nbsp;</td>
            <td width="25%">&nbsp;</td>
            <td width=15%>&nbsp;</td>

        </tr>
</table>
<% }} %>

  </div>
<%if(orgResult != null){ %>

      <div class="producttext">
          <div class="myexpertlist">
            <table width="100%">
              <tr style="color:#4C7398">
                <td width="50%" align="left">
                  <div class="myexperttext">Organization Search Result</div>
                </td>
              </tr>
            </table>
          </div>
          <table width="100%" cellspacing="0">
            <tr bgcolor="#faf9f2">
              <td width="5%">&nbsp;</td>
              <td width="20%" class="expertListHeader">Name</td>
              <td width="20%" class="expertListHeader">Acronym</td>
              <td width="20%" class="expertListHeader">Type</td>
              <td width="20%" class="expertListHeader">Location</td>
              <td width="15%"></td>
            </tr>

            <c:forEach varStatus="status" items="${orgs}" var="orgs">

          <TR vAlign=center align=left style="border-bottom=1px"
            <c:choose>
                      <c:when test='${(status.index)%2 eq 1}'>
                            bgcolor="#fcfcf8""
                      </c:when>
                    <c:otherwise>bgcolor="#faf9f2"</c:otherwise>
                </c:choose> >

                <TD width="5%">&nbsp;</TD>
                <TD class=text-blue-01 width=20%><A class=text-blue-01-link href='institutions.htm?entityId=<c:out escapeXml="false" value="${orgs.entityId}"/>'><c:out escapeXml="false" value="${orgs.name}"/></a> </TD>

                <TD class=text-blue-01 width=20%><c:out escapeXml="false" value="${orgs.acronym}"/></TD>

                <TD class=text-blue-01 width=20%><c:out escapeXml="false" value="${orgs.type}"/></TD>

                <TD class=text-blue-01 width=20%>

               <c:if test='${not empty orgs.city && not empty orgs.state}'>
                  <c:out escapeXml="false" value="${orgs.city} , ${orgs.state} "/>
                </c:if>
               <c:if test='${empty orgs.city}'>
                  <c:out escapeXml="false" value="${orgs.state} "/>
                </c:if>

                <c:if test='${empty orgs.state}'>
                  <c:out escapeXml="false" value="${orgs.city}"/>
                </c:if>

                </TD>

                <TD width=15%>&nbsp;</TD>
              </tr>
              </c:forEach>

		<tr class="back-white">
          <td colspan=6 height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
        <tr bgcolor="#f5f8f4" height=30 valign=middle>
            <TD align=middle width="5%" height=25>&nbsp;</TD>
            <td width="15%" ><a href="add_org.jsp" class="text-blue-01-link">Add Org</a></td>
              <td width="25%" >&nbsp;</td>
            <td width="15%" >&nbsp;</td>
            <td width="25%">&nbsp;</td>
            <td width=15%>&nbsp;</td>

        </tr>


<% } %>
  <%if(orgs !=null && orgs.length < 1){ %>
            <tr class="back-white">
          <td colspan=6 height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
        <tr  height=30 valign=middle>
            <TD align=middle width="5%" height=25>&nbsp;</TD>
            <td width="15%" colspan=3 align="left"><span class="text-blue-01-red">No Organization(s) found.</span></td>
            <td width="25%">&nbsp;</td>
            <td width=15%>&nbsp;</td>

        </tr>

		 <tr class="back-white">
          <td colspan=6 height="1" align="left" valign="top" ><img src="/images/transparent.gif" width="1" height="1"></td>
        </tr>
        <tr bgcolor="#f5f8f4" height=30 valign=middle>
            <TD align=middle width="5%" height=25>&nbsp;</TD>
            <td width="15%" ><a href="add_org.jsp" class="text-blue-01-link">Add Org</a></td>
              <td width="25%" >&nbsp;</td>
            <td width="15%" >&nbsp;</td>
            <td width="25%">&nbsp;</td>
            <td width=15%>&nbsp;</td>

        </tr>

<% } %>




</table>


  <%@ include file="footer.jsp" %>
</form>
</body>
</html>