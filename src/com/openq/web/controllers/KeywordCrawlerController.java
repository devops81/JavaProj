package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import com.openq.ig.pubmed.crawler.keyword.INetworkMapDataService;
import com.openq.ig.pubmed.crawler.keyword.KeywordCategory;
import com.openq.ig.pubmed.crawler.keyword.KeywordCrawlQuery;
import com.openq.utils.StringUtil;
import com.openq.web.forms.KeywordCrawlerForm;


/**
 * This class is used to handle all requests for running the Keyword Crawler
 * 
 * @author Amit Arora 
 */
public class KeywordCrawlerController extends SimpleFormController {
	private static Logger logger = Logger.getLogger(KeywordCrawlerController.class);
	
    INetworkMapDataService networkMapDataService;
    
	public INetworkMapDataService getNetworkMapDataService() {
        return networkMapDataService;
    }

    public void setNetworkMapDataService(INetworkMapDataService networkMapDataService) {
        this.networkMapDataService = networkMapDataService;
    }

    public KeywordCrawlerController() {
		
	}

	/**
	 * Handle the request for rendering the geocoding experts form
	 */
	protected ModelAndView showForm(HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse,
            BindException bindException) throws Exception {
		logger.debug("Showing keyword crawler form");
		
        httpServletRequest.getSession().setAttribute("CURRENT_LINK", "KEYWORD_CRAWLER");
        
		httpServletRequest.getSession().removeAttribute("confirmationMessage");
		
        // get the list of existing keyword categories from the table
        KeywordCategory[] keywordCategories = networkMapDataService.getAllKeywordCategories();
        httpServletRequest.getSession().setAttribute("keywordCategories", keywordCategories);
        
		ModelAndView mav = new ModelAndView("keyword_pubmed_crawler");
		return mav;
	}
	
	/**
	 * Handle the request when the user tries to run the keyword crawler
	 */
	protected ModelAndView processFormSubmission(HttpServletRequest request,
            HttpServletResponse response,
            Object object, BindException exception) throws Exception {
		
        request.getSession().setAttribute("CURRENT_LINK", "KEYWORD_CRAWLER");
        
		request.getSession().removeAttribute("confirmationMessage");
		
        KeywordCrawlerForm kForm = (KeywordCrawlerForm) object;
        
        if(kForm.getActionToPerform().equalsIgnoreCase("crawl")) {
    		
            String[] selectedIds = kForm.getCategoryIds();
            
            String keyword = networkMapDataService.getKeywordForCategory(selectedIds[0]);
            
            // Get the actual path for the webapp directory
            String webappDir = request.getRealPath("");
            
            // Make sure that we got a non-empty keyword
            if(!StringUtil.isEmptyString(keyword)){
                // Start a keyword crawl for this word
                networkMapDataService.updateKeywordCategoryId(selectedIds[0], KeywordCategory.STATUS_RUNNING);
                
            }
    		
            request.getSession().setAttribute("confirmationMessage", "The crawler has started fetching the results for the specified keyword. It may take few minutes for processing to complete.");
        }
        else if(kForm.getActionToPerform().equalsIgnoreCase("delete")) {
            String[] selectedIds = kForm.getCategoryIds();
            if(selectedIds != null) {
                for(int i=0; i<selectedIds.length; i++) {
                    logger.debug("Deleting category with id : " + selectedIds[i]);
                }
                networkMapDataService.deleteCategories(kForm.getCategoryIds());
                
                // get the list of keyword categories from the table
                KeywordCategory[] keywordCategories = networkMapDataService.getAllKeywordCategories();
                request.getSession().setAttribute("keywordCategories", keywordCategories);
                
                request.getSession().setAttribute("confirmationMessage", "Deleted selected categories");
            }
            else {
                logger.debug("Didn't find any ids to delete");
            }
        }
        else if(kForm.getActionToPerform().equalsIgnoreCase("add")) {
            logger.debug("Adding category : " + kForm.getCategory() + " with keywords : " + kForm.getKeyword());
            networkMapDataService.storeNewKeywordCategory(kForm.getCategory(), kForm.getKeyword());
            
            // get the list of keyword categories from the table
            KeywordCategory[] keywordCategories = networkMapDataService.getAllKeywordCategories();
            request.getSession().setAttribute("keywordCategories", keywordCategories);
            
            request.getSession().setAttribute("confirmationMessage", "Added the new category");
        }
        
        ModelAndView mav = new ModelAndView("keyword_pubmed_crawler");
        return mav; 
	}
}