<%
response.setContentType("text/xml");
String xmlString = (String)(request.getSession(true)).getAttribute("xmlString");
%>
<%= xmlString.toString() %>
