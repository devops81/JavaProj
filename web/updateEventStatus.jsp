<html>
<head>
  <title>openQ event response</title>
  <script type="text/javascript">
    function reloadParent(){
      window.opener.location.reload();
      window.close();
    }
  </script>
</head>
<body text=\"#2ABFFF\">
	<font size="2" face="Verdana, Arial, Helvetica, sans-serif">
		Thank you for your response.
	</font>
  <%if(request.getParameter("showClose")!=null){ %>
  <form>
    <input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:23px;" class="button-01" value="" onClick="javascript:reloadParent()" />
  </form>
  <% } %>
</body>
</html>