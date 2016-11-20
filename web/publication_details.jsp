<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="com.openq.ovid.Publications" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="com.openq.kol.SearchDTO"%>

<%

    SearchDTO expertDTO = null;

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
    if (session.getAttribute("UNCOMMITED_PUBLICATIONS") != null) {
        ovidSrch = (ArrayList) session.getAttribute("UNCOMMITED_PUBLICATIONS");
    }
    //System.out.println("ovidSrch   ---  " + ovidSrch.size());
    TreeMap uniqueIdMap = null;
    if (session.getAttribute("UNIQUE_ID_MAP") != null) {
        uniqueIdMap = (TreeMap) session.getAttribute("UNIQUE_ID_MAP");
    }
    ArrayList publicationDetails = null;
    if (session.getAttribute("PUBLICATION_DETAILS") != null) {
        publicationDetails = (ArrayList) session.getAttribute("PUBLICATION_DETAILS");
    }

    SearchDTO searchDTO = null;
    if (session.getAttribute("PROFILE_DETAILS") != null) {
        searchDTO = (SearchDTO) session.getAttribute("PROFILE_DETAILS");
    }

    if (null != ovidSrch && ovidSrch.size() > 0) {
		//apply sort on title
		java.util.Collections.sort(ovidSrch, new Comparator() {
            public int compare(Object o1, Object o2) {
                int result = -1;
                Publications dto1 = (Publications) o1;
                Publications dto2 = (Publications) o2;
                if(dto1 != null && dto1.getTitle() != null &&
                        dto2 != null && dto2.getTitle() != null) {
                    result = dto1.getTitle().compareTo(dto2.getTitle());

                }
                return result;
            }
        });
		//apply sort on year
		java.util.Collections.sort(ovidSrch, new Comparator() {
            public int compare(Object o1, Object o2) {
                int result = -1;
                Publications dto1 = (Publications) o1;
                Publications dto2 = (Publications) o2;
                if(dto1 != null && dto1.getYear() != null &&
                        dto2 != null && dto2.getYear() != null) {
                    result = -new Integer(dto1.getYear().trim()).compareTo(new Integer(dto2.getYear().trim()));

                }
                return result;
            }
        });
		//sort by confidence factor
        java.util.Collections.sort(ovidSrch, new Comparator() {
            public int compare(Object o1, Object o2) {
                int result = -1;
                Publications dto1 = (Publications) o1;
                Publications dto2 = (Publications) o2;
                if(dto1 != null && dto2 != null) {
                    result = -new Integer(dto1.getConfidenceFactor()).compareTo(new Integer(dto2.getConfidenceFactor()));

                }
                return result;
            }
        });

    }

%>

<%@ include file="adminHeader.jsp" %>
<html>
<head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
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

    thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.REFRESH_PROFILES%>";
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
        thisform.action = "<%=CONTEXTPATH%>/profileCapture.htm?action=<%=ActionKeys.COMMIT_DB%>";
        thisform.submit();
    } else {
        alert("Please select atleast one publication to commit");
    }
}

function deletePub(){
	var thisform = document.OvidSearchForm;
	var cntr = 0;
	var uniqueId;
	for(i=0;i<thisform.authorList.length;i++){
		if(thisform.authorList[i].checked){
			uniqueId = thisform.authorList[i].value;
			cntr++;
		}
		if(cntr > 1)
			break;
	}
	if(cntr == 0){
		alert("Please select a publication you want to delete");
		return;
	}
	if(cntr > 1){
		alert("Only one entry may be deleted at a time.  Please select only one.");
		return;
	}
	var index = uniqueId.indexOf(',');
	uniqueId = uniqueId.substr(index+1,uniqueId.length);

	if(confirm("You are about to permanently delete the chosen entry from the database, are you sure you would like to proceed?")){
		thisform.action = "<%=CONTEXTPATH%>/search.do?action=<%=ActionKeys.DELETE_PUBLICATION%>&uniqueId="+uniqueId;
		thisform.submit();
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

function MM_openBrWindow(theURL, winName, features) {
    window.open(theURL, winName, features);
}

function showAbstract(expertId,uniqueId) {
    window.open("<%=request.getContextPath()%>/profileCapture.htm?action=<%=ActionKeys.SHOW_ABSTRACT%>&expId="+expertId+"&uId="+uniqueId, "Abstract", "directories = no,location =no,height=450,width=600,menubar =no,resizable=no,toolbar =no");
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
    <td height="2" align="left" valign="top" class="back-blue-01-dark"><img src="<%=COMMONIMAGES%>/transparent.gif" width="2" height="2"></td>
</tr>

<tr>
<td height="100%" align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

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
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Profile Details</td>
                <td class="text-white-bold" align="right"></td>


            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="90" align="left" valign="top" class="back-white">
        <div style="position:relative;width: 100%;height: 90%;overflow-x:hidden;overflow-y:scroll;">
            <%
                if (searchDTO != null) {
            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody id="profileDetails">
                    <tr>
                        <td width="20"></td>
                        <td width="180"
                            class="text-blue-01">Name:</td>
                        <td width="10">&nbsp;</td>
                        <td width="400"
                            class="text-blue-01"><%=searchDTO.getExpertName() != null?searchDTO.getExpertName():""%></td>
                        <td width="10">&nbsp;</td>
                        <td width="10" class="text-blue-01"></td>

                    </tr>
                    <tr class="back-grey-02-light">
                        <td width="20"></td>
                        <td width="180"
                            class="text-blue-01">Institution:</td>
                        <td width="10">&nbsp;</td>
                        <td width="400"
                            class="text-blue-01"><%=searchDTO.getInstitution() != null ? searchDTO.getInstitution():""%></td>
                        <td width="10">&nbsp;</td>
                        <td width="10" class="text-blue-01"></td>

                    </tr>
                    <tr>
                        <td width="20"></td>
                        <td width="180"
                            class="text-blue-01">Disease Specialties:</td>
                        <td width="10">&nbsp;</td>
                        <td width="400"
                            class="text-blue-01"><%=searchDTO.getSpecialty() != null ? searchDTO.getSpecialty() : ""%></td>
                        <td width="10">&nbsp;</td>
                        <td width="10" class="text-blue-01"></td>

                    </tr>
                    <tr class="back-grey-02-light">
                        <td width="20"></td>
                        <td width="180"
                            class="text-blue-01">Location:</td>
                        <td width="10">&nbsp;</td>
						<%
							String location = "";
						    if(searchDTO.getCity() != null && !"".equals(searchDTO.getCity())) {
								location = searchDTO.getCity();							
							}
							if(searchDTO.getState() != null && !"".equals(searchDTO.getState())) {
								if(!"".equals(location)) {
									location += ", "+searchDTO.getState();						
								} else {
									location = searchDTO.getState();
								}
							}
							if(searchDTO.getCountry() != null && !"".equals(searchDTO.getCountry())) {
								if(!"".equals(location)) {
									location += ", "+searchDTO.getCountry();
								} else {
									location = searchDTO.getCountry();
								}														
							}							
						%>
                        <td width="400"
                            class="text-blue-01"><%=location%></td>
                        <td width="10">&nbsp;</td>
                        <td width="10" class="text-blue-01"></td>

                    </tr>
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
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>

<tr>
    <td height="8" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="25"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                <td class="text-white-bold">Publications</td>
                <td class="text-white-bold" align="right">
                    &nbsp;<%if (ovidSrch != null && ovidSrch.size() > 0) { %><%=ovidSrch.size()%>
                    new Publication(s) Found&nbsp;&nbsp;<% } %></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>
<%
    if (ovidSrch != null && ovidSrch.size() == 0) {
%>
<tr>
    <td align="left" valign="top"><font face="verdana" size="2" color="red">
        <%="No new Publications are available for " + searchDTO.getExpertName()%></font>
    </td>
</tr>
<%
    }
%>

<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
</tr>
<tr>
    <td height="25" align="left" valign="top" class="back-grey-02-light">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="1" height="25" align="center">&nbsp;</td>
                <td width="35" align="left"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>

                <td width="168">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'title','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 2, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Title
                                    <img id="title" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="1" height="25" align="center">&nbsp;</td>
				<td width="40">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="left" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'year','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 4, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Year
                                    <img id="year" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
				<td width="1" height="25" align="center">&nbsp;</td>
                <td width="125">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="right" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'journal','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 6, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Journal
                                    <img id="journal" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="1" height="25" align="center">&nbsp;</td>
                <td width="70">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="left" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'confidence','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 8, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Confidence Factor
                                    <img id="confidence" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="1" height="25" align="center">&nbsp;</td>
                <td width="200">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="left" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'authors','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 10, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Authors
                                    <img id="authors" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="1" height="25" align="center">&nbsp;</td>
				<td width="100">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="25" align="left" valign="middle">
                                <a class="text-blue-01-bold" href="#"
                                   onclick="sortExpertData('<%=COMMONIMAGES%>', 'citation','title,year,journal,confidence,authors,citation', 'sortExpertSearchResults', 12, false, 'typeStr', 2, '<%=(ovidSrch !=null && ovidSrch.size() > 0) ? ovidSrch.size() : 0%>');">Citation
                                    <img id="citation" src="<%=COMMONIMAGES%>/transparent.gif" alt="Sort" width="6" height="6" border="0">
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
				<td width="18" height="25" align="center">&nbsp;</td>
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
                if (ovidSrch != null && ovidSrch.size() > 0) {

            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody id="sortExpertSearchResults">
                    <%
                        Publications resultsDTO = null;
                        String authors = null;
                        String title = null;
                        for (int i = 0; i < ovidSrch.size(); i++) {
                            resultsDTO = (Publications) ovidSrch.get(i);
                    %>
                    <tr <% if (i % 2 > 0) {%> class="back-grey-02-light" <% } %>>
                        <td width="1">&nbsp;</td>
                        <td height="25" width="35" align="center"><input type="checkbox" name="authorList"  value="<%=resultsDTO.getExpertId()+","+resultsDTO.getUniqueIdentifier()%>"/>
                        </td>
                        <td width="165"
                            class="text-blue-01-link"><a href="#"   onclick="showAbstract('<%=resultsDTO.getExpertId()%>','<%=resultsDTO.getUniqueIdentifier()%>')" class="text-blue-01-link">

                            <%
                                if (resultsDTO.getTitle() != null &&
                                        resultsDTO.getTitle().length() > 100) {
                                    title = resultsDTO.getTitle().substring(0, 100);
                                } else {
                                    title = resultsDTO.getTitle();
                                }
                            %>
                            <%=title != null?title:""%>                             
                            </a>
                        </td>
                        <td width="1">&nbsp;</td>
						<td width="40" class="text-blue-01"><%=resultsDTO.getYear()%></td>
						<td width="1" class="text-blue-01">&nbsp;</td>
                        <td width="125"
                            class="text-blue-01"><%=resultsDTO.getNlmJournal() != null ? resultsDTO.getNlmJournal() : ""%></td>
                        <td width="1">&nbsp;</td>
                        <td width="65"
                            class="text-blue-01"><%=resultsDTO.getConfidenceFactor() + "%"%></td>
                        <td width="1" class="text-blue-01">&nbsp;</td>
                        <td width="195" class="text-blue-01">
                            <%
                                if (resultsDTO.getAuthor() != null &&
                                        resultsDTO.getAuthor().length() > 500) {
                                    authors = resultsDTO.getAuthor().substring(0, 500);
                                } else {
                                    authors = resultsDTO.getAuthor();
                                }
                            %>
                            <%=authors != null?authors:""%></td>
                        <td width="1" class="text-blue-01">&nbsp;</td>
						<td width="100" class="text-blue-01">
						<%=resultsDTO.getCitation() != null ? resultsDTO.getCitation() : ""%>
						</td>
						<td width="1" class="text-blue-01">&nbsp;</td>
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
                <td width="39%"><input type="button" name="commit" class="button-01" value="  Commit  " onClick="commitDB()"/>&nbsp;&nbsp; 									   <%--<input type="button" name="delete" class="button-01" value="  Delete  "          onClick="deletePub()"/>--%>
				</td>
                <td width="1%" height="30">&nbsp;</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
	<td height="20">&nbsp;</td>
</tr>
</table>
</td>
<td width="10" class="back-blue-02-light">&nbsp;</td>
</tr>
</table>
</td>
</tr>
</table>
</form>

</body>
<%@ include file="footer.jsp" %>
</html>