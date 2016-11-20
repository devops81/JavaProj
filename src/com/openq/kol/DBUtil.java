package com.openq.kol;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Hashtable;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;


/**
 * File 		: DBUtil.java
 * purpose		: This class is created to handle user Session expiry
 *
 * Created on Apr 2, 2005
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited.
 * description :
 * author 	   : Ravichandran.S
 */
public class DBUtil {
	


    private static DBUtil dbUtil = null;
    private static Logger logger = Logger.getLogger(DBUtil.class);
    public Properties prop;
    public Properties resourceProp;
    public Properties interactionProp;
    public Properties profileTabProp;
    public Properties featuresProp;
    public static String doctor;
    public static String doc;
    public static String customer;
    public static String hcp;
    public static DataSource dataSource;

	private DBUtil(){
        try {
            prop = this.getDataFromPropertiesFile("resources/custom-setup.prop");
            resourceProp = this.getDataFromPropertiesFile("resources/resource-link.prop");
            interactionProp = this.getDataFromPropertiesFile("resources/interactions.prop");
            profileTabProp=this.getDataFromPropertiesFile("resources/profileTab.prop");
            featuresProp=this.getDataFromPropertiesFile("resources/featuresProp.prop");
        }
        catch (IOException i)
        {
        	logger.error(i.getLocalizedMessage(), i);
        }
        if ( prop != null )
        {
            doctor = prop.getProperty("DOCTOR");
            doc = prop.getProperty("DOCTOR_SHORT");
            customer = prop.getProperty("CUSTOMER");
            hcp = prop.getProperty("HCP");
        }
        else{
            doctor = "Expert";
            doc = "Exp";
            customer = "Firm";
            hcp = "Expert";
        }

    }

    public static synchronized DBUtil getInstance()
    {
        if (dbUtil == null){
            dbUtil = new DBUtil();
        }
        return dbUtil;
    }

    public void closeDBResources(Connection connection, Statement statement , ResultSet resultSet)throws DataAccessException{
        try {
            if(resultSet != null){
                resultSet.close();
            }
            if(statement != null){
                statement.close();
            }
            if(connection != null){
                connection.close();
            }
        } catch (SQLException e) {
        	logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException(e.getMessage(), e);
        }
    }

    /*
     * Deepak : 15-Dec-2008 : Modified the method to remove the dependency
     * on the provider.url property in ServerConfig.properties file.
     * There is a small hack involved here.
     * We have declared the dataSource variable as static but the getter/setter are instance methods.
     * This is required because we set the value of the static dataSource through spring dependency
     * injection. Then the dataSource value is available in all the threads.
     * Ideally the DBUtil bean should also be injected at various places through Spring.
     * But, we have some legacy code in Strategy and Interaction module where we directly
     * create DBUtil instance using new.
     * TODO : Move the legacy code to spring and access DBUtil vis dependency injection.
     */
    public Connection createConnection() {
    	Connection connection = null;
    	try {
    		connection = dataSource.getConnection();
    	} catch (Exception e) {
    		logger.error(e);
    	}
    	return connection;
    }

    private Context getWeblogicContext(String providerURL)	throws NamingException {
        Hashtable env = new Hashtable();
        env.put(Context.INITIAL_CONTEXT_FACTORY,
                "weblogic.jndi.WLInitialContextFactory");
        env.put(Context.PROVIDER_URL, providerURL);

        return new InitialContext(env);
    }

    public Properties getDataFromPropertiesFile(String fileName)	throws IOException {

        Properties prop = new Properties();
        ClassLoader classLoader = DBUtil.class.getClassLoader();
        InputStream ioStream = null;
        try{
        	ioStream = classLoader.getResourceAsStream(fileName);
        }catch(Exception e) {
        	logger.error("Exception :"+e);
        }
        //This featuresProp.prop property file currently exists only for Alpharma.This property file is used to decide on what tabs to be displayed
        // in the Header.
        if(fileName.equalsIgnoreCase("resources/featuresProp.prop")&& ioStream==null){
        	return null;
        }else {
            prop.load(ioStream);
        }
        return prop;
    }

	/**
	 * @return the dataSource
	 */
	public DataSource getDataSource() {
		return dataSource;
	}

	/**
	 * @param dataSource the dataSource to set
	 */
	public void setDataSource(DataSource dataSource) {
		DBUtil.dataSource = dataSource;
	}
    
}
