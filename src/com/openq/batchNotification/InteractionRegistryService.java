package com.openq.batchNotification;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class InteractionRegistryService extends HibernateDaoSupport implements IInteractionRegistryService{

	public void deleteRegistration(long userId) {
		List result = getHibernateTemplate().find("from InteractionRegistry IR");
		
		if(result != null && result.size()>0){
			getHibernateTemplate().delete((InteractionRegistry)result.get(0));
		}
		
	}

	public InteractionRegistry getRegistration(long userId) {
		List result = getHibernateTemplate().find("from InteractionRegistry IR");
		if(result != null && result.size()>0){
			return (InteractionRegistry)result.get(0);
		}
		return null;
	}

	public void saveRegistration(InteractionRegistry  interactionRegistry) {
	 
		getHibernateTemplate().save(interactionRegistry);
		
	}
	
	

}
