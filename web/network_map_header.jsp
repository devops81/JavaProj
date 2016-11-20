    <tr>
      <td height="20" align="left" valign="top" class="submenu">
        <table width="50%" align="left" border="0" cellspacing="0" cellpadding="0">
          <tr>
             <td>
               <% if (null != currentLink && currentLink.equalsIgnoreCase("KEYWORD_CRAWLER")) {%>
                  <div class="submenu1">
              <%}else {%>
                  <div class="submenu2">
              <%}%>
                    &nbsp;&nbsp;
                    <a class="text-white-link" href="keyword_pubmed_crawler.htm"><span class="exbold">Keyword Crawl</span></a>
                    &nbsp;&nbsp;
                 </div>
             </td>
             <td>
              <% if (null != currentLink && currentLink.equalsIgnoreCase("KEYWORD_CRAWL_RESULTS")) {%>
                  <div class="submenu1">
              <%}else {%>
                  <div class="submenu2">
              <%}%>
                     &nbsp;&nbsp;
                     <a class="text-white-link" href="keyword_crawl_results.htm?p_datagrid_datagrid1_page_index=0&p_datagrid_datagrid1_order_index=-2"><span class="exbold">Keyword Results</span></a>
                     &nbsp;&nbsp;
                   </div>
             </td>
             <td>
             <% if (null != currentLink && currentLink.equalsIgnoreCase("NETWORKMAP")) {%>
                <div class="submenu1">
             <%}else {%>
                <div class="submenu2">
             <%}%>
                   &nbsp;&nbsp;
                   <a class="text-white-link" href="networkMap.jsp"><span class="exbold">Network Map</span></a>
                   &nbsp;&nbsp;
               </div>
             </td>
          </tr>
        </table>
      </td>
    </tr>