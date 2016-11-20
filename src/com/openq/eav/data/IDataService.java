package com.openq.eav.data;

import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.interaction.Interaction;
import com.openq.user.LocationView;
import com.openq.user.User;

public interface IDataService {

	public void saveEntity(Entity entity);

	public void saveBooleanAttribute(BooleanAttribute boolattr);

	public void saveStringAttribute(StringAttribute strattr);

	public void saveNumberAttribute(NumberAttribute numattr);

	public void saveDateAttribute(DateAttribute dateattr);

	public void saveDateAttribute(AttributeType attr, Entity parent, Date value);

	public void saveStringAttribute(AttributeType attr, Entity parent,
			String value);

	public void saveNumberAttribute(AttributeType attr, Entity parent,
			long value);

	public void saveEntityAttribute(EntityAttribute entityattr,
			AttributeType attrType);

	public void saveBooleanAttribute(AttributeType attr, Entity parent,
			Boolean bool);

	public void saveOLProfile(Entity entity, User u);

	public DateAttribute[] getDateAttribute(Entity entity);

	public StringAttribute[] getStringAttribute(Entity entity);

	public StringAttribute getStringAttribute(long entityId, long attrId);

	public BooleanAttribute getBooleanAttribute(long entityId, long attrId);
	
	public BooleanAttribute[] getBooleanAttribute(long attrId);

	public BinaryAttribute getBinaryAttribute(long entityId, long attrId);

	public BinaryAttribute[] getBinaryAttribute(Entity entity);

	public NumberAttribute[] getNumberAttribute(Entity entity);

	public BooleanAttribute[] getBooleanAttribute(Entity entity);

	public EntityAttribute[] getAllEntityAttributes(Entity entity);

	public EntityAttribute[] getAllEntityAttributes(long entityId);

	public EntityAttribute[] getEntityAttributes(long myEntityId);

	public ArrayList getAllAttributeValues(Entity myEntity);

	public EntityAttribute getEntityAttribute(long id);

	public void updateEntity(Entity entity);

	public void deleteEntity(Entity entity);

	public void deleteArrayElement(long entityAttrId);

	public Entity getEntity(long entityId);

	public IMetadataService getMetadataService();

	public void setMetadataService(IMetadataService metadataService);

	public EntityAttribute[] getEntityAttributes(long parentId, long attrId);

	public User[] getSearchUser(HashMap attIDMap);

	public boolean saveOrUpdateAttribute(long attrId, long entityId,
			Object val, long tabAttributeId, long rootEntityId, long rowId);

	public boolean saveOrUpdateAttribute(long attrId, long entityId, Object val);

	public boolean saveOrUpdateAttributes(long entityId,
			HttpServletRequest request, String editor, long tabAttributeId,
			long rootEntityId, long rowId);

	public StringAttribute[] getMatchingAttributes(String text, long attributeId);

	public StringAttribute getAttribute(long parentId, long attributeId);
	
	public StringAttribute getAttributeValue(Long rootEntityId, Long attributeId);

	public AttributeType getAttributeIdFromName(String attName);

	public User[] getAttrVals(User[] user);

	public void savePublications(long kolId, int attrId, ArrayList pubList);

	/**
	 * @deprecated
	 * @see IExpertDetailsService.populateUserObject
	 * @param User object
	 * @return Location View Object (This is a view in the DB which is no more used in the application.)
	 */
	public LocationView getUserLocation(User u);

	/**
	 * @deprecated
	 * @see IExpertDetailsService.populateUserObject
	 * @param userObj
	 */
	public void getCustomAttributesForOl(User userObj);

	public User[] getEntityforAttributeValue(String value);

	public List getOLForLastName(String value, String jointVenture);

	public int getPublicationCountForUser(User user);

	public Interaction getLastInteractionForUser(User user);

	public String getBio(User user);

	public ArrayList getTAForOL(User ol);

	public long createEntityIfRequired(long entityId, long attrId, long parentId);

	public void setUserFields(User user);

	/**
	 * @deprecated
	 * @see IUserService.getUserForProfileSummary
	 * @param kolid
	 * @return User object
	 */
	public User setUserFields1(long kolid);

	/**
	 * @deprecated
	 * @see IUserService.getUserForProfileSummary
	 * @param kolid
	 * @return
	 */
	public User setUserContactInformation(long kolid);

	public EntityAttribute getMyEntityIdFromEntitiesAttribute(long attributeId,
			long parentId);

	public String getTierForUser(User user);

	public EntityAttribute getEntityAttributeNew(long myEntityId);
	/*
	 * adding saveBooleanAttributes to modify for dataloader tool
	 */
	public void saveBooleanAttribute(AttributeType attr, Entity entity, Boolean bool,
    		long rootEntityId, long rootEntityType, long rowId, long tabAttrId,
			boolean isTable);

	// adding saveBooleanAttribute to modify for dataloader tool, the method was already implemented in the dataService but the corresponding entry was not in IdataService
	public void saveStringAttribute(AttributeType attr, Entity entity, String value,
			long rootEntityId, long rootEntityType, long rowId, long tabAttrId,
			boolean isTable);

}
