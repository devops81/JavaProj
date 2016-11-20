package com.openq.batchNotification;

public interface IInteractionRegistryService {
	
	public void saveRegistration(InteractionRegistry  interactionRegistry);
	
	public InteractionRegistry getRegistration(long userId);
	
	public void deleteRegistration(long userId);

}
