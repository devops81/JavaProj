package com.openq.group;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.mysql.jdbc.ResultSet;

public class GroupService extends HibernateDaoSupport implements IGroupService {
	
	/* (non-Javadoc)
 * @see com.openq.group.IGroupTreeService#getAllGroups()
 */

//Returns all the rows of the result table

public Groups[] getAllGroups() {
		
	    List result = getHibernateTemplate().find("from Groups g order by g.groupName");
	    if(result.size() > 0)
	    	return (Groups[]) result.toArray(new Groups[result.size()]); 
	    else
	    	return null;
	}

//Saves the row to group table

public void addGroups(Groups group) {
	
	getHibernateTemplate().save(group);
	
}

public Groups getGroup(long groupId){
	Groups grp = (Groups) getHibernateTemplate().find("from Groups where groupId=" + groupId).get(0);
	return grp;
}

public void deleteGroup(long groupId){
	
	Groups group = getGroup(groupId);
	getHibernateTemplate().delete(group);
}

//To get all the child groups corresponding to the parent id
public Groups[] getChildGroups(long parentID){
	
	List result = getHibernateTemplate().find("from Groups g where g.parentGroup=" + parentID);
	return (Groups[]) result.toArray(new Groups[result.size()]);
}

public void updateGroup(Groups group) {
	// TODO Auto-generated method stub
	getHibernateTemplate().saveOrUpdate(group);
}

public Map getGroupidGroupnameMap() {
	Map groupidGroupnameMap = new HashMap();
	List result = getHibernateTemplate().find("select g.groupId, g.groupName from Groups g");
	if(result.size()>0){
		for(int i=0; i<result.size(); i++){
			Object[] groupResult = (Object[]) result.get(i);
			if(!groupidGroupnameMap.containsKey(groupResult[0]))
					groupidGroupnameMap.put(groupResult[0], groupResult[1]);
		}
	}
	return groupidGroupnameMap;
}
public Groups[] getAllGroupsExcludingAdminUserGroup(long adminGroupId){
	List result = getHibernateTemplate().find("from Groups g where g.groupId !="+adminGroupId+" order by g.groupName");
    if(result.size() > 0)
    	return (Groups[]) result.toArray(new Groups[result.size()]); 
    else
    	return null;
}

public Groups getGroupByName(String groupName) {
	List result = getHibernateTemplate().find("from Groups grp where grp.groupName='"+groupName+"'");
	if(result.size() > 0)
		return (Groups) result.get(0);

	return null;
}
}