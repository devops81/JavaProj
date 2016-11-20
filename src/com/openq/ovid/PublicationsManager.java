package com.openq.ovid;

import java.util.ArrayList;
import java.util.TreeMap;

import org.apache.log4j.Logger;
import com.openq.kol.DataAccessFactory;
import com.openq.kol.ManagerException;
import com.openq.kol.DataAccessException;
import com.openq.kol.SearchDTO;


public class PublicationsManager {

    private static Logger logger =Logger.getLogger(PublicationsManager.class);

    public SearchDTO getOVIDAuthor(int authorId) throws ManagerException {
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.getOVIDAuthor(authorId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }

    public ArrayList getUniqueIdentifier(int authorId) throws ManagerException {
         try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.getUniqueIdentifier(authorId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }      

    public ArrayList refreshProfiles() throws ManagerException {
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.refreshProfiles();
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }

    public void resetTimerState() throws ManagerException {
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            prefDAO.resetTimerState();
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }

    public void populateUncommitedPublications(ArrayList attributes) throws ManagerException {
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            prefDAO.populateUncommitedPublications(attributes);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }
    }

    public ArrayList showNewPubs(int authorId) throws ManagerException {
         try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.showNewPubs(authorId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }

    public String[] getAbstract(String expId, String uniqueId) throws ManagerException {
         try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.getAbstract(expId,uniqueId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }

    }

    public void updateOvidScheduleDetails(String startTime,String startDate,String days) throws ManagerException{
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            prefDAO.updateOvidScheduleDetails(startTime,startDate,days);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }
    }

    public String[] getOvidScheduleDetails() throws ManagerException{
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            return prefDAO.getOvidScheduleDetails();
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }
    }

    public void deletePublication(String uniqueId) throws ManagerException{
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            prefDAO.deletePublication(uniqueId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }
    }

     public void deleteCommittedPublication(String uniqueId) throws ManagerException{
        try{
            DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
            PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

            prefDAO.deleteCommittedPublication(uniqueId);
        }
        catch (DataAccessException e){
            logger.debug(e.getMessage());
            throw new ManagerException(e.getMessage());
        }catch(Exception e){
            logger.debug(e.getMessage());
            throw new ManagerException("error.general.manager");
        }
    }

     public void logPubException(int authorId,int build){
         try{
             DataAccessFactory  daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
             PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();

             prefDAO.logPubException(authorId,build);
         }
         catch (DataAccessException e){
             logger.debug(e.getMessage());
         }catch(Exception e){
             logger.debug(e.getMessage());
         }
     }

    public ArrayList getMatchingAuthorList() throws ManagerException {
            try {

                DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
                PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();
                return prefDAO.getMatchingAuthorList();

            } catch (DataAccessException e) {
                logger.debug(e.getMessage());
                throw new ManagerException(e.getMessage());
            } catch (Exception e) {
                logger.debug(e.getMessage());
                throw new ManagerException("error.general.manager");
            }
    }

    public ArrayList getPublications(TreeMap pubMap) throws ManagerException {
            try {

                DataAccessFactory daoFactory = DataAccessFactory.getDAOFactory(DataAccessFactory.ORACLE);
                PublicationsDAOInterface prefDAO = daoFactory.getPublicationsDAO();
                return prefDAO.getPublications(pubMap);

            } catch (DataAccessException e) {
                logger.debug(e.getMessage());
                throw new ManagerException(e.getMessage());
            } catch (Exception e) {
                logger.debug(e.getMessage());
                throw new ManagerException("error.general.manager");
            }
    }

}//end of class
