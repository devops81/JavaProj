package com.openq.group;

import org.springframework.orm.hibernate.HibernateTemplate;

public class UserGroupsService {
	
	private HibernateTemplate hibernateTemplate;
	
	public void saveGroups(Groups group){
		hibernateTemplate.save(group);
	}
	
	public void updateGroups(Groups group){
		hibernateTemplate.update(group);
	}
	
	public void deleteGroups(Groups group){
		hibernateTemplate.delete(group);
	}
	
	//load data
	
	//get all groups

}
