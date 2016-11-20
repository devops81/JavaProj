package com.openq.kol;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;



/*
 * KOLManager
 *
 * Feb 18,2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
*/

public class KOLManager {
	
	private static Logger logger = Logger.getLogger(KOLManager.class);
	
	/**
	 * This method gets all the Nodes or segments	 	
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing Nodes or Segments.
	*/
	public ArrayList getSegmentTree() throws ManagerException
	{
		ArrayList allNodes = new ArrayList();
		try{
			DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
			allNodes = (ArrayList)kolDAOInterface.getSegmentTree();
			return allNodes;			
		}
		catch (DataAccessException e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}catch(Exception e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}	
	}
	
	/**
	 * This method applies the selected Segment Tactic to the Segment Experts	 	
	 * @param tacticId
	 * @param segmentId 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode, all Segment Tactics, and Applied SegmentTactic
	*/
   
	public ArrayList applySegmentTactic(int segmentTacticId, int segmentId, int userId) throws ManagerException  {

	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		
		  //	applies the Segment Tactic to the Segment Experts.
		  ArrayList result = kolDAO.updateSegmentExpertTactics(segmentTacticId, segmentId);
	
		  TacticDTO segmentTacticDTO = getAllSegmentTacticDetail(segmentTacticId);
		  
		  if(segmentTacticDTO != null) {
			
			  // Insert the Segment Tactic as a development plan for the expert.
			  InteractionsDTO devPlan = new InteractionsDTO();		
		
			  devPlan.setActivity(String.valueOf(segmentTacticDTO.getTacticId()));

			  devPlan.setRole(segmentTacticDTO.getRole());

              devPlan.setDueDate(segmentTacticDTO.getTacticDueDate());

			  devPlan.setUserId(userId);
		
			  //devPlan.setStatus(getSegmentInfoForSegmentId(segmentId).getStrategyStatus());
		
			  long[] expertIds = null;
			  ArrayList segmentExperts = getExpertsForSegmentId(segmentId);
              boolean flag = false;
			  if(segmentExperts != null && segmentExperts.size() > 0) {
				  expertIds = new long[segmentExperts.size()];
				  for(int i=0; i<segmentExperts.size(); ++i) {
                       flag =  isExists(devPlan.getActivity(),((MyExpertDTO) (segmentExperts.get(i))).getExpertId());
                      if (!flag){
                       expertIds[i] = ((MyExpertDTO) (segmentExperts.get(i))).getExpertId();
                     }
                  }
				
				  new InteractionsManager().addDevPlan(devPlan, expertIds);
			  }	
	  	  }	
	
	  	  return result;	  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
          e.printStackTrace();
        throw new ManagerException("error.general.manager", e);
	  }	
	}
  
	
	/**
	 * This method deletes choosen experts from segments.  
	 * @param expertId,segmentId
	 * @param segmentCriteria
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList of remaining Experts.
	*/
	public ArrayList deleteExpertsFromSegment(String expertIds[],ArrayList segmentCriteria,int segmentId) throws ManagerException
	{
		ArrayList remainingExperts = new ArrayList();
		boolean deleteExpertflag = false;
		try{
			DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
			
			deleteExpertflag = kolDAOInterface.deleteExpertsFromSegment(expertIds,segmentId);
			
			// TODO: Take care of delete flag later
			if (deleteExpertflag == true) {
				remainingExperts = kolDAOInterface.getExpertsForSegmentId(segmentId);
			}
			else {
				remainingExperts = null;
			}
			return remainingExperts;
		}
		catch (DataAccessException e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}catch(Exception e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}
	}
	
	/**
	 * This method adds node to the tree.  
	 * @param NodeDTO 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return boolean status of added node.   
	*/	
	public boolean addNode(NodeDTO nodeDTO) throws ManagerException
	{
		boolean addNodeFlag = false;
		try{
			DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
			addNodeFlag = kolDAOInterface.addNode(nodeDTO);
			
			return addNodeFlag;			
		}
		catch (DataAccessException e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}catch(Exception e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}
	}
	
	/**
	 * This method deletes node or segment from the tree.  
	 * @param nodeIds
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return boolean status of deleting segment.   
	*/
	public boolean deleteNode(String [] nodeIds) throws ManagerException
	{
		boolean deleteNodeFlag = false;
		try{
			DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
			deleteNodeFlag = kolDAOInterface.deleteNode(nodeIds);
			return deleteNodeFlag;			
		}
		catch (DataAccessException e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}catch(Exception e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}
	}
  
	/**
	 * This method gets experts for segment id.  
	 * @param segmentId 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return arraylist containing ExpertDTO's   
	*/
   public ArrayList getExpertsForSegmentId(int segmentId) throws ManagerException
	{
		ArrayList expertsInSegment = new ArrayList();
		try{
			DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
			expertsInSegment = (ArrayList)kolDAOInterface.getExpertsForSegmentId(segmentId);
			return expertsInSegment;			
		}
		catch (DataAccessException e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException(e.getMessage());
		}catch(Exception e){
			logger.error(e.getLocalizedMessage(), e);
			throw new ManagerException("error.general.manager");
		}	   	
   }
   
   
   /**
	* This method gets experts information for Touch Graph.  
	* @param expertIds 
	* @exception ManagerException is thrown in case of problem in execution
	* @return arraylist containing ExpertDTO's   
   */
  public ArrayList getExpertsForTG(String expertIds) throws ManagerException
   {
	   ArrayList expertsInSegment = new ArrayList();
	   try{
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
		   expertsInSegment = (ArrayList)kolDAOInterface.getExpertsForTG(expertIds);
		   return expertsInSegment;			
	   }
	   catch (DataAccessException e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException(e.getMessage());
	   }catch(Exception e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException("error.general.manager");
	   }	   	
  }
   
   /**
	* This method gets experts for segment id.  
	* @param segmentId 
	* @exception ManagerException is thrown in case of problem in execution
	* @return arraylist containing ExpertDTO's   
   */
   public HashMap getExpertsRefDetails(String refIds) throws ManagerException
   {
	   ArrayList expertsInSegment = new ArrayList();
	   try{
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
		   return kolDAOInterface.findKOLReferenceDetails(refIds);
	   }
	   catch (DataAccessException e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException(e.getMessage());
	   }catch(Exception e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException("error.general.manager");
	   }	   	
   }
   
   /**
	* This method gets Nodes for parent Id.  
	* @param parentId
	* @exception ManagerException is thrown in case of problem in execution
	* @return arraylist containing NodeDTO's   
   */
   public ArrayList getNodesForParentId(int parentId) throws ManagerException
   {
	   ArrayList nodesForParentList = new ArrayList();
	   try{
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
		   nodesForParentList = (ArrayList)kolDAOInterface.getNodesForParentId(parentId);
		   return nodesForParentList;			
	   }
	   catch (DataAccessException e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException(e.getMessage());
	   }catch(Exception e){
		   logger.error(e.getLocalizedMessage(), e);
		   throw new ManagerException("error.general.manager");
	   }	
   }

  
   // methods related to KOL Key Messages
 
   
   /**
	* This method fecthes the selected KeyMessage	 	
	* @param keyMessageId	 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing selected KOL Key Message details and all KeyMessages
   */
    
   public ArrayList getKOLKeyMessage(int keyMessageId) throws ManagerException  {
	  
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		  
		  // get the KOL Key Message 
		  return kolDAO.findKOLKeyMessage(keyMessageId);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
   }
   
   /**
	* This method fetches all the KOL Key Messages	 	
	* @param 	 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all KeyMessages
   */
   
   public ArrayList getAllKOLKeyMessage() throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		 //	get all the KOL Key Messages
		 return kolDAO.findAllKOLKeyMessage();		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   
   /**
    * This method adds a new KOL Key Message and fetches back all the KOL Key Messages	 	
    * @param KeyMessageDTO 
    * @exception ManagerException is thrown in case of problem in execution
    * @return ArrayList containing errorCode and all KeyMessages
   */
   
   public ArrayList addKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		 // insert the KOL Key Message and get all the KOL Key Messages.
		 return kolDAO.insertKOLKeyMessage(keyMessageDTO);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   /**
	* This method updates the selected KOL Key Message and fetches back all the KOL Key Messages	 	
	* @param KeyMessageDTO 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all KeyMessages
   */
   
   public ArrayList saveKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  		
		 //	update the KOL Key Message and get all the KOL Key Messages. 
		 return kolDAO.updateKOLKeyMessage(keyMessageDTO);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   /**
	* This method deletes the selected KOL Key Message and fetches back the reamining KOL Key Messages	 	
	* @param keyMessageIds 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all KeyMessages
   */
   
   public ArrayList removeKOLKeyMessage(String keyMessageIds) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
		 //	delete the KOL Key Message and get the remaining KOL Key Messages from database.
		 return kolDAO.deleteKOLKeyMessage(keyMessageIds);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   
   
	// methods related to Tactics
   
   
   /**
	* This method fecthes the selected Tactics detail	 	
	* @param tacticId	 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing selected Tactic details and all Tactics
   */
    
   public ArrayList getTactic(int tacticId) throws ManagerException  {
	  
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		  
		  // get the Tactic 
		  return kolDAO.findTactics(tacticId);		  
	  }
	  catch (DataAccessException e){
	    logger.error(e);
	    throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
	    logger.error(e);
	    throw new ManagerException("error.general.manager", e);
	  }	
   }
   
   /**
	* This method fetches all the Tactics	 	
	* @param 	 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all Tactics
   */
   
   public ArrayList getAllTactics(String ta, String fa, String region) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		 //	get all the Tactics
		 return kolDAO.findAllTactics(ta, fa, region);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   
   /**
	* This method adds a new Tactic and fetches all the available Tactics	 	
	* @param TacticDTO 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all Tactics
   */
   
   public ArrayList addTactic(TacticDTO tacticDTO) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		 // insert the Tactic and get all the Tactics.
		 return kolDAO.insertTactic(tacticDTO);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   /**
	* This method updates the Tactic selected and fetches all the Tactics 	
	* @param KeyMessageDTO 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all Tactics
   */
   
   public ArrayList saveTactic(TacticDTO tacticDTO) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  		
		 //	update the Tactic and get all the Tactics. 
		 return kolDAO.updateTactic(tacticDTO);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   /**
	* This method deletes the selected Tactic and fetches back the reamining Tactics	 	
	* @param tacticIds 
	* @exception ManagerException is thrown in case of problem in execution
	* @return ArrayList containing errorCode and all Tactics
   */
   
   public ArrayList removeTactic(String tacticIds, String ta, String fa, String region) throws ManagerException  {
	
	 try{
		 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
		 //	delete the Tactic and get the remaining Tactics from database.
		 return kolDAO.deleteTactic(tacticIds, ta, fa, region);		  
	 }
	 catch (DataAccessException e){
	   logger.error(e);
	   throw new ManagerException(e.getMessage(), e);
	 }catch(Exception e){
	   logger.error(e);
	   throw new ManagerException("error.general.manager", e);
	 }	
   }
   
   /**
    * This method fetches all the segment details 	 	
    * @param  
    * @exception ManagerException is thrown in case of problem in execution
    * @return ArrayList containing segment details
   */
   
	public ArrayList getAllSegmentWithObjectives() throws ManagerException  {
	
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
		//	get all the segment details.
		return kolDAO.findAllSegmentWithBrandObjectives();		  
	}
	catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	}catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	}	
  }
  
  
  //methods related to Segment Tactics
  
   /**
	 * This method fetches the Segment Tactic Detail	 	
	 * @param segmentTacticId	 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return TacticDTO containing the Segment Tactic Detail.
	*/
   
	public TacticDTO getAllSegmentTacticDetail(int segmentTacticId) throws ManagerException  {
	
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		  //	get the Segment Tactic Detail
		  return kolDAO.findSegementTacticDetail(segmentTacticId);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
	}
   
        
  /**
   * This method fetches all the Segment Tactics	 	
   * @param 	 
   * @exception ManagerException is thrown in case of problem in execution
   * @return ArrayList containing all the Segment Tactics
  */
   
  public ArrayList getAllSegmentTactics(int segmentId) throws ManagerException  {
	
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		//	get all the Segment Tactics
		return kolDAO.findSegementTactics(segmentId);		  
	}
	catch (DataAccessException e){
	  logger.error(e);
	  throw new ManagerException(e.getMessage(), e);
	}catch(Exception e){
	  logger.error(e);
	  throw new ManagerException("error.general.manager", e);
	}	
  }
   
   
  /**
   * This method adds and updates a new Segement Tactic and updates and also fetches all the available Segment Tactics	 	
   * @param TacticDTO
   * @param ArrayList
   * @exception ManagerException is thrown in case of problem in execution
   * @return ArrayList containing errorCode and all Segment Tactics
  */
   
  public ArrayList addNSaveSegmentTactic(int segmentId, TacticDTO segmentTacticDTO, ArrayList segmentTacticList) throws ManagerException  {
	
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		// insert and update the Segment Tactic and get all the updated Segment Tactics.
		ArrayList result = kolDAO.insertNUpdateSegmentTactics(segmentId, segmentTacticDTO, segmentTacticList);
		
		return result;		  
	}
	catch (DataAccessException e){
	  logger.error(e);
	  throw new ManagerException(e.getMessage(), e);
	}catch(Exception e){
	  logger.error(e);
	  throw new ManagerException("error.general.manager", e);
	}	
  }
   
   
  /**
   * This method deletes the selected Segment Tactic and fetches back the remaining Segment Tactics	 	
   * @param tacticIds 
   * @param segmentId
   * @exception ManagerException is thrown in case of problem in execution
   * @return ArrayList containing errorCode and all Segment Tactics
  */
   
  public ArrayList removeSegmentTactic(String segmentTacticIds, int segmentId) throws ManagerException  {
	
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
		//	delete the Segment Tactic and get the remaining Segment Tactics from database.
		return kolDAO.deleteSegmentTactics(segmentTacticIds, segmentId);		  
	}
	catch (DataAccessException e){
	  logger.error(e);
	  throw new ManagerException(e.getMessage(), e);
	}catch(Exception e){
	  logger.error(e);
	  throw new ManagerException("error.general.manager", e);
	}	
  }
  
  
  /**
	 * This method applies the selected Segment Tactic to the Segment Experts	 	
	 * @param tacticId
	 * @param segmentId 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode, all Segment Tactics, and Applied SegmentTactic
	*/
   
	
  
  
  
  public boolean saveStrategy(NodeDTO nodeDTO) throws ManagerException
  {
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
  	
  		return kolDAO.saveStrategy(nodeDTO);  				  
	}
	catch (DataAccessException e){
		logger.error(e.getLocalizedMessage(), e);
		throw new ManagerException(e.getMessage());
	}catch(Exception e){
		logger.error(e.getLocalizedMessage(), e);
		throw new ManagerException("error.general.manager");
	}  	
  }    
   
   public NodeDTO getSegmentInfoForSegmentId(int segmentId) throws ManagerException  {
	try{
		DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
  		return kolDAO.getSegmentInfoForSegmentId(segmentId);		  
	}
	catch (DataAccessException e){
		logger.error(e.getLocalizedMessage(), e);
		throw new ManagerException(e.getMessage());
	}catch(Exception e){
		logger.error(e.getLocalizedMessage(), e);
		throw new ManagerException("error.general.manager");
	}	
  }
 
  public boolean addExpertsToSegment(ArrayList expertIds,int segmentId) throws ManagerException  {
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		  return kolDAO.addExpertsToSegment(expertIds,segmentId);		  
	  }
	  catch (DataAccessException e){
		  logger.error(e.getLocalizedMessage(), e);
		  throw new ManagerException(e.getMessage());
	  }catch(Exception e){
		  logger.error(e.getLocalizedMessage(), e);
		  throw new ManagerException("error.general.manager");
	  }	
  }
  
  /**
	  * This method fetches all the Main Objectives from DB	 	
	  * @param 	 
	  * @exception ManagerException is thrown in case of problem in execution
	  * @return ArrayList containing errorCode and all Tactics
	 */
   
	 public ArrayList getAllMainObjectives() throws ManagerException {	
	   try{
		  
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		   //	get all the Main Objective
		   return kolDAO.getAllMainObjectives();		  
	   }
	   catch (DataAccessException e){
		 logger.error(e);
		 throw new ManagerException(e.getMessage(), e);
	   }catch(Exception e){
		 logger.error(e);
		 throw new ManagerException("error.general.manager", e);
	   }	
	 }	
	 
	 /**
	  * This method fetches all the Main Objectives from DB	 based on filter	
	  * @param 	 
	  * @exception ManagerException is thrown in case of problem in execution
	  * @return ArrayList containing errorCode and all Tactics
	 */
   
	 public ArrayList getAllMainObjectivesOnFilter(String TA,String FA, String region) throws ManagerException {	
	   try{
		  
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		   //	get all the Main Objective
		   return kolDAO.getAllMainObjectivesOnFilter(TA,FA,region);		  
	   }
	   catch (DataAccessException e){
		 logger.error(e);
		 throw new ManagerException(e.getMessage(), e);
	   }catch(Exception e){
		 logger.error(e);
		 throw new ManagerException("error.general.manager", e);
	   }	
	 }	
	 
	public MainObjectiveDTO getMainObjective(int mainObjectiveId) throws ManagerException  {
	  
		  try{
			  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		  
			  // get the Main Objective
			  return kolDAO.findMainObjective(mainObjectiveId);		  
		  }
		  catch (DataAccessException e){
			logger.error(e);
			throw new ManagerException(e.getMessage(), e);
		  }catch(Exception e){
			logger.error(e);
			throw new ManagerException("error.general.manager", e);
		  }	
	   } 
	   
	public void removeMainObjective(String mainObjectiveIds) throws ManagerException  {
	
		 try{
			 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
			 
			 kolDAO.removeMainObjective(mainObjectiveIds);		  
		 }
		 catch (DataAccessException e){
		   logger.error(e);
		   throw new ManagerException(e.getMessage(), e);
		 }catch(Exception e){
		   logger.error(e);
		   throw new ManagerException("error.general.manager", e);
		 }	
	   } 
	   
	 public void addMainObjective(MainObjectiveDTO mainObjectiveDTO) throws ManagerException {
		try{
			 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();

	 
			 kolDAO.addMainObjective(mainObjectiveDTO);		  
		 }
		 catch (DataAccessException e){
		   logger.error(e);
		   throw new ManagerException(e.getMessage(), e);
		 }catch(Exception e){
		   logger.error(e);
		   throw new ManagerException("error.general.manager", e);
		 }
	 	
	 }
	 
	 public void saveMainObjective(MainObjectiveDTO mainObjectiveDTO) throws ManagerException {
		try{
			 DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			 KOLDAOInterface kolDAO = daoFactory.getKOLDAO();

 
			 kolDAO.saveMainObjective(mainObjectiveDTO);		  
			 }
			 catch (DataAccessException e){
			   logger.error(e);
			   throw new ManagerException(e.getMessage(), e);
			 }catch(Exception e){
			   logger.error(e);
			   throw new ManagerException("error.general.manager", e);
			 } 
	 
	 }
	 
	 
	//	methods related to KOL Capability	   
	   
	/**
	 * This method fecthes the selected Capability detail	 	
	 * @param capabilityId	 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing selected Capability details and all Capabilities
	*/
    
	public ArrayList getCapability(int capabilityId) throws ManagerException  {
	  
	   try{
		   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		   KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
		  
		   // get the KOL Capability 
		   return kolDAO.findCapability(capabilityId);		  
	   }
	   catch (DataAccessException e){
		 logger.error(e);
		 throw new ManagerException(e.getMessage(), e);
	   }catch(Exception e){
		 logger.error(e);
		 throw new ManagerException("error.general.manager", e);
	   }	
	}
   
	/**
	 * This method fetches all the Capabilities	 	
	 * @param 	 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode and all Capabilities
	*/
   
	public ArrayList getAllCapabilities(int expertId) throws ManagerException  {
	
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		  //	get all the Capabilities
		  return kolDAO.findAllCapabilities(expertId);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
	}
   
   
	/**
	 * This method adds a new Capability and fetches all the available Capabilities	 	
	 * @param CapabilityDTO 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode and all Capabilities
	*/
   
	public ArrayList addCapability(CapabilityDTO capabilityDTO) throws ManagerException  {
	
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
		  // insert the KOL Capability and get all the Capabilities.
		  return kolDAO.insertCapability(capabilityDTO);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
	}
   
	/**
	 * This method updates the Capability selected and fetches all the Capabilities 	
	 * @param KeyMessageDTO 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode and all Capabilities
	*/
   
	public ArrayList saveCapability(CapabilityDTO capabilityDTO) throws ManagerException  {
	
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  		
		  //	update the Capability and get all the Capabilities. 
		  return kolDAO.updateCapability(capabilityDTO);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
	}
   
	/**
	 * This method deletes the selected Tactic and fetches back the reamining Tactics	 	
	 * @param tacticIds 
	 * @exception ManagerException is thrown in case of problem in execution
	 * @return ArrayList containing errorCode and all Tactics
	*/
   
	public ArrayList removeCapability(String capabilityIds, int expertId) throws ManagerException  {
	
	  try{
		  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
		  KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  	
		  //	delete the Capability and get the remaining Capabilities from database.
		  return kolDAO.deleteCapability(capabilityIds, expertId);		  
	  }
	  catch (DataAccessException e){
		logger.error(e);
		throw new ManagerException(e.getMessage(), e);
	  }catch(Exception e){
		logger.error(e);
		throw new ManagerException("error.general.manager", e);
	  }	
	}
  
   /**
	  * This method fetches all the Tactics applied to KOL	 	
	  * @param 	 
	  * @exception ManagerException is thrown in case of problem in execution
	  * @return ArrayList containing errorCode and all Tactics applied to KOL
	 */
   
		 public ArrayList getAllKOLTactics(int expertId) throws ManagerException  {
	
		   try{
			   DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
			   KOLDAOInterface kolDAO = daoFactory.getKOLDAO();
	  
			   //	get all the Tactics applied to KOL
		   return kolDAO.findKOLTactics(expertId);		  
	   }
	   catch (DataAccessException e){
		 logger.error(e);
		 throw new ManagerException(e.getMessage(), e);
	   }catch(Exception e){
		 logger.error(e);
		 throw new ManagerException("error.general.manager", e);
	   }	
	 }
	 
	 private String getFullPath(String path) {
	   if(!path.endsWith("/")) {
		   return path + "/";
	   }
	   return path;
	 }
	 
	 private String[] getTokens(String stringList, String deLimiter) {
	  	 
		 StringTokenizer strTknizer =  new StringTokenizer(stringList, deLimiter, false);
		 String token = null;
 
		 ArrayList tokensList = new ArrayList(); 
 
		 while(strTknizer.hasMoreTokens()) {
			token = strTknizer.nextToken();
			tokensList.add(token);
		 }
 
		 return (String[]) tokensList.toArray(new String[tokensList.size()]);

	  }
	 
	/**
	  * This method generates the Touch Grpah Node Information 	 	
	  * @param 	 segmentId, filter
	  * @exception ManagerException is thrown in case of problem in execution
	  * @return 
	 */
	
	 
	  
	  /**
	   * 
	   * This method gets Expert List based on the filter Type and filter Value.
	   * @param filterType
	   * @param filter
	   * @param expertList
	   * @return
	   */
	  
	  private ArrayList getFilteredExperts(String filterType, String filter, ArrayList expertList) {
	  	
	  	 ArrayList filteredExpertList = new ArrayList();
	  	 
	  	 for(int i=0; i<expertList.size(); ++i) {
	  	 	MyExpertDTO expertDTO = (MyExpertDTO) expertList.get(i); 
	  	 
			 if("city".equalsIgnoreCase(filterType)) {
		  	 	if(filter.equals(expertDTO.getCity()))
					filteredExpertList.add(expertDTO);		  	 	
		  	 } else if("country".equalsIgnoreCase(filterType)) {
				if(filter.equals(expertDTO.getCountry()))
					filteredExpertList.add(expertDTO);
		  	 	
		  	 } else if("speciality".equalsIgnoreCase(filterType)) {
				if(filter.equals(expertDTO.getSpeciality()))
					filteredExpertList.add(expertDTO);		  	 	
		  	 }
	  	 }
		 return filteredExpertList;
	  }
	  
	  /**
	   * 
	   * This method stores the Touch Graph Node Information to a file. 
	   * @param expertsList
	   * @return 
	   */
	  
	
	 
		
		public NodeDTO getNodeInfo(int segmentId) throws ManagerException {			
			try{
				DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
				KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
				return kolDAOInterface.getNodeInfo(segmentId);							
			}
			catch (DataAccessException e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException(e.getMessage());
			}catch(Exception e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException("error.general.manager");
			}			
		}
		
		public void saveNodeInfo(NodeDTO nodeDTO) throws ManagerException {
			try{
				DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
				KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
				kolDAOInterface.saveNodeInfo(nodeDTO);							
			}
			catch (DataAccessException e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException(e.getMessage());
			}catch(Exception e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException("error.general.manager");
			}			
		}
		public ArrayList getLatestSegmentCriteria(int segmentId) throws ManagerException {
			try{
				DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
				KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
				return kolDAOInterface.getLatestSegmentCriteria(segmentId);							
			}
			catch (DataAccessException e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException(e.getMessage());
			}catch(Exception e){
				logger.error(e.getLocalizedMessage(), e);
				throw new ManagerException("error.general.manager");
			}
			
		}	
		
		 /**
		   * This method gets Segment Criteria.   
		   * @exception ManagerException is thrown in case of problem in execution
		   * @return arraylist of Segment Criteria 
		  */
		   public ArrayList getSegmentCriteria() throws ManagerException
		   {
			  ArrayList segmentCriteriaList = new ArrayList();
			  try{
				  DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
				  KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
				  segmentCriteriaList = (ArrayList)kolDAOInterface.getSegmentCriteria();
				  return segmentCriteriaList;			
			  }
			  catch (DataAccessException e){
				  logger.error(e.getLocalizedMessage(), e);
				  throw new ManagerException(e.getMessage());
			  }catch(Exception e){
				  logger.error(e.getLocalizedMessage(), e);
				  throw new ManagerException("error.general.manager");
			  }	
		   }

    public HashMap getMatchedTaFaRegion(long userId) throws ManagerException {
        try {
            DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
            return kolDAOInterface.getMatchedTaFaRegion(userId);
        }
        catch (DataAccessException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new ManagerException(e.getMessage());
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new ManagerException("error.general.manager");
        }
    }

    public ArrayList getMyTacticList(String staffId) throws ManagerException {
            try {
                DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
                KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
                return kolDAOInterface.getMyTacticList(staffId);
            }
            catch (DataAccessException e) {
                logger.error(e.getLocalizedMessage(), e);
                throw new ManagerException(e.getMessage());
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage(), e);
                throw new ManagerException("error.general.manager");
            }
        }
    public boolean isExists(String planId, long expertId) throws ManagerException {
                try {
                    DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
                    KOLDAOInterface kolDAOInterface = daoFactory.getKOLDAO();
                    return kolDAOInterface.isExists(planId,expertId);
                }
                catch (DataAccessException e) {
                    logger.error(e.getLocalizedMessage(), e);
                    throw new ManagerException(e.getMessage());
                } catch (Exception e) {
                    logger.error(e.getLocalizedMessage(), e);
                    throw new ManagerException("error.general.manager");
                }
            }


}