package com.openq.group;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;
import com.openq.group.IGroupService;

public class UserGroupMapService extends HibernateDaoSupport implements IUserGroupMapService {

	IGroupService groupService;

	/**
	 * @return the groupService
	 */
	public IGroupService getGroupService() {
		return groupService;
	}

	/**
	 * @param groupService the groupService to set
	 */
	public void setGroupService(IGroupService groupService) {
		this.groupService = groupService;
	}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#getAllGroupsForUser(long)
 */
public UserGroupMap[] getAllGroupsForUser(long userid) {

	    List result = getHibernateTemplate().find("from UserGroupMap ug where ug.user_id="+userid);
        return (UserGroupMap[]) result.toArray(new UserGroupMap[result.size()]);
	}

public String[] getAllTAsForUser(long userId)
{
	UserGroupMap userGroupMap[] = getAllGroupsForUser(userId);
	List groupsList = new ArrayList();
	List therapeuticAreaOptionValueIds = new ArrayList();
	if(userGroupMap != null && userGroupMap.length>0){
		for(int i = 0;i<userGroupMap.length;i++){
			groupsList.add(groupService.getGroup(userGroupMap[i].getGroup_id()));
		}
	}
	if(groupsList!=null && groupsList.size()>0){
		Iterator itr = groupsList.iterator();
		while(itr.hasNext()){
			therapeuticAreaOptionValueIds.add(((Groups)itr.next()).getTherupticArea());
		}
		return (String[])therapeuticAreaOptionValueIds.toArray(new String[therapeuticAreaOptionValueIds.size()]);
	}

	return null;
}


/**
 * The assumption is that User can not belong to more then one Group
 * @param userId
 * @return
 */
public long getGroupIdForUser(long userId){
	UserGroupMap[] userGroupMap = getAllGroupsForUser(userId);

	if(userGroupMap !=null && userGroupMap.length > 0){
		return userGroupMap[0].getGroup_id();
	}

	return -1;
}




/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#getAllUsersForGroup(long)
 */
public UserGroupMap[] getAllUsersForGroup(long groupid) {

    List result = getHibernateTemplate().find("from UserGroupMap ug where ug.group_id="+groupid);
	return (UserGroupMap[]) result.toArray(new UserGroupMap[result.size()]);
}


/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#saveUserGroupMap(com.openq.group.UserGroupMap)
 */
public void saveUserGroupMap(UserGroupMap ugmap) {

    getHibernateTemplate().save(ugmap);

}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#deleteUserGroupMap(com.openq.group.UserGroupMap)
 */
public void deleteUserGroupMap(UserGroupMap ugmap) {

    getHibernateTemplate().delete(ugmap);

}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#updateUserGroupMap(com.openq.group.UserGroupMap)
 */
public void updateUserGroupMap(UserGroupMap ugmap) {

    getHibernateTemplate().update(ugmap);

}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#saveUserGroupMap(long, long)
 */
public void saveUserGroupMap(long userid,long groupid) {

	UserGroupMap ugmap=new UserGroupMap();
	ugmap.setGroup_id(groupid);
	ugmap.setUser_id(userid);
    getHibernateTemplate().save(ugmap);

}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#deleteUserGroupMap(long, long)
 */
public void deleteUserGroupMap(long userid,long groupid) {

	UserGroupMap ugmap=new UserGroupMap();
	ugmap.setId(groupid); // changed to setId
	ugmap.setUser_id(userid);
    getHibernateTemplate().delete(ugmap);

}

/* (non-Javadoc)
 * @see com.openq.group.IUserGroupMapService#updateUserGroupMap(long, long)
 */
public void updateUserGroupMap(long userid,long groupid) {

	UserGroupMap ugmap=new UserGroupMap();
	ugmap.setGroup_id(groupid);
	ugmap.setUser_id(userid);
    getHibernateTemplate().update(ugmap);

}


}
