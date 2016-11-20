package com.openq.event.materials;
import java.util.List;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class EventMaterialService extends HibernateDaoSupport implements IEventMaterialService {

	public void saveEventMaterial(EventMaterial eventMaterial){
		getHibernateTemplate().save(eventMaterial);
	}
	
	public void deleteEventMaterial(long materialID){
		EventMaterial material = getEventMaterial(materialID);
	    getHibernateTemplate().delete(material);
	}
	
	public EventMaterial getEventMaterial(long materialID){
		List materialList = getHibernateTemplate().find(
		        "FROM EventMaterial m WHERE m.materialID = " + materialID);
		    if (materialList.size() == 1)
		      return (EventMaterial) materialList.get(0);
		    return null;
	}
	
	public EventMaterial[] getAllEventMaterialsOfEvent(long eventId){
		List material=getHibernateTemplate().find("FROM EventMaterial m where m.eventId= "+eventId);
		EventMaterial[] eventMaterials=(EventMaterial[])material.toArray(new EventMaterial[material.size()]);
		return (eventMaterials);
	}
}
