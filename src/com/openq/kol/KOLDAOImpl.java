/*
 * KOLDAOImpl
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

package com.openq.kol;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.IOException;

import org.apache.log4j.Logger;
import com.openq.web.ActionKeys;


public class KOLDAOImpl implements KOLDAOInterface {

    private static Logger logger = Logger.getLogger(KOLDAOImpl.class);
    public static final String CALENDAR_DATE_FORMAT = "MM/dd/yyyy";

    /**
      * This method gets data of all the nodes in tree.
      * @param
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing Node or Segment Info.
     */
    public ArrayList getSegmentTree() throws DataAccessException
    {
        ArrayList resultList = new ArrayList();
        ArrayList segmentList = new ArrayList();
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        int i = 0;
        try {
            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL_GET_SEGMENT_TREE");
            statement = connection.createStatement();
            resultSet = (ResultSet)statement.executeQuery(query);
            while (resultSet.next())
            {
             NodeDTO nodeDTO = new NodeDTO();
             nodeDTO.setParentName(resultSet.getString("NAME"));
             nodeDTO.setDescription(resultSet.getString("DESCRIPTION"));
             nodeDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
             nodeDTO.setParentId(resultSet.getInt("PARENT_ID"));
             nodeDTO.setCreatedBy(resultSet.getString("LASTNAME")+", "+resultSet.getString("FIRSTNAME"));
             nodeDTO.setCreatedDate(resultSet.getString("CREATE_DATE"));
             nodeDTO.setStrategyLevel(resultSet.getString("STRATEGY_LEVEL"));
             nodeDTO.setTaId(resultSet.getString("TA"));
             nodeDTO.setFaId(resultSet.getString("FA"));
             nodeDTO.setRegionId(resultSet.getString("REGION"));

             SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);
             String nodeCreationDate = "";
             if (resultSet.getString("CREATE_DATE") != null) {
                nodeCreationDate = sdf.format(resultSet.getDate("CREATE_DATE")).toString();
             }
             nodeDTO.setCreatedDate(nodeCreationDate);

             segmentList.add(nodeDTO);
            }
            statement.close();
            resultSet.close();

            StringBuffer hirarchyQuery = new StringBuffer();
            hirarchyQuery.append("SELECT SEGMENT_ID, NAME SEGMENT_NAME, (SELECT SEGMENT_ID FROM");
            hirarchyQuery.append(" SEGMENT S2 WHERE S2.SEGMENT_ID=S1.PARENT_ID) AS PARENT_ID,");
            hirarchyQuery.append("(SELECT NAME FROM SEGMENT S2 WHERE S2.SEGMENT_ID=S1.PARENT_ID)");
            hirarchyQuery.append("AS PARENT_NAME FROM SEGMENT S1 START WITH SEGMENT_ID IN");
            hirarchyQuery.append("(SELECT SEGMENT_ID FROM SEGMENT WHERE PARENT_ID=0)");
            hirarchyQuery.append("CONNECT BY PRIOR SEGMENT_ID=PARENT_ID");

            statement = connection.createStatement();
            resultSet = (ResultSet)statement.executeQuery(hirarchyQuery.toString());
            ArrayList hirarchyList = new ArrayList();
            while(resultSet.next()) {
                NodeDTO hirarchyNodeDTO = new NodeDTO();
                if(resultSet.getString("PARENT_NAME") != null && !"".equals(resultSet.getString("PARENT_NAME"))) {
                    hirarchyNodeDTO.setParentName(resultSet.getString("PARENT_NAME"));
                }
                if(resultSet.getString("SEGMENT_NAME") != null && !"".equals(resultSet.getString("SEGMENT_NAME"))) {
                    hirarchyNodeDTO.setSegmentName(resultSet.getString("SEGMENT_NAME"));
                }
                hirarchyNodeDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                hirarchyNodeDTO.setParentId(resultSet.getInt("PARENT_ID"));

                hirarchyList.add(hirarchyNodeDTO);
            }
            TreeMap hirarchyMap = getHirarchyMap(hirarchyList);
            resultList.add(0,segmentList);
            resultList.add(1,hirarchyMap);
        } catch (SQLException e) {
            logger.error("SQLException in getSegmentTree", e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error("Exception in getSegmentTree", e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, statement,resultSet);
        }
        return resultList;
    }

    private TreeMap getHirarchyMap(ArrayList hirarchyList) {
        TreeMap hirarchyMap = new TreeMap();
        String resultHirarchy = "";
        if(hirarchyList != null && hirarchyList.size() > 0) {
            for(int i=0;i<hirarchyList.size();i++) {

                NodeDTO hirarchyNodeDTO = (NodeDTO) hirarchyList.get(i);
                if(hirarchyNodeDTO != null) {
                    int segmentId = hirarchyNodeDTO.getSegmentId();
                    int parentId = hirarchyNodeDTO.getParentId();
                    String parentName = hirarchyNodeDTO.getParentName();
                    String segmentName = hirarchyNodeDTO.getSegmentName();

                    if(parentId == 0) {
                        hirarchyMap.put(new Integer(segmentId),segmentName);
                    } else {
                        resultHirarchy = getHirarchyStr("",hirarchyNodeDTO,hirarchyList);
                        if(resultHirarchy != null && !resultHirarchy.equals("")) {

                            String subS = resultHirarchy.substring(0,2);
                            int len = resultHirarchy.length();
                            if(subS.equals(" > ")) {
                                resultHirarchy = resultHirarchy.substring(2,len);
                            }
                            if(resultHirarchy.endsWith(" > ")) {
                                resultHirarchy = resultHirarchy.substring(0,len-2);
                            }
                            hirarchyMap.put(new Integer(segmentId),resultHirarchy);
                       }
                    }
                 }
            }
        }
        return hirarchyMap;
    }

    private String getHirarchyStr(String resultHirarchy,NodeDTO hirarchyNodeDTO,ArrayList hirarchyList) {
        int segmentId = hirarchyNodeDTO.getSegmentId();
        int parentId = hirarchyNodeDTO.getParentId();
        String parentName = hirarchyNodeDTO.getParentName();
        String segmentName = hirarchyNodeDTO.getSegmentName();
        if(resultHirarchy != null && !resultHirarchy.equals("")) {
            StringTokenizer st = new StringTokenizer(resultHirarchy, ">");
            while (st.hasMoreTokens()) {
                if(((st.nextToken()).trim()).equals(segmentName.trim())) {
                    segmentName = "";
                    break;
                }
            }
        }


        if(segmentName != null) {

            if("".equals(segmentName)) {
                resultHirarchy = parentName+" > "+resultHirarchy;
            } else {
                resultHirarchy = parentName+" > "+segmentName+" > "+resultHirarchy;
            }
        }
        for(int i=0;i<hirarchyList.size();i++) {
            NodeDTO nodeDTO = (NodeDTO) hirarchyList.get(i);
            if(parentId == nodeDTO.getSegmentId()) {
                if(nodeDTO.getParentId() == 0) {
                    return resultHirarchy;
                } else {
                    resultHirarchy = getHirarchyStr(resultHirarchy,nodeDTO,hirarchyList);
                }
            }
        }
        return resultHirarchy;
    }


    /**
      * This method used to delete experts in particular segment
      * @param experts , segmentId
      * @exception DataAccessException is thrown in case of problem in execution
      * @return boolean
     */
    public boolean deleteExpertsFromSegment(String [] experts,int segmentId) throws DataAccessException
    {
        Connection connection = null;
        PreparedStatement prepstatement = null;
        ResultSet resultSet = null;
        boolean deleteflag = false;

        try {
            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL_DELETE_EXPERTS_IN_SEGMENT");
            prepstatement = connection.prepareStatement(query);
            connection.setAutoCommit(false);
            for (int i=0;i<experts.length;i++){
                prepstatement.setInt(1,segmentId);
                prepstatement.setInt(2,Integer.parseInt(experts[i]));
                int j = (int) prepstatement.executeUpdate();
                if (j == 0) {
                    deleteflag = false;
                    break;
                }
                else {
                    deleteflag = true;
                }
            }
            if (deleteflag == false) {
                connection.rollback();
                connection.setAutoCommit(true);
            }else{
                connection.commit();
                connection.setAutoCommit(true);
            }
            return deleteflag;
        } catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, prepstatement,resultSet);
        }
    }

    /**
      * This method used to add Node or segment to the tree in KOL Strategy.
      * @param nodeDTO
      * @exception DataAccessException is thrown in case of problem in execution
      * @return boolean for adding node.
     */
    public boolean addNode(NodeDTO nodeDTO) throws DataAccessException
    {
        boolean flagAddNode = false;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        int i = 0;
        try {
            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL_ADD_SEGMENT");
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1,nodeDTO.getParentId());
            preparedStatement.setString(2,nodeDTO.getParentName());
            preparedStatement.setString(3,nodeDTO.getDescription());
            preparedStatement.setInt(4,Integer.parseInt(nodeDTO.getCreatedBy()));
            preparedStatement.setString(5,nodeDTO.getStrategyLevel());
            preparedStatement.setString(6,nodeDTO.getTaId());
            preparedStatement.setString(7,nodeDTO.getFaId());
            preparedStatement.setString(8,nodeDTO.getRegionId());


            i = preparedStatement.executeUpdate();


            if (i == 0) {                                 
             flagAddNode = false;
            }
            else {
              flagAddNode = true;
            }
        } catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, preparedStatement,resultSet);
        }
        return flagAddNode;
    }

    /**
      * This method used to delete Node or segment from the tree in KOL Strategy.
      * @param nodeIds
      * @exception DataAccessException is thrown in case of problem in execution
      * @return boolean for deleting node.
     */
    public boolean deleteNode(String[] nodeIds) throws DataAccessException {

        boolean flagDeleteNode = false;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String nodeIdString = "";

        try {

            connection = DBUtil.getInstance().createConnection();
            connection.setAutoCommit(false);

            for(int j = 0; j< nodeIds.length; j++) {
                if(j == 0) {
                    nodeIdString = nodeIds[j];
                } else {
                    nodeIdString = nodeIds[j] + " , " + nodeIdString;
                }
            }

            //delete from segment_tactis
            String query = "DELETE FROM SEGMENT_TACTICS WHERE SEGMENT_ID IN ( "+nodeIdString+" )";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.executeQuery();
            preparedStatement.close();
            // end of delete from segment_tactis

            // delete from segment_criteria
            /*query = "DELETE FROM SEGMENT_CRITERIA WHERE SEGMENT_ID IN ( "+nodeIdString+" )";
               preparedStatement = connection.prepareStatement(query);
               preparedStatement.executeQuery();
               preparedStatement.close();*/
            // end of delete from segment_criteria

            // delete from segment_experts
            query = "DELETE FROM SEGMENT_EXPERTS WHERE SEGMENT_ID IN ( "+nodeIdString+" )";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.executeQuery();
            preparedStatement.close();
            // end of delete from segment_experts

            query = "DELETE FROM SEGMENT WHERE SEGMENT_ID IN ( "+nodeIdString+" ) OR PARENT_ID IN ( "+nodeIdString+" )";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.executeQuery();
            flagDeleteNode = true;

            connection.commit();

            return flagDeleteNode;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException e1) {
                logger.error("SQLException in RollBack", e1);
                throw new DataAccessException("error.db.access");
            }
            logger.error("SQLException in deleteNode", e);
            throw new DataAccessException("error.db.access");
        } catch (Exception e){
            try {
                connection.rollback();
            } catch (SQLException e1) {
                logger.error("SQLException in RollBack", e1);
                throw new DataAccessException("error.db.access");
            }
            logger.error("Exception in deleteNode", e);
            throw new DataAccessException("error.general.dao");
        }
        finally {
            DBUtil.getInstance().closeDBResources(connection, preparedStatement, resultSet);
        }

    }


    /**
      * This method used to get expert details for Touch Graph  based on the expertIds.
      * @param expertIds
      * @exception DataAccessException is thrown in case of problem in execution
      * @return arrayList of experts
     */
    public ArrayList getExpertsForTG(String expertIds) throws DataAccessException
    {
      ArrayList expertWithSpeciatity = new ArrayList();
      Connection connection = null;
      Statement statement = null;
      ResultSet resultSet = null;
      PreparedStatement preparedStatmentNoSpec =null;

      try {
         connection = DBUtil.getInstance().createConnection();

         StringBuffer tgQuery = new StringBuffer();

         tgQuery.append("SELECT A.ID,A.FIRSTNAME,A.LASTNAME,A.LATITUDE,A.LONGITUDE,A.INFLUENCE_LEVEL,");
         tgQuery.append(" A.REFERENCE, B.ATTRIBUTE_VALUE AS SPECIALITY,D.CITY,D.STATE,D.COUNTRY,D.ZIP,");
         tgQuery.append(" D.PHONE FROM USER_TABLE A, USER_ATTRIBUTE_TRANSACTION B ,");
         tgQuery.append(" USER_ADDRESS D WHERE A.ID IN (").append(expertIds).append(")");
         tgQuery.append(" AND A.ID=B.ID AND A.ID = D.ID AND B.USER_ATT_ID =1 UNION SELECT A.ID,");
         tgQuery.append(" A.FIRSTNAME,A.LASTNAME,A.LATITUDE,A.LONGITUDE,A.INFLUENCE_LEVEL,A.REFERENCE,' ' AS SPECIALITY,");
         tgQuery.append(" D.CITY,D.STATE,D.COUNTRY,D.ZIP,D.PHONE FROM USER_TABLE A,USER_ADDRESS D WHERE A.ID IN");
         tgQuery.append("(").append(expertIds).append(") AND A.ID = D.ID");
         tgQuery.append(" AND A.ID NOT IN (SELECT A.ID FROM USER_TABLE A, USER_ATTRIBUTE_TRANSACTION B WHERE A.ID IN");
         tgQuery.append(" (").append(expertIds).append(") AND A.ID=B.ID AND B.USER_ATT_ID =1)");

         PreparedStatement preparedStatement = connection.prepareStatement(tgQuery.toString());


         resultSet = (ResultSet)preparedStatement.executeQuery();
         while (resultSet.next())
         {
           MyExpertDTO myExpertDTO = new MyExpertDTO();
           myExpertDTO.setExpertId(resultSet.getInt("ID"));

           myExpertDTO.setFirstName(resultSet.getString("FIRSTNAME"));
           myExpertDTO.setLastName(resultSet.getString("LASTNAME"));

           myExpertDTO.setExpertName(myExpertDTO.getFirstName()+","+myExpertDTO.getLastName());

           myExpertDTO.setLatitude(resultSet.getFloat("LATITUDE"));
           myExpertDTO.setLongitude(resultSet.getFloat("LONGITUDE"));
           myExpertDTO.setInfluenceLevel(resultSet.getInt("INFLUENCE_LEVEL"));
           myExpertDTO.setSpeciality(resultSet.getString("SPECIALITY"));
           myExpertDTO.setPhone(resultSet.getString("PHONE"));

           myExpertDTO.setCity(resultSet.getString("CITY"));
           myExpertDTO.setState(resultSet.getString("STATE"));
           myExpertDTO.setCountry(resultSet.getString("COUNTRY"));
           myExpertDTO.setZip(resultSet.getString("ZIP"));

           myExpertDTO.setReference(resultSet.getString("REFERENCE"));

           expertWithSpeciatity.add(myExpertDTO);
         }
         resultSet.close();
         preparedStatement.close();

      } catch (SQLException ex) {
          logger.debug(ex.getMessage());
          throw new DataAccessException("error.db.access");
      }catch (Exception e){
          logger.error(e.getLocalizedMessage(), e);
          throw new DataAccessException("error.general.dao");
      }
      finally{
          DBUtil.getInstance().closeDBResources(connection, preparedStatmentNoSpec,resultSet);
      }
      return expertWithSpeciatity;
    }

    /**
      * This method used to get experts based on the segmentId.
      * @param segmentId
      * @exception DataAccessException is thrown in case of problem in execution
      * @return arrayList of experts
     */
    public ArrayList getExpertsForSegmentId(int segmentId) throws DataAccessException
    {

      ArrayList expertWithSpeciatity = new ArrayList();
      Connection connection = null;
      ResultSet resultSet = null;
      PreparedStatement preparedStatmentNoSpec =null;

      try {
         connection = DBUtil.getInstance().createConnection();
         //String query = QueryUtil.getInstance().getQuery("KOL_GET_EXPERTS_FOR_SEGMENT");
          StringBuffer sb = new StringBuffer("");
         /* sb.append("SELECT ");
          sb.append("A.ID, ");
          sb.append("A.FIRSTNAME, ");
          sb.append("A.LASTNAME, ");
          sb.append("A.LATITUDE, ");
          sb.append("A.LONGITUDE, ");
          sb.append("A.INFLUENCELEVEL, ");
          sb.append("A.REFERENCE, ");
          sb.append("B.ATTRIBUTE_VALUE AS SPECIALITY, ");
          sb.append("D.CITY, ");
          sb.append("D.STATE_LOOKUP_ID, ");
          sb.append("D.COUNTRY_LOOKUP_ID, ");
          sb.append("D.ZIP, ");
          sb.append("D.PHONENUMBER ");
          sb.append("FROM USER_TABLE A, USER_ATTRIBUTE_TRANSACTION B ,USER_ADDRESS D ");
          sb.append("WHERE A.ID IN (SELECT EXPERT_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = ?) ");
          sb.append("AND A.ID=B.USER_ID ");
          sb.append("AND A.ID = D.ID ");
          sb.append("AND B.USER_ATT_ID =1 ");
          sb.append("UNION ");
          sb.append("SELECT ");
          sb.append("A.ID, ");
          sb.append("A.FIRSTNAME, ");
          sb.append("A.LASTNAME, ");
          sb.append("A.LATITUDE, ");
          sb.append("A.LONGITUDE, ");
          sb.append("A.INFLUENCELEVEL, ");
          sb.append("A.REFERENCE, ");
          sb.append("' ' AS SPECIALITY, ");
          sb.append("D.CITY, ");
          sb.append("D.STATE_LOOKUP_ID, ");
          sb.append("D.COUNTRY_LOOKUP_ID, ");
          sb.append("D.ZIP, ");
          sb.append("D.PHONENUMBER ");
          sb.append("FROM USER_TABLE A,USER_ADDRESS D ");
          sb.append("WHERE A.ID IN (SELECT EXPERT_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = ?) ");
          sb.append("AND A.ID = D.ID ");
          sb.append("AND A.ID NOT IN ");
          sb.append("( ");
          sb.append("   SELECT ");
          sb.append("   A.ID ");
          sb.append("   FROM USER_TABLE A, USER_ATTRIBUTE_TRANSACTION B ");
          sb.append("   WHERE A.ID IN (SELECT EXPERT_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = ?) ");
          sb.append("   AND A.ID=B.USER_ID ");
          sb.append("   AND B.USER_ATT_ID =1 ");
          sb.append(") ");*/
          sb.append(" SELECT u.id,");
          sb.append(" u.firstname,");
          sb.append(" u.lastname,");
          sb.append(" u.latitude,");
          sb.append(" u.longitude,");
          sb.append(" u.influencelevel,");
          sb.append(" u.speciality,");
          sb.append(" u.phone,");
          sb.append(" u.kolid,");
          sb.append(" u.reference,");
        // sb.append(" o.optvalue AS state,");
        // sb.append(" p.optvalue AS country,");
        //  sb.append(" a.city,");
        //  sb.append(" a.zip");
          sb.append(" u.location");
          sb.append(" FROM user_table u ");
        //sb.append(" user_address a,");
        //  sb.append(" option_lookup o,");
        //  sb.append(" option_lookup p");
        //  sb.append(" WHERE u.address_id = a.id");
       //   sb.append(" AND o.id = a.state_lookup_id");
       //   sb.append(" AND p.id = a.country_lookup_id");
          sb.append(" WHERE u.id IN");
          sb.append(" (SELECT expert_id");
          sb.append(" FROM segment_experts");
          sb.append(" WHERE segment_id = ?)");



         PreparedStatement preparedStatement = connection.prepareStatement(sb.toString());

         preparedStatement.setInt(1,segmentId);
         //preparedStatement.setInt(2,segmentId);
         //preparedStatement.setInt(3,segmentId);

         resultSet = (ResultSet)preparedStatement.executeQuery();

         //MyExpertDTO myExpertDTO = new MyExpertDTO();
         while (resultSet.next())
         {
             MyExpertDTO myExpertDTO = new MyExpertDTO();
           myExpertDTO.setExpertId(resultSet.getInt("ID"));

           myExpertDTO.setFirstName(resultSet.getString("FIRSTNAME"));
           myExpertDTO.setLastName(resultSet.getString("LASTNAME"));

           myExpertDTO.setExpertName(myExpertDTO.getLastName()+", "+myExpertDTO.getFirstName());

           myExpertDTO.setLatitude(resultSet.getFloat("LATITUDE"));
           myExpertDTO.setLongitude(resultSet.getFloat("LONGITUDE"));
           myExpertDTO.setInfluenceLevel(resultSet.getInt("INFLUENCELEVEL"));
           myExpertDTO.setSpeciality(resultSet.getString("SPECIALITY"));
           myExpertDTO.setPhone(resultSet.getString("PHONE"));
           myExpertDTO.setKolId(resultSet.getString("KOLID"));
           //myExpertDTO.setCity(resultSet.getString("CITY"));
           //myExpertDTO.setState(resultSet.getString("STATE"));
           //myExpertDTO.setCountry(resultSet.getString("COUNTRY"));
           //myExpertDTO.setZip(resultSet.getString("ZIP"));
           myExpertDTO.setLocation(resultSet.getString("LOCATION"));
           myExpertDTO.setReference(resultSet.getString("REFERENCE"));

           expertWithSpeciatity.add(myExpertDTO);

         }
         resultSet.close();
         preparedStatement.close();

      } catch (SQLException ex) {
          logger.debug(ex.getMessage());
          throw new DataAccessException("error.db.access");
      }catch (Exception e){
          logger.error(e.getLocalizedMessage(), e);
          throw new DataAccessException("error.general.dao");
      }
      finally{
          DBUtil.getInstance().closeDBResources(connection, preparedStatmentNoSpec,resultSet);
      }
      return expertWithSpeciatity;
    }

    /**
      * This method used to get nodes or segments based on parent Id.
      * @param parentId
      * @exception DataAccessException is thrown in case of problem in execution
      * @return arrayList of Nodes or segment.
     */
    public ArrayList getNodesForParentId(int parentId) throws DataAccessException
    {
        ArrayList segmentList = new ArrayList();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        int i = 0;
        try {
            connection = DBUtil.getInstance().createConnection();

            String query = QueryUtil.getInstance().getQuery("KOL_GET_NODES_FOR_PARENTID");
            preparedStatement = connection.prepareStatement(query);

            preparedStatement.setInt(1,parentId);
            preparedStatement.setInt(2,parentId);
            preparedStatement.setInt(3,parentId);
            preparedStatement.setInt(4,parentId);
            preparedStatement.setInt(5,parentId);

            resultSet = preparedStatement.executeQuery();

            int temp = -1;
            while (resultSet.next()) {

                if (temp != resultSet.getInt("SEGMENT_ID")) {

                    NodeDTO nodeDTO = new NodeDTO();
                    nodeDTO.setParentName(resultSet.getString("NAME"));
                    nodeDTO.setDescription(resultSet.getString("DESCRIPTION"));
                    nodeDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                    nodeDTO.setParentId(resultSet.getInt("PARENT_ID"));
                    nodeDTO.setStrategyLevel(resultSet.getString("STRATEGY_LEVEL"));
                    nodeDTO.setCreatedBy(resultSet.getString("LASTNAME")+", "+resultSet.getString("FIRSTNAME"));
                    nodeDTO.setCreatedDate(resultSet.getString("CREATE_DATE"));
                    nodeDTO.setCreatorId(resultSet.getInt("CREATED_BY"));
                    nodeDTO.setTaId(resultSet.getString("TA"));
                    nodeDTO.setFaId(resultSet.getString("FA"));
                    nodeDTO.setRegionId(resultSet.getString("REGION"));

                    SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);
                    String nodeCreationDate = "";
                    if (resultSet.getString("CREATE_DATE") != null) {
                        nodeCreationDate = sdf.format(resultSet.getDate("CREATE_DATE")).toString();
                    }
                    nodeDTO.setCreatedDate(nodeCreationDate);
                    if (resultSet.getString("CHILD_ID") != null) {
                        nodeDTO.setChildPresent("YES");
                    }
                     segmentList.add(nodeDTO);

                    temp = resultSet.getInt("SEGMENT_ID");
                } else {
                     continue;
                }
            }

            return segmentList;

        } catch (SQLException e) {
            logger.debug("SQLException in getNodesForParentId", e);
            throw new DataAccessException("error.db.access");
        } catch (Exception e){
            logger.debug("Exception in getNodesForParentId", e);
            throw new DataAccessException("error.general.dao");
        } finally {
            DBUtil.getInstance().closeDBResources(connection, preparedStatement, resultSet);
        }

    }

    /**
      * This method used to get segment criteria
      * @param
      * @exception DataAccessException is thrown in case of problem in execution
      * @return arrayList of SegmentCriteriaDTO's
     */


    // methods related to KOL Key Messages

    /**
     * This method finds the KeyMessage Details from the database based on keyMessageId
     * @param keyMessageId
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing selected KeyMessage and the list of Key Messages
    */

    public ArrayList findKOLKeyMessage(int keyMessageId) throws DataAccessException {

        KeyMessageDTO keyMessageDTO = null;
        KeyMessageDTO tempKeyMsgDTO = null;

        ArrayList keyMessageList = new ArrayList();
        ArrayList result = new ArrayList();

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        try {

            con = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL.KEYMESSAGE.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, keyMessageId);

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            resultSet = prepStmt.executeQuery();

            if(resultSet.next()) {

                keyMessageDTO = new KeyMessageDTO();

                keyMessageDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                keyMessageDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                keyMessageDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));

                Date msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    keyMessageDTO.setKeyMessageDate(sdf.format(msgDate));

                keyMessageDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));
            }

            prepStmt.close();

            // fetch all KOL Key Messages
            query = QueryUtil.getInstance().getQuery("KOL.ALL_KEYMESSAGE.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                tempKeyMsgDTO = new KeyMessageDTO();

                tempKeyMsgDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                tempKeyMsgDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                tempKeyMsgDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));
                Date msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    tempKeyMsgDTO.setKeyMessageDate(sdf.format(msgDate));

                tempKeyMsgDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));

                keyMessageList.add(tempKeyMsgDTO);
            }

            con.commit();

            result.add(0, keyMessageDTO);
            result.add(1, keyMessageList);

            return result;


        } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
        }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
        }
        finally{
            DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
        }
    }


    /**
     * This method finds all the KeyMessage Details from the database
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing errorCode and all KeyMessages
    */

    public ArrayList findAllKOLKeyMessage() throws DataAccessException {

        ArrayList keyMessageList = new ArrayList();

        KeyMessageDTO keyMessageDTO = null;

        Connection connection = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        try {

            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL.ALL_KEYMESSAGE.INFO.SELECT");

            prepStmt = connection.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            while(resultSet.next()) {

                keyMessageDTO = new KeyMessageDTO();

                keyMessageDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                keyMessageDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                keyMessageDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));

                Date msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    keyMessageDTO.setKeyMessageDate(sdf.format(msgDate));

                keyMessageDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));


                keyMessageList.add(keyMessageDTO);
            }

            return keyMessageList;

        } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
        }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
        }
    }

    /**
     * This method inserts the new KeyMessage into database and fetches back all the KOL Key Messages from the database
     * @param KeyMessageDTO
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing errorCode and all KeyMessages
    */

    public ArrayList insertKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        int errorCode = 0;

        ArrayList keyMessageList = new ArrayList();
        KeyMessageDTO keyMsgDTO = null;

        ArrayList result = new ArrayList();
        java.sql.Date msgDate = null;

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            String query = QueryUtil.getInstance().getQuery("KOL.KEYMESSAGE.INFO.INSERT");

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            StringBuffer kolMsgQuery = new StringBuffer();

            kolMsgQuery.append("INSERT INTO KOL_KEY_MESSAGE (KEY_MESSAGE_ID, KEY_MESSAGE_NAME, MARKET_CLAIMS,");
            kolMsgQuery.append(" KEY_MESSAGE_DATE, MARKET_CLAIMS_DESC, CREATE_TIME) VALUES ((SELECT NVL(MAX(KEY_MESSAGE_ID),0)+1 ");
            kolMsgQuery.append(" FROM KOL_KEY_MESSAGE),'").append(keyMessageDTO.getKeyMessageName()).append("',");
            kolMsgQuery.append("'").append(keyMessageDTO.getMarketClaims()).append("',");
            if(keyMessageDTO.getKeyMessageDate() != null)
                kolMsgQuery.append("TO_DATE('").append(keyMessageDTO.getKeyMessageDate()).append("', 'mm/dd/yyyy')");
            else
                kolMsgQuery.append("TO_DATE(").append(keyMessageDTO.getKeyMessageDate()).append(", 'mm/dd/yyyy')");
            kolMsgQuery.append(",'").append(keyMessageDTO.getMarketClaimsDesc()).append("', SYSDATE)");

            Statement stmt = con.createStatement();


            try{

                stmt.executeUpdate(kolMsgQuery.toString());

            }catch(SQLException se){
                logger.error("Failed to insert KOL key message", se);
                if(1 == se.getErrorCode())
                {
                    try
                    {
                        con.rollback();
                    }
                    catch(Exception e){}

                }
                errorCode = se.getErrorCode();
            }
            stmt.close();
            con.commit();

            // fetch all KOL Key Messages
            query = QueryUtil.getInstance().getQuery("KOL.ALL_KEYMESSAGE.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                keyMsgDTO = new KeyMessageDTO();

                keyMsgDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                keyMsgDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                keyMsgDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));
                msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    keyMsgDTO.setKeyMessageDate(sdf.format(msgDate));
                keyMsgDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));

                keyMessageList.add(keyMsgDTO);
            }

            con.commit();

            result.add(0, errorCode+"");
            result.add(1, keyMessageList);

            return result;

        } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
        }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
        }finally{
            DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
        }
    }


    /**
     * This method updates the selected KeyMessage and fetches back all the KOL Key Messages from the database
     * @param KeyMessageDTO
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing errorCode and all KeyMessages
    */

    public ArrayList updateKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        int errorCode = 0;
        ArrayList keyMessageList = new ArrayList();
        KeyMessageDTO keyMsgDTO = null;

        ArrayList result = new ArrayList();

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            String query = QueryUtil.getInstance().getQuery("KOL.KEYMESSAGE.INFO.UPDATE");

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            prepStmt = con.prepareStatement(query);

            prepStmt.setString(1, keyMessageDTO.getKeyMessageName());
            prepStmt.setString(2, keyMessageDTO.getMarketClaims());

            java.sql.Date msgDate = null;

            if(keyMessageDTO.getKeyMessageDate() != null)
                msgDate = new java.sql.Date((sdf.parse(keyMessageDTO.getKeyMessageDate())).getTime());

            prepStmt.setDate(3, msgDate);
            prepStmt.setString(4, keyMessageDTO.getMarketClaimsDesc());

            prepStmt.setInt(5, keyMessageDTO.getKeyMessageId());

            // update the selected KOL Key Message
            try{

                prepStmt.executeUpdate();

            }catch(SQLException se){
                logger.error("Failed to update KOL key message", se);
                if(1 == se.getErrorCode())
                {
                    try
                    {
                        con.rollback();
                    }
                    catch(Exception e){}

                }
                errorCode = se.getErrorCode();
            }

            prepStmt.close();
            con.commit();

            // fetch all KOL Key Messages
            query = QueryUtil.getInstance().getQuery("KOL.ALL_KEYMESSAGE.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                keyMsgDTO = new KeyMessageDTO();

                keyMsgDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                keyMsgDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                keyMsgDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));

                msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    keyMsgDTO.setKeyMessageDate(sdf.format(msgDate));

                keyMsgDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));

                keyMessageList.add(keyMsgDTO);
            }

            result.add(0, errorCode+"");
            result.add(1, keyMessageList);

            con.commit();
            return result;

        } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
        }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
        }finally{
            DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
        }
    }


    /**
     * This method deletes the selected KeyMessage and fetches back the remaining KOL Key Messages from the database
     * @param KeyMessageDTO
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing errorCode and all KeyMessages
    */

    public ArrayList deleteKOLKeyMessage(String keyMessageIds) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        ArrayList keyMessageList = new ArrayList();
        KeyMessageDTO keyMessageDTO = null;

        ArrayList result = new ArrayList();

        int errorCode = 0;

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            // delete the selected KOL Key Messages
            StringBuffer deleteQuery = new StringBuffer();
            deleteQuery.append("DELETE FROM KOL_KEY_MESSAGE WHERE KEY_MESSAGE_ID IN (").append(keyMessageIds).append(")");

            prepStmt = con.prepareStatement(deleteQuery.toString());

            try{

                prepStmt.executeUpdate();

            }catch(SQLException se){
                logger.error("Failed to delete KOL key message(s)", se);
                if(1 == se.getErrorCode())
                {
                    try
                    {
                        con.rollback();
                    }
                    catch(Exception e){}

                }
                errorCode = se.getErrorCode();
            }
            prepStmt.close();

            // fetch remaining KOL Key Messages
            String query = QueryUtil.getInstance().getQuery("KOL.ALL_KEYMESSAGE.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                keyMessageDTO = new KeyMessageDTO();

                keyMessageDTO.setKeyMessageId(resultSet.getInt("KEY_MESSAGE_ID"));
                keyMessageDTO.setKeyMessageName(resultSet.getString("KEY_MESSAGE_NAME"));
                keyMessageDTO.setMarketClaims(resultSet.getString("MARKET_CLAIMS"));
                Date msgDate = resultSet.getDate("KEY_MESSAGE_DATE");

                if(msgDate != null)
                    keyMessageDTO.setKeyMessageDate(sdf.format(msgDate));

                keyMessageDTO.setMarketClaimsDesc(resultSet.getString("MARKET_CLAIMS_DESC"));

                keyMessageList.add(keyMessageDTO);
            }

            con.commit();

            result.add(0, errorCode+"");
            result.add(1, keyMessageList);

            return result;

        } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
        }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
        }finally{
            DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
        }
    }


     /**
      * This method finds the Tactic Details from the database based on tacticId
      * @param tacticId
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing selected Tactic and the list of Tactics
     */

     public ArrayList findTactics(int tacticId) throws DataAccessException {

         TacticDTO tacticDTO = null;
         TacticDTO tempTacticDTO = null;

         ArrayList tacticList = new ArrayList();
         ArrayList result = new ArrayList();

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         try {

             con = DBUtil.getInstance().createConnection();
             String query = QueryUtil.getInstance().getQuery("KOL.TACTICS.INFO.SELECT");

             prepStmt = con.prepareStatement(query);
             prepStmt.setInt(1, tacticId);

             // SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

             resultSet = prepStmt.executeQuery();

             if(resultSet.next()) {

                 tacticDTO = new TacticDTO();

                 tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                 tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                 /*
                     Date tacticDate = resultSet.getDate("TACTIC_DATE");

                     if(tacticDate != null) {
                        tacticDTO.setTacticDate(sdf.format(tacticDate));

                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(tacticDate);

                        tacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                     }
                     */

                 tacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));
                 tacticDTO.setFA(resultSet.getString("FA"));
                 tacticDTO.setTA(resultSet.getString("TA"));
                 tacticDTO.setRegion(resultSet.getString("REGION"));
                 tacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                 tacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));
             }

             prepStmt.close();

             // fetch all KOL tactics
             query = QueryUtil.getInstance().getQuery("KOL.ALL_TACTICS.INFO.SELECT");

             prepStmt = con.prepareStatement(query);

             prepStmt.setString(1, tacticDTO.getTA());
             prepStmt.setString(2, tacticDTO.getFA());
             prepStmt.setString(3, tacticDTO.getRegion());

             resultSet = prepStmt.executeQuery();

             while(resultSet.next()) {

                 tempTacticDTO = new  TacticDTO();

                 tempTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                 tempTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                 /*
                     Date tacticDate = resultSet.getDate("TACTIC_DATE");


                     if(tacticDate != null) {
                        tempTacticDTO.setTacticDate(sdf.format(tacticDate));

                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(tacticDate);

                        tempTacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                     }
                     */

                 tempTacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));
                 tempTacticDTO.setFA(resultSet.getString("FA"));
                 tempTacticDTO.setTA(resultSet.getString("TA"));
                 tempTacticDTO.setRegion(resultSet.getString("REGION"));
                 tempTacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                 tempTacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));

                 tacticList.add(tempTacticDTO);
             }

             con.commit();

             result.add(0, tacticDTO);
             result.add(1, tacticList);

             return result;


         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
     }


     /**
      * This method finds all the Tactic Details from the database
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing errorCode and all Tactics
     */

     public ArrayList findAllTactics(String ta, String fa, String region) throws DataAccessException {

         TacticDTO tacticDTO = null;
         ArrayList tacticList = new ArrayList();

         Connection connection = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         try {

             connection = DBUtil.getInstance().createConnection();
             String query = QueryUtil.getInstance().getQuery("KOL.ALL_TACTICS.INFO.SELECT");

             prepStmt = connection.prepareStatement(query);
             prepStmt.setString(1, ta);
             prepStmt.setString(2, fa);
             prepStmt.setString(3, region);

             resultSet = prepStmt.executeQuery();

             // SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

             while(resultSet.next()) {

                tacticDTO = new  TacticDTO();
                tacticDTO.setActivity(resultSet.getString("ACTIVITY"));
                tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                tacticDTO.setFA(resultSet.getString("FA"));
                tacticDTO.setTA(resultSet.getString("TA"));
                tacticDTO.setRegion(resultSet.getString("REGION"));
                tacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                tacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));

                /*
                    Date tacticDate = resultSet.getDate("TACTIC_DATE");

                    if(tacticDate != null) {
                       tacticDTO.setTacticDate(sdf.format(tacticDate));

                       Calendar calendar = Calendar.getInstance();
                       calendar.setTime(tacticDate);

                       tacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                     }
                    */

                tacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));

                tacticList.add(tacticDTO);
             }

                 Collections.sort(tacticList, new Comparator() {
                public int compare(Object o1, Object o2) {
                    TacticDTO ob1 = (TacticDTO)o1;
                    TacticDTO ob2 = (TacticDTO)o2;
                    return ob1.getTacticName().toUpperCase().compareTo(ob2.getTacticName().toUpperCase());
                }
            });
             return tacticList;


         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
         }
     }

     /**
      * This method inserts the new Tactic into database and fetches back all the Tactics from the database
      * @param TacticDTO
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing errorCode and all Tactics
     */

     public ArrayList insertTactic(TacticDTO prmtrTacticDTO) throws DataAccessException {

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         int errorCode = 0;

         TacticDTO tacticDTO = null;
         ArrayList tacticList = new ArrayList();

         ArrayList result = new ArrayList();

         try{

             con = DBUtil.getInstance().createConnection();
             con.setAutoCommit(false);

             // String query = QueryUtil.getInstance().getQuery("KOL.TACTICS.INFO.INSERT");
             // SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

             StringBuffer tacticQuery = new StringBuffer();

             tacticQuery.append("INSERT INTO KOL_TACTICS (TACTIC_ID, TACTIC_NAME,");
             tacticQuery.append(" TACTIC_DETAILS, FA, TA, REGION, OBJECTIVES, CREATE_TIME) VALUES ((SELECT NVL(MAX(TACTIC_ID),0)+1 ");
             tacticQuery.append(" FROM KOL_TACTICS),'").append(prmtrTacticDTO.getTacticName()).append("',");
             /*
                if(prmtrTacticDTO.getTacticDate() != null)
                    tacticQuery.append("TO_DATE('").append(prmtrTacticDTO.getTacticDate()).append("', 'mm/dd/yyyy')");
                else
                    tacticQuery.append("TO_DATE(").append(prmtrTacticDTO.getTacticDate()).append(", 'mm/dd/yyyy')");
                */

             tacticQuery.append("'").append(prmtrTacticDTO.getTacticDetail());
             tacticQuery.append("','").append(prmtrTacticDTO.getFA()).append("','").append(prmtrTacticDTO.getTA()).append("',");
             tacticQuery.append("'").append(prmtrTacticDTO.getRegion()).append("','").append(prmtrTacticDTO.getObjective()).append("',");
             tacticQuery.append(" SYSDATE)");


             Statement stmt = con.createStatement();

             // insert the new KOL Key Message
             try{

                 stmt.executeUpdate(tacticQuery.toString());

             }catch(SQLException se){
                 logger.error("Failed to insert Tactic", se);
                 if(1 == se.getErrorCode())
                 {
                     try
                     {
                         con.rollback();
                     }
                     catch(Exception e){}

                 }
                 errorCode = se.getErrorCode();
             }
             stmt.close();
             con.commit();

             // fetch all KOL Key Messages
             String query = QueryUtil.getInstance().getQuery("KOL.ALL_TACTICS.INFO.SELECT");

             prepStmt = con.prepareStatement(query);

             prepStmt.setString(1, prmtrTacticDTO.getTA());
             prepStmt.setString(2, prmtrTacticDTO.getFA());
             prepStmt.setString(3, prmtrTacticDTO.getRegion());

             resultSet = prepStmt.executeQuery();

             while(resultSet.next()) {

                tacticDTO = new  TacticDTO();

                tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                /*
                    Date tacticDate = resultSet.getDate("TACTIC_DATE");

                    if(tacticDate != null) {
                       tacticDTO.setTacticDate(sdf.format(tacticDate));

                       Calendar calendar = Calendar.getInstance();
                       calendar.setTime(tacticDate);

                       tacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                     }
                    */

                tacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));
                tacticDTO.setFA(resultSet.getString("FA"));
                tacticDTO.setTA(resultSet.getString("TA"));
                tacticDTO.setRegion(resultSet.getString("REGION"));
                tacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                tacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));

                tacticList.add(tacticDTO);
             }

             con.commit();

             result.add(0, errorCode+"");
             result.add(1, tacticList);

             return result;

         } catch (SQLException e) {

             logger.error(e);
             throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
             logger.error(e);
             throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
     }


     /**
      * This method updates the selected Tactic and all the Tactics from the database
      * @param TacticDTO
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing errorCode and all Tactics
     */

     public ArrayList updateTactic(TacticDTO tacticDTO) throws DataAccessException {

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         int errorCode = 0;
         ArrayList tacticList = new ArrayList();
         ArrayList result = new ArrayList();

         try{

             con = DBUtil.getInstance().createConnection();
             con.setAutoCommit(false);

             // UPDATE KOL_TACTICS SET TACTIC_NAME=?, TACTIC_DETAILS=?, FA=?, TA=?, REGION=?, OBJECTIVES=?
             // WHERE TACTIC_ID = ?

             String query = QueryUtil.getInstance().getQuery("KOL.TACTICS.INFO.UPDATE");

             SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

             prepStmt = con.prepareStatement(query);

             prepStmt.setString(1, tacticDTO.getTacticName());

             /*
                java.sql.Date tacticDate = null;

                if(tacticDTO.getTacticDate() != null)
                   tacticDate = new java.sql.Date((sdf.parse(tacticDTO.getTacticDate())).getTime());

                prepStmt.setDate(2, tacticDate);
                */
             prepStmt.setString(2, tacticDTO.getTacticDetail());
             prepStmt.setString(3, tacticDTO.getFA());
             prepStmt.setString(4, tacticDTO.getTA());
             prepStmt.setString(5, tacticDTO.getRegion());
             prepStmt.setString(6, tacticDTO.getObjective());

             prepStmt.setInt(7, tacticDTO.getTacticId());

             // update the selected KOL Key Message
             try{

                 prepStmt.executeUpdate();

             }catch(SQLException se){

                 logger.error("Failed to update Tactic", se);
                 if(1 == se.getErrorCode())
                 {
                     try
                     {
                         con.rollback();
                     }
                     catch(Exception e){}

                 }
                 errorCode = se.getErrorCode();
             }

             prepStmt.close();
             con.commit();

             // fetch all KOL Key Messages
             query = QueryUtil.getInstance().getQuery("KOL.ALL_TACTICS.INFO.SELECT");

             prepStmt = con.prepareStatement(query);

             prepStmt.setString(1, tacticDTO.getTA());
             prepStmt.setString(2, tacticDTO.getFA());
             prepStmt.setString(3, tacticDTO.getRegion());

             resultSet = prepStmt.executeQuery();

             while(resultSet.next()) {

                tacticDTO = new  TacticDTO();

                tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                /*
                    tacticDate = resultSet.getDate("TACTIC_DATE");

                    if(tacticDate != null) {
                       tacticDTO.setTacticDate(sdf.format(tacticDate));

                       Calendar calendar = Calendar.getInstance();
                       calendar.setTime(tacticDate);

                       tacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                     }
                    */

                tacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));
                tacticDTO.setFA(resultSet.getString("FA"));
                tacticDTO.setTA(resultSet.getString("TA"));
                tacticDTO.setRegion(resultSet.getString("REGION"));
                tacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                tacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));

                tacticList.add(tacticDTO);
             }

             result.add(0, errorCode+"");
             result.add(1, tacticList);

             con.commit();
             return result;

         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){

            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
     }


     /**
      * This method deletes the selected Tactics and fetches back the remaining Tactics from the database
      * @param KeyMessageDTO
      * @exception DataAccessException is thrown in case of problem in execution
      * @return ArrayList containing errorCode and all Tactics
     */

     public ArrayList deleteTactic(String tacticIds, String ta, String fa, String region) throws DataAccessException {

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         TacticDTO tacticDTO = null;
         ArrayList tacticList = new ArrayList();

         ArrayList result = new ArrayList();

         int errorCode = 0;

         try{

             con = DBUtil.getInstance().createConnection();
             con.setAutoCommit(false);

             SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

             // delete the selected KOL Key Messages
             StringBuffer deleteQuery = new StringBuffer();
             deleteQuery.append("DELETE FROM KOL_TACTICS WHERE TACTIC_ID IN (").append(tacticIds).append(")");

             prepStmt = con.prepareStatement(deleteQuery.toString());

             try{

                 prepStmt.executeUpdate();

             }catch(SQLException se){
                 logger.error("Failed to delete Tactic(s)", se);
                 if(1 == se.getErrorCode())
                 {
                     try
                     {
                         con.rollback();
                     }
                     catch(Exception e){}

                 }
                 errorCode = se.getErrorCode();
             }
             prepStmt.close();

             // fetch remaining KOL Key Messages
             String query = QueryUtil.getInstance().getQuery("KOL.ALL_TACTICS.INFO.SELECT");

             prepStmt = con.prepareStatement(query);

             prepStmt.setString(1, ta);
             prepStmt.setString(2, fa);
             prepStmt.setString(3, region);

             resultSet = prepStmt.executeQuery();

             while(resultSet.next()) {

                tacticDTO = new  TacticDTO();

                tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                /*
                    Date tacticDate = resultSet.getDate("TACTIC_DATE");

                    if(tacticDate != null) {
                       tacticDTO.setTacticDate(sdf.format(tacticDate));

                       Calendar calendar = Calendar.getInstance();
                       calendar.setTime(tacticDate);

                       tacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                    }
                    */

                tacticDTO.setTacticDetail(resultSet.getString("TACTIC_DETAILS"));
                tacticDTO.setFA(resultSet.getString("FA"));
                tacticDTO.setTA(resultSet.getString("TA"));
                tacticDTO.setRegion(resultSet.getString("REGION"));
                tacticDTO.setObjectiveId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                tacticDTO.setObjective(resultSet.getString("MAIN_OBJECTIVE"));

                tacticList.add(tacticDTO);
             }

             con.commit();

             result.add(0, errorCode+"");
             result.add(1, tacticList);

             return result;

         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
     }

    public boolean addExpertsToSegment(ArrayList expertsInSegement,int segmentId) throws DataAccessException {
        Connection con = null;
        PreparedStatement prepStmt = null;
        PreparedStatement expertInSegmentStmt = null;
        ResultSet resultSet = null;
        ResultSet expertsInSegmentrs = null;
        boolean flag = false;
        try{
            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);
            String insertQuery = "INSERT INTO SEGMENT_EXPERTS(SEGMENT_ID,EXPERT_ID) VALUES (?,?)";
            String countExpertSQL = "SELECT COUNT(*) FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = ? AND EXPERT_ID = ?";
            expertInSegmentStmt = con.prepareStatement(countExpertSQL);
            prepStmt = con.prepareStatement(insertQuery);
            for (int i=0;i<expertsInSegement.size();i++)
                {
                 int expertInSegment = 0;
                 MyExpertDTO myExpertDTO = (MyExpertDTO)expertsInSegement.get(i);
                 expertInSegmentStmt.setInt(1,segmentId);
                 expertInSegmentStmt.setInt(2,(int)myExpertDTO.getExpertId());
                 expertsInSegmentrs = expertInSegmentStmt.executeQuery();
                 while (expertsInSegmentrs.next())
                 {
                    expertInSegment = expertsInSegmentrs.getInt(1);
                 }
                 if (expertInSegment == 0) {
                 prepStmt.setInt(1,segmentId);
                 prepStmt.setInt(2,(int)myExpertDTO.getExpertId());
                 int updateStatus = prepStmt.executeUpdate();
                 if (updateStatus == 0) {
                     flag = false;
                     break;
                 }
                 else {
                    flag = true;
                    }
                }
                }
                if (flag == true) {
                    con.setAutoCommit(true);
                    con.commit();
                    return flag;
                }
                else {
                    con.rollback();
                    con.setAutoCommit(true);
                    return flag;
                }
        }catch(SQLException se){
            logger.error("Failed to delete KOL key message(s)", se);
            if(1 == se.getErrorCode())
            {
                try
                {
                    con.rollback();
                }
                catch(Exception e){}
            }
        }
        catch (Exception e){
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao");
        }finally{
            DBUtil.getInstance().closeDBResources(null, prepStmt, null);
            DBUtil.getInstance().closeDBResources(con, expertInSegmentStmt, resultSet);
        }
        return flag;
      }

    // methods related to Brand Objectives

    /**
     * This method fetches all the Segment details along with Brand Objectives from the database
     * @param
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing Segment Details
    */

    public ArrayList findAllSegmentWithBrandObjectives() throws DataAccessException {

        ArrayList segmentList = new ArrayList();

        NodeDTO segmentDTO = null;

        Connection connection = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        try {

            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL.SEGMENT.OBJECTIVE.SELECT");

            prepStmt = connection.prepareStatement(query);
            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                segmentDTO = new NodeDTO();

                segmentDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                segmentDTO.setSegmentName(resultSet.getString("NAME"));
                segmentDTO.setStatedStrategy(resultSet.getString("STATED_STRATEGY"));
                segmentDTO.setSegmentObjective(resultSet.getString("OBJECTIVE"));

                segmentList.add(segmentDTO);
            }
            prepStmt.close();

            query = "SELECT SEGMENT_ID, NAME ORGANIZATION FROM SEGMENT WHERE SEGMENT_ID IN(";
            query += " SELECT SEGMENT_ID FROM SEGMENT START WITH";
            query += " SEGMENT_ID = ? CONNECT BY PRIOR  PARENT_ID = SEGMENT_ID) ";

            int segmentId = 0;

            if(segmentList.size() > 0) {
                for(int i=0; i<segmentList.size(); ++i) {

                    StringBuffer organization = new StringBuffer();
                    segmentDTO = (NodeDTO) segmentList.get(i);

                    prepStmt = connection.prepareStatement(query);
                    prepStmt.setInt(1, segmentDTO.getSegmentId());

                    resultSet = prepStmt.executeQuery();

                    while(resultSet.next()) {
                        segmentId = resultSet.getInt("SEGMENT_ID");
                        if(segmentId != segmentDTO.getSegmentId()) {
                            if(organization.length() > 0)
                                organization.append(" > ").append(resultSet.getString("ORGANIZATION"));
                            else
                                organization.append(resultSet.getString("ORGANIZATION"));
                        }
                    }

                    segmentDTO.setCountryName(organization.toString());

                    prepStmt.close();
                }

                return segmentList;
            }

            return null;

        } catch (SQLException e) {
            logger.error("SQLException in findAllSegmentWithBrandObjectives", e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.debug("Exception in findAllSegmentWithBrandObjectives", e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
        }
    }


    //	methods related to Segment Tactics


    /**
     * This method fetches the Segment Tactic details for the chosen segmentTactic Id from the database
     * @param segmentTacticId
     * @exception DataAccessException is thrown in case of problem in execution
     * @return TacticDTO containing Segment Tactic Details
     */

    public TacticDTO findSegementTacticDetail(int segmentTacticId) throws DataAccessException {

        TacticDTO segmentTacticDTO = null;

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        try {
            con = DBUtil.getInstance().createConnection();


            Calendar calendar = Calendar.getInstance();

            // fetch the Segment Tactic
            String query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTIC.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, segmentTacticId);

            resultSet = prepStmt.executeQuery();

            if(resultSet.next()) {

                segmentTacticDTO = new  TacticDTO();

                segmentTacticDTO.setSegmentTacticId(resultSet.getInt("SEGMENT_TACTIC_ID"));
                segmentTacticDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                segmentTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));

                segmentTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                segmentTacticDTO.setRole(resultSet.getString("SEGMENT_ROLE"));
                segmentTacticDTO.setRoleName(resultSet.getString("ROLE"));
                segmentTacticDTO.setTacticDueDate(resultSet.getString("TACTIC_DUE_DATE"));

            }

            return segmentTacticDTO;

         } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }


    /**
     * This method fetches all the Segment Tactic details for the chosen segment from the database
     * @param segmentId
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing Segment Tactic Details
     */

    public ArrayList findSegementTactics(int segmentId) throws DataAccessException {

        TacticDTO segmentTacticDTO = null;

        ArrayList segmentTacticList = new ArrayList();
        ArrayList result = new ArrayList();


        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        try {

            con = DBUtil.getInstance().createConnection();

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);
            Calendar calendar = Calendar.getInstance();

            // fetch all Segment Tactics
            String query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTICS.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, segmentId);

            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

                segmentTacticDTO = new  TacticDTO();

                segmentTacticDTO.setSegmentTacticId(resultSet.getInt("SEGMENT_TACTIC_ID"));
                segmentTacticDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                segmentTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));

                segmentTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                //int tacticDate = resultSet.getInt("TACTIC_YEAR");


                //segmentTacticDTO.setTacticYear(tacticDate);

                //segmentTacticDTO.setQuarter(resultSet.getString("QUARTER"));
                segmentTacticDTO.setRole(resultSet.getString("SEGMENT_ROLE"));
                segmentTacticDTO.setRoleName(resultSet.getString("ROLE"));
                //segmentTacticDTO.setRegion(resultSet.getString("REGION"));
                //segmentTacticDTO.setBudget(resultSet.getString("BUDGET"));
                segmentTacticDTO.setTacticDueDate(resultSet.getString("TACTIC_DUE_DATE"));

                segmentTacticList.add(segmentTacticDTO);
            }
            prepStmt.close();

            int appliedTacticId = 0;
            query = "SELECT SEGMENT_TACTIC_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = " + segmentId;
            prepStmt = con.prepareStatement(query);


            resultSet = prepStmt.executeQuery();
            if(resultSet.next()) {
                appliedTacticId = resultSet.getInt("SEGMENT_TACTIC_ID");
            }

            result.add(0, segmentTacticList);
            result.add(1, appliedTacticId+"");

            return result;

         } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }

    /**
     * This method inserts and updates all the Segment Tactic details for the chosen segment into the database
     * @param prmtrSegmentTacticDTO
     * @param prmtrSegmentTacticList
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing Segment Tactic Details
     */

    public ArrayList insertNUpdateSegmentTactics(int segmentId, TacticDTO prmtrSegmentTacticDTO, ArrayList prmtrSegmentTacticList) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        int errorCode = 0;

        ArrayList segmentTacticList = new ArrayList();
        TacticDTO segmentTacticDTO = null;

        ArrayList result = new ArrayList();

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            String query = "";

            if(prmtrSegmentTacticDTO != null) {

                StringBuffer tacticQuery = new StringBuffer();
/*
				tacticQuery.append("INSERT INTO SEGMENT_TACTICS (SEGMENT_TACTIC_ID, SEGMENT_ID, TACTIC_ID,");
				tacticQuery.append(" QUARTER, SEGMENT_ROLE, REGION, BUDGET, CREATE_TIME,TACTIC_YEAR) VALUES ((SELECT NVL(MAX(SEGMENT_TACTIC_ID),0)+1 ");
				tacticQuery.append(" FROM SEGMENT_TACTICS),").append(prmtrSegmentTacticDTO.getSegmentId()).append(",");
				tacticQuery.append(" ").append(prmtrSegmentTacticDTO.getTacticId()).append(",");

				tacticQuery.append("'").append(prmtrSegmentTacticDTO.getQuarter()).append("'");
				tacticQuery.append(",'").append(prmtrSegmentTacticDTO.getRole()).append("'");
				tacticQuery.append(",'").append(prmtrSegmentTacticDTO.getRegion()).append("'");
				tacticQuery.append(",'").append(prmtrSegmentTacticDTO.getBudget()).append("', SYSDATE,");
                tacticQuery.append("'").append(prmtrSegmentTacticDTO.getTacticYear()).append("')");
*/

                tacticQuery.append("INSERT INTO SEGMENT_TACTICS (SEGMENT_TACTIC_ID, SEGMENT_ID, TACTIC_ID,");
                tacticQuery.append(" SEGMENT_ROLE, CREATE_TIME,TACTIC_DUE_DATE) VALUES ((SELECT NVL(MAX(SEGMENT_TACTIC_ID),0)+1 ");
                tacticQuery.append(" FROM SEGMENT_TACTICS),").append(prmtrSegmentTacticDTO.getSegmentId()).append(",");
                tacticQuery.append(" ").append(prmtrSegmentTacticDTO.getTacticId()).append(",");
                tacticQuery.append("'").append(prmtrSegmentTacticDTO.getRole()).append("', SYSDATE, ");
                String dueDate = "to_date('"+prmtrSegmentTacticDTO.getTacticDueDate()+"','MM/dd/yyyy')";
                tacticQuery.append(dueDate).append(")");


                Statement stmt = con.createStatement();

                // insert the new Segment Tactic
                try{

                     stmt.executeUpdate(tacticQuery.toString());

                }catch(SQLException se){
                    logger.error("Failed to insert Segment Tactic", se);
                    if(1 == se.getErrorCode())
                    {
                        try
                        {
                            con.rollback();
                        }
                        catch(Exception e){}

                    }
                    errorCode = se.getErrorCode();
                }

                stmt.close();
                con.commit();
            }

            if(prmtrSegmentTacticList != null && prmtrSegmentTacticList.size() > 0) {

                query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTICS.INFO.UPDATE");
                // UPDATE SEGMENT_TACTICS SET TACTIC_ID=?, SEGMENT_ROLE=?, TACTIC_DUE_DATE=?
                // WHERE SEGMENT_TACTIC_ID = ?
                prepStmt= con.prepareStatement(query);

                for(int i=0; i< prmtrSegmentTacticList.size(); ++i) {
                    segmentTacticDTO = (TacticDTO) prmtrSegmentTacticList.get(i);

                    prepStmt.setInt(1, segmentTacticDTO.getTacticId());
                    prepStmt.setString(2, segmentTacticDTO.getRole());
                    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                    Date dueDate = sdf.parse(segmentTacticDTO.getTacticDueDate());
                    prepStmt.setDate(3, new java.sql.Date(dueDate.getTime()));
                    prepStmt.setInt(4, segmentTacticDTO.getSegmentTacticId());

                    // update the Segment Tactics
                    try{

                        prepStmt.executeUpdate();

                    }catch(SQLException se){
                         logger.error("Failed to update Segment Tactic", se);
                         if(1 == se.getErrorCode())
                         {
                             try
                             {
                                 con.rollback();
                             }
                             catch(Exception e){}

                         }
                         errorCode = se.getErrorCode();
                    }
                }

                prepStmt.close();
                con.commit();
            }


            // fetch all Segment Tactics

            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTICS.INFO.SELECT");
            // SELECT ST.SEGMENT_TACTIC_ID, ST.SEGMENT_ID, ST.TACTIC_ID, T.TACTIC_NAME,
            // ST.SEGMENT_ROLE, ST.TACTIC_DUE_DATE FROM SEGMENT_TACTICS ST, KOL_TACTICS T
            // WHERE ST.TACTIC_ID = T.TACTIC_ID AND ST.SEGMENT_ID = ?

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, segmentId);

            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

               segmentTacticDTO = new  TacticDTO();

               segmentTacticDTO.setSegmentTacticId(resultSet.getInt("SEGMENT_TACTIC_ID"));
               segmentTacticDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
               segmentTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));

               segmentTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

               /*
                  int tacticDate = resultSet.getInt("TACTIC_YEAR");

                  if(tacticDate != null) {
                      segmentTacticDTO.setTacticDate(sdf.format(tacticDate));

                      calendar.setTime(tacticDate);

                      segmentTacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                  }
                  if(tacticDate == null) {
                      segmentTacticDTO.setTacticYear(calendar.get(Calendar.YEAR));
                  }
                  segmentTacticDTO.setTacticYear(tacticDate);
                  */
                segmentTacticDTO.setRole(resultSet.getString("SEGMENT_ROLE"));
                segmentTacticDTO.setRoleName(resultSet.getString("ROLE"));
                segmentTacticDTO.setTacticDueDate( resultSet.getString("TACTIC_DUE_DATE"));


               segmentTacticList.add(segmentTacticDTO);
            }

            prepStmt.close();

            int appliedTacticId = 0;
            query = "SELECT SEGMENT_TACTIC_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = " + segmentId;
            prepStmt = con.prepareStatement(query);


            resultSet = prepStmt.executeQuery();
            if(resultSet.next()) {
                appliedTacticId = resultSet.getInt("SEGMENT_TACTIC_ID");
            }

            con.commit();

            result.add(0, errorCode+"");
            result.add(1, segmentTacticList);
            result.add(2, appliedTacticId+"");

            return result;

         } catch (SQLException e) {
             logger.error(e);
             throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
             logger.error(e);
             throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }


    /**
     * This method deletes the chosen Segment Tactics from the database
     * @param segmentTacticIds
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing Segment Tactic Details
     */

    public ArrayList deleteSegmentTactics(String segmentTacticIds, int segmentId) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        TacticDTO segmentTacticDTO = null;
        ArrayList segmentTacticList = new ArrayList();

        ArrayList result = new ArrayList();

        int errorCode = 0;

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            // delete the selected Segment Tactics
            StringBuffer deleteQuery = new StringBuffer();
            deleteQuery.append("DELETE FROM SEGMENT_TACTICS WHERE SEGMENT_TACTIC_ID IN (").append(segmentTacticIds).append(")");

            prepStmt = con.prepareStatement(deleteQuery.toString());

            try{

                prepStmt.executeUpdate();

            }catch(SQLException se){
                logger.error("Failed to delete Segment Tactic(s)", se);
                if(1 == se.getErrorCode())
                {
                    try
                    {
                        con.rollback();
                    }
                    catch(Exception e){}

                }
                errorCode = se.getErrorCode();
            }
            prepStmt.close();


            Calendar calendar = Calendar.getInstance();

            // fetch all Segment Tactics
            String query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTICS.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, segmentId);

            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

               segmentTacticDTO = new  TacticDTO();

               segmentTacticDTO.setSegmentTacticId(resultSet.getInt("SEGMENT_TACTIC_ID"));
               segmentTacticDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
               segmentTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
               segmentTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
               segmentTacticDTO.setRole(resultSet.getString("SEGMENT_ROLE"));
               segmentTacticDTO.setRoleName(resultSet.getString("ROLE"));
               segmentTacticDTO.setTacticDueDate(resultSet.getString("TACTIC_DUE_DATE") );
            /*   segmentTacticDTO.setRegion(resultSet.getString("REGION"));
			   segmentTacticDTO.setBudget(resultSet.getString("BUDGET"));*/

               segmentTacticList.add(segmentTacticDTO);
            }

            prepStmt.close();

            int appliedTacticId = 0;
            query = "SELECT SEGMENT_TACTIC_ID FROM SEGMENT_EXPERTS WHERE SEGMENT_ID = " + segmentId;
            prepStmt = con.prepareStatement(query);


            resultSet = prepStmt.executeQuery();
            if(resultSet.next()) {
                appliedTacticId = resultSet.getInt("SEGMENT_TACTIC_ID");
            }

            con.commit();

            result.add(0, errorCode+"");
            result.add(1, segmentTacticList);
            result.add(2, appliedTacticId+"");

            return result;

         } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }


    /**
     * This method applies the chosen Segment Tactics to the Segment Experts in the database
     * @param segmentTacticId
     * @param segmentId
     * @exception DataAccessException is thrown in case of problem in execution
     * @return ArrayList containing Segment Tactic Details
     */

    public ArrayList updateSegmentExpertTactics(int segmentTacticId, int segmentId) throws DataAccessException {

        Connection con = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;

        TacticDTO segmentTacticDTO = null;
        ArrayList segmentTacticList = new ArrayList();

        ArrayList result = new ArrayList();

        int errorCode = 0;

        try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

            // applies the selected Segment Tactics to Segment Experts
            StringBuffer tacticQuery = new StringBuffer();
            tacticQuery.append("UPDATE SEGMENT_EXPERTS SET SEGMENT_TACTIC_ID = ").append(segmentTacticId).append(" WHERE SEGMENT_ID = ").append(segmentId);

            prepStmt = con.prepareStatement(tacticQuery.toString());

            try{

                prepStmt.executeUpdate();

            }catch(SQLException se){
                logger.error("Failed to apply Segment Tactic(s)", se);
                if(1 == se.getErrorCode())
                {
                    try
                    {
                        con.rollback();
                    }
                    catch(Exception e){}

                }
                errorCode = se.getErrorCode();
            }
            prepStmt.close();


            Calendar calendar = Calendar.getInstance();

            // fetch all Segment Tactics
            String query = QueryUtil.getInstance().getQuery("KOL.SEGMENT_TACTICS.INFO.SELECT");

            prepStmt = con.prepareStatement(query);
            prepStmt.setInt(1, segmentId);

            resultSet = prepStmt.executeQuery();

            while(resultSet.next()) {

               segmentTacticDTO = new  TacticDTO();

               segmentTacticDTO.setSegmentTacticId(resultSet.getInt("SEGMENT_TACTIC_ID"));
               segmentTacticDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
               segmentTacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));

               segmentTacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

               segmentTacticDTO.setRole(resultSet.getString("SEGMENT_ROLE"));
               segmentTacticDTO.setRoleName(resultSet.getString("ROLE"));
               segmentTacticDTO.setTacticDueDate(resultSet.getString("TACTIC_DUE_DATE") );
               segmentTacticList.add(segmentTacticDTO);
            }

            con.commit();

            result.add(0, errorCode+"");
            result.add(1, segmentTacticList);
            result.add(2, segmentTacticId+"");

            return result;

         } catch (SQLException e) {
            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }


    /**
      * This method used to saveStrategy of particular Node.
      * @param
      * @exception DataAccessException is thrown in case of problem in execution
      * @return boolean based on the status of the updated status.
     */
    public boolean saveStrategy(NodeDTO nodeDTO) throws DataAccessException
    {
        boolean updateSegment = false;
        NodeDTO segmentDTO = null;

        Connection connection = null;
        PreparedStatement prepStmt = null;
        ResultSet resultSet = null;
        try {
            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL_SAVE_STRATEGY");
            prepStmt = connection.prepareStatement(query);
            prepStmt.setString(1,nodeDTO.getKeyMessages());
            prepStmt.setString(2,nodeDTO.getStatedStrategy());
            prepStmt.setString(3,nodeDTO.getSegmentObjective());
            prepStmt.setString(4,nodeDTO.getStrategyStatus());
            prepStmt.setInt(5,nodeDTO.getSegmentId());

            int updateStrategy = prepStmt.executeUpdate();
            if (updateStrategy==0){
                updateSegment = false;
            }else{
                updateSegment = true;
            }
            return updateSegment;
        } catch (SQLException e) {
            logger.error("SQLException in findAllSegmentWithBrandObjectives", e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.debug("Exception in findAllSegmentWithBrandObjectives", e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
        }
    }


    /**
      * This method used to get SegmentInfo based on SegmentId.
      * @param
      * @exception DataAccessException is thrown in case of problem in execution
      * @return arrayList of NodeDTO's
     */
    public NodeDTO getSegmentInfoForSegmentId(int segmentId) throws DataAccessException
    {
        NodeDTO nodeDTO = new NodeDTO();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        int i = 0;
        try {
            connection = DBUtil.getInstance().createConnection();
            String query = QueryUtil.getInstance().getQuery("KOL_GET_STRATEGY_SEGMENTID");
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1,segmentId);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next())
            {
             nodeDTO.setParentName(resultSet.getString("NAME"));
             nodeDTO.setDescription(resultSet.getString("DESCRIPTION"));
             nodeDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
             nodeDTO.setParentId(resultSet.getInt("PARENT_ID"));
             nodeDTO.setStrategyLevel(resultSet.getString("STRATEGY_LEVEL"));
             nodeDTO.setCreatedDate(resultSet.getString("CREATE_DATE"));
             nodeDTO.setDescription(resultSet.getString("DESCRIPTION"));
             nodeDTO.setTaId(resultSet.getString("TA"));
             nodeDTO.setFaId(resultSet.getString("FA"));
             nodeDTO.setRegionId(resultSet.getString("REGION"));
             if(resultSet.getString("OBJECTIVE") != null && !(resultSet.getString("OBJECTIVE")).equals("")) {
                nodeDTO.setSegmentObjective(resultSet.getString("OBJECTIVE"));
             } else {
                nodeDTO.setSegmentObjective("0");
             }
             nodeDTO.setStatedStrategy(resultSet.getString("STATED_STRATEGY"));
             if(resultSet.getString("KEY_MESSAGES") != null && !(resultSet.getString("KEY_MESSAGES")).equals("")) {
                nodeDTO.setKeyMessages(resultSet.getString("KEY_MESSAGES"));
             } else {
                nodeDTO.setKeyMessages("0");
             }
             nodeDTO.setStrategyStatus(resultSet.getString("STRATEGY_STATUS"));
             nodeDTO.setCreatedBy(resultSet.getString("LASTNAME")+", "+resultSet.getString("FIRSTNAME"));

             SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);
             String nodeCreationDate = "";
             if (resultSet.getString("CREATE_DATE") != null) {
                nodeCreationDate = sdf.format(resultSet.getDate("CREATE_DATE")).toString();
             }
             nodeDTO.setCreatedDate(nodeCreationDate);

             nodeDTO.setTaId(resultSet.getString("TA"));
             nodeDTO.setFaId(resultSet.getString("FA"));
             nodeDTO.setRegionId(resultSet.getString("REGION"));

             nodeDTO.setTaName(resultSet.getString("TA_NAME"));
             nodeDTO.setFaName(resultSet.getString("FA_NAME"));
            }
        } catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, preparedStatement,resultSet);
        }
        return nodeDTO;
    }


    public ArrayList getAllMainObjectives() throws DataAccessException {
         MainObjectiveDTO mainObjectiveDTO = null;
         ArrayList mainObjectiveList = new ArrayList();

         Connection con = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;

         try {

            con = DBUtil.getInstance().createConnection();

            String query = QueryUtil.getInstance().getQuery("KOL.ALL_MAIN_OBJECTIVES.INFO.SELECT");

            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();

             while(rs.next()) {

                mainObjectiveDTO = new  MainObjectiveDTO();
                mainObjectiveDTO.setId(rs.getInt("MAIN_OBJECTIVE_ID"));
                mainObjectiveDTO.setMainObjective(rs.getString("MAIN_OBJECTIVE"));
                mainObjectiveDTO.setDescription(rs.getString("DESCRIPTION"));
                mainObjectiveDTO.setTA(rs.getString("TA"));
                mainObjectiveDTO.setFA(rs.getString("FA"));
                mainObjectiveDTO.setRegion(rs.getString("REGION"));
                mainObjectiveList.add(mainObjectiveDTO);
             }
             return mainObjectiveList;
         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, pstmt, rs);
         }
    }

    public ArrayList getAllMainObjectivesOnFilter(String TA,String FA, String region) throws DataAccessException {
         MainObjectiveDTO mainObjectiveDTO = null;
         ArrayList mainObjectiveList = new ArrayList();

         Connection con = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;

         try {

            con = DBUtil.getInstance().createConnection();

            String query = QueryUtil.getInstance().getQuery("KOL.ALL_MAIN_OBJECTIVES.INFO.SELECT.BASED_ON_FILTER");

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, TA);
            pstmt.setString(2, FA);
            pstmt.setString(3,region);
            rs = pstmt.executeQuery();

             while(rs.next()) {

                mainObjectiveDTO = new  MainObjectiveDTO();

                mainObjectiveDTO.setId(rs.getInt("MAIN_OBJECTIVE_ID"));
                mainObjectiveDTO.setMainObjective(rs.getString("MAIN_OBJECTIVE"));
                mainObjectiveDTO.setDescription(rs.getString("DESCRIPTION"));
                mainObjectiveDTO.setTA(rs.getString("TA"));
                mainObjectiveDTO.setFA(rs.getString("FA"));
                mainObjectiveDTO.setRegion(rs.getString("REGION"));
                mainObjectiveDTO.setObjective(rs.getString("OBJECTIVES"));

                mainObjectiveList.add(mainObjectiveDTO);
             }
             return mainObjectiveList;
         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, pstmt, rs);
         }
    }

    public MainObjectiveDTO findMainObjective(int mainObjectiveId) throws DataAccessException {
         MainObjectiveDTO mainObjectiveDTO = null;


         ArrayList mainObjectiveList = new ArrayList();

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         try {

             con = DBUtil.getInstance().createConnection();
             String query = QueryUtil.getInstance().getQuery("KOL.MAIN.0BJECTIVE.INFO.SELECT");

             prepStmt = con.prepareStatement(query);
             prepStmt.setInt(1, mainObjectiveId);

             resultSet = prepStmt.executeQuery();

             if(resultSet.next()) {

                mainObjectiveDTO = new MainObjectiveDTO();

                mainObjectiveDTO.setId(resultSet.getInt("MAIN_OBJECTIVE_ID"));
                mainObjectiveDTO.setMainObjective(resultSet.getString("MAIN_OBJECTIVE"));
                mainObjectiveDTO.setDescription(resultSet.getString("DESCRIPTION"));
                mainObjectiveDTO.setTA(resultSet.getString("TA"));
                mainObjectiveDTO.setFA(resultSet.getString("FA"));
                mainObjectiveDTO.setRegion(resultSet.getString("REGION"));

             }
             prepStmt.close();
             con.commit();
             return mainObjectiveDTO;


         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }
         finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }

    }

    public void removeMainObjective(String mainObjectiveIds) throws DataAccessException {

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         MainObjectiveDTO mainObjectiveDTO = null;
         ArrayList mainObjectiveList = new ArrayList();

         ArrayList result = new ArrayList();

         int errorCode = 0;

         try{

             con = DBUtil.getInstance().createConnection();
             con.setAutoCommit(false);


             StringBuffer deleteQuery = new StringBuffer();

             deleteQuery.append("DELETE FROM MAIN_OBJECTIVES WHERE MAIN_OBJECTIVE_ID IN (").append(mainObjectiveIds).append(")");
             prepStmt = con.prepareStatement(deleteQuery.toString());

             prepStmt.executeQuery();
             prepStmt.close();
             con.commit();
         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }
    }

    public void addMainObjective(MainObjectiveDTO mainObjectiveDTO) throws DataAccessException {

         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         try{

            con = DBUtil.getInstance().createConnection();
            con.setAutoCommit(false);

            StringBuffer insQuery = new StringBuffer();

            insQuery.append("INSERT INTO MAIN_OBJECTIVES(MAIN_OBJECTIVE_ID, MAIN_OBJECTIVE,");
            insQuery.append("DESCRIPTION,FA, TA, REGION , CREATE_TIME) VALUES ((SELECT NVL(MAX(MAIN_OBJECTIVE_ID),0)+1 ");
            insQuery.append("FROM MAIN_OBJECTIVES),'"+mainObjectiveDTO.getMainObjective()+"','"+mainObjectiveDTO.getDescription()+"',");
            insQuery.append("'"+ mainObjectiveDTO.getFA()+"','"+mainObjectiveDTO.getTA()+"','"+mainObjectiveDTO.getRegion()+"', SYSDATE)");

            prepStmt = con.prepareStatement(insQuery.toString());

            prepStmt.executeQuery();
            con.commit();
         } catch (SQLException e) {

             logger.error(e);
             throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){
             logger.error(e);
             throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }

    }

    public void saveMainObjective(MainObjectiveDTO mainObjectiveDTO) throws DataAccessException {
         Connection con = null;
         PreparedStatement prepStmt = null;
         ResultSet resultSet = null;

         int errorCode = 0;
         ArrayList tacticList = new ArrayList();
         ArrayList result = new ArrayList();

         try{

             con = DBUtil.getInstance().createConnection();
             con.setAutoCommit(false);
             StringBuffer updateBuffer = new StringBuffer();
             updateBuffer.append("UPDATE MAIN_OBJECTIVES SET MAIN_OBJECTIVE=?, DESCRIPTION=?,");
             updateBuffer.append("CREATE_TIME=? , TA = ? , FA =? , REGION =? WHERE MAIN_OBJECTIVE_ID = ?");

             prepStmt = con.prepareStatement(updateBuffer.toString());
             prepStmt.setString(1, mainObjectiveDTO.getMainObjective());
             prepStmt.setString(2, mainObjectiveDTO.getDescription());
             prepStmt.setDate(3,new java.sql.Date(System.currentTimeMillis()));

             prepStmt.setString(4, mainObjectiveDTO.getTA());
             prepStmt.setString(5, mainObjectiveDTO.getFA());
             prepStmt.setString(6, mainObjectiveDTO.getRegion());

             prepStmt.setInt(7,(int)mainObjectiveDTO.getId());

             prepStmt.executeUpdate();
             con.commit();

         } catch (SQLException e) {

            logger.error(e);
            throw new DataAccessException(e.getMessage(), e);
         }catch (Exception e){

            logger.error(e);
            throw new DataAccessException("error.general.dao", e);
         }finally{
             DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
         }

    }


    //	Methods related to KOL Capability

      public ArrayList findCapability(int capabilityId) throws DataAccessException {

           CapabilityDTO capabilityDTO = null;
           CapabilityDTO tempCapabilityDTO = null;

           ArrayList capabilityList = new ArrayList();
           ArrayList result = new ArrayList();

           Connection con = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           try {

               con = DBUtil.getInstance().createConnection();
               String query = QueryUtil.getInstance().getQuery("KOL.CAPABILITY.INFO.SELECT");

               prepStmt = con.prepareStatement(query);
               prepStmt.setInt(1, capabilityId);

               SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

               resultSet = prepStmt.executeQuery();

               if(resultSet.next()) {

                  capabilityDTO = new CapabilityDTO();

                  capabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  capabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  capabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  capabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                  capabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  capabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      capabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  capabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  capabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  capabilityDTO.setTopics(resultSet.getString("TOPICS"));

               }

               prepStmt.close();

               // fetch all KOL capabilities
               query = QueryUtil.getInstance().getQuery("KOL.ALL_CAPABILITIES.INFO.SELECT");

               prepStmt = con.prepareStatement(query);
               prepStmt.setInt(1, capabilityDTO.getExpertId());

               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  tempCapabilityDTO = new CapabilityDTO();

                  tempCapabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  tempCapabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  tempCapabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  tempCapabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                  tempCapabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  tempCapabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      tempCapabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  tempCapabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  tempCapabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  tempCapabilityDTO.setTopics(resultSet.getString("TOPICS"));

                  capabilityList.add(tempCapabilityDTO);
               }

               con.commit();

               result.add(0, capabilityDTO);
               result.add(1, capabilityList);

               return result;
           } catch (SQLException e) {

              logger.error(e);
              throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){
              logger.error(e);
              throw new DataAccessException("error.general.dao", e);
           }
           finally{
               DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
           }
      }

      public ArrayList findAllCapabilities(int expertId) throws DataAccessException {

           CapabilityDTO capabilityDTO = null;
           ArrayList capabilityList = new ArrayList();

           Connection connection = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);


           try {

               connection = DBUtil.getInstance().createConnection();
               String query = QueryUtil.getInstance().getQuery("KOL.ALL_CAPABILITIES.INFO.SELECT");

               prepStmt = connection.prepareStatement(query);
               prepStmt.setInt(1, expertId);

               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  capabilityDTO = new CapabilityDTO();

                  capabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  capabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  capabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  capabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                  capabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  capabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      capabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  capabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  capabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  capabilityDTO.setTopics(resultSet.getString("TOPICS"));

                  capabilityList.add(capabilityDTO);
               }

               return capabilityList;

           } catch (SQLException e) {
              logger.error(e);
              throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){
              logger.error(e);
              throw new DataAccessException("error.general.dao", e);
           }
           finally{
               DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
           }
      }

      public ArrayList insertCapability(CapabilityDTO prmtrCapabilityDTO) throws DataAccessException {

           Connection con = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           int errorCode = 0;

           CapabilityDTO capabilityDTO = null;
           ArrayList capabilityList = new ArrayList();

           ArrayList result = new ArrayList();
           java.sql.Date msgDate = null;

           try{

               con = DBUtil.getInstance().createConnection();
               con.setAutoCommit(false);

               String query = QueryUtil.getInstance().getQuery("KOL.CAPABILITY.INFO.INSERT");

               SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

               StringBuffer capabilityQuery = new StringBuffer();

               capabilityQuery.append("INSERT INTO EXPERT_CAPABILITY (ACTIVITY_ID, EXPERT_ID, TACTIC_ID, PLAN_ID,");
               capabilityQuery.append(" ACTIVITY_NAME, LOCATION, ACTIVITY_DATE, ASSESSMENT, TOPICS, CREATE_TIME) VALUES ((SELECT NVL(MAX(ACTIVITY_ID),0)+1 ");
               capabilityQuery.append(" FROM EXPERT_CAPABILITY), ").append(prmtrCapabilityDTO.getExpertId()).append(", ");
               capabilityQuery.append(prmtrCapabilityDTO.getTacticId()).append(", ");
               capabilityQuery.append(prmtrCapabilityDTO.getPlanId()).append(", ");
               capabilityQuery.append("'").append(prmtrCapabilityDTO.getActivityName()).append("', ");
               capabilityQuery.append("'").append(prmtrCapabilityDTO.getLocation()).append("', ");

               if(prmtrCapabilityDTO.getActivityDate() != null)
                   capabilityQuery.append("TO_DATE('").append(prmtrCapabilityDTO.getActivityDate()).append("', 'mm/dd/yyyy')");
               else
                   capabilityQuery.append("TO_DATE(").append(prmtrCapabilityDTO.getActivityDate()).append(", 'mm/dd/yyyy')");

               capabilityQuery.append(",'").append(prmtrCapabilityDTO.getAssessment()).append("', ");
               capabilityQuery.append("'").append(prmtrCapabilityDTO.getTopics()).append("', SYSDATE)");

               Statement stmt = con.createStatement();

               // insert the new KOL Capability
               try{

                   stmt.executeUpdate(capabilityQuery.toString());

               }catch(SQLException se){
                   logger.error("Failed to insert Capability", se);
                   if(1 == se.getErrorCode())
                   {
                       try
                       {
                           con.rollback();
                       }
                       catch(Exception e){}

                   }
                   errorCode = se.getErrorCode();
               }
               stmt.close();
               con.commit();

               // fetch all KOL Capabilities
               query = QueryUtil.getInstance().getQuery("KOL.ALL_CAPABILITIES.INFO.SELECT");

               prepStmt = con.prepareStatement(query);
               prepStmt.setInt(1,prmtrCapabilityDTO.getExpertId());

               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  capabilityDTO = new CapabilityDTO();

                  capabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  capabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  capabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  capabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                  capabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  capabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      capabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  capabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  capabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  capabilityDTO.setTopics(resultSet.getString("TOPICS"));

                  capabilityList.add(capabilityDTO);
               }

               con.commit();

               result.add(0, errorCode+"");
               result.add(1, capabilityList);

               return result;

           } catch (SQLException e) {
               logger.error(e);
               throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){
               logger.error(e);
               throw new DataAccessException("error.general.dao", e);
           }finally{
               DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
           }

      }

      public ArrayList updateCapability(CapabilityDTO capabilityDTO) throws DataAccessException {

           Connection con = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           int errorCode = 0;

           ArrayList capabilityList = new ArrayList();
           ArrayList result = new ArrayList();

           try{

               con = DBUtil.getInstance().createConnection();
               con.setAutoCommit(false);

               String query = QueryUtil.getInstance().getQuery("KOL.CAPABILITY.INFO.UPDATE");

               SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

               prepStmt = con.prepareStatement(query);

               prepStmt.setInt(1, capabilityDTO.getTacticId());
               prepStmt.setInt(2, capabilityDTO.getPlanId());

               prepStmt.setString(3, capabilityDTO.getActivityName());
               prepStmt.setString(4, capabilityDTO.getLocation());

               java.sql.Date capabilityDate = null;
               if(capabilityDTO.getActivityDate() != null)
                  capabilityDate = new java.sql.Date((sdf.parse(capabilityDTO.getActivityDate())).getTime());

               prepStmt.setDate(5, capabilityDate);

               prepStmt.setString(6, capabilityDTO.getAssessment());
               prepStmt.setString(7, capabilityDTO.getTopics());

               prepStmt.setInt(8, capabilityDTO.getActivityId());

               // update the selected KOL Capability
               try{

                   prepStmt.executeUpdate();

               }catch(SQLException se){

                   logger.error("Failed to update Capability", se);
                   if(1 == se.getErrorCode())
                   {
                       try
                       {
                           con.rollback();
                       }
                       catch(Exception e){}

                   }
                   errorCode = se.getErrorCode();
               }

               prepStmt.close();
               con.commit();

               // fetch all KOL Capabilities
               query = QueryUtil.getInstance().getQuery("KOL.ALL_CAPABILITIES.INFO.SELECT");

               prepStmt = con.prepareStatement(query);
               prepStmt.setInt(1, capabilityDTO.getExpertId());

               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  capabilityDTO = new CapabilityDTO();

                  capabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  capabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  capabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  capabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                  capabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  capabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      capabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  capabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  capabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  capabilityDTO.setTopics(resultSet.getString("TOPICS"));

                  capabilityList.add(capabilityDTO);
               }

               result.add(0, errorCode+"");
               result.add(1, capabilityList);

               con.commit();
               return result;

           } catch (SQLException e) {

              logger.error(e);
              throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){

              logger.error(e);
              throw new DataAccessException("error.general.dao", e);
           }finally{
               DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
           }
      }

      public ArrayList deleteCapability(String capabilityIds, int expertId) throws DataAccessException {

           Connection con = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           CapabilityDTO capabilityDTO = null;
           ArrayList capabilityList = new ArrayList();

           ArrayList result = new ArrayList();

           int errorCode = 0;

           try{

               con = DBUtil.getInstance().createConnection();
               con.setAutoCommit(false);

               SimpleDateFormat sdf = new SimpleDateFormat(CALENDAR_DATE_FORMAT);

               // delete the selected KOL Capabilities
               StringBuffer deleteQuery = new StringBuffer();
               deleteQuery.append("DELETE FROM EXPERT_CAPABILITY WHERE ACTIVITY_ID IN (").append(capabilityIds).append(")");

               prepStmt = con.prepareStatement(deleteQuery.toString());

               try{

                   prepStmt.executeUpdate();

               }catch(SQLException se){
                   logger.error("Failed to delete Capability(s)", se);
                   if(1 == se.getErrorCode())
                   {
                       try
                       {
                           con.rollback();
                       }
                       catch(Exception e){}

                   }
                   errorCode = se.getErrorCode();
               }
               prepStmt.close();

               // fetch remaining KOL Capabilities
               String query = QueryUtil.getInstance().getQuery("KOL.ALL_CAPABILITIES.INFO.SELECT");

               prepStmt = con.prepareStatement(query);
               prepStmt.setInt(1, expertId);

               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  capabilityDTO = new CapabilityDTO();

                  capabilityDTO.setActivityId(resultSet.getInt("ACTIVITY_ID"));
                  capabilityDTO.setExpertId(resultSet.getInt("EXPERT_ID"));
                  capabilityDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  capabilityDTO.setTacticName(resultSet.getString("TACTIC_NAME"));
                  capabilityDTO.setPlanId(resultSet.getInt("PLAN_ID"));

                  capabilityDTO.setActivityName(resultSet.getString("ACTIVITY_NAME"));

                  Date activityDate = resultSet.getDate("ACTIVITY_DATE");
                  if(activityDate != null) {
                      capabilityDTO.setActivityDate(sdf.format(activityDate));
                  }

                  capabilityDTO.setLocation(resultSet.getString("LOCATION"));
                  capabilityDTO.setAssessment(resultSet.getString("ASSESSMENT"));
                  capabilityDTO.setTopics(resultSet.getString("TOPICS"));

                  capabilityList.add(capabilityDTO);
               }

               con.commit();

               result.add(0, errorCode+"");
               result.add(1, capabilityList);

               return result;

           } catch (SQLException e) {

              logger.error(e);
              throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){
              logger.error(e);
              throw new DataAccessException("error.general.dao", e);
           }finally{
               DBUtil.getInstance().closeDBResources(con, prepStmt, resultSet);
           }
      }

      public ArrayList findKOLTactics(int expertId) throws DataAccessException {

           TacticDTO tacticDTO = null;
           ArrayList tacticList = new ArrayList();

           Connection connection = null;
           PreparedStatement prepStmt = null;
           ResultSet resultSet = null;

           try {

               connection = DBUtil.getInstance().createConnection();
               StringBuffer kolTacticQuery = new StringBuffer();

               kolTacticQuery.append("SELECT KT.TACTIC_ID, KT.TACTIC_NAME FROM KOL_TACTICS KT WHERE KT.TACTIC_ID IN(");
               kolTacticQuery.append(" SELECT TACTIC_ID FROM SEGMENT_TACTICS WHERE SEGMENT_ID IN ( ");
               kolTacticQuery.append(" SELECT SEGMENT_ID FROM SEGMENT_EXPERTS WHERE EXPERT_ID = ").append(expertId).append(") )");

               prepStmt = connection.prepareStatement(kolTacticQuery.toString());
               resultSet = prepStmt.executeQuery();

               while(resultSet.next()) {

                  tacticDTO = new  TacticDTO();

                  tacticDTO.setTacticId(resultSet.getInt("TACTIC_ID"));
                  tacticDTO.setTacticName(resultSet.getString("TACTIC_NAME"));

                  tacticList.add(tacticDTO);
               }

               return tacticList;

           } catch (SQLException e) {

              logger.error(e);
              throw new DataAccessException(e.getMessage(), e);
           }catch (Exception e){
              logger.error(e);
              throw new DataAccessException("error.general.dao", e);
           }
           finally{
               DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
           }

      }

      public HashMap findKOLReferenceDetails(String refIds) throws DataAccessException {

          HashMap expRefMap = new HashMap();

          Connection connection = null;
          ResultSet resultSet = null;
          PreparedStatement prepStmt =null;

          try {

             connection = DBUtil.getInstance().createConnection();
             StringBuffer refQuery = new StringBuffer();

             refQuery.append("SELECT A.ID,A.FIRSTNAME,A.LASTNAME,A.LATITUDE,A.LONGITUDE,A.INFLUENCE_LEVEL,A.REFERENCE,");
             refQuery.append(" B.ATTRIBUTE_VALUE AS SPECIALITY,D.CITY,D.STATE,D.COUNTRY,D.ZIP,D.PHONE FROM USER_TABLE A,");
             refQuery.append(" USER_ATTRIBUTE_TRANSACTION B ,USER_ADDRESS D WHERE A.ID ");
             refQuery.append(" IN (").append(refIds).append(") AND A.ID=B.ID ");
             refQuery.append(" AND A.ID = D.ID AND B.USER_ATT_ID =1 UNION SELECT A.ID,A.FIRSTNAME,A.LASTNAME,");
             refQuery.append(" A.LATITUDE,A.LONGITUDE,A.INFLUENCE_LEVEL,A.REFERENCE,' ' AS SPECIALITY,D.CITY,D.STATE,D.COUNTRY,D.ZIP,D.PHONE");
             refQuery.append(" FROM USER_TABLE A,USER_ADDRESS D WHERE A.ID IN (").append(refIds).append(") AND A.ID = D.ID AND A.ID ");
             refQuery.append(" NOT IN (SELECT A.ID FROM USER_TABLE A, ");
             refQuery.append(" USER_ATTRIBUTE_TRANSACTION B WHERE A.ID IN (").append(refIds).append(") AND A.ID=B.ID AND B.USER_ATT_ID =1)");

             prepStmt = connection.prepareStatement(refQuery.toString());
             resultSet = prepStmt.executeQuery();

             while (resultSet.next())
             {
               MyExpertDTO myExpertDTO = new MyExpertDTO();
               myExpertDTO.setExpertId(resultSet.getInt("ID"));

               myExpertDTO.setFirstName(resultSet.getString("FIRSTNAME"));
               myExpertDTO.setLastName(resultSet.getString("LASTNAME"));

               myExpertDTO.setExpertName(myExpertDTO.getFirstName()+","+myExpertDTO.getLastName());

               myExpertDTO.setLatitude(resultSet.getFloat("LATITUDE"));
               myExpertDTO.setLongitude(resultSet.getFloat("LONGITUDE"));
               myExpertDTO.setInfluenceLevel(resultSet.getInt("INFLUENCE_LEVEL"));
               myExpertDTO.setSpeciality(resultSet.getString("SPECIALITY"));
               myExpertDTO.setPhone(resultSet.getString("PHONE"));

               myExpertDTO.setCity(resultSet.getString("CITY"));
               myExpertDTO.setState(resultSet.getString("STATE"));
               myExpertDTO.setCountry(resultSet.getString("COUNTRY"));
               myExpertDTO.setZip(resultSet.getString("ZIP"));

               myExpertDTO.setReference(resultSet.getString("REFERENCE"));

               expRefMap.put(myExpertDTO.getExpertId()+"", myExpertDTO);
             }

             return expRefMap;

          } catch (SQLException ex) {
              logger.debug(ex.getMessage());
              throw new DataAccessException("error.db.access");
          }catch (Exception e){
              logger.error(e.getLocalizedMessage(), e);
              throw new DataAccessException("error.general.dao");
          }
          finally{
              DBUtil.getInstance().closeDBResources(connection, prepStmt, resultSet);
          }

      }
    /**
     *
     */
    public NodeDTO getNodeInfo(int segmentId) throws DataAccessException {
        Connection connection = null;
        ResultSet resultSet = null;
        PreparedStatement pstmt =null;
        NodeDTO nodeDTO = null;

        try {

            connection = DBUtil.getInstance().createConnection();
            String query = "SELECT SEGMENT_ID, PARENT_ID, NAME, DESCRIPTION, STRATEGY_LEVEL ,TA, FA, REGION FROM SEGMENT WHERE SEGMENT_ID=?";
            pstmt = connection.prepareStatement(query);

            pstmt.setInt(1,segmentId);
            resultSet = pstmt.executeQuery();

            while(resultSet.next()) {
                nodeDTO = new NodeDTO();

                nodeDTO.setSegmentId(resultSet.getInt("SEGMENT_ID"));
                nodeDTO.setParentId(resultSet.getInt("PARENT_ID"));
                if(resultSet.getString("NAME") != null) {
                    nodeDTO.setParentName(resultSet.getString("NAME"));
                }
                if(resultSet.getString("DESCRIPTION") != null) {
                    nodeDTO.setDescription(resultSet.getString("DESCRIPTION"));
                }
                if(resultSet.getString("STRATEGY_LEVEL") != null) {
                    nodeDTO.setStrategyLevel(resultSet.getString("STRATEGY_LEVEL"));
                }
                if(resultSet.getString("TA") != null) {
                    nodeDTO.setTaId(resultSet.getString("TA"));
                }
                if(resultSet.getString("FA") != null) {
                    nodeDTO.setFaId(resultSet.getString("FA"));
                }
                if(resultSet.getString("REGION") != null) {
                    nodeDTO.setRegionId(resultSet.getString("REGION"));
                }
            }
            return nodeDTO;
        } catch (SQLException ex) {
            logger.debug(ex.getMessage());
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, pstmt, resultSet);
        }
    }
    /**
     *
     */
    public void saveNodeInfo(NodeDTO nodeDTO) throws DataAccessException {
        Connection connection = null;
        ResultSet resultSet = null;
        PreparedStatement pstmt =null;

        try {

            connection = DBUtil.getInstance().createConnection();
            String query = "UPDATE SEGMENT SET NAME = ?,DESCRIPTION = ? , TA =?, FA=? , REGION=? WHERE SEGMENT_ID=?";
            pstmt = connection.prepareStatement(query);

            pstmt.setString(1,nodeDTO.getParentName());
            pstmt.setString(2,nodeDTO.getDescription());
            pstmt.setString(3,nodeDTO.getTaId());
            pstmt.setString(4,nodeDTO.getFaId());
            pstmt.setString(5,nodeDTO.getRegionId());

            pstmt.setInt(6,nodeDTO.getSegmentId());

            pstmt.executeUpdate();

        } catch (SQLException ex) {
            logger.debug(ex.getMessage());
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, pstmt, resultSet);
        }

    }

public ArrayList getLatestSegmentCriteria(int segmentId) throws DataAccessException {

        Connection connection = null;
        ResultSet resultSet = null;
        PreparedStatement pstmt =null;
        ArrayList latestCriteriaList = null;
        SegmentCriteriaDTO criteriaDTO = null;

        try {
            connection = DBUtil.getInstance().createConnection();

            if(segmentId != 0) {
                StringBuffer selectSql = new StringBuffer("");
                selectSql.append("SELECT A.USER_ATT_ID , A.CONDITION_VALUE , A.CONDITION_OPERATOR,");
                selectSql.append(" B.USER_ATT_DATA_TYPE FROM SEGMENT_CRITERIA A,USER_ATTRIBUTE_MASTER B");
                selectSql.append(" WHERE A.SEGMENT_ID = ? AND A.LATEST_CRITERIA = ? AND B.USER_ATT_ID = A.USER_ATT_ID");

                pstmt = connection.prepareStatement(selectSql.toString());

                pstmt.setInt(1,segmentId);
                pstmt.setString(2,"Y");

                resultSet = pstmt.executeQuery();

                latestCriteriaList = new ArrayList();
                while(resultSet.next()) {
                    criteriaDTO = new SegmentCriteriaDTO();

                    criteriaDTO.setAttributeId(resultSet.getInt("USER_ATT_ID"));
                    if(resultSet.getString("CONDITION_VALUE") != null) {
                        criteriaDTO.setValue(resultSet.getString("CONDITION_VALUE"));
                    }
                    if(resultSet.getString("CONDITION_OPERATOR") != null) {
                        criteriaDTO.setCondition(resultSet.getString("CONDITION_OPERATOR"));
                    }
                    if(resultSet.getString("USER_ATT_DATA_TYPE") != null) {
                        criteriaDTO.setAttributeDataType(resultSet.getString("USER_ATT_DATA_TYPE"));
                    }
                    latestCriteriaList.add(criteriaDTO);
                }
            }
            return latestCriteriaList;

        } catch (SQLException ex) {
            logger.debug(ex.getMessage());
            throw new DataAccessException("error.db.access");
        }catch (Exception e){
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally{
            DBUtil.getInstance().closeDBResources(connection, pstmt, resultSet);
        }
  }
/**
 * This method used to get segment criteria
 * @param
 * @exception DataAccessException is thrown in case of problem in execution
 * @return arrayList of SegmentCriteriaDTO's
*/
public ArrayList getSegmentCriteria() throws DataAccessException
{
    ArrayList segmentCriteriaList = new ArrayList();
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    int i = 0;
    try {
        connection = DBUtil.getInstance().createConnection();
        String query = QueryUtil.getInstance().getQuery("KOL_SEGMENT_CRITERIA_ATT_NAME");
        preparedStatement = connection.prepareStatement(query);
        resultSet = preparedStatement.executeQuery();
        while (resultSet.next())
        {
            SegmentCriteriaDTO segmentCriteriaDTO = new SegmentCriteriaDTO();
            segmentCriteriaDTO.setAttributeId(resultSet.getInt("USER_ATT_ID"));
            segmentCriteriaDTO.setAttributeName((String)resultSet.getString("USER_ATT_NAME"));
            segmentCriteriaDTO.setAttributeDataType((String)resultSet.getString("USER_ATT_DATA_TYPE"));
            segmentCriteriaList.add(segmentCriteriaDTO);
        }
        return segmentCriteriaList;
    } catch (SQLException e) {
        logger.error(e.getLocalizedMessage(), e);
        throw new DataAccessException("error.db.access");
    }catch (Exception e){
        logger.error(e.getLocalizedMessage(), e);
        throw new DataAccessException("error.general.dao");
    }
    finally{
        DBUtil.getInstance().closeDBResources(connection, preparedStatement,resultSet);
    }
     }

    public HashMap getMatchedTaFaRegion(long userId) throws DataAccessException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        HashMap tacticMap = new HashMap();
        try {
            con = DBUtil.getInstance().createConnection();
            StringBuffer sb = new StringBuffer("");
            sb.append("SELECT ");
            sb.append("G.THERUPTICAREA, G.FUNCTIONALAREA, G.REGION ");
            sb.append("FROM GROUPS G , USER_GROUP_MAP GM ");
            sb.append("WHERE G.GROUPID = GM.GROUP_ID ");
            sb.append("AND GM.USER_ID=? ");

            pstmt = con.prepareStatement(sb.toString());
            pstmt.setLong(1,userId);
            rs = pstmt.executeQuery();

            TacticDTO tacticDTO = null;
            ArrayList groupList = new ArrayList();
            while(rs.next()) {
                tacticDTO = new TacticDTO();
                tacticDTO.setTA(rs.getString("THERUPTICAREA"));
                tacticDTO.setFA(rs.getString("FUNCTIONALAREA"));
                tacticDTO.setRegion(rs.getString("REGION"));
                groupList.add(tacticDTO);
            }
            rs.close();
            pstmt.close();

            if(groupList != null && groupList.size() > 0) {
                TacticDTO tacticDTO1 = null;
                for(int i=0;i<groupList.size();i++) {
                    tacticDTO1 = (TacticDTO) groupList.get(i);
                        if(tacticDTO1.getTA() != null && tacticDTO1.getFA() != null) {
                            sb = new StringBuffer("");
                            sb.append("SELECT ");
                            sb.append("KT.TACTIC_ID, KT.TACTIC_NAME ");
                            sb.append("FROM KOL_TACTICS KT ");
                            sb.append("WHERE KT.TA=?");
                            sb.append("AND KT.FA=?");
                            sb.append("AND KT.REGION=?");

                            pstmt = con.prepareStatement(sb.toString());
                            pstmt.setString(1,tacticDTO1.getTA());
                            pstmt.setString(2,tacticDTO1.getFA() );
                            pstmt.setString(3,tacticDTO1.getRegion() );

                            rs = pstmt.executeQuery();

                            while(rs.next()) {
                                tacticMap.put(rs.getString("TACTIC_ID")+"",rs.getString("TACTIC_NAME"));
                            }
                        }
                }
            }
            return tacticMap;
        } catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public ArrayList getMyTacticList(String staffid) throws DataAccessException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList tacticList = new ArrayList();
        InteractionsDTO interactionsDTO = null;
        try{
               con = DBUtil.getInstance().createConnection();
               StringBuffer sb = new StringBuffer();

            sb.append("select ");
            sb.append("u.id, u.kolid, u.firstname, ");
            sb.append("u.lastname, ");
            sb.append("kt.tactic_name, ");
            sb.append("o.optvalue as status , ");
            sb.append("to_char(k.due_date,'MM/dd/yyyy') as due_Date , ");
            sb.append("k.staffid,k.plan_id ");
            sb.append("from user_table u, kol_development_plan k,option_lookup o,kol_tactics kt ");
            sb.append("where k.staffid=? ");
            sb.append("and k.expert_id = u.id ");
            sb.append("and o.id = k.status ");
            sb.append("and to_char(kt.tactic_id) = k.activity and o.optvalue like \'In Progress\'");

              pstmt = con.prepareStatement(sb.toString());

             pstmt.setString(1,staffid);

             rs = pstmt.executeQuery();

             while(rs.next()) {
                 interactionsDTO = new InteractionsDTO();
                 interactionsDTO.setUserId(Integer.parseInt(rs.getString("ID")));
                 interactionsDTO.setExpertId(Long.parseLong(rs.getString("KOLID")) );
                 interactionsDTO.setPlanId(rs.getString("PLAN_ID"));
                 interactionsDTO.setFullName(rs.getString("LASTNAME")+", "+rs.getString("FIRSTNAME"));
                 interactionsDTO.setActivity(rs.getString("TACTIC_NAME"));
                 interactionsDTO.setStatusName(rs.getString("STATUS"));
                 interactionsDTO.setDueDate(rs.getString("DUE_DATE"));
                 tacticList.add(interactionsDTO);
              }
            return  tacticList;
        }catch (SQLException e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.db.access");
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
            throw new DataAccessException("error.general.dao");
        }
        finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }

    }
    public boolean isExists(String planId, long expertId) throws DataAccessException {

           Connection con = null;
           PreparedStatement pstmt = null;
           ResultSet rs = null;
             try{
                  con = DBUtil.getInstance().createConnection();
                  StringBuffer sb = new StringBuffer();

                 sb.append("select count(*) as plans  from kol_development_plan where activity=? and expert_id=? ");

                pstmt = con.prepareStatement(sb.toString());

                pstmt.setString(1,planId);
                pstmt.setLong(2,expertId);

                rs = pstmt.executeQuery();
                 int plans = 0;
                 while(rs.next()){
                     plans = rs.getInt("PLANS");
                 }
                 if (plans == 0 ){
                   return false;
                 }else {
                    return true;
                 }

           }catch (SQLException e) {
               logger.error(e.getLocalizedMessage(), e);
               throw new DataAccessException("error.db.access");
           } catch (Exception e) {
               logger.error(e.getLocalizedMessage(), e);
               throw new DataAccessException("error.general.dao");
           }
           finally {
               DBUtil.getInstance().closeDBResources(con, pstmt, rs);
           }


       }


}//end of class
