<%@ page language="java"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.alerts.data.AlertDetail"%>
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
    <form name="alert" method="post" action="editalert.htm">
    <tr>
      <td class="myexperttext1" align="left" height="1" valign="top">
      <b>Edit Alert Wizard&nbsp; - </b> <font size="2">Update
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

            <td class="text-blue-01" width="4" height="26" valign="top">
            <table border="0" cellpadding="0" cellspacing="0" height="100%"
              width="100%">
              <tbody>
                <tr>

                </tr>
              </tbody>
            </table>

            </td>
           
            <td class="text-blue-01" width="1130" height="26" valign="top">
            &nbsp;
            <p><b>&nbsp;Step 3.&nbsp;&nbsp;&nbsp;&nbsp;</b>Select the type of
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
            <table border="0" width="100%"  class="text-blue-01">
             
              <%
                Map attrMap = (Map) session.getAttribute(Constants.ATTRIBUTE_MAP);
                Map savedAttrMap = (Map) session.getAttribute(Constants.SAVED_ATTRIBUTE_MAP);
                String[] attrs = (String[]) session
                    .getAttribute(Constants.ATTRIBUTE_LIST);

                if ((attrs != null) && (attrs.length > 0)) {
                  for (int i = 0; i < attrs.length; i++) {
                    int selected = savedAttrMap.containsKey(attrs[i]) ?
                                   ((AlertDetail)savedAttrMap.get(attrs[i])).getOperator() :
                                   0;
              %>
              <tr>
                <td align="left" width="49"><%=i + 1%></td>
                <td align="left"><%=attrMap.get(attrs[i])%></td>
                <td align="left" width="120"><select name="<%=attrs[i] %>" class="field-blue-01-120x20">
                  <option <%=(selected == 0)?"selected":"" %> value="0">OnCreate</option>
                  <option <%=(selected == 1)?"selected":"" %> value="1">OnUpdate</option>
                  <option <%=(selected == 2)?"selected":"" %> value="2">OnDelete</option>
                </select></td>
              </tr>
              <%
                  }
                } else {
              %>
              <tr>
                <td align="left" width="49"></td>
                <td align="left">No Attributes Selected</td>
                <td align="left" width="120"></td>
              </tr>
              <%
                }
              %>
            </table>
          </div>
            <p>
            <input type="hidden" name="action" value="alertsStep3" /> 
             <input name="nextOne" class="button-01" value="" type="submit" style="border:0 none;background : url('images/buttons/next.gif');width:64; height:22;"></a>&nbsp;
            <input name="edit3" class="button-01"  style="border:0 none;background : url('images/buttons/cancel.gif');width:74; height:22" value="" onclick="javascript:AlertMain();" type="button"></a></p>
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