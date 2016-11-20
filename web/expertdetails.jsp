
<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.expert.MyExpertList" %>
<%@ page import="com.openq.kol.DBUtil"%>

<html>
<HEAD>
    <TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>

    <table>
        <tr>
            <td>
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
                <TBODY>
                <c: items="${myexperts}" var="myexpert">
					<TR valign=center align=left>
						<TD width="25" height=20>&nbsp;</TD>
						<TD width="25"><IMG height=14
							src="images/icon_my_expert.gif" width=14></TD>
						<TD class="text-blue-01-bold"><%=DBUtil.getInstance().doctor%> Details</TD>
						<td>&nbsp;</td>
					</TR>
					
					<TR valign=center align=left>
						<TD width="25" height=20>&nbsp;</TD>
					    <TD class=text-blue-01-link width=175>
                    	<c:out escapeXml="false" value="${myexpert.name}"/> 
                    </TD>
						<td colspan="2">&nbsp;</td>
					</TR>
					
					<TR valign=center align=left>
						<TD width="25" height=20>&nbsp;</TD>
					    <TD class=text-blue-01-link width=175>
                    	<c:out escapeXml="false" value="${myexpert.location}"/> 
                    </TD>
						<td colspan="2">&nbsp;</td>
					</TR>
					
					<TR valign=center align=left>
						<TD width="25" height=20>&nbsp;</TD>
					    <TD class=text-blue-01-link width=175>
                    	<c:out escapeXml="false" value="${myexpert.speciality}"/> 
                    </TD>
						<td colspan="2">&nbsp;</td>
					</TR>
					
					<TR valign=center align=left>
						<TD width="25" height=20>&nbsp;</TD>
					    <TD class=text-blue-01-link width=175>
                    	<c:out escapeXml="false" value="${myexpert.location}"/> 
                    </TD>
						<td colspan="2">&nbsp;</td>
					</TR>
					
					</c:>
			 
			  </TBODY>
			</TABLE>					
            </td>
		</tr>
	</table>
</html>