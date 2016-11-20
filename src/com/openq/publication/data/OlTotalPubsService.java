package com.openq.publication.data;


import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;



public class OlTotalPubsService  extends HibernateDaoSupport implements IOlTotalPubsService {
	
	private Hashtable olPubSummaryHashOnAuthorId;
	
	
	public void updateTotalPubs(OlTotalPubs msg){
		getHibernateTemplate().update(msg);
	}
	
	public void addTotalPubs(OlTotalPubs msg){
		getHibernateTemplate().save(msg);
	}
	
	public List getAllTotalPubs(){
		 return getHibernateTemplate().find("from OlTotalPubs "); 
	}
	
	public Hashtable getAllOlTotalPubsHashedOnAuthorId()
	{
		olPubSummaryHashOnAuthorId = new Hashtable();
	    List olPubSummaryList = getAllTotalPubs();
	    Iterator iterator = olPubSummaryList.iterator();
	    while( iterator.hasNext() )
	    {
	    	OlTotalPubs olTotalPubs = (OlTotalPubs) iterator.next();
	    	olPubSummaryHashOnAuthorId.put(new Long(olTotalPubs.getAuthorId()),olTotalPubs);
	    }
	    return olPubSummaryHashOnAuthorId;
	}

}
