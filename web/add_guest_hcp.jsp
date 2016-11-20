<%@ include file="header.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.kol.DBUtil"%>
<%@page import="com.openq.utils.PropertyReader"%>

<%
	OptionLookup [] countryList = (OptionLookup[])request.getSession().getAttribute("countryList");
	OptionLookup [] stateList = (OptionLookup[])request.getSession().getAttribute("stateList");
	OptionLookup [] ta = (OptionLookup[])request.getSession().getAttribute("ta");
	OptionLookup [] stateAbbriviation = (OptionLookup [])request.getSession().getAttribute("stateAbbriviation");
	User userSaved = (User) request.getSession().getAttribute("userSaved");
	boolean isAlreadySelected = false;
%>
<script src="js/trim.js"></script>
<script language="javascript" src="js/populateChildLOV.js"></script>
<script type="text/javascript">

function addGuest(){
	thisForm = document.addHCP;
	if(trimAll(thisForm.hcpFirstName.value) != '' && trimAll(thisForm.hcpLastName.value) != '' &&
	trimAll(thisForm.hcpCountry.options[thisForm.hcpCountry.selectedIndex].value) != '2730' &&
	trimAll(thisForm.hcpSpeciality.options[thisForm.hcpSpeciality.selectedIndex].value) != '-1' &&
	trimAll(thisForm.hcpAddress1.value) != '' && trimAll(thisForm.hcpZipCode.value) != '' &&
	trimAll(thisForm.hcpCity.value) != '')
	{
		var guestCheckBox = document.getElementById('guestCheckBox');
		var fromAddGuest = true;

		thisForm.action = "<%=CONTEXTPATH%>/add_guest_hcp.htm?guestCheckBox="+guestCheckBox.checked+"&fromAddGuest="+fromAddGuest;
	    thisForm.submit();
	}else{
		alert("Please enter value in all the required fields");
		var addGuestOLButton = document.getElementById('addGuestOLButton');
		if(addGuestOLButton != undefined){
			addGuestOLButton.disabled = false;
		}
		return false;
	}
}

function checkInput() {
	if (document.searchKOL.lastname.value == null || document.searchKOL.lastname.value == "" || document.searchKOL.lastname.value == '<Last Name>')
	{
		alert('Please enter lastname');
		return;
	}
    if(document.searchKOL.searchText.value != '<First Name>' || document.searchKOL.state.options[document.searchKOL.state.options.selectedIndex].value != 'Select State'){
        openProgressBar();
	    document.searchKOL.submit();
    }else{
        alert("Please enter first name or the state in search criteria");
        return;
    }

}

function hideDefault(input){
	if(typeof(input.defaultValue)=="undefined")
		input.defaultValue = input.value;
    if(input.value == input.defaultValue)
   	    input.value = "";
}

function showDefault(input){
	if(input.value == "" && typeof(input.defaultValue) != "undefined")
		input.value = input.defaultValue;
}

function addExpertToKOLSegment(){
		  var thisform = document.searchKOL;
		  var flag = false ;
		  if (null != thisform.checkIds && thisform.checkIds.length != undefined){
			  for (var i = 0;  null != thisform.checkIds && i < thisform.checkIds.length; i++) {
				if (thisform.checkIds[i].checked) {
						flag = true;
						break;
				}
			  }
          }
          else {
          	 if (thisform.checkIds.checked) {
                flag = true;
             }
          }

          if (!flag)
            {
                alert("Please select atleast one <%=DBUtil.getInstance().doctor%>");
                return false;
            }

	//	document.searchKOL.target = "_top";
		document.searchKOL.submit();

    }
</script>

<!--head>
<title>openQ 3.0 - openQ Technologies Inc.</title>
<LINK href="css/openq.css" type=text/css rel=stylesheet>
</head-->

<!--BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0"-->
<%
	String _fName = request.getParameter("hcpfirstname") == null ? "" : request.getParameter("hcpfirstname");
	String _lName = request.getParameter("hcplastname") == null ? "" : request.getParameter("hcplastname");
	String _specialty = request.getParameter("speciality") == null ? "" : request.getParameter("speciality");
	String _address1 = request.getParameter("address1") == null ? "" : request.getParameter("address1");
	String _address2 = request.getParameter("address2") == null ? "" : request.getParameter("address2");
	String _city = request.getParameter("city") == null ? "" : request.getParameter("city");
	String _zip = request.getParameter("zip") == null ? "" : request.getParameter("zip");

%>
<form name="addHCP" method="post">
<input type="hidden" name="hcpSsoid" value='<%=request.getParameter("ssoid")%>'/>
<input type="hidden" name="hcpSsname" value='<%=request.getParameter("ssname")%>'/>
			<div class="producttext">
			<table  cellSpacing=0 cellPadding=0 width="98%" border=0>

				<tr>
		          <td height="20" align="left" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
		            <tr align="left" valign="middle">
		              <td>
		              <div class="producttext">
						<div class="myexpertlist">
							<table width="100%">
								<tbody>
									<tr style="color: rgb(76, 115, 152);">
										<td width="50%" align="left">
											<div class="myexperttext">Add Guest <%=DBUtil.getInstance().doctor%></div>
										</td>
										<td class="atext" width="50%" align="right">
											&nbsp
										</td>
									</tr>
								</tbody>
							</table>
						</div>
		          </table></td>
       			</tr>

			<%if(userSaved != null){ %>
				<tr>
					<td><font face ="verdana" size ="2" color="red"><b>User added successfully.</b></font></td>
				</tr>
			<% } %>

        <tr>
          <td height="10" align="left" valign="top" class="back-white"></td>
        </tr>
        <tr>
          <td align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>First Name:</td>
              <td valign="top"><input type="text" border="#c3c3c3" class="blueTextBox" name="hcpFirstName" value="<%=((userSaved == null)? _fName:"")%>" maxlength="50" size="15" /></td>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>Last Name:</td>
              <td valign="top"><input name="hcpLastName" type="text" value="<%=((userSaved == null)? _lName:"")%>" class="field-blue-01-120x20" maxlength="50" size="15" /></td>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="" nowrap="nowrap" valign="top" class="text-blue-01"><font size="2" color="red">*</font>Therapeutic Area:</td>
              <td valign="top">
              <select name="hcpSpeciality" class="field-blue-01-120x20">
              	<option value="-1" selected></option>
              	<% for(int i=0;i<ta.length;i++){
              		String selected = "" ;
              		if(ta[i].isDefaultSelected())
              			selected = "selected";
              	%>
          			<option value="<%=(ta[i].getId())%>" <%=selected%>><%=ta[i].getOptValue()%></option>
          		<% } %>
			  </select>
              </td>
              <td width="10" height="20" valign="top">&nbsp;</td>
              <td width="100" valign="top">&nbsp;</td>
              <td valign="top">&nbsp;</td>
            </tr>

        <tr>
          <td colspan="12" height="10" align="left" valign="top" class="back-white">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="12" height="10" align="left" valign="top"></td>
        </tr>
        <tr>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>Address Line 1:</td>
          <td valign="top"><input name="hcpAddress1" type="text" value="<%=((userSaved == null)?_address1 : "")%>" class="field-blue-01-120x20" maxlength="50"/></td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01">Address Line 2:</td>
          <td valign="top"><input name="hcpAddress2" type="text" value="<%=((userSaved == null)?_address2 : "")%>" class="field-blue-01-120x20" maxlength="50"/></td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>City:</td>
          <td valign="top"><input name="hcpCity" type="text" value="<%=((userSaved == null)? _city : "")%>" class="field-blue-01-120x20" maxlength="50"/></td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
         <td valign="top">&nbsp;</td>
        </tr>

        <tr>
          <td colspan="12" height="10" align="left" valign="top" class="back-white">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="12" height="10" align="left" valign="top"></td>
        </tr>

        <tr>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>State/Prov.:</td>
          <td valign="top"><select name="hcpState" class="field-blue-01-120x20">
          	<%  isAlreadySelected = false;
          		for(int i=0;i<stateList.length;i++){
          		String selected = "" ;
          		if(stateList[i].isDefaultSelected())
          			selected = "selected";
          	%>
          		<option value="<%=(stateList[i].getId())%>"
          		<% if (stateList[i].getOptValue().equals((String)request.getParameter("state"))){
          			isAlreadySelected = true;
          		%>selected <%}
          		else if(!isAlreadySelected) { %><%=selected%> <%} %>><%=stateList[i].getOptValue()%></option>
          	<% } %></select>
          </td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>Postal Code:</td>
          <td valign="top"><input name="hcpZipCode" type="text" value="<%=((userSaved == null)?_zip :"")%>" class="field-blue-01-120x20" maxlength="50"/></td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01"><font size="2" color="red">*</font>Country:</td>
          <td valign="top"><select name="hcpCountry" class="field-blue-01-120x20">
          	<%  isAlreadySelected = false;
          		for(int i=0;i<countryList.length;i++){
          		String selected = "" ;
          		if(countryList[i].isDefaultSelected())
          			selected = "selected";
          	%>
          		<option value="<%=(countryList[i].getId())%>"
          		<% if(countryList[i].getOptValue()==request.getParameter("country")){
          			isAlreadySelected = true;
          		%> selected <%}
          	    else if(!isAlreadySelected) { %><%=selected%> <%} %>><%=countryList[i].getOptValue()%></option>
          	<% } %></select></td>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
         <td valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="12" height="10" align="left" valign="top" class="back-white">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="12" height="10" align="left" valign="top"></td>
        </tr>
         <tr>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01">Phone:</td>
          <td valign="top"><input name="primaryPhone" type="text" value=""
       	   class="field-blue-01-120x20" maxlength="50"/></td>
          
          
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01">Fax:</td>
          <td valign="top"><input name="primaryFax" type="text" value=""
       	   class="field-blue-01-120x20" maxlength="50"/></td>
       	   
       	   
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01">Email:</td>
          <td valign="top"><input name="primaryEmail" type="text" value=""
       	   class="field-blue-01-120x20" maxlength="50"/></td>
       	   
          </tr>

          <tr>
           <td colspan="12" height="10" align="left" valign="top" class="back-white">&nbsp;</td>
          </tr>
          <tr>
           <td colspan="12" height="10" align="left" valign="top"></td>
          </tr>


          <tr>
          <td width="10" height="20" valign="top">&nbsp;</td>
          <td width="100" valign="top" class="text-blue-01">Mobile:</td>
          <td valign="top"><input name="primaryMobile" type="text" value=""
	     	   class="field-blue-01-120x20" maxlength="50"/></td>

	      <td width="10" height="20" valign="top">&nbsp;</td>

          </tr>



          </table></td>
        </tr>

        <tr>
          <td height="10" align="left" valign="top" class="back-white">&nbsp;</td>

        </tr>

        <tr>
          <td width="200" valign="top" class="text-blue-01">
            <div>
             <input id="guestCheckBox" type="checkbox" name="guestCheckBox" dojoType="dijit.form.CheckBox">
             </input> Add to My List
            </div>
          </td>
        </tr>

        <tr>
          <td height="10" align="left" valign="top"></td>

        </tr>

        <tr>
          <td height="10" align="left" valign="top" class="back-white"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="10" height="20">&nbsp;</td>
              <td class="text-blue-01" width="20">
					<div style="padding-top:10px;padding-bottom:15px;" align="center">
						<input type="button" value="" id="addGuestOLButton" name="Submit33" style="background : url(images/save1.jpg);width:58px; height:24px;" onclick="this.disabled = true; javascript:addGuest()" />
					</div>
			 </td>
              <td class="text-blue-01" width="20">&nbsp;</td>
              <td class="text-blue-01">&nbsp;</td>
            </tr>

 </form>
          </table></td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top" class="back-white">&nbsp;</td>
        </tr>
        <tr>
          <td height="10" align="left" valign="top"></td>
        </tr>

	</table>
			<br><br><br><br>
			<br>
			<br><br><br>

		</td>
		</tr>
	</table>

</div>
<%@ include file="footer.jsp" %>
