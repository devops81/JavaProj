package com.openq.eav.option;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.authorization.FeaturePermissionMetadata;
import com.openq.authorization.IFeaturePermissionService;
import com.openq.utils.PropertyReader;
import com.openq.web.controllers.Constants;

/**
 * Please keep in mind to use 'o' as an alias for querying OptionLookup.
 * This is required so that we can use a generic ORDER_BY_STRING for all the
 * queries involving OptionLookup.
 * @author deepak
 *
 */

public class OptionService extends HibernateDaoSupport implements IOptionService {
	IFeaturePermissionService  featurePermissionService;
	private static final String ORDER_BY_STRING = " order by o.displayOrder, o.optValue ";

	public OptionNames[] getAllOptionNames() {

		List result = getHibernateTemplate().find("from OptionNames order by name");
		return (OptionNames[]) result.toArray(new OptionNames[result.size()]);
	}

	public OptionNames getOptionNames(long id) {
		List result = getHibernateTemplate().find("from OptionNames where id="+id);
		if(result.size() > 0){
			return (OptionNames) result.get(0);
		}else{
			logger.debug("Option name with the id is not available");
			return null;
		}
	}

	public OptionLookup getOptionLookup(long id,long userGroupId) {

		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.id="+ id
				+" and o.id "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		if(result.size() > 0){
			return (OptionLookup) result.get(0);
		}else{
			logger.debug("Option lookup with the id is not available");
			return new OptionLookup();
		}
	}


	public OptionLookup[] getValuesForOption(long OptionId,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.optionId="+ OptionId
				+" and o.id  "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		if(result.size() > 0){
			return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
		}else{
			return new OptionLookup[0];
		}
	}
    public OptionLookup[] getValuesForOptionByDeleteStatus(long OptionId,long userGroupId, boolean allowDeletedValues) {
        final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
        StringBuffer queryBuffer = new StringBuffer ( "from OptionLookup o where o.optionId="+ OptionId );
        if ( !allowDeletedValues ){
            queryBuffer.append(" and o.deleteFlag !='Y' ");
        }
        queryBuffer.append( " and o.id  ").append(PERMISSION_APPEND_QUERY).append(ORDER_BY_STRING);
        List result = getHibernateTemplate().find(queryBuffer.toString());
        if(result.size() > 0){
            return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
        }else{
            return new OptionLookup[0];
        }
    }
	public OptionLookup[] getUndeletedValuesForOption(long OptionId,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.optionId="+ OptionId+" AND o.deleteFlag = 'N'"
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
	}
	public OptionLookup[] getValuesForOption(String optionName,long userGroupId) {
		long id = getIdForOptionName(optionName);
		if (id < 0)
			return new OptionLookup[0];
		return getValuesForOption(id,userGroupId);
	}
	
	public OptionLookup[] getValuesForOptionWithExcludedValues(long id,long userGroupId, String[] excludedValues) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		String excludedvaluesQuery =getExcludedValuesQuery(excludedValues);
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.optionId="+ id
				+" and o.id  "
				+PERMISSION_APPEND_QUERY + excludedvaluesQuery
				+ORDER_BY_STRING);
		if(result.size() > 0){
			return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
		}else{
			return new OptionLookup[0];
		}
	}
	
	private String getExcludedValuesQuery(String[] excludedValues){
		String query ="";
		if(null!=excludedValues && excludedValues.length >1){
			StringBuffer queryBuffer = new StringBuffer("and");
			for(int i=0;i<excludedValues.length;i++){
				queryBuffer.append(" o.optValue !='"+excludedValues[i]+"' and");
			}
			queryBuffer.delete(queryBuffer.length() -3, queryBuffer.length());
			query= queryBuffer.toString();
		}
		return query;
	}
	
   public OptionLookup[] getValuesForOptionByDeleteStatus(String optionName, long userGroupId, boolean allowDeletedValues) {
        long id = getIdForOptionName(optionName);
        if (id < 0){
            return new OptionLookup[0];
        }
        return getValuesForOptionByDeleteStatus(id, userGroupId, allowDeletedValues);
    }
	public OptionLookup[] getUndeletedValuesForOption(String optionName,long userGroupId) {
		long id =getIdForOptionName(optionName);
		if (id < 0)
			return new OptionLookup[0];
		return getUndeletedValuesForOption(id,userGroupId);
	}
	public long getIdForOptionName(String optionName) {
		List result = getHibernateTemplate().find("from OptionNames o where o.name='" + optionName + "'");
		if (result.size() == 0)
			return -1;
		OptionNames oName = (OptionNames) result.get(0);
		return oName.getId();
	}

	public void addValueToOptionLookup(OptionLookup ol){
		getHibernateTemplate().save(ol);
	}

	public void createOptionName(OptionNames optionName){
		getHibernateTemplate().save(optionName);
	}


	public OptionNames createOrUpdateOptionName(String name){

       OptionNames optionName;
       long id = getIdForOptionName(name);
        if ( id == -1 )
        {
            optionName = new OptionNames();
            optionName.setName(name);
            getHibernateTemplate().save(optionName);
        }
        else
        {
            optionName = getOptionNames(id);
            optionName.setName(name);
            getHibernateTemplate().update(optionName);
        }
        return optionName;
    }

    public void saveUpdateOptionLookup(long id, String value,long userGroupId) {
    	final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);

		List list = getHibernateTemplate().find("from OptionLookup o where o.id=" + id
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		if (list.size()> 0) {
			OptionLookup ol = (OptionLookup) list.get(0);
			ol.setOptValue(value);
			ol.setDeleteFlag("N");
			getHibernateTemplate().saveOrUpdate(ol);
		}else{
			logger.debug("Could not find the option lookup to update.");
		}

	}

	public void saveUpdateOptionName(long id, String value){

		List list = getHibernateTemplate().find("from OptionNames where id=" + id);
		if (list.size()> 0) {
			OptionNames on = (OptionNames)list.get(0);
			on.setName(value);
			getHibernateTemplate().saveOrUpdate(on);
		}else{
			logger.debug("Could not find the option lookup to update.");
		}
	}

	public void deleteOptionLookup(long id,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find(
				"from OptionLookup o where o.id=" + id
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		if (result.size()> 0) {
			OptionLookup ol = (OptionLookup) result.get(0);
			// delete all the child records cascade
			deleteChildRecordsCascade(ol.getId());
			ol.setDeleteFlag("Y");
			getHibernateTemplate().delete(ol);
		}else{
			logger.debug("Could not find the option lookup to update.");
		}

	}
	public void deleteOptionLookup(OptionLookup opid,long userGroupId) {
		opid.setDeleteFlag("Y");
		// delete all the child records cascade
		deleteChildRecordsCascade(opid.getId());
		getHibernateTemplate().update(opid);
	}




	public void addValueToOptionLookup(OptionNames optionNames, String value, long parentId) {
		OptionLookup ol = new OptionLookup();
		ol.setOptValue(value);
		ol.setOptionId(optionNames);
		ol.setDeleteFlag("N");
		ol.setParentId(parentId);
		getHibernateTemplate().save(ol);
	}

	public void addValuesToOptionLookUp(OptionNames optionNames, LinkedHashSet valuesSet)
	{
		Iterator h = valuesSet.iterator();
		while (h.hasNext()) {
			OptionLookup ol = new OptionLookup();
			//String value=(String)h.next();
			//System.out.println("Value: "+value);
			//ol.setOptValue(value);
			ol.setOptValue((String)h.next());
			ol.setDeleteFlag("N");

			ol.setOptionId(optionNames);
			getHibernateTemplate().save(ol);
		}
	}


	public void addOrUpdateValuesToOptionLookUp(OptionNames optionNames, LinkedHashSet valuesSet,long userGroupId)
	{

        OptionLookup[] optionLookups = this.getValuesForOption(optionNames.getId(),userGroupId);
        List existingOptionNames = Arrays.asList(optionLookups);
        Iterator newIterator = valuesSet.iterator();
        Iterator existingIterator = existingOptionNames.iterator();

        while (newIterator.hasNext())
        {   OptionLookup thisOptionLookup;
            if ( existingIterator.hasNext())
            {
                thisOptionLookup = (OptionLookup) existingIterator.next();
                thisOptionLookup.setOptValue((String)newIterator.next());
                getHibernateTemplate().evict(thisOptionLookup);
                getHibernateTemplate().update(thisOptionLookup);
            }
            else
            {
                thisOptionLookup = new OptionLookup();
			    thisOptionLookup.setOptValue((String)newIterator.next());
			    thisOptionLookup.setOptionId(optionNames);
			    getHibernateTemplate().save(thisOptionLookup);
            }
        }
	}


	public void addValueToOptionLookup(OptionLookup ol,OptionNames on){
		ol.setOptionId(on);
		ol.setDeleteFlag("N");
		getHibernateTemplate().save(ol);
	}
	public OptionLookup[] getRelatedChild(long optionId, long parentId,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("from OptionLookup o where o.optionId='" + optionId +
				"' and o.parentId='" + parentId +
				"' and o.deleteFlag!='Y'"
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		if(result.size()>0)
			return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
		else
			return null;
	}

	public OptionLookup[] getAllChild(long parentId,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.parentId="+ parentId
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
	}
	/**
	 * This method sets the default value for option lookup LOV
	 * @param existingOptionLookupId
	 * @param newOptionLookupId
	 * @return boolean true for success and false for failure
	 */

	public boolean setDefaultDisplayValue(long existingOptionLookupId, long newOptionLookupId,long userGroupId) {
		OptionLookup newObj = null;
		deleteDefaultDisplayValue(existingOptionLookupId,userGroupId);
		try{
			if(newOptionLookupId != 0){
				newObj = getOptionLookup(newOptionLookupId,userGroupId);
				if(newObj != null && newObj.getId() != 0){
					newObj.setDefaultSelected(true);
					getHibernateTemplate().update(newObj);
					return true;
				}
			}
		} catch (Exception e) {
			logger.error("Error occurred while setting option id : " + newOptionLookupId
					+ " default selected value. StackTrace follows : "
					+ e.getStackTrace());
			return false;
		}
		return false;
	}
	/**
	 * This method deletes the default value for option lookup LOV
	 * @param existingOptionLookupId
	 * @return boolean true for success and false for failure
	 */
	public boolean deleteDefaultDisplayValue(long existingOptionLookupId,long userGroupId) {
		OptionLookup existingObj = null;
		try{
			if(existingOptionLookupId != 0){
				existingObj = getOptionLookup(existingOptionLookupId,userGroupId);
				if(existingObj != null && existingObj.getId() != 0){
					existingObj.setDefaultSelected(false);
					getHibernateTemplate().update(existingObj);
					return true;
				}
			}
		} catch (Exception e) {
			logger.error("Error occurred while deleting option id : " + existingOptionLookupId
					+ " default selected value. StackTrace follows : "
					+ e.getStackTrace());
			return false;
		}
		return false;
	}

	public void updateOptionLookupDisplayOrder(OptionLookup optionLookup) {
		getHibernateTemplate().update(optionLookup);
	}

	public OptionLookup getOptionLookup(long id) {
		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.id="+ id +ORDER_BY_STRING);
		if(result.size() > 0){
			return (OptionLookup) result.get(0);
		}else{
			logger.debug("Option lookup with the id is not available");
			return null;
		}
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
	private String getPermissionAppendQuery(long permissionOnFeature, long userGroupId) {
		String query = "";
		String condition = "";
		long adminUserGroupId = 0;
		String adminUserTypeIdString = PropertyReader.getEavConstantValueFor("ADMIN_USER_GROUP_ID");
		if(adminUserTypeIdString != null && !"".equals(adminUserTypeIdString)){
			adminUserGroupId = Long.parseLong(adminUserTypeIdString);
		}
		if(adminUserGroupId == userGroupId){
			query = " like '%' ";
		}else{
			List result = getHibernateTemplate().find("from FeaturePermissionMetadata fpm where fpm.id="+permissionOnFeature);
			if(result.size() > 0){
				if(((FeaturePermissionMetadata) result.get(0)).isAllowedByDefault()){
					condition = " not ";
				}
			}
			query = condition + " in ( select fum.featureId from FeatureUsergroupMap fum where fum.permissionOnFeature="+permissionOnFeature
			+ " and fum.usergroupId  like '%,"+userGroupId+",%' ) ";
		}
		return query;
	}
	public List getRelatedChild(String optionName, long parentId,long userGroupId) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		List result = getHibernateTemplate().find("select o from OptionLookup o, OptionNames on where on.id = o.optionId and on.name='" + optionName +
				"' and o.parentId='" + parentId +
				"' and o.deleteFlag!='Y'"
				+" and o.id   "
				+PERMISSION_APPEND_QUERY
				+ORDER_BY_STRING);
		return result;
	}
	/**
	 * This method will delete all the child records recursively
	 * @param parentId
	 */
	public void deleteChildRecordsCascade(long parentId) {

		List result = getHibernateTemplate().find("from OptionLookup o where o.deleteFlag!='Y' and o.parentId="+ parentId);
		if(result.size() > 0){
			for( int i=0; i<result.size(); i++){
				OptionLookup lookup = (OptionLookup) result.get(i);
				if(lookup != null)
					deleteChildRecordsCascade(lookup.getId());
				lookup.setDeleteFlag("Y");
				getHibernateTemplate().update(lookup);
			}
		}
	}

	public List getRelatedChildForParents(String optionName,
			String commaSeparatedParentIds, long userGroupId, String lovValuesToBeExcluded, boolean allowDeletedValuesFlag) {
		final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
		StringBuffer queryBuffer = new StringBuffer("");
		queryBuffer.append("select o from OptionLookup o, OptionNames on where on.id = o.optionId and on.name='" + optionName).append(
				"' and o.parentId in (" + commaSeparatedParentIds + ") ").append(
				" and o.id   ").append(PERMISSION_APPEND_QUERY);

		// check if deleted values are not allowed
	      if( !allowDeletedValuesFlag ){
	          queryBuffer.append("  and o.deleteFlag !='Y' ");
	        }

		// if there are values to be excluded then append query
		if(lovValuesToBeExcluded != null &&
  				!"".equals(lovValuesToBeExcluded) &&
  				!"undefined".equalsIgnoreCase(lovValuesToBeExcluded)){

			queryBuffer.append(" and o.optValue not in ( " + lovValuesToBeExcluded + " ) ");
   		}
		queryBuffer.append(ORDER_BY_STRING);

		List result = getHibernateTemplate().find(queryBuffer.toString());
		return result;
	}

	public OptionLookup getOptionValueForOptValueAndRegion(String optValue, String region) {
		logger.debug("Into getOptionValueForOptValueAndRegion for OptValue="+optValue+" and region="+region);
		System.out.println("Accessing");
		List result = getHibernateTemplate().find("from OptionLookup o where o.optValue='" + optValue +"'");
		if(result == null || result.size()==0)
			{
				System.out.println("strategy : null");
				logger.warn("There is no option in the database having optValue="+optValue+" Result is null");
				return null;
			}
		return (OptionLookup) result.get(0);


	}

		public long getIdForOptionValue(String optValue){
			//final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
			List result = null;
			try{
			result = getHibernateTemplate().find("from OptionLookup o where o.optValue='" + optValue +"'");
			}catch(Exception e){
				System.err.println(e);
			}
			if(result != null && result.size()!=0){
				OptionLookup optionLookup = (OptionLookup) result.get(0);
			    return optionLookup.getId();
			}

			return 0;


		}

		public OptionLookup getOptionForOptionValue(String optValue) {
			List result = null;
			System.out.println("Opt Service");
			try{
			result = getHibernateTemplate().find("from OptionLookup o where o.optValue='" + optValue +"'");
			}catch(Exception e){
				System.err.println(e);
			}
			if(result != null && result.size()!=0){
				OptionLookup optionLookup = (OptionLookup) result.get(0);
			    return optionLookup;
			}


			return null;
		}
		public OptionLookup[] getAllOptions(String optionList,long userGroupId){

			final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
			List result = getHibernateTemplate().find("select o from OptionLookup o, OptionNames on where on.id = o.optionId and on.name in (" + optionList +
					") and o.deleteFlag!='Y'"
					+" and o.id   "
					+PERMISSION_APPEND_QUERY
					+ORDER_BY_STRING);
			if(result != null && result.size()!=0){
				return (OptionLookup[]) result.toArray(new OptionLookup[result.size()]);
			}
			return null;


		}

		public long getIdForOptionValueAndParentName(String optValue,String parentName){
			//final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);

			List result = getHibernateTemplate().
					find("select o from OptionLookup o, OptionNames o1 where o1.id = o.optionId.id and o1.name='" + parentName +
					"' and o.deleteFlag!='Y'"
					+" and o.optValue='" + optValue +"'");
			if(result == null || result.size()==0){
				System.out.println(optValue+":"+parentName);
			    return 0;
			}

			OptionLookup optionLookup = (OptionLookup) result.get(0);
			return optionLookup.getId();



		}

		public List getLookupForOptionId(long optionId, long userGroupId) {
			final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);
			StringBuffer queryBuffer = new StringBuffer("");
			queryBuffer.append("select o from OptionLookup o where o.optionId = " +optionId).append("  and o.deleteFlag !='Y' ").append(
					" and o.id   ").append(PERMISSION_APPEND_QUERY);

			queryBuffer.append(ORDER_BY_STRING);

			List result = getHibernateTemplate().find(queryBuffer.toString());
			return result;
		}

		public List getOptionLookupByName(String optionName) {
			List result = getHibernateTemplate().find("from OptionLookup o where o.optionId.name = '" +optionName + "' and o.deleteFlag !='Y' ");
			return result;
		}
		 public void saveUpdateOptionLookup(long id, String value,long parentId,long userGroupId) {
		    	final String PERMISSION_APPEND_QUERY = getPermissionAppendQuery(Constants.LOV_VALUE_PERMISSION_ID, userGroupId);

				List list = getHibernateTemplate().find("from OptionLookup o where o.id=" + id
						+" and o.id   "
						+PERMISSION_APPEND_QUERY
						+ORDER_BY_STRING);
				if (list.size()> 0) {
					OptionLookup ol = (OptionLookup) list.get(0);
					ol.setOptValue(value);
					ol.setDeleteFlag("N");
					ol.setParentId(parentId);
					getHibernateTemplate().saveOrUpdate(ol);
				}else{
					logger.debug("Could not find the option lookup to update.");
				}

			}

		 public OptionLookup getParentOptionLookupId(String parentOptionName, String parentOptionValue) {
		     String queryString = "from OptionLookup optl where upper(optl.optionId.name) = '" +
		     parentOptionName.replaceAll("'", "''").toUpperCase() + "' and upper(optl.optValue) like '" +
		     parentOptionValue.replaceAll("'", "''").toUpperCase() +"' and optl.deleteFlag != 'Y'";

		     List parentOptionLookupList = getHibernateTemplate().find(queryString);
		     if (parentOptionLookupList != null && parentOptionLookupList.size() > 0)
		         return (OptionLookup)parentOptionLookupList.get(0);

		     return null;
		 }

		 public boolean doesOptionLookupExist(String childOptionValue, long parentOptionValueId) {

		     String queryString = "from OptionLookup opt where upper(opt.optValue) = '" +
		     childOptionValue.replaceAll("'", "''").toUpperCase() + "' and opt.parentId = "+ parentOptionValueId +
		     " and opt.deleteFlag != 'Y'";

		     List sitesFound = getHibernateTemplate().find(queryString);
		     if (sitesFound != null && sitesFound.size() > 0)
		         return true;
		     return false;
		 }

        public Map getValueParentMap(String optionName) {
            Map valueParentMap = new HashMap();
            String queryString = "select val.optValue, par.optValue from OptionLookup val, OptionLookup par " +
            		" where par.id = val.parentId and val.optionId.name = '" + optionName + "'";
            List results = getHibernateTemplate().find(queryString);
            for(int i=0; i<results.size(); i++){
                Object[] result = (Object[]) results.get(i);
                String childObj = (String) result[0];
                String parentObj = (String) result[1];
                valueParentMap.put(childObj, parentObj);
            }
            return valueParentMap;
        }
        
        public OptionLookup getParentLookupObject(String childOptionName){
        	final String queryString = "select par from OptionLookup child, OptionLookup par " +
        	" where child.parentId = par.id and child.optionId.id = "+ Constants.COUNTRY_LOV_ATTRIBUTE_ID +" and child.optValue = '" + childOptionName + "'";
        	
        	final List parentOptionLookupList = getHibernateTemplate().find(queryString);
		     if (parentOptionLookupList != null && parentOptionLookupList.size() > 0){
		         return (OptionLookup)parentOptionLookupList.get(0);
		     }
		     return null;
        }

}
