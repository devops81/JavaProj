package com.openq.utils;

import org.apache.log4j.Logger;


import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;

public class PropertyReader {

    private static PropertyReader propertyReader = new PropertyReader();
    private static Logger logger = Logger.getLogger(PropertyReader.class);
    private Properties eavConstant;
    private Properties lovConstant;
    private Properties serverConfig;

    private PropertyReader(){
        try {
            eavConstant = this.getDataFromPropertiesFile("resources/EavConstants.prop");
            lovConstant = this.getDataFromPropertiesFile("resources/LOVConstants.prop");
            serverConfig = this.getDataFromPropertiesFile("resources/ServerConfig.properties");
        }
        catch (IOException i)
        {
            logger.fatal("can not find the property files for eav and lov constant ");
            throw new RuntimeException("can not find the property files for eav and lov constant ");
        }
    }

    public static synchronized PropertyReader getInstance()
    {
        if (PropertyReader.propertyReader == null){
            PropertyReader.propertyReader = new PropertyReader();
        }
        return PropertyReader.propertyReader;
    }

    public static String getEavConstantValueFor(String key)
    {
        return  propertyReader.eavConstant.getProperty(key);
    }

    public static String getLOVConstantValueFor(String key)
    {     
        return  propertyReader.lovConstant.getProperty(key);
    }

    public static String getServerConstantValueFor(String key)
    {     
        return  propertyReader.serverConfig.getProperty(key);
    }

    public Properties getDataFromPropertiesFile(String fileName)	throws IOException {

        Properties prop;
        ClassLoader classLoader = PropertyReader.class.getClassLoader();
        InputStream ioStream = classLoader.getResourceAsStream(fileName);
        prop = new Properties();
        prop.load(ioStream);

        return prop;
    }
}
