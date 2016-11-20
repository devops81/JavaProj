<%@ page import="com.openq.kol.SearchDTO" %>
<%@ page import="java.net.URLEncoder,java.util.*"%>

<%

    SearchDTO expertDTO = null;


    ArrayList ad_expert_user_list = (ArrayList) session.getAttribute("EXPERT_ADVANCE_SEARCH");

    String fromDate = (String) session.getAttribute("fromDate");
    if (fromDate == null) fromDate = "";
    String toDate = (String) session.getAttribute("toDate");
    if (toDate == null) toDate = "";
    TreeMap searchAttributes = (TreeMap) session.getAttribute("searchAttributes");
    if (searchAttributes == null) searchAttributes = new TreeMap();
    int userTypeId = 0;/*Integer.parseInt((String) session.getAttribute(SessionKeys.USER_TYPE_ID));*/

    String kolScheduler = "";
    if (session.getAttribute("KOL_SCHEDULER") != null) {
        kolScheduler = (String) session.getAttribute("KOL_SCHEDULER");
    }

    /*String currentLink = null;
    if (session.getAttribute("CURRENT_LINK") != null) {
        currentLink = (String) session.getAttribute("CURRENT_LINK");
    }*/
    ArrayList ovidSrch = null;
    if (session.getAttribute("OVID_SEARCH_RESULT") != null) {
        ovidSrch = (ArrayList) session.getAttribute("OVID_SEARCH_RESULT");
    }

    TreeMap uniqueIdMap = null;
    if(session.getAttribute("UNIQUE_ID_MAP") != null) {
        uniqueIdMap = (TreeMap) session.getAttribute("UNIQUE_ID_MAP");
    }

%>

<%@ include file="adminHeader.jsp" %>
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
<script src="<%=COMMONJS%>/columnSort.js" language="Javascript"></script>

<Script language="Javascript">

function showText(text,id) {
    if(text != null && id != null) {
        text = decodeURIComponent(text);
        if(text != null && text.indexOf("+") != -1) {
            text = text.replace(/\+/g,' ');
        }
        document.getElementById(id).title=text.substring(0,500);
    }
}
function commitDB() {
    var flag = false;
    var thisform = document.OvidSearchForm;
    for (var i = 0; i < thisform.elements.length; i++) {

        if (thisform.elements[i].type == "checkbox" && thisform.elements[i].checked) {
            flag = true;
            break;
        }
    }
    if(flag) {
        thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.COMMIT_DB%>";
        thisform.submit();
    } else {
        alert("Please select atleast one Author to delete");
    }
}
    var ordCol = -1;

    function sortExpertData(imageContext, imgName, colNamesList, tableId, col, rev, dataType, orderedCol, dataSize) {


        if (dataSize == null || dataSize == 0)
            return false;

        // toggle the image head icon.
        var imageSrcURL = "";

        var colNames = colNamesList.split(",");
        var element;

        var currentArrow = "";

        for (var index = 0; colNames != null && index < colNames.length; ++index) {

            element = document.getElementById(colNames[index]);

            if (element != null) {

                if (imgName == element.id) {

                    imageSrcURL = imageContext + "/transparent.gif";

                    currentArrow = element.src.substring(element.src.lastIndexOf('/') + 1);

                    if (currentArrow != null && currentArrow == "transparent.gif") {
                        element.src = imageContext + "/arrow_up_dark.gif";
                        rev = false;
                    } else {
                        imageSrcURL = imageContext + "/arrow_down_dark.gif";
                        rev = true;
                        if (currentArrow != null && currentArrow == "arrow_down_dark.gif") {
                            element.src = imageContext + "/arrow_up_dark.gif";
                            rev = false;
                        } else {
                            element.src = imageSrcURL;
                        }
                    }

                } else {
                    imageSrcURL = imageContext + "/transparent.gif";
                    element.src = imageSrcURL;
                }
            }
        }

        sortTable(tableId, col, rev, dataType, ordCol);
        ordCol = col;

        //	sortTable(tableId, col, rev, dataType, orderedCol);
    }




    function searchOvid()
    {

        var thisform = document.OvidSearchForm;

        if ((thisform.authorName != null && thisform.authorName.value != "")
                && (thisform.institution != null && thisform.institution.value != "")) {

            thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.OVID_SEARCH%>";
            thisform.submit();
        } else {
            alert("Eneter Author Name/Institution/Year Of Publication")
        }

    }


    function show_calendar(sName) {
        gsDateFieldName = sName;
        // pass in field name dynamically
        var winParam = "top=200,left=200,width=174,height=189,scrollbars=0,resizable=0,toolbar=0";
        if (document.layers)    // NN4 param
            winParam = "top=200,left=200,width=172,height=200,scrollbars=0,resizable=0,toolbar=0";
        window.open("jsp/Popup/PickerWindow.htm", "_new_picker", winParam);
    }

    function MM_openBrWindow(theURL, winName, features)
    {
        window.open(theURL, winName, features);
    }

</Script>


<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
</head>

<body>
<form name="OvidSearchForm" method="Post" AUTOCOMPLETE="OFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

    <td>
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">

            <tr>
                <td height="1" align="left" valign="top" class="back-blue-01-dark"><img
                        src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
            </tr>

<tr>
    <td height="2" align="left" valign="top" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                            width="2" height="2"></td>
</tr>

<tr>
<td height="100%" align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

<td width="10" class="back-blue-02-light">&nbsp;</td>
<td class="back-blue-02-light">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                   height="10"></td>
</tr>

<tr valign="top">
    <td>
        <jsp:include page="ovid_search_menu.jsp"/>
    </td>
</tr>

<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="35"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Data Sources </td>
                <td class="text-white-bold" align="right"></td>


                <%if (ad_expert_user_list != null && ad_expert_user_list.size() > 0) { %>

                <td class="text-white-bold" align="right" valign="middle">
                </td>
                <td width="30" height="20">&nbsp;</td>

                <% } %>


            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>
<%
    if (ovidSrch != null && ovidSrch.size() == 0) {
%>
<tr>
    <td align="left" valign="top"><font face="verdana" size="2" color="red">
        <%="No results for the given search criteria"%></font>
    </td>
</tr>
<%
    }
%>

<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
	<td height="25" align="left" valign="top" class="back-grey-02-light">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr align="left" valign="middle">
			<td width="3" height="25" align="center">&nbsp;</td>
			<td width="5" align="left"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
			<td width="180" class="text-blue-01-bold">Database Name</td>
			<td width="10" height="25" align="center">&nbsp;</td>
			<td width="180" class="text-blue-01-bold">Short Name</td>
			<td width="10" height="25" align="center">&nbsp;</td>
		</tr>
	</table>
	</td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>

<tr>
    <td height="200" align="left" valign="top" class="back-white">
        <div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll;">

            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="3" align="center">&nbsp;</td>
						<td width="15" align="left">&nbsp;</td>
                        <td width="180">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                            <%
                            	Calendar today = Calendar.getInstance();
            					int curYear = today.get(Calendar.YEAR);
                            %>
                                <td align="right" valign="middle" class="text-blue-01">
                                    EMBASE <<%=(curYear-5)%> to Present>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td width="20" align="center">&nbsp;</td>
                        <td width="180">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td align="right" valign="middle" class="text-blue-01">
                                      emef
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="10" align="center">&nbsp;</td>
                    </tr>
                    <tr class="back-grey-02-light">
                        <td width="3" align="center">&nbsp;</td>
                        <td width="5" align="left">&nbsp;</td>

                        <td width="180">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="right" valign="middle" class="text-blue-01">
                                    MEDLINE <<%=(curYear-5)%> to Present>
                                </td>
                            </tr>
                        </table>
                        </td>
                        <td width="20" align="center">&nbsp;</td>
                        <td width="180">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td align="right" valign="middle" class="text-blue-01">
                                      medx
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="10" align="center">&nbsp;</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </td>
</tr>

<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif"
                                                                              width="1" height="1"></td>
</tr>

<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="1%" height="30">&nbsp;</td>
                <td width="39%"></td>
                <td width="1%" height="30">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>

</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

</form>

</body>
<%@ include file="footer.jsp" %>
</html>
