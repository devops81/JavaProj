package com.openq.kol;

import java.util.Properties;
import java.io.*;

import com.openq.kol.DataAccessException;;

/**
 * File 		: QueryUtil.java
 * purpose		: This file is used for getting the Query from Queries.properties
 * 
 * Created on May 18, 2005
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * description : 
 * author 	   : baskark
 */
public class QueryUtil {
	
	private static Properties opCache    = new Properties();
	private static QueryUtil queryUtil = null;
		
	private QueryUtil(){
		
        try {
			ClassLoader dbClassLoader = QueryUtil.class.getClassLoader();
			String path = "resources/Queries.properties";
			InputStream dbQueryIS =dbClassLoader.getResourceAsStream(path);
			opCache.load(dbQueryIS);
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	static 
	{
	//Eager Instantiation	
		queryUtil = new QueryUtil();
	}
	
	
	public static synchronized QueryUtil getInstance()
	{
		if (queryUtil == null){
			queryUtil = new QueryUtil();
		}	  
		return queryUtil;
	}
	
	public String getQuery(String queryKey)throws DataAccessException{
		if (opCache.containsKey(queryKey))
			return (String) opCache.getProperty(queryKey);
  	    else
  	    	throw new DataAccessException( "unable to locate "+queryKey) ;  
	}
	
	

}
