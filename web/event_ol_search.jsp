<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@ include file = "imports.jsp" %>
<%@ include file = "UserCheck.jsp" %>

<!-- saved from url=(0022)http://internet.e-mail -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="js/utilityFunctions.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><%=DBUtil.getInstance().doctor%> Search</title>
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
<script src="<%=COMMONJS%>/validation.js"></script>
<script language="javascript">
    function searchOls() {
        var thisform = document.searchOL;
        thisform.lastnamesearch.value = checkAndReplaceApostrophe(thisform.lastnamesearch.value);
        thisform.action = "<%=CONTEXTPATH%>/event_ol_search.htm?action=olSearch";
        openProgressBar();
        thisform.submit();
    }

    function populateParent() {
        var thisform = document.searchOL;
        var arrayOfCheckedAttendee = new Array();

        if (thisform.checkedAttendee != null) {
            for (var i = 0; i < thisform.checkedAttendee.length; i++) {
                if (thisform.checkedAttendee[i].checked == true) {
                    arrayOfCheckedAttendee.push(thisform.checkedAttendee[i].value);
                }
            }
            if (thisform.checkedAttendee.length == null) {
                arrayOfCheckedAttendee.push(thisform.checkedAttendee.value);
            }
        }
        window.opener.addOLs(arrayOfCheckedAttendee);
    }
</script>
<%
    User [] myExperts = (User[]) request.getSession().getAttribute("myExperts");
	OptionLookup [] state = (OptionLookup []) request.getSession().getAttribute("state");
	OptionLookup [] therapeuticArea = (OptionLookup[]) request.getSession().getAttribute("therapeuticArea");
	OptionLookup [] attendeeType = (OptionLookup[]) request.getSession().getAttribute("attendeeType");
    String searchText = null;
    if(session.getAttribute("SEARCH_TEXT") != null) {
        searchText = (String) session.getAttribute("SEARCH_TEXT");
    }
%>
<body onUnload="javascript:checkForProgressBar()">
<form name="searchOL" method="post"  onsubmit="javascript:openProgressBar();searchOls();">
<div class="contentmiddle">
        <div class="producttext">
	    <div class="myexpertlist">
	      <table width="100%">
	        <tr style="color:#4C7398">
	        <td width="2%"><img src="images/searchpic.gif"/>
	        </td>
	        <td width="50%" align="left">
	          <div class="myexperttext">Search <%=DBUtil.getInstance().doctor%></div>
	        </td>
	        
	        </tr>
	      </table>
	    </div>
	    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
	        <tr>
	          <td width="10" height="20">&nbsp;</td>
	          <td width="190" valign="top">&nbsp;</td>
	          <td>&nbsp;</td>
            <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="190"><input name="lastnamesearch" type="text" class="field-blue-01-180x20" maxlength="50" value="<%=searchText != null?searchText:""%>"/></td>
              <td><input name="Submit332" type="button" style="border:0;background:url(images/buttons/search_expert.gif);width=90px;height=24px" onclick="searchOls()" /></td>
            </tr>
         </table>
         </div>
         <br>
         
         <div class="producttext" style="height:200px"  style="overflow:auto">
          
		    <div class="myexpertplan" height:200px>
		      <table width="100%">
		        <tr style="color:#4C7398">
		        <td align="left">
		          <div class="myexperttext">Search <%=DBUtil.getInstance().doctor%> Results</div>
		        </td>
		        </tr>
		      </table>
		    </div>
		    <table width="100%" cellspacing="0">
		      <tr bgcolor="#f5f8f4">
			      <td width="5%" align="right">&nbsp;</td>
			      <td width="30%" class="expertPlanHeader">Name</td>
			      <td width="25%" class="expertPlanHeader">Speciality</td>
			      <td width="25%" class="expertPlanHeader">Location</td>
			      <td width="15%">&nbsp;</td>
		      </tr>
		      
            
             

                    <% if (myExperts != null) {
                        for (int i = 0; i < myExperts.length; i++) { %>
                        
                    <tr class='<%=(i%2==0)?"back-white-02-light":"back-grey-02-light"%>'>
                        
                        <td width="5%" valign="middle" class="text-blue-01"><input type="checkbox" name="checkedAttendee"
                                                                                   value="<%=(myExperts[i].getId() + ";" +myExperts[i].getLastName()+ ", " + myExperts[i].getFirstName())%>"/></td>
                        <td width="30%" valign="middle"  class="text-blue-01"><%=myExperts[i].getLastName()%>, <%=myExperts[i].getFirstName()%></td>
                        <td width="25%"  valign="middle" class="text-blue-01" ><%=myExperts[i].getSpeciality() != null?myExperts[i].getSpeciality():""%></td>
                        <td width="25%" valign="middle" class="text-blue-01"><%=myExperts[i].getLocation() != null?myExperts[i].getLocation():""%></td>
                        <td width="15%">&nbsp;</td>
                    </tr>
                    <%
                            }
                        }
                    %>
                
      </table>
    </div></td>
    <br>
    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="producttext">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td width="5">&nbsp;</td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20"><input name="Submit333" type="button" style="background: transparent url(images/buttons/add_expert.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 80px; height: 24px;" class="button-01" value="" onclick="javascript:populateParent()" /></td>
               <td width="5">&nbsp;</td>
              <td class="text-blue-01" width="20"><input name="Submit33" type="button" style="background: transparent url(images/buttons/close_window.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 115px; height: 24px;" class="button-01" value="" onclick="javascript:window.close()"  /></td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>
            
          </table></td>
  </tr>
</table>
</div>
</form>
</body>
<%
    session.removeAttribute("myExperts");
    session.removeAttribute("SEARCH_TEXT");
%>
</html>