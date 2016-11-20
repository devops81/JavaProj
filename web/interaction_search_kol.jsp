<%@ page import="com.openq.eav.expert.MyExpertList" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ include file="imports.jsp" %>
<HTML>
<HEAD>
    <TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
    <LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
</HEAD>
<%
    MyExpertList[] myExpertListses = null;

    TreeMap treeMap = new TreeMap();

    if (null != request.getAttribute("myexperts_list")) {
        myExpertListses = (MyExpertList[]) request.getAttribute("myexperts_list");
    }
    String kolObjects = null;
    if (null != request.getAttribute("KOL_OBJECT") &&
            !"".equals(request.getAttribute("KOL_OBJECT"))) {
        kolObjects = (String) request.getAttribute("KOL_OBJECT");
    }

%>

<script type="text/javascript">
    var id;
    var name;
    var requestArray =new Array();

    function requestObject(expertId, expertName) {
        this.id = expertId;
        this.name = expertName;
    }

    <%
        if (null != myExpertListses && myExpertListses.length > 0) {

            for (int i = 0; i < myExpertListses.length; i++) {
                if (!treeMap.containsKey(myExpertListses[i].getId() + "")) {
                    treeMap.put(myExpertListses[i].getId() + "", myExpertListses[i]);
     %>
            requestArray[<%=i%>] =new requestObject("<%=myExpertListses[i].getId()%>","<%=myExpertListses[i].getName()%>");
     <%
                }
            }
        }
    %>



    var kolObject = "";
    if (null != <%=kolObjects%> && "" != '<%=kolObjects%>') {
        kolObject = '<%=kolObjects%>';
    }
    function doExpertSearch() {
        var thisform = document.interactionSearch;
        thisform.action = "<%=CONTEXTPATH%>/searchKol.htm?action=<%=ActionKeys.EXPERT_SEARCH_INTERACTION%>&searchText=" + thisform.searchText.value + "&kolObject=" + kolObject;
        thisform.submit();
    }

    function addKol() {
        var thisform = document.interactionSearch;
        var arrayIds = new Array;
        arrayIds = thisform.kolIds;

        if (arrayIds != null && arrayIds.length > 0) {
            for (var i = 0; i < arrayIds.length; i++) {
                if (arrayIds[i].checked) {
                    if (kolObject.length > 0) {
                        if (kolObject.indexOf(arrayIds[i].value) == -1) {
                            kolObject += "," + arrayIds[i].value;
                        }
                    } else {
                        kolObject = arrayIds[i].value;
                    }
                }
            }             
        }
    }

    function closeKols() {
        var parent = window.opener;
        parent.populateKols(kolObject,requestArray);
        window.close();
    }

</script>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0">
<form name="interactionSearch" method="post" AUTOCOMPLETE="OFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">

<td>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">

<tr>
<td align="left" valign="top">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
<td width="10" class="back-blue-02-light">&nbsp;</td>
<td class="back-blue-02-light">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light">
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
    <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
</tr>
<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="20">&nbsp;</td>
                <td width="30"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14"></td>
                <td class="text-white-bold">Search <%=DBUtil.getInstance().doctor%></td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                     height="1"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white"></td>
</tr>
<tr>
    <td align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <tr>
                <td width="10" height="20" valign="top">&nbsp;</td>
                <td width="190" valign="top"><input name="searchText" type="text" class="field-blue-01-180x20"
                                                    maxlength="50"></td>
                <td valign="top"><input name="Submit332" type="button" class="button-01" value="        Search        "
                                        onClick="doExpertSearch()"></td>
            </tr>

        </table>
    </td>
</tr>

<tr>
    <td height="10" align="left" valign="top" class="back-white"></td>
</tr>

<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>

<tr>
    <td height="20" align="left" valign="top" class="back_horz_head">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
                <td width="10" height="20">&nbsp;</td>
                <td width="20">&nbsp;</td>
                <td width="30"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14"></td>
                <td class="text-white-bold">Search <%=DBUtil.getInstance().doctor%> Results</td>
            </tr>
        </table>
    </td>
</tr>

<tr>
    <td height="10" align="left" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
                <td width="1%" height="20" valign="top">&nbsp;</td>
                <td width="3%" valign="middle" class="text-blue-01-bold">&nbsp;</td>
                <td width="4%" valign="middle" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif"
                                                                              width="14" height="14"></td>
                <td width="35%" valign="middle" class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%> Name</td>
                <td width="30%" valign="middle" class="text-blue-01-bold">Specialty</td>
                <td width="24%" valign="middle" class="text-blue-01-bold">Location</td>
            </tr>
            <tr>
                <td colspan="7" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1"
                                                                 height="1"></td>
            </tr>
        </table>
        <div style="height:140px; overflow:auto;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <%
                    if (null != myExpertListses && myExpertListses.length > 0) {
                        MyExpertList list = null;
                        for (int i = 0; i < myExpertListses.length; i++) {
                            list = myExpertListses[i];

                %>

                <tr>
                    <td width="1%" height="20" valign="top"><input type="checkbox" name="kolIds"
                                                                   value="<%=list.getId()%>"/></td>
                    <td width="3%" valign="middle" class="text-blue-01">&nbsp;</td>
                    <td width="4%" valign="middle" class="text-blue-01"><img
                            src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14"></td>
                    <td width="35%" valign="middle"
                        class="text-blue-01"><%=list.getName() != null ? list.getName() : ""%></td>
                    <td width="30%" valign="middle"
                        class="text-blue-01"><%=list.getSpeciality() != null ? list.getSpeciality() : ""%></td>
                    <td width="24%" valign="middle"
                        class="text-blue-01"><%=list.getLocation() != null ? list.getLocation() : ""%></td>
                </tr>

                <%
                        }
                    }
                %>
            </table>
        </div></td>
</tr>
<%--<tr>
    <td align="left" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1">
    </td>
</tr>--%>
<tr>
    <td height="10" align="left" class="back-white"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
</tr>

<tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

            <tr>
                <td width="10" height="20">&nbsp;</td>
                <td width="175" class="text-blue-01"><input name="Submit33" type="button" class="button-01"
                                                value="       Add <%=DBUtil.getInstance().doctor%>       " onClick="addKol()"></td>
                <td width="1%" height="20">&nbsp;</td>
                <td class="text-blue-01"><input name="Submit33" type="button" class="button-01"
                                                value="  Close  " onClick="closeKols()"></td>
                <td width="5%" height="20">&nbsp;</td>
                <td width="5%" height="20">&nbsp;</td>
            </tr>

        </table>
    </td>
</tr>
<tr>
    <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10"
                                                                      height="10"></td>
</tr>
<tr>
    <td height="10" align="left" valign="top"></td>
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
<script type="text/javascript">
    // alert("object -- "+kolObject)
</script>
</body>
</html>
