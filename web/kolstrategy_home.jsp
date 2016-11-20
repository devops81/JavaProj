<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="header.jsp" %>
<html>
<head>
    <title>openQ 2.0 - openQ Technologies Inc.</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


    <style type="text/css">
        <!--
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }

        -->
    </style>
    <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">

</head>
<%
    TreeMap hirarchyMap = new TreeMap();
    if (session.getAttribute("HIERARCHY_MAP") != null) {
        hirarchyMap = (TreeMap) session.getAttribute("HIERARCHY_MAP");
    }

    String segmentId = null;
    if (request.getParameter("segId") != null) {
        segmentId = (String) request.getParameter("segId");
    }
 
    if (segmentId == null || (segmentId != null && !"".equals(segmentId))) {
        if (session.getAttribute("segId") != null && !"".equals(session.getAttribute("segId"))) {
            segmentId = (String) session.getAttribute("segId");
        }
    }
 
    String rootNode = "";
    if (session.getAttribute("rootnode") != null) {
        rootNode = (String) session.getAttribute("rootnode");
    }
  int userType = 0;
    if (session.getAttribute("USER_TYPE") != null) {
        userType = Integer.parseInt((String)session.getAttribute("USER_TYPE"));
    }
  
 
%>
<script>
    function showHirarchyView(hirarName, rootNode) {
        if ("true" == rootNode) {
         if(document.getElementById("kolHeader")) {
            document.getElementById("kolHeader").innerHTML = "KOL Strategy";
            }
        } else {
            if (hirarName != null && hirarName != "null" && hirarName != "" && document.getElementById("kolHeader")) {
                if (hirarName == undefined ) {                
                    document.getElementById("kolHeader").innerHTML = "KOL Strategy";                    
                } else {
                    document.getElementById("kolHeader").innerHTML = "KOL Strategy > " + hirarName;
                    hirarName = "";
                }
            } else {
            if(document.getElementById("kolHeader")) {
                document.getElementById("kolHeader").innerHTML = "KOL Strategy";
             }
            }
        }
    }
</script>

<body onLoad="showHirarchyView(
<% String hirarName = "";
   if(segmentId != null && !segmentId.equals("") && hirarchyMap!= null) {
	  hirarName = (String)hirarchyMap.get(new Integer(segmentId));	
   }
%>
'<%=hirarName%>',<%if(rootNode != null) {%>'<%=rootNode%>'<% } %>
);">

<table  border=0 cellspacing=0 cellpadding=0 width=99% height="600">
<br>
	 <tr>
		<td width="23%" align="left" valign="top" height="600">
				<div class="expertsegmentationdiv">
					<div class="leftsearchbgpic" style="width:250">
						<div class="leftsearchtext"><%=DBUtil.getInstance().doctor%> Segmentation</div>
					</div>
					<iframe id="backgr1" name="tree" src="kol_manage_tree.jsp" width="250" height="800"
                                        frameborder="0" scrolling="auto" ></iframe>
				</div>
		</td>
		
		<td valign="top">
		     <div class="producttext">
					<!-- Go to Segment Strategy page if returning from Add Expert else -->
                    <!-- go to Create Segment page -->
                     <%
	                     if (segmentId == null ) {
	                        session.setAttribute("CURRENT_LINK", "createNode");
	                 %>
							<iframe src="kol_create_node.jsp" height="800" width="100%" name="main" frameborder="0" scrolling=no></iframe>
	                    <% } else { %>
							<iframe src="kol_setsegment.jsp" height="800" width="100%" name="main" frameborder="0" scrolling="auto"></iframe>
	                    <% } %>
              </div>
		</td>
	</tr>
</table>

<%@ include file = "footer.jsp" %>
</body>
<%
    session.removeAttribute("segId");
%>
</html>