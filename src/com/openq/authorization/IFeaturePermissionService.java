package com.openq.authorization;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public interface IFeaturePermissionService {

	public FeaturePermissionMetadata[] getAllFeaturePermissionMetadata();
	
	public FeaturePermissionMetadata getFeaturePermissionMetadataForId(long permissionOnFeature);
	
	public boolean saveFeatureUsergroupMap(Collection featureUsergroupList);
	
	public FeatureUsergroupMap[] getFeatureUsergroupMap(long permissionOnFeature);
	
	public boolean deleteFeatureUsergroupMap(String commaSeparatedfeatureUsergroupIdsTodelete);
	
	public String getPermissionAppendQuery (long permissionOnFeature, long userGroupId);
	
	public Map getEntityGroupMapping (long permissionIdFromFeaturePermissionMetadata);
	
	public FeatureUsergroupMap getFeatureUsergroupMapForId(long featureId, long permissionOnFeature);
	
	public void saveNewUsergroupMapping(FeatureUsergroupMap newUsergroupMapping);
	
	public void updateUsergroupMapping(FeatureUsergroupMap newUsergroupMapping);
	
	public Set getRestrictedAttributes(long permissionOnFeature, long userGroupId);
}
