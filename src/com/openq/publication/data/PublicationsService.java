package com.openq.publication.data;



import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;


public class PublicationsService extends HibernateDaoSupport implements IPublicationsService{

	private Hashtable olPubsHashOnISSN;
	
	public void addpublication(Publications publication) {
		getHibernateTemplate().save(publication);
		
	}
	public void updatePublication(Publications pub){
		getHibernateTemplate().update(pub);
	}

	public Publications [] getAllPublicationsOfOl(long authorId) {
		List result = getHibernateTemplate().find("from Publications where author_id="+ authorId +" ORDER BY COMMIT_FLAG DESC,year_of_publication desc");
        return (Publications[]) result.toArray(new Publications[result.size()]);
	}
	
	public Hashtable deleteOlPublicationsOfYearHashedOnISSN(long authorId,int lastYear)
	{
		olPubsHashOnISSN = new Hashtable();
	    List olPubsList = getHibernateTemplate().find("from Publications where author_id="+authorId+" and year_of_publication="+ lastYear);
	    Iterator iterator = olPubsList.iterator();
	    while( iterator.hasNext() )
	    {
	    	Publications pub=(Publications)iterator.next();
	    	olPubsHashOnISSN.put(pub.getIssn(),pub);
	    }
	    getHibernateTemplate().deleteAll(olPubsList);
		return olPubsHashOnISSN;
	}
	
	public Publications [] getPublicationsInProfile(long authorId){
		List result=getHibernateTemplate().find("from Publications where commit_flag > 0 and author_Id = "+ authorId);
		return (Publications[]) result.toArray(new Publications[result.size()]);
	}
	
	public Publications [] getUncommittedPublications (long authorId){
		List result=getHibernateTemplate().find(" from Publications where commit_flag =0 and author_Id ="+ authorId);
		return (Publications[]) result.toArray(new Publications[result.size()]);	
	}
	
	public Publications [] getNewPublications (long authorId, Date lastcapture){
		List result=getHibernateTemplate().find(" from Publications where author_id ="+ authorId + " and create_Time = TO_TIMESTAMP('"+lastcapture.toString()+"','YYYY-MM-DD HH24:MI:SS.FF3')");
		return (Publications[]) result.toArray(new Publications[result.size()]);	
	}
	
	
	
	public Publications getlastProfileUpdate(long authorId){
		List result=getHibernateTemplate().find(" from Publications where author_id ="+ authorId + " order by update_Time desc ");
		if(result != null && result.size()!= 0)
			return ((Publications) result.get(0)); 
		else
			return null;
	}
	public Publications getlastProfileCapture(long authorId){
		List result=getHibernateTemplate().find(" from Publications where author_id ="+ authorId + " order by create_Time desc ");
		if(result != null && result.size()!= 0)
			return ((Publications) result.get(0)); 
		else
			return null;
	}
	public Publications getPublicationDetails(long publicationId) {
		
		List result=getHibernateTemplate().find(" from Publications where pub_id="+ publicationId );
		if(result != null && result.size()!= 0)
			return ((Publications) result.get(0)); 
		else
			return null;
	}

}
