<%@ include file = "imports.jsp" %>
<%@ page import="com.openq.web.controllers.Constants" %>
<%@ page import="java.lang.StringBuffer"%>
<%@ page import="com.openq.eav.option.OptionNames"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<script type="text/javascript" src="js/json.js"></script>
<script type="text/javascript" src="js/utilities/JSONError.js"></script>


<%String parentJsonObj=(String)request.getAttribute("parentJsonObj");%>


<%
            OptionNames[] displayOptionName = (OptionNames[]) request
            .getSession().getAttribute("displayOptionName");
    OptionLookup[] displayList = (OptionLookup[]) request.getSession()
            .getAttribute("displayList");

    OptionLookup[] parentList = null;
    if (request.getSession().getAttribute("parentList") != null) {
        parentList = (OptionLookup[]) request.getSession()
        .getAttribute("parentList");
    }

    String [] parentOfOptionvalues = null;
    if(request.getSession().getAttribute("parentOfOptionvalues") != null) {
        parentOfOptionvalues = (String [])request.getSession().getAttribute("parentOfOptionvalues");
    }
    
    String [] parentOfOptionNames = null;
    if(request.getSession().getAttribute("parentOfOptionNames") != null) {
        parentOfOptionNames = (String []) request.getSession().getAttribute("parentOfOptionNames");
    }
    
    String[] grandParentList = null;
    if(request.getSession().getAttribute("grandParentList") != null) {
        grandParentList = (String []) request.getSession().getAttribute("grandParentList");
    }
    
    long existingDefaultValue = 0;
    StringBuffer existingDisplayOrder = new StringBuffer("");
    Map entityGroupMap = (Map) request.getAttribute("LOV_VALUE_PERMISSION_MAP");
    request.removeAttribute("LOV_PERMISSION_MAP");
    
%>

<script src="<%=COMMONJS%>/validation.js"></script>
<script src="<%=COMMONJS%>/dragAndDropTableRows.js"></script>
<script language="javascript" src="js/groupLevelSecurity.js"></script>
<script>
<%if((String) request.getSession().getAttribute("NEW_OPTION_NAME")!=null){%>
parent.tree.document.location.replace(src="valueList.htm?action=listTree");
<%request.getSession().removeAttribute("NEW_OPTION_NAME");
}%>

var parentDataJsonObj = '<%=parentJsonObj%>'
function updateParentChild(parentId,updatedValue, listId)
{
    document.list.updateField.value = updatedValue;
    document.list.updateListID.value = listId;
    document.getElementById("addFieldId").style.display="none"
    document.getElementById("addButtonId").style.display="none"
    document.getElementById("addValueId").style.display="none"
    document.getElementById("updateFieldId").style.display="block"
    document.getElementById("updateButtonId").style.display="block"
    document.getElementById("updateValueId").style.display="block"
    document.getElementById("addListButton").style.display="none"
    document.getElementById("updateListButton").style.display="block"
    
    var oselect= document.getElementById("optionLookupSelect");
    for(var x=0; oselect != null && x<oselect.length; x++)
    {    
         if(oselect[x].value == parentId )
        {
             oselect[x].selected=true;
             oselect[x].focus = true;
        }
    }
}
function update(updatedValue, listId){
    
    document.list.updateField.value = updatedValue;
    document.list.updateListID.value = listId;
    
    document.getElementById("addFieldId").style.display="none"
    document.getElementById("addButtonId").style.display="none"
    document.getElementById("addValueId").style.display="none"

    document.getElementById("updateFieldId").style.display="block"
    document.getElementById("updateButtonId").style.display="block"
    document.getElementById("updateValueId").style.display="block"
}

function updateOption(updatedOption, optionId)
{
    document.list.updateOptionName.value = updatedOption
    document.list.updateOptionNameId.value = optionId
    
    document.getElementById("addOptionId").style.display="none" 
    document.getElementById("addNewOptionTd").style.display="none"
    document.getElementById("addNewOptionId").style.display="none"
    
    document.getElementById("updateOptionId").style.display="block"
    document.getElementById("updateOptionTd").style.display="block"
    document.getElementById("updateOptionbutton").style.display="block"
}

function checkForNull()
{
    var thisform = document.list;
        if(thisform.newOption != null && thisform.newOption.value != "" && thisform.newOption.value != null)
            thisform.submit();
        if(thisform.newList != null && thisform.newList.value != null && thisform.newList.value != "")
            thisform.submit();
        if(thisform.updateField != null && thisform.updateField.value != null && thisform.updateField.value != "")
        {
            thisform.submit();
        }
}
var state = new Array;
function toggleRadioButton(radioButton){
    var defaultValueAction = document.list.defaultValueAction;
    
    if (state[radioButton.name] && state[radioButton.name] == radioButton.value) {
        radioButton.checked = false;
        state[radioButton.name] = '';
        defaultValueAction.value="<%=ActionKeys.DELETE_DEFAULT_LOV_VALUE%>";
    } else {
        radioButton.checked = true;
        state[radioButton.name] = radioButton.value;
        document.list.newDefaultValue.value = radioButton.value;
        defaultValueAction.value="<%=ActionKeys.SET_DEFAULT_LOV_VALUE%>";
    }
    return true;
}


function saveLOVChanges(){
var table = document.getElementById('displayOptionTable');
var newDisplayOrder = document.getElementById('newDisplayOrder');
var newDisplayOrderString = "";
var displayOrder = 1;
for(i=0;i<table.rows.length;i++){
    var row = table.rows[i];
    if(row.name == "lovValues"){
        var optionLookupIdDisplayOrder = row.id + ":" + displayOrder;
        newDisplayOrderString = newDisplayOrderString + "," + optionLookupIdDisplayOrder;
        displayOrder++;
    }
}
newDisplayOrder.value = newDisplayOrderString.substring(1);
document.list.submit();
}
</script>


<HTML>

<HEAD>
    <TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>

<BODY class="">


<form name="list" method="post">

  <div class="contentmiddle">
  <div class="producttext" style=width:100%;height=300;overflow:auto>
    <div class="myexpertlist">
    <table width="100%;height:100">
        <tr style="color:#4C7398">
        <td width="25%" align="left">
          <%
            String displayOption = request.getParameter("displayOption");
            String selectedOptionId = (String) request.getSession()
                    .getAttribute("selectedOptionId");
            String listName = null;
            for (int i = 0; i < displayOptionName.length; i++) {
                if (displayOptionName[i].getId() == Integer
                .parseInt(selectedOptionId)) {
                    listName = displayOptionName[i].getName();
                    break;
                }
            }
            if (displayOption == null) {
          %>
          
                    <div class="myexperttext">Options</div>
          <%
          } else if (displayOption != null) {
          %>
                    <div class="myexperttext">List of values for <%=listName%><input type="hidden" name="optionIdForList" value="1"></div>          
       <%
                   }
                   %>
        </td>
        <td  width="20%" align="left">
            <div class="myexperttext">Parent</div>
        </td>
        <td  width="20%" align="left">
            <div class="myexperttext">Default Value</div>
        </td>
         <td  width="25%" align="left">
            <div class="myexperttext">Restricted User Groups</div>
        </td>
        <td  width="10%" align="left">
            <div class="myexperttext">Change User Groups</div>
        </td>
        </tr>
      </table>
    </div>
    <table width="100%" cellspacing="0" scrolling="yes" id="displayOptionTable">
      <%
            if (displayOption == null) {

            for (int i = 0; i < displayOptionName.length; i++) {
                if (displayOptionName[i].getName() != null
                && !displayOptionName[i].getName().equals("null")) {
      %>

                        <tr bgcolor='<%=(i % 2 == 0 ? "#fafbf9" : "#f5f8f4")%>'>
                          <td width="10" height="20" valign="top">&nbsp;</td>
                          <td width="20">&nbsp;</td>
                          <td class="expertListHeader"><%=displayOptionName[i].getName()%></td>
                          <%
                          //if(parentOfOptionvalues != null){
                          %>
                          <td class="expertListHeader"><%=parentOfOptionNames[i]%></td>
                          <%
                          //}
                          %>
                        </tr>
        
                    <%
                                    }
                                    }

                                } else {
                                    if (Integer.parseInt(selectedOptionId) != -1
                                    && displayList.length > 0) {
                            %>
                        <%
                                for (int i = 0; i < displayList.length; i++) {
                                String checked = "";
                                if (displayList[i].isDefaultSelected()) {
                                    checked = "checked";
                                    existingDefaultValue = displayList[i].getId();
                                }
                                existingDisplayOrder.append(",").append(
                                        displayList[i].getId()).append(":").append(
                                        i + 1);
                                String restrictedGroups = "";
                                Long lovIdLong = new Long(displayList[i].getId());
                                if (entityGroupMap != null
                                        && entityGroupMap.containsKey(lovIdLong)
                                        && entityGroupMap.get(lovIdLong) != null)
                                    restrictedGroups = entityGroupMap.get(lovIdLong)
                                    + "";
                        %>
                        <tr bgcolor='<%=(i % 2 == 0 ? "#fafbf9" : "#f5f8f4")%>' name="lovValues" id="<%=displayList[i].getId()%>">
                        <td width="10" height="20" valign="top">&nbsp;</td>
                          <td width="20">&nbsp;</td>
                          <td class="expertListHeader" width="3%">
                            <p align="center">
                            <input type="checkbox" name="check<%=displayList[i].getId()%>" value="ON" <% if(displayList[i].getDeleteFlag().equalsIgnoreCase("Y")) { %>checked="checked"<% }%>/></td>
                          <td width="25%" class="expertListHeader">
                          
                          <a href="#" class="text-blue-01-link" onclick="javascript:updateParentChild('<%=displayList[i].getParentId()%>','<%=displayList[i].getOptValue()%>','<%=displayList[i].getId()%>');"><%=displayList[i].getOptValue()%></a>
                          <input type="hidden" name="listID" value="<%=displayList[i].getId()%>"/>  
                            
                          </td>
                          <%
                          //if(parentOfOptionvalues[i] != null){
                          %>
                           <td width="20%" class="expertListHeader"><%=parentOfOptionvalues[i]%></td>
                           <td width="20%" class="expertListHeader"><input type="radio" name="defaultSelectedOptionRadio" value="<%=displayList[i].getId()%>" <%=checked%> onClick="toggleRadioButton(this)">
                           </td>
                            <td width="25%" class="text-blue-01" id="permittedGroupsTd<%=displayList[i].getId()%>"value="<%=restrictedGroups%>"><%=restrictedGroups%></td>
                            <td width="10%" class="expertListHeader">
                                <img src="images/configure.gif" onclick="showGroupChangerPopup('<%=displayList[i].getId()%>','<%=Constants.LOV_VALUE_PERMISSION_ID%>')" style="cursor: pointer;">
                            </td>
                           <%
                           //}
                           %>
                        </tr>
        
                        <%
                                }
                                %>
                        
                     <%
                                             }
                                             %>

                    <%
                    }
                    %>
            
            </table> 
    </div>
    <%
    if (displayOption != null) {
    %>
    <table cellspacing="0">             <tr class="back-grey-02-light" >
                          <td width="10" height="20" valign="top">&nbsp;</td>
                          <td width="1%">&nbsp;</td>
                          <td class="text-blue-01" width="10%" colspan="1">
                          &nbsp;<input type="submit" name="delLov" class="button-01" value=""style="border:0;background : url(images/buttons/delete.gif);width:73px; height:22px;" value="  Delete  "/>
                            </td>
                          <td class="text-blue-01" width="10%" colspan="1">
                          &nbsp;
                           <input type="hidden" name="newDisplayOrder" value=""/>
                           <input type="hidden" name="newDefaultValue" value=""/>
                          <input type="hidden" name="defaultValueAction" value=""/>
                          <input type="hidden" name="existingDefaultValue" value="<%=existingDefaultValue%>"/>
                          <input type="hidden" name="existingDisplayOrder" value="<%=(existingDisplayOrder != null
                                        && !"".equals(existingDisplayOrder
                                                .toString()) ? existingDisplayOrder
                                        .substring(1)
                                        : "")%>"/>
                        <input type="button" name="saveLOVChangesButton" class="button-01" value=""style="border:0;background : url(images/buttons/save.gif);width:73px; height:22px;" 
                          value="" onClick="saveLOVChanges()"/>
                            </td>  
                        <td width="80%"></td>
                    </tr>
    </table>
    <%
    }
    %>                  
          <br>
          <div class="producttext">
             <div class="myexpertplan">
                <table width="100%">
                    <tr style="color:#4C7398">
                        <td align="left">
                            <%
                            if (displayOption == null) {
                            %>
                               <div id="addOptionId" class="myexperttext">Add New Option</div>
                               <%
                               } else {
                               %>
                               <div id="addValueId" style="display:block" class="myexperttext">Add New Value</div>
                               <div id="updateValueId" style="display:none" class="myexperttext">Edit Value</div>
                               <%
                               }
                               %>
                        </td>
                    </tr>
                </table>
             </div>
             <table width="100%" cellspacing="0" cellpadding="0">
        
            <tr>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
             </tr>
              <%
              if (displayOption == null) {
              %>
              <tr>
            <td id="addNewOptionTd" width="20%" valign="middle" style="display:block" class="text-blue-01">
                Option Name:&nbsp;<input name="newOption" type="text" class="field-blue-01-340x20"> 
            </td>
            <td width="20%" height="20" valign="top"><br>&nbsp;</td>
            <td width="20%" height="20" valign="top"><br>&nbsp;</td>
            </tr>
            <tr>
            <td width="20%" valign="middle" id="addFieldId" style="display:block" class="text-blue-01" height="40">
                Parent:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="optionSelect" class="field-blue-01-340x20">
                <option value="-1" selected>None</option>
                <%
                            if (displayOptionName != null) {
                            for (int i = 0; i < displayOptionName.length; i++) {
                %>
                <option value="<%=displayOptionName[i].getId()%>"><%=displayOptionName[i].getName()%></option>
                <%
                        }
                        }
                %>  
                </select>&nbsp;&nbsp;
                <input name="addNewOption" type="button" class="button-01" value=""style="border:0;background : url(images/buttons/add_new_option.gif);width:123px; height:22px;" class="button-01" onclick="javascript:checkForNull()"/>
            </td>
            <td width="20%" height="20" valign="top"><br>&nbsp;</td>
            <td width="20%" height="20" valign="top"><br>&nbsp;</td>
            </tr>
              <tr>
              <td id="addNewOptionId" width="20%" valign="middle" style="display:block">&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              </tr>
              <%
              } else {
              %>
              <tr>
              <td width="20%" valign="middle" id="addFieldId" style="display:block" class="text-blue-01" height="40">
                  Value:&nbsp;&nbsp;<input name="newList" type="text" class="field-blue-01-340x20" >
                &nbsp;&nbsp;
              </td>
              <td width="20%" valign="middle" id="updateFieldId" style="display:none" class="text-blue-01" height="40">
                  Value:&nbsp;&nbsp;<input name="updateField" type="text" class="field-blue-01-340x20">
              </td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              </tr>
              <tr>
              <td width="20%" valign="middle" id="addFieldId" name="updateParentOrChild" style="display:block" class="text-blue-01" height="40">    
                Parent:&nbsp;<select id="optionLookupSelect" name="optionLookupSelect" class="field-blue-01-340x20">
                <option value="-1" selected>None</option>
                    <%
                            if (parentList != null) {
                            for (int i = 0; i < parentList.length; i++) {
                                if(grandParentList[i]!=null) {
                    %>
                    <option value="<%=parentList[i].getId()%>"><%=parentList[i].getOptValue() + "~" + grandParentList[i]%></option>
                    <%} else {%>
                    <option value="<%=parentList[i].getId()%>"><%=parentList[i].getOptValue()%></option>                
                    <%  }}} %>  
                </select>&nbsp;&nbsp;
               </td>
               <td width="20%" height="20" valign="middle">
                <div id="addListButton" style=display:block;>
                <input name="addlist" type="button" value="" style="border:0;background : url(images/buttons/add_new_value.gif);width:118px; height:22px;" class="button-01" onclick="javascript:checkForNull()"/>
                </div>
                <div id="updateListButton" style=display:none;>
                <input name="updateButton" type="button" style="border:0;background : url(images/buttons/update.gif);width:74px; height:22px;" class="button-01" value="" onclick="javascript:checkForNull()"/>
                </div>
              </td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              </tr>
              <tr>
              <td valign="middle" id="addButtonId" style="display:block" width="20%">&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
            </tr>
              <tr>
              <td width="20%" height="20" valign="top">
                <input name="updateListID" type="hidden" value=""/>
              </td>
              <td id="updateButtonId" style="display:none" width="20%">
                <input name="deleteListId" type="hidden" value=""/>
              </td>
              <td width="20%" height="20" valign="top"><br>&nbsp;</td>
               <% } %>
           </tr>
      </table>
    <script>
        dragAndDrop(document.getElementById('displayOptionTable'));
    </script>        
             
             
          </div>  
  
 </form>
</BODY>
</HTML>
