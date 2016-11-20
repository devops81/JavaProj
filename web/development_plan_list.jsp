<%@ page import="com.openq.kol.InteractionsDTO"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.utils.PropertyReader"%>
<%@ page import="com.openq.kol.DBUtil"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ include file="imports.jsp"%>


<%
 String frontEndAdmin = PropertyReader.getEavConstantValueFor("FRONT_END_ADMIN"); 
  long userType = -1;
if(request.getSession().getAttribute(Constants.USER_TYPE) != null) {
    userType = ((OptionLookup)request.getSession().getAttribute(Constants.USER_TYPE)).getId();
}
 ArrayList devPlansList = new ArrayList();
 if (session.getAttribute("DEV_PLANS_LIST") != null) {
	devPlansList = (ArrayList)session.getAttribute("DEV_PLANS_LIST");
 }

 int userId = 0;
 if (session.getAttribute("USER_ID") != null) {
 	userId = Integer.parseInt((String) session.getAttribute("USER_ID"));
 }

   HashMap activityList = new HashMap();
   if(session.getAttribute("ACTIVITY") != null ){
       activityList = (HashMap) session.getAttribute("ACTIVITY");
   }
    String prettyPrint = null != request.getParameter("prettyPrint") ? (String) request.getParameter("prettyPrint") : null ;


	if (prettyPrint != null && "true".equalsIgnoreCase(prettyPrint) ) {
%>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
       	<td align="right"><span class="text-blue-01-bold" onClick="javascript:window.close()"><IMG
            height=16 src="images/close.gif" width=16 align=middle
            border=0>&nbsp;Close</span>&nbsp;&nbsp;<span class="text-blue-01-bold" onClick="javascript:window.print()"><img src='images/print_icon.gif' align=middle border=0 height="19"/>&nbsp;Print</span>&nbsp;</td>
	  </tr>
	  </table>
<%}%>


<html>
<head>
<title><%=DBUtil.getInstance().doctor%> DNA 2.0 - openQ Technologies</title>
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

<body>
<form name="devPlansListForm" method="post">

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<% if (null != prettyPrint ) {%>
 <tr height="30" class="back-grey-02-light">
   <td width="15" height="20" align="center" valign="middle"></td>
    <td width="15"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"></td>
    <td width="25%" class="text-blue-01-bold">Activity </td>
    <td width="12%" class="text-blue-01-bold">Status </td>
    <td width="18%" class="text-blue-01-bold">Due Date </td>
    <td width="12%" class="text-blue-01-bold">Owner   </td>
    <td width="9%" class="text-blue-01-bold">Title  </td>
    <td width="100" class="text-blue-01-bold">Comment  </td>
  </tr>
<%}%>
  <% 	boolean found =false;
	for (int i = 0; i < devPlansList.size() ; i++) {
		InteractionsDTO interactionsDTO =(InteractionsDTO) devPlansList.get(i);
         if (activityList != null ){ System.out.println(interactionsDTO.getDevPlanId());
             found = activityList.containsValue(interactionsDTO.getActivity());
             session.setAttribute("FOUND",new Boolean(found));
         }
  %>
  <tr <% if(i%2>0){%> class="back-grey-02-light" <%}%>>
    <td width="2%" height="20" align="center" valign="middle">
      <input type="checkbox" name="checkedDevPlanList" value="<%=interactionsDTO.getDevPlanId()%>" <%if (userId != interactionsDTO.getUserId() && userType != Long.parseLong(frontEndAdmin)) { %> disabled <% } %>>
    </td>
    <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_events.gif" width="14" height="14"></td>
    <td width="20%" class="text-blue-01">
  <%--   <% if (found ){ %>--%>
        <%if((interactionsDTO.getStaffId() == null) || ("".equals(interactionsDTO.getStaffId())) || (interactionsDTO != null && interactionsDTO.getAmgenOwnerUserId() != null
            && !"".equals(interactionsDTO.getAmgenOwnerUserId()) && userId == Integer.parseInt(interactionsDTO.getAmgenOwnerUserId())) && null == prettyPrint) { %>
            <a href="<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.EDIT_DEV_PLAN%>&devPlanId=<%=interactionsDTO.getDevPlanId()%>&activity=<%=interactionsDTO.getActivityId()%>&role=<%=interactionsDTO.getRole()%>&comments=<%=interactionsDTO.getComment()%>" target="_parent" class="text-blue-01-link"><%=interactionsDTO.getActivity()%></a>
        <%} else {%>
        <a href="<%=CONTEXTPATH%>/searchInteraction.htm?action=<%=ActionKeys.EDIT_DEV_PLAN%>&devPlanId=<%=interactionsDTO.getDevPlanId()%>&activity=<%=interactionsDTO.getActivityId()%>&role=<%=interactionsDTO.getRole()%>&comments=<%=interactionsDTO.getComment()%>" target="_parent" class="text-blue-01-link"> <%=interactionsDTO.getActivity()%></a>
        <%}%>
     <%--<%}else {%>
     <%=interactionsDTO.getActivity()%>
     <%}%>--%>
    </td>

    <td width="12%" class="text-blue-01"><%=interactionsDTO.getStatusName() != null ? interactionsDTO.getStatusName() : "" %>
    <%--<td width="100" class="text-blue-01"><%=interactionsDTO.getTherapyName() != null ? interactionsDTO.getTherapyName() : ""%>--%>
    <td width="15%" class="text-blue-01"><%=interactionsDTO.getDueDate() != null ? interactionsDTO.getDueDate() : ""%>
    <td width="16%" class="text-blue-01"><%=interactionsDTO.getOwner() != null ? interactionsDTO.getOwner() :""%>
    <td width="15%" class="text-blue-01"><%=interactionsDTO.getRoleName() != null ?  interactionsDTO.getRoleName() :""%></td>
    <td width="27%" class="text-blue-01"><%=interactionsDTO.getComment() != null ?  interactionsDTO.getComment() :""%></td>      
    <td width="1%"></>
  </tr>

  <%

     } // end of for loop
  %>


</table>

</form>
</body>
</html>

<%
	session.removeAttribute("prettyPrint");
%>
