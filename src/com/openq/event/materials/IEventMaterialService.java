package com.openq.event.materials;

public interface IEventMaterialService {
	public EventMaterial getEventMaterial(long materialId);
	public EventMaterial[] getAllEventMaterialsOfEvent(long eventId);
	public void saveEventMaterial(EventMaterial eventMaterial);
	public void deleteEventMaterial(long materialID);
}
