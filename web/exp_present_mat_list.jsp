
<jsp:directive.page import="com.openq.event.materials.EventMaterial"/><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@page import = "java.text.SimpleDateFormat"%>

<%@page import = "java.util.ArrayList"%>
<%@page import = "java.util.Enumeration"%>
<%@page import = "java.util.Arrays"%>
<%
 
 ArrayList persentationList=new ArrayList();
 persentationList = (ArrayList)session.getAttribute("MATERIAL_LIST");
%>
<html>
<head>
<title>openQ 2.0 - openQ Technologies Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
<link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
function MM_openBrWindow(theURL,winName,features) {

  
  window.open(theURL,winName,features);
}

function getFile(var id){
   alert("called");
   var thisform =document.PresentationMaterial;
   thisform.action="<%=CONTEXTPATH%>/exp_present_mat.htm?action=getFile&materialId="+id;
   thisform.submit();
}

</script>

<body>
<form method="POST" name="ExpertPresentationList">
<table width="100%"  border="0" cellspacing="0" scrolling=yes cellpadding="0">
<% 		
 ArrayList description=(ArrayList)session.getAttribute("description");	
 ArrayList filePath=(ArrayList)session.getAttribute("filePath");
 ArrayList inputStream=(ArrayList)request.getSession().getAttribute("inputStream");
 EventMaterial[] materials=(EventMaterial[])session.getAttribute("materials");
 
 ArrayList matList=new ArrayList();
 if(materials!=null){
	 for(int i=0;i<materials.length;i++){
	  matList.add(materials[i]);
	 }
}	 
 System.out.println("Description now is "+description);
 System.out.println("file name is "+filePath);
 List fileList=null;
 Enumeration enum = request.getParameterNames();
 ArrayList currDeletedMaterials=new ArrayList();
 ArrayList oldDeletedMaterials=new ArrayList();
 if(session.getAttribute("deletedMaterials")!=null){
    currDeletedMaterials=(ArrayList)session.getAttribute("deletedMaterials"); 
    for(int j=0;j<currDeletedMaterials.size();j++){
       System.out.println("Deleted material List is "+currDeletedMaterials.get(j)); 
    }
 }
		while(enum.hasMoreElements()) {
			String str = enum.nextElement().toString();
			if(str.equals("MaterialIds")) {
			    System.out.println("teh index is "+request.getParameterValues(str));
				fileList = Arrays.asList(request.getParameterValues(str));
				int len = fileList.size() - 1;
				System.out.println("the len is "+len);
				if(session.getAttribute("materials")==null){
					for(int k = len; k >= 0; k--) {
					    description.remove(Integer.parseInt(fileList.get(k).toString()));
						filePath.remove(Integer.parseInt(fileList.get(k).toString()));
						inputStream.remove(Integer.parseInt(fileList.get(k).toString()));	
					}
				}else{
				    System.out.println("in else");
				    System.out.println("material id from request "+fileList.get(0));
				    int k=0;
				    for( k = len; k >= 0; k--) {
				        if(Integer.parseInt(fileList.get(k).toString())<999){ //assuming that no one is going to put more than 999 material in one go 
						    description.remove(Integer.parseInt(fileList.get(k).toString()));
							filePath.remove(Integer.parseInt(fileList.get(k).toString()));
							inputStream.remove(Integer.parseInt(fileList.get(k).toString()));
						}		
					}	
				    //String[] matIdList=request.getParameterValues(str);
				    int index=0;
				    for(int i=0;i<materials.length;i++){
				        System.out.println("i is "+i);
				    	System.out.println("material Ids are "+materials[i].getMaterialID());
				    	System.out.println("len is "+(len+index));
				    	System.out.println("size of file list " +fileList.size());
				    	if(index==fileList.size()){
				    	 index=0;
				    	}
				    	//System.out.println("mtrl id is "+fileList.get(len+index));
				    	for(index=0;index<fileList.size();index++){
				    	    System.out.println("mtrl id is "+fileList.get(index));
						    if(Long.toString(materials[i].getMaterialID()).equals(fileList.get(index).toString())){
						    		matList.remove(materials[i]);
						    		currDeletedMaterials.add(materials[i]);
						    		
						   	}	
					    }
				    }
				     materials=(EventMaterial[])matList.toArray(new EventMaterial[matList.size()]);	
				     session.setAttribute("materials",materials);
				     session.setAttribute("deletedMaterials",currDeletedMaterials);
				     System.out.println("Deleted material size is "+currDeletedMaterials.size());
				     for(int i=0;i<currDeletedMaterials.size();i++){
				       System.out.println("Deleted material List is "+currDeletedMaterials.get(i)); 
				    }
				    
				}	
			}
		}		
 if(description!=null){	
 for(int i= 0; i <description.size() ; i++) {	
	 
  %>
  <tr <% if(i%2>0){%> class="back-grey-02-light" <%}%>>
	<td height="25" align="left" valign="top" class="back-grey-02-light">
	    
		
		
		<td width="25" height="20" align="left" valign="middle">
			<input type="checkbox" name="MaterialIds" value=<%=i%>>
		</td>
		<td width="100" class="text-blue-01"><%=description.get(i)%></td>
		<td width="181" class="text-blue-01"></td>
		<td class="text-blue-01-link"><a href="<%=CONTEXTPATH%>/exp_present_mat.htm?action=viewFile&index=<%=i%>"><%=filePath.get(i) %></a></td>
		
	</tr>


  
	<% 
		}
	}	
		
  %>
  <%
  if(session.getAttribute("materials")!=null){
  
  for(int i= 0; i< materials.length; i++) {	
	 
  %>
  <tr <% if(i%2>0){%> class="back-grey-02-light" <%}%>>
	<td height="25" align="left" valign="top" class="back-grey-02-light">
	    
		
		
		<td width="25" height="20" align="left" valign="middle">
			<input type="checkbox" name="MaterialIds" value=<%=materials[i].getMaterialID()%>>
		</td>
		<td width="100" class="text-blue-01"><%=materials[i].getDescription()%></td>
		<td width="181" class="text-blue-01"></td>
        <td class="text-blue-01-link"> <a href="<%=CONTEXTPATH%>/exp_present_mat.htm?action=getFile&materialId=<%=materials[i].getMaterialID()%>"><%=materials[i].getName()%></a></td>
		
	</tr>


  
	<% 
		}
	}	
	session.removeAttribute("matarials");
	//session.removeAttribute("eventId");	
  %>
  </table>
	
</table>
</form>
</body>
</html>
