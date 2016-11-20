package com.openq.kol;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import org.apache.log4j.Logger;

/**

* File : InteractionsManager.java

* Purpose : This manager class is for users' interactions with expert 
* 
* Created on Jul 15, 2005
* 
* Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
* and/or distribution is strictly prohibited. 
* 
* description :
* 
* author : vpadmavati
* 
*/

public class InteractionsManager {

	private static Logger logger = Logger.getLogger(InteractionsManager.class);

	
	/////////// Development Plan
  
  	
	/**
	* This method calls DAO to add a development plan
	* @param interactionsDTO
	* @throws ManagerException
	*/

	public void addDevPlan(InteractionsDTO interactionsDTO) throws ManagerException {

		try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
			interactionsDAO.addDevPlan(interactionsDTO);
	    } 
		catch (DataAccessException e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}
		catch (Exception e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}
	
	}
	
	public void addDevPlan(InteractionsDTO interactionsDTO, long[] expertIds) throws ManagerException {

		try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
			interactionsDAO.addDevPlan(interactionsDTO,expertIds);
	    } 
		catch (DataAccessException e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}
		catch (Exception e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}
	
	}
	
	/**
	* This method calls DAO to list all development plans
	* @param  devPlanId
	* @return ArrayList
	* @throws ManagerException
	*/
	public List getDevPlanHistory(int devPlanId) throws ManagerException {

		try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
			return interactionsDAO.getDevPlanHistory(devPlanId);

		} 
		catch (DataAccessException e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}
		catch (Exception e) {
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}

	}
  	/**
   	* This method calls DAO to get the details of a development plan
   	* @param devPlanId
   	* @return InteractionsDTO
   	* @throws ManagerException
   	*/

  	public InteractionsDTO getDevPlanDetails(int devPlanId) throws ManagerException {
	
		try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	return interactionsDAO.getDevPlanDetails(devPlanId);

	  	} 
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
			logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}

  	}

    /**
   	* This method calls DAO to list all development plans
   	* @param expertId
   	* @return ArrayList
   	* @throws ManagerException
   	*/

  	public ArrayList getAllDevPlans(int expertId) throws ManagerException {

		try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	return interactionsDAO.getAllDevPlans(expertId);

	  	}
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}

  	}

     public void deleteDevPlan(String devPlanId[])throws ManagerException {
         try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	interactionsDAO.deleteDevPlan(devPlanId);

	  	}
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}

     }

    public void updateDevPlan(int devPlanId,InteractionsDTO interactionsDTO)throws ManagerException {
         try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	interactionsDAO.updateDevPlan(devPlanId,interactionsDTO);

	  	}
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}

     }
 
	public void saveDevPaln( String[] interactions,long userId, String[] kolIdArr, String userName,String staffId, Date intDate) throws ManagerException {
        try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	interactionsDAO.saveDevPaln(interactions,userId,kolIdArr,userName,staffId,intDate);

	  	}
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}
    }
   public void saveInteractionTactics(long interactionId, String[] interactions) throws ManagerException {
        try {

			DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  	InteractionsDAOInterface interactionsDAO = daoFactory.getInteractionsDAO();
		  	interactionsDAO.saveInteractionTactics(interactionId, interactions);

	  	}
	  	catch (DataAccessException e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException(e.getMessage());
	  	}
	  	catch (Exception e) {
		  	logger.error(e.getLocalizedMessage(), e);
		  	throw new ManagerException("error.general.manager");
	  	}
    }
}
