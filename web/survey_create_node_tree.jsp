<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp"%>
<%@page import = "java.util.*" %>
<%@page import ="com.openq.survey.NewSurvey"%>
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
	var node0 = new YAHOO.widget.TextNode("Surveys", root, true);
	//node0.target = 'main' ;
	node0.labelStyle='folder-style';
    node0.href='#';
	var node1 = new YAHOO.widget.TextNode("Interactions", node0, false);
    //node1.target = 'main' ;
	node1.labelStyle='folder-style';
	node1.href='#';
	var node2 = new YAHOO.widget.TextNode("Medical Intelligence", node0, false);
    //node2.target = 'main' ;
	node2.labelStyle='folder-style';
    node2.href='#';
	var node3 = new YAHOO.widget.TextNode("DCI", node0, false);
    //node2.target = 'main' ;
	node3.labelStyle='folder-style';
    node3.href='#';
	var node4 = new YAHOO.widget.TextNode("Saved", node1, false);
    //node3.target = 'main' ;
	node4.labelStyle='folder-style';
	node4.href='#';
	var node5 = new YAHOO.widget.TextNode("Launched", node1, false);
    //node4.target = 'main' ;
	node5.labelStyle='folder-style';
    node5.href='#';
	var node6 = new YAHOO.widget.TextNode("Saved", node2, false);
    //node5.target = 'main' ;
	node6.labelStyle='folder-style';
	node6.href='#';
	var node7 = new YAHOO.widget.TextNode("Launched", node2, false);
    //node6.target = 'main' ;
	node7.labelStyle='folder-style';
	node7.href='#';
    var node8 = new YAHOO.widget.TextNode("Saved", node3, false);
    //node5.target = 'main' ;
	node8.labelStyle='folder-style';
	node8.href='#';
	var node9 = new YAHOO.widget.TextNode("Launched", node3, false);
    //node6.target = 'main' ;
	node9.labelStyle='folder-style';
	node9.href='#';
		
		<% 
			NewSurvey[] allSurveys = null;
			if(session.getAttribute("allNewSurveys")!=null){
				allSurveys=(NewSurvey[])session.getAttribute("allNewSurveys");
			}
			if(allSurveys !=null)
				{
					for(int i=0;i<allSurveys.length;i++)
						{	 				
							NewSurvey nodeDTO =(NewSurvey)allSurveys[i];
						%>
						var parentNode = null;
						<% if(nodeDTO.getType().equals("Interactions")){
							if(nodeDTO.getState().equals("Saved")){%>
                            parentNode = node4;         
						<%} else {%>
                            parentNode = node5;
                         <%}
						}
						 else if(nodeDTO.getType().equals("Medical Intelligence")){
						if(nodeDTO.getState().equals("Saved")){%>
                        parentNode = node6;
						<%} else {%>
						parentNode = node7;	
						<%} }
						else if(nodeDTO.getType().equals("DCI")){
						if(nodeDTO.getState().equals("Saved")){%>
                        parentNode = node8;
						<%} else {%>
						parentNode = node9;	
						<%} }%>	
                        var node<%=(i+10)%> = new YAHOO.widget.TextNode("<%=nodeDTO.getName()%>",parentNode,false);
								// Leaf Nodes
								node<%=(i+10)%>.labelStyle="icon-doc";
								node<%=(i+10)%>.href='<%=CONTEXTPATH%>/survey.htm?action=editSurvey&surveyId='+'<%=nodeDTO.getId()%>';
								node<%=(i+10)%>.target = '_parent' ;
					   <%
							
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
