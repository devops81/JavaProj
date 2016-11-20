package com.openq.kol;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
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
    public Properties jdbcConnectionInfo;
    public static String doctor;
    public static String doc;
    public static String customer;
    public static String hcp;
    

    private DBUtil(){
        try {
            prop = this.getDataFromPropertiesFile("resources/custom-setup.prop");
            resourceProp = this.getDataFromPropertiesFile("resources/resource-link.prop");
            interactionProp = this.getDataFromPropertiesFile("resources/interactions.prop");
            profileTabProp=this.getDataFromPropertiesFile("resources/profileTab.prop");
            featuresProp=this.getDataFromPropertiesFile("resources/featuresProp.prop");
            jdbcConnectionInfo=this.getDataFromPropertiesFile("resources/jdbc.properties");
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


    public Connection createConnection()throws DataAccessException{
        Connection connection = null;

        String serverName = "";
        Context ctx = null;
        DataSource ds = null;
        try
        {
            Properties props = getDataFromPropertiesFile("resources/ServerConfig.properties");
            serverName = props.getProperty("appserver.name");

            if (null != serverName && !"".equals(serverName)
                    && "weblogic".equalsIgnoreCase(serverName))
            {
                String providerURL = props.getProperty("provider.url");
                ctx = getWeblogicContext(providerURL);
                String jndiName = props.getProperty("jndi.name","openq");
                ds = (DataSource) ctx.lookup(jndiName);
                if (ds != null) {
                    connection = ds.getConnection();
                }
            } else {
            	DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
                String url = jdbcConnectionInfo.getProperty("jdbc.url");
                //String port = jdbcConnectionInfo.getProperty("jdbc.port");
                //String databaseName = jdbcConnectionInfo.getProperty("jdbc.databaseName");
                String username = jdbcConnectionInfo.getProperty("jdbc.username");
                String password = jdbcConnectionInfo.getProperty("jdbc.password");
                //String connectionString = url+":"+port+":"+"databaseName="+databaseName;
                connection = DriverManager.getConnection(url,username,password); // @machineName:port:SID
           }
            return connection;

        } catch (NamingException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException(e.getMessage());
        } catch (SQLException e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException(e.getMessage());
        }catch(Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException(e.getMessage());
        }
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
        try {
        	ioStream = classLoader.getResourceAsStream(fileName);
        } catch (Exception e) {
        	logger.error("Exception :" + e.getMessage());
        }
        // This featuresProp.prop property file currently exists only for
		// Alpharma.This property file is used to decide on what tabs to be
		// displayed
        // in the Header.
        if (fileName.equalsIgnoreCase("resources/featuresProp.prop")
        		&& ioStream == null)
        	return null;
        else {
        	prop.load(ioStream);
        }
        return prop;
    }
}
