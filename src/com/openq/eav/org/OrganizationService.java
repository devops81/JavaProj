package com.openq.eav.org;

import java.util.*;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.data.Entity;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.utils.PropertyReader;
import com.openq.web.controllers.Constants;

public class OrganizationService extends HibernateDaoSupport implements IOrganizationService {
    public static final long orgProfileAttrId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_PROFILE"));
	public static final long nameAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_NAME"));
    public static final long acronymAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_ACRONYM"));
    public static final long typeAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_TYPE"));
    public static final long countryAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_COUNTRY"));
    public static final long stateAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_STATE"));
    public static final long majorSegmentAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_MAJOR_SEGMENT"));
    public static final long minorSegmentAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_MINOR_SEGMENT"));
   public static final long cityAttributeId = Long.parseLong(PropertyReader.getEavConstantValueFor("ORG_CITY"));
   

    IOptionService optionService;

    public IOptionService getOptionService() {
        return optionService;
    }

    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }

    public Organization[] searchOrganizationsAdv(HashMap parameters,long userGroupId) {

        ArrayList results = new ArrayList();
        
        String key = null;
        String value = null;
        StringBuffer query = new StringBuffer();
        StringBuffer query1 = new StringBuffer();
        StringBuffer query2 = new StringBuffer();
        int counter = 0;
        StringAttribute[] attributes = null;
        OptionLookup lookup = null;
        HashSet uniqueMatches = new HashSet();
        HashSet finalSet = new HashSet();
        

        if (parameters != null && parameters.size() > 0) {
            int count = 0;
            Set keys = parameters.keySet();
            Iterator itr = keys.iterator();
            while (itr.hasNext()) {
                key = (String) itr.next();
                value = (String) parameters.get(key);
                if (Long.parseLong(key) != nameAttributeId && Long.parseLong(key) != acronymAttributeId) {
                    lookup = optionService.getOptionLookup(Long.parseLong(value), userGroupId);
                }
                if (counter > 0) {
                    query1.append(", StringAttribute sa" + counter);
                    if (Long.parseLong(key) != nameAttributeId && Long.parseLong(key) != acronymAttributeId) {
                        query.append(" and upper(sa" + counter + ".value) like upper('" + lookup.getOptValue() + "') and sa" + counter + ".attribute=" + key);
                    } else {
                        query.append(" and upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
                    }
                    count = counter;
                    count--;
                    query2.append(" and sa" + count + ".parent=" + "sa" + counter + ".parent");
                } else {
                    query1.append("from StringAttribute sa" + counter);
                    if (Long.parseLong(key) != nameAttributeId && Long.parseLong(key) != acronymAttributeId) {
                        query.append(" where upper(sa" + counter + ".value) like upper('" + lookup.getOptValue() + "') and sa" + counter + ".attribute=" + key);
                    } else {
                        query.append(" where upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
                    }
                }
                counter++;
            }
        } else {
            query1 = new StringBuffer();
            query1.append("from StringAttribute sa order by sa.parent");
        }
        if (query1.length() > 0) {
            String searchQuery = query1.append(query).append(query2).toString();
            List matches = getHibernateTemplate().find(searchQuery);
            if (parameters.size() > 1) {
                List attList = new ArrayList();
                Object[] obj = null;
                for (int j = 0; j < matches.size(); j++) {
                    obj = (Object[]) matches.get(j);
                    if (obj != null && obj.length > 0) {
                        for (int o = 0; o < obj.length; o++) {
                            attList.add(obj[o]);
                        }
                    }
                }
                attributes = (StringAttribute[]) attList.toArray(new StringAttribute[matches.size()]);
            } else if(parameters.size() == 1){
                attributes = (StringAttribute[]) matches.toArray(new StringAttribute[matches.size()]);
            } else {
                attributes = (StringAttribute[]) matches.toArray(new StringAttribute[matches.size()]);

                if(attributes != null && attributes.length>0) {
                    HashSet resultSet = new HashSet();
                    for(int a=0;a<attributes.length;a++) {
                        resultSet = parseParents(dataService.getEntity(attributes[a].getParent().getId()),
                                attributes[a].getParent().getId(),resultSet);
                        finalSet.addAll(resultSet);
                    }


                    if(finalSet != null && !finalSet.isEmpty() && finalSet.size() <= 1000) {
                        String parentList = null;
                        Iterator iterator = finalSet.iterator();
                        while(iterator.hasNext()) {
                            if(parentList != null) {
                                parentList += ", " + iterator.next();
                            } else {
                                parentList = (String) iterator.next();
                            }
                        }
                        iterateData(parentList,results);

                    } else if(finalSet != null && !finalSet.isEmpty() && finalSet.size() > 1000) {
                        String parentList = null;
                        Iterator iterator = finalSet.iterator();
                        int countItr = 0;
                        while(iterator.hasNext()) {
                            if(parentList != null) {
                                parentList += ", " + iterator.next();
                            } else {
                                parentList = (String) iterator.next();
                            }
                            countItr++;
                            if(countItr == 1000) {
                                iterateData(parentList,results);
                                parentList = null;
                                countItr = 0;
                            }
                        }
                        if(countItr < 1000) {
                            iterateData(parentList,results);
                        }
                    }
                }
            }
            if (parameters.size() >= 1) {
                for (int i = 0; i < attributes.length; i++) {
                    if (!uniqueMatches.contains(attributes[i].getParent().getId() + "")) {
                        uniqueMatches.add(attributes[i].getParent().getId() + "");
                        Organization org = new Organization();
                        populateAttr(attributes, results, i, org);
                    }
                }
            }
        }
        return (Organization []) results.toArray(new Organization[results.size()]);
    }

    private void iterateData(String parentList,ArrayList results) {
        StringBuffer query1 = new StringBuffer();
        
        query1.append("from StringAttribute sa where sa.parent in(" + parentList + ") order by sa.parent");
        List matches = getHibernateTemplate().find(query1.toString());
        StringAttribute[] attributes = (StringAttribute[]) matches.toArray(new StringAttribute[matches.size()]);
        if (attributes != null && attributes.length > 0) {
            StringAttribute stringAttr = null;
            Organization organization = null;
            long tmpId = 0;
            for (int s = 0; s < attributes.length; s++) {
                stringAttr = attributes[s];

                if (stringAttr.getParent().getId() == tmpId && organization != null) {
                    if (stringAttr.getAttribute().getAttribute_id() == nameAttributeId) {
                        organization.setName(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == acronymAttributeId) {
                        organization.setAcronym(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == countryAttributeId) {
                        organization.setCountry(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == typeAttributeId) {
                        organization.setType(stringAttr.getValue());
                    }else if(stringAttr.getAttribute().getAttribute_id() == stateAttributeId){
                        organization.setState(stringAttr.getValue());
                    }else if(stringAttr.getAttribute().getAttribute_id() == cityAttributeId){
                        organization.setCity(stringAttr.getValue());
                    }
                } else {
                    if (organization != null) {
                        results.add(organization);
                    }
                    organization = new Organization();
                    if (stringAttr.getAttribute().getAttribute_id() == nameAttributeId) {
                        organization.setName(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == acronymAttributeId) {
                        organization.setAcronym(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == countryAttributeId) {
                        organization.setCountry(stringAttr.getValue());
                    } else if (stringAttr.getAttribute().getAttribute_id() == typeAttributeId) {
                        organization.setType(stringAttr.getValue());
                    }else if(stringAttr.getAttribute().getAttribute_id() == stateAttributeId){
                        organization.setState(stringAttr.getValue());
                    }else if(stringAttr.getAttribute().getAttribute_id() == cityAttributeId){
                        organization.setCity(stringAttr.getValue());
                    }
                    EntityAttribute [] ea = dataService.getEntityAttributes(stringAttr.getParent().getId());
                    if (dataService.getEntityAttributes(stringAttr.getParent().getId()) != null && dataService.getEntityAttributes(stringAttr.getParent().getId()).length > 0)
                    {
                        organization.setEntityId(ea[0].getParent().getId());
                    }
                }
                tmpId = stringAttr.getParent().getId();
            }
        }
    }
    private HashSet parseParents(Entity entity, long entityId, HashSet results) {
        EntityAttribute entityAttribute[] = null;
        EntityAttribute entityAtt = null;
        Entity newEntity = null;
        if (entity.getType().getEntity_type_id() != 124) { // 124 is organization profile in entitytypes table
            entityAttribute = dataService.getEntityAttributes(entityId);
            if (entityAttribute != null && entityAttribute.length > 0) {
                for (int i = 0; i < entityAttribute.length; i++) {
                    entityAtt = entityAttribute[i];
                    newEntity = dataService.getEntity(entityAtt.getParent().getId());
                    parseParents(newEntity, entityAtt.getParent().getId(), results);
                }
            }
        } else {
            if (results != null && !results.contains(entityId + "")) {
                results.add(entityId + "");
            }
        }
        return results;
    }
    private void populateAttr(StringAttribute[] attributes, ArrayList results, int i, Organization org) {
    	
    	StringAttribute tempOrgName = dataService.getAttribute(attributes[i].getParent().getId(), nameAttributeId);
        if(tempOrgName != null) {
            org.setName(tempOrgName.getValue());
        }
        StringAttribute tempOrgAcronym = dataService.getAttribute(attributes[i].getParent().getId(), acronymAttributeId);
        if(tempOrgAcronym != null) {
            org.setAcronym(tempOrgAcronym.getValue());
        }
        StringAttribute tempOrgAttrId = dataService.getAttribute(attributes[i].getParent().getId(), typeAttributeId);
        if(tempOrgAttrId != null) {
            org.setType(tempOrgAttrId.getValue());
        }
        StringAttribute tempOrgCountryId = dataService.getAttribute(attributes[i].getParent().getId(), countryAttributeId);
        if(tempOrgCountryId != null) {
            org.setCountry(tempOrgCountryId.getValue());
        }
        StringAttribute tempOrgStateId = dataService.getAttribute(attributes[i].getParent().getId(), stateAttributeId);
        if(tempOrgStateId != null) {
            org.setState(tempOrgStateId.getValue());
        }
        StringAttribute tempOrgCityId = dataService.getAttribute(attributes[i].getParent().getId(), cityAttributeId);
        if(tempOrgCityId != null) {
            org.setCity(tempOrgCityId.getValue());
        }
        EntityAttribute [] ea = dataService.getEntityAttributes(attributes[i].getParent().getId());
        if(dataService.getEntityAttributes(attributes[i].getParent().getId()) != null && dataService.getEntityAttributes(attributes[i].getParent().getId()).length>0) {
            org.setEntityId(ea[0].getParent().getId());
        }
        results.add(org);
    }

    public Organization[] searchOrganizations(String nameOrAcronym) {
        StringAttribute[] nameMatches = dataService.getMatchingAttributes(
                nameOrAcronym, nameAttributeId);
        StringAttribute[] acronymMatches = dataService.getMatchingAttributes(
                nameOrAcronym, acronymAttributeId);

        List resultList = getHibernateTemplate().find("from OrganizationView orgView where upper(orgView.name) like '%"+nameOrAcronym.toUpperCase()+"%' or"
        		+" upper(orgView.acronym) like '%"+nameOrAcronym.toUpperCase()+"%' order by lower(orgView.name), lower(orgView.acronym), lower(orgView.type), lower(orgView.city),lower(orgView.state),lower(orgView.country)");	
      if(resultList!=null&&resultList.size()>0)
      {
    	  List orgObjList = new ArrayList();
    	  for(int i=0;i<resultList.size();i++)
    	  {
    		  OrganizationView orgView = (OrganizationView)resultList.get(i);
    		  Organization organization = new Organization();
    		  organization.setEntityId(orgView.getId());
    		  organization.setName(orgView.getName());
    		  organization.setCity(orgView.getCity());
    		  organization.setState(orgView.getState());
    		  organization.setType(orgView.getType());
    		  organization.setCountry(orgView.getCountry());
    	      orgObjList.add(organization);
    	  }
        if(orgObjList.size()>0)
        	return (Organization []) orgObjList.toArray(new Organization[orgObjList.size()]);
      }  		
        /*// get the union of results
        ArrayList results = new ArrayList();
        HashSet uniqueMatches = new HashSet();
        for (int i = 0; i < nameMatches.length; i++) {
            uniqueMatches.add(nameMatches[i].getParent().getId() + "");
            Organization org = new Organization();
            org.setName(nameMatches[i].getValue());
            String acronym=null;
            if(dataService.getAttribute(nameMatches[i].getParent().getId(), acronymAttributeId)!=null) 
            	acronym = dataService.getAttribute(nameMatches[i].getParent().getId(), acronymAttributeId).getValue();
            if(acronym !=null){
                org.setAcronym(acronym);
            }else{
                org.setAcronym("");
            }
            String orgCity=null;
            String orgState=null;
            if(dataService.getAttribute(nameMatches[i].getParent().getId(), cityAttributeId)!=null)
            	orgCity = dataService.getAttribute(nameMatches[i].getParent().getId(), cityAttributeId).getValue();
            if(orgCity != null)
            	org.setCity(orgCity);
            else
            	org.setCity("");
            if(dataService.getAttribute(nameMatches[i].getParent().getId(), stateAttributeId )!=null)
            	orgState = dataService.getAttribute(nameMatches[i].getParent().getId(), stateAttributeId).getValue();
            if(orgState != null)
            	org.setState(orgState);
            else
            	org.setState("");
            
            fillOrgObject(nameMatches, results, i, org);
        }

        for (int k = 0; k < acronymMatches.length; k++) {
            if (!uniqueMatches.contains(acronymMatches[k].getParent().getId() + "")) {
                Organization org = new Organization();
                if(dataService.getAttribute(acronymMatches[k].getParent().getId(), nameAttributeId).getValue()!=null)
                org.setName(dataService.getAttribute(acronymMatches[k].getParent().getId(), nameAttributeId).getValue());
                String acronym = acronymMatches[k].getValue();
                if(acronym !=null){
                    org.setAcronym(acronym);
                }else{
                    org.setAcronym("");
                }
                String orgCity=null;
                String orgState=null;
                if(dataService.getAttribute(acronymMatches[k].getParent().getId(), cityAttributeId)!=null)
                	orgCity = dataService.getAttribute(acronymMatches[k].getParent().getId(), cityAttributeId).getValue();
                if(orgCity != null)
                	org.setCity(orgCity);
                else
                	org.setCity("");
                if(dataService.getAttribute(acronymMatches[k].getParent().getId(), stateAttributeId )!=null)
                	orgState = dataService.getAttribute(acronymMatches[k].getParent().getId(), stateAttributeId).getValue();
                if(orgState != null)
                	org.setState(orgState);
                else
                	org.setState("");
                
                fillOrgObject(acronymMatches, results, k, org);
            }
        }

        return (Organization []) results.toArray(new Organization[results.size()]);*/
    return null;
    }

    public Organization getOrganizationByid(long orgId) {
    	Organization org = new Organization();
    	if(orgId>0)
    	{
    		List results = getHibernateTemplate().find("From OrganizationView orgV where orgV.id="+orgId);
    	    if(results!=null&&results.size()>0)
    	    {
    	    	OrganizationView orgView = (OrganizationView)results.get(0);
    	        org.setEntityId(orgId);
    	    	org.setName(orgView.getName());
    	        org.setAcronym(orgView.getAcronym());
    	        org.setCity(orgView.getCity());
    	        org.setState(orgView.getState());
    	        org.setCountry(orgView.getCountry());
    	        org.setType(orgView.getType());
    	    }   
    	return org;
    	}
    	return null;
    }
    
    private void fillOrgObject(StringAttribute[] nameMatches, ArrayList results, int i, Organization org) {
    	if(dataService.getAttribute(nameMatches[i].getParent().getId(), typeAttributeId)!=null)
    		org.setType(dataService.getAttribute(nameMatches[i].getParent().getId(), typeAttributeId).getValue());
    	if(dataService.getAttribute(nameMatches[i].getParent().getId(), countryAttributeId)!=null)
    		org.setCountry(dataService.getAttribute(nameMatches[i].getParent().getId(), countryAttributeId).getValue());
        EntityAttribute [] ea = dataService.getEntityAttributes(nameMatches[i].getParent().getId());
        org.setEntityId(ea[0].getParent().getId());
        results.add(org);
    }


     public Organization[] getAllOrganizations() {

        List matches = getHibernateTemplate().find(
				"from StringAttribute sa where sa.attribute=" + nameAttributeId);
		StringAttribute[] nameMatches = (StringAttribute[]) matches.toArray(new StringAttribute[matches.size()]);

        ArrayList results = new ArrayList();
        HashSet uniqueMatches = new HashSet();
        for (int i = 0; i < nameMatches.length; i++) {
            uniqueMatches.add(nameMatches[i].getParent().getId() + "");
            Organization org = new Organization();
            org.setName(nameMatches[i].getValue());
            String acronym=null;
            if(dataService.getAttribute(nameMatches[i].getParent().getId(), acronymAttributeId)!=null)
            	acronym = dataService.getAttribute(nameMatches[i].getParent().getId(), acronymAttributeId).getValue();
            if(acronym !=null){
                org.setAcronym(acronym);
            }else{
                org.setAcronym("");
            }
            populateAttr(nameMatches, results, i, org);
        }
        return (Organization []) results.toArray(new Organization[results.size()]);
    }

    IDataService dataService;

    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

	
}
