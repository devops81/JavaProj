<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>


<%@ page import="com.openq.kol.KeyMessageDTO" %>
<HTML>
<HEAD>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>Key Message</TITLE>
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
<script src="./js/validation.js"></script>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
<script language="javascript">

function show_calendar(sName) {
    gsDateFieldName = sName;
    var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
    if (document.layers)
        winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
    window.open("Popup/PickerWindow.html", "_new_picker", winParam);
}




function submitKOLKeyMsg(formObj, contextURL)
{


    if (!isEmptyText(formObj.keyMsgName,"Message Name"))
        return;
    if (!isEmptyText(formObj.marketClaims,"Market Claims"))
        return;
    

    if (formObj.keyMsgName.value.length <= 0)
    {
        alert("Please provide valid input for Key Message Name");
        formObj.keyMsgName.focus();
        return false;
    }
    else if (formObj.marketClaims.value.length <= 0) {
        alert("Please provide valid input for Market Claims");
        formObj.marketClaims.focus();
        return false;
    }

    formObj.action = "<%=CONTEXTPATH%>/kol_keymessages.htm?action=<%=ActionKeys.ADD_KOL_KEY_MESSAGE%>";

    formObj.target = "_self";
    formObj.submit();
}

function saveKOLKeyMsg(formObj, contextURL)
{

    if (!isEmptyText(formObj.keyMsgName,"Message Name"))
        return;
    if (!isEmptyText(formObj.marketClaims,"Market Claims"))
        return;
   
    
    if (formObj.keyMsgName.value.length <= 0)
    {
        alert("Please provide valid input for Key Message Name");
        formObj.keyMsgName.focus();
        return false;
    }
    else if (formObj.marketClaims.value.length <= 0) {
        alert("Please provide valid input for Market Claims");
        formObj.marketClaims.focus();
        return false;
    }


    formObj.action = "<%=CONTEXTPATH%>/kol_keymessages.htm?action=<%=ActionKeys.SAVE_KOL_KEY_MESSAGE%>";

    formObj.target = "_self";
    formObj.submit();
}


function editKeyMsg(keyMsgId) {

    var formObj = document.KOLKeyMsg;

    formObj.action = "<%=CONTEXTPATH%>/kol_keymessages.htm?action=<%=ActionKeys.EDIT_KOL_KEY_MESSAGE%>&keyMsgId=" + keyMsgId;

    formObj.target = "_self";
    formObj.submit();
}

function cancelKOLKeyMsg(formObj, contextURL) {

    formObj.action = "<%=CONTEXTPATH%>/kol_keymessages.htm?action=<%=ActionKeys.VIEW_KOL_KEY_MESSAGE%>";

    formObj.target = "_self";
    formObj.submit();
}

function deleteKeyMessage() {


    var thisform = document.KOLKeyMsg;
    var flag = false;

    thisform.action = "<%=CONTEXTPATH%>/kol_keymessages.htm?action=<%=ActionKeys.DELETE_KOL_KEY_MESSAGE%>";
    thisform.target = "_self";

    for (var i = 0; i < thisform.elements.length; i++) {

        if (thisform.elements[i].type == "checkbox" && thisform.elements[i].name == "keyMessageId" && thisform.elements[i].checked) {
            flag = true;
            break;
        }
    }

    if (flag) {
        if (confirm("Do you want to delete the selected Key Message/s?")) {
            thisform.submit();
        }
    } else {
        alert("Please select atleast one Key Message to delete");
    }

}

</script>
</head>


<%
    ArrayList keyMsgList = new ArrayList();

    if (session.getAttribute("KOL_KEY_MESSAGE") != null)
        keyMsgList = (ArrayList) session.getAttribute("KOL_KEY_MESSAGE");

    KeyMessageDTO keyMessageDTO = null;

    if (session.getAttribute("SEL_KOL_KEY_MESSAGE") != null)
        keyMessageDTO = (KeyMessageDTO) session.getAttribute("SEL_KOL_KEY_MESSAGE");

    String message = null;
    if (session.getAttribute("MESSAGE") != null)
        message = (String) session.getAttribute("MESSAGE");

    String show = "show";

    if (session.getAttribute("SHOW") != null)
        show = (String) session.getAttribute("SHOW");


%>


<body class="back-blue-02-light">
<form name="KOLKeyMsg" method="POST">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td>
        <jsp:include page="kol_menu.jsp" flush="true"/>
    </td>
</tr>
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>

<% if (message != null) {
%>
<tr>
    <td class="text-blue-01-red"><%=message%></td>
</tr>
<%
    }
%>

<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="8" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Messages</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="1%">&nbsp;</td>
                <td width="13%" align="left" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif"
                                                                            width="14" height="14">&nbsp;&nbsp;Market
                    Claims</td>
                <td width="9%" class="text-blue-01-bold">&nbsp;&nbsp;&nbsp;Messages</td>
                <td width="2%">&nbsp;</td>
                <td width="19%" class="text-blue-01-bold">&nbsp;&nbsp;Date</td>
               <%-- <td align="left" width="19%" class="text-blue-01-bold">Supporting Content</td>--%>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="100" align="left" valign="top" class="back-white">

    <div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <%
                for (int i = 0; i < keyMsgList.size(); ++i) {
                    KeyMessageDTO keyMsgDTO = (KeyMessageDTO) keyMsgList.get(i);
            %>
            <tr align="left" valign="middle" <%if (i % 2 > 0) {%> class="back-grey-02-light"<% }%>>
                <td width="4%" align="middle"><input type="checkbox" name="keyMessageId"
                                                     value="<%=keyMsgDTO.getKeyMessageId()%>"></td>

                <td width="30%" height="25" align="left" class="text-blue-01-link"><a
                        href="javascript:editKeyMsg('<%=keyMsgDTO.getKeyMessageId()%>')"
                        class="text-blue-01-link"><%=keyMsgDTO.getMarketClaims() != null ? keyMsgDTO.getMarketClaims() : ""%><a/>
                </td>
                <td width="25%"
                    class="text-blue-01"><%=keyMsgDTO.getKeyMessageName() != null ? keyMsgDTO.getKeyMessageName() : ""%></td>


                <td width="25%"
                    class="text-blue-01"><%=keyMsgDTO.getKeyMessageDate() != null ? keyMsgDTO.getKeyMessageDate() : ""%></td>
                <td width="15%" class="text-blue-01"></td>
            </tr>
            <%
                }
            %>


        </table>
    </div>
</tr>
<tr>
    <td width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img
            src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>


<tr>
    <td align="left" valign="top" class="back-white">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="5" height="30">&nbsp;</td>
                <%
                    if (keyMsgList != null && keyMsgList.size() > 0) {


                %>
                <td>
                    <input type="button" class="button-01" name="deleteProg" value="Delete Key Message"
                           onClick="deleteKeyMessage();">
                </td>
                <td width="10">&nbsp;</td>
                <%

                    }
                %>

            </tr>
        </table>
    </td>
</tr>


<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold"><%if (keyMessageDTO != null) { %> Edit <% } else { %> Add New <% } %>
                    Message</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-02-light"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                             width="1" height="1"></td>
</tr>

<tr>
    <td height="100" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <tr><td></td></tr>

            <tr>
                <td width="20" height="20">&nbsp;</td>
                <td width="10%" class="text-blue-01-bold">Message Name <sup> * </sup></td>
                <td width="5%" class="text-blue-01-bold">&nbsp;</td>
                <td class="text-blue-01-bold">Date</td>
                <td width="10" height="20">&nbsp;</td>
            </tr>

            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td><input name="keyMsgName" type="text" class="field-blue-03-130x20" maxLength="50"
                           value="<%=(keyMessageDTO != null && keyMessageDTO.getKeyMessageName() != null) ? keyMessageDTO.getKeyMessageName() : ""%>">
                <td width="5%" class="text-blue-01">&nbsp;</td>
                <input name="selKeyMsgId" type="hidden"
                       value="<%=(keyMessageDTO != null && keyMessageDTO.getKeyMessageId() != 0) ? keyMessageDTO.getKeyMessageId()+"" : ""%>">


                <td>
                    <input name="keyMsgDate" type="text" class="field-blue-03-130x20" maxLength="50" readOnly
                           value="<%=(keyMessageDTO != null && keyMessageDTO.getKeyMessageDate() != null) ? keyMessageDTO.getKeyMessageDate() : ""%>">
                    <a href="javascript:show_calendar('KOLKeyMsg.keyMsgDate')">
                        <img src="<%=COMMONIMAGES%>/icon_calendar.gif" width="14" height="17" border="0">
                    </a>
                </td>
                <td width="10" height="20">&nbsp;</td>
            </tr>

            <tr><td height="10"></td></tr>

            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td width="10%" class="text-blue-01-bold">Market Claims <sup> * </sup></td>
                <td width="5%" class="text-blue-01">&nbsp;</td>
                <td class="text-blue-01-bold">Market Claims Description</td>
                <td width="10" height="20">&nbsp;</td>
            </tr>

            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td valign="top"><input name="marketClaims" type="text" class="field-blue-03-130x20" maxLength="50"
                                        value="<%=(keyMessageDTO != null && keyMessageDTO.getMarketClaims() != null) ? keyMessageDTO.getMarketClaims() : ""%>">
                </td>
                <td width="5%" class="text-blue-01">&nbsp;</td>
                <td><textarea name="marketClaimsDesc" wrap="VIRTUAL"
                              class="field-blue-12-220x100"><%=(keyMessageDTO != null && keyMessageDTO.getMarketClaimsDesc() != null) ? keyMessageDTO.getMarketClaimsDesc().trim() : ""%></textarea>
                </td>

                <!--<td valign="top" width="50%"><a href="#" class="text-black-link">Link Documents</a></td> -->
            </tr>

            <tr>
                <td colspan="6" width="100%" height="5" align="left" valign="top"></td>
            </tr>

            <tr>
                <td colspan="6" width="100%" height="1" align="left" valign="top" class="back-blue-03-medium"><img
                        src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
            </tr>

            <tr height="30">
                <td width="5">&nbsp;</td>

                <% if ("show".equalsIgnoreCase(show)) { %>

                <td colspan="5">
                    <input name="addMsg" type="button" class="button-01" value="Add Message"
                           onClick="submitKOLKeyMsg(this.form, '<%=CONTEXTPATH%>');">
                </td>
                <% } else { %>

                <td colspan="5">
                    <input name="editMsg" type="button" class="button-01" value="Save Message"
                           onClick="saveKOLKeyMsg(this.form, '<%=CONTEXTPATH%>');">
                    &nbsp;&nbsp;&nbsp;&nbsp;<input name="cancelMsg" type="button" class="button-01" value="Cancel"
                                                   onClick="cancelKOLKeyMsg(this.form, '<%=CONTEXTPATH%>');">
                </td>

                <% } %>

            </tr>

        </table>
    </td>
</tr>

</table>
</form>
</body>
</html>

<%

    session.removeAttribute("MESSAGE");
    session.removeAttribute("SHOW");
    session.removeAttribute("SEL_KOL_KEY_MESSAGE");
    session.removeAttribute("KOL_KEY_MESSAGE");

%>