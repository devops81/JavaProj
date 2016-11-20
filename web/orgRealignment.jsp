<!-- saved from url=(0022)http://internet.e-mail -->
<%@ page language="java" %>
<%@ include file = "header.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.contacts.Contacts" %>
<%@ page import="com.openq.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.openq.eav.org.Organization" %>
<%@ page import="com.openq.orgContacts.OrgContacts" %>

<%
    if (request.getSession().getAttribute(Constants.CURRENT_USER) == null)
        response.sendRedirect("login.htm");
    String user1 = null;
    if (null != session.getAttribute("USER1")) {
        user1 = (String) session.getAttribute("USER1");
    }
    String user2 = null;
    if (null != session.getAttribute("USER2")) {
        user2 = (String) session.getAttribute("USER2");
    }
    String email1 = null;
    if (null != session.getAttribute("EMAIL1")) {
        email1 = (String) session.getAttribute("EMAIL1");
    }
    String email2 = null;
    if (null != session.getAttribute("EMAIL2")) {
        email2 = (String) session.getAttribute("EMAIL2");
    }
    String phone1 = null;
    if (null != session.getAttribute("PHONE1")) {
        phone1 = (String) session.getAttribute("PHONE1");
    }
    String phone2 = null;
    if (null != session.getAttribute("PHONE2")) {
        phone2 = (String) session.getAttribute("PHONE2");
    }
    String staffId1 = null;
    if (null != session.getAttribute("STAFFID1")) {
        staffId1 = (String) session.getAttribute("STAFFID1");
    }
    String staffId2 = null;
    if (null != session.getAttribute("STAFFID2")) {
        staffId2 = (String) session.getAttribute("STAFFID2");
    }
    Map contactsOrgMap1=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_ORG_MAP_USER1")!=null){
       contactsOrgMap1=(LinkedHashMap)session.getAttribute("CONTACTS_ORG_MAP_USER1");
    }
    Map contactsOrgMap2=new LinkedHashMap();
    if(session.getAttribute("CONTACTS_ORG_MAP_USER2")!=null){
       contactsOrgMap2=(LinkedHashMap)session.getAttribute("CONTACTS_ORG_MAP_USER2");
    }
    String beginDate = null != session.getAttribute("CONTACT_PRESENT_DATE")? (String)session.getAttribute("CONTACT_PRESENT_DATE") : null;
    String endDate = null != session.getAttribute("CONTACT_END_DATE")? (String)session.getAttribute("CONTACT_END_DATE") : null;
    String nextDate = null != session.getAttribute("CONTACT_NEXT_DATE")? (String)session.getAttribute("CONTACT_NEXT_DATE") : null;
    String previousDate = null != session.getAttribute("CONTACT_PREVIOUS_DATE")? (String)session.getAttribute("CONTACT_PREVIOUS_DATE") : null;
    int count1=0;
    int count2=0;

%>

<HTML>
<HEAD>
	<TITLE>openQ 2.0 - openQ Technologies Inc.</TITLE>
	<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
    <SCRIPT src = "<%=COMMONJS%>/listbox.js" language = "javascript"></SCRIPT>
</HEAD>

<script language="javascript">



function addAttendee(username, phone, email, staffid) {
    if (document.orgrealignment.selectUserToggle.value=='user2') {
        document.orgrealignment.user2.value = username;
        document.orgrealignment.staffId2.value = staffid;
        document.orgrealignment.email2.value = email;
        document.orgrealignment.phone2.value = phone;

    } else if(document.orgrealignment.selectUserToggle.value=='user1') {
        document.orgrealignment.user1.value = username;
        document.orgrealignment.staffId1.value = staffid;
        document.orgrealignment.email1.value = email;
        document.orgrealignment.phone1.value = phone;

    }
 }

function selectUser1() {
	document.orgrealignment.selectUserToggle.value = 'user1';
    window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
}

function selectUser2() {
	document.orgrealignment.selectUserToggle.value = 'user2';
    window.open('employee_search.htm','employeesearch','width=690,height=400,top=100,left=100,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
}

function printList() {
    var thisform = document.orgrealignment;
    var staffId1 = document.orgrealignment.staffId1.value;
    var staffId2 = document.orgrealignment.staffId2.value;
    var user1 = document.orgrealignment.user1.value;
    var user2 = document.orgrealignment.user2.value;
     window.open("<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.ORG_REALIGNMENT_PRINT%>&staffId1=" + staffId1 + "&staffId2=" + staffId2 + "&user1="+user1 + "&user2="+user2);

}
function help() {
    alert("For demonstration purpose only. All links are just placeholders.");
}
function resetValues() {
    var thisform = document.orgrealignment;
    thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.RESET_ORG_REALIGN%>";
    thisform.submit();
}



function test1(userList){
	var eUserList = document.orgrealignment.r2.value;
	if(userList.indexOf(',')!= -1){
		var uArray = userList.split(",");
		for(i=0;i<uArray.length;i++){
			var val = uArray[i];
			if(eUserList.indexOf(val) != -1){
				eUserList = eUserList.replace(val,"");
			}
		}
	}else{
		if(eUserList.indexOf(userList) != -1){
				eUserList = eUserList.replace(userList,"");
			}
	}
	//alert(" Values after "+eUserList);
	document.orgrealignment.r2.value = eUserList;
}

function test2(userList){
	var eUserList = document.orgrealignment.r1.value;
	var uArray = userList.split(",");
	for(i=0;i<uArray.length;i++){
		var val = uArray[i];
		if(eUserList.indexOf(val) != -1){
			eUserList = eUserList.replace(val,"");
		}
	}
	//	alert(" Values after "+eUserList);
	document.orgrealignment.r1.value = eUserList;
}


function saveAllOrgs() {
    var thisform = document.orgrealignment;

    var staffId1 = document.orgrealignment.staffId1.value;
    var staffId2 = document.orgrealignment.staffId2.value;
    thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.SAVE_REALIGNMENT_ORGS%>";
    thisform.submit();

}
function addOrgToList1() {
	var thisform = document.orgrealignment;
	var staffId1 = document.orgrealignment.staffId1.value;
    if (null != staffId1 && staffId1 != 0) {
		thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.GET_ORGS%>&staffId="+staffId1+"&table=1";
    	thisform.submit();
    }
}
function addOrgToList2() {
	var thisform = document.orgrealignment;
    var staffId2 = document.orgrealignment.staffId2.value;
    if (null != staffId2 && staffId2 != 0) {
		thisform.action = "<%=CONTEXTPATH%>/orgAlignment.htm?action=<%=ActionKeys.GET_ORGS%>&staffId="+staffId2+"&table=2";
    	thisform.submit();
    }
}


function setDisable(){

    if( (null != document.getElementById ("user1") && "" != document.getElementById ("user1").value) && ((null != document.getElementById ("user2") && "" != document.getElementById ("user2").value) ) ) {
        document.getElementById ("Submit3322").disabled = false;
        document.getElementById ("Submit33223").disabled = false;
    }else{
        document.getElementById ("Submit3322").disabled = true;
        document.getElementById ("Submit33223").disabled = true;
    }
}



function moveToTable2(moveCopyFlag){
	var thisform = document.orgrealignment;
    var staffId2 = document.orgrealignment.staffId2.value;
    var staffId1 = document.orgrealignment.staffId1.value;

    var user2 = document.orgrealignment.user2.value;
    var email2 = document.orgrealignment.email2.value;
    var phone2 = document.orgrealignment.phone2.value;
    var columnValueArray = new Array();
    var checkedObjArray = new Array();
	var indexOfObjArray = new Array();
	var cCount = 0;
	var chk = false;
	var c = 0;
	var userList1 = "";
	//testcolumns('olAlignmentTableForUser2');

    var editButtonSelect = customGetElementByName('editOrgContactTable1');
	    for(var i=0;i<editButtonSelect.length;i++){
			if(editButtonSelect[i].checked){
				var rowNum = findRowNumOfTable('orgAlignmentTableForUser1',editButtonSelect[i].getAttribute("id").split("_")[1]);
				var index =editButtonSelect[i].getAttribute("id").split("_")[1];
				columnValueArray = getColumnValuesOfARow('orgAlignmentTableForUser1',index);
				if(ifOrgPresent('orgAlignmentTableForUser2',columnValueArray) == 'true'){
					alert('This Record Is Already Present');

				}else{
					addRow('orgAlignmentTableForUser2',columnValueArray, moveCopyFlag);
					checkedObjArray[cCount] = orgAlignmentTableForUser1.rows[i];
					indexOfObjArray[cCount] = i;
					cCount++;
				}

			}
		}

	   if (checkedObjArray.length > 0 && moveCopyFlag == 'move'){

		   deleteRows(checkedObjArray);
		   reorder(orgAlignmentTableForUser1, indexOfObjArray[0]);
	    }
	//testcolumns('olAlignmentTableForUser2');

}

function moveToTable1(moveCopyFlag){
	var thisform = document.orgrealignment;
    var staffId2 = document.orgrealignment.staffId2.value;
    var staffId1 = document.orgrealignment.staffId1.value;

    var user2 = document.orgrealignment.user2.value;
    var email2 = document.orgrealignment.email2.value;
    var phone2 = document.orgrealignment.phone2.value;
    var columnValueArray = new Array();
    var checkedObjArray = new Array();
	var indexOfObjArray = new Array();
	var cCount = 0;
	var chk = false;
	var c = 0;
	var userList2="";

	 var editButtonSelect = customGetElementByName('editOrgContactTable2');
	    for(var i=0;i<editButtonSelect.length;i++){
			if(editButtonSelect[i].checked){
				var rowNum = findRowNumOfTable('orgAlignmentTableForUser2',editButtonSelect[i].getAttribute("id").split("_")[1]);
				var index =editButtonSelect[i].getAttribute("id").split("_")[1];
				columnValueArray = getColumnValuesOfARow('orgAlignmentTableForUser2',index);
				if(ifOrgPresent('orgAlignmentTableForUser1',columnValueArray) == 'true'){
					alert('This Record Is Already Present');

				}
				else{
					addRow('orgAlignmentTableForUser1',columnValueArray, moveCopyFlag);
					checkedObjArray[cCount] = orgAlignmentTableForUser2.rows[i];
					indexOfObjArray[cCount] = i;
					cCount++;
				}

			}
		}
		if (checkedObjArray.length > 0 && moveCopyFlag == 'move'){

			deleteRows(checkedObjArray);
			reorder(orgAlignmentTableForUser2, indexOfObjArray[0]);
	    }
}

function ifOrgPresent(tableName, columnValuesArray){

	var oTable = document.getElementById(tableName);
	var flag = 'false';
	if(tableName == 'orgAlignmentTableForUser1')
		var tableId='Table1';
	if(tableName == 'orgAlignmentTableForUser2')
		var tableId='Table2';
	var hiddenOrgsIds = customGetElementByName('alignedOrgs'+tableId);
	for(var i=0;i<hiddenOrgsIds.length;i++){
			if(hiddenOrgsIds[i].value == columnValuesArray[5]) {
	          return 'true';;
		}
	}
	return 'false';
}

function findRowNumOfTable(tableName, editContactIndex){
 	var orgAlignTable = document.getElementById(tableName);
	for(var j=0; j<orgAlignTable.rows.length;j++){
		var rowIndex = (orgAlignTable.rows[j].cells[7].firstChild.id);
		var editIndex = (editContactIndex);
		if(editIndex == rowIndex){
			return j;
		}
	}
}
function reorder(tableObj, firstIndex){
      for(var i= 0;i< tableObj.rows.length;i++){
           if (i%2>0){
	              tableObj.rows[i].className = "back-grey-02-light";
           }else{
                   tableObj.rows[i].className= "back-white-02-light";
		   }

      }
 }


   function deleteRows(rowObjArray){
    	for (var i=0; i<rowObjArray.length; i++) {
			var rIndex = rowObjArray[i].sectionRowIndex;

			rowObjArray[i].parentNode.deleteRow(rIndex);

		}
  }
function testcolumns(tableName){
    if(tableName == 'orgAlignmentTableForUser1')
		var tableId='Table1';
	if(tableName == 'orgAlignmentTableForUser2')
		var tableId='Table2';
	var oTable = document.getElementById(tableName);
	for(var rowNum=oTable.rows.length-1;rowNum<oTable.rows.length;rowNum++){
	var alignedOrgName = document.getElementById("alignedOrgName"+tableId+rowNum);
	var primaryContactFlag = document.getElementById("primaryContact"+tableId+rowNum);
	var beginDateTextBoxName = document.getElementById("contactBeginDate"+tableId+rowNum);
    var endDateTextBoxName = document.getElementById("contactEndDate"+tableId+rowNum);
    var editCheckBox = document.getElementById(tableId+"_"+rowNum);
    var hiddenAlignedOrgIds = document.getElementById("hiddenAlignedOrgs"+tableId+rowNum);
    var hiddenContactBeginDates = document.getElementById("hiddenContactBeginDate"+tableId+rowNum);
    var hiddenContactEndDates = document.getElementById("hiddenContactEndDate"+tableId+rowNum);
    var hiddenContactIds = document.getElementById("hiddenContactIds"+tableId+rowNum);
    var hiddenPrimaryContactFlagValue = document.getElementById("hiddenPrimaryContactFlagValue"+tableId+rowNum);


    alert(alignedOrgName.innerHTML);
    alert(beginDateTextBoxName.value);
    alert(endDateTextBoxName.value);
    alert(primaryContactFlag.innerHTML);
    alert(editCheckBox.value);
    alert(hiddenAlignedOrgIds.value);
    alert(hiddenContactBeginDates.value);
    alert(hiddenContactEndDates.value);
    alert(hiddenContactIds.value);
    alert(hiddenPrimaryContactFlagValue.value);
    }

}

function getColumnValuesOfARow(tableName, rowNum){
	var columnValueArray = new Array();

	if(tableName == 'orgAlignmentTableForUser1')
		var tableId='Table1';
	if(tableName == 'orgAlignmentTableForUser2')
		var tableId='Table2';
	var oTable = document.getElementById(tableName);
	var alignedOrgName = document.getElementById("alignedOrgName"+tableId+rowNum);
	var primaryContactFlag = document.getElementById("primaryContact"+tableId+rowNum);
	var beginDateTextBoxName = document.getElementById("contactBeginDate"+tableId+rowNum);
    var endDateTextBoxName = document.getElementById("contactEndDate"+tableId+rowNum);
    var editCheckBox = document.getElementById(tableId+"_"+rowNum);
    var hiddenAlignedOrgIds = document.getElementById("hiddenAlignedOrgs"+tableId+rowNum);
    var hiddenContactBeginDates = document.getElementById("hiddenContactBeginDate"+tableId+rowNum);
    var hiddenContactEndDates = document.getElementById("hiddenContactEndDate"+tableId+rowNum);
    var hiddenContactIds = document.getElementById("hiddenContactIds"+tableId+rowNum);
    var hiddenPrimaryContactFlagValue = document.getElementById("hiddenPrimaryContactFlagValue"+tableId+rowNum);

    var i=0;
    columnValueArray[i++] = alignedOrgName.innerHTML;
    columnValueArray[i++] = beginDateTextBoxName.value;
    columnValueArray[i++] = endDateTextBoxName.value;
    columnValueArray[i++] = primaryContactFlag.innerHTML;
    columnValueArray[i++] = editCheckBox.value;
    columnValueArray[i++] = hiddenAlignedOrgIds.value;
    columnValueArray[i++] = hiddenContactBeginDates.value;
    columnValueArray[i++] = hiddenContactEndDates.value;
    columnValueArray[i++] = hiddenContactIds.value;
    columnValueArray[i++] = hiddenPrimaryContactFlagValue.value;

    return columnValueArray;

}


function selectAllContacts(headerId){
	var editSelectTable1 = customGetElementByName('editOrgContactTable1');
	var editSelectTable2 = customGetElementByName('editOrgContactTable2');

	if(headerId == '1'){
		for(var i=0;i<editSelectTable1.length;i++){
			editSelectTable1[i].click();
		}
	}
	if(headerId == '2'){
		for(var i=0;i<editSelectTable2.length;i++){
			editSelectTable2[i].click();
		}
	}
}
//This is  not optimal, but IE doesnt fetch elements which were added throuh DOM by getElementsByName
function customGetElementByName(elementName){
	var allInputs = document.getElementsByTagName("input");
	var elements = new Array();
	var count = 0;
	for(var i=0;i<allInputs.length;i++){
		if(allInputs[i].getAttribute("name") == elementName){
			elements[count]=allInputs[i];
			count++;
		}
	}
	return elements;
}

</script>
<%
	 completeName = (String) request.getSession().getAttribute(Constants.COMPLETE_USER_NAME);
%>
<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" onLoad="setDisable()">
<form name="orgrealignment" method="post">
<input type="hidden" name="selectUserToggle" value=""/>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="producttext">

 <tr align="left" valign="top">
    <td width="10" class="colContent">&nbsp;</td>

    <td><table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
         <tr>
             <td width="10" class="colContent">&nbsp;</td>
        </tr>

        <tr>
          <td align="left" valign="top"><table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
              <tr align="left" valign="top">

                <td width="10" class="colContent">&nbsp;</td>
                <td class="producttext">
				
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="colContent">
                    <tr>
                      <td height="20" align="left" valign="top" class="colContent">
                      <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="colTitle">
                          <tr align="left" valign="middle">
                            <td width="10" height="20">&nbsp;</td>
                            <td class="colTitle">Orgnization Re -Alignment </td>
                            <td class="text-white-bold" align="right" valign="middle"><a href="javascript:printList()"
								  class="text-white-bold" target="_self" title="Printer-friendly version of this section"><img src="<%=COMMONIMAGES%>/print_icon.gif" width="16" height="16" border="0"></a>
							 </td>
							 <td width="30" height="20">&nbsp;</td>
                          </tr>
                      </table></td>
                    </tr>
                    <tr>
                      <td height="1" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="1" height="1"></td>
                    </tr>
                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"></td>
                    </tr>
                    <%--<tr>
                      <td align="left" valign="top" class="back-white"><span class="text-black-01-bold">&nbsp;&nbsp;&nbsp;(We are still discussing how best to display the information, for now it's a list box)</span></td>
                    </tr>--%>
                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
                    </tr>
                    <%--<tr>
                      <td height="10" align="left" valign="top"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
                      <td width="10" rowspan="9" align="left" valign="top">&nbsp;</td>
                    </tr>--%>

                    <td height="100%" align="left" valign="top" class="colContent"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="10" height="100%" class="text-blue-01"></td>
                        <td class="text-blue-01"><table width="100%" border="0" cellpadding="2" cellspacing="0">
                          <tr>
                            <td width="50%" valign="bottom" height="50"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="80" height="20" class="text-blue-01"><span class="style2">Align User 1:</span></td>
                                <td width="125"><input name="user1" type="text" class="field-blue-06-100x20" readonly maxlength="50" value="<%=null != user1 ? user1 : ""%>"/></td>
                                 <input type="hidden" name="staffId1" value="<%=null != staffId1 ? staffId1 : ""%>"/>
                                  <input type="hidden" name="email1" value="<%=null != email1 ? email1 : ""%>"/>
                                  <input type="hidden" name="phone1" value="<%=null != phone1 ? phone1 : ""%>"/>
								  <input type="hidden" name="moveUser1" />
								  <input type="hidden" name="moveUser11" />
								  <input type="hidden" name="r1" />
                                <td class="text-blue-01"><input name="save222" type="button" class="button-01"  style="border:0;background : url(images/select.jpg);width:85px; height:22px;" onClick="javascript:selectUser1()"></td>

                                <td> <input name="save3" type="button"
                                                                                class="button-01"
                                                                                value=" Get Orgs "
                                                                                onClick="addOrgToList1()"></td>

                              </tr>

                            </table></td>
                            <td valign="top" style="padding-bottom:5px;">&nbsp;</td>
                            <td width="50%" valign="bottom" style="padding-bottom:5px;"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="125" height="20" class="text-blue-01"><span class="style2">Align User 2:</span></td>
                                <td width="125"><input name="user2" type="text" class="field-blue-06-100x20" readonly maxlength="50" value="<%=null != user2 ? user2 : ""%>"/></td>
                                 <input type="hidden" name="staffId2" value="<%=null != staffId2 ? staffId2 : ""%>"/>
                                  <input type="hidden" name="email2" value="<%=null != email2 ? email2 : ""%>"/>
                                  <input type="hidden" name="phone2" value="<%=null != phone2 ? phone2 : ""%>"/>
								  <input type="hidden" name="moveUser2" />
								  <input type="hidden" name="moveUser22" />
  								  <input type="hidden" name="r2" />
                                  <td class="text-blue-01"><input name="save2222" type="button" class="button-01"  style="border:0;background : url(images/select.jpg);width:85px; height:22px;" onClick="javascript:selectUser2()"></td>

                                <td>&nbsp;<input name="save334" type="button"
                                                                                class="button-01"
                                                                                value=" Get Orgs "
                                                                                onClick="addOrgToList2()"></td>
                              </tr>

                            </table></td>
                            <td valign="bottom" style="padding-bottom:5px;">&nbsp;</td>
                          </tr>
                          <tr>
                          		<td>&nbsp;</td>
                          		<td>&nbsp;</td>
                          		<td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="50%" height="30" valign="middle">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="colTitle">
	                    		<tr>
			                        <td width="1%" valign="middle"  class="text-blue-01-bold">
			                        <img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
					                <td width="1%" valign="middle"></td>
					                <td width="20%" class="colTitle" align="left"> Org Name </td>
								    <td width="1%" class="colTitle" align="left">&nbsp;</td>
								    <td width="15%" class="colTitle" align= "left"> Begin Date </td>
								    <td width="15%" class="colTitle" align= "left"> End Date </td>
					                <td width="15%" class="colTitle" align= "left"> Primary Flag </td>
					                <td width="5%" class="colTitle" align= "left"> Select All
					                </td>
					                <td width="1%" class="colTitle" align= "left"></td>
			            		</tr>
			            		<tr>
			            			<td width="1%"/>&nbsp;</td>
					                <td width="1%" valign="middle"></td>
					                <td width="20%" class="text-blue-01-bold" align="left"> &nbsp;</td>
								    <td width="1%" class="text-blue-01-bold" align="left">&nbsp;</td>
								    <td width="15%" class="text-blue-01-bold" align= "left">&nbsp;</td>
								    <td width="15%" class="text-blue-01-bold" align= "left">&nbsp;</td>
					                <td width="15%" class="text-blue-01-bold" align= "left">&nbsp; </td>
					                <td width="5%" class="text-blue-01-bold" align= "left">
					                	<INPUT type=checkbox value="" name= "headerEditContact1" id="headerEditContact1" onclick="selectAllContacts('1')">
								    </td>
					                <td width="1%" class="text-blue-01-bold" align= "left">&nbsp;</td>

			            		</tr>
	                  		</table>
                            <div style="height:150px; overflow:auto;">
                            <table id = "orgAlignmentTableForUser1" name="userTable1" width="100%" border="0" cellspacing="0" cellpadding="0">

	                         <%count1=0;
						       if(contactsOrgMap1!=null){
		                      Set keySet=contactsOrgMap1.keySet();
						      Iterator i=keySet.iterator();
							  while(i.hasNext()){
								OrgContacts alignedContact = (OrgContacts)(i.next());
								Organization alignedOrg=(Organization)contactsOrgMap1.get(alignedContact);
		                    	if(count1%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<td width="1%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
				                <td width="1%" valign="middle"></td>
					            <td width="20%"  class="text-blue-01"  align="left" id="alignedOrgNameTable1<%=count1%>" name="alignedOrgNameTable1">
					 	         <%= alignedOrg.getName()%>
					 	        </td>
							    <td width="1%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="15%" class="text-blue-01" align= "left">

							    <input id="contactBeginDateTable1<%=count1%>" name="contactBeginDateTable1<%=count1%>" type="text" class="field-blue-14-90x20" readonly
							    	value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>" >
							    </td>
							    <td width="15%" class="text-blue-01" align= "left">
							    <input id="contactEndDateTable1<%=count1%>" name="contactEndDateTable1<%=count1%>" type="text" class="field-blue-14-90x20" readonly
							    	value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>" >
							    </td>

				                <td width="15%" class="text-blue-01" align= "left" id="primaryContactTable1<%=count1%>" name="primaryContactTable1">&nbsp;&nbsp;&nbsp;&nbsp;
				                  <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
				                </td>


				                <td width="5%" class="text-blue-01" align= "middle">
				                <INPUT type="checkbox" value="<%=alignedOrg.getEntityId()%>" name= "editOrgContactTable1" id="Table1_<%=count1%>"> </TD>
							    <td width="1%">
							    <input id="hiddenAlignedOrgsTable1<%=count1%>" name="alignedOrgsTable1" type="hidden" value="<%=alignedOrg.getEntityId()%>">
							    <input id="hiddenContactBeginDateTable1<%=count1%>" name="contactBeginDateTable1" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>">
							    <input id="hiddenContactEndDateTable1<%=count1%>" name="contactEndDateTable1" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>">
							    <input id="hiddenContactIdsTable1<%=count1%>" name="contactIdsTable1" type="hidden" value="<%=alignedContact.getOrgContactsId()%>">
							    <input id="hiddenPrimaryContactFlagValueTable1<%=count1%>" name="hiddenPrimaryContactFlagValueTable1" type="hidden"
							    <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> value="Y" <%} else{%> value="N" <%}%> >

							    </td>
		  					</TR>
		  					<%
		  					count1++;
		  					}
		  				}
	  					%>

	                        </table>
	                        </div>
                            </td>
                            <td width="150" valign="top" style="padding-bottom:5px;"><table width="100%" border="0" cellpadding="2" cellspacing="0">
                              <tr>
                                <td align="center" class="text-blue-01"><strong>Copy</strong></td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01"><input name="save23" type="button" class="button-01" value="    &gt;    " onClick="moveToTable2('copy')"></td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01"><input name="save24" type="button" class="button-01" value="    &lt;    " onClick="moveToTable1('copy')"></td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01">&nbsp;</td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01"><strong>Move</strong></td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01"><input name="save23" type="button" class="button-01" value="    &gt;    " onClick="moveToTable2('move')"></td>
                              </tr>
                              <tr>
                                <td align="center" class="text-blue-01"><input name="save24" type="button" class="button-01" value="    &lt;    " onClick="moveToTable1('move')"></td>
                              </tr>


                            </table></td>
                            <td width="50%" height="30" valign="middle">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="colTitle">
	                    		<tr>
			                        <td width="1%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
					                <td width="1%" valign="middle"></td>
					                <td width="20%" class="colTitle" align="left"> Org Name </td>
								    <td width="1%" class="colTitle" align="left">&nbsp;</td>
								    <td width="15%" class="colTitle" align= "left"> Begin Date </td>
								    <td width="15%" class="colTitle" align= "left"> End Date </td>
					                <td width="15%" class="colTitle" align= "left">Primary Flag </td>
					                <td width="5%" class="colTitle" align= "left"> Select All
					                </td>
					                <td width="1%" class="text-blue-01-bold" align= "left"></td>
			            		</tr>
			            		<tr>
			            			<td width="1%"/>&nbsp;</td>
					                <td width="1%" valign="middle"></td>
					                <td width="20%" class="text-blue-01-bold" align="left"> &nbsp;</td>
								    <td width="1%" class="text-blue-01-bold" align="left">&nbsp;</td>
								    <td width="15%" class="text-blue-01-bold" align= "left">&nbsp;</td>
								    <td width="15%" class="text-blue-01-bold" align= "left">&nbsp;</td>
					                <td width="15%" class="text-blue-01-bold" align= "left">&nbsp; </td>
					                <td width="5%" class="text-blue-01-bold" align= "left">&nbsp;
					                	<INPUT type=checkbox value="" name= "headerEditContact2" id="headerEditContact2" onclick="selectAllContacts('2')">
								    </td>
								    <td width="1%" class="text-blue-01-bold" align= "left">&nbsp;</td>

			            		</tr>
	                  		</table>
                            <div style="height:150px; overflow:auto;">
                            <table id = "orgAlignmentTableForUser2" name="userTable2" width="100%" border="0" cellspacing="0" cellpadding="0">
	                         <% count2=0;
						      if(contactsOrgMap2!=null){
		                      Set keySet=contactsOrgMap2.keySet();
						      Iterator i=keySet.iterator();
							  while(i.hasNext()){
								OrgContacts alignedContact = (OrgContacts)(i.next());
								Organization alignedOrg=(Organization)contactsOrgMap2.get(alignedContact);
		                    	if(count2%2==0){
								%>
									<TR align="left" valign="middle" class="back-white-02-light">
								<%
								}else{
								%>
									<TR align="left" valign="middle" class="back-grey-02-light">
								<% } %>
		  						<td width="1%" valign="middle"  class="text-blue-01-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14" height="14" /></td>
				                <td width="1%" valign="middle"></td>
					            <td width="20%"  class="text-blue-01"  align="left" id="alignedOrgNameTable2<%=count2%>" name="alignedOrgNameTable2">
					 	         	<%= alignedOrg.getName()%>
					 	         </td>
							    <td width="1%" class="text-blue-01" align="left">&nbsp;</td>
							    <td width="15%" class="text-blue-01" align= "left">

							    <input id="contactBeginDateTable2<%=count2%>" name="contactBeginDateTable2<%=count2%>" type="text" class="field-blue-14-90x20" readonly
							    	value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>" >
							    </td>
							    <td width="15%" class="text-blue-01" align= "left">
							    <input id="contactEndDateTable2<%=count2%>" name="contactEndDateTable2<%=count2%>" type="text" class="field-blue-14-90x20" readonly
							    	value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>" >
							    </td>

				                <td width="15%" class="text-blue-01" align= "left" id="primaryContactTable2<%=count2%>" name="primaryContactTable2">&nbsp;&nbsp;&nbsp;&nbsp;
				                  <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> Y<%} else{%> N <%}%>
				                </td>


				                <td width="5%" class="text-blue-01" align= "middle">
				                <INPUT type="checkbox" value="<%=alignedOrg.getEntityId()%>" name= "editOrgContactTable2" id="Table2_<%=count2%>"> </TD>
							    <td width="1%">
							    <input id="hiddenAlignedOrgsTable2<%=count2%>" name="alignedOrgsTable2" type="hidden" value="<%=alignedOrg.getEntityId()%>">
							    <input id="hiddenContactBeginDateTable2<%=count2%>" name="contactBeginDateTable2" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getBegindate())).toString().toUpperCase()%>">
							    <input id="hiddenContactEndDateTable2<%=count2%>" name="contactEndDateTable2" type="hidden" value="<%=(new SimpleDateFormat("dd-MMM-yyyy").format(alignedContact.getEnddate())).toString().toUpperCase()%>">
							    <input id="hiddenContactIdsTable2<%=count2%>" name="contactIdsTable2" type="hidden" value="<%=alignedContact.getOrgContactsId()%>">
							    <input id="hiddenPrimaryContactFlagValueTable2<%=count2%>" name="hiddenPrimaryContactFlagValueTable2" type="hidden"
							    <% if(alignedContact.getIsPrimaryContact()!=null && alignedContact.getIsPrimaryContact().equalsIgnoreCase("true")){%> value="Y" <%} else{%> value="N" <%}%> >

							    </td>
		  					</TR>
		  					<%
		  					count2++;
		  					}
		  				}
	  					%>

	                        </table>
	                        </div>
                            </td>
                            <td valign="top" style="padding-bottom:5px;">&nbsp;</td>
                          </tr>
                         <%-- <tr>
                            <td height="30" valign="middle">&nbsp;</td>
                            <td valign="top" style="padding-bottom:5px;">&nbsp;</td>
                            <td align="right" valign="middle" style="padding-bottom:5px;"><input name="Submit332232" type="button" class="button-01" value="Print Org List" onClick=""></td>
                            <td valign="top" style="padding-bottom:5px;">&nbsp;</td>
                          </tr>--%>
                        </table></td>
                      </tr>
                    </table></td>
                    </tr>
                    <tr>
                      <td height="10" align="left" valign="top">&nbsp;</td>
                    </tr>

                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
                    </tr>
                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="10" height="20">&nbsp;</td>
                          <td class="text-blue-01"><input name="Submit3322" type="button" class="button-01" style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" onClick="saveAllOrgs()">
                            &nbsp;
                            <%--<input name="Submit33222" type="button" class="button-01" value="Cancel" onClick="">
                            &nbsp;&nbsp;--%>
                            <input name="Submit33223" type="button" class="button-01" style="border:0;background : url(images/buttons/reset.gif);width:65px; height:22px;" type="button" onClick="resetValues()"></td>
                        </tr>
                      </table></td>
                    </tr>
                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="10"></td>
                    </tr>
                    <tr>
                      <td height="10" align="left" valign="top" class="colContent"></td>
                    </tr>
                  </table>
                </td>
                <td width="10" class="colContent">&nbsp;</td>
              </tr>
          </table></td>
        </tr>

    </table></td>

  </tr>
</table>
</form>
</body>
</html>
<%@ include file="footer.jsp"%>
<script>
  //document.orgrealignment.save2222.disabled = true;

var globalRowCount1=<%=count1%>;
var globalRowCount2=<%=count2%>;

  function addRow(tableName,columnValueArray, moveCopyFlag){
      var thisform = document.orgrealignment;
      var oTable = document.getElementById(tableName);

	 if(tableName=='orgAlignmentTableForUser1'){
		var tableId='Table1';
		var count =  globalRowCount1;
		globalRowCount1 = globalRowCount1 + 1;
	  }
	  if(tableName=='orgAlignmentTableForUser2'){
		var tableId='Table2';
		var count =  globalRowCount2;
		globalRowCount2 = globalRowCount2 + 1;
	  }
	  var len = oTable.rows.length;
	  counter = len;
	  var i=0;
	  var oRow = oTable.insertRow();                          //create rows (<tr>s) in the table with appropriate values for the columns(<td>s)
      if (counter%2>0)                                        // To alternate the background of rows to gray & white colors
            oRow.className = "back-white-02-light";
      else
            oRow.className= "back-grey-02-light";

      var oCell = oRow.insertCell();
	  oCell.width = "4%";
	  oCell.height = "25";
	  oCell.align="left";
	  var oIMG = document.createElement("img");
	  oIMG.setAttribute("src","<%=COMMONIMAGES%>/icon_my_expert.gif");
	  oIMG.setAttribute("height","14");
	  oIMG.setAttribute("width","14");
	  oCell.appendChild(oIMG);

      oCell = oRow.insertCell();
	  oCell.width = "1%";
	  oCell.height = "25";
	  oCell.innerHTML ="&nbsp";

      var oCell = oRow.insertCell();
	  oCell.width = "25%";
	  oCell.height = "25";
	  oCell.className = "text-blue-01";
	  oCell.id = "alignedOrgName"+tableId+count;
	  oCell.name = "alignedOrgName"+tableId;
	  oCell.innerHTML = columnValueArray[0];

	  oCell = oRow.insertCell();
	  oCell.width = "1%";
	  oCell.height = "25";
	  oCell.innerHTML ="&nbsp";

	  oCell = oRow.insertCell();
	  oCell.width = "15%";
	  oCell.height = "25";
      oCell.align="left";
	  oCell.className="text-blue-01";
	  var beginDate = document.createElement('input');
	  beginDate.setAttribute('type', 'textbox');
	  beginDate.setAttribute('className','field-blue-14-90x20');
	  beginDate.setAttribute('name', 'contactBeginDate'+tableId+count);
	  beginDate.setAttribute('id', 'contactBeginDate'+tableId+count);
	  beginDate.setAttribute('value','<%=beginDate%>');
	  oCell.appendChild(beginDate);

	  oCell = oRow.insertCell();
	  oCell.width = "15%";
	  oCell.height = "25";
      oCell.align="left";
	  oCell.className="text-blue-01";
	  var endDate = document.createElement('input');
	  endDate.setAttribute('type', 'textbox');
	  endDate.setAttribute('className','field-blue-14-90x20');
	  endDate.setAttribute('name', 'contactEndDate'+tableId+count);
	  endDate.setAttribute('id', 'contactEndDate'+tableId+count);
	  endDate.setAttribute('value','<%=endDate%>');
	  oCell.appendChild(endDate);

	  var oCell = oRow.insertCell();
	  oCell.width = "10%";
	  oCell.height = "25";
	  oCell.align="left";
	  oCell.className = "text-blue-01";
	  oCell.id = "primaryContact"+tableId+count;
	  oCell.name = "primaryContact"+tableId;
	  oCell.innerHTML = "    "+columnValueArray[3];

	  oCell = oRow.insertCell();
	  oCell.width = "5%";
	  oCell.height = "25";
      oCell.align="middle";
	  var edit = document.createElement('input');
	  edit.setAttribute('type', 'checkbox');
	  edit.setAttribute('name', 'editOrgContact'+tableId);
	  edit.setAttribute('id', tableId+"_"+count);
	  edit.setAttribute('value',columnValueArray[4]);
	  oCell.appendChild(edit);

	  var oCell = oRow.insertCell();
	  oCell.width = "1%";
	  var hiddenInput = document.createElement('input');
	  hiddenInput.setAttribute('type', 'hidden');
	  hiddenInput.setAttribute('name', 'alignedOrgs'+tableId);
	  hiddenInput.setAttribute('id', 'hiddenAlignedOrgs'+tableId+count);
	  hiddenInput.setAttribute('value',columnValueArray[5]);
	  oCell.appendChild(hiddenInput);

	  hiddenInput = document.createElement('input');
	  hiddenInput.setAttribute('type', 'hidden');
	  hiddenInput.setAttribute('name', 'contactBeginDate'+tableId);
	  hiddenInput.setAttribute('id', 'hiddenContactBeginDate'+tableId+count);
	  hiddenInput.setAttribute('value','<%=beginDate%>');
	  oCell.appendChild(hiddenInput);

	  var hiddenInput = document.createElement('input');
	  hiddenInput.setAttribute('type', 'hidden');
	  hiddenInput.setAttribute('name', 'contactEndDate'+tableId);
	  hiddenInput.setAttribute('id', 'hiddenContactEndDate'+tableId+count);
	  hiddenInput.setAttribute('value','<%=endDate%>');
	  oCell.appendChild(hiddenInput);

	  var hiddenInput = document.createElement('input');
	  hiddenInput.setAttribute('type', 'hidden');
	  hiddenInput.setAttribute('name', 'contactIds'+tableId);
	  hiddenInput.setAttribute('id', 'hiddenContactIds'+tableId+count);
	  hiddenInput.setAttribute('value','1');
	  oCell.appendChild(hiddenInput);

	  var hiddenInput = document.createElement('input');
	  hiddenInput.setAttribute('type', 'hidden');
	  hiddenInput.setAttribute('name', 'hiddenPrimaryContactFlagValue'+tableId);
	  hiddenInput.setAttribute('id', 'hiddenPrimaryContactFlagValue'+tableId+count);
	  hiddenInput.setAttribute('value',columnValueArray[3]);
	  oCell.appendChild(hiddenInput);
}

</script>