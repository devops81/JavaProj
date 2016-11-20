package com.openq.eav.entitySearch;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.contacts.Contacts;
import com.openq.eav.data.Entity;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.org.Organization;
import com.openq.eav.org.OrganizationView;
import com.openq.eav.trials.ClinicalTrials;
import com.openq.eav.trials.ITrialService;
import com.openq.kol.DBUtil;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.MutableInteger;
import com.openq.utils.SqlAndHqlUtilFunctions;
import com.openq.web.controllers.Constants;

/**
 * Created by IntelliJ IDEA. User: Lenovo Date: Oct 19, 2007 Time: 1:33:17 PM To
 * change this template use File | Settings | File Templates.
 */

public class EntitySearchService extends HibernateDaoSupport implements
IEntitySearchService {

    private static Logger logger = Logger.getLogger(EntitySearchService.class);

    IDataService dataService;

    IOrganizationService orgService;

    ITrialService trialService;

    IMetadataService metadataService;

    IUserService userService;

    IFeaturePermissionService featureSearchPermissionService;
    private static final long ORG_NAME_ATTR_ID = 12l;

    private static final long TRIAL_NAME_ATTR_ID = 15l;

    public static final String EXPERTS = "Experts";

    public static final String ORGS = "Orgs";

    public static final String TRIALS = "Trials";

    public static final String EXPERTS_STATS = "Experts_Stats";

    public static final String ORGS_STATS = "Orgs_Stats";

    public static final String TRIALS_STATS = "Trials_Stats";

    public static LinkedHashMap attribStats = new LinkedHashMap();

    public static boolean hasAdded = false;
    public IMetadataService getMetadataService() {
        return metadataService;
    }

    public void setMetadataService(IMetadataService metadataService) {
        this.metadataService = metadataService;
    }
    
    public LinkedHashMap getExpertsSerachResultSet(String keyword, long userGroupId)
    {
        final String PERMISSION_APPEND_QUERY = featureSearchPermissionService.getPermissionAppendQuery(Constants.SEARCH_ATTRIBUTES_PERMISSION_ID, userGroupId);
            //to prevent crashes owing to invalid characters in keyword use positional binding
        List result = getHibernateTemplate()
                .find(
                                "from StringAttribute D where "
                                +"D.rootEntityType=101 and lower(D.value) like ? and D.attribute "+PERMISSION_APPEND_QUERY +"", "%"+keyword.toLowerCase()+"%");
        Object strObj = null;
        Iterator iterator = result.iterator();
        LinkedHashMap userIdAttributeMatchMap = new LinkedHashMap();
        LinkedHashMap userAttributeMatchMap = new LinkedHashMap();
        Set kolIdSet = new HashSet();
        while (iterator.hasNext()) {
            strObj = (Object) iterator.next();
            StringAttribute attributeObject = ((StringAttribute) (strObj));
            AttributeType attributeType = attributeObject.getAttribute();
            Long userId = new Long(attributeObject.getRootEntityId());//(User) (objArr[1]);
            //dataService.setUserFields(u);
            kolIdSet.add(userId);
            Set matchedAttributeSet = (Set) userIdAttributeMatchMap.get(userId);
            if (matchedAttributeSet == null) {
                userIdAttributeMatchMap.put(userId, new HashSet());
                matchedAttributeSet = (Set) userIdAttributeMatchMap.get(userId);
            }
            matchedAttributeSet.add(attributeType.getName());
        }
       if(kolIdSet.size()>0)
       {
            String[] inClauseTokenStrings=SqlAndHqlUtilFunctions.constructInClauseForQuery(kolIdSet);
            StringBuffer query = new StringBuffer("from User u where u.deleteFlag = 'N' and ");
           for (int i = 0; i < inClauseTokenStrings.length; i++) {
              query.append("( u.kolid in (" + inClauseTokenStrings[i] + " )) OR");
          }
          query.delete(query.length() - 2, query.length());
          query.append(" order by lower(u.lastName), lower(u.firstName)");
          
            logger.debug("Query involving in clause: " + query.toString());
            List result1 = getHibernateTemplate().find(query.toString());
            if (result1 != null && result1.size() > 0) {
                Set set = new HashSet();
                List toReturn = new ArrayList();
                for (int i = 0; i < result1.size(); i++) {
                    long id = ((User) result1.get(i)).getId();
                    if (set.add(new Long(id)) == true) {
                        {
                            User user = ((User)result1.get(i));
                            Set matchedAttributeSet = (Set)userIdAttributeMatchMap.get(new Long(user.getKolid()));
                            userAttributeMatchMap.put(user, matchedAttributeSet);
                            //toReturn.add((User) result1.get(i));
                        }
                    }
                }
        }
      } 
       System.out.println("Returning results\n");
      return userAttributeMatchMap;

        
    }
    public LinkedHashMap fetchKOLMap(LinkedHashMap ExpertResultMap, MutableInteger startSearchIndex,MutableInteger stopSearchIndex) {
        LinkedHashMap entitiesMap = new LinkedHashMap();

        Map expertAttribStats = new LinkedHashMap();
        Map expertSearchResults = fetchExperts(ExpertResultMap, startSearchIndex,expertAttribStats);
        entitiesMap.put(EXPERTS, expertSearchResults);
        entitiesMap.put(EXPERTS_STATS, expertAttribStats);

    /*  Map orgAttribStats = new LinkedHashMap();
        Map orgSearchResults = getOrgResults(keyword, orgAttribStats);
        entitiesMap.put(ORGS, orgSearchResults);
        entitiesMap.put(ORGS_STATS, orgAttribStats);
*/
        /*Map trialAttribStats = new LinkedHashMap();
        if (eavTrial != "false") {
            Map trialSearchResults = getTrialResults(keyword, trialAttribStats);
            entitiesMap.put(TRIALS, trialSearchResults);
            entitiesMap.put(TRIALS_STATS, trialAttribStats);
        }
*/
        return entitiesMap;
    }
    public LinkedHashMap fetchORGMap(LinkedHashMap ResultAttributeMatchMap, MutableInteger startSearchIndex)
    {
        LinkedHashMap entitiesMap = new LinkedHashMap();
        Map orgAttribStats = new LinkedHashMap();
        Map orgSearchResults = fetchOrgResults(ResultAttributeMatchMap,startSearchIndex, orgAttribStats);
        entitiesMap.put(ORGS, orgSearchResults);
        entitiesMap.put(ORGS_STATS, orgAttribStats);
        return entitiesMap;
    }
    public LinkedHashMap fetchOrgResults(Map ResultAttributeMatchMap, MutableInteger startSearchIndex, Map attributeStats)
    {
        LinkedHashMap userAttributeMatchMap = new LinkedHashMap();
        Set expertKeySet= ResultAttributeMatchMap.keySet();
        Iterator iterator = expertKeySet.iterator();
        for(int j=0;j<startSearchIndex.getNumber();j++)
        {
            if(iterator.hasNext())
            iterator.next();
        }
        //Entity entity;
        String entityIdString = "";
        long entityId=0;
        int count=0;
        Set orgIdSet = new HashSet();
        java.util.Properties maxUser = DBUtil.getInstance().featuresProp;
        if(maxUser!=null && maxUser.getProperty("MAX_NUM_USERS_PER_PAGE")!=null)
        {   
            int maxUserPerPage= Integer.parseInt(maxUser.getProperty("MAX_NUM_USERS_PER_PAGE"));
            while (iterator.hasNext() && count<maxUserPerPage) 
            {
                count++;
                //stopSearchIndex.increment();
            entityIdString = (String) iterator.next();
            if(entityIdString!=null&&!"".equals(entityIdString))
            {
                try
                {
                    entityId = Long.parseLong(entityIdString.trim());
                }
                catch (Exception e) {
                    // TODO: handle exception
                logger.error("Number Format execption parsing organization's parent entity");
                }
                Long orgEntityId = new Long(entityId);
                orgIdSet.add(orgEntityId);  
                    
            }
        }
        if(orgIdSet.size()>0)
        {
            System.out.println("orgIdSet size"+orgIdSet.size());
            String[] inClauseTokenStrings=SqlAndHqlUtilFunctions.constructInClauseForQuery(orgIdSet);
            StringBuffer query = new StringBuffer("from OrganizationView u where");
         for (int i = 0; i < inClauseTokenStrings.length; i++) {
              query.append("( u.id in (" + inClauseTokenStrings[i] + " )) OR");
            }
            query.delete(query.length() - 2, query.length());
            query.append(" order by lower(u.name)");
            logger.debug("Query involving in clause: " + query.toString());
            List result1 = getHibernateTemplate().find(query.toString());
            if (result1 != null && result1.size() > 0) {
                Set set = new HashSet();
                List toReturn = new ArrayList();
                for (int i = 0; i < result1.size(); i++) {
                    long id = ((OrganizationView) result1.get(i)).getId();
                    if (set.add(new Long(id)) == true) {
                        {
                            OrganizationView orgView = ((OrganizationView)result1.get(i));
                            Organization organization = new Organization();
                            organization.setEntityId(orgView.getId());
                            organization.setName(orgView.getName());
                            organization.setAcronym(orgView.getAcronym());
                            organization.setCity(orgView.getCity());
                            organization.setCountry(orgView.getCountry());
                            organization.setState(orgView.getState());
                            organization.setType(orgView.getType());
                            userAttributeMatchMap.put(organization, new HashSet((Set)(ResultAttributeMatchMap.get(orgView.getId()+""))));
                            
                        }
                    }
                }
           }   
            
        }
        
        /*Organization organization = orgService.getOrganizationByid(entityId);
        userAttributeMatchMap.put(organization, new HashSet((Set)(ResultAttributeMatchMap.get(entityIdString))));
        */// Update stats
        Set attributeSet= (Set)ResultAttributeMatchMap.get(entityIdString);
        Iterator attributeIterator= attributeSet.iterator();
        
        while(attributeIterator.hasNext())
        {
            String attributeName = (String) attributeIterator.next();
            if (attributeStats.containsKey(attributeName)) {
                attributeStats.put(attributeName, new Integer(
                        ((Integer) attributeStats.get(attributeName))
                        .intValue() + 1));
            } else {
                attributeStats.put(attributeName, new Integer(1));
            }
        }
        }
        return userAttributeMatchMap;
    }

    public LinkedHashMap fetchExperts(LinkedHashMap ExpertResultMap,MutableInteger startSearchIndex,Map attributeStats)
    {
        LinkedHashMap userAttributeMatchMap = new LinkedHashMap();
        Set expertKeySet= ExpertResultMap.keySet();
        Iterator iterator = expertKeySet.iterator();
        for(int j=0;j<startSearchIndex.getNumber();j++)
        {
            if(iterator.hasNext())
            iterator.next();
        }
        User user = new User();
        int count=0;
        java.util.Properties maxUser = DBUtil.getInstance().featuresProp;
        if(maxUser!=null && maxUser.getProperty("MAX_NUM_USERS_PER_PAGE")!=null)
        {   
            int maxUserPerPage= Integer.parseInt(maxUser.getProperty("MAX_NUM_USERS_PER_PAGE"));
            while (iterator.hasNext() && count<maxUserPerPage) 
            {
                count++;
                //stopSearchIndex.increment();
                user = (User) iterator.next();
                 // from every user set various fileds like interaction, publication count, user location, biodata etc.
                dataService.setUserFields(user);
                userAttributeMatchMap.put(user, new HashSet((Set)(ExpertResultMap.get(user))));
                
                // Update stats
                Set attributeSet= (Set)ExpertResultMap.get(user);
                if(attributeSet!=null)
                {
                    Iterator attributeIterator= attributeSet.iterator();
                    while(attributeIterator.hasNext())
                    {
                        String attributeName = (String) attributeIterator.next();
                        
                        if (attributeStats.containsKey(attributeName)) {
                            attributeStats.put(attributeName, new Integer(
                                    ((Integer) attributeStats.get(attributeName))
                                    .intValue() + 1));
                        } else {
                            attributeStats.put(attributeName, new Integer(1));
                        }
                    }
                }
                else
                    System.out.println("Attributestats returned a null set\n");
                
            }
        }
        
        
        return userAttributeMatchMap;
    }
    
    public LinkedHashMap getOrgSerachResultSet(String keyword) 
    {

        //to prevent crashes owing to invalid characters in keyword use positional binding
        List result = getHibernateTemplate()
            .find(
                            "from StringAttribute A, StringAttribute B where "
                            + "upper(A.value) like ? "
                            + " and A.rootEntityType=12 and B.rootEntityId=A.rootEntityId and B.attribute.id=118 order by" +
                                    " upper(B.value)", "%"+keyword.toUpperCase()+"%");

        
        LinkedHashMap ResultAttributeMatchMap = new LinkedHashMap();
        if(result!=null&&result.size()>0)
        {
            Object objArr[] = null;
            Iterator iterator = result.iterator();
            while(iterator.hasNext())
            {
                objArr=(Object[])iterator.next();
                StringAttribute attributeType1=(StringAttribute)objArr[0];
                String attributeName = attributeType1.getAttribute().getName();
                Set matchedAttributeSet = (Set) ResultAttributeMatchMap.get(attributeType1.getRootEntityId()+"");
                if (matchedAttributeSet == null) 
                {
                    ResultAttributeMatchMap.put(attributeType1.getRootEntityId()+"", new HashSet());
                    matchedAttributeSet = (Set) ResultAttributeMatchMap.get(attributeType1.getRootEntityId()+"");
                }
                matchedAttributeSet.add(attributeName);
            }
        }
        return ResultAttributeMatchMap;
    }
    
    public LinkedHashMap getTrialResults(String keyword, Map attributeStats) {

        List result = getHibernateTemplate()
        .find(
                "from StringAttribute A, EntityAttribute B, Entity C where "
                + "upper(A.value) like upper('%"
                + keyword
                + "%')"
                + " and A.parent=B.myEntity and B.parent=C.id and C.type="
                + TRIAL_NAME_ATTR_ID);

        Object objArr[] = null;
        Iterator iterator = result.iterator();
        LinkedHashMap trialAttributeMatchMap = new LinkedHashMap();
        while (iterator.hasNext()) {

            objArr = (Object[]) iterator.next();
            Entity entity = (Entity) (objArr[2]);
            StringAttribute attributeType1 = (StringAttribute) (objArr[0]);

            ClinicalTrials clinicalTrials = trialService.getTrialWithId(entity
                    .getId());
            String attributeName = attributeType1.getAttribute().getName();

            Set matchedAttributeSet = (Set) trialAttributeMatchMap
            .get(clinicalTrials);
            if (matchedAttributeSet == null) {
                trialAttributeMatchMap.put(clinicalTrials, new HashSet());
                matchedAttributeSet = (Set) trialAttributeMatchMap
                .get(clinicalTrials);
            }
            matchedAttributeSet.add(attributeName);

            // Update stats
            if (attributeStats.containsKey(attributeName)) {
                attributeStats.put(attributeName, new Integer(
                        ((Integer) attributeStats.get(attributeName))
                        .intValue() + 1));
            } else {
                attributeStats.put(attributeName, new Integer(1));
            }
        }

        return trialAttributeMatchMap;
    }

    /**
     * This method returns all searchable attributes for a given entity
     * 
     * @param
     */
    public List getSearchableAttributesForEntity(long entityTypeId,long userGroupId) {

        List attributeList = new ArrayList();
        Set restrictedAttributes = featureSearchPermissionService.getRestrictedAttributes(Constants.SEARCH_ATTRIBUTES_PERMISSION_ID, userGroupId);
        attributeList = getSearchableAttributesForEntity(entityTypeId,
                attributeList,userGroupId,restrictedAttributes);
        if (attributeList != null && !attributeList.isEmpty()) {
            Collections.sort(attributeList, new java.util.Comparator() {
                public int compare(Object o1, Object o2) {
                    AttributeType dto1 = (AttributeType) o1;
                    AttributeType dto2 = (AttributeType) o2;
                    return dto1.getDescription().toUpperCase().compareTo(
                            dto2.getDescription().toUpperCase());
                }
            });
        }

        return attributeList;
    }

    private List getSearchableAttributesForEntity(long entityTypeId,
            List attributeList,long userGroupId,Set restrictedAttributes) {
        AttributeType[] attributes = metadataService
        .getAllShowableAttributes(entityTypeId);
        if (attributes != null && attributes.length > 0) {
            for (int i = 0; i < attributes.length; i++) {
                if (attributes[i].isEntity()) {
                    attributeList = getSearchableAttributesForEntity(
                            attributes[i].getType(), attributeList,userGroupId,restrictedAttributes);
                } else {

                    if (attributes[i].isSearchable()
                            && (attributes[i].getType() == 1||attributes[i].getType()==5))
                        {
                         if(restrictedAttributes!=null&&restrictedAttributes.size()>0)
                         {
                             if(!restrictedAttributes.contains(attributes[i].getAttribute_id()+""))
                             {
                                 attributeList.add(attributes[i]);
                             }
                         }
                         else
                             attributeList.add(attributes[i]);
                        }

                }

            }
        }

        return attributeList;
    }
    /**
     * This method returns the Experts based on the attribute , value pair
     * 
     * @param attributeKeyword
     *            value map
     * @return A Map of Users and Attribute matches.
     */
    public Map getResultMap(Map attrKeywordMap)
    {       String searchParam = "and";
    boolean andSearch = true;
    boolean hasAdded = false;
    if(attrKeywordMap.get("searchParam")!=null)
    {
        searchParam = (String) attrKeywordMap.get("searchParam");//The search parameter AND/OR      
        attrKeywordMap.remove("searchParam");
        if(searchParam.equalsIgnoreCase("or"))
        {
            andSearch = false;
            searchParam = "or";
        }
    }
    Set expertIdSet = new HashSet();
    Map expertIdAttrMatchMap = new LinkedHashMap();
    Map expertAttrMatchMap = new LinkedHashMap();
    if (attrKeywordMap.get("contacts(Firstname)")!=null)
    {
     Set keyWordSet = (Set) attrKeywordMap.get("contacts(Firstname)");
     Iterator iterator = keyWordSet.iterator();
     String firstname="firstname";
     while(iterator.hasNext())
     {
         String name = (String)iterator.next(); 
         Set contactsSet = getExpertsForContact(name,expertIdAttrMatchMap,firstname);   
         if((contactsSet==null||contactsSet.size()<1)&&andSearch)
             return new LinkedHashMap();//No results came up. End search
         expertIdSet = processKolsSet(expertIdSet,contactsSet,hasAdded,andSearch);
     }
     hasAdded=true;
    attrKeywordMap.remove("contacts(Firstname)");
    }
    
    if (attrKeywordMap.get("contacts(Lastname)")!=null)
    {
     Set keyWordSet = (Set) attrKeywordMap.get("contacts(Lastname)");
     Iterator iterator = keyWordSet.iterator();
     String lastname="lastname";
     while(iterator.hasNext())
     {
         String name = (String)iterator.next(); 
         Set contactsSet = getExpertsForContact(name,expertIdAttrMatchMap,lastname); 
         if((contactsSet==null||contactsSet.size()<1)&&andSearch)
             return new LinkedHashMap();//No results came up. End search
         expertIdSet = processKolsSet(expertIdSet,contactsSet,hasAdded,andSearch);
     }
     hasAdded=true;
    attrKeywordMap.remove("contacts(Lastname)");
    }
    
    if(attrKeywordMap.get("org")!=null)
    {
        Set keyWordSet = (Set) attrKeywordMap.get("org");
         Iterator iterator = keyWordSet.iterator();
         StringBuffer query = new StringBuffer("from StringAttribute u where (u.attribute ="+119+" or u.attribute="+118+") and");
         while(iterator.hasNext())
         {
             String name = (String)iterator.next(); 
             query.append("( lower(u.value) like '%"+name.toLowerCase()+"%') "+searchParam);
         }    
             if(andSearch){
                query.delete(query.length() - 3, query.length());
             }else{
               query.delete(query.length() - 2, query.length());
             }
             query.append(" order by lower(u.value) ");
             logger.debug("Query involving org affiliation: " + query.toString());
             System.out.println("Query involving org affiliation: " + query.toString());
             List resultList = getHibernateTemplate().find(query.toString());
             if(resultList!=null&&resultList.size()>0)
             {
               Set orgsIdSet = new HashSet();        
                for(int i=0;i<resultList.size();i++)
                {
                    StringAttribute strAttrObject = (StringAttribute) resultList.get(i);
                    if(strAttrObject!=null)
                    orgsIdSet.add(new Long(strAttrObject.getRootEntityId()));
                }
              System.out.println("The size of OrgsIdSet"+orgsIdSet.size());
              Set orgAfflExpertsIdSet = getAffiliatedExpertsForOrgs(orgsIdSet,expertIdAttrMatchMap);         
              if((orgAfflExpertsIdSet==null||orgAfflExpertsIdSet.size()<1)&&andSearch)
                     return new LinkedHashMap();//No results came up. End search
                    expertIdSet = processKolsSet(expertIdSet,orgAfflExpertsIdSet,hasAdded,andSearch);
                     System.out.println("expertIdSetSize new"+expertIdSet.size());
                  
             }
             else
             {
               System.out.println("The size of result List is null");    
             }
      hasAdded=true;
     attrKeywordMap.remove("org");
    }
  if(attrKeywordMap!=null&&attrKeywordMap.size()>0)
  {
      Iterator attrKeywordMapIterator = attrKeywordMap.keySet().iterator();
      
      while(attrKeywordMapIterator.hasNext())
      {
          StringBuffer query = new StringBuffer("from StringAttribute D where "
                    +"D.rootEntityType=101 and");
          String key = (String)attrKeywordMapIterator.next();
          Set keyWordSet = (Set)attrKeywordMap.get(key);
          Iterator keyWordSetIterator = keyWordSet.iterator();
          query.append(" D.attribute="+new Long(((String) key).trim()).longValue()+" and (");
          while(keyWordSetIterator.hasNext())
          {
              String keyword = (String)keyWordSetIterator.next();     
              query.append(" lower(D.value) like '%"
                + keyword.toLowerCase() + "%' "+searchParam);
          }
          if(andSearch)
                query.delete(query.length() - 3, query.length());
             else
               query.delete(query.length() - 2, query.length());  
          query.append(")");
          System.out.println("The final Query"+query.toString()); 
             List resultList = getHibernateTemplate().find(query.toString());
             if(resultList!=null&&resultList.size()>0)
             {
                 System.out.println("The attribute search results"+resultList.size());
                 Set expertAttrIdSet = new HashSet();
                 for(int i=0;i<resultList.size();i++)
                 {
                     StringAttribute strAttrObj = (StringAttribute)resultList.get(i);
                     if(strAttrObj!=null)
                     {
                         Long userId = new Long(strAttrObj.getRootEntityId());
                         expertAttrIdSet.add(userId);
                         Set matchedAttributeSet = (Set) expertIdAttrMatchMap.get(userId);
                         if (matchedAttributeSet == null) {
                                expertIdAttrMatchMap.put(userId, new HashSet());
                                matchedAttributeSet = (Set) expertIdAttrMatchMap.get(userId);
                         }
                         matchedAttributeSet.add(strAttrObj.getAttribute().getName());
                         expertIdAttrMatchMap.put(userId,matchedAttributeSet);
                     }
                 }
               expertIdSet = processKolsSet(expertIdSet, expertAttrIdSet, hasAdded, andSearch);
               hasAdded=true;
             }
             else
             { 
                 if(andSearch)//And search and results turned out null
                     {
                       System.out.println("Returning null");
                       return new LinkedHashMap();
                     }
             }
      
     
     }
     
  } 
    
 if(expertIdSet!=null&&expertIdSet.size()>0)
 {

        String[] inClauseTokenStrings=SqlAndHqlUtilFunctions.constructInClauseForQuery(expertIdSet);
     StringBuffer query = new StringBuffer("from User u where u.deleteFlag = 'N' and ");
     for (int i = 0; i < inClauseTokenStrings.length; i++) {
          query.append("( u.kolid in (" + inClauseTokenStrings[i] + " )) OR");
        }
        query.delete(query.length() - 2, query.length());
        query.append(" order by lower(u.lastName) ");
        logger.debug("Query involving in clause: " + query.toString());
        List result1 = getHibernateTemplate().find(query.toString());
        if (result1 != null && result1.size() > 0) {
            Set set = new HashSet();
            List toReturn = new ArrayList();
            for (int i = 0; i < result1.size(); i++) {
                long id = ((User) result1.get(i)).getId();
                if (set.add(new Long(id)) == true) {
                    {
                        User user = ((User)result1.get(i));
                        Set matchedAttributeSet = (Set)expertIdAttrMatchMap.get(new Long(user.getKolid()));
                        expertAttrMatchMap.put(user, matchedAttributeSet);
                        //toReturn.add((User) result1.get(i));
                    }
                }
            }
       }   
        System.out.println("Exiting the function\n");
        return expertAttrMatchMap;  
 }
return new LinkedHashMap();
}
    
    /**
     * This method performs an intersection between two Hashsets
     * 
     * @param HashSet1
     * @param HashSet2
     * @return A hashSet with the result.
     */
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

    /**
     * This method is called with a LinkedHashMap of attributeIds and textvalues for
     * Expert search.
     * 
     * @param LinkedHashMap
     *            of idvalue pair
     * @return LinkedHashMap of experts and attributes searched on
     */
    public LinkedHashMap fetchKOLMap(LinkedHashMap resultMap,MutableInteger startSearchIndex)
    {
        LinkedHashMap entitiesMap = new LinkedHashMap();
        Map expertAttribStats = new LinkedHashMap();
        Map expertSearchResults = fetchExperts(resultMap, startSearchIndex, expertAttribStats);
        entitiesMap.put(EXPERTS, expertSearchResults);
        entitiesMap.put(EXPERTS_STATS, expertAttribStats);
        return entitiesMap;
    }
    private Contacts[] getContact(long staffId) {
        logger.debug("Getting Contacts for StaffId: " + staffId);
        List result = getHibernateTemplate().find(
                "from Contacts where staffid=" + staffId);
        if (result == null)
            logger.debug("result is null");
        return ((Contacts[]) result.toArray(new Contacts[result.size()]));
    }
    
    private User[] getUsersByFirstName(String name) {
        
        List result = getHibernateTemplate().find(
                    "from User u where lower(u.firstName) like '%"
                    + name.toLowerCase() + "%' AND u.userType in ( " + Constants.USER_USER_TYPE + ", " + Constants.FRONT_END_ADMIN_USER_TYPE + " ) and u.deleteFlag='N'"); 

        if(result!=null&&result.size()>0)
        {
            return ((User [])result.toArray(new User [result.size()]));
        }

        return null;
        }

    private User[] getUsersByLastName(String name) {
        
        List result = getHibernateTemplate().find(
                    "from User u where lower(u.lastName) like '%"
                    + name.toLowerCase() + "%' AND u.userType in ( " + Constants.USER_USER_TYPE + ", " + Constants.FRONT_END_ADMIN_USER_TYPE + " ) ");

        if(result!=null&&result.size()>0)
        {
            return ((User [])result.toArray(new User [result.size()]));
        }

        return null;
        }
    
    private Set getExpertsForContact(String name,Map expertAttrIdMatchMap, String check)
    {
    User[] users = null;
    if(check.equals("firstname")) {
        users = getUsersByFirstName(name);
    }
    else {
        users = getUsersByLastName(name);
    }
    Set contactSet = new HashSet();
    AttributeType contactAttributeType = new AttributeType();
    contactAttributeType.setName("contacts");
    if(users!=null&&users.length>0)
     {
       for(int i=0;i<users.length;i++)
      {
          Contacts contacts[] = getContact(Long.parseLong(users[i].getStaffid()));
          Contacts contact = null;
            if (contacts != null && contacts.length > 0) {
                for (int c = 0; c < contacts.length; c++) {
                    contact = contacts[c];
                    System.out.println("Contact :"+contact.getContactName()+"staffId"+contact.getStaffid()+"Kolid"+contact.getKolId());
                    Long userId = new Long(getKolIdFromUserId(contact.getKolId()).getKolid());
                    contactSet.add(userId);
                    Set matchedAttributeSet = (Set) expertAttrIdMatchMap.get(userId);
                        if (matchedAttributeSet == null) {
                            expertAttrIdMatchMap.put(userId, new HashSet());
                            matchedAttributeSet = (Set) expertAttrIdMatchMap.get(userId);
                        }
                        matchedAttributeSet.add(contactAttributeType.getName());

                    expertAttrIdMatchMap.put(userId,matchedAttributeSet);
                    
                }     
            }
        }
     return contactSet;
     } 
    return null;
    }
    
    private User getKolIdFromUserId(long userId) {
        logger.debug("Getting KolId for userID: " + userId);
        return (User) getHibernateTemplate().load(User.class, new Long(userId));
    }
    
    private Set getAffiliatedExpertsForOrgs(Set orgsIdSet,Map expertIdAttrMatchMap)
    {
    if(orgsIdSet!=null&&orgsIdSet.size()>0)
    {
       Set expertIdSet = new HashSet();
       String[] inClauseTokenStrings=SqlAndHqlUtilFunctions.constructInClauseForQuery(orgsIdSet);
       StringBuffer query = new StringBuffer("from OrgOlMap o where");
       for (int i = 0; i < inClauseTokenStrings.length; i++) {
                query.append("(  o.orgId in (" + inClauseTokenStrings[i] + " )) OR");
            }
       query.delete(query.length() - 2, query.length());
       System.out.println("Calling orgOlMap query"+query.toString());
       List resultList = getHibernateTemplate().find(query.toString());   
       if(resultList!=null&&resultList.size()>0)
       {
         for(int j=0;j<resultList.size();j++)
         {
             OrgOlMap orgOlObject = (OrgOlMap)resultList.get(j);
             if(orgOlObject!=null)
             {
                 User u = ((User) getHibernateTemplate().load(User.class, new Long(orgOlObject.getOlId())));
                    if (u.getUserType().getId() == 4l) {
                        Long userId = new Long(u.getKolid());
                        expertIdSet.add(userId);          
                        Set matchedAttributeSet = (Set) expertIdAttrMatchMap.get(userId);
                        if (matchedAttributeSet == null) {
                            expertIdAttrMatchMap.put(userId, new HashSet());
                            matchedAttributeSet = (Set) expertIdAttrMatchMap.get(userId);
                        }
                        matchedAttributeSet.add("orgs");

                        expertIdAttrMatchMap.put(userId,matchedAttributeSet);
                    } 
                 }
         }   
        return expertIdSet;
       }
    }
        
    return null;
    }
    
    private Set processKolsSet(Set expertIdSet, Set toBeAddedKols ,boolean hasAdded,boolean andSearch)
    {
        if(!hasAdded)
        {
            hasAdded = true;
            return toBeAddedKols;
        }
        else
        {
            if(andSearch)
            {
                expertIdSet.retainAll(toBeAddedKols);
            }
            else
            {
              expertIdSet.addAll(toBeAddedKols);    
            }
        }
        
    return expertIdSet;
    }   
    public IOrganizationService getOrgService() {
        return orgService;
    }

    public void setOrgService(IOrganizationService orgService) {
        this.orgService = orgService;
    }

    public ITrialService getTrialService() {
        return trialService;
    }

    public void setTrialService(ITrialService trialService) {
        this.trialService = trialService;
    }

    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    public IFeaturePermissionService getFeatureSearchPermissionService() {
        return featureSearchPermissionService;
    }

    public void setFeatureSearchPermissionService(
            IFeaturePermissionService featureSearchPermissionService) {
        this.featureSearchPermissionService = featureSearchPermissionService;
    }

}
