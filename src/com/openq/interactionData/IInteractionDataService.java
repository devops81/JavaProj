package com.openq.interactionData;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Feb 14, 2007
 * Time: 5:13:53 PM
 * To change this template use File | Settings | File Templates.
 */
public interface IInteractionDataService {

    public InteractionData[] getAllDataOnType(long interactionId,String type);

	public void saveInteractionData(InteractionData data);

	public void updateInteractionData(InteractionData data);

	public void deleteInteractionData(InteractionData data);

	public InteractionData [] getInteractionData(long id);

    public void updateInteractionData(long interactionId, InteractionData[] newData,String type);
    
    public int getAttendeeCountFromInteractionData(long interactionId);
    	 
    public int getInteractionsCountForEvent(long eventId);
    
    public void deleteInteractionDataByType(long interactionId, String type);
    
    public void saveInteractionData(InteractionData [] newInteractionData);
}
