package com.openq.Notify;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class NotifyService extends HibernateDaoSupport implements INotifyService{
	
	  public void registerNotification(Notification notification)
	  {
		  getHibernateTemplate().save(notification);
		  
	  }
	  public void deregisterNotification(Notification notification)
	  {
		  List result = getHibernateTemplate().find("from Notification where kolId=" + notification.getKolId() +  
				  			" and userId = "+notification.getUserId());
		  if(result!=null && result.size()>0)
		  getHibernateTemplate().delete(result.get(0));
	  }

}
