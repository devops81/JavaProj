package com.openq.eav.scripts;

import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.EavConstants;
import com.openq.eav.audit.AuditInfo;
import com.openq.eav.audit.IAuditService;
import com.openq.eav.data.DateAttribute;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.org.OrgOlCma;

/*
 * Assumes a set of tables with data from which the OL data loader can 
 * load info into EAV data tables.
 */
public class EavDataLoader extends HibernateDaoSupport {
	public void saveTableRow(Entity parent, long attrId, HashMap attrValuesMap) {
		// create an entry into eav_attributes
		AttributeType at = metadataService.getAttributeType(attrId);
		EntityAttribute ea = new EntityAttribute();
		ea.setAttribute(at);
		ea.setParent(parent);
		dataService.saveEntityAttribute(ea, at);

		// parent of rows
		Entity rowEntity = ea.getMyEntity();
		saveAttributes(rowEntity, attrValuesMap);
	}
	
	public void saveorgolmap(OrgOlCma org)
	{
		getHibernateTemplate().update(org);
	}
	

	public void saveAttributes(Entity parent, HashMap attrValuesMap) {
		Set keys = attrValuesMap.keySet();
		Iterator itar = keys.iterator();
		while (itar.hasNext()) {
			String attrIdString = (String) itar.next();
			AttributeType attrType = metadataService.getAttributeType((new Long(attrIdString)).longValue());
			if (attrType.getType() == EavConstants.STRING_ID || attrType.getType() == EavConstants.DROPDOWN_ID) {
				//System.out.println("Saving attribute =" + attrType.getName() + ", value=" + attrValuesMap.get(attrIdString));
				dataService.saveStringAttribute(attrType, parent, (String) attrValuesMap.get(attrIdString));
			} else if (attrType.getType() == EavConstants.BOOLEAN_ID) {
				// System.out.println("Saving attribute =" + attrType.getName() + ", value=" + attrValuesMap.get(attrIdString));
				dataService.saveBooleanAttribute(attrType, parent, new Boolean((String) attrValuesMap.get(attrIdString)));
			} else if (attrType.getType() == EavConstants.DATE_ID) {
				//System.out.println("Saving attribute =" + attrType.getName() + ", value=" + attrValuesMap.get(attrIdString));
				//System.out.println("WARNING: Date attribute found. Might have issues supporting it.");
				Date d = new Date(Integer.parseInt(((String) attrValuesMap.get(attrIdString))), 1, 1);
				//d.setYear();
				dataService.saveDateAttribute(attrType, parent, d);
			} else if (attrType.getType() == EavConstants.NUMBER_ID || attrType.getType() == EavConstants.MULTI_SELECT_ID) {
				System.out.println("Saving attribute =" + attrType.getName() + ", value=" + attrValuesMap.get(attrIdString));
				System.out.println("WARNING: Number or multi-select attribute found. Might have issues supporting it.");
			}
		}
		
		// save audit info
		AuditInfo info = new AuditInfo();
		info.setUserName("LMI");
		try {
			info.setUpdateTime(DateAttribute.formatter.parse("12/30/2006"));
		} catch (Exception e) {
			e.printStackTrace();
			info.setUpdateTime(Calendar.getInstance().getTime());
		}
		info.setEditedEntityId(parent.getId());
		auditService.saveAuditInfo(info);
	}
	
	IMetadataService metadataService;
	IDataService dataService;
	IAuditService auditService;
	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public IAuditService getAuditService() {
		return auditService;
	}

	public void setAuditService(IAuditService auditService) {
		this.auditService = auditService;
	}
}
