package com.openq.authorization;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.openq.kol.DBUtil;

/**
 * This service provides routines to check whether a particular feature of the 
 * app is enabled for the given deployment or not
 *  
 * @see com.openq.authorization.IFeatureAccessService
 * @author Amit
 */
public class FeatureAccessService implements IFeatureAccessService {

    private static final String accessPropsFile = "resources/features.properties";
    
    private static Logger logger = Logger.getLogger(FeatureAccessService.class);
    private Properties featureProps;
    
    
    public FeatureAccessService() {
        ClassLoader classLoader = DBUtil.class.getClassLoader();
        InputStream ioStream = classLoader.getResourceAsStream(accessPropsFile);
        featureProps = new Properties();
        
        try {
            featureProps.load(ioStream);
        } 
        catch (IOException e) {
            logger.error("Unable to read properties for feature access");
            e.printStackTrace();
        }
    }
    
    public boolean isFeatureEnabled(String feature) {
        String enabled = featureProps.getProperty(feature, "false");
        
        return ("true".equals(enabled));
    }

    public Properties getFeatureAccessDetails() {
        return featureProps;
    }
}
