<jsp:directive.page import="com.openq.utils.PropertyReader"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
<%@ page import="com.openq.eav.trials.TrialsConstants" %>
<%@ page import="java.util.HashMap" %>


<script language="javascript">
    var globalSelectedIndex = 0;

    function changeStyle(selectedIndex, total) {

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

    }
    
    function hideExpertInfo(sectionName) {
        if ("Interactions" == sectionName) {
            document.getElementById("expertInfoPanel").style.display = "block";
            //document.getElementById("vertSplitPanel").style.display = "block";
        } else {
            document.getElementById("expertInfoPanel").style.display = "block";
            //document.getElementById("vertSplitPanel").style.display = "block";

        }

    }
    

</script>
<%
    HashMap leftNavMap = (HashMap) request.getSession().getAttribute("leftNavMap");
	String trial_official_title = "";
	String trial_phase = "";
	String trial_status = "";
	if (leftNavMap != null) {
		trial_official_title = (String) leftNavMap.get(TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID + "");
		trial_phase = (String) leftNavMap.get(TrialsConstants.TRIAL_PHASE_ATTRIB_ID + "");
		trial_status = (String) leftNavMap.get(TrialsConstants.TRIAL_STATUS_ATTRIB_ID + "");
	}

%>

<body ><form name="interactionForm" method="POST" AUTOCOMPLETE="OFF">

<div class="contentmiddle" width="100%">
  <div class="contentleft">
       <div id="expertInfoPanel" class="koldetails" >
        <div class="leftsearchbgpic">
          <div class="leftsearchtext"><span class="text-blue-01-bold">Trial Details</span></div>
        </div>
        
        <div class="profileguesttext">
           		<span class="text-blue-01-bold">Official Title</span><br>
           		<span class="text-blue-01"><%=trial_official_title!=null?trial_official_title:""%></span><p>
           		
           		<span class="text-blue-01-bold">Phase</span><br>
                <span class="text-blue-01"><%=trial_phase!=null?trial_phase:""%></span><p>
                
                <span class="text-blue-01-bold">Status</span><br>
                <span class="text-blue-01"><%=trial_status!=null?trial_status:""%></span><br>
        </div>
      </div>
  </div><!--content left ends here-->
  <div class="contentright">
<%
    //EntityAttribute [] attributes = (EntityAttribute []) request.getSession().getAttribute("attributes");
    AttributeType [] attributes = (AttributeType []) request.getSession().getAttribute("attrTypes");
    HashMap map = (HashMap) request.getSession().getAttribute("attributesMap");
    int colspan = 1;
%>

      <div class="submenu">
	      <table width="100%" cellspacing="0" cellpadding="0">
	      	<tr width="100%">
      

            <%
                int tabCount = attributes.length;
                for (int i = 0; i < attributes.length; i++) {
                    colspan += 3;
            %>
            <td>
            <div onclick="javascript:changeStyle(<%=i%>, <%=tabCount + 2%>)" id="sec<%=i%>"
                class='<%=((i == 0) ? "submenu1" : "submenu2")%>'>&nbsp;

                <a id="att<%=i%>" href='innerProfilePage.htm?attributeId=<%=attributes[i].getAttribute_id()%>&entityId=<%=(map != null && map.get(attributes[i]) != null ? ((EntityAttribute) map.get(attributes[i])).getMyEntity().getId() + "": "")%>&parentId=<c:out escapeXml="false" value="${parentId}"/>' target="inner" class='<%=((i != 0) ? "text-black-link" : "text-white-link")%>' onclick="hideExpertInfo('<%=attributes[i].getName()%>')">
                <span class="exbold" align=center><%=attributes[i].getName()%></span></a>
                &nbsp;</div></td>
            

            <% } %>
            <!-- Turn off the interactions tab -->
            <!--td>
            <div onclick="javascript:changeStyle(1, <%=tabCount + 2%>)" id="sec<%=tabCount + 1%>"
                class="submenu2">&nbsp;

                <a id="att<%=tabCount + 1%>" href="search_interaction_main.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>" target="inner" target="inner" onclick="hideExpertInfo('Interactions')" class="text-black-link">
                <span class="exbold" align=center>Interactions</span></a>
                &nbsp;</div></td-->
            <td>
            <div onclick="javascript:changeStyle(2, <%=tabCount + 2%>)" id="sec<%=2%>"
                class="submenu2">&nbsp;

                <a id="att<%=tabCount + 2%>" href="trial_to_ol_map.htm?entityId=<%=request.getParameter("entityId")%>" target="inner" target="inner" onclick="hideExpertInfo('Trial')" class="text-black-link">
                <span class="exbold" align=center>Affiliated <%=DBUtil.getInstance().doctor%>s</span></a>
                &nbsp;</div></td>
            
        </tr>

    </table>
    <div class="clear">
    </div>
    <div  class="producttext">
      <iframe src='innerProfilePage.htm?attributeId=<%=attributes[0].getAttribute_id()%>&entityId=<%=(map.get(attributes[0]) != null ? ((EntityAttribute) map.get(attributes[0])).getMyEntity().getId() + "": "")%>&parentId=<c:out escapeXml="false" value="${parentId}"/>'
                        height="600" width="100%" name="inner" id="innerProfile" frameborder="0"
                        scrolling="auto"></iframe>
    </div>
    </div><!--content right-->
	</div><!--content middle-->
	</div>          
    <%@ include file="footer.jsp" %>
   
    
    
</form>
</form>
