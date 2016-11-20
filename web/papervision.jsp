<%@ page language="java" %>
<script type="text/javascript" src="flash/swfobject.js"></script>
<style type="text/css">
#flashcontent {
	height: 484px;
	width: 1258px;
	border: 1px solid #d9e4ea;
	position: absolute;
	top: 186px;
	left: 2px;
}
/* end hide */
html
{
  overflow: hidden;
  overflow-y: scroll;
 }
body {
  margin: 0;
  padding: 0;
}

</style>
<%
	session.setAttribute("CURRENT_LINK", "ADVANCED_SEARCH");
%>
<%@ include file="header.jsp" %>
	<div id="flashcontent">
		<strong>You need to upgrade your Flash Player</strong>
	</div>
	<script type="text/javascript">
		// <![CDATA[

		var so = new SWFObject("flash/openQ3DSearch.swf", "main", "1258", "484", "9", "#ffffff", true);
		so.write("flashcontent");

		// ]]>
	</script>
</body>
</html>
