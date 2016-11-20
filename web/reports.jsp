<%@ page import="java.util.*"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ page import="java.io.InputStream"%>
<!-- saved from url=(0022)http://internet.e-mail -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Untitled Document</title>
</head>
<%@ include file="header.jsp" %>
<body>
<%
        java.util.Properties prop1 = DBUtil.getInstance().resourceProp;
%>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light"><tr><td width="20"></td><td valign="top">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
            <td width="10" rowspan="7" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
            <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="middle">
                    <td width="10" height="20">&nbsp;</td>
                    <td class="text-white-bold">Resources</td>
                </tr>
            </table></td>
        </tr>
        <tr>
            <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
        <tr>
            <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
            <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <% for ( int i=0; i< prop1.size()/3; i++)
                {
                    int j = i + 1;
                    String key1 =   "header-"+j;
                    String key2 =   "header-desc-"+j;
                    String key3 =   "header-link-"+j;
                    String header = prop1.getProperty(key1);
                    String headerDesk = prop1.getProperty(key2);
                    String headerLink = prop1.getProperty(key3);
                 %>

                <tr>
                    <td width="15" height="20">&nbsp;</td>
                    <td colspan="11" class="text-blue-01-bold"><%= header %></td>
                </tr>
                <tr>
                    <td height="20">&nbsp;</td>
                    <td colspan="11" class="text-blue-01"><%= headerDesk %><br />
                        <a href="#" onClick="window.open(<%= headerLink %>,'prop1','width=690,height=500,top=100,left=100,resizable=yes,toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes')" class="text-blue-01-link"><%= headerLink%></a></td>
                </tr>
                <tr>
                    <td height="20">&nbsp;</td>
                    <td colspan="11" class="text-blue-01">&nbsp;</td>
                </tr>

                <% }
                %>


            </table>
            </td>
        </tr>
        <tr>
            <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
            <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
            <td width="10" rowspan="3" align="left" valign="top">&nbsp;</td>
        </tr>
    </table>
</td></tr></table>
</body>
<%@ include file="footer.jsp" %>
</html>