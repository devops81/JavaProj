package com.openq.authorization;

import java.util.Properties;

/**
 * This service provides routines to check whether a particular feature of the 
 * app is enabled for the given deployment or not
 *  
 * @author Amit
 */
public interface IFeatureAccessService {
	public Properties getFeatureAccessDetails();
	public boolean isFeatureEnabled(String feature);
}
