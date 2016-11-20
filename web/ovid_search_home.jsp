<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page import="com.openq.ovid.OvidResultsDTO" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.openq.kol.DBUtil"%>

<%
    int userTypeId = 0;//Integer.parseInt((String) session.getAttribute(SessionKeys.USER_TYPE_ID));

    String kolScheduler = "";
    if (session.getAttribute("KOL_SCHEDULER") != null) {
        kolScheduler = (String) session.getAttribute("KOL_SCHEDULER");
    }


    ArrayList ovidSrch = null;
    if (session.getAttribute("OVID_SEARCH_RESULT") != null) {
        ovidSrch = (ArrayList) session.getAttribute("OVID_SEARCH_RESULT");
    }

    TreeMap uniqueIdMap = null;
    if (session.getAttribute("UNIQUE_ID_MAP") != null) {
        uniqueIdMap = (TreeMap) session.getAttribute("UNIQUE_ID_MAP");
    }
    ArrayList publicationDetails = null;
    if (session.getAttribute("PUBLICATION_DETAILS") != null) {
        publicationDetails = (ArrayList) session.getAttribute("PUBLICATION_DETAILS");
    }

	if (null != publicationDetails && publicationDetails.size() > 0) {
		//apply sort on expert name
		java.util.Collections.sort(publicationDetails, new Comparator() {
            public int compare(Object o1, Object o2) {
                OvidResultsDTO dto1 = (OvidResultsDTO) o1;
                OvidResultsDTO dto2 = (OvidResultsDTO) o2;
                return dto1.getExpertName().toUpperCase().compareTo(dto2.getExpertName().toUpperCase());
            }
        });
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
function refreshPub() {
    var thisform = document.OvidSearchForm;

    thisform.action = "<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.OVID_RESULTS%>&link=Results";
    thisform.submit();
}


function showText(text, id) {
    if (text != null && id != null) {
        text = decodeURIComponent(text);
        if (text != null && text.indexOf("+") != -1) {
            text = text.replace(/\+/g, ' ');
        }
        document.getElementById(id).title = text.substring(0, 500);
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
    if (flag) {
        thisform.action = "<%=CONTEXTPATH%>/profileCapture.htm??action=<%=ActionKeys.COMMIT_DB%>";
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

    /*  if ((thisform.authorName != null && thisform.authorName.value != "")
&& (thisform.institution != null && thisform.institution.value != "")) {*/

    thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.OVID_SEARCH%>";
    thisform.submit();
    /*} else {
        alert("Eneter Author Name/Institution/Year Of Publication")
    }*/

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
    var win = window.open(theURL, winName, features);
    
}

</Script>


<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head>

<body>
<form name="OvidSearchForm" method="Post" AUTOCOMPLETE="OFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

    <td>
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">




<tr>
<td height="100%" align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
<!--		<td width="200" class="back-blue-02-light">
		<iframe name="adcalender" src="<%=COMMONJSP%>/blank.jsp" height="100%" width="120%"  frameborder="0" scrolling="auto"></iframe>
		</td>
        <td width="5" class="back_vert_sprtr">&nbsp;</td>
-->
<td width="10" class="back-blue-02-light">&nbsp;</td>
<td class="back-blue-02-light">
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>


<tr valign="top">
    <td>
        <jsp:include page="ovid_search_menu.jsp"/>
    </td>
</tr>

<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="30" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Search Results</td>
                <td class="text-white-bold" align="right">
                    &nbsp;<%if (ovidSrch != null && ovidSrch.size() > 0) { %><%=ovidSrch.size()%>
                    Publication(s) Found &nbsp;&nbsp;<% } %></td>


            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="8" height="25" align="center">&nbsp;</td>
                <td width="25" align="left"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>

                <td width="180">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'expName','expName,totalPubs,newPubs,lupdate', 'sortExpertSearchResults', 2, false, 'typeStr', 2, '<%=(publicationDetails !=null && publicationDetails.size() > 0) ? publicationDetails.size() : 0%>');"><%=DBUtil.getInstance().doctor%> Name<img id="expName" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="10" height="25" align="center">&nbsp;</td>
                <td width="180">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'totalPubs','expName,totalPubs,newPubs,lupdate', 'sortExpertSearchResults', 4, false, 'typeNum', 2, '<%=(publicationDetails !=null && publicationDetails.size() > 0) ? publicationDetails.size() : 0%>');">Total
                                    Publications<img id="totalPubs" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="10" height="25" align="center">&nbsp;</td>
                <td width="180">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'newPubs','expName,totalPubs,newPubs,lupdate', 'sortExpertSearchResults', 6, false, 'typeNum', 2, '<%=(publicationDetails !=null && publicationDetails.size() > 0) ? publicationDetails.size() : 0%>');">New
                                    Publications<img id="newPubs" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="10" height="25" align="center">&nbsp;</td>
                <td width="180">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#" onclick="sortExpertData('<%=COMMONIMAGES%>','lupdate','expName,totalPubs,newPubs,lupdate', 'sortExpertSearchResults', 8, false, 'typeDate', 2, '<%=(publicationDetails !=null && publicationDetails.size() > 0) ? publicationDetails.size() : 0%>');">Last Update<img id="lupdate" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="24" height="25" align="center">&nbsp;</td>

            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="200" align="left" valign="top" class="back-white">
        <div style="position:relative;width: 100%;height: 100%;overflow-x:hidden;overflow-y:scroll;">
            <%
                if (publicationDetails != null && publicationDetails.size() > 0) {

            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody id="sortExpertSearchResults">
                    <%
                        OvidResultsDTO resultsDTO = null;
                        for (int i = 0; i < publicationDetails.size(); i++) {
                            resultsDTO = (OvidResultsDTO) publicationDetails.get(i);
                    %>
                    <tr <% if (i % 2 > 0) {%> class="back-grey-02-light" <% } %>>
                        <td width="10">&nbsp;</td>
                        <td height="20" width="25" align="center">&nbsp;</td>

                        <td width="180"
                            class="text-blue-01-link">
                            <a href="<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.PUBLICATION_DETAILS%>&expert_id=<%=resultsDTO.getAuthorId()%>"
                               class="text-blue-01-link">
                                <%=resultsDTO.getExpertName() != null ? resultsDTO.getExpertName() : ""%></a></td>
                        <td width="10">&nbsp;</td>
                        <td width="180"
                            class="text-blue-01"><%=resultsDTO.getTotalPublication()%></td>
                        <td width="10">&nbsp;</td>
                        <td width="180"
                            class="text-blue-01"><%=resultsDTO.getNewPublications()%></td>
                        <td width="10" class="text-blue-01">&nbsp;</td>
                        <td width="180"
                            class="text-blue-01">
                        <!-- New Link -->
                        <%
                            String commitDate = "";
                            if(resultsDTO.getLastUpdate() != null) {
                            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
                            commitDate = sdf.format(resultsDTO.getLastUpdate());
                        %>
                          <%=commitDate%>
                        <%
							} else {
                        %>
						&nbsp;
						<%	}	%>
                        </td> 
                        <td width="10" class="text-blue-01">&nbsp;</td>

                    </tr>
                    <%
                        }//end of for loop
                    %>
                </tbody>
            </table>
            <%
                }//end of if size > 0
            %>
        </div>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="30" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="1%" height="30">&nbsp;</td>
                <td width="39%"><input type="button" name="refresh" class="button-01" value="Refresh Profile(s)"
                                       onClick="refreshPub()"/></td>
                <td width="1%" height="30">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>

</table>
</td>
<td width="10" class="back-blue-02-light">&nbsp;</td>
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
