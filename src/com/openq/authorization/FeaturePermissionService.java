package com.openq.authorization;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.group.IGroupService;
import com.openq.utils.PropertyReader;

public class FeaturePermissionService extends HibernateDaoSupport implements
IFeaturePermissionService {

	IGroupService groupService;

	private static Logger logger = Logger
	.getLogger(FeaturePermissionService.class);

	public FeaturePermissionMetadata[] getAllFeaturePermissionMetadata() {
		List result = getHibernateTemplate().find(
				"from FeaturePermissionMetadata fpm");
		if (result != null && result.size() > 0) {
			return (FeaturePermissionMetadata[]) result
			.toArray(new FeaturePermissionMetadata[result.size()]);
		} else {
			logger.debug("Result is null for getAllFeaturePermissionMetadata");
			return null;
		}
	}

	public boolean saveFeatureUsergroupMap(Collection featureUsergroupList) {
		boolean isSuccess = false;
		try {
			for (Iterator it = featureUsergroupList.iterator(); it.hasNext();) {
				getHibernateTemplate().save(it.next());
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
			isSuccess = true;
		}
		return isSuccess;
	}

	public FeatureUsergroupMap[] getFeatureUsergroupMap(long permissionOnFeature) {
		List result = getHibernateTemplate().find(
				" from FeatureUsergroupMap fum where fum.permissionOnFeature="
				+ permissionOnFeature);
		if (result != null && result.size() > 0) {
			return (FeatureUsergroupMap[]) result
			.toArray(new FeatureUsergroupMap[result.size()]);
		} else {
			logger.debug("getFeatureUsergroupMap : result is null");
			return null;
		}
	}
	public FeaturePermissionMetadata getFeaturePermissionMetadataForId(
			long permissionOnFeature) {
		if (permissionOnFeature != 0) {
			List result = getHibernateTemplate().find(
					"from FeaturePermissionMetadata fpm where fpm.id="
					+ permissionOnFeature);
			if (result != null && result.size() > 0)
				return (FeaturePermissionMetadata) result.get(0);
			else {
				logger
				.debug("FeaturePermissionMetadata is empty. getFeaturePermissionMetadataForId returns null.");
				return null;
			}
		} else {
			logger
			.debug("permissionOnFeature is 0. getFeaturePermissionMetadataForId returns null.");
			return null;
		}
	}

	public boolean deleteFeatureUsergroupMap(
			String commaSeparatedfeatureUsergroupIdsTodelete) {
		boolean isSuccess = false;
		try {
			getHibernateTemplate().delete(
					" from FeatureUsergroupMap fum where fum.id in ("
					+ commaSeparatedfeatureUsergroupIdsTodelete + ")");
		} catch (Exception e) {
			logger.debug(e.getMessage());
			isSuccess = true;
		}
		return isSuccess;
	}
	
	public String getPermissionAppendQuery(long permissionOnFeature, long userGroupId) {
		String query = "";
		String condition = "";
		long adminUserGroupId = 0;
		String adminUserTypeIdString = PropertyReader.getEavConstantValueFor("ADMIN_USER_GROUP_ID");
		if(adminUserTypeIdString != null && !"".equals(adminUserTypeIdString)){
			adminUserGroupId = Long.parseLong(adminUserTypeIdString);
		}
		if(adminUserGroupId == userGroupId){
			query = " like '%' ";
		}else{
			List result = getHibernateTemplate().find("from FeaturePermissionMetadata fpm where fpm.id="+permissionOnFeature);
			if(result.size() > 0){
				if(((FeaturePermissionMetadata) result.get(0)).isAllowedByDefault()){
					condition = " not ";
				}
			}
			query = condition + " in ( select fum.featureId from FeatureUsergroupMap fum where fum.permissionOnFeature="+permissionOnFeature
			+ " and fum.usergroupId  like '%,"+userGroupId+",%' ) ";
		}
		return query;
	}

	public Set getRestrictedAttributes(long permissionOnFeature, long userGroupId) {
		String query = "";
		String condition = "";
		long adminUserGroupId = 0;
		String adminUserTypeIdString = PropertyReader.getEavConstantValueFor("ADMIN_USER_GROUP_ID");
		if(adminUserTypeIdString != null && !"".equals(adminUserTypeIdString)){
			adminUserGroupId = Long.parseLong(adminUserTypeIdString);
		}
		if(adminUserGroupId == userGroupId){
			query = " like '%' ";
		}else{
			List result = getHibernateTemplate().find("from FeaturePermissionMetadata fpm where fpm.id="+permissionOnFeature);
			if(result.size() > 0){
				if(((FeaturePermissionMetadata) result.get(0)).isAllowedByDefault()){
					condition = " not ";
				}
			}
			query = "from FeatureUsergroupMap fum where fum.permissionOnFeature="+permissionOnFeature
			+ " and fum.usergroupId  like '%,"+userGroupId+",%'";
		   List attributesResult = getHibernateTemplate().find(query);
		   if(attributesResult!=null&&attributesResult.size()>0)
		   {
			   Set attributeSet = new HashSet();
			  for(int i=0;i<attributesResult.size();i++)
			  {
				  FeatureUsergroupMap featureUsergroupMap = (FeatureUsergroupMap)attributesResult.get(i);
			      if(featureUsergroupMap!=null)
			    	  attributeSet.add(featureUsergroupMap.getFeatureId()+"");
			  }
			  return attributeSet;
		   }
		}
		return null;
	}	
	public Map getEntityGroupMapping(
			long permissionIdFromFeaturePermissionMetadata) {

		Map entityGroupMapping = new HashMap();
		Map groupidGroupnameMap = groupService.getGroupidGroupnameMap();
		List result = getHibernateTemplate().find("select fum.featureId,fum.usergroupId from FeatureUsergroupMap fum where " +
				" fum.permissionOnFeature="+permissionIdFromFeaturePermissionMetadata);
		if(groupidGroupnameMap != null && result.size()>0){
			for(int i=0; i<result.size(); i++){
				Object[] resultArray = (Object[]) result.get(i);
				String commaSeparatedGroupIds = (String) resultArray[1];
				StringBuffer commaSeparatedGroupNames = new StringBuffer();
				if(commaSeparatedGroupIds != null){
					String[] groupIds = commaSeparatedGroupIds.split(",");
					if(groupIds != null){
						for(int j=0; j<groupIds.length; j++){
							if(groupIds[j] != null && !"".equals(groupIds[j])){
								long groupId = Long.parseLong(groupIds[j]);
								commaSeparatedGroupNames.append(groupidGroupnameMap.get(new Long(groupId))).append(",");
							}
						}
					}
				}
				Long entityId = (Long) resultArray[0];
				String groupNames="";
				if(commaSeparatedGroupNames!=null && 
						commaSeparatedGroupNames.length() > 0){
					groupNames = commaSeparatedGroupNames.toString().substring(0, commaSeparatedGroupNames.length()-1);
					if(!entityGroupMapping.containsKey(entityId))
						entityGroupMapping.put(entityId, groupNames);
				}
			}
		}
		return entityGroupMapping;
	}
	public FeatureUsergroupMap getFeatureUsergroupMapForId(long featureId, long permissionOnFeature){
		List result = getHibernateTemplate().find("from FeatureUsergroupMap fum where fum.featureId="+featureId +
				" and fum.permissionOnFeature="+permissionOnFeature);
		if(result.size()>0){
			return (FeatureUsergroupMap) result.get(0);
		}
		return null;
	}
	public void saveNewUsergroupMapping(FeatureUsergroupMap newUsergroupMapping){
		try{
			getHibernateTemplate().save(newUsergroupMapping);
		}catch(Exception e){
			logger.error(e.getMessage());
		}
	}
	public void updateUsergroupMapping(FeatureUsergroupMap newUsergroupMapping){
		try{
			getHibernateTemplate().update(newUsergroupMapping);
		}catch(Exception e){
			logger.error(e.getMessage());
		}
	}
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
}
