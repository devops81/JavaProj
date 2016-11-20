package com.openq.eav.entitySearch;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.openq.utils.MutableInteger;


/**
 * Created by IntelliJ IDEA.
 * User: Lenovo
 * Date: Oct 19, 2007
 * Time: 1:33:17 PM
 * To change this template use File | Settings | File Templates.
 */
public interface IEntitySearchService {

   // public LinkedHashMap getEntitiesMap(String keyword,String eavTrial,long userGroupId);
   // public LinkedHashMap getEntitiesMap(Map attrKeywordMap);
    public List getSearchableAttributesForEntity(long entityTypeId,long userGroupId);
    public LinkedHashMap getExpertsSerachResultSet(String keyword, long userGroupId);
    public LinkedHashMap fetchExperts(LinkedHashMap ExpertResultMap,MutableInteger startSearchIndex,Map attributeStats);
    public LinkedHashMap fetchKOLMap(LinkedHashMap ExpertResultMap,MutableInteger startSearchIndex, MutableInteger stopSearchIndex);
   // public LinkedHashMap fetchResult(LinkedHashMap resultMap, MutableInteger startSearchIndex,Map attributeStats);
    public Map getResultMap(Map attrKeywordMap);
    public LinkedHashMap fetchKOLMap(LinkedHashMap resultMap,MutableInteger startSearchIndex);
    public LinkedHashMap fetchORGMap(LinkedHashMap ResultAttributeMatchMap, MutableInteger startSearchIndex);
    public LinkedHashMap getOrgSerachResultSet(String keyword);
    
}
