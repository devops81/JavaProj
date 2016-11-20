<%@ page language="java" %>
<%@ include file = "imports.jsp" %>
<%@ page import="com.amgen.orx.types.EoList"%>

<%
	EoList [] orxResult = (EoList[])request.getSession().getAttribute("orxResult");
%>

<script language="javascript">
	function setParentTextBox(ORXCustomer){
			window.opener.addORXName(ORXCustomer);
	}
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ORX Search</title>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>
<form name="searchORX" method="post">
<input type="hidden" name="parentFormName" value=""/>
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="10" class="back-blue-02-light">&nbsp;</td>
    <td class="back-blue-02-light"><div>
      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-blue-02-light">
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
          <td width="10" rowspan="12" align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
              <td width="15" height="20">&nbsp;</td>
              <td width="25">&nbsp;</td>
              <td width="40"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="text-white-bold">Search ORX</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="1" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="190" valign="top"><input name="searchtext" type="text" class="field-blue-01-180x20" maxlength="50"/></td>
              <td valign="top"><input name="Submit332" type="submit" class="button-01" value="        Search        "/></td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="20" align="left" valign="top" class="back_horz_head"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle">
              <td width="15" height="20">&nbsp;</td>
              <td width="25">&nbsp;</td>
              <td width="45"><img src="<%=COMMONIMAGES%>/icon_search.gif" width="14" height="14" /></td>
              <td class="text-white-bold">Search ORX Results</td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="back-grey-02-light">
            <tr>
              <td width="15" height="20" valign="top">&nbsp;</td>
              <td width="25" valign="middle" class="text-blue-01-bold">&nbsp;</td>
              <td width="45" valign="middle" class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
              <td valign="middle" class="text-blue-01-bold" width="100">Name</td>
              <td valign="middle" class="text-blue-01-bold" width="100">Phone</td>
              <td valign="middle" class="text-blue-01-bold" width="100">Location</td>
              <td valign="middle" class="text-blue-01-bold" width="100">&nbsp;</td>
              
            </tr>
            <tr>
              <td colspan="8" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1" /></td>
            </tr>
          </table>
                <div style="height:200px; overflow:auto;">
                  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  
                   <% if(orxResult != null){ for(int i=0;i<orxResult.length && i <50;i++){ %>
                  
                     <tr class='<%=(i%2==0)?"back-white-02-light":"back-white-02-light"%>'>
                      <td width="15" height="20" valign="top">&nbsp;</td>
                      <td width="25" valign="middle"><input name="radiobutton" type="radio" value="radiobutton" onclick="javascript:setParentTextBox('<%=((orxResult[i].getCustomer()!= null 
																				 && orxResult[i].getCustomer().getBusinessInfo() != null 
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson()!= null
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier() != null
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier().getFullName() != null) 
																	 			 ?
																				 orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier().getFullName() : "")%>')"/></td>
                      <td width="45" valign="middle" class="text-blue-01"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
                      <td valign="middle" class="text-blue-01" width="100"><%=((orxResult[i].getCustomer()!= null 
																				 && orxResult[i].getCustomer().getBusinessInfo() != null 
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson()!= null
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier() != null
																				 && orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier().getFullName() != null) 
																	 			 ?
																				 orxResult[i].getCustomer().getBusinessInfo().getPerson().getIdentifier().getFullName() : "N.A")%></td>
					  <td valign="middle" class="text-blue-01" width="100"><%=((orxResult[i].getCustomer()!=null 
																	&& orxResult[i].getCustomer().getBusinessInfo() !=null
																	&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms()!=null
																	&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getTelecomAddress()!=null
																	&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom() != null
																	&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom().getFullNumber() != null)
																 	?
																 	orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom().getFullNumber(): "N.A")%></td>
                      <td valign="middle" class="text-blue-01" width="100"><%=((orxResult[i].getCustomer() != null && orxResult[i].getCustomer().getBusinessInfo()!=null
																			&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms() != null 
																			&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getPostalAddress() != null
																			&& orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getPostalAddress().getStreetAddress()!= null)
																			?
																			orxResult[i].getCustomer().getBusinessInfo().getContactMechanisms().getPostalAddress().getStreetAddress()[0].toString():"N.A")%></td>
                      <td valign="middle" class="text-blue-01" width="100">&nbsp;</td>
                    </tr>
                  
                   <% }} %>
                  
                  </table>
                </div></td>
        </tr>
        <tr>
          <td align="left" class="back-blue-03-medium"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="1" /></td>
        </tr>
        <tr>
          <td height="10" align="left" class="back-white"></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20"><input name="Submit33" type="button" class="button-01" value="  Close  " onclick="javascript:window.close()" /></td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>
            
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10" /></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"></td>
        </tr>
      </table>
    </div></td>
  </tr>
</table>
</form>
</body>
</html>