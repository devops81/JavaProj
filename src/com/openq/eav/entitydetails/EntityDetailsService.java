/**
 * com.openq.eav.entitydetails
 * tarun
 * Nov 3, 2008
 */
package com.openq.eav.entitydetails;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.EavConstants;
import com.openq.eav.entitydetails.filter.FilterFactory;
import com.openq.eav.entitydetails.filter.ITableRowFilter;
import com.openq.eav.metadata.AttributeType;
import com.openq.utils.HibernateUtilService;
import com.openq.utils.SqlAndHqlUtilFunctions;

/**
 *
 */
public class EntityDetailsService extends HibernateDaoSupport implements IEntityDetailsService {

    Logger logger = Logger.getLogger(EntityDetailsService.class);

    private final String stringAttributeTable = "StringAttribute";

    private final String booleanAttributeTable = "BooleanAttribute";

    /** (non-Javadoc)
     * @see com.openq.eav.entitydetails.IEntityDetailsService#getOlDetails(long[], long[])
     */
    public Map getOlDetails(long[] entityIds, long[] attributes, List filterNames) {

        //instantiate all the filters using FilterFactory
        List filterObjects = new ArrayList();
        for (int i = 0; i < filterNames.size(); i++) {
            try {
                ITableRowFilter filter = FilterFactory.createFilter((String) filterNames.get(i));
                filterObjects.add(filter);
            } catch (Exception e) {
                logger.warn("Exception caught. Failed to instantiate the filter class with name " + filterNames.get(i));
                logger.warn(e.getMessage());
                e.printStackTrace();
            }
        }

        logger.debug("Appending the filter attributes");
        //add the extra attributes which are required in filtering
        long[] updatedAttributesArray = attributes;
        for (int i = 0; i < filterObjects.size(); i++) {
            updatedAttributesArray = ((ITableRowFilter) filterObjects.get(i))
                    .addFilterAttributes(updatedAttributesArray);
        }
        logger.debug("the filter attributes appended");

        //make a database query
        Map olsMap = fetchExpertDetails(entityIds, updatedAttributesArray);

        //start filtering the details in olsMap
        for (int i = 0; i < filterObjects.size(); i++) {
            olsMap = ((ITableRowFilter) filterObjects.get(i)).doFiltering(olsMap);
        }

        return olsMap;
    }

    /*
     * fetchExpertDetails is the method where the database is queried and
     * the fetched results are arranged in a pre-defined format. It returns
     * a map(M1) in which key is the entityId and value is again a Map(M2).
     * The size of map M1 will be equal to the size of entityIds array passed
     * as a parameter. The structure of M2 is explained below:
     *
     * The child attributes of tabs are simple key-value pairs in the map but
     * for tables key is attribute_id of table entity and value is a map (M).
     * Size of M is equal to the number of rows under the table and key in
     * map M is the unique row_id and the value is map(M') which contains
     * attribute details as key-value pairs.
     *
     * Following is the sample entity data structure:
     * ************************************************
     * {
         86052426= {
                    43={
                         136337={
                                   44=Fax, 83009820=4047286269
                                },
                         133975={
                                   44=Email, 83009820=wmcdona@emory.edu
                                },
                         131088={
                                   44=Business, 83009820=4047286302
                                }
                        },
                    34={
                         160021={
                                   42=USA, 40=MA, 39=Bangalore, 36=Primary
                                },
                         126520={
                                   42=USA, 40=GA, 39=Atlanta, 36=Yes
                                }
                       },
                    24=Psychiatry,
                    18=William,
                    20=McDonald,
                    83005945=XXXXXX,
                    USER_ID=86052587
                   }
        }
     ********************************************************
     *   86052426 = Enity Id of the Ol
     *   Contact Information Table Data:
     *
     *   43 =  Attribute id of the "Contact Information" tab
     *   136337, 133975, 131088 = Row ids of the contact information table rows
     *   44 = Attribute id of the "Contact Type" basic attribute
     *   83009820 = Attribute id of the "Contact Info" basic attribute
     *
     *   Tab Data:
     *   24 = Attribute id of the "Primary Speciality" basic attribute
     *   18 = Attribute id of the "First Name" basic attribute
     *   20 = Attribute id of the "Last Name" basic attribute
     *   83005945 = Attribute id of the "Chart Id" basic attribute
     *
     *   Non-Eav Data:
     *   User_id is also appended to the results and it is required at many places to link
     *   Eav and User_table
     */

    private Map fetchExpertDetails(long[] entityIds, long[] basicAttributes) {

        Map olsMap = new HashMap();

        if (entityIds == null || entityIds.length == 0)
            return olsMap;

        // Initialization: put an entry for each entity
        for (int i = 0; i < entityIds.length; i++) {
            olsMap.put(entityIds[i] + "", new HashMap());
        }

        String[] basicAttributesString = SqlAndHqlUtilFunctions.constructInClauseForQuery(basicAttributes);
        String[] entityIdsString = SqlAndHqlUtilFunctions.constructInClauseForQuery(entityIds);

        Map attributeTableCache = HibernateUtilService.attributeTableCache;
        boolean isBooleanAttrPresent = false;
        for (int i = 0; i < basicAttributes.length; i++) {
            AttributeType at = (AttributeType) attributeTableCache.get(new Long(basicAttributes[i]));
            if (at.getType() == 4) {
                isBooleanAttrPresent = true;
                break;
            }
        }

        //query the string attribute table
        List expertDetails = getDetailsFromEavTable(entityIdsString, basicAttributesString, stringAttributeTable);
        olsMap = populateOlsMap(olsMap, expertDetails);

        if (isBooleanAttrPresent) {
            //query the boolean attribute table
            expertDetails = getDetailsFromEavTable(entityIdsString, basicAttributesString, booleanAttributeTable);
            olsMap = populateOlsMap(olsMap, expertDetails);
        }

        return olsMap;
    }

    private List getDetailsFromEavTable(String[] entityIdsString, String[] basicAttributesString, String tableClass) {
        StringBuffer query = new StringBuffer(
                "select sa.attribute, sa.value, sa.rootEntityId, sa.tabAttributeId, sa.table, sa.rowId, u.id "
                        + " from " + tableClass + " sa, User u " + " where sa.rootEntityType="
                        + EavConstants.KOL_ENTITY_ID + " and (");

        for (int i = 0; i < entityIdsString.length; i++) {
            query.append("( sa.rootEntityId in (" + entityIdsString[i] + " )) OR");
        }
        query.delete(query.length() - 2, query.length());
        query.append(" ) and ");

        for (int i = 0; i < basicAttributesString.length; i++) {
            query.append("( sa.attribute in (" + basicAttributesString[i] + " )) OR");
        }
        query.delete(query.length() - 2, query.length());
        query.append("and u.deleteFlag = 'N' and u.kolid=sa.rootEntityId ");

        logger.debug("Query to be executed: " + query.toString());

        long start = System.currentTimeMillis();

        List expertDetails = getHibernateTemplate().find(query.toString());

        long end = System.currentTimeMillis();
        logger.debug("Time taken by hibernate to execute query: " + (end - start));
        return expertDetails;

    }

    private Map populateOlsMap(Map olsMap, List fromDbQuery) {
        if (fromDbQuery == null || fromDbQuery.size() == 0) {
            return olsMap;
        }

        for (int i = 0; i < fromDbQuery.size(); i++) {
            Object[] row = (Object[]) fromDbQuery.get(i);
            long userId = ((Long) row[6]).longValue();
            long entityId = ((Long) row[2]).longValue();

            Map olDetails = (Map) olsMap.get(entityId + "");
            String tabAttributeId = ((Long) row[3]).longValue() + "";
            String rowId = ((Long) row[5]).longValue() + "";
            String attributeId = ((AttributeType) row[0]).getAttribute_id() + "";
            boolean isTable = ((Boolean) row[4]).booleanValue();

            String val = row[1] == null ? "" : row[1].toString();

            //add the userid to olDetails Map
            olDetails.put("USER_ID", userId + "");

            //if attribute's parent is of tab type, directly add the attribute to the map
            if (!isTable)
                olDetails.put(attributeId, val);
            else {
                //if attribute's parent is of table type
                Map tableRowsMap;
                if (olDetails.containsKey(tabAttributeId))
                    tableRowsMap = (Map) olDetails.get(tabAttributeId);
                else {
                    tableRowsMap = new HashMap();
                    olDetails.put(tabAttributeId, tableRowsMap);
                }
                Map tableRow;
                if (tableRowsMap.containsKey(rowId)) {
                    //Row with this rowId already exists in the tableRowsMap
                    tableRow = (Map) tableRowsMap.get(rowId);
                }
                else {
                    //Create a new row with this rowId
                    tableRow = new HashMap();
                    //add this row to the tableRowsMap
                    tableRowsMap.put(rowId, tableRow);
                }
                //put this attribute to this row map
                tableRow.put(attributeId, val);
            }
        }
        return olsMap;
    }
}
