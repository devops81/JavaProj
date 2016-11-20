<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ include file="imports.jsp" %>

<%@ page import="com.openq.eav.option.OptionLookup" %>
<%@ page import="com.openq.eav.option.OptionNames" %>

<%
    OptionNames [] displayOptionName = (OptionNames []) request.getSession().getAttribute("displayOptionName");
    OptionLookup [] displayList = (OptionLookup []) request.getSession().getAttribute("displayList");
%>

<HTML>
<HEAD>
    <%@ page
            language="java"
            contentType="text/html; charset=ISO-8859-1"
            pageEncoding="ISO-8859-1"
            %>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <script src="<%=COMMONJS%>/ua.js"></script>
    <script src="<%=COMMONJS%>/ftiens4.js"></script>
    <link href="<%=COMMONCSS%>/openq.css" rel="stylesheet" type="text/css">
    <script>
        // You can find instructions for this file here:
        // http://www.treeview.net

        // Decide if the names are links or just the icons
        USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks

        // Decide if the tree is to start all open or just showing the root folders
        STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree

        ICONPATH = '<%=COMMONIMAGES %>/' //change if the gif's folder is a subfolder, for example: 'images/'
        PERSERVESTATE = 0

        foldersTree = gFld("Options", "valueList.htm")

        <%
            String selectedOptionId = (String) request.getSession().getAttribute("selectedOptionId");
            if(displayOptionName != null) {
                for(int i=0;i<displayOptionName.length;i++) 
	{
                if(displayOptionName[i].getName()!=null && !displayOptionName[i].getName().equals("null") )
{
        %>
                      
                      aux<%=i%> = insDoc(foldersTree, gLnk("R", "<%=displayOptionName[i].getName()%>", "valueList.htm?displayOption=<%=displayOptionName[i].getId()%>&parentId=<%=displayOptionName[i].getParentId()%>"));
                     
        <%
  				  }	      
                }
            }
        %>

    </script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">

    <tr align="left" valign="top" class="back-grey-02-light">
        <td width="15" height="31">&nbsp;</td>
        <td valign="middle">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="middle">
                    <td width="14" height="20"><img src="<%=COMMONIMAGES%>/icon_values.gif" width="14" height="14"></td>
                    <td width="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="5" height="5"></td>
                    <td class="text-blue-01-bold">Options</td>
                </tr>
            </table>
        </td>
        <td width="5"><img src="<%=COMMONIMAGES%>/transparent.gif" width="5" height="5"></td>
    </tr>

    <tr>
        <td width="5" height="10"><img src="<%=COMMONIMAGES%>/transparent.gif" width="5" height="10"></td>
    </tr>

    <tr>
        <td width="15" height="31">&nbsp;</td>
        <td align="left" valign="top">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="2%"><img src="<%=COMMONIMAGES %>/transparent.gif"></td>
                    <td width="98%"><style>
                        /* styles for the tree */
                        SPAN.TreeviewSpanArea A {
						        
						        font-family: verdana, arial, helvetica; 
						        text-decoration: none;
						        color: "#6B6B6B";
						        font-weight:bold;
								padding-bottom:3px;
								padding-top:3px;
								font-size: 11px; 
						   }
						   SPAN.TreeviewSpanArea A:hover {
						        background-color:#CBDDEA;
						   }

                        /* rest of the document */
                        BODY {
                            background-color: white
                        }

                        TD {
                            font-size: 11pt;
                            font-family: verdana, helvetica;
                        }
                    </style>

                        <div style="position:absolute; top:50px; left:37px;">
                            <table border=0>
                                <tr>
                                    <td align="left" valign="middle"><a href="http://www.treemenu.net/"
                                                                        target="_blank"></a></td>
                                </tr>
                                <tr>
                            </table>
                        </div>
            <span class=TreeviewSpanArea> 
            <script>initializeDocument()</script>
            <noscript>
                A tree for site navigation will open here if you enable JavaScript
                in your.
            </noscript>
            </span></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>