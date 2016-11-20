package com.openq.kol;

import java.sql.Connection;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;


/**
 * 
 * File : InteractionsDAOInterface.java

 * Purpose : 
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

public interface InteractionsDAOInterface {


    public void addDevPlan(InteractionsDTO interactionsDTO, long[] expertIds) throws DataAccessException;
    public void addDevPlan(InteractionsDTO interactionsDTO) throws DataAccessException;

    public List getDevPlanHistory(int devPlanId) throws DataAccessException;

    public InteractionsDTO getDevPlanDetails(int devPlanId) throws DataAccessException;

    public void addDevPlanHistory(InteractionsDTO interactionsDTO , int planID , Connection con ) throws  DataAccessException;

    public ArrayList getAllDevPlans(int expertId) throws DataAccessException;

    public void deleteDevPlan(String devPlanId[])throws DataAccessException;

    public void updateDevPlan(int devPlanId, InteractionsDTO interactionsForm) throws DataAccessException;

    public void saveDevPaln(String[] interactions,long userId, String[] kolIdArr,String userName,String staffId, Date intDate) throws DataAccessException;

   public void saveInteractionTactics(long interactionId, String[] interactions) throws DataAccessException;
} 
