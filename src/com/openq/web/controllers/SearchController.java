package com.openq.web.controllers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.EavConstants;
import com.openq.eav.entitySearch.EntitySearchService;
import com.openq.eav.entitySearch.IEntitySearchService;
import com.openq.eav.metadata.AttributeType;
import com.openq.kol.DBUtil;
import com.openq.user.User;
import com.openq.utils.MutableInteger;
import com.openq.web.ActionKeys;


public class SearchController extends AbstractController {

  IEntitySearchService entitySearchService;

  public ModelAndView handleRequestInternal(HttpServletRequest request,
      HttpServletResponse response) throws Exception {
	  
	  
	ModelAndView mav = new ModelAndView("search");
    HttpSession session = request.getSession();
    String action =null;
    if(null==session.getAttribute("action"))
    {
    	action = request.getParameter("action");
    }
    else
    {
    	action=(String)session.getAttribute("action");
    }
    String reset=request.getParameter("reset");
    if(reset != null && ActionKeys.RESET_ADVANCE_SEARCH.equals(reset)){
        session.removeAttribute("experts");
        session.removeAttribute("experts_stats");
        session.removeAttribute("orgs");
        session.removeAttribute("orgs_stats");
        session.removeAttribute("trials");
        session.removeAttribute("trials_stats");
        session.removeAttribute("searchText");
        session.removeAttribute("keyword");
        session.removeAttribute("selected_searchParams");
        session.removeAttribute("selectedSearchParam1");
        session.removeAttribute("selectedSearchParam2");
        session.removeAttribute("searchBuilder");
        session.removeAttribute("orgCheckBox");
        session.removeAttribute("trialCheckBox");
        session.removeAttribute("action");
        removePaginationSessions(session);
        session.setAttribute("keyword", "<Enter Keyword>");
        session.setAttribute("CURRENT_LINK", "ADVANCED_SEARCH");
        return mav;
    }
    String removeAction= request.getParameter("removeAction");
    if(null!=removeAction && removeAction.equalsIgnoreCase("true"))
    {
    	session.removeAttribute("action");
    }
    long userGroupId =-1;
    String userGroupIdStr = (String)request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
    if(null!=userGroupIdStr){
    	userGroupId= Long.parseLong(userGroupIdStr);
    }
    List attrList = entitySearchService.getSearchableAttributesForEntity(EavConstants.KOL_ENTITY_ID,userGroupId);
    AttributeType[] attributes = (AttributeType[])attrList.toArray(new AttributeType[attrList.size()]);
    if(attributes!=null){
    	session.setAttribute("EXPERT_SEARCHABLE_ATTRIBUTES", attributes);
    }
    session.removeAttribute("selected_searchParams");
    session.removeAttribute("selectedSearchParam1");
    session.removeAttribute("selectedSearchParam2");
    session.removeAttribute("selectText");
    session.removeAttribute("searchBuilder");
    session.setAttribute("CURRENT_LINK", "ADVANCED_SEARCH");
    
    String eavTrial = "true";
    java.util.Properties profileProp = DBUtil.getInstance().featuresProp;
    if(profileProp.getProperty("EAV_TRIAL")!=null)
    {  if(profileProp.getProperty("EAV_TRIAL").equalsIgnoreCase("false")) 
      {
       eavTrial = "false";
      }
    }
    session.setAttribute("eavTrial", eavTrial);    
    
    String fromEvent=request.getParameter("fromEvent");
    if(fromEvent != null && fromEvent.equalsIgnoreCase("true"))
    { 	
      
      session.setAttribute("fromEvent", fromEvent);
      session.removeAttribute("experts");
      session.removeAttribute("experts_stats");
      session.removeAttribute("orgs");
      session.removeAttribute("orgs_stats");
      session.removeAttribute("trials");
      session.removeAttribute("trials_stats");
      session.removeAttribute("searchText");
      session.removeAttribute("selected_searchParams");
      session.removeAttribute("keyword");
    }
    else
    	{
       session.removeAttribute("fromEvent");
      }
    String fromOLAlignemnt =request.getParameter("fromOLAlignment");
    if(fromOLAlignemnt !=null && fromOLAlignemnt.equalsIgnoreCase("true")){
        System.out.println("Coming to OLAlignment");
        session.setAttribute("fromOLAlignment",fromOLAlignemnt);
    }else
        session.removeAttribute("fromOLAlignment");
    
    if((request.getParameterValues("invitedOl")) != null)
    {
    	String[] attendees = request.getParameterValues("invitedOl");
    	session.setAttribute("attendees",attendees);
    }
    
    String keyword = request.getParameter("searchText"); // First name
    // System.out.println("keyword : action = "+keyword+" : "+action);
    keyword = (keyword == null ? keyword : keyword.trim());
    LinkedHashMap matches = new LinkedHashMap();
    String test= request.getParameter("attributeFilter2");
    String rps = request.getParameter("removePageSession");
    String expertCheckBox;
    String orgCheckBox;
    if(rps!=null && rps.equalsIgnoreCase("True"))
    {
    	session.removeAttribute("expertCheckBox");
    	session.removeAttribute("orgCheckBox");
    	String isSAXAJVUserString = (String) session.getAttribute(Constants.IS_SAXA_JV_GROUP_USER);
    	expertCheckBox=request.getParameter("expertCheckBox");
    	orgCheckBox=request.getParameter("orgCheckBox");
    	boolean isSAXAJVUser = false;
    	if(isSAXAJVUserString != null && "true".equals(isSAXAJVUserString)){
    			isSAXAJVUser = true;
    	}
    	
    	String isOTSUKAJVUserString = (String) session.getAttribute(Constants.IS_OTSUKA_JV_GROUP_USER);
		boolean isOTSUKAJVUser = false;
		if(isOTSUKAJVUserString != null && "true".equals(isOTSUKAJVUserString)){
				isOTSUKAJVUser = true;
		}
		
    	if(isSAXAJVUser || isOTSUKAJVUser){
    		session.setAttribute("expertCheckBox", "on");
    	}else{
    		session.setAttribute("expertCheckBox", expertCheckBox);
    	}
    	session.setAttribute("orgCheckBox", orgCheckBox);
    }
    // set links for prev and next
    String linkClicked = request.getParameter("linkClicked");
    Integer nextLinkObj = (Integer) session.getAttribute(Constants.NEXT_SEARCH_RESULTS_START_LINK);
    Integer prevLinkObj = (Integer) session.getAttribute(Constants.PREV_SEARCH_RESULTS_START_LINK);
    if(linkClicked != null){
    	if(Constants.PREV_SEARCH_RESULTS_START_LINK.equals(linkClicked)){
    		int nextLink = nextLinkObj != null ? (nextLinkObj.intValue()) - Constants.LINKS_PER_PAGE : -1;
  	    	session.setAttribute(Constants.NEXT_SEARCH_RESULTS_START_LINK, new Integer(nextLink));
	  	    int prevLink = prevLinkObj != null ? (prevLinkObj.intValue() - Constants.LINKS_PER_PAGE) : -1;
	  	    session.setAttribute(Constants.PREV_SEARCH_RESULTS_START_LINK, new Integer(prevLink));
    	}else if(Constants.NEXT_SEARCH_RESULTS_START_LINK.equals(linkClicked)){
    		int nextLink = nextLinkObj != null ? (nextLinkObj.intValue()) + Constants.LINKS_PER_PAGE : -1;
	    	session.setAttribute(Constants.NEXT_SEARCH_RESULTS_START_LINK, new Integer(nextLink));
	  	    int prevLink = nextLinkObj != null ? (nextLinkObj.intValue() - Constants.LINKS_PER_PAGE) : -1;
	  	    session.setAttribute(Constants.PREV_SEARCH_RESULTS_START_LINK, new Integer(prevLink));
    	}
    }else{
    	session.setAttribute(Constants.PREV_SEARCH_RESULTS_START_LINK, new Integer(-1));
    	session.setAttribute(Constants.NEXT_SEARCH_RESULTS_START_LINK, new Integer(Constants.LINKS_PER_PAGE));
    }
   expertCheckBox= (String)session.getAttribute("expertCheckBox");
   orgCheckBox=(String)session.getAttribute("orgCheckBox");
   if(action!=null&&action.equals("expertAttributeSearch") && expertCheckBox!=null && expertCheckBox.equalsIgnoreCase("on"))
    {
	   session.setAttribute("action", action);
	   if(keyword!=null)
	   {
		   session.setAttribute("keyword", keyword);
	   }
      Map idValuePair = new LinkedHashMap();
      String selectText=request.getParameter("selectText");
      if(selectText!=null)
      {
        idValuePair.put("searchParam",request.getParameter("selectText"));
        session.setAttribute("selectText", selectText);
      }
      List selectedParams = new ArrayList();
      for(int i=1;i<=8;i++)
      {
    	if(request.getParameter("attributeFilter"+i)!=null)
        {
          
          if(request.getParameter("searchAttributeText"+i)!=null&&!request.getParameter("searchAttributeText"+i).trim().equals(""))
          {
            String attrId = request.getParameter("attributeFilter"+i);
            String searchValue =  request.getParameter("searchAttributeText"+i);
            searchValue = searchValue.trim();
            searchValue = searchValue.replaceAll("'", "''");
            String[] selectedAttrs = new String[2];
            selectedAttrs[0] = attrId;
            selectedAttrs[1] = searchValue;
            
            if(i==1||i==2)
            {
              session.setAttribute("selectedSearchParam"+i, selectedAttrs);
            }
            else
            {
              
              selectedParams.add(selectedAttrs);  
            }
            if(idValuePair.get(attrId)!=null)
            {
              Set keyWordSet = (Set)idValuePair.get(attrId);
              idValuePair.remove(attrId);
              keyWordSet.add(searchValue);
              idValuePair.put(attrId,keyWordSet);
              
            }
            else
            {
              Set keyWordSet = new HashSet();
              keyWordSet.add(searchValue);
              idValuePair.put(attrId,keyWordSet);  
              
            }
            
          }
            
        }
          
      }
      
  //    matches = entitySearchService.getEntitiesMap(idValuePair);
      Map ExpertResultMap= new LinkedHashMap();
      MutableInteger stopSearchIndex= new MutableInteger(0);
      MutableInteger startSearchIndex= new MutableInteger(0);
      int currentPage=0;
      LinkedList startList= new LinkedList();
      String remPageSession= (String)request.getParameter("removePageSession");
      
      
      
      if(null!=remPageSession && remPageSession.equalsIgnoreCase("True"))
      {
      	session.removeAttribute("IS_FIRST_TIME_PAGINATION");
      	removePaginationSessions(session);
      	
      }
      if(!(session.getAttribute("IS_FIRST_TIME_PAGINATION")!=null && !session.getAttribute("IS_FIRST_TIME_PAGINATION").toString().equalsIgnoreCase("True")))
      {
      	int extraPage=0;
      	ExpertResultMap = (LinkedHashMap)entitySearchService.getResultMap(idValuePair);
      	session.setAttribute("USER_RESULT_COUNT", new MutableInteger(ExpertResultMap.size()));
    	if((ExpertResultMap.size()%Constants.MAX_NUM_USERS_PER_PAGE)!=0)
    	{
    		extraPage=1;
    	}
    	int pageCount= (ExpertResultMap.size()/Constants.MAX_NUM_USERS_PER_PAGE)+extraPage;
    	session.setAttribute("TOTAL_NUMBER_OF_PAGES", new Integer(pageCount));
    	session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
    	
    //	stopSearchIndex= new MutableInteger(0);
    	startSearchIndex= new MutableInteger(0);
    	
    	startList.add(new Integer(startSearchIndex.getNumber()));
    	session.setAttribute("IS_FIRST_TIME_PAGINATION", "False");
    	session.setAttribute("EXPERT_RESULT_MAP", ExpertResultMap);
 //   	session.setAttribute("STOP_SEARCH_INDEX", stopSearchIndex);
    	session.setAttribute("START_SEARCH_INDEX", startSearchIndex);
    	session.setAttribute("START_LIST", startList);
      }
      String pageNumber= (String)request.getParameter("pageNumber");
      Integer currentPageInteger= (Integer)session.getAttribute("CURRENT_PAGE");
      if(null!=currentPageInteger)
      {
    	  try
    	  {
    		  currentPage=currentPageInteger.intValue();
    	  }
    	  catch(Exception e)
    	  {
    		  logger.error("exception caught ::" + e.getMessage()+ "  currentpage: "+ currentPageInteger);
    	  }
      }
    	  
      currentPage=((Integer)session.getAttribute("CURRENT_PAGE")).intValue();
      if(pageNumber!=null && pageNumber.equalsIgnoreCase("true"))
      {
      	if(currentPage>0)
      	{
      		currentPage-=1;
      		session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
      	}
      }
      else if(pageNumber!=null && pageNumber.equalsIgnoreCase("false"))
      {
      	int maxPage=((Integer)session.getAttribute("TOTAL_NUMBER_OF_PAGES")).intValue();
      	if(currentPage<maxPage-1)
      	{
      		currentPage+=1;
      		session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
      	}
      }
      
      else if(pageNumber!=null)
      {
  		try
  		{
  			currentPage=Integer.parseInt(pageNumber);
  			session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
  		}
  	    catch(Exception e)
  	    {
  	    	logger.error("exception caught please check :: "+ e.getMessage()+"  value of previousText: "+ pageNumber);
  	    }
      }
      startSearchIndex=new MutableInteger(currentPage*Constants.MAX_NUM_USERS_PER_PAGE);
  	
  	 matches= entitySearchService.fetchKOLMap((LinkedHashMap)session.getAttribute("EXPERT_RESULT_MAP"),startSearchIndex);
     /*set the start_search_index=stopSearchIndex 
      * so that the fetch Experts starts from the index where the previous fetch ended.
      * */
     session.setAttribute("START_SEARCH_INDEX", stopSearchIndex); 
     session.setAttribute("STOP_SEARCH_INDEX", stopSearchIndex);
      session.setAttribute("CURRENT_LINK", "ADVANCED_SEARCH");
      LinkedHashMap expertsFound = (LinkedHashMap) matches.get(EntitySearchService.EXPERTS);
      session.setAttribute("experts", expertsFound);
      session.setAttribute("experts_stats", matches.get(EntitySearchService.EXPERTS_STATS));
      session.setAttribute("selected_searchParams",selectedParams);
      request.getSession().setAttribute("myexperts", expertsFound.keySet().toArray(new User[0]));
      request.getSession().setAttribute("searchBuilder","true");
    } 
   boolean goIn=false;
   if((expertCheckBox!=null && expertCheckBox.equalsIgnoreCase("on"))||(orgCheckBox!=null && orgCheckBox.equalsIgnoreCase("on")))
   {
	   goIn=true;
   }
   else
   {
	   goIn=false;
   }
   if(keyword!=null && !keyword.equalsIgnoreCase("<Enter Keyword>")&& goIn)
    {
	   if(null!=session.getAttribute("action"))
	   {
		   session.removeAttribute("action");
	   }
    	session.setAttribute("keyword", keyword);
    /* check if the pagination is happening for the first time or not.
     * if it is happening for the first time then no need of calling getExpertSerachResultSet 
     * 
     *go in side the if() , if it is the first time ;)
    */
    LinkedHashMap ExpertResultMap= new LinkedHashMap();
    LinkedHashMap orgResultMap= new LinkedHashMap();
    MutableInteger stopSearchIndex= new MutableInteger(0);
    MutableInteger startSearchIndex= new MutableInteger(0);
    MutableInteger stopSearchIndexOrg= new MutableInteger(0);
    MutableInteger startSearchIndexOrg= new MutableInteger(0);
    int currentPage=0;
    int currentPageOrg=0;
    String remPageSession= (String)request.getParameter("removePageSession");
    
    
    
    if(null!=remPageSession && remPageSession.equalsIgnoreCase("True"))
    {
    	session.removeAttribute("IS_FIRST_TIME_PAGINATION");
    	removePaginationSessions(session);
    	
    }
    if(!(session.getAttribute("IS_FIRST_TIME_PAGINATION")!=null && !session.getAttribute("IS_FIRST_TIME_PAGINATION").toString().equalsIgnoreCase("True")))
    {
    	int extraPage=0;
    	int extraPageOrg=0;
    	if(expertCheckBox!=null && expertCheckBox.equalsIgnoreCase("on"))
    	{
    		ExpertResultMap=(LinkedHashMap)entitySearchService.getExpertsSerachResultSet(keyword, userGroupId);
	    	session.setAttribute("USER_RESULT_COUNT", new MutableInteger(ExpertResultMap.size()));
	    	if((ExpertResultMap.size()%Constants.MAX_NUM_USERS_PER_PAGE)!=0)
	    	{
	    		extraPage=1;
	    	}
	    	int pageCount= (ExpertResultMap.size()/Constants.MAX_NUM_USERS_PER_PAGE)+extraPage;
	    	session.setAttribute("TOTAL_NUMBER_OF_PAGES", new Integer(pageCount));
	    	session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
	    	
	    	stopSearchIndex= new MutableInteger(0);
	    	startSearchIndex= new MutableInteger(0);
	    	
	    	session.setAttribute("IS_FIRST_TIME_PAGINATION", "False");
	    	session.setAttribute("EXPERT_RESULT_MAP", ExpertResultMap);
	    	session.setAttribute("STOP_SEARCH_INDEX", stopSearchIndex);
	    	session.setAttribute("START_SEARCH_INDEX", startSearchIndex);
    	}
    	if(orgCheckBox!=null && orgCheckBox.equalsIgnoreCase("on"))
    	{
    		orgResultMap=(LinkedHashMap)entitySearchService.getOrgSerachResultSet(keyword);
    		session.setAttribute("ORG_RESULT_COUNT", new MutableInteger(orgResultMap.size()));
	    	if((orgResultMap.size()%Constants.MAX_NUM_USERS_PER_PAGE)!=0)
	    	{
	    		extraPageOrg=1;
	    	}
	    	int pageCount= (orgResultMap.size()/Constants.MAX_NUM_USERS_PER_PAGE)+extraPage;
	    	session.setAttribute("ORG_TOTAL_NUMBER_OF_PAGES", new Integer(pageCount));
	    	session.setAttribute("ORG_CURRENT_PAGE", new Integer(currentPageOrg));
	    	
	    	stopSearchIndex= new MutableInteger(0);
	    	startSearchIndex= new MutableInteger(0);
	    	
	    	session.setAttribute("IS_FIRST_TIME_PAGINATION", "False");
	    	session.setAttribute("ORG_RESULT_MAP", orgResultMap);
	    	session.setAttribute("ORG_STOP_SEARCH_INDEX", stopSearchIndexOrg);
	    	session.setAttribute("ORG_START_SEARCH_INDEX", startSearchIndexOrg);
    		
    	}
    }
    if(expertCheckBox!=null && expertCheckBox.equalsIgnoreCase("on"))
    {
	    String pageNumber= (String)request.getParameter("pageNumber");
	    Integer currentPageInteger= (Integer)session.getAttribute("CURRENT_PAGE");
	    if(null!=currentPageInteger)
	    {
	  	  try
	  	  {
	  		  currentPage=currentPageInteger.intValue();
	  	  }
	  	  catch(Exception e)
	  	  {
	  		  logger.error("exception caught ::" + e.getMessage()+ "  currentpage: "+ currentPageInteger);
	  	  }
	    }
	    if(pageNumber!=null && pageNumber.equalsIgnoreCase("true"))
	    {
	    	if(currentPage>0)
	    	{
	    		currentPage-=1;
	    		session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
	    	}
	    }
	    else if(pageNumber!=null && pageNumber.equalsIgnoreCase("false"))
	    {
	    	int maxPage=((Integer)session.getAttribute("TOTAL_NUMBER_OF_PAGES")).intValue();
	    	if(currentPage<maxPage-1)
	    	{
	    		currentPage+=1;
	    		session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
	    	}
	    }
	    
	    else if(pageNumber!=null)
	    {
			try
			{
				currentPage=Integer.parseInt(pageNumber);
				session.setAttribute("CURRENT_PAGE", new Integer(currentPage));
			}
		    catch(Exception e)
		    {
		    	logger.error("exception caught please check :: "+ e.getMessage()+"  value of previousText: "+ pageNumber);
		    }
	    }
	    startSearchIndex=new MutableInteger(currentPage*Constants.MAX_NUM_USERS_PER_PAGE);
		stopSearchIndex=new MutableInteger(currentPage*Constants.MAX_NUM_USERS_PER_PAGE);
		matches= entitySearchService.fetchKOLMap((LinkedHashMap)session.getAttribute("EXPERT_RESULT_MAP"),startSearchIndex,stopSearchIndex);
	    /*set the start_search_index=stopSearchIndex 
	     * so that the fetch Experts starts from the index where the previous fetch ended.
	     * */
	    session.setAttribute("START_SEARCH_INDEX", stopSearchIndex); 
	    session.setAttribute("STOP_SEARCH_INDEX", stopSearchIndex);
	    LinkedHashMap expertsFound = (LinkedHashMap) matches.get(EntitySearchService.EXPERTS);
	    session.setAttribute("experts", expertsFound);
	    session.setAttribute("experts_stats", matches.get(EntitySearchService.EXPERTS_STATS));
	    request.getSession().setAttribute("myexperts", expertsFound.keySet().toArray(new User[0]));
    }
    if(orgCheckBox!=null && orgCheckBox.equalsIgnoreCase("on"))
    {
	    String pageNumberOrg= (String)request.getParameter("pageNumberOrg");
	    Integer currentPageIntegerOrg= (Integer)session.getAttribute("ORG_CURRENT_PAGE");
	    if(null!=currentPageIntegerOrg)
	    {
	  	  try
	  	  {
	  		currentPageOrg=currentPageIntegerOrg.intValue();
	  	  }
	  	  catch(Exception e)
	  	  {
	  		  logger.error("exception caught ::" + e.getMessage()+ "  currentpage: "+ currentPageIntegerOrg);
	  	  }
	    }
	    if(pageNumberOrg!=null && pageNumberOrg.equalsIgnoreCase("true"))
	    {
	    	if(currentPageOrg>0)
	    	{
	    		currentPageOrg-=1;
	    		session.setAttribute("ORG_CURRENT_PAGE", new Integer(currentPageOrg));
	    	}
	    }
	    else if(pageNumberOrg!=null && pageNumberOrg.equalsIgnoreCase("false"))
	    {
	    	int maxPageOrg=((Integer)session.getAttribute("ORG_TOTAL_NUMBER_OF_PAGES")).intValue();
	    	if(currentPageOrg<maxPageOrg-1)
	    	{
	    		currentPageOrg+=1;
	    		session.setAttribute("ORG_CURRENT_PAGE", new Integer(currentPageOrg));
	    	}
	    }
	    
	    else if(pageNumberOrg!=null)
	    {
			try
			{
				currentPageOrg=Integer.parseInt(pageNumberOrg);
				session.setAttribute("ORG_CURRENT_PAGE", new Integer(currentPageOrg));
			}
		    catch(Exception e)
		    {
		    	logger.error("exception caught please check :: "+ e.getMessage()+"  value of previousText: "+ currentPageOrg);
		    }
	    }
	    startSearchIndexOrg=new MutableInteger(currentPageOrg*Constants.MAX_NUM_USERS_PER_PAGE);
		stopSearchIndexOrg=new MutableInteger(currentPageOrg*Constants.MAX_NUM_USERS_PER_PAGE);
		LinkedHashMap orgMatches= new LinkedHashMap();
		try
		{
			orgMatches= entitySearchService.fetchORGMap((LinkedHashMap)session.getAttribute("ORG_RESULT_MAP"),startSearchIndexOrg);
		
	    /*set the start_search_index=stopSearchIndex 
	     * so that the fetch Experts starts from the index where the previous fetch ended.
	     * */
		    session.setAttribute("ORG_START_SEARCH_INDEX", startSearchIndexOrg); 
		    session.setAttribute("ORG_STOP_SEARCH_INDEX", stopSearchIndexOrg);
		    LinkedHashMap orgsFound = (LinkedHashMap) orgMatches.get(EntitySearchService.ORGS);
		    session.setAttribute("orgs", orgsFound);
		    session.setAttribute("orgs_stats", orgMatches.get(EntitySearchService.ORGS_STATS));
		}
		catch(Exception e)
		{
			logger.error("caught:: at orgmatches  "+ e.getMessage());
		}
    }
  }
    return mav;
  }
  public void removePaginationSessions(HttpSession session)
  {
	  
	if(null!=session.getAttribute("USER_RESULT_COUNT"))
  	{
  		session.removeAttribute("USER_RESULT_COUNT");	
  	}
  	if(null!=session.getAttribute("EXPERT_RESULT_MAP"))
  	{
  		session.removeAttribute("EXPERT_RESULT_MAP");
  	}
  	if(null!=session.getAttribute("STOP_SEARCH_INDEX"))
  	{
  		session.removeAttribute("STOP_SEARCH_INDEX");	
  	}
  	if(null!=session.getAttribute("START_SEARCH_INDEX"))
  	{
  		session.removeAttribute("START_SEARCH_INDEX");
  	}
  	if(null!=session.getAttribute("TOTAL_NUMBER_OF_PAGES"))
  	{
  		session.removeAttribute("TOTAL_NUMBER_OF_PAGES");	
  	}
  	if(null!=session.getAttribute("CURRENT_PAGE"))
  	{
  		session.removeAttribute("CURRENT_PAGE");	
  	}
  	if(null!=session.getAttribute("experts"))
  	{
  		session.removeAttribute("experts");	
  	}
 	if(null!=session.getAttribute("experts_stats"))
  	{
  		session.removeAttribute("experts_stats");	
  	}
 	if(null!=session.getAttribute("myexperts"))
  	{
  		session.removeAttribute("myexperts");	
  	}
  	if(null!=session.getAttribute("ORG_RESULT_COUNT"))
  	{
  		session.removeAttribute("ORG_RESULT_COUNT");	
  	}
  	if(null!=session.getAttribute("ORG_RESULT_MAP"))
  	{
  		session.removeAttribute("ORG_RESULT_MAP");	
  	}
  	if(null!=session.getAttribute("ORG_STOP_SEARCH_INDEX"))
  	{
  		session.removeAttribute("ORG_STOP_SEARCH_INDEX");	
  	}
  	if(null!=session.getAttribute("ORG_START_SEARCH_INDEX"))
  	{
  		session.removeAttribute("ORG_START_SEARCH_INDEX");	
  	}
	if(null!=session.getAttribute("ORG_TOTAL_NUMBER_OF_PAGES"))
  	{
  		session.removeAttribute("ORG_TOTAL_NUMBER_OF_PAGES");	
  	}
	if(null!=session.getAttribute("ORG_CURRENT_PAGE"))
  	{
  		session.removeAttribute("ORG_CURRENT_PAGE");	
  	}
	if(null!=session.getAttribute("orgs"))
  	{
  		session.removeAttribute("orgs");	
  	}
	if(null!=session.getAttribute("orgs_stats"))
  	{
  		session.removeAttribute("orgs_stats");	
  	}
  }

   
    	 
  public IEntitySearchService getEntitySearchService() {
    return entitySearchService;
  }

  public void setEntitySearchService(IEntitySearchService entitySearchService) {
    this.entitySearchService = entitySearchService;
  }
}
