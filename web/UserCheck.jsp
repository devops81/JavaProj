<%
	if (request.getSession().getAttribute("currentUser") == null){
%>
	<script language="javascript">
	window.close();
	opener.location.href="sessionexpired.jsp";
	</script>
<% 	} 	%>