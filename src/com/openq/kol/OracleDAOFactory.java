package com.openq.kol;

import com.openq.ovid.PublicationsDAOImpl;


/**
 * File 		: OracleDAOFactory.java
 * purpose		: OracleDAOFactory is an concrete Class extending DataAccessFactory
 * 				  DAO access methods for all the modules.This class will create instances 
 * 				  of a particular DAO requested by the calling class/methods
 * 
 * Created on Mar 4, 2005
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * description : 
 * author 	   : Ravichandran.S
 */
public class OracleDAOFactory extends DataAccessFactory {




    public KOLDAOImpl getKOLDAO()throws DataAccessException{

        return new KOLDAOImpl();
    }

    public InteractionsDAOImpl getInteractionsDAO()throws DataAccessException{

        return new InteractionsDAOImpl();
    }

    //abstract method to access a PublicationsDAOImpl
    public PublicationsDAOImpl getPublicationsDAO() throws DataAccessException {
        return new PublicationsDAOImpl();
    }

}
