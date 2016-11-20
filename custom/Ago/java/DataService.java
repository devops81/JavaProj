package com.openq.eav.data;

import java.io.IOException;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import net.sf.hibernate.HibernateException;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.openq.contacts.Contacts;
import com.openq.eav.EavConstants;
import com.openq.eav.audit.AuditInfo;
import com.openq.eav.audit.IAuditService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.scripts.OlConstants;

import com.openq.ovid.Publications;
import com.openq.user.*;
import com.openq.utils.PropertyReader;
import com.openq.attendee.Attendee;
import com.openq.interaction.Interaction;

public class DataService extends HibernateDaoSupport implements IDataService {

    private static Logger logger = Logger.getLogger(DataService.class);

    private HashMap tempAttributeSet = null;
    /**
     * The maximum number of entries allowed in an Oracle "IN" clause
     */
    private static final int MAX_IN_CLAUSE_ENTRIES = 1000;

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveEntity(com.openq.eav.data.Entity)
      */
    public void saveEntity(Entity entity) {
        getHibernateTemplate().save(entity);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveEntityAttribute(com.openq.eav.data.EntityAttribute,
      *      com.openq.eav.metadata.AttributeType, com.openq.eav.data.Entity,
      *      java.lang.String)
      */
    public void saveEntityAttribute(EntityAttribute entityattr,
                                    AttributeType attrType) {

        if (attrType.isEntity()) {
            Entity et = new Entity();
            et.setType(metadataService.getEntityType(attrType.getType()));
            getHibernateTemplate().save(et);
            entityattr.setMyEntity(et);
        }

        entityattr.setAttribute(attrType);

        getHibernateTemplate().save(entityattr);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveDateAttribute(com.openq.eav.data.DateAttribute,
      *      com.openq.eav.metadata.AttributeType, com.openq.eav.data.Entity,
      *      java.sql.Date)
      */
    public void saveDateAttribute(AttributeType attr, Entity entity, Date value) {
        DateAttribute dateattr = new DateAttribute();
        dateattr.setParent(entity);
        dateattr.setAttribute(attr);
        dateattr.setValue(value);
        getHibernateTemplate().save(dateattr);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveStringAttribute(com.openq.eav.data.StringAttribute,
      *      com.openq.eav.metadata.AttributeType, com.openq.eav.data.Entity,
      *      java.lang.String)
      */
    public void saveStringAttribute(AttributeType attr, Entity entity,
                                    String value) {
        StringAttribute stringattr = new StringAttribute();
        stringattr.setParent(entity);
        stringattr.setAttribute(attr);
        stringattr.setValue(value);
        getHibernateTemplate().save(stringattr);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveNumberAttribute(com.openq.eav.data.NumberAttribute,
      *      com.openq.eav.metadata.AttributeType, com.openq.eav.data.Entity,
      *      long)
      */
    public void saveNumberAttribute(AttributeType attr, Entity entity,
                                    long value) {
        NumberAttribute numattr = new NumberAttribute();
        numattr.setParent(entity);
        numattr.setAttribute(attr);
        numattr.setValue(value);
        getHibernateTemplate().save(numattr);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#saveBooleanAttribute(com.openq.eav.data.BooleanAttribute,
      *      com.openq.eav.metadata.AttributeType, com.openq.eav.data.Entity,
      *      java.lang.Boolean)
      */
    public void saveBooleanAttribute(AttributeType attr, Entity entity,
                                     Boolean bool) {
        BooleanAttribute boolattr = new BooleanAttribute();
        boolattr.setParent(entity);
        boolattr.setValue(bool);
        boolattr.setAttribute(attr);
        getHibernateTemplate().save(boolattr);
    }

    public void saveBooleanAttribute(BooleanAttribute boolattr) {
        getHibernateTemplate().save(boolattr);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getDateAttribute(com.openq.eav.metadata.AttributeType,
      *      com.openq.eav.data.Entity)
      */
    public DateAttribute[] getDateAttribute(Entity entity) {

        List result = getHibernateTemplate().find(
                "from DateAttribute d where d.parent=" + entity.getId());
        return (DateAttribute[]) result
                .toArray(new DateAttribute[result.size()]);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getStringAttribute(com.openq.eav.metadata.AttributeType,
      *      com.openq.eav.data.Entity)
      */
    public StringAttribute[] getStringAttribute(Entity entity) {

        List result = getHibernateTemplate().find(
                "from StringAttribute s where s.parent=" + entity.getId());
        return (StringAttribute[]) result.toArray(new StringAttribute[result
                .size()]);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getStringAttribute(com.openq.eav.metadata.AttributeType,
      *      com.openq.eav.data.Entity)
      */
    public StringAttribute getStringAttribute(long entityId, long attrId) {

        List result = getHibernateTemplate().find(
                "from StringAttribute s where s.parent=" + entityId
                        + " and s.attribute=" + attrId);
        if (result.size() == 0)
            return null;
        return (StringAttribute) result.get(0);
    }

    public BooleanAttribute getBooleanAttribute(long entityId, long attrId) {

        List result = getHibernateTemplate().find(
                "from BooleanAttribute b where b.parent=" + entityId
                        + " and b.attribute=" + attrId);
        if (result.size() == 0)
            return null;
        return (BooleanAttribute) result.get(0);
    }

  public BinaryAttribute getBinaryAttribute(long entityId, long attrId) {

    List result = getHibernateTemplate().find(
        "from BinaryAttribute b where b.parent=" + entityId
            + " and b.attribute=" + attrId);
    if (result.size() == 0)
      return null;
    return (BinaryAttribute) result.get(0);
  }

  public BinaryAttribute[] getBinaryAttribute(Entity entity) {

    List result = getHibernateTemplate().find(
        "from BinaryAttribute n where n.parent=" + entity.getId());
    return (BinaryAttribute[]) result.toArray(new BinaryAttribute[result
        .size()]);
  }

  /*
	 * (non-Javadoc)
	 *
	 * @see com.openq.eav.data.IDataService#getNumberAttribute(com.openq.eav.metadata.AttributeType,
	 *      com.openq.eav.data.Entity)
	 */
    public NumberAttribute[] getNumberAttribute(Entity entity) {

        List result = getHibernateTemplate().find(
                "from NumberAttribute n where n.parent=" + entity.getId());
        return (NumberAttribute[]) result.toArray(new NumberAttribute[result
                .size()]);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getBooleanAttribute(com.openq.eav.metadata.AttributeType,
      *      com.openq.eav.data.Entity)
      */
    public BooleanAttribute[] getBooleanAttribute(Entity entity) {
        List result = getHibernateTemplate().find(
                "from BooleanAttribute b where b.parent=" + entity.getId());
        return (BooleanAttribute[]) result.toArray(new BooleanAttribute[result
                .size()]);
    }

    public EntityAttribute[] getAllEntityAttributes(Entity entity) {
        List result = getHibernateTemplate().find(
                "from EntityAttribute e where e.parent=" + entity.getId()
                        + " order by e.parent");
        return (EntityAttribute[]) result.toArray(new EntityAttribute[result
                .size()]);
    }

    public ArrayList getAllAttributeValues(Entity myEntity) {
        ArrayList attrArray = new ArrayList();

        StringAttribute[] strAttrs = getStringAttribute(myEntity);
        for (int j = 0; j < strAttrs.length; j++) {
            attrArray.add(strAttrs[j]);
        }

        NumberAttribute[] numAttrs = getNumberAttribute(myEntity);
        for (int j = 0; j < numAttrs.length; j++) {
            attrArray.add(numAttrs[j]);
        }

        BooleanAttribute[] boolAttrs = getBooleanAttribute(myEntity);
        for (int j = 0; j < boolAttrs.length; j++) {
            attrArray.add(boolAttrs[j]);
        }

        DateAttribute[] dateAttrs = getDateAttribute(myEntity);
        for (int j = 0; j < dateAttrs.length; j++) {
            attrArray.add(dateAttrs[j]);
        }

    BinaryAttribute[] binaryAttrs = getBinaryAttribute(myEntity);
    for (int j = 0; j < binaryAttrs.length; j++) {
      attrArray.add(binaryAttrs[j]);
    }
        return attrArray;
    }

    public EntityAttribute[] getEntityAttributes(long parentId, long attrId) {
        List result = getHibernateTemplate().find(
                "from EntityAttribute e where e.parent=" + parentId
                        + " and e.attribute=" + attrId + " order by e.parent");
        return (EntityAttribute[]) result.toArray(new EntityAttribute[result
                .size()]);
    }

    public EntityAttribute getEntityAttribute(long id) {
        return (EntityAttribute) getHibernateTemplate().get(
                EntityAttribute.class, new Long(id));
    }

    public EntityAttribute[] getAllEntityAttributes(long entityId) {
        List result = getHibernateTemplate().find(
                "from EntityAttribute e where e.parent=" + entityId
                        + " order by e.parent");
        return (EntityAttribute[]) result.toArray(new EntityAttribute[result
                .size()]);
    }


    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#updateEntity(com.openq.eav.data.Entity)
      */
    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#updateEntity(com.openq.eav.data.Entity)
      */
    public void updateEntity(Entity entity) {
        getHibernateTemplate().update(entity);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#deleteEntity(com.openq.eav.data.Entity)
      */
    public void deleteEntity(Entity entity) {
        getHibernateTemplate().delete(entity);
    }

    public void deleteArrayElement(long entityAttrId) {
        // Get entity Id of the array
        EntityAttribute ea = (EntityAttribute) getHibernateTemplate().load(
                EntityAttribute.class, new Long(entityAttrId));
        Entity myEntity = ea.getMyEntity();

        // Delete all basic attributes of the entity
        ArrayList allAttributeValues = getAllAttributeValues(myEntity);
        for (int i = 0; i < allAttributeValues.size(); i++) {
            getHibernateTemplate().delete(allAttributeValues.get(i));
        }

        // Delete this attribute
        getHibernateTemplate().delete(ea);

        // Delete this entity
        getHibernateTemplate().delete(myEntity);
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getEntity(long)
      */
    public Entity getEntity(long entityId) {

        return (Entity) getHibernateTemplate().load(Entity.class,
                new Long(entityId));
    }

    public void saveOLProfile(Entity entity, User u) {
        // create an entry for this into Entities table

        AttributeType[] attributes = metadataService.getAllAttributes(entity
                .getType().getEntity_type_id());

        // for each attribute
        for (int i = 0; i < attributes.length; i++) {
            initEavTablesForAttribute(attributes[i], entity, u);
        }
    }

    private void initEavTablesForAttribute(AttributeType type, Entity parent,
                                           User u) {

        if (type.isEntity()) {
            if (type.isArraylist()) {

                for (int i = 0; i < 1; i++) {
                    EntityAttribute entityAttribute = new EntityAttribute();
                    entityAttribute.setParent(parent);
                    entityAttribute.setAttribute(type);
                    saveEntityAttribute(entityAttribute, type);
                    if (type.getAttribute_id() == OlConstants.KOL_OL_Summary_Address) {
                        saveAddress(entityAttribute.getMyEntity(), u);
                    } else if (type.getAttribute_id() == OlConstants.KOL_OL_Summary_Classification_Tier) {
                        saveTheurapticArea(entityAttribute.getMyEntity(), u);
                    }
                }
            } else {
                EntityAttribute entityAttribute = new EntityAttribute();
                entityAttribute.setParent(parent);
                entityAttribute.setAttribute(type);
                saveEntityAttribute(entityAttribute, type);
                if (type.getAttribute_id() == OlConstants.KOL_OL_Summary_Profile) {
                    saveName(entityAttribute.getMyEntity(), u);
                }
                saveOLProfile(entityAttribute.getMyEntity(), u);
            }
        }
    }

    private void saveAddress(Entity parent, User user) {
        AttributeType type = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Type);
        saveStringAttribute(type, parent, "");

        AttributeType usage = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Usage);
        saveStringAttribute(usage, parent, "Primary");

        UserAddress ua = user.getUserAddress();
        AttributeType line1 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Line_1);
        saveStringAttribute(line1, parent, ua.getAddress1());

        AttributeType line2 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Line_2);
        saveStringAttribute(line2, parent, ua.getAddress2());

        AttributeType city = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_City);
        saveStringAttribute(city, parent, ua.getCity());

        AttributeType state = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_State);
        saveStringAttribute(state, parent, ua.getState().getOptValue());

        AttributeType zip = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Zip);
        saveStringAttribute(zip, parent, ua.getZip());

        AttributeType country = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Country);
        saveStringAttribute(country, parent, ua.getCountry().getOptValue());

        /*AttributeType source = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Address_Source);
        saveStringAttribute(source, parent, "Amgen");*/
    }

    private void saveTheurapticArea(Entity parent, User user) {
        AttributeType ta =
        metadataService.getAttributeType(OlConstants.KOL_OL_Summary_Classification_Tier_Therapeutic_Area);
        saveStringAttribute(ta, parent, user.getSpeciality());

        AttributeType tier = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Classification_Tier_Tier);
        saveStringAttribute(tier, parent, "Guest");
    }

    private void saveName(Entity parent, User user) {
        AttributeType fName = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Firstname);
        saveStringAttribute(fName, parent, user.getFirstName());

        AttributeType lName = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Lastname);
        saveStringAttribute(lName, parent, user.getLastName());

        /*AttributeType s1 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty1);
        saveStringAttribute(s1, parent, "");

        AttributeType s2 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty2);
        saveStringAttribute(s2, parent, "");

        AttributeType s3 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty3);
        saveStringAttribute(s3, parent, "");

        AttributeType s4 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty4);
        saveStringAttribute(s4, parent, "");

        AttributeType s5 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty5);
        saveStringAttribute(s5, parent, "");

        AttributeType s6 = metadataService
                .getAttributeType(OlConstants.KOL_OL_Summary_Profile_Specialty6);
        saveStringAttribute(s6, parent, ""); */

        AttributeType s7 = metadataService.getAttributeType(17l);
         saveStringAttribute(s7, parent, "");

         AttributeType s8 = metadataService.getAttributeType(21l);
         saveStringAttribute(s8, parent, "");

         /*AttributeType s9 = metadataService.getAttributeType(22l);
         saveStringAttribute(s9, parent, "");

         AttributeType s10 = metadataService.getAttributeType(23l);
         saveStringAttribute(s10, parent, "");

         AttributeType s11 = metadataService.getAttributeType(30l);
         saveStringAttribute(s11, parent, "");

         AttributeType s12 = metadataService.getAttributeType(82625243l);
         saveStringAttribute(s12, parent, "");

         AttributeType s13 = metadataService.getAttributeType(82625243l);
         saveStringAttribute(s13, parent, "");

         AttributeType s14 = metadataService.getAttributeType(82625301l);
         saveStringAttribute(s14, parent, "");

         AttributeType s15 = metadataService.getAttributeType(82625302l);
         saveStringAttribute(s15, parent, "");

         AttributeType s16 = metadataService.getAttributeType(82625303l);
         saveStringAttribute(s16, parent, "");

         AttributeType s17 = metadataService.getAttributeType(82625304l);
         saveStringAttribute(s17, parent, "");

         AttributeType  s18 = metadataService.getAttributeType(82625305l);
         saveStringAttribute(s18, parent, "");*/






    }

    private IMetadataService metadataService;

    private IAuditService auditService;

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#getMetadataService()
      */
    public IMetadataService getMetadataService() {
        return metadataService;
    }

    /*
      * (non-Javadoc)
      *
      * @see com.openq.eav.data.IDataService#setMetadataService(com.openq.eav.metadata.IMetadataService)
      */
    public void setMetadataService(IMetadataService metadataService) {
        this.metadataService = metadataService;
    }

    public void saveStringAttribute(StringAttribute strattr) {
        getHibernateTemplate().save(strattr);
    }

    public void saveDateAttribute(DateAttribute dateattr) {
        getHibernateTemplate().save(dateattr);
    }

    public void saveNumberAttribute(NumberAttribute numattr) {
        getHibernateTemplate().save(numattr);
    }

    public boolean saveOrUpdateAttribute(long attrId, long entityId, Object val) {

        AttributeType type = metadataService.getAttributeType(attrId);

        val = val.equals("__NULL__") ? "" : val;
        if (type.getType() == EavConstants.STRING_ID
                || type.getType() == EavConstants.DROPDOWN_ID) {
            List result = getHibernateTemplate().find(
                    "from StringAttribute s where s.parent=" + entityId
                            + " and " + "s.attribute=" + attrId);
            if (result.size() == 0) {
                StringAttribute sa = new StringAttribute();
                sa.setParent(getEntity(entityId));
                sa.setAttribute(metadataService.getAttributeType(attrId));
                sa.setValue(val.toString());
                getHibernateTemplate().save(sa);
            } else {
                StringAttribute sa = (StringAttribute) result.get(0);
                String oldValue = sa.getValue();
                sa.setValue(val.toString());
                getHibernateTemplate().update(sa);

                if (type.getAttribute_id() == 160 && oldValue != null && oldValue.equals("Guest") && val != null && !val.equals("Guest")) {
                    return true;
                }
            }
        } else if (type.getType() == EavConstants.DATE_ID && val != null
                && !val.toString().trim().equals("")) {
            List result = getHibernateTemplate().find(
                    "from DateAttribute s where s.parent=" + entityId + " and "
                            + "s.attribute=" + attrId);
            DateAttribute sa = null;
            if (result.size() > 0) {
                sa = (DateAttribute) result.get(0);
            } else {
                sa = new DateAttribute();
                sa.setAttribute(metadataService.getAttributeType(attrId));
                sa.setParent(getEntity(entityId));
            }

            try {
                sa.setValue(DateAttribute.formatter.parse(val.toString()));
                getHibernateTemplate().save(sa);
            } catch (ParseException re) {
                throw new RuntimeException("Unable to parse date");
            }
        }/*
			 * else if (type.getType() == EavConstants.DROPDOWN_ID ) {
			 *  }
			 */
        else if (type.getType() == EavConstants.NUMBER_ID && val != null
                && !val.toString().trim().equals("")) {
            List result = getHibernateTemplate().find(
                    "from NumberAttribute s where s.parent=" + entityId
                            + " and " + "s.attribute=" + attrId);
            if (result.size() > 0) {
                NumberAttribute sa = (NumberAttribute) result.get(0);
                sa.setValue(Long.parseLong(val.toString()));
                getHibernateTemplate().update(sa);
            }
        } else if (type.getType() == EavConstants.MULTI_SELECT_ID) {
            // TODO:
    } else if (type.getType() == EavConstants.BINARY_ID && val != null && !"".equals(val.toString())) {
      MultipartFile mFile = (MultipartFile) val;
      String fileName = mFile.getOriginalFilename();


      List result = getHibernateTemplate().find(
          "from BinaryAttribute s where s.parent=" + entityId
              + " and " + "s.attribute=" + attrId);
            try {
                if ( fileName != null && !"".equals(fileName) && fileName.length() > 2 )
                {
                    if (result.size() > 0 && fileName != null && !"".equals(fileName) && fileName.length() > 2) {
                        BinaryAttribute sa = (BinaryAttribute) result.get(0);
                        sa.setFileName(fileName);
                        sa.setDataStream(mFile.getInputStream());
                        getHibernateTemplate().update(sa);
                    } else {
                        BinaryAttribute ba = new BinaryAttribute();
                        ba.setAttribute(metadataService.getAttributeType(attrId));
                        ba.setParent(getEntity(entityId));
                        ba.setFileName(fileName);
                        ba.setDataStream(mFile.getInputStream());
                        getHibernateTemplate().save(ba);
                    }
                }
            } catch (IOException ioe) {
                throw new RuntimeException(ioe);
            }
        } else if (type.getType() == EavConstants.BOOLEAN_ID) {
            List result = getHibernateTemplate().find(
                    "from BooleanAttribute s where s.parent=" + entityId
                            + " and " + "s.attribute=" + attrId);
            if (result.size() > 0) {
                BooleanAttribute sa = (BooleanAttribute) result.get(0);
                sa.setValue(new Boolean(val.toString()));
                getHibernateTemplate().update(sa);
            } else {
                BooleanAttribute ba = new BooleanAttribute();
                ba.setAttribute(metadataService.getAttributeType(attrId));
                ba.setParent(getEntity(entityId));
                ba.setValue(new Boolean(val.toString()));
                getHibernateTemplate().save(ba);
            }
        }
        return false;
    }

    public void saveOrUpdateAttributes(long entityId, HttpServletRequest request) {
        Enumeration params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String p = (String) params.nextElement();
            if (p.startsWith("attr_")) {
                String pVal = request.getParameter(p);
                long attrId = Long.parseLong(p.substring(5));

                saveOrUpdateAttribute(attrId, entityId, pVal);
            }
        }
    }

    public EntityAttribute[] getEntityAttributes(long myEntityId) {
        List result = getHibernateTemplate().find(
                "from EntityAttribute e where e.myEntity=" + myEntityId);
        return (EntityAttribute[]) result.toArray(new EntityAttribute[result
                .size()]);
    }

    public Contacts[] getContact(long staffId) {
        List result = getHibernateTemplate().find(
                "from Contacts where staffid=" + staffId);
        return ((Contacts[]) result.toArray(new Contacts[result.size()]));
    }

    private User getKolId(long userId) {
        return (User) getHibernateTemplate().load(User.class, new Long(userId));
    }



    // AMIT - Changes for understanding and improving the performance of
    // AdvancedSearch query

    /**
     * This routine is used to get the list of OLs who match the name criteria
     * specified in the attributes. If no name criteria is defined, it would
     * return null
     */
    private List getOLsMatchingNameCriteria(HashMap attributes) {
        List nameResults = null;
        boolean lastNameFlag = false;
        boolean firstNameFlag = false;
        String nameQuery = null;

        long startTime = System.currentTimeMillis();

        if (attributes.containsKey(PropertyReader.getEavConstantValueFor("LAST_NAME"))) {
            lastNameFlag = true;
        }
        if (attributes.containsKey(PropertyReader.getEavConstantValueFor("FIRST_NAME"))) {
            firstNameFlag = true;
        }
        if (lastNameFlag && firstNameFlag) {
            nameQuery = "from User u where upper(u.firstName) like upper('%"
                    + attributes.get(PropertyReader.getEavConstantValueFor("FIRST_NAME"))
                    + "%') and upper(u.lastName) like upper('%"
                    + attributes.get(PropertyReader.getEavConstantValueFor("LAST_NAME")) + "%') and u.userType=4";
            attributes.remove(PropertyReader.getEavConstantValueFor("FIRST_NAME"));
            attributes.remove(PropertyReader.getEavConstantValueFor("LAST_NAME"));
        } else if (lastNameFlag) {
            nameQuery = "from User u where upper(u.lastName) like upper('%"
                    + attributes.get(PropertyReader.getEavConstantValueFor("LAST_NAME")) + "%') and u.userType=4";
            attributes.remove(PropertyReader.getEavConstantValueFor("LAST_NAME"));
        } else if (firstNameFlag) {
            nameQuery = "from User u where upper(u.firstName) like upper('%"
                    + attributes.get(PropertyReader.getEavConstantValueFor("FIRST_NAME")) + "%') and u.userType=4";
            attributes.remove(PropertyReader.getEavConstantValueFor("FIRST_NAME"));
        }

        if (null != nameQuery && !"".equals(nameQuery)) {
            nameQuery = nameQuery + " AND u.deleteFlag ='N' ";
            nameResults = getHibernateTemplate().find(nameQuery);
        }

        long endTime = System.currentTimeMillis();
        logger.debug("              Name search took : " + (endTime - startTime) + " msecs");

        return nameResults;
    }

    /**
     * This routine is used to get the list of OLs who match the "contacts"
     * criteria specified in the attributes. If no "contacts" criteria is
     * defined, it would return an empty HashSet
     *
     * @param attributes
     * @return
     */
    private HashSet getOLsMatchingContactCriteria(HashMap attributes) {
        long startTime = System.currentTimeMillis();

        String staffId = null;
        staffId = (String) attributes.get(PropertyReader.getEavConstantValueFor("CUSTOMER_CONTACTS"));
        attributes.remove(PropertyReader.getEavConstantValueFor("CUSTOMER_CONTACTS"));


        HashSet contactSet = null;
        if (staffId != null && !"".equals(staffId)) {
            contactSet = new HashSet();
            Contacts contacts[] = getContact(Long.parseLong(staffId));
            Contacts contact = null;
            if (contacts != null && contacts.length > 0) {
                for (int c = 0; c < contacts.length; c++) {
                    contact = contacts[c];
                    contactSet
                            .add(getKolId(contact.getKolId()).getKolid() + "");
                }
            }
        }

        long endTime = System.currentTimeMillis();
        logger.debug("              Contact search took : " + (endTime - startTime) + " msecs");

        return contactSet;
    }
public void check(HashMap attributes){
    String key = null;
    String value = null;
    Set keys = attributes.keySet();
    Iterator itr = keys.iterator();
    while (itr.hasNext()) {

        key = (String) itr.next();
        value = (String) attributes.get(key);
        logger.debug(key+"|"+value);
    }


}
    /**
     * This routine is used to get the list of OLs who match the EAV-attribute
     * criteria specified in the attributes. If no EAV-attribute criteria is
     * defined, it would return an empty HashSet
     *
     * @param attributes
     * @return
     */
    private HashSet getOLsMatchingEAVAtrributesCriteria(HashMap attributes) {
        String attrQuery = null;
        boolean attFlag = false;
        String key = null;
        String value = null;
        long startTime = System.currentTimeMillis();

        Set keys = attributes.keySet();
        Iterator itr = keys.iterator();

        StringAttribute stringAttribute[] = null;
        StringAttribute stringAttr = null;
        Entity entity = null;
        long entityId = -1;
        List results = null;
        HashSet expList = null;
        HashSet finalList = null;
        tempAttributeSet = new HashMap();
        int counter = 0;
        boolean hasAdded = false;
        HashSet tmpSet = new HashSet();
        HashSet result = new HashSet();

        while (itr.hasNext()) {
            finalList = new HashSet();
            attFlag = true;
            hasAdded = false;
            expList = new HashSet();
            key = (String) itr.next();
            value = (String) attributes.get(key);

            attrQuery = "from StringAttribute sa where upper(sa.value) like '%"
                        + value.toUpperCase()
                        + "%' and sa.attribute="
                        + Long.parseLong(key);
            results = getHibernateTemplate().find(attrQuery);
            if(results != null && results.size() == 0){
                tempAttributeSet.remove(key);
            }
            stringAttribute = (StringAttribute[]) results
                    .toArray(new StringAttribute[results.size()]);
            if (stringAttribute != null && stringAttribute.length > 0) {
                for (int i = 0; i < stringAttribute.length; i++) {
                    stringAttr = stringAttribute[i];
                    entity = stringAttr.getParent();
                    entityId = entity.getId();
                    entity = getEntity(entityId);

                    expList = parseParents(entity, entityId, expList);

                    finalList.addAll(expList);
                    hasAdded = true;
                }
            }
            else if (stringAttribute != null && stringAttribute.length == 0) {
                break;
            }
            if (hasAdded) {
                counter++;
                if (counter == 1) {
                    result = tmpSet = finalList;
                } else if (counter == 2) {
                    result = getIntersection(tmpSet, finalList);
                } else if (counter > 2) {
                    result = getIntersection(result, finalList);
                }
            }
        }

        long endTime = System.currentTimeMillis();
        logger.debug("              EAV Attrib search took : " + (endTime - startTime) + " msecs");

        return result;

    }

    /**
     * This routine is used to get the list of OLs who match the "Special"
     * EAV-attribute criteria specified in the attributes. If no EAV-attribute
     * criteria is defined, it would return an empty HashSet
     *
     * @param attributes
     * @return
     */
    private HashSet getOLsMatchingSpecialEAVAtrributesCriteria(HashMap attributes, List attribsToSearch) {
        String attrQuery = null;
        boolean attFlag = false;
        String key = null;
        String value = null;

        long startTime = System.currentTimeMillis();

        Set keys = attributes.keySet();
        Iterator itr = keys.iterator();

        StringAttribute stringAttribute[] = null;
        StringAttribute stringAttr = null;
        Entity entity = null;
        long entityId = -1;
        List results = null;
        HashSet expList = null;
        HashSet finalList = null;

        List attribsToRemove = new ArrayList();

        boolean hasAdded = false;
        HashSet result = new HashSet();
        while (itr.hasNext()) {
            finalList = new HashSet();
            attFlag = true;
            hasAdded = false;
            expList = new HashSet();
            key = (String) itr.next();
            value = (String) attributes.get(key);

            // Speciality field needs to be handled differently than other
            // attributes. The reason being
            // that the specified speciality might match any of the
            // "Speciality1" through "Speciality6" field
            boolean splCondition = attribsToSearch.contains(key);

            // We will process only the special condition EAV attributes over
            // here
            if (splCondition) {
                // remove this attribute from the HashMap to prevent further processing
                attribsToRemove.add(key);

                attrQuery = "from StringAttribute sa where upper(sa.value) like '%"
                        + value.toUpperCase()
                        + "%' and sa.attribute="
                        + Long.parseLong(key);

                results = getHibernateTemplate().find(attrQuery);

                stringAttribute = (StringAttribute[]) results
                        .toArray(new StringAttribute[results.size()]);
                if (stringAttribute != null && stringAttribute.length > 0) {
                    for (int i = 0; i < stringAttribute.length; i++) {
                        stringAttr = stringAttribute[i];
                        entity = stringAttr.getParent();
                        entityId = entity.getId();
                        entity = getEntity(entityId);

                        expList = parseParents(entity, entityId, expList);

                        finalList.addAll(expList);
                        hasAdded = true;
                    }
                }
                if (hasAdded) {
                    result = getUnion(result, finalList);
                }
            }
        }

        // remove the attributes that we have already handled in this routine
        for(int i=0;i<attribsToRemove.size(); i++) {
            attributes.remove(attribsToRemove.get(i));
            logger.debug("Removed attribute : " + attribsToRemove.get(i));
        }

        long endTime = System.currentTimeMillis();
        logger.debug("              Speciality search took : " + (endTime - startTime) + " msecs");

        return result;
    }

    /**
     * This routine is used to find the OLs matching the given "Speciality" criteria
     *
     * @param attributes
     * @return
     */
    private HashSet getOLsMatchingSpecialityCriteria(HashMap attributes) {
        List specialityAttribs = new ArrayList();
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_1")).getAttribute_id() + "");
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_2")).getAttribute_id() + "");
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_3")).getAttribute_id() + "");
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_4")).getAttribute_id() + "");
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_5")).getAttribute_id() + "");
        specialityAttribs.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_6")).getAttribute_id() + "");

        return getOLsMatchingSpecialEAVAtrributesCriteria(attributes, specialityAttribs);
    }

    /**
     * Log all the attributes that have been specified for the search query.
     * This is for debugging purposes
     *
     * @param attributes
     */
    private void printQueryAttributes(HashMap attributes) {
        Iterator iter = attributes.keySet().iterator();
        while (iter.hasNext()) {
            String attrib = (String) iter.next();
            String value = (String) attributes.get(attrib);

            logger.debug("Searching for attribute '" + attrib
                    + "' having value : '" + value + "'");
        }
    }

    /**
     * This routine is used to search for OLs matching the criteria specified for all
     * EAV-attributes mentioned in the "attribsToSearch" list. If any attribute present
     * in the list is not specified in the search criteria (attributes map), it is skipped
     * The routine first creates an on-the-fly query which searches for EAV objects meeting all
     * the specified search criteria. Then the routine looks up the OLs who contain these
     * EAV-objects.
     *
     * NOTE: Since the StringAttributes table can grow pretty big, we should be careful in
     * 		 writing the query used for joining with itself.
     *
     * @param attributes
     * @param attribsToSearch
     * @return
     */
    private HashSet getOLsMatchingRelatedEAVAtrributes(HashMap attributes, List attribsToSearch) {
        HashSet result = null;

        int searchParamIndex = 1;
        boolean runQuery = false;

         /* A sample query generated by the following code is given below.
           *
           * select sa1.parent_id
           * from STRING_ATTRIBUTE sa1
           * where sa1.attribute_id = 111
           * and   sa1.value  like '%200%'
           * and   exists (select 1 from STRING_ATTRIBUTE sa2
           *    			 where sa1.parent_id = sa2.parent_id
           *     			 and   sa2.attribute_id = 113
           *     			 and   sa2.value like '%MN%')
           * and   exists (select 1 from STRING_ATTRIBUTE sa3
           *     			 where   sa1.parent_id = sa3.parent_id
           *     			 and   sa3.attribute_id = 114
           *     			 and   sa3.value = '55905')
           */

        // We will search for all the specified attributes together, hence generate a suitable
        // query for the same

        StringBuffer queryBuffer = new StringBuffer();
        for(int i=0; i<attribsToSearch.size(); i++) {
            String key = (String) attribsToSearch.get(i);
            String value = (String) attributes.get(key);

            if(value != null) {
                //set the runQuery flag to true
                runQuery = true;

                if(searchParamIndex != 1) {
                    // add the and exists clause
                    queryBuffer.append(" and exists (");
                }

                // These values are coming from the drop-downs in the UI, so instead of
                // converting the value to upper case, and doing a like match, we can do
                // an actual comparison with the provided value
                queryBuffer.append("select sa").append(searchParamIndex).append(" from StringAttribute sa").append(searchParamIndex);
                queryBuffer.append(" where sa").append(searchParamIndex).append(".attribute = ").append(key);
                //queryBuffer.append(" and upper(sa").append(searchParamIndex).append(".value) like '%").append(value.toUpperCase()).append("%'");
                queryBuffer.append(" and sa").append(searchParamIndex).append(".value = '").append(value).append("'");

                if(searchParamIndex != 1) {
                    // close the and exists clause properly
                    queryBuffer.append(" and sa").append(searchParamIndex).append(".parent = sa1.parent)");
                }

                searchParamIndex++;
            }
        }

        // Now combine the individual queries for searching for an individual condition,
        // and create a single query which can search across all related attributes
        if(runQuery) {
            long startTime = System.currentTimeMillis();
            logger.debug("-----------------------Running : " + queryBuffer.toString());
            List results = getHibernateTemplate().find(queryBuffer.toString());
            logger.debug("-----------------------Got results in : " + (System.currentTimeMillis() - startTime) + " msecs");

            StringAttribute[] stringAttribute = (StringAttribute[]) results
                    .toArray(new StringAttribute[results.size()]);
            Entity entity = null;
            long entityId = -1;
            HashSet expList = null;

            startTime = System.currentTimeMillis();
            if (stringAttribute != null && stringAttribute.length > 0) {
                result = new HashSet();
                expList = new HashSet();
                for (int i = 0; i < stringAttribute.length; i++) {
                    StringAttribute stringAttr = stringAttribute[i];
                    entity = stringAttr.getParent();
                    entityId = entity.getId();
                    entity = getEntity(entityId);

                    expList = parseParents(entity, entityId, expList);

                    result.addAll(expList);
                }
            }
            logger.debug("-----------------------Parsed parents in : " + (System.currentTimeMillis() - startTime) + " msecs");

            if(result != null)
                logger.debug("The query '" + queryBuffer.toString() + "' returned " + results.size() + " OLs");
            else
                logger.debug("The query '" + queryBuffer.toString() + "' found no matching OLs");
        }

        return result;
    }

    /**
     * This routine is used to find all OLs matching the specified TA/TIER criteria
     *
     * @param attributes
     * @return
     */
    private HashSet getTAAndTierMatch(HashMap attributes) {
        long startTime = System.currentTimeMillis();
        List taTierList = new ArrayList();
        taTierList.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("THERAPEUTIC_AREA")).getAttribute_id()+""); // there are multiple ids for "Therapeutic Area"
        taTierList.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("TIER")).getAttribute_id()+"");
        HashSet results = getOLsMatchingRelatedEAVAtrributes(attributes, taTierList);
        removeAttribsFromMap(attributes, taTierList);

        long endTime = System.currentTimeMillis();
        logger.debug("              TA/TIER search took : " + (endTime - startTime) + " msecs");
        return results;
    }

    /**
     * This routine is used to find all OLs matching the specified
     * Position/Platform/Publication criteria
     *
     * @param attributes
     * @return
     */
    private HashSet getPositionPlatformPublicationMatch(HashMap attributes) {
        long startTime = System.currentTimeMillis();
        List posPlaPubList = new ArrayList();
        posPlaPubList.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("THERAPY")).getAttribute_id()+"");//TODO Hard coding
        posPlaPubList.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PLATFORM")).getAttribute_id()+"");
        posPlaPubList.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PUBLICATION")).getAttribute_id()+"");
        HashSet results = getOLsMatchingRelatedEAVAtrributes(attributes, posPlaPubList);
        removeAttribsFromMap(attributes, posPlaPubList);

        long endTime = System.currentTimeMillis();
        logger.debug("              Position/Publication search took : " + (endTime - startTime) + " msecs");

        return results;
    }

    /**
     * This routine is used to find all OLs matching the address criteria
     *
     * @param attributes
     * @return
     */
    private HashSet getAddressMatch(HashMap attributes) {
        long startTime = System.currentTimeMillis();

        // First find the results which match address field with Line 1
        List line1List = new ArrayList();
        line1List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_1")).getAttribute_id()+"");
        line1List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_STATE")).getAttribute_id() + "");
        line1List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_ZIP")).getAttribute_id()+"");
        line1List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id()+"");
        HashSet line1Matches = getOLsAddressMatchingRelatedEAVAtrributes(attributes, line1List);

        // Now find the results which match address field with Line 2
        List line2List = new ArrayList();
        line2List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_2")).getAttribute_id()+"");
        line2List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_STATE")).getAttribute_id() + "");
        line2List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_ZIP")).getAttribute_id()+"");
        line2List.add(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id()+"");
        HashSet line2Matches = getOLsAddressMatchingRelatedEAVAtrributes(attributes, line2List);

        // Take a union of line 1 and line 2 results
        HashSet addressMatches = getUnion(line1Matches, line2Matches);

        removeAttribsFromMap(attributes, line1List);
        removeAttribsFromMap(attributes, line2List);

        long endTime = System.currentTimeMillis();
        logger.debug("              Address search took : " + (endTime - startTime) + " msecs");

        return addressMatches;
    }

    private HashSet getOLsAddressMatchingRelatedEAVAtrributes(HashMap attributes, List attribsToSearch) {
        HashSet result = null;

        int searchParamIndex = 1;
        boolean runQuery = false;
        StringBuffer queryBuffer = new StringBuffer();
        for(int i=0; i<attribsToSearch.size(); i++) {
            String key = (String) attribsToSearch.get(i);
            String value = (String) attributes.get(key);

            if(value != null) {
                //set the runQuery flag to true
                runQuery = true;

                if(searchParamIndex != 1) {
                    // add the and exists clause
                    queryBuffer.append(" and exists (");
                }
                queryBuffer.append(" SELECT sa").append(searchParamIndex).append(" from StringAttribute sa").append(searchParamIndex);
                queryBuffer.append(", StringAttribute sb ").append(" where ( " +" (sa").append(searchParamIndex).append(".attribute = ").append(key).append(" and sb.attribute = "+(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_USAGE")).getAttribute_id()+"")+")");
                // specific check is provided for "Country", for country we dont need to check for 'like % %'
                // in case when Country is selected as " ", it will disply all the country name who has " ", if % % is there.
                // ideally we should not display any thing if Country is selected as " "
                if(key !=null && key.equalsIgnoreCase(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id()+"")){
                    queryBuffer.append(" and (upper(sa").append(searchParamIndex).append(".value) like '").append(value.toUpperCase()).append("' and sb.value = 'Primary')");
                }else{
                    queryBuffer.append(" and (upper(sa").append(searchParamIndex).append(".value) like '%").append(value.toUpperCase()).append("%' and sb.value = 'Primary')");
                }
                queryBuffer.append(" and sa").append(searchParamIndex).append(".parent = sb.parent )");

                if(searchParamIndex != 1) {
                    // close the and exists clause properly
                    queryBuffer.append(" and sa").append(searchParamIndex).append(".parent = sa1.parent)");
                }
                searchParamIndex++;
            }
        }
        // Now combine the individual queries for searching for an individual condition,
        // and create a single query which can search across all related attributes
        if(runQuery) {
            List results = getHibernateTemplate().find(queryBuffer.toString());

            StringAttribute[] stringAttribute = (StringAttribute[]) results
                    .toArray(new StringAttribute[results.size()]);
            Entity entity = null;
            long entityId = -1;
            HashSet expList = null;

            if (stringAttribute != null && stringAttribute.length > 0) {
                result = new HashSet();
                expList = new HashSet();
                for (int i = 0; i < stringAttribute.length; i++) {
                    StringAttribute stringAttr = stringAttribute[i];
                    entity = stringAttr.getParent();
                    entityId = entity.getId();
                    entity = getEntity(entityId);

                    expList = parseParents(entity, entityId, expList);

                    result.addAll(expList);
                }
            }

            if(result != null)
                logger.debug("The query '" + queryBuffer.toString() + "' returned " + results.size() + " OLs");
            else
                logger.debug("The query '" + queryBuffer.toString() + "' found no matching OLs");
        }
        return result;
    }

    /**
     * This routine is used to remove the attributes specified in the "attributesToRemove"
     * list from the attributes map. If a particular attribute is not available in the map,
     * it ignores it
     *
     * @param attributes
     * @param attributesToRemove
     */
    private void removeAttribsFromMap(HashMap attributes, List attributesToRemove) {
        for(int i=0; i<attributesToRemove.size(); i++) {
            Object attrib = attributesToRemove.get(i);
            if(attrib != null) {
                attributes.remove(attrib);
            }
        }
    }

    /**
     * Search for users matching the specified search criteria
     */
    public User[] getSearchUser(HashMap attIDMap) {
        User expertSearchResults[] = null;
        LocationView expertSearchResultsForLocation[] = null;
        SpecialtyView expertSearchResultsForSpecialty[] = null;
        HomeUserView expertSearchResultsForHomeUser[] =null;
        if (attIDMap != null && !attIDMap.isEmpty()) {
            HashMap attributes = attIDMap;
            List nameResults = null;
            ArrayList orgResults = null;
            HashSet contactSet = null;
            HashSet specialityResults = null;
            HashSet taTierResults = null;
            HashSet posPlaPubResults = null;
            HashSet addressResults = null;
            HashSet eavResults = null;
            HashSet result = null;
            this.tempAttributeSet = attIDMap;
            boolean affilitedOrgFlag =  attributes.containsKey("ORG_OL_LIST");
            boolean lastNameFlag = attributes.containsKey(PropertyReader.getEavConstantValueFor("LAST_NAME"));
            boolean firstNameFlag = attributes.containsKey(PropertyReader.getEavConstantValueFor("FIRST_NAME"));
            boolean contactFlag = attributes.containsKey(PropertyReader.getEavConstantValueFor("CUSTOMER_CONTACTS"));

            boolean specialityFlag = attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_1")).getAttribute_id() + "") ||
                                     attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_2")).getAttribute_id() + "") ||
                                     attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_3")).getAttribute_id() + "") ||
                                     attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_4")).getAttribute_id() + "") ||
                                     attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_5")).getAttribute_id() + "") ||
                                     attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_6")).getAttribute_id() + "");
            boolean taTierFlag = attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("TIER")).getAttribute_id() + "") ||
                                 attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("THERAPEUTIC_AREA")).getAttribute_id() + "");

            boolean posPlaPubFlag = false;
             /*attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("POSITION_TO_CUSTOMER_SCIENCE")).getAttribute_id() + "") ||
                                       attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PLATFORM")).getAttribute_id() + "") ||
                                       attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("PUBLICATION")).getAttribute_id() + ""); */

            boolean addressFlag   = attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_1")).getAttribute_id() + "") ||
                                      attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_LINE_2")).getAttribute_id() + "") ||
                                      attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id() + "") ||
                                      attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_STATE")).getAttribute_id() + "") ||
                                      attributes.containsKey(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("ADDRESS_ZIP")).getAttribute_id() + "");
            // Print out the search attributes for debugging purposes
            if(!affilitedOrgFlag){
                printQueryAttributes(attributes);
            }


            // Identify the OLs which match the name criteria specified on the
            // search page
            if(lastNameFlag || firstNameFlag) {
                logger.debug("Searching for name criteria");
                nameResults = getOLsMatchingNameCriteria(attributes);
                if((nameResults == null) || (nameResults.size() == 0))
                    return null; // we haven't found any match for the specified name criteria

                logger.debug("Found " + nameResults.size() + " OLs matching name criteria");
            }
            //Get all the OL belongs to the affilited orgnization
            if(affilitedOrgFlag){
                logger.debug("Searching for Organization criteria");
                orgResults = (ArrayList) attributes.get("ORG_OL_LIST");
                logger.debug("Found " + orgResults.size() + " OLs matching orgnization criteria");
                attributes.remove("ORG_OL_LIST");
            }

            // Identify the OLs which match because of the contacts criteria
            // specified on the search page
            if (contactFlag) {
                logger.debug("Searching for contact criteria");
                contactSet = getOLsMatchingContactCriteria(attributes);
                if((contactSet == null) || (contactSet.size() == 0))
                    return null; // we haven't found any match for the specified contacts criteria

                logger.debug("Found " + contactSet.size() + " OLs matching contact criteria");
            }

            // Identify the OLs which match the search criteria for the speciality field
            if(specialityFlag) {

                logger.debug("Searching for speciality criteria");
                specialityResults = getOLsMatchingSpecialityCriteria(attributes);

                if((specialityResults == null) || (specialityResults.size() == 0))
                    return null; // we haven't found any match for the specified speciality criteria

                logger.debug("Found " + specialityResults.size() + " OLs for speciality criteria");
            }

            // Search for related fields as a set
            if(taTierFlag) {
                logger.debug("Searching for ta tier criteria");
                taTierResults = getTAAndTierMatch(attributes);
                if((taTierResults == null) || (taTierResults.size() == 0))
                        return null; // we haven't found any match for the specified TA/Tier criteria

            }

            if(posPlaPubFlag) {
                logger.debug("Searching for Position/Platform/Publication criteria");
                posPlaPubResults = getPositionPlatformPublicationMatch(attributes);
                if((posPlaPubResults == null) || (posPlaPubResults.size() == 0))
                    return null; // we haven't found any match for the specified Position/Platform/Publication criteria

            }

            // Identify the OLs which match the line criteria
            if(addressFlag) {
                logger.debug("Searching for line criteria");
                addressResults = getAddressMatch(attributes);
                if((addressResults == null) || (addressResults.size() == 0))
                    return null;  // we haven't found any match for the specified address criteria

                logger.debug("Found " + addressResults.size() + " OLs for line criteria");
            }

            // Identify the OLs which match the other search criteria specified
            // on the search page
            logger.debug(" Size of the attributes -->"+attributes.size());

            if(attributes.size() > 0) {
                logger.debug("Searching for remaining EAV attributes");
                eavResults = getOLsMatchingEAVAtrributesCriteria(attributes);
                if((eavResults == null) || (eavResults.size() == 0)){
                       return null; // we haven't found any match for the specified criteria for EAV attributes
                }
                logger.debug("Found " + eavResults.size() + " OLs matching remaining EAV attrib criteria");
            }

            // Compute results as an intersection between all separate results


            if(contactFlag) {
                result = contactSet;
            }

            if(result != null)
                logger.debug("Have " + result.size() + " OLs after using contact set");

            if(specialityFlag) {
                if(result == null)
                    result = specialityResults; // The contact criteria was not defined
                else
                    result = getIntersection(result, specialityResults); // Some OLs were found via contact match, hence find an intersection
            }
            if(result != null)
                logger.debug("Have " + result.size() + " OLs after intersecting with speciality results");

            if(taTierFlag) {
                if(result == null)
                    result = taTierResults;
                else
                    result = getIntersection(result, taTierResults);
            }

            if(result != null)
                logger.debug("Have " + result.size() + " OLs after intersecting with TA/TIER results");

            if(posPlaPubFlag) {
                if(result == null)
                    result = posPlaPubResults;
                else
                    result = getIntersection(result, posPlaPubResults);
            }

            if(result != null)
                logger.debug("Have " + result.size() + " OLs after intersecting with Position/Platform/Publication results");



            if(addressFlag) {
                if(result == null)
                    result = addressResults;
                else
                    result = getIntersection(result, addressResults);
            }

            if(result != null)
                logger.debug("Have " + result.size() + " OLs after intersecting with line results");


            if(eavResults != null && eavResults.size() > 0) {
                if(result == null)
                    result = eavResults;
                else
                    result = getIntersection(result, eavResults); // Some OLs were found via contact/speciality match, hence find an intersection
            }

            if(result != null)
                logger.debug("Have " + result.size() + " OLs after intersecting with eavResults");
            else
                logger.debug("Have no OLs so far");

            // TODO: Remove these redundant flags
            boolean attFlag = ((result != null) && (result.size() != 0));
            logger.debug(" Result of the --"+attFlag);
            // Now take an intersection with the OLs matching the name criteria
            StringBuffer kolIds = new StringBuffer();
            ArrayList kolIdList = new ArrayList();
            if ((lastNameFlag || firstNameFlag) && attFlag) {

                if (nameResults != null && !nameResults.isEmpty()
                        && result != null && !result.isEmpty()) {

                    User users[] = (User[]) nameResults
                            .toArray(new User[nameResults.size()]);
                    User user = null;

                    for (int u = 0; u < users.length; u++) {
                        user = users[u];
                        if (result.contains(user.getKolid() + "")) {
                            if (!kolIdList.contains(user.getKolid() + "")) {
                                kolIdList.add(user.getKolid() + "");

                            }
                        }
                    }
                }
            } else if ((lastNameFlag || firstNameFlag) && !(contactFlag || specialityFlag || taTierFlag || posPlaPubFlag || addressFlag)) {
                    if (nameResults != null && !nameResults.isEmpty()) {
                    User users[] = (User[]) nameResults
                            .toArray(new User[nameResults.size()]);
                    User user = null;
                    for (int u = 0; u < users.length; u++) {
                        user = users[u];
                        kolIdList.add(user.getKolid() + "");
                    }
                }

            } else {
                String kol = null;
                if (result != null && !result.isEmpty()) {
                    Iterator iter = result.iterator();

                    while (iter.hasNext()) {
                        kol = (String) iter.next();
                        kolIdList.add(kol);
                    }
                }
            }

            if(orgResults != null && !orgResults.isEmpty()){
                if( kolIdList != null && !kolIdList.isEmpty()){
                logger.debug("ORG Size "+orgResults.size());
                logger.debug(" KOL ID Size "+kolIdList.size());
                kolIdList = getListInteraction(orgResults,kolIdList);
                logger.debug(" FINAL KOL ID Size "+kolIdList.size());
            }else if(!(lastNameFlag || firstNameFlag || contactFlag || specialityFlag || taTierFlag || posPlaPubFlag || addressFlag)) {
                        // If no other search criteria was specified, the OLs matching the Organization criteria are the final result
                // Otherwise, the reason for kolIdList being null or empty is that the intersection of other criteria returned
                // an empty set
                Iterator itr = orgResults.iterator();
                while(itr.hasNext()){
                    User user = (User) itr.next();
                    String kolId = Long.toString(user.getKolid());
                    kolIdList.add(kolId);
                }
            }
            }



            List resultListForSpecialty = new ArrayList();
            List resultListForLocation = new ArrayList();
            List resultListForHomeUser = new ArrayList();
            if (!kolIdList.isEmpty()) {
                // Concatenate all kolids to be used in an "in" query
                // Oracle has an upper limit of @see
                // DataService#MAX_IN_CLAUSE_ENTRIES on the number of entries in
                // a SQL query
                // Hence split the overall kolIds into batches none greater than
                // MAX_IN_CLAUSE_ENTRIES
                for (int j = 0; j < kolIdList.size(); j += MAX_IN_CLAUSE_ENTRIES) {

                    // refresh the buffer
                    kolIds = new StringBuffer();

                    int remainingEntries = (kolIdList.size() - j); // check how
                                                                    // many
                                                                    // entries
                                                                    // are left
                    int maxInnerLoopIndex = (remainingEntries > MAX_IN_CLAUSE_ENTRIES) ? MAX_IN_CLAUSE_ENTRIES
                            : remainingEntries;
                    for (int a = j; a < j + maxInnerLoopIndex; a++) {
                        if (a == j) {
                            kolIds = kolIds.append(kolIdList.get(a));
                        } else {
                            kolIds = kolIds.append(", ").append(
                                    kolIdList.get(a));
                        }
                    }
                    String expertQuery = null;
                    expertQuery = "from SpecialtyView u where u.kolid in ("
                            + kolIds + ") and u.deleteflag ='N'";
                    resultListForSpecialty
                            .addAll(getHibernateTemplate().find(expertQuery));
                    expertQuery = "from LocationView u where u.kolid in ("
                            + kolIds + ") and u.deleteflag ='N' and u.state like '%'";
                    resultListForLocation
                            .addAll(getHibernateTemplate().find(expertQuery));
                    expertQuery = "from HomeUserView u where u.kolId in ("
                        + kolIds + ") and u.deleteFlag ='N'";
                    resultListForHomeUser
                            .addAll(getHibernateTemplate().find(expertQuery));
                }
            }
            expertSearchResultsForLocation = (LocationView[]) resultListForLocation
                    .toArray(new LocationView[resultListForLocation.size()]);
            expertSearchResultsForSpecialty = (SpecialtyView[]) resultListForSpecialty
                    .toArray(new SpecialtyView[resultListForSpecialty.size()]);
            expertSearchResultsForHomeUser = (HomeUserView[]) resultListForHomeUser
                    .toArray(new HomeUserView[resultListForHomeUser.size()]);
            expertSearchResults = populateAttrs(expertSearchResultsForLocation,
                    expertSearchResultsForSpecialty,expertSearchResultsForHomeUser);

        } else if (attIDMap != null && attIDMap.isEmpty()) {
            // TODO: Refactor this as well
            List expertResult = getHibernateTemplate().find(
                    "from User u where u.userType=4 and  u.deleteFlag ='N' ");
            expertSearchResults = (User[]) expertResult
                    .toArray(new User[expertResult.size()]);
            List resultList = new ArrayList();
            List resultList1 = new ArrayList();
            if (expertSearchResults != null && expertSearchResults.length > 0) {
                StringBuffer kolIds = new StringBuffer();
                int iterations = 0;
                for (int e = 0; e < expertSearchResults.length; e++) {
                    if (iterations == 0) {
                        kolIds.append(expertSearchResults[e].getKolid());
                    } else {
                        kolIds.append(", ").append(
                                expertSearchResults[e].getKolid());
                    }
                    iterations++;
                    if (iterations == 999) {

                        String expertQuery = "from SpecialtyView u where u.kolid in ("
                                + kolIds + ") and u.deleteflag ='N'";
                        resultList.addAll(getHibernateTemplate().find(
                                expertQuery));
                        expertQuery = "from LocationView u where u.kolid in ("
                                + kolIds + ") and u.deleteflag ='N' and u.state like '%'";
                        resultList1.addAll(getHibernateTemplate().find(
                                expertQuery));

                        iterations = 0;
                        kolIds = new StringBuffer();
                    }
                }
                if (iterations < 999) {
                    String expertQuery = "from SpecialtyView u where u.kolid in ("
                            + kolIds + ") and u.deleteflag ='N'";
                    resultList.addAll(getHibernateTemplate().find(expertQuery));
                    expertQuery = "from LocationView u where u.kolid in ("
                            + kolIds + ") and u.deleteflag ='N' and u.state like '%'";
                    resultList1
                            .addAll(getHibernateTemplate().find(expertQuery));
                }
                expertSearchResultsForSpecialty = (SpecialtyView[]) resultList
                        .toArray(new SpecialtyView[resultList.size()]);
                expertSearchResultsForLocation = (LocationView[]) resultList1
                        .toArray(new LocationView[resultList.size()]);
                expertSearchResults = populateAttrs(expertSearchResultsForLocation,
                        expertSearchResultsForSpecialty,expertSearchResultsForHomeUser);
            }
        }
        return expertSearchResults;
    }

    // AMIT - END: Changes for understanding and improving the performance of
    // AdvancedSearch query



    private User[] populateAttrs(LocationView[] expertSearchResults1,
                                 SpecialtyView[] expertSearchResults2,HomeUserView[] expertSearchResults3) {
        User[] users = null;
        HashMap locationMap = new HashMap();
        HashMap specialtyMap = new HashMap();
        HashMap homeUserMap = new HashMap();
        if (expertSearchResults1 != null) {
            for (int l = 0; l < expertSearchResults1.length; l++) {
                if (expertSearchResults1[l] != null) {
                    locationMap.put(expertSearchResults1[l].getId() + "",
                            expertSearchResults1[l]);
                }
            }
        }
        if (expertSearchResults2 != null) {
            for (int l = 0; l < expertSearchResults2.length; l++) {
                if (expertSearchResults2[l] != null) {
                    specialtyMap.put(expertSearchResults2[l].getId() + "",
                            expertSearchResults2[l]);
                }
            }
        }
        if (expertSearchResults3 != null) {
            for (int l = 0; l < expertSearchResults3.length; l++) {
                if (expertSearchResults3[l] != null) {
                    homeUserMap.put(expertSearchResults3[l].getId() + "",
                            expertSearchResults3[l]);
                }
            }
        }
        if (expertSearchResults2 != null) {
            users = new User[expertSearchResults2.length];
            SpecialtyView view = null;
            for (int y = 0; y < expertSearchResults2.length; y++) {
                users[y] = new User();
                view = expertSearchResults2[y];
                if (view != null) {
                    users[y].setId(view.getId());
                    users[y].setKolid(view.getKolid());
                    users[y].setFirstName(view.getFirstname());
                    users[y].setLastName(view.getLastname());
                    users[y].setMiddleName(view.getMiddlename());
                    users[y].setSpeciality(getSpecialty(view));
                    if (locationMap.containsKey(view.getId() + "")) {
                        users[y].setLocation(getLocation((LocationView) locationMap.get(view.getId() + "")));
                    }
                    if (homeUserMap.containsKey(view.getId() + "")) {
                        users[y].setTitle(((HomeUserView) homeUserMap.get(view.getId() + "")).getTitle());
                    }
                }
            }
        }
        return users;
    }

    private String getSpecialty(SpecialtyView expertSearchResults) {
        String specialty = null;
        if (expertSearchResults.getSpecialty1() != null
                && !" ".equals(expertSearchResults.getSpecialty1())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty1();
            } else {
                specialty = expertSearchResults.getSpecialty1();
            }
        }
        if (expertSearchResults.getSpecialty2() != null
                && !" ".equals(expertSearchResults.getSpecialty2())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty2();
            } else {
                specialty = expertSearchResults.getSpecialty2();
            }
        }
        if (expertSearchResults.getSpecialty3() != null
                && !" ".equals(expertSearchResults.getSpecialty3())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty3();
            } else {
                specialty = expertSearchResults.getSpecialty3();
            }
        }
        if (expertSearchResults.getSpecialty4() != null
                && !" ".equals(expertSearchResults.getSpecialty4())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty4();
            } else {
                specialty = expertSearchResults.getSpecialty4();
            }
        }
        if (expertSearchResults.getSpecialty5() != null
                && !" ".equals(expertSearchResults.getSpecialty5())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty5();
            } else {
                specialty = expertSearchResults.getSpecialty5();
            }
        }
        if (expertSearchResults.getSpecialty6() != null
                && !" ".equals(expertSearchResults.getSpecialty6())) {
            if (specialty != null) {
                specialty += ", " + expertSearchResults.getSpecialty6();
            } else {
                specialty = expertSearchResults.getSpecialty6();
            }
        }
        return specialty;
    }

    private String getLocation(LocationView expertSearchResults) {
        String location = null;
        if (expertSearchResults.getState() != null
                && !"".equals(expertSearchResults.getState())
                && !" ".equals(expertSearchResults.getState()))
        {

                if (location != null) {
                        location += ", " + expertSearchResults.getState();
                } else {
                        location = expertSearchResults.getState();

                }
        }

        if (expertSearchResults.getCity() != null
                && !"".equals(expertSearchResults.getCity())
                && !" ".equals(expertSearchResults.getCity()))
        {

                        location = expertSearchResults.getState();
        }

        if (expertSearchResults.getCountry() != null
                && !"".equals(expertSearchResults.getCountry())) {

            if (location != null ) {
                location += ", " + expertSearchResults.getCountry();

            } else {
                location = expertSearchResults.getCountry();

            }
        }

        return location;
    }

    public User[] getAttrVals(User[] user) {
        User[] finalUser = null;
        if (user != null && user.length > 0) {
            User userObj = null;
            for (int i = 0; i < user.length; i++) {
                getCustomAttributesForOl(user[i]);
            }
        }
        return user;
    }

    public void getCustomAttributesForOl(User userObj) {
        boolean usageFlag = false;
        EntityAttribute[] olSummary = getEntityAttributes(userObj
                .getKolid(), Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_SUMMARY")).getAttribute_id()+""));
        if (olSummary != null && olSummary.length > 0) {
            EntityAttribute olSum = olSummary[0];
            EntityAttribute[] profile = null;
            // get Specialties info
            profile = getEntityAttributes(olSum.getMyEntity().getId(),
                    Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_PROFILE")).getAttribute_id()+""));
            if (profile != null && profile.length > 0) {
                String[] splInfo = new String[profile.length];
                for (int k = 0; k < profile.length; k++) {
                    EntityAttribute ea = profile[k];
                    StringAttribute[] attributes = getStringAttribute(ea
                            .getMyEntity());
                    String specialty = null;
                    for (int l = 0; l < attributes.length; l++) {
                        if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_1")).getAttribute_id()
                                || attributes[l].getAttribute()
                                        .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_2")).getAttribute_id()
                                || attributes[l].getAttribute()
                                        .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_3")).getAttribute_id()
                                || attributes[l].getAttribute()
                                        .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_4")).getAttribute_id()
                                || attributes[l].getAttribute()
                                        .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_5")).getAttribute_id()
                                || attributes[l].getAttribute()
                                        .getAttribute_id() == getAttributeIdFromName(PropertyReader.getEavConstantValueFor("SPECIALTY_6")).getAttribute_id()) {
                            if (specialty != null
                                    && attributes[l].getValue() != null
                                    && !" ".equals(attributes[l]
                                            .getValue())) {
                                specialty += ", "
                                        + attributes[l].getValue();
                            } else if (attributes[l].getValue() != null
                                    && !" ".equals(attributes[l]
                                            .getValue())) {
                                specialty = attributes[l].getValue();
                            }
                        }
                    }
                    userObj.setSpeciality(specialty);
                }
            }
            // get Location info
            profile = getEntityAttributes(olSum.getMyEntity().getId(),
                    Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_ADDRESS")).getAttribute_id()+""));
            String state = null;
            String country = null;
			String city = null;
            String location = null;
            if (profile != null && profile.length > 0) {
                for (int k = 0; k < profile.length; k++) {
                    EntityAttribute ea = profile[k];
                    StringAttribute[] attributes = getStringAttribute(ea
                            .getMyEntity());
                    for (int l = 0; l < attributes.length; l++) {
                        if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                		PropertyReader.getEavConstantValueFor("ADDRESS_STATE")).getAttribute_id()) {
                            state = attributes[l].getValue();
                        } else if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                		PropertyReader.getEavConstantValueFor("ADDRESS_COUNTRY")).getAttribute_id()) {
                            country = attributes[l].getValue();
                        } else if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                		PropertyReader.getEavConstantValueFor("ADDRESS_CITY")).getAttribute_id()) {
                            city = attributes[l].getValue();
                        } else if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                		PropertyReader.getEavConstantValueFor("ADDRESS_USAGE")).getAttribute_id()
                                && "Primary"
                                        .equalsIgnoreCase(attributes[l]
                                                .getValue())) {
                            usageFlag = true;
                        }
                    }
                }
            }
            if (state != null && !"-NA-".equals(state)) {
                location = state;
            }
			if (city != null && !"".equals(city)) {
                location =city;
            }
            if (country != null) {
                if (location != null) {
                    location += ", " + country;
                } else {
                    location = country;
                }
            }
            if (usageFlag) {
                userObj.setLocation(location);
            }

            // get contactInfo number
            profile = getEntityAttributes(olSum.getMyEntity().getId(),
                    Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_CONTACT")).getAttribute_id()+""));
            String contactType = "";
            String contactInfo = "";
            if (profile != null && profile.length > 0) {
                for (int k = 0; k < profile.length; k++) {
                    contactType="";
                    contactInfo="";
                    EntityAttribute ea = profile[k];
                    StringAttribute[] attributes = getStringAttribute(ea
                            .getMyEntity());
                    for (int l = 0; l < attributes.length ; l++) {
                        if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                        PropertyReader.getEavConstantValueFor("EXPERT_CONTACT_CONTACT_TYPE")).getAttribute_id()) {
                            contactType = attributes[l].getValue();
                        } else if (attributes[l].getAttribute()
                                .getAttribute_id() == getAttributeIdFromName(
                                        PropertyReader.getEavConstantValueFor("EXPERT_CONTACT_CONTACT_INFO")).getAttribute_id()) {
                            contactInfo = attributes[l].getValue();
                        }
                        BooleanAttribute ba = getBooleanAttribute(ea.getMyEntity().getId(), getAttributeIdFromName(
                                PropertyReader.getEavConstantValueFor("EXPERT_CONTACT_PREFERRED_CONTACT")).getAttribute_id());
                        if (ba != null && ba.getValue().booleanValue()) {
                            // this is the preferred contact
                            userObj.setPreferredContactType(contactType);
                            userObj.setPreferredContactInfo(contactInfo);
                        }

                    }
                    if (contactInfo != null && !contactInfo.trim().equals("") && contactType != null && contactType.equalsIgnoreCase("phone")) {
                        userObj.setPhone(contactInfo);

                    }
                }
            }
        }
    }

    private HashSet parseParents(Entity entity, long entityId, HashSet results) {
        return parseParents(entity.getType().getEntity_type_id(), entityId, results);
    }

    /**
     * This routine is used to find an entity in the hierachy of the given entity
     * that is of type OL Profile (id = 101)
     *
     * @param entityType
     * @param entityId
     * @param results
     * @return
     */
    private HashSet parseParents(long entityType, long entityId, HashSet results) {
        if (entityType != 101) {
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                // TODO: See if there is any entity-based way provided by hibernate for using
                // prepared statements.
                ps = this.getSession().connection().prepareStatement("select ea1.parent_id, e.type " +
                        "from entities_attribute ea1, entities e " +
                        "where e.entity_id = ea1.parent_id " +
                        "and   ea1.myentity_id = ?");

                ps.setLong(1, entityId);
                rs = ps.executeQuery();

                if(rs.next()) {
                    long parentId = rs.getLong(1);
                    long parentEntityType = rs.getLong(2);

                    // Close the ResultSet and PreparedStatement objects
                    rs.close();
                    ps.close();

                    rs = null;
                    ps = null;

                    // Make a recursive call to move one level up in the entity hierarchy
                    parseParents(parentEntityType, parentId, results);
                }
            }
            catch(SQLException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            } catch (DataAccessResourceFailureException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            } catch (HibernateException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
            finally {
                try {
                    if(rs != null)
                        rs.close();
                }
                catch(Exception e) {
                    // ignore it
                }

                try {
                    if(ps != null)
                       ps.close();
                }
                catch(Exception e) {
                    // ignore it
                }
            }

        } else {
            if (results != null && !results.contains(entityId + "")) {
                results.add(entityId + "");
            }
        }
        return results;
    }

    private HashSet getUnion(HashSet set1, HashSet set2) {
        HashSet results = new HashSet();
        if (set1 != null){
            results.addAll(set1);
        }
        if( set2 != null ){
            results.addAll(set2);
        }
        return results;
    }

    private HashSet getIntersection(HashSet set1, HashSet set2) {
        HashSet results = new HashSet();
        if (set1 != null && !set1.isEmpty() && set2 != null && !set2.isEmpty()) {
            Iterator itr = set1.iterator();
            String kol = null;
            while (itr.hasNext()) {
                kol = (String) itr.next();
                if (set2.contains(kol)) {
                    results.add(kol);
                }
            }
        }
        return results;
    }

    private ArrayList getListInteraction(ArrayList l1,ArrayList l2){
        ArrayList results = new ArrayList();
        if (l1 != null && !l1.isEmpty() && l2 != null && !l2.isEmpty()) {
            Iterator itr = l1.iterator();
            while(itr.hasNext()){
                User user = (User) itr.next();
                String kolId = Long.toString(user.getKolid());
                if(!results.contains(kolId)){
                    if(l2.contains(kolId)){
                        results.add(kolId);
                    }
                }
            }
        }
        return results;
    }

    private Object getParameter(HttpServletRequest req, String name){
    if(req instanceof MultipartHttpServletRequest){
      MultipartHttpServletRequest mreq = (MultipartHttpServletRequest)req;
      if(mreq.getFile(name) != null) return mreq.getFile(name);
    }
    return req.getParameter(name);
  }

  public boolean saveOrUpdateAttributes(long entityId,
                                        HttpServletRequest request, String editor) {
    Collection params = new ArrayList();
        Enumeration paramsEnum = request.getParameterNames();
    while(paramsEnum.hasMoreElements()){
      params.add(paramsEnum.nextElement());
    }
    if(request instanceof MultipartHttpServletRequest){
      Iterator fileNamesItr = ((MultipartHttpServletRequest)request).getFileNames();
      while(fileNamesItr.hasNext()){
        params.add(fileNamesItr.next());
      }
    }
        boolean register = false;
        for (Iterator itr=params.iterator();itr.hasNext();) {
            String p = (String) itr.next();
            if (p.startsWith("attr_")) {
                Object pVal = getParameter(request, p);

                long attrId = Long.parseLong(p.substring(5));
                if (!register)
                    register = saveOrUpdateAttribute(attrId, entityId, pVal);
                else
                    saveOrUpdateAttribute(attrId, entityId, pVal);
            }
        }
        // make entry into audit table
        AuditInfo info = new AuditInfo();
        info.setEditedEntityId(entityId);
        info.setUserName(editor);
        auditService.saveAuditInfo(info);
        return register;
    }

    public IAuditService getAuditService() {
        return auditService;
    }

    public void setAuditService(IAuditService auditService) {
        this.auditService = auditService;
    }

    public StringAttribute[] getMatchingAttributes(String text, long attributeId) {
        List matches = getHibernateTemplate().find(
                "from StringAttribute sa where upper(sa.value) like upper('%"
                        + text + "%') and sa.attribute=" + attributeId);
        return (StringAttribute[]) matches.toArray(new StringAttribute[matches
                .size()]);
    }

    public StringAttribute getAttribute(long parentId, long attributeId) {
        List l = getHibernateTemplate().find(
                "from StringAttribute sa where sa.attribute=" + attributeId
                        + " and sa.parent=" + parentId);
        if (l.size() == 0)
            return null;
        return (StringAttribute) l.get(0);
    }

    public AttributeType getAttributeIdFromName(String attName) {
        List matches = getHibernateTemplate().find(
                "from AttributeType a where upper(a.name) = upper('" + attName
                        + "') order by a.attribute_id");
        AttributeType[] result = (AttributeType[]) matches
                .toArray(new AttributeType[matches.size()]);
        if (result != null && result.length > 0) {
            return result[0];
        }
        return null;
    }

    public void savePublications(long kolId, int attrId, ArrayList pubList) {
        if (pubList != null && pubList.size() > 0) {
            Publications publications = null;
            for (int i = 0; i < pubList.size(); i++) {
                EntityAttribute entityAttribute = new EntityAttribute();
                entityAttribute.setParent(getEntity(kolId));
                AttributeType at = metadataService.getAttributeType(attrId);
                entityAttribute.setAttribute(at);
                saveEntityAttribute(entityAttribute, at);
                publications = (Publications) pubList.get(i);
                saveStringAttribute(metadataService.getAttributeType(56),
                        entityAttribute.getMyEntity(), publications.getTitle());
                saveStringAttribute(metadataService.getAttributeType(60),
                        entityAttribute.getMyEntity(), publications.getType());
                saveStringAttribute(metadataService.getAttributeType(59),
                        entityAttribute.getMyEntity(), publications.getYear());
                saveStringAttribute(metadataService.getAttributeType(57),
                        entityAttribute.getMyEntity(), publications
                                .getNlmJournal());
            }
        }
    }

    public LocationView getUserLocation(User u) {
        List result = getHibernateTemplate().find(
                "from LocationView l where l.id=" + u.getId() + " and l.kolid="
                        + u.getKolid() + " and l.deleteflag ='N' and l.city like '%'");
        if (result.size() == 0)
        {
            System.out.println("  location view  = 0 ");
            return null;
        }
        Iterator i = result.iterator();
        LocationView locationView = null;
        LocationView temp = null;
        while ( i.hasNext() && temp == null )
        {
           locationView = (LocationView) i.next();
           if ( locationView.getAddress1() != null  && !locationView.getCity().equals("")
              && locationView.getCity() != null  && !locationView.getCity().equals("") )
           {
               System.out.println("  location view  found  ");
               temp = locationView;
           }
        }
        return (LocationView) result.get(0);
    }

    public User[] getEntityforAttributeValue(String value) {
        List result = getHibernateTemplate().find("select distinct A.id from Entity A, EntityAttribute B, EntityAttribute C," +
           "StringAttribute D where upper(D.value) like upper('%"+value+"%') and D.parent=C.myEntity and C.parent=B.myEntity " +
             "and B.parent=A.id and A.type=101");

        //from SpecialtyView u where u.kolid in ("
        String query = "from User u where u.kolid in( ";
        Long[] str =(Long[]) result.toArray(new Long[result.size()]);

        if (str.length >0) {
            for (int i=0;i<str.length;i++) {
                if (i == 0)
                    query += str[0];
                else
                    query += ", " + str[i];
            }
            query += " ) and u.deleteFlag ='N' ";
        } else {
            return new User[0];
        }
        List r = getHibernateTemplate().find(query);

        User [] experts = ((User[]) r.toArray(new User[r.size()]));
        for (int i=0; i<experts.length; i++) {
            LocationView l = getUserLocation(experts[i]);
            experts[i].setUserLocation(l);
        }
        return getAttrVals(experts);
     }

    public Interaction getLastInteractionForUser(User user)
    {
       List result = getHibernateTemplate().find(" from Attendee i where i.userId = " + user.getId() + " order by userId" );
       if( result != null && result.size() > 0 )
       {
           Attendee attendee = (Attendee) result.get(result.size() - 1);
           user.setLastInteraction(attendee.getInteraction());
       }
       return user.getLastInteraction();
    }

    public int getPublicationCountForUser(User user)
    {
         StringBuffer queryB  = new StringBuffer("select a.myEntity from EntityAttribute a where a.parent in (").append(user.getKolid()).append(") and a.attribute = ").append(95);
         List result=getHibernateTemplate().find(queryB.toString());
         if ( result.size() == 0 ) user.setNumberOfPublication(0);

         long l = ((Entity)result.get(0)).getId();

         queryB  = new StringBuffer("select a.myEntity from EntityAttribute a where a.parent in (").append(l).append(") and a.attribute = ").append(96);
         result=getHibernateTemplate().find(queryB.toString());
         user.setNumberOfPublication(result.size());
         user.setPubCount(result.size());         
        return user.getNumberOfPublication();
    }

    public String getBio(User user) {
        EntityAttribute[] olSummary = getEntityAttributes(user.getKolid(), Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_SUMMARY")).getAttribute_id()+""));

        if (olSummary != null && olSummary.length > 0) {
            EntityAttribute olSum = olSummary[0];
            EntityAttribute[] summaryBio = null;


            summaryBio = getEntityAttributes(olSum.getMyEntity().getId(), 2l);
            if (summaryBio != null && summaryBio.length > 0) {
                for (int k = 0; k < summaryBio.length; k++) {
                    EntityAttribute ea = summaryBio[k];

                    StringAttribute[] attributes = getStringAttribute(ea
                            .getMyEntity());
                    for (int l = 0; l < attributes.length; l++) {
                        if (attributes[l].getAttribute().getAttribute_id() == 3l) {
                        	return attributes[l].getValue();
                        }
                    }
                }
            }
        }
        
        return "";
    }
    
    public ArrayList getTAForOL(User ol) {
        EntityAttribute[] olSummary = getEntityAttributes(ol.getKolid(), Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_SUMMARY")).getAttribute_id()+""));
        ArrayList taList = new ArrayList();
        
        if (olSummary != null && olSummary.length > 0) {
            EntityAttribute olSum = olSummary[0];
            EntityAttribute[] classificationAtt = null;
            
            long classificationAttID = Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("EXPERT_CLASSIFICATION")).getAttribute_id()+"");
            long taAttID = Long.parseLong(getAttributeIdFromName(PropertyReader.getEavConstantValueFor("THERAPEUTIC_AREA")).getAttribute_id()+"");
            
            classificationAtt = getEntityAttributes(olSum.getMyEntity().getId(), classificationAttID);
            if (classificationAtt != null && classificationAtt.length > 0) {
            	
            	HashMap map = new HashMap();
                for (int k = 0; k < classificationAtt.length; k++) {
                    EntityAttribute ea = classificationAtt[k];
                    
                    StringAttribute ta = getStringAttribute(ea.getMyEntity().getId(), taAttID);
                    if(ta != null) {
                    	map.put(classificationAtt[k], ta);
                    }
                }
                
                Iterator iter = map.values().iterator();
                while(iter.hasNext()) {                	
                	StringAttribute strAtt = (StringAttribute) iter.next();
                	taList.add(strAtt.getValue());
                }
            }
        }
        
        return taList;
    }


	public long createEntityIfRequired(long entityId, long attrId, long parentId) {
        if (entityId > 0)
            return entityId;
        if (entityId < 0 && attrId > 0 && parentId >0) {
            // create the child entity
            logger.debug("createEntityIfRequired is creating a new Entity");
        	EntityAttribute ea = new EntityAttribute();
            ea.setParent(getEntity(parentId));
            saveEntityAttribute(ea, metadataService.getAttributeType(attrId));
            return ea.getMyEntity().getId();
        }
        return entityId;
      }

     public void setUserFields(User user)
     {
         getLastInteractionForUser(user);
         getPublicationCountForUser(user);
         user.setUserLocation(getUserLocation(user));
         user.setBioData(getBio(user));
     }

     public User setUserFields1(long kolId)
     {
         User user = null;
         List results = getHibernateTemplate().find("from User u where u.deleteFlag ='N' AND u.kolid = " + kolId);
         if(results.size() != 0)
         {
             user = (User) results.get(0);
             getCustomAttributesForOl(user);
             List result2 = getHibernateTemplate().find("from HomeUserPhoneView u where u.kolId = " + user.getKolid());
             Iterator it = result2.iterator();
             while ( it.hasNext() )
             {
                 HomeUserPhoneView homeUserPhoneView = (HomeUserPhoneView) it.next();
                 if ( "phone".equalsIgnoreCase(homeUserPhoneView.getType()) )
                     user.setPhone(homeUserPhoneView.getPhone());
                 else if( ("email").equalsIgnoreCase(homeUserPhoneView.getPhone()) )
                    user.setEmail(homeUserPhoneView.getPhone());
                 else if( ("fax").equalsIgnoreCase(homeUserPhoneView.getPhone()) )
                     user.setFax(homeUserPhoneView.getPhone());
             }
             // get the Clinical Area of Interests
             StringBuffer sb = new StringBuffer("select b.value from User a, StringAttribute b, EntityAttribute j,  EntityAttribute k");
             sb.append(" where a.deleteFlag = 'N' and a.userType = 4 and j.parent = a.kolid and a.kolid=").append(user.getKolid());
             sb.append(" and j.attribute = 1 and k.attribute = 2 and b.attribute = 5 and b.parent = k.myEntity and k.parent = j.myEntity");
             result2 = getHibernateTemplate().find(sb.toString());
             if ( result2.size() > 0 )
             user.setAreaOfInterest((String)result2.get(0));

             // get the Address Attributes:
             sb = new StringBuffer("from User a, StringAttribute b, EntityAttribute j,  EntityAttribute k");
             sb.append(" where a.deleteFlag = 'N' and a.userType = 4 and j.parent = a.kolid and a.kolid=").append(user.getKolid());
             sb.append(" and j.attribute = 1 and k.attribute = 34 and b.attribute in (36,37,38,39,40,41,42) ");
             sb.append(" and b.parent = k.myEntity and k.parent = j.myEntity  order by b.parent, b.attribute");
             result2 = getHibernateTemplate().find(sb.toString());
             it = result2.iterator();
             int i = 0;
             while ( it.hasNext())
             {
                 StringAttribute sa =  (StringAttribute) ((Object []) it.next())[1];
                 long id = sa.getAttribute().getAttribute_id();
                 i = (int) id;
                 String s = sa.getValue();
                 switch  (i) {
                     case 36: user.setAddUse(s); i++; break;
                     case 37: user.setAddLine1(s); i++; break;
                     case 38: user.setAddLine2(s); i++; break;
                     case 39: user.setAddCity(s); i++; break;
                     case 40: user.setAddState(s); i++; break;
                     case 41: user.setAddZip(s); i++; break;
                     case 42: user.setAddCountry(s); i++; break;
                 }
             }
         }
         return user;
     }

}
