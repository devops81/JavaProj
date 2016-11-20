<%@ page language="java"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type"
  content="text/html; charset=windows-1252">
<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript" type="text/javascript">
 function AlertMain(){
 document.location.href="alert.htm?action=alertsStatus";
 }
 
 
 function check(){
 var val = document.getElementById("alert").alert_name.value;
 var attr = document.getElementById("alert").attributes.selectedIndex;
 if(val == "")
 	{
 	alert("Alert name not specified!");
 	document.getElementById("alert").alert_name.focus();
 	return false;
 	}
 if(attr == -1){
 	alert("Alert Attributes not specified!");
 	document.getElementById("alert").attributes.focus();
 	return false;
 	}
 
 document.getElementById("alert").submit();
 //document.getElementById("alert").action="addalert.htm";
 
 }
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%"
  height="385">
  <tbody>
    <form name="alert" method="post" action="addalert.htm">
    <tr style="color:#4C7398">
      <td class="myexperttext1" align="left" height="380" valign="top">
      &nbsp; <b>Add Alert Wizard&nbsp; - </b><font size="2">Please
      select the attributes on which alerts should be defined.</font>
      <table border="0" cellpadding="0" cellspacing="0" width="1156"
        height="1">
        <tbody>
          <tr>
            <td class="text-blue-01" colspan="4" height="1" width="1156">
            <hr>
            </td>
          </tr>
          <tr>
      

            <td class="text-blue-01" width="1130" height="26" valign="top">
            &nbsp;
            <p><b>Step 1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b> Select Alert
            Name : <input type="text" name="alert_name" size="20" class="field-blue-01-180x20"></p>
            <p><b>Step 2.&nbsp;&nbsp;&nbsp;&nbsp; </b> Select Attribute/s
            you like to define alerts on <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            (Use CTRL to select Multiple Attributes):</p>
            <p>
            <select name="attributes" multiple class="field-blue-13-500x100"
              size="5">
              <%
                Map attrMap = (Map) session.getAttribute(Constants.ATTRIBUTE_MAP);

                for (Iterator iter = attrMap.keySet().iterator(); iter.hasNext();) {
                  String value = (String) iter.next();
                  String name = (String) attrMap.get(value);
              %>
              <option value="<%=value %>"><%=name%></option>
              <%
                }
              %>
            </select></p>
            <p>            <input type="hidden" name="action" value="alertsStep2" />
             <input name="nextOne" class="button-01" value="" type="button" onclick="check();" style="border:0 none;background : url('images/buttons/next.gif');width:64; height:22;"><a></a>
            <input name="edit3" class="button-01"  style="border:0 none;background : url('images/buttons/cancel.gif');width:74; height:22;" value="" onclick="javascript:AlertMain();" type="button"><a></a></p>
            </td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
    </form>
  </tbody>
</table>
</body>
</html>