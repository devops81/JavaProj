/**
 * com.openq.eav.entitydetails.filter
 * tarun
 * Feb 25, 2009
 */
package com.openq.eav.entitydetails.filter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.openq.eav.scripts.OlConstants;

/*
 * Table Row Filter Impletementation for PrintSummaryProfile.
 * Checks for data in professional activities sub-tabs
 * Check for publications data and select the 3 publications after sorting
 */
public class PrintSummaryProfileFilterImpl implements ITableRowFilter {

    /*
     * Add all the required attributes
     */
    public long[] addFilterAttributes(long[] attributesList) {
        return attributesList;
    }

    /* (non-Javadoc)
     * @see com.openq.eav.entitydetails.filter.ITableRowFilter#doFiltering(java.util.Map)
     */
    public Map doFiltering(Map entityDetailsMap) {
        if (entityDetailsMap == null || entityDetailsMap.size() == 0)
            return new HashMap();
        Iterator iter = entityDetailsMap.keySet().iterator();

        while (iter.hasNext()) {
            String entityId = (String) iter.next();
            Map entityDetails = (Map) entityDetailsMap.get(entityId);

          //set the Societies data to display on the printSummary Profile
            putSocietiesData(entityDetails);

            //societies
            boolean exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Societies + "",
                    OlConstants.KOL_Professional_Activities_Societies_Societies_Description + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Societies + "", new Boolean(exists));

            //Patents
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Patents + "",
                    OlConstants.KOL_Professional_Activities_Patents_Patent_Title + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Patents + "", new Boolean(exists));

            //Honors
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Honors + "",
                    OlConstants.KOL_Professional_Activities_Honors_Honor_Description + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Honors + "", new Boolean(exists));

            //Presentation
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Presentation + "",
                    OlConstants.KOL_Professional_Activities_Presentation_Presentation_Title + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Presentation + "", new Boolean(exists));

            //Industry Activities
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Industry_Activities + "",
                    OlConstants.KOL_Professional_Activities_Industry_Activities_Industry_Type + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Industry_Activities + "", new Boolean(exists));

            //BMS Trials
            exists = doesDataExists(entityDetails, OlConstants.KOL_Trials_Bms_Trials + "",
                    OlConstants.KOL_Trials_Bms_Trials_Bms_Trials_Title + "");
            entityDetails.put(OlConstants.KOL_Trials_Bms_Trials + "", new Boolean(exists));

            //All Trials
            exists = doesDataExists(entityDetails, OlConstants.KOL_Trials_All_Trials + "",
                    OlConstants.KOL_Trials_All_Trials_Trial_Name + "");
            entityDetails.put(OlConstants.KOL_Trials_All_Trials + "", new Boolean(exists));

          //set the Editorial Boards data to display on the printSummary Profile
            putEditorialBoardsData(entityDetails);

            //Editorial Boards
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Editorial_Boards + "",
                    OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Journal + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Editorial_Boards + "", new Boolean(exists));

            //Committees
            exists = doesDataExists(entityDetails, OlConstants.KOL_Professional_Activities_Committees + "",
                    OlConstants.KOL_Professional_Activities_Committees_Committees_Type + "");
            entityDetails.put(OlConstants.KOL_Professional_Activities_Committees + "", new Boolean(exists));

            //set the top 3 pulications
            putPublicationsData(entityDetails);

            //set the iPlan Data tab data to display on the printSummary Profile
            putSpeakerContractData(entityDetails);

            //Publications
            exists = doesDataExists(entityDetails, OlConstants.KOL_Publications_Publications + "",
                    OlConstants.KOL_Publications_Publications_Medline_Id + "");
            entityDetails.put(OlConstants.KOL_Publications_Publications + "", new Boolean(exists));

        }

        return entityDetailsMap;
    }

    /*
     * This method checks for the attribute value in the table rows. If value for the given
     * attribute exists in any of the rows then return true else false
     * FIXME Can we check any attribute under this table entity or we have to check only the specified attribute ?
     */
    private boolean doesDataExists(Map expertDetails, String tabId, String attributeId) {

        if (expertDetails.containsKey(tabId)) {
            Map tableRows = (Map) expertDetails.get(tabId);
            if (tableRows == null || tableRows.size() == 0)
                return false;
            Iterator iter = tableRows.keySet().iterator();
            while (iter.hasNext()) {
                String rowId = (String) iter.next();
                Map row = (Map) tableRows.get(rowId);
                if (row.containsKey(attributeId)) {
                    Object value = row.get(attributeId);
                    if (value != null)
                        return true;
                }
            }
            return false;
        }
        return false;
    }

    /*
     * The sorting of the publications is done on the basis of the
     * publication date
     */
    private void putPublicationsData(Map expertDetails) {
        if (expertDetails.containsKey(OlConstants.KOL_Publications_Publications + "")) {
            Map publicationRows = (Map) expertDetails.get(OlConstants.KOL_Publications_Publications + "");
            if (publicationRows == null || publicationRows.size() == 0)
                return;
            Iterator iter = publicationRows.keySet().iterator();
            List publicationList = new ArrayList();
            while (iter.hasNext()) {
                String rowId = (String) iter.next();
                Map row = (Map) publicationRows.get(rowId);

                Object medlineIdObj = row.get(OlConstants.KOL_Publications_Publications_Medline_Id + "");
                Object pubDateObj = row.get(OlConstants.KOL_Publications_Publications_Publication_Date + "");
                Object pubTitleObj = row.get(OlConstants.KOL_Publications_Publications_Pub_Title + "");
                Object journalObj = row.get(OlConstants.KOL_Publications_Publications_Journal + "");

                if (medlineIdObj != null && ((String) medlineIdObj).trim().length() > 0) {
                    Map publicationMap = new HashMap();
                    String medlineIdString = ((String) medlineIdObj).trim();
                    publicationMap.put("pubMedId", medlineIdString);
                    publicationMap.put("pubTitle", (pubTitleObj == null) ? "" : (String) pubTitleObj);
                    publicationMap.put("pubDate", (pubDateObj == null) ? "" : (String) pubDateObj);
                    publicationMap.put("pubJournal", (journalObj == null) ? "" : (String) journalObj);

                    publicationList.add(publicationMap);
                }
            }
            // sort the publication list according the publication date
            Comparator c = new Comparator() {
                public int compare(Object publication1, Object publication2) {
                    String date1 = (String) (((Map) publication1).get("pubDate"));
                    String date2 = (String) (((Map) publication2).get("pubDate"));

                    return date1.compareTo(date2);

                }
            };
            Collections.sort(publicationList, c);

            //select the latest 3 publications
            List newPublicationList = new ArrayList();
            if (publicationList.size() > 0) {
                int size = publicationList.size();
                int endNumber = size - 3;
                if (endNumber < 0)
                    endNumber = 0;
                newPublicationList = publicationList.subList(endNumber, size);

                //put the Publication medline id list in the expertdetails map
                expertDetails.put("PUBLICATION_LIST", newPublicationList);

            }
        }
        return;
    }

    private void putSpeakerContractData(Map expertDetails) {
        if (expertDetails.containsKey(OlConstants.KOL_iPlan_Data + "")) {
            Map speakerContractRows = (Map) expertDetails.get(OlConstants.KOL_iPlan_Data + "");
            if (speakerContractRows == null || speakerContractRows.size() == 0)
                return;
            Iterator iter = speakerContractRows.keySet().iterator();
            List speakerContractList = new ArrayList();
            while (iter.hasNext()) {
                String rowId = (String) iter.next();
                Map row = (Map) speakerContractRows.get(rowId);

                Object productObj = row.get(OlConstants.KOL_iPlan_Data_Product + "");
                Object activeObj = row.get(OlConstants.KOL_iPlan_Data_Active + "");
                Object startDateObj = row.get(OlConstants.KOL_iPlan_Data_StartDate + "");
                Object endDateObj = row.get(OlConstants.KOL_iPlan_Data_EndDate + "");

                if ((productObj != null && ((String) productObj).trim().length() > 0) ||
                        (activeObj != null && ((String) activeObj).trim().length() > 0) ||
                        (startDateObj != null && ((String) startDateObj).trim().length() > 0) ||
                        (endDateObj != null && ((String) endDateObj).trim().length() > 0)) {
                    Map speakerContractMap = new HashMap();

                    speakerContractMap.put("iPlanProduct", (productObj == null) ? "" : (String) productObj);
                    speakerContractMap.put("iPlanActive", (activeObj == null) ? "" : (String) activeObj);
                    speakerContractMap.put("iPlanStartDate", (startDateObj == null) ? "" : (String) startDateObj);
                    speakerContractMap.put("iPlanEndDate", (endDateObj == null) ? "" : (String) endDateObj);

                    speakerContractList.add(speakerContractMap);
                }
            }
                //put the Speaker Contract iPlan_Data data in the expertdetails map
                expertDetails.put("SPEAKERCONTRACT_LIST", speakerContractList);
        }
        return;

    }

    private void putSocietiesData(Map expertDetails) {
        if (expertDetails.containsKey(OlConstants.KOL_Professional_Activities_Societies + "")) {
            System.out.println(expertDetails.get(OlConstants.KOL_Professional_Activities_Societies + "").getClass());
            Map societiesRows = (Map) expertDetails.get(OlConstants.KOL_Professional_Activities_Societies + "");
            if (societiesRows == null || societiesRows.size() == 0)
                return;
            Iterator iter = societiesRows.keySet().iterator();
            List societiesList = new ArrayList();
            while (iter.hasNext()) {
                String rowId = (String) iter.next();
                Map row = (Map) societiesRows.get(rowId);

                Object descriptionObj = row.get(OlConstants.KOL_Professional_Activities_Societies_Societies_Description + "");
                Object boardObj = row.get(OlConstants.KOL_Professional_Activities_Societies_Societies_Board + "");
                Object titleObj = row.get(OlConstants.KOL_Professional_Activities_Societies_Societies_Title + "");
                Object yearsObj = row.get(OlConstants.KOL_Professional_Activities_Societies_Societies_Years + "");

                if ((descriptionObj != null && ((String) descriptionObj).trim().length() > 0) ||
                        (boardObj != null && ((String) boardObj).trim().length() > 0) ||
                        (titleObj != null && ((String) titleObj).trim().length() > 0) ||
                        (yearsObj != null && ((String) yearsObj).trim().length() > 0)) {
                    Map societiesMap = new HashMap();

                    societiesMap.put("societiesDescription", (descriptionObj == null) ? "" : (String) descriptionObj);
                    societiesMap.put("societiesBoard", (boardObj == null) ? "" : (String) boardObj);
                    societiesMap.put("societiesTitle", (titleObj == null) ? "" : (String) titleObj);
                    societiesMap.put("societiesYears", (yearsObj == null) ? "" : (String) yearsObj);

                    societiesList.add(societiesMap);
                }
            }
                //put the Societies data in the expertdetails map
                expertDetails.put("SOCIETIES_LIST", societiesList);
        }

        return;

    }


    private void putEditorialBoardsData(Map expertDetails) {
        if (expertDetails.containsKey(OlConstants.KOL_Professional_Activities_Editorial_Boards + "")) {
            Map editorialBoardRows = (Map) expertDetails.get(OlConstants.KOL_Professional_Activities_Editorial_Boards + "");
            if (editorialBoardRows == null || editorialBoardRows.size() == 0)
                return;
            Iterator iter = editorialBoardRows.keySet().iterator();
            List editorialBoardList = new ArrayList();
            while (iter.hasNext()) {
                String rowId = (String) iter.next();
                Map row = (Map) editorialBoardRows.get(rowId);

                Object journalObj = row.get(OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Journal + "");
                Object positionObj = row.get(OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Position + "");
                Object datesObj = row.get(OlConstants.KOL_Professional_Activities_Editorial_Boards_Editorial_Board_Dates + "");

                if ((journalObj != null && ((String) journalObj).trim().length() > 0) ||
                        (positionObj != null && ((String) positionObj).trim().length() > 0) ||
                        (datesObj != null && ((String) datesObj).trim().length() > 0)) {
                    Map editorialBoardMap = new HashMap();

                    editorialBoardMap.put("editorialBoardJournal", (journalObj == null) ? "" : (String) journalObj);
                    editorialBoardMap.put("editorialBoardPosition", (positionObj == null) ? "" : (String) positionObj);
                    editorialBoardMap.put("editorialBoardDates", (datesObj == null) ? "" : (String) datesObj);

                    editorialBoardList.add(editorialBoardMap);
                }
            }
                //put the Editorial Boards data in the expertdetails map
                expertDetails.put("EDITORIALBOARD_LIST", editorialBoardList);
        }
        return;

    }



}
