
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.openq.ig.pubmed.crawler.keyword.KeywordCategory" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<HTML>
<HEAD>
    <LINK href="css/openq.css" type=text/css rel=stylesheet>
    
    
    <script type="text/javascript">
        function runKeywordCrawler(contextURL){
            var thisform = document.keywordCrawlerForm;
            var flag = false;
            var count = 0;

            for (var i = 0; i < thisform.elements.length; i++) {
                if (thisform.elements[i].type == "checkbox" && thisform.elements[i].checked) {
                    flag = true;
                    count++;
                }
            }
            
            if((flag) && (count == 1)) {
                thisform.actionToPerform.value = "crawl";
                thisform.action = "keyword_pubmed_crawler.htm";
                thisform.submit();
            }
            else {
                alert("Please select one category to crawl");
            }
        }
        
        function deleteCategories(contextURL) {
            var thisform = document.keywordCrawlerForm;
            thisform.actionToPerform.value = "delete";
            
            thisform.action = "keyword_pubmed_crawler.htm";
            thisform.submit();
        }

        function addCategory(contextURL) {
            var thisform = document.keywordCrawlerForm;
            thisform.actionToPerform.value = "add";
            
            thisform.action = "keyword_pubmed_crawler.htm";
            thisform.submit();
        }

    </script>
</HEAD>

<%@ include file="header.jsp" %>

<BODY leftMargin=0 topMargin=0 marginheight="0" marginwidth="0" align="center">
 <form name="keywordCrawlerForm" method="post">

  <table border="0" cellspacing="0" cellpadding="0" width="100%">


    <!-- Top menu -->
    <%@ include file = "network_map_header.jsp" %>

    <!-- Crawler inputs -->
    <tr>
      <td class="text-blue-02-glow">
       <table align="center" width="100%" height="250" cellpadding="0" cellspacing="2">

        <tr>
          <td colspan="2" height="20" align="left" valign="top" class="back_horz_head">
            <div class="myexpertlist">
             <table width="100%">   
                <tr style="color:#4C7398;height=10">
                  <td width="2%" align="left">
                    <div class="myexperttext">Manage Categories</div>
                  </td>
                </tr>    
             </table>
            </div>
          </td>
        </tr>

        <c:if test="${confirmationMessage != null}">
          <tr>
            <td colspan="2" align="center" class="text-blue-13">
              <b><c:out value="${confirmationMessage}"/></b>
            </td>
          </tr>
        </c:if>
        
        <!-- Show the existing keyword categories -->
        <%
          KeywordCategory[] categories = (KeywordCategory[]) session.getAttribute("keywordCategories");
          if((categories != null) && (categories.length > 0)) {
        %>
        
        <tr>
         <td colspan="2" height="110"  width="100%" valign="top" class="back-white">
           <div style="position:relative; height:100; overflow:auto;">
             <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
               
               <%
                 for(int i=0; i<categories.length; i++) {
               %>
               
               <tr>
                 <td>
                   <input type="checkbox" name="categoryIds" value="<%="" + categories[i].getId()%>"/>
                 </td>
                 <td class="text-blue-13">
                   <%=categories[i].getCategory()%>
                 </td>
                 <td class="text-blue-13">
                   <%=categories[i].getKeywords()%>
                 </td>
                 <td class="text-blue-13">
                   <%=categories[i].getStatus()%>
                 </td>
                 <td class="text-blue-13">
                   <%=categories[i].getLastRuntime()%>
                 </td>                                      
               </tr>
               
               <%
                 }
               %>
               
             </table>
           </div>
         </td>
        </tr>
        
        <tr>
          <td align="left">
            &nbsp;&nbsp;<input class="button-01" style="border:0;background : url(images/buttons/delete.gif);width:73px; height:23px;"  type="button" name="delete_categories" value="" onclick="javascript:deleteCategories('<%=CONTEXTPATH%>')"/>
          </td>
          <td align="left">
            <input class="button-01" style="border:0;background : url(images/buttons/submit.gif);width:80px; height:23px;"  type="button" name="run_crawler" value="" onclick="javascript:runKeywordCrawler('<%=CONTEXTPATH%>')"/>
          </td>
        </tr>
        
        <%
          }
        %>        	
        
        <tr>
          <td colspan="2" height="20" align="left" valign="top" class="back_horz_head">
            <div class="myexpertlist">
             <table width="100%">   
                <tr style="color:#4C7398;height=10">
                  <td width="2%" align="left">
                    <div class="myexperttext">Add Category</div>
                  </td>
                </tr>    
             </table>
            </div>
          </td>
        </tr>

        <tr>
             <td colspan="2" valign="top">
               <input type="hidden" name="actionToPerform"/>
               <table cellpadding="7" cellspacing="7">
                <tr>
                 <td align="left" class="text-blue-13">
                  Category 
                 </td>
                 <td align="left" class="text-blue-13">
                  Keyword
                 </td>
                </tr>
                <tr>
                 <td align="left">
                   <input class="blueTextBox" name="category"/>
                 </td>
                 <td align="left">
                   <input class="blueTextBox" name="keyword"/>
                 </td>
                </tr>
                <tr>
                  <td colspan="2" align="left">
                    <input class="button-01" style="border:0;background : url(images/buttons/add.gif);width:56px; height:23px;"  type="button" name="run_crawler" value="" onclick="javascript:addCategory('<%=CONTEXTPATH%>')"/>
                  </td>
                </tr>
               </table>
             </td>
        </tr>
       </table>
      </td>
     </tr>
   </table>

</form>

</body>

</html>