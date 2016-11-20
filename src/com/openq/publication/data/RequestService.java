package com.openq.publication.data;



import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;



public class RequestService extends HibernateDaoSupport implements IRequestService {

	public Request  getCaptureStatus(long userId) {
		List result = getHibernateTemplate().find("from Request where userID =" + userId);
		if(result != null && result.size()!= 0)
			return ((Request) result.get(0)); 
		return null;
	}

	public void updateCaptureStatus(Request request){
		getHibernateTemplate().update(request);
	}
	
	public void addCaptureStatus(Request request){
		getHibernateTemplate().save(request);
	}

}
