<%@ page language="java" %>
<%@page import = "com.openq.event.materials.EventMaterial"%>

<HEAD>
	<TITLE>openQ 3.0 - openQ Technologies Inc.</TITLE>
	<LINK href="css/openq.css" type=text/css rel=stylesheet>
</HEAD>
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
					      <td width="1%" align="right">&nbsp;</td>
					      <td width="32%" class="expertPlanHeader">Description</td>
					      <td width="9%" class="expertPlanHeader">Material</td>
					      <td width="35%">&nbsp;</td>
				      </tr>
				     
				      <%EventMaterial[] material = (EventMaterial[])request.getSession().getAttribute("MATERIAL");
				      for(int i=0;i<material.length;i++){
				       %>
				       <tr>
				       		<td width="1%" align="right">&nbsp;</td>
				       		<td width="1%" align="right">&nbsp;</td>
				       		<td width="32%" class="text-blue-01"><%=material[i].getDescription() %></td>
				       		<td class="text-blue-01-link"> <a href="exp_present_mat.htm?action=getFile&materialId=<%=material[i].getMaterialID()%>"><%=material[i].getName()%></a></td>
				       </tr>
				       <%} 
				       request.getSession().removeAttribute("MATERIAL");
				       %>
				      </table>
				       </div>
				       </div>
				       </form>
				       </body>
				       </html>
				      