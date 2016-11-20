<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page import="com.openq.geocode.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.openq.kol.DBUtil"%>

<%
	GeocodeAddress[] expertAddresses = (GeocodeAddress[]) session.getAttribute("expertAddresses");
	String expertListDescription = "All Experts";
	String toggleURL = "";
	String toggleURLDescription = "";
	String launchingPage = (String) session.getAttribute("launchingPage");
	if(session.getAttribute ("expertListDescription") != null) {
	    expertListDescription = (String) session.getAttribute ("expertListDescription");
	    toggleURL = (String) session.getAttribute ("toggleURL");
	    toggleURLDescription = (String) session.getAttribute ("toggleURLDescription");
	}
%>

<%@ include file="header.jsp" %>

	<STYLE TYPE="text/css" MEDIA=screen>
	<!--
	/* Push pin
	------------------ */
	.pin{
		width:5px;height:5px;
		font-weight:bold;font-size:8pt;
		color:White;
		z-index:5
	}
	-->
	</STYLE>

	<script src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.2"></script>
	
	<script>
	var map;
	
	function drawMap()
	{ 
		var lat;
		var longi;
		var params = new Object();
		var pin;
		 
		params.latitude = 0;
	        params.longitude = 0;
	        params.zoomlevel = 4;
	        params.mapstyle = 'h';
	        params.showScaleBar = false;
	        params.showDashboard = true;
	        params.dashboardSize = "small";
	        params.dashboardX = 3;
	        params.dashboardY = 3;
	 
	 	<%
	 		//To get the low, high Latitude and Longitude to calculate the center of the map
	 		if((expertAddresses != null) && (expertAddresses.length>0)) {
	 				
	 			GeocodeAddress add = expertAddresses[0];
		 			
				double lowLat= add.getLatitude();
				double lowLong= add.getLongitude();
				double highLat= add.getLatitude();
				double highLong= add.getLongitude();
				double temp=0;
				
				for (int i = 0; i < expertAddresses.length; i++) {
					
					add= expertAddresses[i];
					
					temp= add.getLatitude();
			
					if(temp<lowLat)
						lowLat=temp;
					if(temp>highLat)
						highLat=temp;
		
					temp= add.getLongitude();
		
					if(temp<lowLong)
						lowLong=temp;
					if(temp>highLong)
						highLong=temp;
				}
		%>
				
				//To set the center of the map
				params.latitude = (<%=lowLat%>+<%=highLat%>)/2;
				params.longitude = (<%=lowLong%>+<%=highLong%>)/2;
			
		<%
			}
		%>
	 		
		try {
			map = new VEMap("virtualEarthMapDiv");
			map.LoadMap();
			
			map.SetCenterAndZoom(new VELatLong(params.latitude, params.longitude), params.zoomlevel);
			map.SetMapStyle(params.mapstyle);
		}
		catch(e) {
			alert("No Internet Connection is available, Please check your netowrk connectivity or check with your ISP")
			//alert(e.name + ":" + e.message);
		}
		
		try {
	 	<%
			for (int i = 0; i < expertAddresses.length; i++)
			{
				try {
					GeocodeAddress add= expertAddresses[i];
		%>
			//Add a push pin for a location (lat,long) and add a label to the panel display
			pin = new VEPushpin(<%=i%>, new VELatLong(<%=add.getLatitude()%>, <%=add.getLongitude()%>), 
			        null, '<a href="<%=add.getProfileURL()%>"><%=add.getLabel()%></a>', '<%=add.getDescription()%>');
			map.AddPushpin(pin);
		<%	
				}
				catch(Exception e2) {
					System.out.println(e2);
				}
			}
		%>
		}
		catch (e) {
			//alert(e.name + ":" + e.message);
		}
	}
	
	
	dojo.addOnLoad(drawMap);
	</script>

<br>
<div class="producttext" style="width:95%; HEIGHT: 1100px;">
	<div class="myexpertlist">
    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
	  <tr align="left" valign="middle" style="color:#4C7398">
	    <td width="20" height="20">&nbsp;</td>
	    <td width="14" class="text-white-bold"><img src="<%=COMMONIMAGES%>/icon_my_expert.gif" width="14"
								    height="14"/></td>
	    <td width="" class="">&nbsp;<font face="verdana" size ="2"><%=DBUtil.getInstance().doctor%> Search Results (Only <%=DBUtil.getInstance().doctor%>s with verifiable addresses are being displayed)</font></td>
	    
	    <td width="200" align="left"><font face="verdana" size="2"><a href="<%=toggleURL%>"><span class=""><%=toggleURLDescription%></font></span></a></td>
		<td width="25" height="20">&nbsp;</td>	
		<td width="25" class="text-white-bold"><a href="<%=launchingPage%>"><img src="<%=COMMONIMAGES%>/close.gif" width="14"
								    height="14" border="0"/></a></td>
		<td width="10" height="20">&nbsp;</td>	
	  </tr>
    </table>
	</div>
	<br/>
  <div id="virtualEarthMapDiv" style="position:absolute; left:3%; WIDTH:94%; HEIGHT: 1000px; OVERFLOW:hidden;"></div>
</div>
<%@ include file="footer.jsp" %>
</html>