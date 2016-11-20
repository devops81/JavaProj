package com.openq.ovid;

import com.openq.kol.DataAccessException;
import com.openq.kol.SearchDTO;

import java.util.ArrayList;
import java.util.TreeMap;


public interface PublicationsDAOInterface {

    public SearchDTO getOVIDAuthor(int authorId) throws DataAccessException;

    public ArrayList getUniqueIdentifier(int authorId) throws DataAccessException;      

    public ArrayList refreshProfiles() throws DataAccessException;

    public void populateUncommitedPublications(ArrayList attributes) throws DataAccessException;

    public ArrayList showNewPubs(int authorId) throws DataAccessException;

    public String[] getAbstract(String expId,String uniqueId) throws DataAccessException;

    public void updateOvidScheduleDetails(String startTime,String startDate,String days) throws DataAccessException;

    public String[] getOvidScheduleDetails() throws DataAccessException;
    
    public void deletePublication(String pubId) throws DataAccessException;
    
    public void deleteCommittedPublication(String uniqueId) throws DataAccessException;
    
    public void resetTimerState() throws DataAccessException;
    
    public void logPubException(int authorId,int build) throws DataAccessException;

    public ArrayList getMatchingAuthorList() throws DataAccessException;

    public ArrayList getPublications(TreeMap pubMap) throws DataAccessException;
}
