package com.openq.siteSearch;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.IFeaturePermissionService;
import com.openq.eav.option.IOptionService;
import com.openq.utils.PropertyReader;
import com.openq.web.controllers.Constants;

/**
*
* @author Tapan
* @date 15th Sept 2009
*
*/



public class SiteSearchService extends HibernateDaoSupport implements ISiteSearchService {


    IOptionService optionService;

    IFeaturePermissionService featurePermissionService;

    /**
     * @return the optionService
     */
    public IOptionService getOptionService() {
        return optionService;
    }
    /**
     * @param optionService the optionService to set
     */
    public void setOptionService(IOptionService optionService) {
        this.optionService = optionService;
    }
    /**
     * @return the featurePermissionService
     */
    public IFeaturePermissionService getFeaturePermissionService() {
        return featurePermissionService;
    }
    /**
     * @param featurePermissionService the featurePermissionService to set
     */
    public void setFeaturePermissionService(
            IFeaturePermissionService featurePermissionService) {
        this.featurePermissionService = featurePermissionService;
    }

    public List getAllSites(HashMap siteParamMap, long userGroupId, String currentUserTA) {

        StringBuffer queryBuffer1 = new StringBuffer("from SiteEntity se");
        StringBuffer queryBuffer2 = new StringBuffer();
        for (Iterator itr = siteParamMap.entrySet().iterator(); itr.hasNext();) {
            Map.Entry entry = (Map.Entry) itr.next();
            String param = (String)entry.getKey();
            String value = ((String)entry.getValue());

            if(value != null && !"".equals(value)){
                value = value.trim().toUpperCase();
            }
            if (("centerName").equals(param)) {
                queryBuffer2.append(" and upper(se.centerName) like '%").append(value).append("%' ");
            }
            if (("address").equals(param)) {
                queryBuffer2.append(" and upper(se.address) like '%").append(value).append("%' ");
            }
            if (("firstName").equals(param)) {
                queryBuffer2.append(" and upper(se.firstName) like '%").append(value).append("%' ");
            }
            if (("city").equals(param)) {
                queryBuffer2.append(" and upper(se.city) like '%").append(value).append("%' ");
            }
            if (("lastName").equals(param)) {
                queryBuffer2.append(" and upper(se.lastName) like '%").append(value).append("%' ");
            }
            if (("state").equals(param)) {
                queryBuffer2.append(" and upper(se.provinceCounty) like '%").append(value).append("%' ");
            }
            if (("zipCode").equals(param)) {
                queryBuffer2.append(" and upper(se.poastalCode) like '%").append(value).append("%' ");
            }
            if (("country").equals(param)) {
                queryBuffer2.append(" and upper(se.country) like '%").append(value).append("%' ");
            }
        }

        String finalQuery = queryBuffer1.append(" where ").
        append(queryBuffer2.substring(4, queryBuffer2.length())).toString();

        if (finalQuery != null && !("".equals(finalQuery))) {
            return getHibernateTemplate().find(finalQuery);
        }

        return null;
    }

}