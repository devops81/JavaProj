<%@ page language="java"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.alerts.data.Alert"%>
<%@ page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type"
  content="text/html; charset=windows-1252">
<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript" type="text/javascript">
 function AlertMain()
 {document.location.href="alert.htm?action=alertsStatus";}
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%"
  height="385">
  <tbody>
    <form name="alert" method="post" action="editalert.htm">
    <tr>
      <td class="myexperttext1" align="left" height="380" valign="top">Edit Alert Wizard&nbsp; - Please update the attributes on which alerts should be defined.
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
            <p><b>Step 1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b> Select Alert Name :
            <%
              Alert alert = (Alert) session.getAttribute(Constants.ALERT_OBJ);
            %>
            <input type="text" name="alert_name" size="20" value="<%=alert.getName() %>" class="field-blue-01-180x20"></p>
            <p><b>Step 2.&nbsp;&nbsp;&nbsp;&nbsp; </b> Select Attribute/s you like to define alerts on <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            (Use CTRL to select Multiple Attributes):</p>
            <p>
            <select name="attributes" multiple class="field-blue-13-500x100"
              size="5">
              <%
                Map attrMap = (Map) session.getAttribute(Constants.ATTRIBUTE_MAP);
                Map savedAttrMap = (Map) session.getAttribute(Constants.SAVED_ATTRIBUTE_MAP);

                for (Iterator iter = attrMap.keySet().iterator(); iter.hasNext();) {
                  String value = (String) iter.next();
                  String name = (String) attrMap.get(value);
                  String selected = savedAttrMap.containsKey(value) ? "selected" : "";
              %>
              <option <%=selected %> value="<%=value %>"><%=name%></option>
              <%
                }
              %>
            </select></p>
            <p>
            <input type="hidden" name="action" value="alertsStep2" />
             <input name="nextOne" class="button-01" value="" type="submit" style="border:0 none;background : url('images/buttons/next.gif');width:64; height:22;"><a></a>
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