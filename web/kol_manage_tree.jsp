<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@page import = "java.util.*" %>
<%@page import = "com.openq.kol.NodeDTO"%>
<%@page  import ="com.openq.web.ActionKeys"%>

<html>
<head>
<title>openQ 2.0 - openQ Technologies Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="<%=COMMONCSS%>/tree.css" rel="stylesheet" type="text/css">
	<script src="<%=COMMONJS%>/yahoo/yahoo.js"></script>
	<script src="<%=COMMONJS%>/event/event.js"></script>
	<script src="<%=COMMONJS%>/treeview/treeview.js"></script>
	<script src="<%=COMMONJS%>/utilities/utilities.js"></script>
			 <style type="text/css">
    #treewrapper {position:relative;}
	#treediv {position:relative; width:250px;}
	#figure1 {float:right;background-color:#FFFCE9;padding:1em;border:1px solid grey}

	.icon-doc { 
					display:block; 
					padding-left: 20px;
					background: transparent url(images/icons.png) 0 -144px no-repeat;
					color:#6B6B6B;
					font-weight:bold;
					padding-bottom:3px;
					padding-top:3px;
					font-size: 70%; 
					font-family: verdana,helvetica; 
					border: none;
					font-size-adjust:none;
					font-style:normal;
					font-variant:normal;
					line-height:1.2em;
					text-decoration: none;
			}
    .icon-doc:hover { 
					background-color:#CBDDEA;
    		}

	.folder-style
			{
					display:block; 
					padding-left: 2px;
					color:#6B6B6B;
					font-weight:bold;
					padding-bottom:3px;
					padding-top:3px;
					font-size: 70%; 
					font-family: verdana,helvetica; 
					border: none;
					font-size-adjust:none;
					font-style:normal;
					font-variant:normal;
					line-height:1.2em;
					text-decoration: none;
			}
	 .folder-style:hover { 
					background-color:#CBDDEA;
    		}	
</style>
<script>


//Wrap our initialization code in an anonymous function
//to keep out of the global namespace:
(function(){
	var init = function() {
	var tree = new YAHOO.widget.TreeView("treediv");
	var root = tree.getRoot();
	var node0 = new YAHOO.widget.TextNode("Segment Drill Down", root, true);
	node0.target = 'main' ;
	node0.href = '<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SHOW_DATA_FOR_ROOTNODE%>&parentId=0&rootnode=true';
	node0.labelStyle='folder-style';

		<% 
			ArrayList programTree = null;
			if(session.getAttribute("HIERARCHY")!=null){
				programTree=(ArrayList)session.getAttribute("HIERARCHY");
			}
			if(programTree !=null)
				{
					for(int i=0;i<programTree.size();i++)
						{	 				
							NodeDTO nodeDTO =(NodeDTO)programTree.get(i);
						%>
							var node<%=nodeDTO.getSegmentId()%> = new YAHOO.widget.TextNode("<%=nodeDTO.getParentName()%>", node<%=nodeDTO.getParentId()%>, false);
							node<%=nodeDTO.getSegmentId()%>.target = 'main' ;
						<%				
							if(nodeDTO.getParentId()==0 || nodeDTO.getStrategyLevel().equals("false")) 
							{
						%>
								node<%=nodeDTO.getSegmentId()%>.labelStyle='folder-style';
								node<%=nodeDTO.getSegmentId()%>.href = '<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SHOW_DATA_FOR_TREE%>&parentId=<%=nodeDTO.getParentId()%>&parentName=<%=nodeDTO.getParentName()%>&segmentId=<%=nodeDTO.getSegmentId()%>&segmentlevel=notlast';
						<%
							} else 
							{
						%>
								// Leaf Nodes
								node<%=nodeDTO.getSegmentId()%>.labelStyle="icon-doc";	
								node<%=nodeDTO.getSegmentId()%>.href = '<%=CONTEXTPATH%>/kolstrategy_home.htm?action=<%=ActionKeys.KOL_SHOW_DATA_FOR_TREE%>&segmentId=<%=nodeDTO.getSegmentId()%>&parentId=<%=nodeDTO.getParentId()%>&parentName=<%=nodeDTO.getParentName()%>&segmentlevel=last';
						<%
							}
						}
				}
		%>

		tree.draw();
	}
	YAHOO.util.Event.on(window, "load", init);
})();
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left" width="90%" valign="top" style="margin-left:10px">
		<div id="treediv"> </div>

		
	</td>
  </tr>
</table>
</body>
</html>
