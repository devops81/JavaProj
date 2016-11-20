<jsp:directive.page import="com.openq.utils.PropertyReader"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="header.jsp" %>
<%@ page import="com.openq.eav.data.EntityAttribute" %>
<%@ page import="com.openq.eav.metadata.AttributeType" %>
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
            document.getElementById("vertSplitPanel").style.display = "block";
        } else {
            document.getElementById("expertInfoPanel").style.display = "block";
            document.getElementById("vertSplitPanel").style.display = "block";

        }

    }
    

</script>
<%
    HashMap leftNavMap = (HashMap) request.getSession().getAttribute("leftNavMap");
	String org_name = "", org_address = "", org_state = "", org_zip = "", org_phone = "", org_city = "";
	if (leftNavMap != null) {
		org_name = (String) leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_NAME"));
		org_address = (String) leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_ADDRESS_LINE_1"));
		org_state = (String) leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_STATE"));
		org_city = (String)leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_CITY"));
		org_zip = (String) leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_ZIP"));
		org_phone = (String) leftNavMap.get(PropertyReader.getEavConstantValueFor("ORG_PHONE"));
	}

%>

<body onload="javascript:changeStyle(0, 4)" ><form name="interactionForm" method="POST" AUTOCOMPLETE="OFF">

<div class="contentmiddle">
  <div class="contentleft">
       <div id="expertInfoPanel" class="koldetails" >
        <div class="leftsearchbgpic">
          <div class="leftsearchtext"><span class="text-blue-01-bold">Organization Details</span></div>
        </div>
        
        <div class="profileguesttext">
           		<span class="text-blue-01-bold"><%=org_name!=null?org_name:""%></span><br>
                <span class="text-blue-01"><%=org_address!=null?org_address:""%> <%=org_city!=null?org_city:""%>
                <%=org_state!=null?org_state:""%> <%=org_zip!=null?org_zip:""%> </span><br>
                <span class="text-blue-01-bold"><%=org_phone!=null?org_phone:""%></span>
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
                for (int i = 0; i < attributes.length; i++) {
                    colspan += 3;
            %>
            <td>
            <div onclick="javascript:changeStyle(<%=i%>, 4)" id="sec<%=i%>"
                class='<%=((i != 0) ? "submenu1" : "submenu2")%>'>&nbsp;

                <a id="att<%=i%>" href='innerProfilePage.htm?attributeId=<%=attributes[i].getAttribute_id()%>&entityId=<%=(map != null && map.get(attributes[i]) != null ? ((EntityAttribute) map.get(attributes[i])).getMyEntity().getId() + "": "")%>&parentId=<c:out escapeXml="false" value="${parentId}"/>' target="inner" class='<%=((i != 0) ? "text-black-link" : "text-white-link")%>' onclick="hideExpertInfo('<%=attributes[i].getName()%>')">
                <span class="exbold" align=center><%=attributes[i].getName()%></span></a>
                &nbsp;</div></td>
            

            <% } %>
            <td>
            <div onclick="javascript:changeStyle(2, 4)" id="sec2"
                class="submenu2">&nbsp;

                <a id="att1" href="search_interaction_main.htm?action=<%=ActionKeys.PROFILE_SHOW_ADD_INTERACTION%>&intType=org"  onclick="hideExpertInfo('Interactions')" class="text-black-link">
                <span class="exbold" align=center>Interactions</span></a>
                &nbsp;</div></td>
            <td>
            <div onclick="javascript:changeStyle(3, 4)" id="sec3"
                class="submenu2">&nbsp;

                <a id="att2" href="ol_org_map.htm?entityId=<%=request.getParameter("entityId")%>" target="inner" target="inner" onclick="hideExpertInfo('Organization')" class="text-black-link">
                <span class="exbold" align=center>Affiliated <%=DBUtil.getInstance().doctor%>s</span></a>
                &nbsp;</div></td>
            
        </tr>

    </table>
    <div class="clear">
    </div>
    <div  class="producttext">
      <iframe src='innerProfilePage.htm?attributeId=<%=attributes[0].getAttribute_id()%>&entityId=<%=(map.get(attributes[0]) != null ? ((EntityAttribute) map.get(attributes[0])).getMyEntity().getId() + "": "")%>&parentId=<c:out escapeXml="false" value="${parentId}"/>'
                        height="650" width="100%" name="inner" id="innerProfile" frameborder="0"
                        scrolling="auto"></iframe>
    </div>
    </div><!--content right-->
    </div><!--content middle-->                    
    </div>
    
</form>
<%@ include file="footer.jsp" %>
</body>
