package com.openq.kol;

import com.openq.ovid.PublicationsDAOImpl;


/**
 * File 		: DataAccessFactory.java
 * purpose		: DataAccessFactory is an Abstract Class defining the  
 * 				  DAO access methods for all the modules
 * 
 * Created on Mar 4, 2005
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * description : 
 * author 	   : Ravichandran.S
 */
public abstract class DataAccessFactory {

    // List of DAO types supported by the factory
    public static final int ORACLE = 1;


    /**
     * This method will help in getting access to DAO factory for a particular database
     * @param whichFactory constant refering to Database factory
     * @return DataAccessFactory concrete class of requested factory
     * @throws DataAccessException in case of failure
     */
    public static DataAccessFactory getDAOFactory(int whichFactory) throws DataAccessException{

      switch (whichFactory) {
        case ORACLE:
            return new OracleDAOFactory();
        default :
            return null;
      }
    }

    //abstract method to access a KOLDAO
    public abstract KOLDAOImpl getKOLDAO() throws DataAccessException;

    //abstract method to access a InteractionsDAO
    public abstract InteractionsDAOImpl getInteractionsDAO() throws DataAccessException;

    //abstract method to access a InteractionsDAO
    public abstract PublicationsDAOImpl getPublicationsDAO() throws DataAccessException;





}
