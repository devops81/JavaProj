<%@ page import="com.openq.eav.metadata.*" %>
<%@ page import="com.openq.eav.data.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.openq.web.ActionKeys"%>
<%@ page import="com.openq.web.controllers.Constants"%>
<%@ page import="com.openq.authentication.UserDetails" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="com.openq.kol.DBUtil"%>
<%
String from = null;
if (null != session.getAttribute("FromHome")){
    from = (String)session.getAttribute("FromHome");
}

 long profile_id = (Long.parseLong((String)session.getAttribute("profile_id")));
 String currentKOLName = request.getParameter("currentKOLName") == null ? "" : request.getParameter("currentKOLName");

 String rootParentId = (String) request.getAttribute("ROOT_PARENT_ID");
 String userId = (String)((UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER)).getId();
%>
<% String pid=(String)session.getAttribute("ParID"); %>
<html>
<head>
    <link href="css/openq.css" rel="stylesheet" type="text/css">
</head>
    <script src="./js/cookieHelper.js"></script>
    <script language="javascript">

    var attrId = <c:out escapeXml="false" value="${selectedTab}"/>;
    var entityId = <c:out escapeXml="false" value="${entityId}"/>;
    var parentId = <c:out escapeXml="false" value="${parentId}"/>;
    var selectedTabName = '<c:out escapeXml="false" value="${selectedTabName}"/>';
    //var doctorName = '<%=currentKOLName%>';
    function setEntityIds(aId, eId, pId, stName) {
        attrId = aId;
        entityId = eId;
        parentId = pId;
        selectedTabName = stName;
    }

    function cancelEditOrSave() {
        //alert(1);
        window.frames['addEditTableRowFrame'].location.href = 'blank.html';
        document.getElementById("rowForAddEditTable").style.display = 'none';
        document.getElementById("dividerLineForAddEditTable").style.display = 'none';
        document.editDeleteForm.cancelEditSave.style.display = 'none';
        //document.editDeleteForm.editButton.value = 'Edit';
        document.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/edit.gif)';
        //window.frames['addEditTableRowFrame'].location.href = 'blank.html';
        //alert(2);
        // if table, show add and delete buttons
        if (window.frames['showBasicAttrs'].deleteTableRowForm._table) {
            document.editDeleteForm.deleteRow.style.display = 'block';
            document.editDeleteForm.addRow.style.display = 'block';
        }
        //alert(3);
        document.selfSubmitForm.target = "showBasicAttrs";
        document.selfSubmitForm.attributeId = attrId;
        document.selfSubmitForm.entityId = entityId;
        document.selfSubmitForm.parentId = parentId;
        document.selfSubmitForm.tabName = selectedTabName;
        //alert(document.selfSubmitForm.target);
        document.selfSubmitForm.submit();
    }

    function editValues() {

    	var selectedRow = -1;
        if (window.frames['showBasicAttrs'].editProfileAttributesForm) {
            // Save called on showBasicAttrs frame
            if (window.frames['showBasicAttrs'].checkRequiredFields()) {
                //document.editDeleteForm.editButton.value = 'Edit';
                document.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/edit.gif)';
                var flag="true";
                if(selectedTabName == 'Thought Leader Criteria')
                {
                    var yesCount = 0;
                    var temp = window.frames['showBasicAttrs'].editProfileAttributesForm.getElementsByTagName("select");
                    for(cnt=0;cnt<temp.length; cnt++)
                    {
                    	temp[cnt].disabled = false;
                        if(temp[cnt].options[temp[cnt].selectedIndex].value == 'Yes' || temp[cnt].options[temp[cnt].selectedIndex].value == 'YES')
                        {
                            yesCount = yesCount+1;
                        }
                    }
                    if(yesCount==0)
                    {
                        for(cnt=0;cnt<temp.length; cnt++)
                        {
                            if(temp[cnt].options[temp[cnt].selectedIndex].value == '<%=Constants.TL_TYPE_TL%>' )
                            {
                                flag=false;
                            }
                        }
                    }

                }
                if (flag == "true")
                {
                    window.frames['showBasicAttrs'].editProfileAttributesForm.submit();
                }
                else
                {
                	alert('A <%=Constants.TL_TYPE_TL%> must have one or more Selection Criteria.  Please set at least one of the Selection Criteria to Yes.');
                }
                document.editDeleteForm.cancelEditSave.style.display = 'none';
            }


            if(document.editDeleteForm.editButton.style.width=='73px')
            {

            document.editDeleteForm.editButton.style.width='60';

            }

        } else if (window.frames['addEditTableRowFrame'].editProfileAttributesForm) {
            if(document.editDeleteForm.editButton.style.width=='73px')
            {
                document.editDeleteForm.editButton.style.width='60';
            }
            // Save called on addEditTableRowFrame frame
            if (window.frames['addEditTableRowFrame'].checkRequiredFields()) {
                document.getElementById("rowForAddEditTable").style.display = 'none';
                document.editDeleteForm.cancelEditSave.style.display = 'none';
                document.getElementById("dividerLineForAddEditTable").style.display = 'none';
                //document.editDeleteForm.editButton.value = 'Edit';
                document.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/edit.gif)';
                window.frames['addEditTableRowFrame'].editProfileAttributesForm.target = 'showBasicAttrs';
                window.frames['addEditTableRowFrame'].location.href = 'blank.html';
                window.frames['addEditTableRowFrame'].editProfileAttributesForm.submit();
            }
        } else if(attrId == <%=Constants.SELECTION_CRITERIA_ATTRIBUTEID%> &&
        		window.frames['showBasicAttrs'].deleteTableRowForm.TLStatusAlreadySet.value == 'false'){
             var parameterString = '&attributeId='+attrId+"&kolid="+ <%=rootParentId%>+'&entityId='+
             entityId+'&entityAttr=-1&parentId='+parentId+'&tabName='+selectedTabName +
             '&currentKOLName=<%=currentKOLName%>&targetWindow=window.opener.frames["showBasicAttrs"].deleteTableRowForm';
             window.open('selectionCriteriaPopup.htm?' + parameterString, 'TLSelectionCriteria','width=700,height=600,top=100,left=100,resizable=1,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=1');
        } else {
            // we are on showBasicAttributes.jsp and Edit button was clicked
            var thisform = window.frames['showBasicAttrs'].deleteTableRowForm;
            // check if any table rows are selected
            if (thisform) {
                var isTable = thisform._table;
                if (isTable) {
                    var flag = false;
                    var count = 0;
                    for(var i=0;i<thisform.elements.length;i++) {
                        if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked) {
                            count = count + 1;
                            if (thisform.elements[i].checked)
                            {
                                selectedRow = thisform.elements[i].value;
                            }
                        }
                    }
                    if (count != 1) {
                        alert('Please select a single row to edit.');
                        return;
                    }
                }
            }
            document.editAttributeForm.attributeId.value = attrId;
            document.editAttributeForm.tabName.value = selectedTabName;
            if (selectedRow != -1) {
                document.editAttributeForm.entityId.value = -1;
            }
            else {
                document.editAttributeForm.entityId.value = entityId;
            }
            document.editAttributeForm.entityAttr.value = selectedRow;
            document.editAttributeForm.parentId.value = parentId;
            // load in a different frame if edit called on a table
            if (window.frames['showBasicAttrs'].deleteTableRowForm._table) {
                document.editAttributeForm.target = "addEditTableRowFrame";
                document.getElementById("rowForAddEditTable").style.display = 'block';
                document.getElementById("dividerLineForAddEditTable").style.display = 'block';
            } else {
                document.editAttributeForm.target = "showBasicAttrs";
            }
            //document.editDeleteForm.editButton.value = 'Save';
            document.editDeleteForm.editButton.style.backgroundImage = 'url(images/buttons/save.gif)';
            document.editDeleteForm.cancelEditSave.style.display = 'none';
            document.editDeleteForm.editButton.style.height='22'
            document.editDeleteForm.editButton.style.width='73'
            //document.editDeleteForm.
            document.editAttributeForm.submit();
        }
    resizeIFramesInnerProfile();
    }

    function addTableRow() {
        if (document.editAttributeForm) {
            document.editAttributeForm.attributeId.value = attrId;
            document.editAttributeForm.tabName.value = selectedTabName;
            document.editAttributeForm.parentId.value = parentId;
            document.editAttributeForm.entityId.value = -1;
            document.editAttributeForm.entityAttr.value = -1;
            document.editAttributeForm.target = "addEditTableRowFrame";
            document.getElementById("rowForAddEditTable").style.display = 'block';
            document.getElementById("dividerLineForAddEditTable").style.display = 'block';
            document.editDeleteForm.cancelEditSave.style.display = 'none';
            document.editAttributeForm.submit();
        }
    resizeIFramesInnerProfile();
    }

    function deleteTableRows() {
        var thisform = window.frames['showBasicAttrs'].deleteTableRowForm;
        if (thisform) {
            var flag = false;

            for(var i=0;i<thisform.elements.length;i++) {
                if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
                    flag = true;
                    if (thisform.elements[i].value == thisform.totalRowId.value)
                    {
                        alert("Cannot delete 'Total' row.");
                        return;
                    }

                    //break;
                }
            }

            if(flag) {
                if(confirm("Do you want to delete the selected rows?")) {
                    thisform.submit();
                }
            } else {
                alert("Please select at least one row to delete");
            }
        }
    }
  var globalSelectedIndex = 0;
    function changeStyle(selectedIndex, total) {

    if(document.editDeleteForm.editButton.style.width=='73px')
            {

            document.editDeleteForm.editButton.style.width='60';

            }
        for(var i=0;i<total;i++)
        {
            if (i==selectedIndex)
            {
                if(document.getElementById("tab"+i))
                {
                    document.getElementById("tab"+i).className = "submenu4";
                    document.getElementById("href"+i).className="text-white-link";
                }
            }
            else
            {
                if(document.getElementById("tab"+i))
                {
                    document.getElementById("tab"+i).className = "submenu3";
                    document.getElementById("href"+i).className="text-black-link";
                }

            }
        }

         globalSelectedIndex = selectedIndex;

        window.frames['addEditTableRowFrame'].location.href = 'blank.html';
        document.getElementById("rowForAddEditTable").style.display = 'none';
        document.getElementById("dividerLineForAddEditTable").style.display = 'none';

        changeEventStyle('no');
    }
  function hideButtons(mesg){
      if( mesg == "Yes"){
          document.getElementById("footerTableId").style.display = 'none';
          document.getElementById("heightForEvents").height =420;
      }else{
         document.getElementById("footerTableId").style.display = 'block';
         document.getElementById("heightForEvents").height = 210;
      }

  }
     function changeEventStyle(selected) {
            if (selected == "yes")
            {
                if (document.getElementById("eventsId")) {
                    document.getElementById("eventsId").className = "submenu4";
                    document.getElementById("hrefEvents").className = "text-white-link";
                }

                if (document.getElementById("tab" + globalSelectedIndex)) {
                    document.getElementById("tab" + globalSelectedIndex).className = "submenu3";
                    document.getElementById("href" + globalSelectedIndex).className = "text-black-link";
                }
                globalSelectedIndex = 0;

            }
            else
            {
                if (document.getElementById("eventsId")) {
                    document.getElementById("eventsId").className = "submenu3";
                    document.getElementById("hrefEvents").className = "text-black-link";
                }
            }
        }

    <%--
    function toggleAlertMode() {
        var iconName = document.getElementById('_alertIcon').src.toString();
        var thisForm = document.editDeleteForm;
        var action;
        var flag = 0;
        if (iconName.indexOf('disabled') > 0) {
            if (confirm("Please confirm that you would like to recieve e-mail when profile/interaction changes for "+'<%=currentKOLName%>'+". Press OK to confirm.")) {
                document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
                alert("E-mail alerts for Profile changes activated.");
                
                setCookie( <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>, "enabled", 15);
                action = "registerNotify";
                flag = 1;
                
                //alert(document.getElementById('_alertIcon').src);
            }
        } else {
            if (confirm("Please confirm that you would not like to recieve e-mail when profile/interaction changes for"+'<%=currentKOLName%>'+ ". Press OK to confirm.")) {
                document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
                alert("E-mail alerts for  Profile changes de-activated.");
                eraseCookie( <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>);
                action = "deregisterNotify";
                flag = 1;
                //alert(document.getElementById('_alertIcon').src);
            }
        }
        //alert(attrId);
        
    if(flag)
        {
        document.location.href="innerProfilePage.htm?currentKOLName=<%=currentKOLName%>&attributeId="+attrId+"&parentId="+parentId+"&kolId=<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>&action="+action+"&rootParentId=<%=rootParentId%>&selected="+selectedTabName+"&entityId="+entityId+"&displayName=<%=request.getAttribute("displayName")%>";

        }
        //thisForm.submit();
                
        

    }

    function setNotifyIcon() {
    

        if (getCookie(  <%=userId%>+<%=request.getSession().getAttribute(Constants.CURRENT_KOL_ID)%>)) {
        
            document.getElementById('_alertIcon').src = 'images/alert-enabled.gif';
        } else {
            document.getElementById('_alertIcon').src = 'images/alert-disabled.gif';
        }
    }
  --%>
  
  function resizeIFramesInnerProfile(){
    var frame = document.getElementById('showBasicAttrs');
    frame.height = frame.Document.body.scrollHeight;
    if(parent.resizeIFramesFullProfile) parent.resizeIFramesFullProfile();
  }

  function pageOnLoad(){
    //setNotifyIcon();
    if(parent.resizeIFramesFullProfile) parent.resizeIFramesFullProfile();
  }
  </script>

<body onLoad="javascript:pageOnLoad()" class="reset">
<%
    AttributeType attr = (AttributeType) request.getSession().getAttribute("attribute");
    AttributeType [] subAttrs = (AttributeType []) request.getSession().getAttribute("subAttributes");
    HashMap map = (HashMap) request.getSession().getAttribute("entityAttributesMap");

    boolean hasSubTabs = !attr.isArraylist() && subAttrs != null && subAttrs.length > 0 && subAttrs[0].isEntity();
%>

<form name="editDeleteForm">

    <div class="producttext" vertical-align="top" align="center" style="text-align:left;border:0px;">
        <!-- sub tabs start here -->
        <div class="myexpertlist">
          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="middle" style="color:#4C7398">
              <td width=100% valign="middle">
                 <div class="myexperttext">
                        <%
                        if(request.getAttribute("displayName")!=null){%>
                         <div class="myexperttext">&nbsp;&nbsp;<%=request.getAttribute("displayName") %> </div>
                        <%}else{%>
                        <div class="myexperttext">&nbsp;&nbsp;<%=subAttrs[0].getName()%> </div>
                        <%}%>            
                 </div>
              </td>
            </tr>
         </table>
     </div>   
        
    <!-- sub tabs end here -->

  <!-- show basic attributes -->
  <table width=100% height=410px scrolling="auto" cellpadding="0" cellspacing="0" bgcolor="#fcfcf8">
      <tr>
        <td  height=100% valign=top width="100%" id="heightForEvents"> <iframe src='showBasicAttributes.htm?attributeId=<c:out escapeXml="false" value="${selectedTab}"/>&entityId=<c:out escapeXml="false" value="${entityId}"/>&parentId=<c:out escapeXml="false" value="${parentId}"/>&currentKOLName=<%=currentKOLName%>&tabName=<c:out escapeXml="false" value="${selectedTabName}"/>' height="105%" vspace=0 hspace=0 width="100%" name="showBasicAttrs" id="showBasicAttrs" frameborder="0" scrolling="auto"></iframe></td>
       
       <td height="27" valign=top width="100%" class="text-blue-02">&nbsp;</td>

      </tr>

      <tr style="display:none" id="dividerLineForAddEditTable">
        <td colspan="180" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
      </tr>
      <tr class="back-white" style="display:none" id="rowForAddEditTable">
        <td height="" valign=top width="100%"><iframe src='blank.html' height="300px" vspace=0 hspace=0 width="100%" name="addEditTableRowFrame" id="addEditTableRowFrame" frameborder="0" scrolling="auto"></iframe></td>
      </tr>

  <!-- footer for profile view -->

      <tr>
        <td colspan="10" height="1" align="left" valign="top" class="back-blue-03-medium"><img src="images/transparent.gif" width="1" height="1"></td>
      </tr>

      <tr>
        <td colspan="10" height="1" align="left" valign="top"></td>
      </tr>
      
      <tr id="footerTableId" class="back-white">
        <td height="30"><table width=100% border="0" cellspacing="0" cellpadding="0">
               <tr>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="middle" width="5">
                    <input name="deleteRow" type="button" class="button-01" value="" style="border:0 none;background : url('images/buttons/delete.gif');width:73px; height:22px" onClick="deleteTableRows();" <c:out escapeXml="false" value="${disableDeleteButton}"/>></td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="middle" width="5">
                    <input name="editButton" type="button" value="" style="border:0 none;background : url('images/buttons/edit.gif');width:60px; height:22px" onClick="editValues();" <c:out escapeXml="false" value="${disableEditButton}"/>></td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="middle" width="5">
                    <input name="addRow" type="button" class="button-01" value="" style="border:0 none;background : url('images/buttons/add-int.gif');width:73px; height:22px" onClick="addTableRow();" <c:out escapeXml="false" value="${disableAddButton}"/>></td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="middle" width="5"><input name="cancelEditSave" type="button" class="button-01" style="display:none" value="Cancel" onClick="cancelEditOrSave();"></td>
                 <td valign="top" align="right">&nbsp;</td>
                 
                 <td width="45" height="30">
                     &nbsp;</td>
                     <td width="30" height="30">&nbsp;</td>
                
                 <td valign="top" align="right" width="43">&nbsp;
                  </td>

                 <td width="15" height="30">
                     &nbsp;</td>
                 
                 <td valign="top" align="right" width="13">&nbsp;
                 </td>
                 
                 <td width="15" height="30">
                    &nbsp;</td>
                 <td valign="top" align="right" width="5">&nbsp;</td>
                 <td width="15" height="30">
                    &nbsp;</td>
                 <td valign="top" align="top" width="45" style="cursor:hand" onClick="javascript:window.open('showBasicAttributes.htm?attributeId=' + attrId + '&entityId=' + entityId + '&parentId=' + parentId + '&prettyPrint=true' + '&currentKOLName=<%=currentKOLName%>' + '&tabName=' + selectedTabName)">
                    <img src='images/print.gif' border=0 height="32" title="Printer friendly format"/>
                </td>
              </tr>
              
               <tr>
<td width="5" height="30">&nbsp;</td>
                 <td valign="top" width="5">&nbsp;</td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="top" width="5">&nbsp;</td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="top" width="5">&nbsp;</td>
                 <td width="5" height="30">&nbsp;</td>
                 <td valign="top" width="5">&nbsp;</td>
                 <td valign="top" align="right">&nbsp;</td>
                 <td width="45" height="30">&nbsp;</td>
                 <td width="30" height="30">&nbsp;</td>
                 
                <td valign="top" align="right"  height="30" width="43">&nbsp;</td>

                  <td width="22" height="30">&nbsp;</td>
                 
                <td valign="top" align="right"  height="30" width="36">&nbsp;</td>
                 <td width="14" height="30">&nbsp;</td>
                 <td valign="top" align="right"  height="30" width="5" style="cursor:hand">&nbsp;</td>
                 <td width="15" height="30">&nbsp;</td>
                 <td height="30" valign="top" align="right" width="5" style="cursor:hand" onClick="javascript:window.open('showBasicAttributes.htm?attributeId=' + attrId + '&entityId=' + entityId + '&parentId=' + parentId + '&prettyPrint=true' + '&currentKOLName=<%=currentKOLName%>' + '&tabName=' + selectedTabName)"><a class="text-blue-link" href="#" >Print</a></td>
                 <td width="5" height="30">&nbsp;</td>
              </tr>
            </table>
            
         </td>
      </tr>
</table>
</div>

</form>
</div>
<form name="editAttributeForm" action="editProfileAttributes.htm">
    <input type="hidden" name="attributeId" value='<c:out escapeXml="false" value="${selectedTab}"/>' />
    <input type="hidden" name="entityId" value='<c:out escapeXml="false" value="${entityId}"/>' />
    <input type="hidden" name="entityAttr" value="-1"/>
    <input type="hidden" name="parentId" value='<c:out escapeXml="false" value="${parentId}"/>' />
    <input type="hidden" name="currentKOLName" value='<%=currentKOLName%>' />
    <input type="hidden" name="tabName" value='<c:out escapeXml="false" value="${selectedTabName}"/>' />
</form>
<form name="selfSubmitForm" action="showBasicAttributes.htm" target="showBasicAttrs">
    <input type="hidden" name="attributeId" value='<c:out escapeXml="false" value="${selectedTab}"/>' />
    <input type="hidden" name="entityId" value='<c:out escapeXml="false" value="${entityId}"/>' />
    <input type="hidden" name="parentId" value='<c:out escapeXml="false" value="${parentId}"/>' />
    <input type="hidden" name="currentKOLName" value='<%=currentKOLName%>' />
    <input type="hidden" name="tabName" value='<c:out escapeXml="false" value="${selectedTabName}"/>' />
</form>

</body>
<script type="text/javascript">
var i=1;
if(document.getElementById("tab0")!=null){
    document.getElementById("tab0").className = "submenu4";
}
if(document.getElementById("href0")!=null){
    document.getElementById("href0").className="text-white-link";
}

while(document.getElementById("tab"+i)!=null){
            document.getElementById("tab"+i).className = "submenu3";
            document.getElementById("href"+i).className="text-white-link";
            i++;    
}
</script>
</html>