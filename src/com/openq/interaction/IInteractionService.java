package com.openq.interaction;


import java.util.Date;
import java.util.List;
import java.util.Map;

import com.openq.eav.option.OptionLookup;

public interface IInteractionService {

	public Interaction getInteraction(long interactionId);

    public Interaction[] getRecentInteractionsByExpert(long expertId);
    
    public Interaction[] getRecentInteractionsByExpert(long expertId,OptionLookup product,String type, boolean isSAXAJVUser);
    
	public Interaction[] getAllInteractionByUser(long userId);

	public void saveInteraction(Interaction interaction);

	public void updateInteraction(Interaction interaction);

	public void deleteInteraction(Interaction interaction);

    public Object[] getCreatedBy(long interactionId,long userId);
    
    public Interaction[] getCreatedByandUpdatedBy(Date fromDate, Date toDate);
    
    public InteractionTripletSectionMap[] getInteractionTripletSectionMap();
    
    public Map getInteractionIdFirstTopicMap(String commaSeparatedInteractionIds);
    
    public List getInteractionResultsList (Date fromDate, Date toDate, long userId, String OLOrgName, long productLOVId, boolean isSAXAJVUser, long expertId);
   
    public List getAllInteractionsByExpertId (long expertId);
    
    public List getAllInteractionByNotfication(Date fromDate, Date toDate);
    
    public int getSearchResultCutoff();
    
    public Interaction[] getAllInteractionByExpert(long expertId);

 }