package com.openq.interactionData;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;
import com.openq.eav.data.IDataService;
import com.openq.user.UserService;
import com.openq.utils.SqlAndHqlUtilFunctions;

public class UserRelationshipService extends HibernateDaoSupport implements 
										IUserRelationshipService {
	
	IDataService dataService;
	Date date = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh.mm.ss.SSSSSSSSS aa");
	String presentDate = sdf.format(date);
	java.sql.Timestamp ts = new java.sql.Timestamp(System.currentTimeMillis());
	static private Logger logger = Logger.getLogger(UserService.class);

	
	
	public String saveUserrelation(UserRelationship user) {
		logger.debug("Saving User");
		logger.info("Saving User: " + user);
		getHibernateTemplate().save(user);		
		logger.debug("User saved");
		return "true";
	}
	
	
	public String updateUserrelation(UserRelationship user) {
		logger.debug("Updating User");
		logger.info("Updating User: " + user);
		getHibernateTemplate().update(user);		
		logger.debug("User updated");
		return "true";
		}

	
	public UserRelationship[] getRelatedUser(String Id, String filterFlag) {
		logger.debug("Getting User for staffId:" + Id);
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh.mm.ss.SSSSSSSSS aa");
		String presentDate = sdf.format(date);
		String query="";
		if("Current Only".equalsIgnoreCase(filterFlag))
			query = "from UserRelationship u,User ut where (u.userId = ut.id or " +
				 "u.supervisorId = ut.id) and ut.id = "+ Id +" And u.endDate>='"+presentDate+"'  And u.beginDate<='"+presentDate+"' And ut.deleteFlag='N'";
		else
			query = "from UserRelationship u,User ut where (u.userId = ut.id or " +
			 "u.supervisorId = ut.id) and ut.id = "+ Id +" And ut.deleteFlag='N'";
		logger.info("query is :"+query);
		List result = getHibernateTemplate().find(query);
				logger.info("result.length="+result.size());
				List temp = new ArrayList();
				for(int i=0;i<result.size();i++)
				{
					Object[] arrObj = (Object[])result.get(i);
					temp.add((UserRelationship)arrObj[0]);
				}
		return (UserRelationship[]) temp.toArray(new UserRelationship[temp.size()]);
	}
	
	
	public String getTAbyCostCenter(String CC) {
		List result = getHibernateTemplate().find("from CostCenterToTAMap cc where cc.costCenter = '"+CC+"'");
		if(result != null && result.size()>0)
			return (String) result.get(0);
		return null;
	}
	


	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}


	public UserRelationship getUserRelationShip(long userId) {
		try{
		List result = getHibernateTemplate().find("from UserRelationship u where u.userId="+userId);
		System.out.println(result.size());
		if(result != null && result.size()>0)
			return (UserRelationship) result.get(0);
		}catch(Exception e)
		{
			System.err.println(e);
		}
		
		return null;
	}
	
	
	public UserRelationship[] getUserRelationshipForTerritories(String territoryIds) {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        String presentDate = sdf.format(date);

        String[] inClauses = SqlAndHqlUtilFunctions.constructInClauseForQuery(territoryIds);
        StringBuffer query = new StringBuffer("from UserRelationship u where " +
        		" trunc(u.endDate) >='"+presentDate+"'  And trunc(u.beginDate) <='"+presentDate+"' and ( ");

        for (int i = 0; i < inClauses.length; i++) {
            query.append("( u.territory in (" + inClauses[i] + " )) OR");
        }

        //delete the extra "OR" from the last 
        query.delete(query.length() - 2, query.length());
        query.append(" )");

        List result = getHibernateTemplate().find(query.toString());
        if (result != null && result.size() > 0)
            return (UserRelationship[]) result.toArray(new UserRelationship[result.size()]);
        return null;

    }
}

