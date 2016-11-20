	<%@ include file="adminHeader.jsp" %>
	
		
	<table  border=0 cellspacing=0 cellpadding=0 width=99% height="450">
	 <tr>
		<td width="22%" align="left" valign="top" height="450">
				<div class="expertsegmentationdiv">
					<div class="leftsearchbgpic">
						<div class="leftsearchtext">Users</div>
					</div>
					<iframe id="backgr1" name="tree" src="userTree.htm" width="100%" height="300%"
                                        frameborder="0" scrolling="auto" ></iframe>
				</div>
		</td>		
		<td valign="top">
		     <div class="producttext">
					<!-- Go to Segment Strategy page if returning from Add Expert else -->
                    <!-- go to Create Segment page -->
                     
	                   <iframe id="backgr1" frameborder="0" name="main" width="100%" height="450" src="createUser.htm"></iframe> 
              </div>
		</td>
	</tr>
</table>
			
    <%@ include file="footer.jsp" %>