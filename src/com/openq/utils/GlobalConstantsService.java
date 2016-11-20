package com.openq.utils;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

/**
 * This class implements the methods required to access/modify the data in the
 * GLOBAL_CONSTANTS table
 * 
 * @author Deepak Singh Rawat
 * @version 1.0, 06/22/2008
 * 
 */
public class GlobalConstantsService extends HibernateDaoSupport implements
IGlobalConstantsService {

	private static Logger logger = Logger
	.getLogger(GlobalConstantsService.class);

	/**
	 * Returns an array of GlobalConstants objects with all
	 * the global constants defined in the GLOBAL_CONSTANTS table 
	 * 
	 * @return globalConstants[]    instance of GlobalConstants class
	 * Returns an instance of size zero if no data is present or any error occurs.
	 */
	public GlobalConstants[] getAllGlobalConstants() {
		try {
			List allGlobalConstants = getHibernateTemplate().find("from GlobalConstants gc");
			if (allGlobalConstants != null && allGlobalConstants.size() > 0) {
				return (GlobalConstants[]) allGlobalConstants
				.toArray(new GlobalConstants[allGlobalConstants.size()]);
			} else {
				logger.debug("GLOBAL_CONSTANTS table is empty.");
				return new GlobalConstants[0];
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			return new GlobalConstants[0];
		}
	}

	/**
	 * Returns the value of the Global Constant in the GLOBAL_CONSTANTS
	 * table for the name passed as parameter.
	 *
	 * @param  <code>String</code> Global Constant Name
	 *
	 * @return a <code>String</code> value.
	 * Returns <code>null</code> if no data is present or any error occurs.
	 */
	public String getValueByName(String name) {
		try {
			List globalConstant = getHibernateTemplate().find("select gc.value from GlobalConstants gc where gc.name = '"+name+"'");
			if (globalConstant != null && globalConstant.size()>0) {
				return (String) globalConstant.get(0);
			} else {
				logger.debug("GLOBAL_CONSTANTS table is empty.");
				return null;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
	}
	
	/**
	 * Updates the value of the Global Constant in the GLOBAL_CONSTANTS table.
	 * 
	 * @param  instance of GlobalConstants class with the new value
	 * 
	 * @return a <code>boolean</code> value indicating the success/failure
	 * in update. Returns true if update is successful and false if update fails.
	 */

	public boolean updateGlobalConstantValue(GlobalConstants globalConstants) {
		try {
			getHibernateTemplate().update(globalConstants);
			return true;
		} catch (Exception e) {
			logger.error(e.getMessage());
			return false;
		}
	}
}
