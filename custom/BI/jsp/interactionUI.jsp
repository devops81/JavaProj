<%@ page import="com.openq.user.User"%>
<%@ page import="com.openq.eav.option.OptionLookup"%>
<%@ page import="com.openq.attendee.Attendee"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.openq.interactionData.InteractionData"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.openq.interaction.Interaction"%>
<%@ page import="com.openq.kol.DBUtil"%>

<script type="text/javascript">
	function showHideDiv(divId) {
		if (document.getElementById) {
			thisDiv = document.getElementById(divId).style
				if (thisDiv.display == "block") {
					thisDiv.display = "none"
				}else {
				thisDiv.display = "block"
			   }
				return false
		}else {
		return true
		}
	}
	
	function showDiv(divId){
	  if(document.getElementById){
	    thisDiv=document.getElementById(divId).style
	       thisDiv.display="block";
	       return false
	  }else{
	    return true 
	  }
	}
	
	function hideDiv(divId){
	  if(document.getElementById){
	    thisDiv=document.getElementById(divId).style
	       thisDiv.display="none";
	       return false
	  }else{
	    return true 
	  }
	}
</script>
<!-- Description starts here -->
<%if(prop1.getProperty("DESCRIPTION").equals("true")) { %>
   <tr>
     <td>
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="descriptionImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('description')"/>&nbsp;&nbsp;Description
         </div>
         <div id="descriptionContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">
            <!-- same as old code -->
             <tr>
                <td width="10" height="20">&nbsp;</td>
		        <% if (!"view".equalsIgnoreCase(mode)) { %>
                    <td width="295" class="text-blue-01">Selection</td>
                    <td width="320" align="center" class="text-blue-01-bold">&nbsp;</td>
		        <% } %>
                <td width="260" class="text-blue-01"></td><td class="text-blue-01">&nbsp;</td>
            </tr>
            <tr>
                <td height="20">&nbsp;</td>
		        <% if (!"view".equalsIgnoreCase(mode)) { %>
                <td width="190" class="text-blue-01" valign="top">
		            <input type=textbox name="description_text"  class="field-blue-13-260x100" >
		        </td>
                <td class="text-blue-01"  valign="top">
                    <table width="100%"   border="0" cellpadding="0" cellspacing="0">
                    <tr><td align="center" valign="top">&nbsp;</td></tr>
                    <tr><td align="center" valign="top">
			                <input type="button" onclick="javascript:copySelectedFromTextArea(forms[0].description_text,forms[0].Description);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_description"/>
			            </td>
                    </tr>
                    <tr>
                        <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
                    </tr>
                    <tr>
                        <td align="center" valign="top">
			                <input type="button" onclick="javascript:deleted(forms[0].Description);" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_description"/>
			            </td>
                    </tr>
                    </table>
                 </td>
		        <% } %>
	            <td class="text-blue-01">
		            <select name="Description" multiple class="field-blue-13-260x100"
                    <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
                    <%  Set Description = interaction != null && null != interaction.getInteractionDataOnType("Description") ? interaction.getInteractionDataOnType("Description") : new HashSet();
                        if (interaction != null && Description != null )
                        {
                            InteractionData interactionData = new InteractionData();
                            Iterator itr = Description.iterator();
                            while(itr.hasNext()){
                            interactionData = (InteractionData)itr.next();
                            %>
			                    <option value="<%=interactionData.getData()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%= interactionData.getData() %></option>
                            <% }
                       }
                     %>
                     </select>
		          </td>
		          <td class="text-blue-01">&nbsp;</td>
                  <td class="text-blue-01">&nbsp;</td>
            </tr>
     </table>

    <!-- old code ends here -->
      </div>
     </div>
    </td>
   </tr>
   <!-- Description ends here -->
<%
}
if(prop1.getProperty("HCP_EXPENSE").equals("true"))
{ %>
   <tr>
     <td>
       <div class="reset colOuter">
         <div class="colTitle">
               <img id="expTypeImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('expType')"/>&nbsp;&nbsp;<%=prop1.getProperty("EXPERT_EXPENSE_TITLE")%>
         </div>
         <div id="expTypeContent" class="colContent">
           <table width="auto"  border="0" cellspacing="0" cellpadding="0">

<!-- same as old code -->

      <tr>
        <td width="10" height="20" valign="top">&nbsp;</td>
        <td width="180" valign="middle" class="text-blue-01">Expense Type</td>
        <td width="20" valign="middle" class="text-blue-01">&nbsp;</td>
        <td width="180" valign="middle" class="text-blue-01">Expense Venue</td>
        <td width="20" valign="middle" class="text-blue-01">&nbsp;</td>
        <td width="180" valign="middle" class="text-blue-01">Expense Amount</td>
        <td valign="middle" class="text-blue-01">&nbsp;</td>
      </tr>
      <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td valign="top">
		  <select name="expenseType" class="field-blue-01-180x20" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> onchange="changeExpenseVenue();changeExpenseAmount();">
          <%
		    boolean found = false;
            if (expenseTypeLookup != null && expenseTypeLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < expenseTypeLookup.length; i++) {
                    lookup = expenseTypeLookup[i];
          %>
			<option value="<%=lookup.getId()%>" <%  if (interaction != null && interaction.getExpenseType() != null && interaction.getExpenseType().getId() == lookup.getId()) { found = true; %> selected <% } else if("No Expense".equals(lookup.getOptValue()) && !found) { %> selected  <% } %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		</td>
        <td height="20" valign="top">&nbsp;</td>
        <td valign="top">
		  <select name="expenseVenue" class="field-blue-01-180x20" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> onchange="changeExpenseAmount()">

          <%
            if (expenseVenueLookup != null && expenseVenueLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < expenseVenueLookup.length; i++) {
                    lookup = expenseVenueLookup[i];
          %>
			<option value="<%=lookup.getId()%>" <% if (interaction != null && interaction.getExpenseVenue() != null && interaction.getExpenseVenue().getId() == lookup.getId()) { %> selected <% } %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		</td>
        <td valign="top">&nbsp;</td>
        <td valign="top"><input name="amount" type="text" class="field-blue-01-180x20" maxlength="7" <% if (interaction != null) { %> value="<%=interaction.getAmount()%>" <% } %> <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> ></td>
        <td valign="top" class="text-blue-01"><p align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></td>
        </tr>

      <% for ( int i=0; i< prop1.size(); i++)
      {
           int j = i + 1;
           String key1 =   "interaction-"+j;
           String comment = prop1.getProperty(key1);

           if(comment!=null){
            %>
     <tr>
        <td width="10" height="20" valign="top">&nbsp;</td>
        <%if(comment!=null) {%>
        <td colspan="6" valign="middle" class="text-blue-01">
            <%= comment %>
        </td>
        <%} %>
      </tr>
        <% }//end of comment=null
        } %>

    </table>
    </div>
    </div>
    </td>
  </tr>
<%}
if(prop1.getProperty("PRODUCT_TYPE").equals("true"))
{%>
<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="productImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('product')"/>&nbsp;&nbsp;<%=prop1.getProperty("PRODUCT_TITLE")%>
      </div>
      <div id="productContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">

 <!-- same as old code -->

       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="295" class="text-blue-01">Selection</td>
         <td width="320" align="center">&nbsp;</td>
		 <% } %>
         <td width="260" class="text-blue-01">Product</td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="190" class="text-blue-01" valign="top">
		  <select name="select4" multiple class="field-blue-13-260x100">
		  <%
            if (productsLookup	 != null && productsLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < productsLookup.length; i++) {
                    lookup = productsLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		 </td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
             <tr>
               <td align="center" valign="top">&nbsp;</td>
             </tr>
             <tr>
               <td align="center" valign="top">
			    <input type="button" onclick="javascript:copySelected(forms[0].select4,forms[0].productsList);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_product"/>
			   </td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top">
			    <input type="button" onclick="javascript:deleted(forms[0].productsList);" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_product"/>
			   </td>
             </tr>
         </table></td>
		 <% } %>
         <td class="text-blue-01">
		   <select name="productsList" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %>>
		  <%
              Set products = interaction != null && null != interaction.getInteractionDataOnType("Products") ? interaction.getInteractionDataOnType("Products") : new HashSet();

           if (interaction != null && products != null ) {
              InteractionData interactionData = new InteractionData();

                  Iterator itr = products.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();

          %>
			<option value="<%=interactionData.getLovId().getId()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=interactionData.getLovId().getOptValue() %></option>
          <%    }

            }
          %>
           </select>
		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
   </tr>
<%}%>
<!-- Pre call plan starts here -->
<%if(prop1.getProperty("PRE_CALL_PLAN").equals("true"))
{%>
<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="productImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('product')"/>&nbsp;&nbsp;<%=prop1.getProperty("PRECALL_PLAN_TITLE")%>
      </div>
      <div id="productContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">
 
       <tr>
         <td height="20">&nbsp;</td>
         
         <% 
            Set valueForCheckBox = interaction != null && null != interaction.getInteractionDataOnType("Pre Call Plan") ? interaction.getInteractionDataOnType("Pre Call Plan") : new HashSet();
              if (interaction != null && valueForCheckBox != null ) {
              InteractionData interactionData = new InteractionData();
                  
                  Iterator itr = valueForCheckBox.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();
                    
                   }       
                 
         %>
         
          <td width=20px class="text-blue-01"><input type=radio name="preCallCkBox" <%="yes".equalsIgnoreCase(interactionData.getData())?"checked":"" %> value="yes">Yes</td>
          <td width=10px>&nbsp;</td>
          <td width=20px class="text-blue-01"><input type=radio name="preCallCkBox" <%="no".equalsIgnoreCase(interactionData.getData())?"checked":"" %> value="no">No</td>
          <%}else{ %>
          <td width=20px class="text-blue-01"><input type=radio name="preCallCkBox" value="yes">Yes</td>
          <td width=10px>&nbsp;</td>
          <td width=20px class="text-blue-01"><input type=radio name="preCallCkBox" checked value="no">No</td>
          
          <%} %>
       </tr>
      </table>
     </div>
    </div>
   </td>
  </tr>    
         
<%}%>
<!-- Pre call plan ends here -->


<%if(prop1.getProperty("SCENTIFIC_TOPICS").equals("true"))
{%>

<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="sciTopicImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('sciTopic')"/>&nbsp;&nbsp;Scientific Topics
      </div>
      <div id="sciTopicContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">

 <!-- same as old code -->


      <tr>
        <td width="10" height="20">&nbsp;</td>
		<% if (!"view".equalsIgnoreCase(mode)) { %>
        <td width="295" class="text-blue-01">Selection</td>
        <td width="320" align="center" class="text-blue-01-bold">&nbsp;</td>
		<% } %>
        <td width="260" class="text-blue-01"><%=prop1.getProperty("TOPIC_HEADER")%></td>
        <td class="text-blue-01">&nbsp;</td>
      </tr>
      <tr>
        <td height="20">&nbsp;</td>
		<% if (!"view".equalsIgnoreCase(mode)) { %>
        <td width="190" class="text-blue-01" valign="top">
		  <select name="select1" multiple class="field-blue-13-260x100">
		  <%
            if (scientificTopicsLookup != null && scientificTopicsLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < scientificTopicsLookup.length; i++) {
                    lookup = scientificTopicsLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		</td>
        <td class="text-blue-01"  valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="center" valign="top">&nbsp;</td>
            </tr>
            <tr>
              <td align="center" valign="top">
              <input type="button" onclick="javascript:copySelected(forms[0].select1,forms[0].scientificTopics);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_sci"/>
			  </td>
            </tr>
            <tr>
              <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
            </tr>
            <tr>
              <td align="center" valign="top">
			  <input type="button" onclick="javascript:deleted(forms[0].scientificTopics);" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_sci"/>
			  </td>
            </tr>
        </table></td>
		<% } %>
        <td class="text-blue-01">
		  <select name="scientificTopics" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
		  <%
		    Set topicList = interaction != null && null != interaction.getInteractionDataOnType("Scientific Topics") ?  interaction.getInteractionDataOnType("Scientific Topics") : new HashSet();
            if (interaction != null && topicList != null ) {
                InteractionData interactionData = new InteractionData();

                    Iterator itr = topicList.iterator();
                     while(itr.hasNext()){
                      interactionData = (InteractionData)itr.next();

             %>
			<option value="<%=interactionData.getLovId().getId()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=interactionData.getLovId().getOptValue()%></option>
          <%    }

            }
          %>
          </select>
		</td>
        <td class="text-blue-01">&nbsp;</td>
      </tr>
    </table>
    </div>
    </div>
    </td>
  </tr>

<%}%>
<!--Idhar-->
  <% if(prop1.getProperty("MATERIALS").equals("true")){ %>

 <tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="reqForLBMImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('reqForLBM')"/>&nbsp;&nbsp;Scientific Platform Objectives
      </div>
      <div id="reqForLBMContent" class="colContent">
      <table width="auto"  border="0" cellspacing="0" cellpadding="0">
       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="295" class="text-blue-01">Selection</td>
         <td width="320" align="center">&nbsp;</td>
		 <% } %>
         <td width="260" class="text-blue-01">Objectives Selected</td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
       <tr>
            <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
		  <td width="190" class="text-blue-01" valign="top">
		  <select name="select3" multiple class="field-blue-13-260x100">
		  <%
            if (materialsLookup	 != null && materialsLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < materialsLookup.length; i++) {
                    lookup = materialsLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>



		 </td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
             <tr>
               <td align="center" valign="top">&nbsp;</td>
             </tr>
             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="copySelected(forms[0].select3,forms[0].materialsList)" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_material"/>
			   </td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="deleted(forms[0].materialsList)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_materials"/>
			   </td>
             </tr>
         </table></td>

          <% } %>

         <td class="text-blue-01">
		   <select name="materialsList" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %>>
                               <%
              Set materialsSet = interaction != null && null != interaction.getInteractionDataOnType("Materials") ? interaction.getInteractionDataOnType("Materials") : new HashSet();

           if (interaction != null && materialsSet != null ) {
              InteractionData interactionData = new InteractionData();

                  Iterator itr = materialsSet.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();
                    OptionLookup optionLookup = interactionData.getLovId();
                    if(optionLookup != null){

          %>
			<option value="<%=optionLookup.getId()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%= optionLookup.getOptValue() %></option>
          <%    		}
                   }
            }
          %>

           </select>
		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </DIV></DIV>
     </td>
   </tr>
<%}%>

<% if(prop1.getProperty("OTHER_SCIENTIFIC_TOPICS").equals("true"))
{%>
<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="OthersciTopicImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('OthersciTopic')"/>&nbsp;&nbsp;<%=prop1.getProperty("SCIENTIFIC_PROPERTIES_OTHER_TITLE")%>
      </div>
      <div id="OthersciTopicContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">

 <!-- same as old code -->

      <tr>
        <td width="10" height="20">&nbsp;</td>
		<% if (!"view".equalsIgnoreCase(mode)) { %>
        <td width="295" class="text-blue-01">Selection</td>
        <td width="320" align="center" class="text-blue-01-bold">&nbsp;</td>
		<% } %>
        <td width="260" class="text-blue-01">Other Topics Discussed</td>
        <td class="text-blue-01">&nbsp;</td>
      </tr>
       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="190" class="text-blue-01" valign="top">
		  <input type=textbox name="other_Topics"  class="field-blue-13-260x100" >
		 </td>
         <td class="text-blue-01"  valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="center" valign="top">&nbsp;</td>
            </tr>
            <tr>
              <td align="center" valign="top">
			  <input type="button" onclick="javascript:copySelectedFromTextArea(forms[0].other_Topics,forms[0].otherTopics);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_Osci"/>
			  </td>
            </tr>
            <tr>
              <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
            </tr>
            <tr>
              <td align="center" valign="top">
			  <input type="button" onclick="deleted(forms[0].otherTopics)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_Osci"/>
			  </td>
            </tr>
        </table></td>
		 <% } %>
		 <td class="text-blue-01">
		  <select name="otherTopics" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
          <%
              Set otherTopicsSet = interaction != null && null != interaction.getInteractionDataOnType("Other Scientific Topics") ? interaction.getInteractionDataOnType("Other Scientific Topics") : new HashSet();

           if (interaction != null && otherTopicsSet != null ) {
              InteractionData interactionData = new InteractionData();

                  Iterator itr = otherTopicsSet.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();

          %>
			<option value="<%=interactionData.getData()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%= interactionData.getData() %></option>
          <%    }
          }
          %>
          </select>
		</td>
        <td class="text-blue-01">&nbsp; </td>
        <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
   </tr>
   <!-- other interaction property -->
   <%}
if(prop1.getProperty("OTHER_INTERACTION_ACTIVITY").equals("true"))
{ %>
<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="OtherIntActImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('OtherIntAct')"/>&nbsp;&nbsp;Key clinical/scientific discussion points
      </div>
      <div id="OtherIntActContent" class="colContent">
      <table width="auto"  border="0" cellspacing="0" cellpadding="0">

      <tr>
        <td width="10" height="20">&nbsp;</td>
		<% if (!"view".equalsIgnoreCase(mode)) { %>
        <td width="295" class="text-blue-01">Selection</td>
        <td width="320" align="center" class="text-blue-01-bold">&nbsp;</td>
		<% } %>
        <td width="260" class="text-blue-01">Other Interaction Activities</td>
        <td class="text-blue-01">&nbsp;</td>
      </tr>
      <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="190" class="text-blue-01" valign="top">
		  <input type=textbox name="other_interaction_activities"  class="field-blue-13-260x100" >

	   </td>

        <td class="text-blue-01"  valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td align="center" valign="top">&nbsp;</td>
            </tr>
            <tr>
              <td align="center" valign="top">
			  <input type="button" onclick="copySelectedFromTextArea(forms[0].other_interaction_activities,forms[0].otherInteractionActivities)" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_Oint"/>
			  </td>
            </tr>
            <tr>
              <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
            </tr>
            <tr>
              <td align="center" valign="top">
			  <input type="button" onclick="deleted(forms[0].otherInteractionActivities)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_Oint"/>
			  </td>
            </tr>
        </table></td>

		 <% } %>

		         <td class="text-blue-01">
		  <select name="otherInteractionActivities" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
                    <%
              Set otherActivitiesSet = interaction != null && null != interaction.getInteractionDataOnType("Other Interaction Activities") ? interaction.getInteractionDataOnType("Other Interaction Activities") : new HashSet();

           if (interaction != null && otherActivitiesSet != null ) {
              InteractionData interactionData = new InteractionData();

                  Iterator itr = otherActivitiesSet.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();

          %>
			<option value="<%=interactionData.getData()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%= interactionData.getData() %></option>
          <%    }

            }
          %>

          </select>
		</td>

         <td class="text-blue-01">&nbsp;

		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
   </tr>
   <!-- ends here -->
<%}if(prop1.getProperty("INTERACTION_ACTIVITY").equals("true")){%>
<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="intActImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('intAct')"/>&nbsp;&nbsp;<%=prop1.getProperty("INTERACTION_ACTIITY_TITLE")%>
      </div>
      <div id="intActContent" class="colContent">
        <table width="auto"  border="0" cellspacing="0" cellpadding="0">

       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="295" class="text-blue-01">Selection</td>
         <td width="320">&nbsp;</td>
		 <% } %>
         <td width="260" class="text-blue-01">Activities Completed</td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="190" class="text-blue-01" valign="top">
		  <select name="select2" multiple class="field-blue-13-260x100">
		  <%
            if (interactionActivityLookup != null && interactionActivityLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < interactionActivityLookup.length; i++) {
                    lookup = interactionActivityLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		 </td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
             <tr>
               <td align="center" valign="top">&nbsp;</td>
             </tr>
             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="copySelected(forms[0].select2,forms[0].interactionActivityList)" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_Int"/>
			   </td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="deleted(forms[0].interactionActivityList)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_Int"/>
			   </td>
             </tr>
         </table></td>
		 <% } %>
         <td class="text-blue-01">
		   <select name="interactionActivityList" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
		  <%
              Set activityList = interaction != null && null != interaction.getInteractionDataOnType("Interaction Activity") ? interaction.getInteractionDataOnType("Interaction Activity") : new HashSet();

           if (interaction != null && activityList != null ) {
              InteractionData interactionData = new InteractionData();

                  Iterator itr = activityList.iterator();
                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();

          %>
			<option value="<%=interactionData.getLovId().getId()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=interactionData.getLovId().getOptValue() %></option>
          <%    }

            }
          %>
           </select>
		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
   </tr>

<%}
if(prop1.getProperty("SIM_SITE").equals("true"))
{ %>

<tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="simImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('sim')"/>&nbsp;&nbsp;SIM
      </div>
      <div id="simContent" class="colContent">
      <table width="auto"  border="0" cellspacing="0" cellpadding="0">

      <tr>
        <td width="10" height="20" valign="top">&nbsp;</td>
        <td width="180" valign="middle" class="text-blue-01">SIM</td>
        <td width="20" valign="middle" class="text-blue-01">&nbsp;</td>
        <td width="180" valign="middle" class="text-blue-01">Site Follow Up</td>
        <td valign="middle" class="text-blue-01">&nbsp;</td>
        </tr>
      <tr>
        <td height="20" valign="top">&nbsp;</td>
        <td valign="top">
		  <select name="sim" class="field-blue-01-180x20" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
		  <%
            if (simLookup != null && simLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < simLookup.length; i++) {
                    lookup = simLookup[i];
          %>
			<option value="<%=lookup.getId()%>" <% if (interaction != null && interaction.getSim().getId() == lookup.getId()) { %> selected <% } %>><%=lookup.getOptValue()%> </option>
          <%
                }
            }
          %>
          </select>
		</td>
        <td valign="top">&nbsp;</td>
        <td valign="top">
		  <select name="siteFollowUp" class="field-blue-01-180x20" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
		  <%
            if (siteFollowUpLookup != null && siteFollowUpLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < siteFollowUpLookup.length; i++) {
                    lookup = siteFollowUpLookup[i];
          %>
			<option value="<%=lookup.getId()%>" <% if (interaction != null && interaction.getSiteFollow().getId() == lookup.getId()) { %> selected <% } %>><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>
		</td>
        <td valign="top">&nbsp;</td>
        </tr>
    </table>
    </div></div>
    </td>
  </tr>

<%} %>

 
<%if(prop1.getProperty("LITERATURE").equals("true")){ %>
 <tr>
  <td>
    <div class="reset colOuter">
      <div class="colTitle">
            <img id="unsolImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('unsol')"/>&nbsp;&nbsp;Unsolicited Request For Literature to <%=DBUtil.getInstance().hcp%>
      </div>
      <div id="unsolContent" class="colContent">
      <table width="auto"  border="0" cellspacing="0" cellpadding="0">
       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="295" class="text-blue-01">&nbsp;</td>
         <td width="320" align="center">&nbsp;</td>
		 <% } %>
         <td width="260" class="text-blue-01"></td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="190" class="text-blue-01" valign="top">
		  <textarea name="literature"  class="field-blue-13-260x100"><%if(interaction != null && interaction.getLiterature() != null && !"".equals(interaction.getLiterature())) {%><%=interaction.getLiterature()%><%}%></textarea>
		 </td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">
             <tr>
               <td align="left" class="text-blue-01" valign="top"><i>Authors first initial and last name, Journal name, Volume Number, First page, and the Year published.
                </br></i></td>
             </tr>
             <tr>
               <td align="center" valign="top"></td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top"></td>
             </tr>
         </table></td>
		 <% } %>
         <td class="text-blue-01">&nbsp;

   		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
   </tr>
<%}if(prop1.getProperty("MEDICAL_REQUEST").equals("true"))
{%>
  <tr>
   <td>
    <div class="reset colOuter">
     <div class="colTitle">
           <img id="unsolMedReqImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('unsolMedReq')"/>&nbsp;&nbsp;Unsolicited Medical Request
     </div>
     <div id="unsolMedReqContent" class="colContent">
     <table width="auto"  border="0" cellspacing="0" cellpadding="0">

       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>

         <td width=20% class="text-blue-01">Physician</td>

         <td width=15%  class="text-blue-01">&nbsp;&nbsp;&nbsp;&nbsp;Product</td>
		 <td width=20% class="text-blue-01">Request</td>
         <td class="text-blue-01">&nbsp;</td>
         <% } %>
       </tr>


       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>

         <td width="150" class="text-blue-01" valign="top"><input type=textbox name="physician1"  class="field-blue-13-235x80" /></td>

		  <td width="150" class="text-blue-01" valign="top" align="center">
		  <select name="product_id" class="field-blue-01-120x20">
		  <%
            if (productsLookup != null && productsLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < productsLookup.length; i++) {
                    lookup = productsLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <% } }
          %>
          </select>		 </td>
         <td width="150" class="text-blue-01" valign="top"><input type=textbox name="request1"  class="field-blue-13-235x80" /></td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">

             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="addInteractionOptionandText(forms[0].medicalRequest, forms[0].product_id,'true', forms[0].physician1.value,forms[0].request1.value)" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_medical"/>			   </td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="deleteOptions(forms[0].medicalRequest)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_medical"/>			   </td>
             </tr>
         </table></td>
		 <% } %>
         <td class="text-blue-01">
		  <select name="medicalRequest" multiple class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %> >
		  <%
		   Set medicalRequest = interaction != null && null != interaction.getInteractionDataOnType("MedicalRequest") ? interaction.getInteractionDataOnType("MedicalRequest") : new HashSet();
           if (interaction != null && medicalRequest != null   ) {
              InteractionData interactionData = new InteractionData();


                  Iterator itr = medicalRequest.iterator();

                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();
                    String[] text=interactionData.getData().split("@");
                        String req= "";
                        String physician="";
                    if ( text.length > 2 )
                    {
                       req=text[0];
                       physician=text[1];
                    }

          %>
			<option value="<%=interactionData.getLovId().getId()+"@"+req+"@"+physician%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=interactionData.getLovId().getOptValue()+"( "+req+","+physician+" )" %></option>
          <% } }
          %>
          </select>
          <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
		 </td>
         <td class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
    </div></div>
   </td>
   </tr>
<% } %>
<!-- Medical request with policy -->
<%if(prop1.getProperty("MEDICL_REQUEST_POLICY").equals("true"))
{%>
  <tr>
   <td>
    <div class="reset colOuter">
     <div class="colTitle">
           <img id="unsolMedReqImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('unsolMedReq')"/>&nbsp;&nbsp;Unsolicited Medical Request
     </div>
     <div id="unsolMedReqContent" class="colContent">
     <table width="auto"  border="0" cellspacing="0" cellpadding="0">

       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <%	
                   		Set medicalRequestPolicy = interaction != null && null != interaction.getInteractionDataOnType("Unsolicited Medical Request") ? interaction.getInteractionDataOnType("Unsolicited Medical Request") : new HashSet();
           				String firstValue= "";
	                    String secValue="";
	                    String yesNoValue="";
           				if (interaction != null && medicalRequestPolicy != null   ) {
           				    System.out.println("in the if");
	              			InteractionData interactionData = new InteractionData();
	                  		Iterator itr = medicalRequestPolicy.iterator();
	                  		
	                   		while(itr.hasNext()){
	                   		    System.out.println("in while");
	                    		interactionData = (InteractionData)itr.next();
	                    		String[] text=interactionData.getData().split("@");
	                        	if ( text.length >0 ){
	                       			yesNoValue=text[0];
	                       			System.out.println("yes no value is "+yesNoValue);
	                       			firstValue=text[1];
	                       			System.out.println("first is "+firstValue);
	                       			System.out.println("second is "+secValue);
	                       			secValue=text[2];
	                    		}
							}
						}
          			%> 

         
		  	   
		 <td width=20px class="text-blue-01"><input type=radio name="yes_no" onclick="javascript:showDiv('policyquestion');"
		        <%if (interaction != null && medicalRequestPolicy != null ){
                     if("yes".equalsIgnoreCase(yesNoValue)){ %>checked<%}
             	}%>
		     value="yes">Yes</td>
         <td width=10px>&nbsp;</td>
         <td width=20px class="text-blue-01"><input type=radio name="yes_no"  onclick="javascript:hideDiv('policyquestion');" 
            	<%if (interaction != null && medicalRequestPolicy != null ){
                     if("no".equalsIgnoreCase(yesNoValue)){ %>checked<%}
             	}else{%> checked <%} %> value="no">No</td>       
			 
         <td width=20px class="text-blue-01">&nbsp;</td>
         <td id=offlable width=200px class="text-blue-01"><b> Policies:</b>&nbsp;<u>On-Label</u> / <u>Off-Label</u>&nbsp;&nbsp;</td>
         <td width=20%>&nbsp;</td>
       </tr>
       </table>
       <table>
       <tr>
        <td height=4px>&nbsp;</td>
       </tr>
       <tr>
        <td width="10" height="20">&nbsp;</td>
        <td colspan=3>
        <!-- yahan par -->
         <div id="policyquestion" <%if(("yes".equalsIgnoreCase(yesNoValue))) {%>style="display:block;" <%}else{ %> style="display:none;" <%} %>>
           <table width="auto" border="0" cellspacing="0" cellpadding="0">
             <tr>
                
                <td width=60% class="text-blue-01">Did off-label occur ?</td>
                
		    		<td width=20px class="text-blue-01"><input type=radio name="yes_no1" <%if ("yes".equalsIgnoreCase(firstValue)) { %> checked<% }%> value="yes">Yes</td>
            		<td width=10px>&nbsp;</td>
            		<td width=20px class="text-blue-01"><input type=radio name="yes_no1"  <%if ("no".equalsIgnoreCase(firstValue)) { %> checked<% }%> value="no">No</td>       
		 
		    	
             </tr>
             <tr>
                
              	<td width=60% class="text-blue-01">A package insert was offered to the health care professional?</td>
                
		 	  		<td width=20px class="text-blue-01"><input type=radio name="yes_no2" <%if ("yes".equalsIgnoreCase(secValue)) { %> checked<% }%> value="yes">Yes</td>
            		<td width=10px>&nbsp;</td>
            		<td width=20px class="text-blue-01"><input type=radio name="yes_no2" <%if ("no".equalsIgnoreCase(secValue)) { %> checked<% }%> value="no">No</td>       
		 
		    	
             </tr>
           </table>
         <div>
        </td>         
       </tr>       
     </table>
    </div></div>
   </td>
   </tr>
<% } %>
<!-- Medical request policy ends here -->
<%if(prop1.getProperty("ASSESSMENT").equals("true")){ %>
<tr>
 <td>
  <div class="reset colOuter">
   <div class="colTitle">
         <img id="assessImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('assess')"/>&nbsp;&nbsp;Planned Interactions
   </div>
   <div id="assessContent" class="colContent">
   <table width="auto"  border="0" cellspacing="0" cellpadding="0">

       <tr>
         <td width="5" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="136" class="text-blue-01">Planned Interaction</td>
         <td width="100" class="text-blue-01">Status</td>
         <td width="157">&nbsp;</td>
		 <% } %>
         <td width="187" class="text-blue-01">Assessment</td>
         <td width="75" class="text-blue-01">&nbsp;</td>
       </tr>
       <tr>
         <td width="5" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="136" class="text-blue-01" valign="top">
		  <select name="plannedInteraction" class="field-blue-02-260x50">
		  <%
            if (plannedInteractionLookup != null && plannedInteractionLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < plannedInteractionLookup.length; i++) {
                    lookup = plannedInteractionLookup[i];
          %>
			        <option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%  }  } %>
         </select>&nbsp;&nbsp;
		 </td>
         <td width="100" class="text-blue-01" valign="top">
		  <select name="status" class="field-blue-01-120x20">
		  <%
            if (statusLookup != null && statusLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < statusLookup.length; i++) {
                    lookup = statusLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
         </select></td>
         <td width="157" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">

             <tr>
               <td align="center" valign="top">
			     <div align="center">
			       <input type="button" onclick="addInteractionOptions(forms[0].assessment, forms[0].plannedInteraction, 'Planned Interaction', 'true', forms[0].status,forms[0].ids);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_plans"/>
	             </div></td>
				 <td width=16%>&nbsp;</td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top">
			     <div align="center">
			       <input type="button" onclick="deleted(forms[0].assessment)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_plans"/>
	             </div></td>
				 <td width=16%>&nbsp;</td>
             </tr>
         </table></td>
		 <% } %>
         <td width="187" class="text-blue-01">
		  <select name="assessment" multiple class="field-blue-13-300x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled <% } %>>
		  <%
		    String assessment[] = null;

            if (interaction != null && interaction.getIntAssessList() != null) {
                assessment = interaction.getIntAssessList();
				String lookup = null;
				String val = null;

                for (int i = 0; i < assessment.length; i++) {
                    lookup = assessment[i];
					String []piVal = lookup.split("1122");
					val    = piVal[0];
					lookup = piVal[1];

          %>
			<option value="<%=val%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected <% } %> ><%=lookup%></option>
          <% }  }
          %>
          </select>
          <input type="hidden" name="ids" value=""/>
         </td>
         <td width="75" class="text-blue-01">&nbsp;</td>
       </tr>
     </table>
     </div></div>
     </td>
     </tr>

<%}if(prop1.getProperty("EFFECTIVENESS").equals("true")){%>
<tr>
 <td>
  <div class="reset colOuter">
   <div class="colTitle">
         <img id="effectiveImg" class="toggleImg" src="images/buttons/minus.gif" onclick="javascript:toggleSection('effective')"/>&nbsp;&nbsp;Tool Effectiveness
   </div>
   <div id="effectiveContent" class="colContent">
   <table width="auto"  border="0" cellspacing="0" cellpadding="0">

       <tr>
         <td width="10" height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="200" class="text-blue-01">Tool</td>
         <td width="100" class="text-blue-01">Effectiveness Rating</td>
         <td width="190" align="center">&nbsp;</td>
		 <% } %>
         <td colspan="2" class="text-blue-01">Assessment		   		 </td>
         </tr>
       <tr>
         <td height="20">&nbsp;</td>
		 <% if (!"view".equalsIgnoreCase(mode)) { %>
         <td width="200" class="text-blue-01" valign="top">
		  <select name="tool" class="field-blue-01-180x20">
		  <%
            if (toolLookup != null && toolLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < toolLookup.length; i++) {
                    lookup = toolLookup[i];
          %>
			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>		 </td>
         <td width="100" class="text-blue-01" valign="top">
		  <select name="rating" class="field-blue-01-180x20">
		  <%
            if (ratingLookup != null && ratingLookup.length > 0) {
                OptionLookup lookup = null;
                for (int i = 0; i < ratingLookup.length; i++) {
                    lookup = ratingLookup[i];
          %>

			<option value="<%=lookup.getId()%>"><%=lookup.getOptValue()%></option>
          <%
                }
            }
          %>
          </select>		 </td>
         <td valign="top"><table width="100%"   border="0" cellpadding="0" cellspacing="0">

             <tr>
               <td align="center" valign="top">
			   <input type="button" onclick="addInteractionOptions(forms[0].toolAssessment, forms[0].tool, 'Tool', 'true', forms[0].rating);" style="background: transparent url(images/buttons/add-int.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="add_tools"/>			   </td>
             </tr>
             <tr>
               <td height="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="10" height="5"></td>
             </tr>
             <tr>
               <td align="center" valign="top"><input type="button" onclick="deleted(forms[0].toolAssessment)" style="background: transparent url(images/prodelete.jpg) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 73px; height: 22px;" value="" name="del_tools"/></td>
             </tr>
         </table></td>
		 <td colspan="2" class="text-blue-01"><select name="toolAssessment" multiple="multiple" class="field-blue-13-260x100" <% if ("view".equalsIgnoreCase(mode)) { %> disabled="disabled" <% } %> >
           <%
              Set tools = interaction != null && null != interaction.getInteractionDataOnType("ToolEffectiveness") ? interaction.getInteractionDataOnType("ToolEffectiveness") : new HashSet();

           if (interaction != null && tools != null   ) {
              InteractionData interactionData = new InteractionData();


                  Iterator itr = tools.iterator();

                   while(itr.hasNext()){
                    interactionData = (InteractionData)itr.next();

          %>
           <option value="<%=interactionData.getLovId().getId()+"_"+interactionData.getStatusId().getId()%>" <% if (!"view".equalsIgnoreCase(mode)) { %> selected="selected" <% } %> ><%=interactionData.getLovId().getOptValue()+"( "+interactionData.getStatusId().getOptValue()+ " )" %></option>
           <%    }

            }
          %>
         </select></td>
		 <% } %>
         </tr>
     </table>
     </div></div>
     </td>
   </tr>
<%} %><% if (!"view".equalsIgnoreCase(mode)) { %><!-- tool ends here -->