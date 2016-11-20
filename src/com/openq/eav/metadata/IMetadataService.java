package com.openq.eav.metadata;


import com.openq.authorization.IPrivilegeService;
import com.openq.eav.data.Entity;


public interface IMetadataService {
	public EntityType[] getRootEntityTypes();
	public EntityType getEntityType(long entityTypeId);
	public AttributeType getAttributeType(long attributeTypeId);
	public void createEntityType(EntityType entityType);
	public void createAttributeType(EntityType parent, AttributeType attributeType);
	public long getEntityTypeId(String datatype);
	public long[] getAllRootEntityTypeId();
	public void deleteEntityType(EntityType entityType);
	public void deleteEntityType(long entityTypeId);
	public void addAttributeType(EntityType entityType, AttributeType newAttribute);
	public void deleteAttributeType(AttributeType attributeType);
	public void deleteAttributeType(long attributeTypeId);
	public void updateEntityType(EntityType entityType);
	public void updateAttributeType(AttributeType attributeType);
	public AttributeType[] searchAttributes(String text);
	public EntityType[] searchEntities(String text);
	public AttributeType [] getAllAttributes(long entityTypeId);
	public AttributeType getAttributeForEntity(long entityTypeId);
	public AttributeType [] getAllShowableAttributes(long entityTypeId);
	public AttributeType [] getAllShowableAttributesFilteredByPermissions(long entityTypeId, String uId, IPrivilegeService privilegeService);
	
    public Entity getEntity(long entityTypeId);

	/**
	 * This routine is used to retrieve the attribute with the given id and having the
	 * specified parent
	 *
	 * @param parentId id for the parent entity containing the specified attribute
	 * @param attribId id for the attribute whose key is needed
	 *
	 * @return AttributeType object for the specified attribute, null if not found
	 */
	public AttributeType getAttribute(long parentId, long attribId);

	/**
	 * This routine is used to get the feature key for the specified attribute.
	 * It traverses the attribute hierarchy to include the names of all ancestors
	 * of the attribute in the feature key
	 *
	 * @param parentId id for the parent entity containing the specified attribute
	 * @param attribId id for the attribute whose key is needed
	 *
	 * @param A String containing the name of the attribute prefixed with the names of all it's ancestors
	 */
	public String getFeatureKeyForAttribute(long parentId, long attribId);
	
	public AttributeType getAttributeType(String attributeName);
}
