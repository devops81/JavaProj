<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.expert.MyExpertList" %>
<%@ page import="com.openq.kol.InteractionsDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.user.HomeUserView"%>
<%@ page import="com.openq.eav.expert.ExpertDetails"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="com.openq.web.ActionKeys" %>
<%
  java.util.Properties featuresExpertList = DBUtil.getInstance().featuresProp;
  ArrayList myTacticList = null;
  if (null != (session.getAttribute("MY_TACTIC_LIST"))){
      myTacticList = (ArrayList)session.getAttribute("MY_TACTIC_LIST");
  }

  //HomeUserView [] myOL = (HomeUserView[]) request.getSession().getAttribute("myOL");
  ExpertDetails [] myOL = (ExpertDetails[]) request.getSession().getAttribute("myOL");
  String msg = request.getParameter("message");
  msg = msg == null ? "" : msg;
%>


<HTML>
<HEAD>
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
    <script  src="js/validation.js" language="JavaScript"></script>

  <TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
  <LINK href="css/openq.css" type=text/css rel=stylesheet>
  <script language="javascript" src="js/dojo-release-0.9.0/dojo/dojo.js"></script>
  <script type="text/javascript">
  dojo.require("dojo.parser");
  dojo.require("dojo.cookie");
  dojo.require("dijit.layout.ContentPane");
  dojo.require("dojo.fx");
  dojo.require("dojox.fx.easing");
  dojo.require("dijit.form.CheckBox");


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
}

function hideGoDiv(secId){
if(secId%2==0){
 	document.getElementById("expertListRow"+secId).className="white";
 }else{
 	document.getElementById("expertListRow"+secId).className="#faf9f2";
 }
}
function showContentDiv(secId,fromContentDiv){
 var i=0;
 while(document.getElementById("quickContactDiv"+i)!=null){
  document.getElementById(i+"Content").style.display="none";
  i++;
 }
  var lastIndex=i-1;
  var divId=dojo.byId("quickContactDiv"+secId);
  var divIdofLastGo=dojo.byId("quickContactDiv"+lastIndex);
  var offsetY=40;
  var menuX=findPosX(divId);
  var menuY=findPosY(divId);
  var menuYOfLastGo=findPosY(divIdofLastGo);
  var scrollTop=document.getElementById("myexpertlist").scrollTop;
  var hightOfContentDiv=80
  var offsetOnContentDiv=50;
  if(fromContentDiv=="true"){
	       document.getElementById(secId+"Content").style.left=menuX-37;
		   if(menuY-scrollTop+hightOfContentDiv+offsetOnContentDiv>350){
		     document.getElementById(secId+"Content").style.top=menuY-5-147
		   }else{
		     document.getElementById(secId+"Content").style.top=menuY-5;
		    }
	  }else{
		   document.getElementById(secId+"Content").style.left=menuX-35;
		   if(menuY-scrollTop+hightOfContentDiv+offsetOnContentDiv>350){
		     document.getElementById(secId+"Content").style.top=menuY-13-147
		   }else{
		     document.getElementById(secId+"Content").style.top=menuY-13;
		    }

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

function deleteOls()
{
var thisform = document.myExpertListForm;
	  var flag = false ;
	 if (null != thisform.expertCheckBox && thisform.expertCheckBox.length != undefined){


             for (var i = 0;  null != thisform.expertCheckBox && i < thisform.expertCheckBox.length; i++) {
			if (thisform.expertCheckBox[i].checked) {
				flag = true;
				break;
			}
		  }
	  }
     else if(thisform.expertCheckBox!=null)//If there is only one checkbox element.
	  {
	    if(thisform.expertCheckBox.checked)
			flag=true;
	  }

   	  if (!flag) {
    		alert("Please select at least one <%=DBUtil.getInstance().doctor%>.");
			return;
                  }
         else
         {
           if(window.confirm("Are you sure you want to delete these <%=DBUtil.getInstance().doctor%>s ?"))
            {
               document.myExpertListForm.action="expertlist.htm?action=delete";
            }
         }
      document.myExpertListForm.submit();

}
</script>
<script type="text/javascript" src="./js/sorttable.js"></script>
</HEAD>
<script type="text/javascript" src="./js/scriptaculous/lib/prototype.js"></script>
<script type="text/javascript" src="./js/fastinit.js"></script>
<script type="text/javascript" src="./js/tablesort.js"></script>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" >

<form name="myExpertListForm" method="POST">
<tr align=center>

			<td>
				<span class="text-blue-01-red"><%=msg%></span>
			</td>
		</tr>


      <!-- div class="myexpertlist">

      <table width="100%">
        <tr style="color:#4C7398">
        <td width="50%" align="left">
          <div class="myexperttext">My <%=DBUtil.getInstance().doctor%> List</div>

		  <div class="columnchanger" id="columnchanger">
			<div class="columnchangeheader">
				<div class="changemessage"><b>Select column headers</b></div>
				<div class="closebutton" onclick="javascript: hideColumnChanger();">
					X</div>
			</div>
			<div class="columnchangecontent">
				<div class="message">Please check the column headers that you
					want to show up:</div>
				<table class="columnselection">
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Name</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Speciality</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Phone</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1" checked></td>
						<td>Location</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Address</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Availability</td>
					</tr>
					<tr>
						<td><input name="columns" type="checkbox" value="c1"></td>
						<td>Latest Publication</td>
					</tr>
					<tr>
						<td></td>
						<td><input class="updatebutton" type="button" name="update" value="Update Selection" onclick="javascript: wipeOutColumnChanger();"></td>
					</tr>
				</table>
			</div>
		  </div>
        </td>
        </tr>
      </table>
    </div-->
    <div id="myexpertlist" class="producttext" style=width:100%;height=300;overflow:auto>
    <table width="100%" cellspacing="0" scrolling ="yes" class="sortable">
      <tr bgcolor="#faf9f2">
      <td width="5%">&nbsp;</td>
      <td width="20%" class="expertListHeader">Name</td>
      <td width="20%" class="expertListHeader">Specialty</td>
      <td width="30%" class="expertListHeader"><%=DBUtil.getInstance().doctor%> Type</td>
      <td width="20%" class="expertListHeader">Location</td>
      <td width="5%"></td>
      </tr>
      <%if(myOL != null && myOL.length != 0){
      for(int i=0;i<myOL.length;i++){ %>
        <tr bgcolor='<%=(i%2==0?"white":"#faf9f2")%>' id="expertListRow<%=i %>" onMouseOver="javascript:showGoDiv('<%=i %>')" onMouseOut="javascript:hideGoDiv('<%=i %>')">
          <td width="5%" align="right"><input id="expertCheckBox" dojotype="dijit.form.CheckBox"
           name="expertCheckBox"  value=<%=myOL[i].getId()%>
           type="checkbox" />&nbsp;<img src="images/tpic.jpg"></td>
          <td width="20%" class="expertListRow">
            <A class=text-blue-01-link target='_top' href="expertfullprofile.htm?kolid=<%=myOL[i].getId()%>&entityId=<%=myOL[i].getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=myOL[i].getLastName()%>, <%=myOL[i].getFirstName()%>">
            <%=myOL[i].getLastName()%>, <%=myOL[i].getFirstName()%></A>
          </td>
          <td width="20%" class="text-blue-01">
            <% String speciality = "";
            	if(myOL[i].getPrimarySpeciality()!= null && !myOL[i].getPrimarySpeciality().equals("")){
            		speciality = myOL[i].getPrimarySpeciality();
            	}
            	if(myOL[i].getSecondarySpeciality()!= null && !myOL[i].getSecondarySpeciality().equals("")){
            		if(speciality.equals(""))
            			speciality = myOL[i].getSecondarySpeciality();
            		else
            			speciality = speciality + ", " + myOL[i].getSecondarySpeciality();
            	}
            	if(myOL[i].getTertiarySpeciality()!= null && !myOL[i].getTertiarySpeciality().equals("")){
            		if(speciality.equals(""))
            			speciality = myOL[i].getTertiarySpeciality();
            		else
            			speciality = speciality +", " + myOL[i].getTertiarySpeciality();
            	}
            	%>
           	<%=speciality%>
          </td>
          <td width="30%" class="text-blue-01">
            &nbsp;<%=myOL[i].getMslOlType()==null?"":myOL[i].getMslOlType()%>
          </td>
          <td width="20%" class="text-blue-01">

          <%
                        String location1 ="";
                        if(myOL[i].getAddressCity()!=null && !myOL[i].getAddressCity().equals(""))
                        location1 = myOL[i].getAddressCity();
	                    if(myOL[i].getAddressState()!= null && !myOL[i].getAddressState().equals(""))
	                    {
	                    	if(location1.equals(""))
	                    		location1 = myOL[i].getAddressState();
	                    	else
	                    		location1 = location1+", "+ myOL[i].getAddressState();
	                    }
	                    if(myOL[i].getAddressCountry()!=null &&
	                    		!myOL[i].getAddressCountry().trim().equalsIgnoreCase("United States") &&
	                    		!myOL[i].getAddressCountry().trim().equalsIgnoreCase("USA")&&
	                    		!myOL[i].getAddressCountry().trim().equalsIgnoreCase("United states of America") )
                        {
							if(location1.equals(""))
                          		location1 = myOL[i].getAddressCountry();
                          	else
                          		location1 = location1+", "+myOL[i].getAddressCountry();
                        }
                        %>
          <%=location1%>

          </td><%--
          <td width="15%">
          <div >
			<div id="quickContactDiv<%=i %>" style="display:none"  onMouseOver="javascript:showContentDiv('<%=i%>','false')" onMouseOut="javascript:hideContentDiv('<%=i%>')">
    			<a href='#' class="text-blue-01-link">Go</a>
			</div>
			<div id="<%=i%>Content" onMouseOver="javascript:showQuickContactDiv('<%=i%>')"  onMouseOut="javascript:hideQuickContactDiv('<%=i%>')" style="position:absolute;  display:none; width:135px; height:80px; top=47px; left=520px; padding-bottom:2px;  ">
			  <table width=100% bgColor="#E2EAEF" cellpadding="0" cellspacing="0"  style="padding-bottom:5px;opacity:0.2" >

             <%
               // check if the events feature needs to be enabled or not
               String enableEvents = (String) session.getAttribute("isEventsFeatureEnabled");
               if((enableEvents != null) && ("true".equalsIgnoreCase(enableEvents))) {
             %>
			  <tr><td>&nbsp;
            	<a target=_top href="event_add.htm?kolName=<%=myOL[i].getLastName()%>,<%=myOL[i].getFirstName()%>&kolId=<%=myOL[i].getId()%>" class="text-blue-01-link">Schedule Event</a>
          	  </td></tr>

          	  <tr><td height="24">&nbsp;
          	    <a target="_top" href='event_search.htm?&go=true&kolId=<%=myOL[i].getId()%>&kolName=<%=myOL[i].getLastName()%>,<%=myOL[i].getFirstName()%>', class="text-blue-01-link">
				Past Events</a>
          	  </td></tr>
                <%
                  }

                  // check if the interactions feature needs to be enabled or not
                String enableInteractions = (String) session.getAttribute("isInteractionsFeatureEnabled");
                if((enableInteractions != null) && ("true".equalsIgnoreCase(enableInteractions))) {
                %>
          	  <tr><td>&nbsp;
          	    <a href='searchInteraction.htm?action=<%=ActionKeys.SEARCH_INTERACTION%>&kol_name=<%=myOL[i].getLastName()%>,<%=myOL[i].getFirstName()%>&go=true&kolId=<%=myOL[i].getId()%>', target="_top" class="text-blue-01-link">
          	    Past Interactions</a>
          	  </td></tr>
          	  <tr><td>&nbsp;
          	    <a target=_top href='expertfullprofile.htm?fromInteraction=yes&kolid=<%=myOL[i].getId()%>&entityId=<%=myOL[i].getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=myOL[i].getLastName()%>, <%=myOL[i].getFirstName()%>' class="text-blue-01-link">New Interaction</a>
          	  </td></tr>
                <%
                  }
                %>
          	    <%if(!(featuresExpertList!=null && featuresExpertList.getProperty("EAV_PUBLICATIONS")!=null && featuresExpertList.getProperty("EAV_PUBLICATIONS").equalsIgnoreCase("false"))){
				 	%>
			    <tr><td>&nbsp;
          	    <a target='_top' href="expertfullprofile.htm?kolid=<%=myOL[i].getId()%>&entityId=<%=myOL[i].getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=myOL[i].getLastName()%>, <%=myOL[i].getFirstName()%>&go=true" class="text-blue-01-link">Publications</a>
          	  </td></tr>
          	  <%} %>
          	    <tr><td>&nbsp;
          	    <a target='_top' href="expertfullprofile.htm?kolid=<%=myOL[i].getId()%>&entityId=<%=myOL[i].getKolid()%>&<%=Constants.CURRENT_KOL_NAME%>=<%=myOL[i].getLastName()%>, <%=myOL[i].getFirstName()%>"class="text-blue-01-link">Profile</a>
          	  </td></tr>
          	  </table>
          	</div>
          </div>
          </td>
        --%></TR>

 <% }} else{ %>
        <tr>
          <td colspan="6" align="center" class="expertListRow">
            <b>No <%=DBUtil.getInstance().doctor%>s have been added to your list</b>
          </td>
        </tr>
      <% } %>

    </table>
    </div>
    <table width="100%" cellspacing="0">
    <tr>
    <td align="left">&nbsp;
    <div class="deleteButton" align="left" >
    <input type="button" name="delete1" value=""style="border:0;background :url(images/buttons/remove_from_list.gif);width: 123px; height: 22px;" value=""  onclick="javascript:deleteOls();"/>
    </div>
    </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
   </table>
  </div>
    <%--My tactics for the logged in user--%>

  <%
    boolean isPlanEnabled = false;
    String planEnabledPropVal = (String) session.getAttribute("isStrategyFeatureEnabled"); // the plan feature is tied to the strategy feature
    if((planEnabledPropVal != null) && ("true".equalsIgnoreCase(planEnabledPropVal)))
      isPlanEnabled = true;

    if(isPlanEnabled) { // Render the My Expert Plan section only if the strategy feature is enabled in the features.properties file
  %>

   <div class="producttext">
    <div class="myexpertplan">
      <table width="100%">
        <tr style="color:#4C7398">
        <td align="left">
          <div class="myexperttext">My Plan</div>
        </td>
        </tr>
      </table>
    </div>

    <table width="100%" cellspacing="0" class="sortable1">
      <tr bgcolor="#f5f8f4">

      <td width="5%" align="center">&nbsp;</td>
      <th width="30%" align="left" class="expertPlanHeader">Task Name</th>
      <th width="25%" align="left" class="expertPlanHeader"><%=DBUtil.getInstance().doctor%></th>
      <th width="25%" class="sortfirstdesc expertPlanHeader" align="left">Due date</th>
      <th width="15%"class="expertPlanHeader" align="left">Status</th>

      </tr>
       <%if( null != myTacticList && myTacticList.size() != 0){
           for(int i=0;i<myTacticList.size();i++){
                 InteractionsDTO tacticList = (InteractionsDTO)myTacticList.get(i);
    %>
              <tr bgcolor='<%=(i%2==0?"white":"#f5f8f4")%>' onmouseover="this.className='coloronmouseover'" onMouseout="this.className='<%=(i%2==0?"white":"#f5f8f4")%>'">
                <td width="5%" align="right"><img src="images/taskpic.jpg"></td>
                <td width="30%" class="expertListRow">
                  <a class=text-blue-01-link href='expertfullprofile.htm?kolid=<%=tacticList.getUserId()%>&entityId=<%=tacticList.getExpertId()%>&expertId=<%=tacticList.getExpertId()%>&fromTaskList=yes' target="_top"><%=tacticList.getActivity()%></a>
                </td>
                <td width="25%" class="text-blue-01"><%=tacticList.getFullName()%></td>
                <td width="25%" class="text-blue-01"><%=tacticList.getDueDate() != null ? tacticList.getDueDate() : "" %></td>
                <td width="15%" class="text-blue-01"><%=tacticList.getStatusName() != null ? tacticList.getStatusName() : "" %></td>
              </tr>
          <% }
         } else {%>
          <tr>
            <td colspan="5" align="center" class="expertListRow">
              <b>No Tasks were assigned</b>
            </td>
          </tr>
          <%}%>
      </table>
    </div>

   <%
    }
   %>

  </form>
</body>
</html>
