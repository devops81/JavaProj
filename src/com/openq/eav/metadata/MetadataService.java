package com.openq.eav.metadata;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;


import com.openq.authorization.IPrivilegeService;
import com.openq.authorization.Privilege;
import com.openq.eav.data.Entity;
import com.openq.web.controllers.Constants;


public class MetadataService  extends HibernateDaoSupport implements IMetadataService {
	public static final int ROOT_NODE_TREE_DEPTH = 0;
	
	/**
	 * Get the list of all entities that are not attributes of other entities.
	 * Each top-level entitiy would be used to define a certin class of
	 * entities.
	 * <p>
	 * 
	 * For example, 'User Metadata' can be a top level entity that contains all
	 * user entities.
	 * <p>
	 * 
	 * <pre>
	 *    - User Metadata (Top level entity)
	 *    		|-Legal
	 *    		|-Expert
	 *    			|-Area of Focus
	 *    			|-Travel Preferences
	 *    			... 
	 *    		|-SalesRep
	 *    		...
	 * </pre>
	 * 
	 * @return List of all top level entities
	 */
	public EntityType[] getRootEntityTypes() {

		List result = getHibernateTemplate()
				.find(
						"from EntityType e where e.treeDepth = "
								+ ROOT_NODE_TREE_DEPTH);
		return (EntityType[]) result.toArray(new EntityType[result.size()]);
	}

	/**
	 * 
	 * Get the metadata for an entity, whose ID is <code>entityTypeId</code>.
	 * <p>
	 * 
	 * @param entityTypeId
	 *            ID of entity that needs to be loaded.
	 * @return Entity type reprenesed by the ID
	 */
	public EntityType getEntityType(long entityTypeId) {

		return ((EntityType) getHibernateTemplate().load(EntityType.class,
				new Long(entityTypeId)));
	}

	/**
	 * 
	 * Get all attributes of an entity, whose ID is <code>entityTypeId</code>.
	 * <p>
	 * 
	 * @param entityTypeId
	 *            ID of entity that needs to be loaded.
	 * @return Entity type reprenesed by the ID
	 */
	public AttributeType[] getAllAttributes(long entityTypeId) {
		List result = getHibernateTemplate().find(
				"from AttributeType a where a.parent = " + entityTypeId
						+ " order by a.displayOrder asc");

		return (AttributeType[]) result
				.toArray(new AttributeType[result.size()]);
	}

	public AttributeType[] getAllShowableAttributes(long entityTypeId) {
		List result = getHibernateTemplate().find(
				"from AttributeType a where a.parent = " + entityTypeId
						+ " and a.showable=1  order by a.displayOrder asc");
//        System.out.println("result is "+ result);
		return (AttributeType[]) result
				.toArray(new AttributeType[result.size()]);
	}

		
	public AttributeType[] getAllShowableAttributesFilteredByPermissions(
			long entityTypeId, String uId, IPrivilegeService privilegeService) {

		AttributeType[] attributes = getAllShowableAttributes(entityTypeId);
		long id = Long.parseLong(uId);
		ArrayList l = new ArrayList();
		for (int i = 0; i < attributes.length; i++) {
			String featureKey = getFeatureKeyForAttribute(attributes[i]
					.getParent().getEntity_type_id(), attributes[i]
					.getAttribute_id());
			if (privilegeService.wrappedIsOperationAllowed(id, featureKey,
					Privilege.READ))
				l.add(attributes[i]);
		}

		return (AttributeType[]) l.toArray(new AttributeType[l.size()]);
	}

	/**
	 * Get the attribute definition, given the id of the attribute.
	 */
	public AttributeType getAttributeType(long attributeTypeId) {

		return ((AttributeType) getHibernateTemplate().load(
				AttributeType.class, new Long(attributeTypeId)));
	}
	public AttributeType getAttributeFromId(long attributeId){
		List result=getHibernateTemplate().find("from AttributeType a where a.attribute_id="+attributeId);
		if(result.size()==0){
			return null;
		}
		return (AttributeType) result.get(0);
	}

	public AttributeType getAttributeForEntity(long entityTypeId) {
		List result = getHibernateTemplate().find(
				"from AttributeType a where a.type = " + entityTypeId);
		if (result.size() == 0)
			return null;

		return (AttributeType) result.get(0);
	}

	/**
	 * Create a new entity type at the root level. This API would only create
	 * the entity definition and would not add any attributes to it.
	 * <p>
	 * 
	 * Attributes should be added using addAttributeToEntity API.
	 * 
	 * @param type
	 *            Definition of entity to be created
	 * @throws SQLException
	 * @throws HibernateException
	 */
	public void createEntityType(EntityType entityType) {

		if (entityType != null && entityType.getAttributes().size() > 0) {
			throw new RuntimeException(
					"Creating entities with attributes is not supported. Please use addAttributeToEntityType for adding attributes.");
		}

		getHibernateTemplate().save(entityType);
	}
	
	public void createAttributeType(EntityType parent, AttributeType attributeType)  {
		
		
        attributeType.setParent(parent);
		getHibernateTemplate().save(attributeType);
	}
	

	public long getEntityTypeId(String datatype) {
		// System.out.println("getEntu Datatype "+datatype);
		List result = getHibernateTemplate().find(
				"from EntityType a where a.name ='" + datatype
						+ "' and a.treeDepth=-1");
		// System.out.println("Size: "+result.size());
		// EntityType[] entity=(EntityType[]) result.toArray();
		return (((EntityType) result.get(0)).getEntity_type_id());
	}

	public long[] getAllRootEntityTypeId() {
		long[] root_entity_type_id = null;
		List result = getHibernateTemplate()
				.find(
						"from EntityType where treeDepth='0' and NAME NOT LIKE '%Reserved%'");
		if (result.size() > 0) {
			root_entity_type_id = new long[result.size()];
			for (int i = 0; i < result.size(); i++)
				root_entity_type_id[i] = ((EntityType) result.get(i))
						.getEntity_type_id();
		}
		return (root_entity_type_id);
	}

	/**
	 * Set deleted flag of an entity to true. This API also recursively cascades
	 * delete to all the child attributes and entities for this node.
	 * 
	 * @param entityType
	 */
	public void deleteEntityType(EntityType entityType) {
		getHibernateTemplate().delete(entityType);
	}

	/**
	 * Load the Entity type for the given Id and call deleteEntityType on it.
	 * 
	 * @param entityId
	 *            of the entity to be deleted
	 */
	public void deleteEntityType(long entityTypeId) {
		deleteEntityType(getEntityType(entityTypeId));
	}

	/**
	 * Add a new entity to this attribute. This attribute can either be of basic
	 * type or another entity. When the attribute itself is an entity, the child
	 * entity should be created first and then the attribute definition should
	 * be
	 * 
	 * @param type
	 * @param newAttribute
	 * @throws SQLException
	 * @throws HibernateException
	 */
	public void addAttributeType(EntityType entityType,
			AttributeType newAttribute) {
		if (newAttribute.isEntity()) {
			EntityType et = new EntityType();
			et.setName(newAttribute.getName());
			et.setDescription(newAttribute.getDescription());
			et.setTreeDepth(entityType.getTreeDepth() + 1);

			getHibernateTemplate().save(et);
			newAttribute.setType(et.getEntity_type_id());
		}

		newAttribute.setParent(entityType);

		getHibernateTemplate().save(newAttribute);
	}

	public void deleteAttributeType(AttributeType attributeType) {
		if (attributeType.isEntity()) {
			deleteEntityType(attributeType.getType());
		}
		getHibernateTemplate().delete(attributeType);
	}

	public void deleteAttributeType(long attributeTypeId) {
		deleteAttributeType(getAttributeType(attributeTypeId));
	}

	public void updateEntityType(EntityType entityType) {
		getHibernateTemplate().update(entityType);
	}

	public void updateAttributeType(AttributeType attributeType) {
		getHibernateTemplate().update(attributeType);
	}

	// Placeholder APIs for search on metadata
	public AttributeType[] searchAttributes(String text) {

		List result = getHibernateTemplate().find(
				"from AttributeType a where a.name like ?" + text);

		return (AttributeType[]) result
				.toArray(new AttributeType[result.size()]);
	}

	// Placeholder APIs for search on metadata
	public EntityType[] searchEntities(String text) {

		List result = getHibernateTemplate().find(
				"from EntityType e where e.name like ?" + text);

		return (EntityType[]) result.toArray(new EntityType[result.size()]);
	}

	/**
	 * @see IMetadataService#getAttribute(long, long)
	 */
	public AttributeType getAttribute(long parentId, long attribId) {
		List result = getHibernateTemplate().find(
				" from AttributeType a where a.parent = " + parentId
						+ " and a.attribute_id = " + attribId);
		if (result.size() == 0)
			return null;

		return (AttributeType) result.get(0);
	}

	/**
	 * @see IMetadataService#getFeatureKeyForAttribute(long, long)
	 */
	public String getFeatureKeyForAttribute(long parentId, long attribId) {
		String key = null;

		AttributeType aType = null;
		aType = getAttribute(parentId, attribId);

		if (aType == null) {
			throw new IllegalArgumentException("Couldn't find attribute : "
					+ attribId + " for parent : " + parentId);
		}

		key = getSanitizedName(aType.getName());
		EntityType parent = aType.getParent();
		long parentDepth = parent.getTreeDepth();
		key = getSanitizedName(parent.getName()) + "." + key;

		// Keep traversing till we don't hit the root entity
		while (parentDepth != 0) {
			aType = getAttributeForEntity(parent.getEntity_type_id());
			parent = aType.getParent();
			parentDepth = parent.getTreeDepth();
			key = getSanitizedName(parent.getName()) + "." + key;
		}

		return key;
	}

	/**
	 * Return the given String after replacing all spaces with underscores
	 * 
	 * @param name
	 * 
	 * @return
	 */
	private String getSanitizedName(String name) {
		return name.replace(' ', '_');
	}
    public Entity getEntity(long entityTypeId)
    {
        return ((Entity) getHibernateTemplate().load(Entity.class,
                new Long(entityTypeId)));
    }

	public AttributeType getAttributeType(String attributeName) {
		List result = getHibernateTemplate().find("from AttributeType at where at.name='" + attributeName + "'");
		if(result.size() > 0){
			return (AttributeType) result.get(0);
		}else{
			return null;
		}
	}
}
