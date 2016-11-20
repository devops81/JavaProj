
<%@ page language="java" %>
<%@ page import="com.openq.ig.pubmed.crawler.keyword.KeywordCrawlResult" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.taglibs.datagrid.DataGridParameters" %>

<%@ taglib uri="/tags/datagrid-1.0" prefix="ui" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<% 
  int pageIndex = (int) DataGridParameters.getDataGridPageIndex(request, "datagrid1");
  int orderIndex = (int) DataGridParameters.getDataGridOrderIndex(request, "datagrid1");
%>

<HTML>
<HEAD>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
    <LINK href="css/datagrid.css" type=text/css rel=stylesheet>
</HEAD>

<%@ include file="header.jsp" %>

<br>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" align="center">

  <table border="0" cellspacing="0" cellpadding="0" width="100%">

    <!-- Top menu -->
    <%@ include file = "network_map_header.jsp" %>

    <!-- Result List -->
    <tr>
     <td class="text-blue-02-glow">
      <table align="center" width="100%" height="300">
      
        <tr>
          <td height="20" colspan="2" align="left" valign="top">
            <div class="myexpertlist">
             <table width="100%">   
                    <tr style="color:#4C7398;height=10">
                                <td width="2%" align="left">
                                      <div class="myexperttext">Crawler Results</div>
                                </td>
                  </tr>    
             </table>
            </div>
          </td>
        </tr>

        <tr>
          <td colspan="2" border="1" valign="top">
            <ui:dataGrid items="${keywordCrawlResults}" var="keywordCrawlResult" name="datagrid1" cellPadding="12" cellSpacing="" scroll="true" width="50%" height="250" styleClass="datagrid">
              <columns>
                <column width="35%" order="true">
                  <header value="Name" hAlign="left"/>
                  <item   value="${keywordCrawlResult.authorName}" hAlign="left"/>
                </column>
                <column width="20%" order="true">
                  <header value="# Publications" hAlign="right"/>
                  <item   value="${keywordCrawlResult.pubCount}" hAlign="right"/>      
                </column>
              </columns>
              <header        styleClass="datagrid-header" show="true"/>
              <footer        styleClass="footer" show="false"/>
              <rows          styleClass="back-white-02-light"/>
              <alternateRows styleClass="back-grey-02-light"/>
              <paging        size="8" nextUrlVar="next" previousUrlVar="previous"/>
            </ui:dataGrid>
          </td>
        </tr>
        
        <tr>
            <td align="left" width="50%">
                <c:if test="${previous != null}">
                        <a href="<c:out value="${previous}"/>"><img border="0" src="images/prev-button.jpg"/></a>
                    </c:if>
                </td>
            <td align="right" width="50%">
                    <c:if test="${next != null}">
                        <a href="<c:out value="${next}"/>"><img border="0" src="images/next-button.jpg"/></a>
                    </c:if>
            </td>
        </tr>
      </table>
     </td>
    </tr>
  </table>

</body>

<%@ include file="footer.jsp" %>

</html>