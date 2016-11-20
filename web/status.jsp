<jsp:useBean id="task" scope="session"  class="com.openq.pbar.TaskBean"/>
<HTML>
<HEAD>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
    <TITLE>JSP Progress Bar</TITLE>
    <% if (task.isRunning()) { %>
        <SCRIPT LANGUAGE="JavaScript">
            setTimeout("location='status.jsp'", 300);
        </SCRIPT>
    <% } %>
</HEAD>
<BODY>
    <H2 ALIGN="CENTER">        
        <% int percent = task.getPercent();		%>      
    </H2>
    <TABLE WIDTH="40%" ALIGN="CENTER" BORDER=0 CELLPADDING=0 CELLSPACING=0 >
        <TR>
            <% for (int i = 1; i <= percent; i += 2) { %>
                <TD WIDTH="10%" class=back_horz_head>
				</TD>
            <% } %>
            <% for (int i = 100; i >= percent; i -= 5) { %>
                <TD WIDTH="10%">&nbsp;</TD>
            <% } %>
        </TR>
		<TR>
		  <td  ALIGN="CENTER" width="100%" colspan="50" class="text-blue-01-bold">&nbsp; </td>
        </tr> 
		<TR>
		  <td  ALIGN="CENTER" width="100%" colspan="50" class="text-blue-01-bold">&nbsp; </td>
        </tr> 
		<TR>
		  <td  ALIGN="CENTER" width="100%" colspan="50" class="text-blue-01-bold"> &nbsp;</td>
        </tr> 
		<TR>
		  <td  ALIGN="CENTER" width="100%" colspan="50" class="text-blue-01-bold"> Search in progress </td>
        </tr> 
    </TABLE>
</BODY>
</HTML>
