<html>
<head>
	<link href="css/openq.css" rel="stylesheet" type="text/css">
</head>
<body class="">
	<table width="100%"  border="0">
	  <tr align="left">
	    <td class="text-blue-01-red"> 
	    <%= ((String)request.getSession().getAttribute("errorMsg")!= null && 
                !("".equalsIgnoreCase((String)request.getSession().getAttribute("errorMsg"))) && 
                !("null".equalsIgnoreCase((String)request.getSession().getAttribute("errorMsg"))))?" Error: New Privileges cannot be saved. "+(String)request.getSession().getAttribute("errorMsg"):"" 
                %> 
        </td>
	  </tr>
	</table>
<% request.getSession().removeAttribute("errorMsg"); %>
</body>
</html>