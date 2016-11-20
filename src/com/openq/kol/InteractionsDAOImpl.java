package com.openq.kol;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Calendar;

import org.apache.log4j.Logger;
import com.openq.web.ActionKeys;

/**
* File : InteractionsDAOImpl.java

* Purpose : This class is to interact with the interactions_table 
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

public class InteractionsDAOImpl implements InteractionsDAOInterface {

    private static Logger logger = Logger.getLogger(InteractionsDAOImpl.class);

    /**
     * This method gets the details of a given development plan
     * @param devPlanId
     * @return InteractionsDTO
     * @throws DataAccessException
     */  
     
    public InteractionsDTO getDevPlanDetails(int devPlanId) throws DataAccessException {

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {

            InteractionsDTO interactionsDTO = null;

            con = DBUtil.getInstance().createConnection();

            //Query
            // SELECT PLAN_ID, YEAR, TRIMESTER, ACTIVITY, ROLE, OUTCOME, USER_ID, STRATEGY FROM KOL_DEVELOPMENT_PLAN WHERE PLAN_ID = ?

            String query = "SELECT PLAN_ID, ACTIVITY, KT.TACTIC_NAME ,ROLE, STAFFID, USER_ID,STATUS,THERAPY, to_char(DUE_DATE,'MM/dd/yyyy') as due_date ,OWNER FROM KOL_DEVELOPMENT_PLAN , KOL_TACTICS KT  WHERE PLAN_ID = ? AND  TO_CHAR(KT.TACTIC_ID) =ACTIVITY";
                    //QueryUtil.getInstance().getQuery("DEV_PLAN.DETAILS.SELECT");
            stmt = con.prepareStatement(query);

            stmt.setInt(1, devPlanId);

            rs = stmt.executeQuery();

            while(rs.next()){

                interactionsDTO = new InteractionsDTO();

                interactionsDTO.setDevPlanId(rs.getInt("PLAN_ID"));
                interactionsDTO.setActivity(rs.getString("TACTIC_NAME"));
                interactionsDTO.setRole(rs.getString("ROLE"));
                interactionsDTO.setUserId(rs.getInt("USER_ID"));
                interactionsDTO.setStatus( rs.getString("STATUS"));
                interactionsDTO.setTherapy(rs.getString("THERAPY") );
                interactionsDTO.setDueDate(rs.getString("DUE_DATE"));
                interactionsDTO.setOwner(rs.getString("OWNER"));
                interactionsDTO.setStaffId(rs.getString("STAFFID"));
            }

            return interactionsDTO;

        }
        catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        }
        catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, stmt, rs);
        }

    }

    /**
     * This method adds a development plan history of an Expert
     * @param interactionsDTO
     * @throws DataAccessException
     */
    public void addDevPlanHistory(InteractionsDTO interactionsDTO , int planID , Connection con ) throws DataAccessException
    {
        PreparedStatement stmt = null;
        try
        {
            con.setAutoCommit(false);
            //USER_ID - User , who is updating development plan for Expert
            //EXPERT_ID	- Expert for whoom - development plan being created
            //Query
            String query = "INSERT INTO KOL_DEVELOPMENT_PLAN_HISTORY (USER_ID, PLAN_ID, UPDATE_TIME, STATUS) VALUES( ?, ?, ?, ?) ";
            stmt = con.prepareStatement(query);
            stmt.setInt(1, interactionsDTO.getUserId()  );
            stmt.setInt(2, planID  );
            stmt.setTimestamp( 3, new Timestamp( new Date().getTime()  ) );
            stmt.setString(4, interactionsDTO.getStatus()  );
            stmt.executeUpdate();
            con.commit();
        }
        catch (SQLException sqle) {
            logger.debug(sqle.getMessage());
            try {
                con.rollback();
            } catch (Exception e) {logger.error(e.getLocalizedMessage(), e);}
            throw new DataAccessException("error.db.access");
        }
        catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {logger.error(ex.getLocalizedMessage(), ex);}
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(null, stmt, null);
        }
    }


    /**
     * This method adds a development plan
     * @param interactionsDTO
     * @throws DataAccessException
     */
    public void addDevPlan(InteractionsDTO interactionsDTO, long[] expertIds) throws DataAccessException {

        Connection 			con 	= null;

        PreparedStatement 	stmt 	= null;
        PreparedStatement insertStmt = null;

        ResultSet 			rs 		= null;

        int 				planID  = -1;

        try
        {
            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);
                       
            //Query
           /* INSERT INTO KOL_DEVELOPMENT_PLAN
            (PLAN_ID  ,ACTIVITY,ROLE,CREATE_TIME,UPDATE_TIME,USER_ID,EXPERT_ID,STRATEGY ,DUE_DATE,owner,staffid) VALUES
            ((SELECT NVL(MAX(PLAN_ID),0)+1 FROM KOL_DEVELOPMENT_PLAN),?  ,?   ,SYSDATE    ,SYSDATE    ,?  ,? ,? ,  ?  )
			*/

            String query = QueryUtil.getInstance().getQuery("DEV_PLAN.INSERT");
            String selectQuery = null;

            insertStmt = con.prepareStatement(query);

            for(int i=0; i<expertIds.length; ++i) {
                 if (expertIds[i] != 0){
                insertStmt.setString(1, interactionsDTO.getActivity());
                insertStmt.setString(2, interactionsDTO.getRole());
                insertStmt.setInt(3, interactionsDTO.getUserId());
                insertStmt.setLong(4, (long)expertIds[i]);
                insertStmt.setString(5, interactionsDTO.getTherapy());
                insertStmt.setString(6,interactionsDTO.getStatus());
                SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
                Date date = sdf.parse(interactionsDTO.getDueDate());

                insertStmt.setDate(7, new java.sql.Date(date.getTime()));
                insertStmt.setString(8,interactionsDTO.getOwner());
                insertStmt.setString(9,interactionsDTO.getStaffId());
                insertStmt.setString(10, interactionsDTO.getComment());     

                insertStmt.executeUpdate();

                selectQuery = "SELECT MAX(PLAN_ID) AS PLAN_ID FROM KOL_DEVELOPMENT_PLAN WHERE ACTIVITY = ?";
                stmt = con.prepareStatement(selectQuery);
                stmt.setString(1, interactionsDTO.getActivity()  );
                ///
                //Get  the new
                rs = stmt.executeQuery();
                while( rs.next() )
                {
                    planID = rs.getInt( "PLAN_ID");
                }
                // Add history
                this.addDevPlanHistory( interactionsDTO , planID , con );
                stmt.close();
              }
            }

            con.commit();

        }
        catch (SQLException sqle) {
            //sqle.printStackTrace();
            logger.error(sqle.getLocalizedMessage(), sqle);
            try {
                con.rollback();
            } catch (Exception e) {}

            throw new DataAccessException("error.db.access");

        }
        catch (Exception e){
            logger.debug(e.getMessage() , e);
            try {
                con.rollback();
            } catch (Exception ex) {}
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, insertStmt, null);
        }

    }

    /**
     * This method gets the development plan status history
     * @param devPlanId
     * @return List - list of statues for
     * @throws DataAccessException
     */
    public List getDevPlanHistory( int devPlanId ) throws DataAccessException
    {

        Connection 			con 	= null;
        PreparedStatement 	stmt 	= null;
        ResultSet 			rs 		= null;
        try
        {
            List planHistoryList 	= new ArrayList();
            con = DBUtil.getInstance().createConnection();
            String query = "SELECT STATUS, FIRSTNAME || ' ' || LASTNAME AS NAME , SUBSTR(TO_CHAR (KDPH.UPDATE_TIME) ,0, 9) AS UPDATE_TIME FROM KOL_DEVELOPMENT_PLAN_HISTORY  KDPH,USER_TABLE UT WHERE KDPH.USER_ID = UT.ID AND KDPH.PLAN_ID = ?";

            stmt = con.prepareStatement(query);
            stmt.setInt(1, devPlanId);
            rs = stmt.executeQuery();
            while(rs.next())
            {
                StringBuffer buffer = new StringBuffer();
                buffer.append(rs.getString("STATUS")).append(" - ");
                buffer.append(rs.getString("NAME")).append(" ");
                //buffer.append(rs.getString("UPDATE_TIME")).append(" < ");
                buffer.append(rs.getString("UPDATE_TIME")).append(" ");
                planHistoryList.add( buffer.toString()  );
            }
            return planHistoryList;
        }
        catch (SQLException e) {
            logger.debug(e.getMessage() , e);
            throw new DataAccessException("error.db.access");
        }
        catch (Exception e){
            logger.debug(e.getMessage() , e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, stmt,rs);
        }
    }

    private float parseCostString(String planCost) {
        try {
            NumberFormat nf = NumberFormat.getCurrencyInstance();
            return nf.parse(planCost).floatValue();
        } catch(ParseException pe) {
        }
        try {
            NumberFormat nf = NumberFormat.getInstance();
            return nf.parse(planCost).floatValue();
        }catch(ParseException pe) {
        }
        return 0;
    }

    /**
     * This method lists all development plans
     * @param expertId
     * @return ArrayList
     * @throws DataAccessException
     */
    public ArrayList getAllDevPlans(int expertId) throws DataAccessException {

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        PreparedStatement stmt1 = null;
        ResultSet rs1 = null;

        try {

            ArrayList devPlansList = new ArrayList();

            con = DBUtil.getInstance().createConnection();

            //Query
            // SELECT PLAN_ID, YEAR, TRIMESTER, ACTIVITY, ROLE, OUTCOME, USER_ID, STRATEGY FROM KOL_DEVELOPMENT_PLAN WHERE EXPERT_ID = ?

            StringBuffer sb = new StringBuffer();
                    //QueryUtil.getInstance().getQuery("GET.ALL.DEV_PLANS");
            /*sb.append("SELECT ");
            sb.append(" DISTINCT K.PLAN_ID, ");
            sb.append(" K.ACTIVITY, KT.TACTIC_NAME, ");
            sb.append(" K.ROLE, ");
            sb.append(" K.STATUS, ");
            sb.append(" TO_CHAR( K.DUE_DATE, 'MM/dd/yyyy') AS DUE_DATE, ");
            sb.append(" K.THERAPY, ");
            sb.append(" K.OWNER, ");
            sb.append(" K.USER_ID, ");
            sb.append(" K.STRATEGY, ");
            sb.append(" P.OPTVALUE AS ROLENAME, ");
            sb.append(" Q.OPTVALUE AS STATUSNAME, ");
            sb.append(" O.OPTVALUE AS THERAPYNAME ");
            sb.append(" FROM KOL_DEVELOPMENT_PLAN K, OPTION_LOOKUP O, OPTION_LOOKUP P,OPTION_LOOKUP Q ,KOL_TACTICS KT ");
            sb.append(" WHERE O.ID = K.THERAPY ");
            sb.append(" AND P.ID = K.ROLE ");
            sb.append(" AND Q.ID= K.STATUS ");
            sb.append(" AND K.EXPERT_ID =? AND TO_CHAR(KT.TACTIC_ID)=K.ACTIVITY ");
            sb.append(" UNION ");
            sb.append(" SELECT ");
            sb.append(" DISTINCT K.PLAN_ID, ");
            sb.append(" K.ACTIVITY,  KT.TACTIC_NAME, ");
            sb.append(" K.ROLE, ");
            sb.append(" K.STATUS, ");
            sb.append(" TO_CHAR( K.DUE_DATE, 'MM/dd/yyyy') AS DUE_DATE, ");
            sb.append(" K.THERAPY, ");
            sb.append(" K.OWNER, ");
            sb.append(" K.USER_ID, ");
            sb.append(" K.STRATEGY, ");
            sb.append(" P.OPTVALUE AS ROLENAME, ");
            sb.append(" '' AS STATUSNAME, ");
            sb.append(" '' AS THERAPYNAME ");
            sb.append(" FROM KOL_DEVELOPMENT_PLAN K, OPTION_LOOKUP O, OPTION_LOOKUP P,OPTION_LOOKUP Q ,KOL_TACTICS KT ");
            sb.append(" WHERE P.ID = K.ROLE ");
            sb.append(" AND K.EXPERT_ID =?  AND TO_CHAR(KT.TACTIC_ID)=K.ACTIVITY ");
            sb.append(" AND K.PLAN_ID NOT IN ");
            sb.append(" ( ");
            sb.append("    SELECT DISTINCT K.PLAN_ID ");
            sb.append("    FROM KOL_DEVELOPMENT_PLAN K, OPTION_LOOKUP O, OPTION_LOOKUP P,OPTION_LOOKUP Q ");
            sb.append("    WHERE O.ID = K.THERAPY ");
            sb.append("    AND P.ID = K.ROLE ");
            sb.append("    AND Q.ID= K.STATUS ");
            sb.append("    AND K.EXPERT_ID =? ");
            sb.append(" ) ");
*/

            sb.append("SELECT ");
            sb.append(" DISTINCT K.PLAN_ID, K.COMMENTS, ");
            sb.append(" K.ACTIVITY, KT.TACTIC_NAME, ");
            sb.append(" K.ROLE, ");
            sb.append(" K.STATUS, ");
            sb.append(" TO_CHAR( K.DUE_DATE, 'MM/dd/yyyy') AS DUE_DATE, ");
            sb.append(" K.THERAPY, ");
            sb.append(" K.OWNER, ");
            sb.append(" K.USER_ID, ");
            sb.append(" K.STRATEGY, K.STAFFID, ");
            sb.append(" P.OPTVALUE AS ROLENAME, ");
            sb.append(" Q.OPTVALUE AS STATUSNAME, ");
            sb.append(" O.OPTVALUE AS THERAPYNAME ");
            sb.append(" FROM KOL_DEVELOPMENT_PLAN K, OPTION_LOOKUP O, OPTION_LOOKUP P,OPTION_LOOKUP Q ,KOL_TACTICS KT ");
            sb.append(" WHERE O.ID(+) = K.THERAPY ");
            sb.append(" AND P.ID(+) = K.ROLE ");
            sb.append(" AND Q.ID(+)= K.STATUS ");
            sb.append(" AND K.EXPERT_ID =? AND TO_CHAR(KT.TACTIC_ID)=K.ACTIVITY ");

            stmt = con.prepareStatement(sb.toString());

            stmt.setInt(1, expertId);
          /*  stmt.setInt(2, expertId);
            stmt.setInt(3, expertId);*/


            rs = stmt.executeQuery();

            while(rs.next()){

                InteractionsDTO interactionsDTO = new InteractionsDTO();

                interactionsDTO.setDevPlanId(rs.getInt("PLAN_ID"));
                interactionsDTO.setActivityId(rs.getString("ACTIVITY") );
                interactionsDTO.setActivity(rs.getString("TACTIC_NAME"));
                interactionsDTO.setRole(rs.getString("ROLE"));
                interactionsDTO.setRoleName(rs.getString("ROLENAME"));
                interactionsDTO.setTherapy(rs.getString("THERAPY"));
                interactionsDTO.setStatus(rs.getString("STATUS"));
                interactionsDTO.setStatusName(rs.getString("STATUSNAME"));
                interactionsDTO.setTherapyName(rs.getString("THERAPYNAME"));
                interactionsDTO.setOwner(rs.getString("OWNER"));
                interactionsDTO.setDueDate(rs.getString("DUE_DATE"));
                interactionsDTO.setUserId(rs.getInt("USER_ID"));
                interactionsDTO.setStrategy(rs.getString("STRATEGY"));
                interactionsDTO.setStaffId(rs.getString("STAFFID"));
                interactionsDTO.setComment(rs.getString("COMMENTS"));
                if(interactionsDTO.getStaffId() != null && !"".equals(interactionsDTO.getStaffId())) {
                    sb = new StringBuffer("");
                    sb.append("SELECT ID FROM USER_TABLE WHERE STAFFID=?");

                    stmt1 = con.prepareStatement(sb.toString());
                    stmt1.setString(1,interactionsDTO.getStaffId());

                    rs1 = stmt1.executeQuery();
                    while(rs1.next()) {
                        interactionsDTO.setAmgenOwnerUserId(rs1.getString("ID"));
                    }
                    rs1.close();
                    stmt1.close();
                }

                devPlansList.add(interactionsDTO);

            }

            return devPlansList;

        }
        catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        }
        catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            e.printStackTrace();
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, stmt,rs);
        }

    }

    /**
    * This method deletes development plan
    * @param devPlanIds
    * @throws DataAccessException
    */
    public void deleteDevPlan(String[] devPlanIds) throws DataAccessException {

        Connection con = null;
        PreparedStatement stmt = null;

        try {

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            // DELETE FROM KOL_DEVELOPMENT_PLAN WHERE PLAN_ID = ?
            String query = QueryUtil.getInstance().getQuery("DEV_PLAN.DELETE");
            stmt = con.prepareStatement(query);

            for (int i = 0; i < devPlanIds.length; i++) {

                stmt.setInt(1, Integer.parseInt(devPlanIds[i]));
                stmt.executeUpdate();

            }

            con.commit();

        }
        catch (SQLException sqle) {

            logger.debug(sqle.getMessage());
            try {
                con.rollback();
            } catch (Exception e) {
            }
            throw new DataAccessException("error.db.access");

        }
        catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {}
            throw new DataAccessException("error.general.dao");

        }
        finally {
            DBUtil.getInstance().closeDBResources(con, stmt, null);
        }
    }

    /**
     * This method adds a development plan
     * @param interactionsForm
     * @throws DataAccessException
     */
    public void addDevPlan(InteractionsDTO interactionsForm) throws DataAccessException {

        Connection 			con 	= null;
        PreparedStatement 	stmt 	= null;
        ResultSet 			rs 		= null;
        int 				planID  = -1;
        try
        {
            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);
            //Query
          /* INSERT INTO KOL_DEVELOPMENT_PLAN (PLAN_ID,  ACTIVITY, ROLE,  CREATE_TIME,UPDATE_TIME,
            USER_ID, EXPERT_ID, THERAPY, STATUS,DUE_DATE,OWNER,staffid) VALUES
            ((SELECT NVL(MAX(PLAN_ID),0)+1 FROM KOL_DEVELOPMENT_PLAN), ?, ?, SYSDATE, SYSDATE,?, ?, ?,?,?,?)*/
            String query = QueryUtil.getInstance().getQuery("DEV_PLAN.INSERT");
            stmt = con.prepareStatement(query);


            stmt.setString(1, interactionsForm.getActivity());
            stmt.setString(2, interactionsForm.getRole());
            stmt.setInt(3, interactionsForm.getUserId());
            stmt.setLong(4, interactionsForm.getExpertId());
            stmt.setString(5, interactionsForm.getTherapy());
            stmt.setString(6, interactionsForm.getStatus());

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
            Date date = sdf.parse(interactionsForm.getDueDate());

            stmt.setDate(7, new java.sql.Date(date.getTime()));
            stmt.setString(8,interactionsForm.getOwner());
            stmt.setString(9,interactionsForm.getStaffId());
            stmt.setString(10,interactionsForm.getComment());

            stmt.executeUpdate();
            stmt.clearParameters();
            stmt.close();

            query = "SELECT MAX(PLAN_ID) AS PLAN_ID FROM KOL_DEVELOPMENT_PLAN WHERE ACTIVITY = ?";
            stmt = con.prepareStatement(query);
            stmt.setString(1, interactionsForm.getActivity()  );
            ///
            //Get  the new
            rs = stmt.executeQuery();
            while( rs.next() )
            {
                planID = rs.getInt( "PLAN_ID");
            }
            // Add history
            this.addDevPlanHistory( interactionsForm , planID , con );

            con.commit();

        }
        catch (SQLException sqle) {

            logger.error(sqle.getLocalizedMessage(), sqle);
            try {
                con.rollback();
            } catch (Exception e) {logger.error(e.getLocalizedMessage(), e);}

            throw new DataAccessException("error.db.access");

        }
        catch (Exception e){
        	logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {logger.error(ex.getLocalizedMessage(), ex);}
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, stmt, null);
        }

    }

    /**
     * This method updates a development plan
     * @param interactionsForm
     * @throws DataAccessException
     */
    public void updateDevPlan(int devPlanId,InteractionsDTO interactionsForm) throws DataAccessException {

        Connection con = null;
        PreparedStatement stmt = null;

        try {

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            //Query
            /*UPDATE KOL_DEVELOPMENT_PLAN SET  ACTIVITY = ?, ROLE = ?,  UPDATE_TIME = SYSDATE,
            STATUS = ? ,THERAPY=?, DUE_DATE=? ,OWNER=?,COMMENTS=? WHERE PLAN_ID = ?*/

            String query = QueryUtil.getInstance().getQuery("DEV_PLAN.UPDATE");
            stmt = con.prepareStatement(query);

            stmt.setString(1, interactionsForm.getActivity());
            stmt.setString(2, interactionsForm.getRole());
            stmt.setString(3, interactionsForm.getStatus());
            stmt.setString(4, interactionsForm.getTherapy());

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
            Date date = sdf.parse(interactionsForm.getDueDate());

            stmt.setDate(5, new java.sql.Date(date.getTime()));
            stmt.setString(6, interactionsForm.getOwner());
            stmt.setString(7, interactionsForm.getStaffId());
            stmt.setString(8, interactionsForm.getComment());
            stmt.setInt(9, devPlanId);
            
            stmt.executeUpdate();

            // Add history
            this.addDevPlanHistory( interactionsForm , devPlanId , con);

            con.commit();

        }
        catch (SQLException sqle) {
        	
            logger.error(sqle.getLocalizedMessage(), sqle);
            try {
                con.rollback();
            } catch (Exception e) {logger.error(e.getLocalizedMessage(), e);}

            throw new DataAccessException("error.db.access");


        }
        catch (Exception e){
        	logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {logger.error(ex.getLocalizedMessage(), ex);}
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, stmt, null);
        }
    }

    public void saveDevPaln(String[] interactions, long userId, String[] kolIdArr,String userName,String staffId,Date intDate) throws DataAccessException {

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {

            con = DBUtil.getInstance().createConnection();
            if (interactions != null && interactions.length > 0 && kolIdArr != null && kolIdArr.length > 0) {
                String interaction = null;
                String selQuery = null;
                String updateQuery = null;
                String insertQuery = null;
                String activity = null;
                String[] strArr = null;
                String kolId = null;

                for (int i = 0; i < interactions.length; i++) {
                    interaction = interactions[i];
                    if (interaction.indexOf("_") != -1) {
                        strArr = interaction.split("_");
                        if (strArr != null && strArr.length > 1) {
                            activity = strArr[0];
                            for (int k = 0; k < kolIdArr.length; k++) {
                                kolId = kolIdArr[k];
                                if (null != kolId && !"".equals(kolId) && activity != null && !"".equals(activity)) {
                                    selQuery = "SELECT PLAN_ID FROM KOL_DEVELOPMENT_PLAN WHERE EXPERT_ID=? AND ACTIVITY='" + activity + "'";
                                    pstmt = con.prepareStatement(selQuery);
                                    pstmt.setLong(1, Long.parseLong(kolId));

                                    rs = pstmt.executeQuery();
                                    int planId = -1;
                                    while (rs.next()) {
                                        planId = rs.getInt("PLAN_ID");
                                    }
                                    rs.close();
                                    pstmt.close();

                                    if (planId != -1 && strArr[1] != null && !"".equals(strArr[1])) {
                                        updateQuery = "UPDATE KOL_DEVELOPMENT_PLAN SET STATUS=? , OWNER=? ,STAFFID=?, DUE_DATE=?, USER_ID=? WHERE EXPERT_ID=? AND ACTIVITY='" + activity + "'";
                                        pstmt = con.prepareStatement(updateQuery);
                                        pstmt.setString(1,strArr[1]);
                                        pstmt.setString(2,userName);
                                        if(staffId != null && !"".equals(staffId)) {
                                            pstmt.setLong(3,Long.parseLong(staffId));
                                        } else {
                                            pstmt.setLong(3,0);
                                        }

                                        pstmt.setDate(4,new java.sql.Date(intDate.getTime()));
                                        pstmt.setLong(5, userId);
                                        pstmt.setLong(6, Long.parseLong(kolId));

                                        pstmt.executeUpdate();

                                    } else if (planId == -1 && strArr[1] != null && !"".equals(strArr[1])) {
                                        insertQuery = "INSERT INTO KOL_DEVELOPMENT_PLAN (PLAN_ID,USER_ID,ACTIVITY," +
                                                "CREATE_TIME,UPDATE_TIME,EXPERT_ID,STATUS,OWNER,STAFFID,DUE_DATE) " +
                                                "VALUES ((SELECT NVL(MAX(PLAN_ID),0)+1 FROM KOL_DEVELOPMENT_PLAN),?,?,SYSDATE,SYSDATE,?,?,?,?,?)";
                                        pstmt = con.prepareStatement(insertQuery);
                                        pstmt.setLong(1, userId);
                                        pstmt.setString(2, activity);
                                        pstmt.setLong(3, Long.parseLong(kolId));
                                        pstmt.setString(4, strArr[1]);
                                        pstmt.setString(5, userName);
                                        if(staffId != null && !"".equals(staffId)) {
                                            pstmt.setLong(6,Long.parseLong(staffId));
                                        } else {
                                            pstmt.setLong(6,0);
                                        }
                                        pstmt.setDate(7,new java.sql.Date(intDate.getTime()));
                                        pstmt.executeUpdate();

                                    }

                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
        	logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {logger.error(ex.getLocalizedMessage(), ex);
            }
            throw new DataAccessException("error.general.dao");
        }
        finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }

    }
    ////////////// Development Plan

    // saves Planned interactions in Interaction_tactics table.

    public void saveInteractionTactics(long interactionId, String[] interactions) throws DataAccessException {

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {

            con = DBUtil.getInstance().createConnection();
            if (interactions != null && interactions.length > 0 ) {
                String interaction = null;
                String delQuery = null;
                String updateQuery = null;
                String insertQuery = null;
                String activity = null;
                String[] strArr = null;
                String kolId = null;

                delQuery = "DELETE FROM INTERACTION_TACTICS WHERE INTERACTION_ID=" + interactionId;
                pstmt = con.prepareStatement(delQuery);
                rs = pstmt.executeQuery();
                rs.close();
                pstmt.close();
                for (int i = 0; i < interactions.length; i++) {
                    interaction = interactions[i];
                    if (interaction.indexOf("_") != -1) {
                        strArr = interaction.split("_");
                        if (strArr != null && strArr.length > 1) {
                            activity = strArr[0];


                            if (strArr[1] != null && !"".equals(strArr[1])) {

                                insertQuery = "INSERT INTO INTERACTION_TACTICS (ID,INTERACTION_ID,TACTIC_ID,STATUS_ID) VALUES" +
                                        "((SELECT NVL(MAX(ID),0)+1 FROM INTERACTION_TACTICS), ?,?,? )";
                                pstmt = con.prepareStatement(insertQuery);
                                
                                pstmt.setLong(1, interactionId);
                                pstmt.setLong(2, Long.parseLong(activity));
                                pstmt.setLong(3, Long.parseLong(strArr[1]));
                                pstmt.executeUpdate();
                            }


                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
            try {
                con.rollback();
            } catch (Exception ex) {
            }
            throw new DataAccessException("error.general.dao");
        }
        finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }


    }






} 
