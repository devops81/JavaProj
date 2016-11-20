package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.ig.pubmed.crawler.keyword.INetworkMapDataService;
import com.openq.ig.pubmed.crawler.keyword.KeywordCrawlResult;


/**
 * This class is used to handle all requests for reviewing Keyword Crawl results
 * 
 * @author Amit Arora 
 */
public class KeywordCrawlResultsController extends AbstractController {
	private static Logger logger = Logger.getLogger(KeywordCrawlResultsController.class);
	
	private INetworkMapDataService networkMapDataService;
	

    protected ModelAndView handleRequestInternal(HttpServletRequest httpServletRequest, 
                        HttpServletResponse httpServletResponse) throws Exception {
        logger.debug("Reviewing keyword crawl results");
        
        httpServletRequest.getSession().setAttribute("CURRENT_LINK", "KEYWORD_CRAWL_RESULTS");
        
        httpServletRequest.getSession().removeAttribute("confirmationMessage");
        
        KeywordCrawlResult[] results = networkMapDataService.getKeywordCrawlResults();
        
        httpServletRequest.getSession().setAttribute("keywordCrawlResults", results);
        
        ModelAndView mav = new ModelAndView("keyword_crawl_results");
        return mav;
    }


    public INetworkMapDataService getNetworkMapDataService() {
        return networkMapDataService;
    }


    public void setNetworkMapDataService(INetworkMapDataService networkMapDataService) {
        this.networkMapDataService = networkMapDataService;
    }
}