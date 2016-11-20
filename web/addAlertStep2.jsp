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
<table border="0" cellpadding="0" cellspacing="0" width="100%"
  height="385">
  <tbody>
    <form name="alert" method="post" action="addalert.htm">
    <tr style="color:#4C7398">
      <td class="myexperttext1" align="left" height="1" valign="top">
      <b>Add Alert Wizard&nbsp; - </b> <font size="2">Define
      the criteria on which alerts should be triggered</font>
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
            <p><b>Step 3.&nbsp;&nbsp;&nbsp;&nbsp;</b>Select the type of
            alert for each attribute</p>
            &nbsp;&nbsp;
              <div style="width:800px; height:auto;">

              <table border="0" width="100%"  class="text-blue-01">
              <tr class="back-grey-02-light">
                <td align="left" width="49"><b>SL.No</b></td>
                <td align="left"><b>Attributes</b></td>
                <td align="left" width="134"><b>Alert Criteria</b></td>
              </tr>
              </table></div>
           <div style="width:800px; height: 85px; overflow-y: scroll;">
           <table border="0" width="100%" cellpadding="2" class="text-blue-01">
                          <%
                Map attrMap = (Map) session.getAttribute(Constants.ATTRIBUTE_MAP);
                String[] attrs = (String[]) session
                    .getAttribute(Constants.ATTRIBUTE_LIST);

                if ((attrs != null) && (attrs.length > 0)) {
                  for (int i = 0; i < attrs.length; i++) {
              %>
              <tr>
                <td align="left" width="51"><%=i + 1%></td>
                <td align="left" width="600"><%=attrMap.get(attrs[i])%></td>
                <td align="left" width="130"><select name="<%=attrs[i] %>" class="field-blue-01-120x20">
                  <option value="0">OnCreate</option>
                  <option value="1">OnUpdate</option>
                  <option value="2">OnDelete</option>
                </select></td>
              </tr>
              <%
                  }
                } else {
              %>
              <tr>
                <td align="left" width="51"></td>
                <td align="left" width="600">No Attributes Selected</td>
                <td align="left" width="130"></td>
              </tr>
              <%
                }
              %>
            </table>
            </div>
           
            <p>
            <input type="hidden" name="action" value="alertsStep3" /> 
             <input name="nextOne" class="button-01" value="" type="submit" style="border:0 none;background : url('images/buttons/next.gif');width:64; height:22;"></a>&nbsp;
            <input name="edit3" class="button-01"  style="border:0 none;background : url('images/buttons/cancel.gif');width:74; height:22;" value="" onclick="javascript:AlertMain();" type="button"></a></p>
            <p>&nbsp;
            </td>
          </tr>
        </tbody>
      </table>
      </td>
    </tr>
  </tbody>
</table>
</body>
</html>