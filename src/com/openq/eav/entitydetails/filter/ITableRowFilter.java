/**
 * com.openq.eav.filter
 * tarun
 * Oct 18, 2008
 */
package com.openq.eav.entitydetails.filter;

import java.util.Map;

public interface ITableRowFilter {

    /**
     * Add the attributesIds of the attributes on whose basis filtering
     * will be done
     * @param attributesList
     * @return the long array which will contain the attributes passed as param
     *         and also the extra attributes which will help in filtering
     */
    public long[] addFilterAttributes(long[] attributesList);

    /**
     * Method to filter the entity data in the map passesd as a parameter
     * @param entityDetailsMap
     * @return
     */
    public Map doFiltering(Map entityDetailsMap);

}
