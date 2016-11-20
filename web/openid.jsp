<%@ include file="header.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>

<html>
<script type="text/javascript"">
 
  function submit(){
    document.paramsForm.submit();
  }
  
 </script>
<body onLoad="submit()">
<form name="paramsForm" method="POST" target="openIDFrame" 	action='<c:out escapeXml="true" value="${openidUrl}/login.htm"/>'>
	<input type="hidden" name="userID" value=<c:out escapeXml="true" value="${userID}"/> />
	<input type="hidden" name="token" value=<c:out escapeXml="true" value="${token}"/> />
	<input type="hidden" name="userName" value=<c:out escapeXml="true" value="${userName}"/> />
	<input type="hidden" name="ts" value=<c:out escapeXml="true" value="${timestamp}"/> />
</form>
<div style="overflow:hidden;">
	<iframe name="openIDFrame" id="openIDFrame" height="1050" width="100%" frameborder="0" scrolling="no" 
	    style="background-color: #fcfcf8;">
	</iframe>
</div>
<%@ include file="footer.jsp"%>
</body>
</html>