<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.group.Groups" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="com.openq.kol.DBUtil"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>
<% String mess = (String) request.getParameter("action"); %>
<%String message=null; %>

<% if(mess.equals("add"))
{
message=(String)session.getAttribute("MESSAGE1");
}
if(mess.equals("saveUser"))
{
message=(String)session.getAttribute("MESSAGE");
}
String prntmessage=message==null?"":message;

    ArrayList userTypeList = null;
    User[] userList = null;

    Groups[] groupInfo = null;
    if (session.getAttribute("ALL_USER_GROUPS") != null) {
        groupInfo = (Groups[]) session.getAttribute("ALL_USER_GROUPS");

    }

    OptionLookup userTypeOption[] = null;
    if (session.getAttribute("USER_TYPE_LIST") != null) {
        userTypeOption = (OptionLookup[]) session.getAttribute("USER_TYPE_LIST");
    }

    if (session.getAttribute("USER_SEARCH_LIST") != null) {
        userList = (User[]) session.getAttribute("USER_SEARCH_LIST");
    }

   
    String searchMessage = "";
    if (session.getAttribute("SEARCH_MESSAGE") != null) {
        searchMessage = (String) session.getAttribute("SEARCH_MESSAGE");
    }

    String partialName = "";
    int userType = 0;
    int groupType = 0;

    if (request.getAttribute("PARTIAL_USER_NAME") != null && !"".equals(request.getAttribute("PARTIAL_USER_NAME"))) {
        partialName = (String) request.getAttribute("PARTIAL_USER_NAME");
    }

    if (request.getAttribute("USER_TYPE_ID") != null && !"".equals(request.getAttribute("USER_TYPE_ID"))) {
        userType = Integer.parseInt((String) request.getAttribute("USER_TYPE_ID"));
    }

    if (request.getAttribute("GROUP_ID") != null && !"".equals(request.getAttribute("GROUP_ID"))) {
        groupType = Integer.parseInt((String) request.getAttribute("GROUP_ID"));
    }
    boolean isAlreadySelected = false;
%>
<html>
<head>
    <title><%=DBUtil.getInstance().doctor%> DNA 2.0 - openQ Technologies</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
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
    <Script language="Javascript">

        function searchUser(formObj, contextURL) {

            var thisform = document.updateUserForm;
            /*if ((thisform.userName.value == "") && (thisform.userTypeId.value == 0) && (thisform.groupId.value == 0)){
       alert("Please fill any one attribute");
       return;
     }	*/

            formObj.action = contextURL + "/users.htm?action=<%=ActionKeys.SEARCH_USER%>";
            formObj.submit();
        }

        function deleteUser(contextURL, userName, userTypeId, groupId) {

            var thisform = window.frames['userSearchList'].listUsersForm;
            var flag = false;

            for (var i = 0; i < thisform.elements.length; i++) {

                if (thisform.elements[i].type == "checkbox" && thisform.elements[i].checked) {
                    flag = true;
                    break;
                }
            }


            window.frames['userSearchList'].listUsersForm.action = contextURL + "/users.htm?action=<%=ActionKeys.DELETE_USER%>&userName=" + userName + "&userTypeId=" + userTypeId + "&groupId=" + groupId;
            if (flag)
            {
                if (confirm("Do you want to delete the selected user?"))
                {
                    window.frames['userSearchList'].listUsersForm.target = "_parent";
                    window.frames['userSearchList'].listUsersForm.submit();
                }
            }
            else
            {
                alert("Please select atleast one user to delete");
            }

        }

        function checkUncheck(formObj)
        {
            if (document.updateUserForm.checkUser.checked == true)
            {
                box = eval(window.frames['userSearchList'].listUsersForm.checkedUserList);

                if (box.length > 0)
                {
                    for (var i = 0; i < box.length; i++) {
                        box[i].checked = true;
                    }
                }
                else
                {
                    box.checked = true;
                }
            }
            else
            {
                box = eval(window.frames['userSearchList'].listUsersForm.checkedUserList);

                if (box.length > 0)
                {
                    for (var i = 0; i < box.length; i++)
                    {
                        box[i].checked = false;
                    }
                }
                else
                {
                    box.checked = false;
                }
            }
        } // end of checkUncheck()
    </Script>
</head>

<body class="">
<form name="updateUserForm" method="POST" AUTOCOMPLETE="OFF"
      action="javascript:searchUser(document.updateUserForm, '<%=CONTEXTPATH%>')">
<div class="producttext">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="left">
    <td>
        <font face="verdana" size="2" color="red">
            <b><%=prntmessage%></b>
        </font>
    <td>
</tr>
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
    <td width="10" rowspan="15" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top">
	<div class="myexpertlist">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="20">&nbsp;</td>
                <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="myexperttext">User Search</td>
            </tr>
        </table>
	</div>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                             width="1" height="1"></td>
</tr>
<tr>
    <td height="60" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td width="180" class="text-blue-01">Partial User Name</td>
                <td width="20">&nbsp;</td>
                <td width="180" class="text-blue-01">User Type</td>
                <td width="20">&nbsp;</td>
                <td width="180" class="text-blue-01">User Group</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td height="20">&nbsp;</td>
                <td><input name="userName" type="text" class="field-blue-01-180x20"
                           value="<%=(partialName != null ? partialName : "")%>"></td>
                <td>&nbsp;</td>

                <td><select name="userTypeId" class="field-blue-01-180x20">
                    <option value="-1" selected>Select User Type</option>
                    <%
                        if (userTypeOption != null && userTypeOption.length > 0) {
                            OptionLookup lookup = null;
                            isAlreadySelected = false;
                            for (int i = 0; i < userTypeOption.length; i++) {
                                lookup = userTypeOption[i];
                         		String selected = "" ;
                          		if(lookup.isDefaultSelected())
                          			selected = "selected";
                    %>
                    <option value="<%=lookup.getId()%>" 
                    <%if(userType != 0 && userType == lookup.getId()) {
                    	isAlreadySelected = true;
                    %> selected <%}
                    else if(!isAlreadySelected) {%><%=selected%> <%} %>><%=lookup.getOptValue()%></option>
                    <%
                            }
                        }
                    %>
                </select></td>
                <td>&nbsp;</td>
                <td><select name="groupId" class="field-blue-01-180x20">
                    <option value="-1" selected>Select Group Type</option>
                    <%
                        if (groupInfo != null && groupInfo.length > 0) {
                            Groups groups = null;
                            for (int i = 0; i < groupInfo.length; i++) {
                                groups = groupInfo[i];

                    %>
                    <option value="<%=groups.getGroupId()%>" <% if (groupType != 0 && groups.getGroupId() == groupType) { %>
                            selected <%}%>><%=groups.getGroupName()%></option>

                    <%
                            }
                        }
                    %>
                </select></td>
                <td class="text-black-link">&nbsp;</td>
            </tr>
            <tr>
                <td height="10" colspan="7"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="10" height="30">&nbsp;</td>

                <td><input name="search" type="button" class="button-01" style="border:0;background : url(images/buttons/search_user.gif);width:110px; height:23px;" value=""
                           onClick="javascript:searchUser(this.form, '<%=CONTEXTPATH%>')"></td>

            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="20" align="left" valign="top">
	<div class="myexpertplan">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
                <td width="2%" height="20">&nbsp;</td>
                <td width="2%"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="myexperttext">Search Results </td>
            </tr>
        </table>
	</div>
    </td>
</tr>
<%
    if (userList != null && userList.length > 0) {
%>
<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="140" align="left" valign="top" class="back-white">
        <iframe src="user_search_list.jsp" height="100%" width="100%" name="userSearchList"
                frameborder="0" scrolling="yes"></iframe>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>

<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="5" height="30">&nbsp;</td>

                <td><input name="delete" type="button" class="button-01" value="" style="border:0;background : url(images/buttons/delete_user.gif);width:102px; height:22px;"
                           onClick="javascript:deleteUser('<%=CONTEXTPATH%>', '<%=((request.getParameter("userName") != null) ? request.getParameter("userName") : "")%>', '<%=((request.getParameter("userTypeId") != null) ? request.getParameter("userTypeId") : "")%>', '<%=((request.getParameter("groupId") != null) ? request.getParameter("groupId") : "")%>')">
                </td>

            </tr>
        </table>
    </td>
</tr>
<%
} else {
%>
<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="25" height="25" align="center">&nbsp;</td>
                <td width="25" align="left">&nbsp;</td>
                <td class="text-blue-01-bold">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<tr>
    <td height="140" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="150">&nbsp;</td>
                <td class="text-blue-01-bold" align="center"><%=searchMessage%></td>
                <td width="200">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>

<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="5" height="30">&nbsp;</td>

                <td>&nbsp;</td>

            </tr>
        </table>
    </td>
</tr>
<%
    }
%>
<tr>
    <td align="left" valign="top">&nbsp;</td>
</tr>
</table>
</div>
</form>
<%
    session.removeAttribute("DISPLAY_GROUP_INFO");
    session.removeAttribute("MESSAGE");
    session.removeAttribute("SEARCH_MESSAGE");
%>
</body>
</html>