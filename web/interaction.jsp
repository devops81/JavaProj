<%@ page import="com.openq.kol.DBUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>
	<h1><%=DBUtil.getInstance().doctor%> Interactions</h1>
		<form name="interaction">
			<table>
				<tr>
					<td>Interaction Type</td>
					<td>Date</td>
				</tr>
				<tr>
					<td>In Person<input name="InPerson" type="text">
					<td>Other<input name="Others" type="radio">
				</tr>
				<tr>
					<td collspan="2">Attendee</td>
				</tr>
				<tr>
					<TD><SELECT name=Tool> <OPTION selected>Slide Presentation</OPTION> 
	        			<OPTION>Publication</OPTION>
	        			<OPTION>Literature</OPTION>
	        			</SELECT></TD>
					<TD><SELECT name=Rating>
						<OPTION selected>Positive</OPTION>
						<OPTION>Neutral</OPTION>
						<OPTION>Negative</OPTION>
						</SELECT></TD>
				</tr>
				<tr>
					<TD><INPUT type=submit value=Save name=SaveInteraction></TD>
				</tr>
			</table>
			Interaction page: <c:out escapeXml="false" value="${Status}"/>
		</form>
</html>