<%@ page language="java"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type"
  content="text/html; charset=windows-1252">
<link href="css/openq.css" type="text/css" rel="stylesheet">
<script language="javascript">
 function AlertMain()
 {document.location.href="alert.htm?action=alertsStatus";}
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="385">
  <tbody>
    <form name="alert" method="post" action="addalert.htm">
    <tr style="color:#4C7398">
      <td class="myexperttext1" height="1" valign="top">
      <b>Add Alert Wizard&nbsp; -</b><font size="2">Select
      the users and groups that should get the alert message</font>
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
            <table border="0" cellpadding="0" cellspacing="0" width="1156"
              height="1">
              <tr>
                <td class="text-blue-01" width="380" height="26" valign="top">
               <b>Step 5.</b>&nbsp;&nbsp;&nbsp;</b>Select User Groups <br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                (Use CTRL to select Multiple Groups):<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </p>
                <!--
                <p><b>Step 6.&nbsp; </b>Select Deliver Mechanism : <input
                  type="checkbox" name="UI" value="ON"> UI&nbsp; <input
                  type="checkbox" name="EM" value="ON"> Email</p>
                -->
                <p><br />
                <br />
                <br />
                <br />
                <b><br>
				<br>
				</b>&nbsp;</p>
                <p>
                <input type="hidden" name="action" value="alertsSave" />
                <input name="finish" class="button-01" value="" style="border:0 none;background : url('images/buttons/finish.gif');width:68; height:22"  type="submit"></a>&nbsp;
                <input name="edit3" class="button-01"  style="border:0 none;background : url('images/buttons/cancel.gif');width:74; height:22;" value="" onclick="javascript:AlertMain();" type="button"></p>
               </td>
                <td class="text-blue-01" width="750" height="26" valign="top">

                <select name="groups" multiple class="field-blue-13-235x80" size="8">
                  <%
                    Map groupMap = (Map) session.getAttribute(Constants.GROUPS);

                    for (Iterator iter = groupMap.keySet().iterator(); iter.hasNext();) {
                      String value = (String) iter.next();
                      String name = (String) groupMap.get(value);
                  %>
                  <option value="<%=value %>"><%=name%></option>
                  <%
                    }
                  %>
                </select>
                </td>
              </tr>
            </table>
            <p>&nbsp;
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
