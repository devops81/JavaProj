package com.openq.publication.data;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class OlPubSummaryService extends HibernateDaoSupport implements IOlPubSummaryService{

	public void addOlSummary(OlPublicationSummaryDTO msg) {
		getHibernateTemplate().save(msg);
	}

	public void updateOlSummary(OlPublicationSummaryDTO msg) {
		getHibernateTemplate().update(msg);
	}

	public OlPublicationSummaryDTO [] getAllOlPubSummary() {
		
		List result = getHibernateTemplate().find("from OlPublicationSummaryDTO order by pubsinprofile");
		
		return (OlPublicationSummaryDTO [])result.toArray(new OlPublicationSummaryDTO[result.size()]);
	}
	
	public OlPublicationSummaryDTO getOlPubSummary(long authorId){
		List result=getHibernateTemplate().find(" from OlPublicationSummaryDTO where OLID ="+ authorId );
		if(result != null && result.size()!= 0)
			return((OlPublicationSummaryDTO)result.get(0));
		else
			return null;
		
	}
}
