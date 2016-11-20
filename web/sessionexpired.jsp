<html>
	<head>
	<!-- The current values will be substituted in the output file by an ant task during build -->
    <meta svnHighestRevisionNumber=1>
    <meta svnLastCommitedRevisionNumber=1>
    <meta buildVersionNumber=1>
    <meta buildDate="mm/dd/yyyy hh:mm:ss aa">
	<title>openQ 3.0 - openQ Technologies Inc.</title>
	<% String accessDenied = request.getParameter("accessDenied");%>
	<script language="javascript">
	  function closeAndOpen(){
		  parent.window.opener='x';
		  parent.window.close();
		  var win = window.open('errorpage.jsp?accessDenied=<%=accessDenied != null ? accessDenied : "false"%>','ErrorPage','width=400,height=400,top=50,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
      }	
</script>
<body onLoad="closeAndOpen()"></body>
</html>