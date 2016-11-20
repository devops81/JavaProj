<%@ page language="java" %>
<jsp:directive.page import="java.io.InputStream"/>
<%@ include file = "imports.jsp" %>
<%@page import = "java.util.Enumeration"%>
<%@page import = "java.util.ArrayList"%>
<%@page import = "java.lang.Integer"%>
<%@page import = "org.springframework.web.multipart.MultipartFile"%>
<%@page import = "org.springframework.web.multipart.MultipartHttpServletRequest"%>
<%@page import = "org.springframework.web.multipart.commons.CommonsMultipartResolver"%>
<html>
<HEAD>
	<TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
	
	
	<script language="javascript">
    function viewMaterials(){
	    var thisform =document.PresentationMaterial;
	    thisform.action="<%=CONTEXTPATH%>/exp_present_mat.htm?action=View";
	    <% System.out.println("deleting session"); 
	    session.removeAttribute("deletedMaterials");%>
	    thisform.submit();
    } 
	</script>
</HEAD>
<%
 
 String contentType = request.getContentType();
 
  ArrayList description=new ArrayList();
  ArrayList filePath=new ArrayList();
  ArrayList inputStream=new ArrayList();
  if(request.getSession().getAttribute("description")!=null){
     description=(ArrayList)request.getSession().getAttribute("description");
  }
  if(request.getSession().getAttribute("filePath")!=null){
     filePath=(ArrayList)request.getSession().getAttribute("filePath");
  }
  if(request.getSession().getAttribute("inputStream")!=null){
     inputStream=(ArrayList)request.getSession().getAttribute("inputStream");
  }
  
 if(contentType != null ) {
     
     String fileName;
     InputStream is;
          
	 CommonsMultipartResolver multiPart = new CommonsMultipartResolver();
	 MultipartHttpServletRequest multiRequest = multiPart.resolveMultipart(request);
	 if(multiRequest.getParameter("versionNumber")!=null && multiRequest.getParameter("versionNumber").trim().length()>0){
		 String desc = multiRequest.getParameter("versionNumber");
		 if(request.getAttribute("mreq")!=null){
		    MultipartHttpServletRequest mreq=(MultipartHttpServletRequest)request.getAttribute("mreq");
		    fileName=mreq.getFile("materialFile").getOriginalFilename();
		    is=mreq.getFile("materialFile").getInputStream();
		 }else{			 			 	
			System.out.println("versionno is "+multiRequest.getParameter("versionNumber"));
			System.out.println("Material file is "+multiRequest.getFile("materialFile"));
			fileName=multiRequest.getFile("materialFile").getOriginalFilename();
			System.out.println("file name now is "+filePath);
			is=multiRequest.getFile("materialFile").getInputStream();
		 }
		 System.out.println("IS is "+is);
		 description.add(desc);
		 filePath.add(fileName);
		 inputStream.add(is);
		 session.setAttribute("filePath",filePath);
		 session.setAttribute("description",description);
		 session.setAttribute("inputStream",inputStream);
		 System.out.println(" Description is "+session.getAttribute("description"));
		 System.out.println(" Input stream is "+inputStream);
	 } 
 }

 

%>

<!--<LINK href="<%=COMMONCSS%>/openq.css" type=text/css rel=stylesheet>
<SCRIPT src = "<%=COMMONJS%>/listbox.js" language = "Javascript"></SCRIPT-->
<SCRIPT src = "js/validation.js" language = "Javascript"></SCRIPT>
<script  language="JavaScript">

function uploadFile(){
	var thisform =document.PresentationMaterial;
	
	if ((checkNullSearch(thisform.versionNumber)==false) || (checkNullSearch(thisform.materialFile)==false)){
			
		return false;
	}
	/*thisform.action="<%=CONTEXTPATH%>/exp_present_mat.htm?action=upload";*/

/*	fileCount = fileCount+1;
	properties.setProperty("DESC_" + fileCount, thisform.versionNumber.value);
	properties.setProperty("FILE_NAME_" + fileCount, thisform.file_name.value); */
	thisform.submit();
}

function checkUncheck()
{
	if (document.PresentationMaterial.MaterialName.checked == true )
	{
		box = eval(window.frames['PresentationList'].ExpertPresentationList.MaterialIds);
	
	    if (box.length>0)
	    { 
			for(var i=0;i<box.length;i++){
			box[i].checked=true;
			}
		}
		else
		{
			box.checked=true;
		}
	}
	else
	{
		box = eval(window.frames['PresentationList'].ExpertPresentationList.MaterialIds);
		
		if (box.length>0)
	    {
			for(var i=0;i<box.length;i++)
			{
				box[i].checked=false;
			}
		}
		else
		{
			box.checked=false;
		}
	}
}

function deleteMaterial(){

	var thisform =window.frames['PresentationList'].ExpertPresentationList;
	var flag =false;
	
	for(var i=0;i<thisform.elements.length;i++){
		
		if(thisform.elements[i].type =="checkbox" && thisform.elements[i].checked){
			flag =true;
			break;		
		}
	}	

	if(flag){		
		if(confirm("Do you want to delete the selected Presentation /s?")){
			thisform.submit();
		}
	}else {
		alert("Please select atleast one Material to delete");
	}

}

function search(formObj)
{
	var keyword_value = formObj.keyword.value;
	if(keyword_value.length <= 0)
	{
		alert ("Please enter search keyword");
		formObj.keyword.focus();
		return false;
	}
	
	formObj.submit();
}
</script>



<body>
 <form name="PresentationMaterial" method="POST" AUTOCOMPLETE="OFF" enctype="multipart/form-data">
             <div class="contentmiddle">
			        <div class="producttext" >
				    <div class="myexpertlist">
				      <table width="100%">
				        <tr style="color:#4C7398">
				        </td>
				        <td width="50%" align="left">
				          <div class="myexperttext">Uploaded Material</div>
				        </td>
				        
				        </tr>
				      </table>
				    </div>
				    <table width="100%" cellspacing="0">
				      <tr bgcolor="#f5f8f4">
					      <td width="1%" align="right">&nbsp;</td>
					      <td width="1%" class="expertPlanHeader">&nbsp;</td>
					      <td width="32%" class="expertPlanHeader">Description</td>
					      <td width="9%" class="expertPlanHeader">Material</td>
					      <td width="35%">&nbsp;</td>
				      </tr>
				      <tr>
				          <td width="1%" align="right">&nbsp;</td>
				          <td width="95%" align="left" valign="top" colspan="4">
	                      <iframe src="exp_present_mat_list.jsp" height="100%" width="100%" name="PresentationList" id="PresentationList" frameborder="0" scrolling="yes"></iframe>
                          </td>
				      </tr>
				       
				      <tr>
				         <td width="5%" align="right">&nbsp;</td>
				        <td colspan="2">                                     
                        <!-- input name="Submit" type="button" class="button-01" value="Delete Material" onclick="deleteMaterial()"-->

                         <br>
 <%if(session.getAttribute("eventId")!=null){ %>
                         <input type=button name=view_materials  style="background: transparent url(images/buttons/view_material.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 111px; height: 22px;" value="" class="button-01" onclick="viewMaterials()"/>
                         <input type=button name=del_materials style="background: transparent url(images/buttons/remove_material.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 129px; height: 22px;" value="" class="button-01" onclick="deleteMaterial()"/>
                         <%}else{ %><input type=button name=del_materials style="background: transparent url(images/buttons/remove_material.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 129px; height: 22px;" value="" class="button-01" onclick="deleteMaterial()"/>
                        <%} %>
                        </td> 
 
                        </tr>
				    </table>
				    </div>
				    <div class="producttext">
				    	<div class="myexpertplan">
					      <table width="100%">
					        <tr style="color:#4C7398">
					        <td align="left">
					          <div class="myexperttext">Upload New Material</div>
					        </td>
					        </tr>
					      </table>
					    </div>
					    <table width=100%>
					      	<tr>
							  <td width="89" height="20">&nbsp;</td>
		                      <td width="167" class="text-blue-01">Description</td>
		                      <td>&nbsp;</td>
		                      <td class="text-blue-01">Material File</td>
		                      <td>&nbsp;</td>
	                    	</tr>
	                    	<tr>
		                      <td height="20">&nbsp;</td>
		                      <td><input name="versionNumber" type="text" class="field-blue-01-180x20"></td>
		                      <td width="5%">&nbsp;</td>		                                           
		                      <td width="67%"><input name="materialFile" type="file" class="button-02"/></td>
		                      <td width="1%">&nbsp;</td>
                    		</tr>

					    <tr>
						    <td>&nbsp;</td>
	                        <td colspan=3><input type="button" name="Submit2" class="button-01" value="" onClick ="javascript:uploadFile()" style="background: transparent url(images/buttons/update_material.gif) repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial; width: 123px; height: 22px;"/>
	                        <input name="Submit33" type="button" style="border:0;background : url(images/buttons/close_window.gif);width:115px; height:22px;" class="button-01" value="" onClick="javascript:window.close()" />
	                        </td>
        
	                      	<td height="30" colspan=2 align="right" rowspan="3">&nbsp;</td>
	                      	<td rowspan="3">&nbsp;</td>
                    	</tr>

						</table>

				    </div>
 </div> 
</table>
</form>
</body>
<%
  //session.removeAttribute("materials");
%>
</html>
                         