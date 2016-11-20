package com.openq.ovid;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;

import org.apache.log4j.Logger;

import com.openq.kol.DataAccessException;
import com.openq.kol.DBUtil;
import com.openq.kol.SearchDTO;


public class PublicationsDAOImpl implements PublicationsDAOInterface {

    private static Logger logger = Logger.getLogger(PublicationsDAOImpl.class);


    /**
     *
     * @param authorId
     * @return
     * @throws DataAccessException
     */
    public SearchDTO getOVIDAuthor(int authorId) throws DataAccessException {
        PreparedStatement pstmt = null;
        PreparedStatement pstmtInner = null;
        Connection con = null;
        ResultSet rs = null;
        ResultSet rsInner = null;
        try {

            con = DBUtil.getInstance().createConnection();
            StringBuffer sb = new StringBuffer("");
            sb.append("SELECT * FROM SPECIALTY_VIEW WHERE ID=?");

            pstmt = con.prepareStatement(sb.toString());
            pstmt.setInt(1, authorId);
            rs = pstmt.executeQuery();
            SearchDTO searchDTO = new SearchDTO();
            String specialty = null;
            String institution = null;
            int authId = -1;
            while (rs.next()) {
                if (authId != rs.getInt("ID")) {
                    specialty = null;
                    searchDTO.setExpertName(rs.getString("LASTNAME") + ", " + rs.getString("FIRSTNAME"));
                    if (rs.getString("SPECIALTY1") != null && !"".equals(rs.getString("SPECIALTY1"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY1");
                        } else {
                            specialty = rs.getString("SPECIALTY1");
                        }
                    }
                    if (rs.getString("SPECIALTY2") != null && !"".equals(rs.getString("SPECIALTY2"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY2");
                        } else {
                            specialty = rs.getString("SPECIALTY2");
                        }
                    }
                    if (rs.getString("SPECIALTY3") != null && !"".equals(rs.getString("SPECIALTY3"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY3");
                        } else {
                            specialty = rs.getString("SPECIALTY3");
                        }
                    }
                    if (rs.getString("SPECIALTY4") != null && !"".equals(rs.getString("SPECIALTY4"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY4");
                        } else {
                            specialty = rs.getString("SPECIALTY4");
                        }
                    }
                    if (rs.getString("SPECIALTY5") != null && !"".equals(rs.getString("SPECIALTY5"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY5");
                        } else {
                            specialty = rs.getString("SPECIALTY5");
                        }
                    }
                    if (rs.getString("SPECIALTY6") != null && !"".equals(rs.getString("SPECIALTY6"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY6");
                        } else {
                            specialty = rs.getString("SPECIALTY6");
                        }
                    }
                    if (specialty != null) {
                        searchDTO.setSpecialty(specialty);
                    }
                    sb = new StringBuffer();
                    sb.append(" SELECT * FROM LOCATION_VIEW WHERE ID=?");

                    pstmtInner = con.prepareStatement(sb.toString());
                    pstmtInner.setInt(1,rs.getInt("ID"));
                    rsInner = pstmtInner.executeQuery();
                    while(rsInner.next()) {
                        if(rsInner.getString("STATE") != null) {
                            searchDTO.setState(rsInner.getString("STATE"));
                        }
                        if(rsInner.getString("COUNTRY") != null) {
                            searchDTO.setCountry(rsInner.getString("COUNTRY"));
                        }
                    }
                    rsInner.close();
                    pstmtInner.close();

                    sb = new StringBuffer();
                    sb.append("SELECT A.ID,B.VALUE AS INSTITUTION FROM USER_TABLE A, STRING_ATTRIBUTE B, ENTITIES_ATTRIBUTE D, ");
                    sb.append("ENTITIES_ATTRIBUTE E WHERE D.PARENT_ID=A.KOLID AND D.ATTRIBUTE_ID=2 AND E.PARENT_ID=D.MYENTITY_ID ");
                    sb.append("AND E.ATTRIBUTE_ID=186 AND B.PARENT_ID=E.MYENTITY_ID AND B.ATTRIBUTE_ID=189 AND A.ID=?");
                    pstmtInner = con.prepareStatement(sb.toString());

                    pstmtInner.setInt(1,rs.getInt("ID"));
                    rsInner = pstmtInner.executeQuery();
                    while(rsInner.next()) {
                        if(institution != null) {
                            institution += ", "+ rsInner.getString("INSTITUTION");
                        } else {
                            institution = rsInner.getString("INSTITUTION");
                        }

                    }
                    if(institution != null) {
                        searchDTO.setInstitution(institution);
                    }
                    rsInner.close();
                    pstmtInner.close();

                } else {
                    //todo: do nothing for now.
                }
                authId = rs.getInt("ID");
            }
            rs.close();
            pstmt.close();

            return searchDTO;
        } catch (SQLException sqe) {
            logger.debug(sqe.getMessage());
            throw new DataAccessException("error.db.access");
        } catch (Exception e) {
            logger.debug(e.getMessage());
            throw new DataAccessException("error.general.dao");
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public ArrayList getUniqueIdentifier(int authorId) throws DataAccessException {

        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        ArrayList identifierLst = null;
        try {

            con = DBUtil.getInstance().createConnection();
            String selAccount = "SELECT UNIQUE_IDENTIFIER FROM PUBLICATIONS WHERE AUTHOR_ID=?";
            pstmt = con.prepareStatement(selAccount);
            pstmt.setInt(1, authorId);

            rs = pstmt.executeQuery();

            identifierLst = new ArrayList();
            while (rs.next()) {
                identifierLst.add(rs.getString("UNIQUE_IDENTIFIER"));
            }
            rs.close();
            pstmt.close();

            return identifierLst;
        } catch (SQLException sqe) {
            logger.debug(sqe.getMessage());
            throw new DataAccessException("error.db.access");
        } catch (Exception e) {
            logger.debug(e.getMessage());
            throw new DataAccessException("error.general.dao");
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }

    }


    /**
     * @return
     * @throws DataAccessException
     */
    public ArrayList refreshProfiles() throws DataAccessException {
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        OvidResultsDTO resultsDTO = null;
        ArrayList publicationList = new ArrayList();

        try {
            con = DBUtil.getInstance().createConnection();
            TreeMap totalPub = new TreeMap();
            StringBuffer query = new StringBuffer("");
            /*
             * This query brings the count of committed publications
             */
            query.append("SELECT AUTHOR_ID, COUNT(UNIQUE_IDENTIFIER) AS TOTAL_PUBLICATIONS FROM UNCOMMITED_PUBLICATIONS WHERE DELETE_FLAG = 'Y' AND COMMITTED_FLAG='Y' GROUP BY AUTHOR_ID");

            pstmt = con.prepareStatement(query.toString());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                totalPub.put(rs.getInt("AUTHOR_ID") + "", rs.getInt("TOTAL_PUBLICATIONS") + "");
            }
            rs.close();
            pstmt.close();

            query = new StringBuffer("");
            /*
             * This query brings the count of uncommitted publications
             */
            query.append("SELECT AUTHOR_ID, COUNT(UNIQUE_IDENTIFIER) AS NEW_PUBLICATIONS FROM UNCOMMITED_PUBLICATIONS ");
            query.append(" WHERE DELETE_FLAG = 'N' AND COMMITTED_FLAG='N' GROUP BY AUTHOR_ID");

            TreeMap newPub = new TreeMap();

            pstmt = con.prepareStatement(query.toString());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                newPub.put(rs.getInt("AUTHOR_ID") + "", rs.getInt("NEW_PUBLICATIONS") + "");
            }
            rs.close();
            pstmt.close();

            query = new StringBuffer("");
            query.append("SELECT AUTHOR_ID, MAX(UPDATE_TIME) AS UPDATE_TIME FROM UNCOMMITED_PUBLICATIONS GROUP BY AUTHOR_ID");
            TreeMap updateTimeMap = new TreeMap();

            pstmt = con.prepareStatement(query.toString());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                updateTimeMap.put(rs.getInt("AUTHOR_ID") + "", rs.getDate("UPDATE_TIME"));
            }
            rs.close();
            pstmt.close();
            // Getting commited publications
            query = new StringBuffer("");
            query.append("SELECT DISTINCT A.AUTHOR_ID,B.FIRSTNAME,B.LASTNAME FROM UNCOMMITED_PUBLICATIONS A, USER_TABLE B WHERE ");
            query.append(" A.AUTHOR_ID=B.ID AND B.DELETEFLAG='N'");
            pstmt = con.prepareStatement(query.toString());
            rs = pstmt.executeQuery();
            int authorId = 0;
            while (rs.next()) {
                authorId = rs.getInt("AUTHOR_ID");
                resultsDTO = new OvidResultsDTO();
                resultsDTO.setAuthorId(authorId);
                resultsDTO.setExpertName(rs.getString("LASTNAME") + ", " + rs.getString("FIRSTNAME"));
                if (totalPub.containsKey(authorId + "")) {
                    resultsDTO.setTotalPublication(Integer.parseInt((String) totalPub.get(authorId + "")));
                }
                if (newPub.containsKey(authorId + "")) {
                    resultsDTO.setNewPublications(Integer.parseInt((String) newPub.get(authorId + "")));
                }

                if (updateTimeMap.containsKey(authorId + "")) {
                    resultsDTO.setLastUpdate((java.util.Date) updateTimeMap.get(authorId + ""));
                }
                publicationList.add(resultsDTO);
            }
            rs.close();
            pstmt.close();

            return publicationList;
        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    /**
     * @param attributes
     * @throws DataAccessException
     */
    public void populateUncommitedPublications(ArrayList attributes) throws DataAccessException {
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;

        try {
            if (attributes != null && attributes.size() > 0) {
                con = DBUtil.getInstance().createConnection();
                TreeMap uniqueIdentifiers = new TreeMap();
                String selQuery = "SELECT AUTHOR_ID,UNIQUE_IDENTIFIER,TITLE FROM UNCOMMITED_PUBLICATIONS";
                pstmt = con.prepareStatement(selQuery);

                rs = pstmt.executeQuery();
                while (rs.next()) {
                    uniqueIdentifiers.put(rs.getString("UNIQUE_IDENTIFIER") + rs.getString("AUTHOR_ID"), rs.getString("TITLE"));
                }
                StringBuffer strBuff = new StringBuffer(" ");
                strBuff.append(" INSERT INTO UNCOMMITED_PUBLICATIONS(PUBLICATION_ID,AUTHOR_ID,UNIQUE_IDENTIFIER,PUBLICATION_TYPE,SOURCE,NLM_JOURNAL_NAME,TITLE,");
                strBuff.append(" ABSTRACT,DATE_OF_PUBLICATION,YEAR_OF_PUBLICATION,SUBJECT_HEADING,COUNTRY_OF_PUBLICATION,LANGUAGE,CREATE_TIME,CONFIDENCE_FACTOR,AUTHORS,DELETE_FLAG,TIMER_STATE,COMMITTED_FLAG) VALUES ((SELECT NVL(MAX(PUBLICATION_ID),0)+1 FROM UNCOMMITED_PUBLICATIONS),");
                strBuff.append(" ?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?,?,'N','0','N')");


                ArrayList ovidAuthors = null;
                Publications publications = null;
                boolean insFlag = false;
                String author = null;
                int identifier = 0;
                for (int i = 0; i < attributes.size(); i++) {
                    insFlag = false;
                    ovidAuthors = (ArrayList) attributes.get(i);
                    if (null != ovidAuthors && ovidAuthors.size() > 0) {
                        for (int j = 0; j < ovidAuthors.size(); j++) {
                            insFlag = false;
                            publications = (Publications) ovidAuthors.get(j);
                            if (publications != null && publications.getExpertId() != null
                                    && !"".equals(publications.getExpertId())) {

                                author = publications.getExpertId();
                                identifier = publications.getUniqueIdentifier();
                                String key = identifier + author;
                                if (uniqueIdentifiers != null && uniqueIdentifiers.size() > 0) {
                                    if (uniqueIdentifiers.containsKey(key)) {
                                        insFlag = false;
                                    } else if (uniqueIdentifiers.containsKey(key) &&
                                            (((String) uniqueIdentifiers.get(key)).trim().equalsIgnoreCase(publications.getTitle().trim())
                                            )) {
                                        insFlag = false;
                                    } else {
                                        insFlag = true;
                                    }
                                } else
                                if ((uniqueIdentifiers == null) || (uniqueIdentifiers != null && uniqueIdentifiers.size() == 0))
                                {
                                    insFlag = true;
                                }
                                if (insFlag && publications.getUniqueIdentifier() != 0) {
                                    pstmt = con.prepareStatement(strBuff.toString());

                                    String title = "";
                                    if(publications.getTitle() != null) {
                                        if(publications.getTitle().length() > 4000) {
                                            title = publications.getTitle().substring(0,4000);
                                        } else {
                                            title = publications.getTitle();
                                        }
                                    }

                                    String authors = "";
                                    if(publications.getAuthor() != null) {
                                        if(publications.getAuthor().length() > 4000) {
                                            authors = publications.getAuthor().substring(0,4000);
                                        } else {
                                            authors = publications.getAuthor();
                                        }
                                    }

                                    String abstracts = "";
                                    if(publications.getJournalAbstract() != null) {
                                        if(publications.getJournalAbstract().length() > 4000) {
                                            abstracts = publications.getJournalAbstract().substring(0,4000);
                                        } else {
                                            abstracts = publications.getJournalAbstract();
                                        }
                                    }

                                    pstmt.setInt(1, Integer.parseInt(publications.getExpertId()));
                                    pstmt.setInt(2, publications.getUniqueIdentifier());
                                    pstmt.setString(3, publications.getType());
                                    pstmt.setString(4, publications.getSource());
                                    pstmt.setString(5, publications.getNlmJournal());
                                    pstmt.setString(6, title);
                                    pstmt.setString(7, abstracts);
                                    pstmt.setString(8, publications.getDateOfPublication());
                                    pstmt.setString(9, publications.getYear());
                                    pstmt.setString(10, publications.getSubjectHeading());
                                    pstmt.setString(11, publications.getCountryOfPublication());
                                    pstmt.setString(12, publications.getLanguage());
                                    pstmt.setString(13, publications.getConfidenceFactor() + "");
                                    pstmt.setString(14, authors);
                                    pstmt.executeUpdate();
                                    con.commit();
                                    System.out.println("long  == "+publications.getExpertId());
                                    pstmt.close();
                                }
                            }
                        }
                    }
                    ovidAuthors = null;
                }
            }
            attributes = null;

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    /**
     * @param authorId
     * @throws DataAccessException
     */
    public ArrayList showNewPubs(int authorId) throws DataAccessException {
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        ArrayList newPubs = new ArrayList();
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append(" SELECT AUTHOR_ID, TITLE, YEAR_OF_PUBLICATION YEAR, PUBLICATION_TYPE, CONFIDENCE_FACTOR, AUTHORS, NLM_JOURNAL_NAME, UNIQUE_IDENTIFIER,SOURCE FROM UNCOMMITED_PUBLICATIONS WHERE AUTHOR_ID=? AND DELETE_FLAG='N' AND TIMER_STATE = '0'");

            pstmt = con.prepareStatement(strBuff.toString());
            pstmt.setInt(1, authorId);
            rs = pstmt.executeQuery();
            Publications publications = null;
            while (rs.next()) {
                publications = new Publications();
                publications.setExpertId(rs.getInt("AUTHOR_ID") + "");
                publications.setTitle(rs.getString("TITLE"));
                publications.setYear(rs.getString("YEAR"));
                publications.setType(rs.getString("PUBLICATION_TYPE"));
                publications.setNlmJournal(rs.getString("NLM_JOURNAL_NAME"));
                if (rs.getString("CONFIDENCE_FACTOR") != null) {
                    publications.setConfidenceFactor(Integer.parseInt(rs.getString("CONFIDENCE_FACTOR")));
                }
                publications.setAuthor(rs.getString("AUTHORS"));
                publications.setUniqueIdentifier(rs.getInt("UNIQUE_IDENTIFIER"));
                publications.setCitation(rs.getString("SOURCE"));

                newPubs.add(publications);
            }
            rs.close();
            pstmt.close();

            return newPubs;

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    /**
     * @param uniqueId
     * @throws DataAccessException
     */
    public String[] getAbstract(String expId, String uniqueId) throws DataAccessException {
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        String result[] = new String[2];
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append(" SELECT ABSTRACT,TITLE FROM UNCOMMITED_PUBLICATIONS WHERE AUTHOR_ID=? AND UNIQUE_IDENTIFIER=?");

            pstmt = con.prepareStatement(strBuff.toString());
            pstmt.setInt(1, Integer.parseInt(expId));
            pstmt.setInt(2, Integer.parseInt(uniqueId));
            rs = pstmt.executeQuery();

            while (rs.next()) {
                result[0] = rs.getString(1);
                result[1] = rs.getString(2);
            }
            rs.close();
            pstmt.close();

            return result;

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public void updateOvidScheduleDetails(String startTime, String startDate, String days) throws DataAccessException {
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append("SELECT * FROM PUBLICATION_SCHEDULE ");

            pstmt = con.prepareStatement(strBuff.toString());
            rs = pstmt.executeQuery();
            int scheduleId = -1;
            while(rs.next()) {
                scheduleId = rs.getInt("SCHEDULE_ID");
            }
            if(scheduleId != -1) {
                strBuff = new StringBuffer(" ");
                strBuff.append("UPDATE PUBLICATION_SCHEDULE SET START_TIME=?, START_DATE=?, EXECUTION_DAYS=? WHERE SCHEDULE_ID=? ");
                pstmt = con.prepareStatement(strBuff.toString());
                pstmt.setString(1,startTime);
                pstmt.setString(2,startDate);
                pstmt.setString(3,days);
                pstmt.setInt(4,scheduleId);

                pstmt.executeUpdate();

            } else {
                strBuff = new StringBuffer(" ");
                strBuff.append("INSERT INTO PUBLICATION_SCHEDULE VALUES ((SELECT NVL(MAX(SCHEDULE_ID),0)+1 FROM PUBLICATION_SCHEDULE),?,?,?)");
                pstmt = con.prepareStatement(strBuff.toString());
                pstmt.setString(1,startTime);
                pstmt.setString(2,startDate);
                pstmt.setString(3,days);

                pstmt.executeUpdate();
            }

            con.commit();

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public String[] getOvidScheduleDetails() throws DataAccessException {
        String[] results = new String[3];
        PreparedStatement pstmt = null;
        Connection con = null;
        ResultSet rs = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append("SELECT * FROM PUBLICATION_SCHEDULE");

            pstmt = con.prepareStatement(strBuff.toString());

            rs = pstmt.executeQuery();
            while (rs.next()) {
                results[0] = rs.getString("START_TIME");
                results[1] = rs.getString("START_DATE");
                results[2] = rs.getString("EXECUTION_DAYS");
            }

            return results;
        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public void deletePublication(String uniqueId) throws DataAccessException {

        PreparedStatement pstmt = null;
        Connection con = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append("UPDATE UNCOMMITED_PUBLICATIONS SET DELETE_FLAG = 'Y' WHERE UNIQUE_IDENTIFIER = " + uniqueId);

            pstmt = con.prepareStatement(strBuff.toString());

            pstmt.executeUpdate();

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }
    }

    public void deleteCommittedPublication(String uniqueIdList) throws DataAccessException {

        PreparedStatement pstmt = null;
        Connection con = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer(" ");
            strBuff.append("UPDATE PUBLICATIONS SET DELETE_FLAG = 'Y' WHERE UNIQUE_IDENTIFIER IN (" + uniqueIdList +")");

            pstmt = con.prepareStatement(strBuff.toString());

            pstmt.executeUpdate();

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }
    }

    public void resetTimerState()throws DataAccessException{
        PreparedStatement pstmt = null;
        Connection con = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer("");
            strBuff.append("UPDATE UNCOMMITED_PUBLICATIONS SET TIMER_STATE = '0'");

            pstmt = con.prepareStatement(strBuff.toString());

            pstmt.executeUpdate();
            con.commit();

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }

    }

    public void logPubException(int authorId,int build)throws DataAccessException{
        PreparedStatement pstmt = null;
        Connection con = null;
        try {
            con = DBUtil.getInstance().createConnection();

            StringBuffer strBuff = new StringBuffer("");
            strBuff.append("INSERT INTO PUBLICATIONS_EXCEPTION(ID,AUTHOR_ID,BUILD,CREATE_TIME)");
            strBuff.append(" VALUES((SELECT MAX(ID)+1 FROM PUBLICATIONS_EXCEPTION),?,?,?)");

            //logger.info(strBuff.toString());

            pstmt = con.prepareStatement(strBuff.toString());

            pstmt.setLong(1,authorId);
            pstmt.setLong(2,build);
            pstmt.setTimestamp(3,new Timestamp(new Date().getTime()));

            pstmt.executeUpdate();
            con.commit();

        } catch (SQLException sqe) {
            logger.error(sqe.getMessage(), sqe);
            throw new DataAccessException("error.db.access", sqe);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, null);
        }
    }

    public ArrayList getMatchingAuthorList() throws DataAccessException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList authorList = new ArrayList();

        try {
            con = DBUtil.getInstance().createConnection();
            StringBuffer stringBuffer = new StringBuffer("");
            stringBuffer.append("SELECT * FROM SPECIALTY_VIEW ");

            pstmt = con.prepareStatement(stringBuffer.toString());
            rs = pstmt.executeQuery();
            SearchDTO searchDTO = null;
            int authorId = -1;
            String specialty;
            String institution = null;
            String location = null;
            while (rs.next()) {
                if (authorId != rs.getInt("ID")) {
                    specialty = null;
                    institution = null;
                    searchDTO = new SearchDTO();

                    searchDTO.setUserid(rs.getInt("ID"));
                    searchDTO.setFirstName(rs.getString("FIRSTNAME"));
                    searchDTO.setMiddleName(rs.getString("MIDDLENAME"));
                    searchDTO.setLastName(rs.getString("LASTNAME"));

                    /*if (rs.getString("SPECIALTY1") != null && !"".equals(rs.getString("SPECIALTY1"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY1");
                        } else {
                            specialty = rs.getString("SPECIALTY1");
                        }
                    }
                    if (rs.getString("SPECIALTY2") != null && !"".equals(rs.getString("SPECIALTY2"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY2");
                        } else {
                            specialty = rs.getString("SPECIALTY2");
                        }
                    }
                    if (rs.getString("SPECIALTY3") != null && !"".equals(rs.getString("SPECIALTY3"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY3");
                        } else {
                            specialty = rs.getString("SPECIALTY3");
                        }
                    }
                    if (rs.getString("SPECIALTY4") != null && !"".equals(rs.getString("SPECIALTY4"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY4");
                        } else {
                            specialty = rs.getString("SPECIALTY4");
                        }
                    }
                    if (rs.getString("SPECIALTY5") != null && !"".equals(rs.getString("SPECIALTY5"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY5");
                        } else {
                            specialty = rs.getString("SPECIALTY5");
                        }
                    }
                    if (rs.getString("SPECIALTY6") != null && !"".equals(rs.getString("SPECIALTY6"))) {
                        if (specialty != null) {
                            specialty += ", " + rs.getString("SPECIALTY6");
                        } else {
                            specialty = rs.getString("SPECIALTY6");
                        }
                    }
                    if (specialty != null) {
                        searchDTO.setSpecialty(specialty);
                    }*/


                    /*institution = rs.getString("INSTITUTION");
                    searchDTO.setInstitution(institution);*/
                    authorList.add(searchDTO);
                } else {
                    /*if (institution != null) {
                        institution += ", " + rs.getString("INSTITUTION");
                    } else {
                        institution = rs.getString("INSTITUTION");
                    }
                    authorList.remove(searchDTO);
                    searchDTO.setInstitution(institution);
                    authorList.add(searchDTO);*/
                }
                authorId = rs.getInt("ID");
            }

            return authorList;
        } catch (SQLException sqle) {
            logger.error("SQLException in getFilteredExpertList", sqle);
            throw new DataAccessException("error.db.access", sqle);
        } catch (Exception e) {
            logger.error("Error in getFilteredExpertList", e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }
    }

    public ArrayList getPublications(TreeMap pubMap) throws DataAccessException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList pubList = new ArrayList();
        try {
            if (pubMap != null && pubMap.size() > 0) {
                con = DBUtil.getInstance().createConnection();
                Set pubSet = pubMap.keySet();
                Iterator itr = pubSet.iterator();
                String key = null;
                String val = null;
                Publications publications = null;
                while (itr.hasNext()) {
                    key = (String) itr.next();
                    val = (String) pubMap.get(key);
                    String query = "SELECT * FROM UNCOMMITED_PUBLICATIONS WHERE UNIQUE_IDENTIFIER=? AND AUTHOR_ID=?";
                    pstmt = con.prepareStatement(query);
                    pstmt.setLong(1, Long.parseLong(key));
                    pstmt.setLong(2, Long.parseLong(val));

                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        publications = new Publications();
                        publications.setTitle(rs.getString("TITLE"));
                        publications.setType(rs.getString("PUBLICATION_TYPE"));
                        publications.setYear(rs.getString("YEAR_OF_PUBLICATION"));
                        publications.setNlmJournal(rs.getString("NLM_JOURNAL_NAME"));

                        pubList.add(publications);
                    }
                    rs.close();
                    pstmt.close();

                    // making delete_flag as yes once publications and put against profile
                    query = "UPDATE UNCOMMITED_PUBLICATIONS SET DELETE_FLAG='Y', COMMITTED_FLAG='Y', UPDATE_TIME=SYSDATE WHERE UNIQUE_IDENTIFIER=? AND AUTHOR_ID=?";
                    pstmt = con.prepareStatement(query);
                    pstmt.setLong(1, Long.parseLong(key));
                    pstmt.setLong(2, Long.parseLong(val));
                    pstmt.executeUpdate();
                }

            }
            return pubList;
        } catch (SQLException sqle) {
            logger.error("SQLException in getFilteredExpertList", sqle);
            throw new DataAccessException("error.db.access", sqle);
        } catch (Exception e) {
            logger.error("Error in getFilteredExpertList", e);
            throw new DataAccessException("error.general.dao", e);
        } finally {
            DBUtil.getInstance().closeDBResources(con, pstmt, rs);
        }

    }

}//end of class
