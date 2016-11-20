/**
 * com.openq.eav.entitydetails
 * tarun
 * Nov 3, 2008
 */
package com.openq.eav.entitydetails;

import java.util.List;
import java.util.Map;

/**
 * Service to fetch details of an entity from EAV. 
 * Usage of filters can help in dealing with Table type entities and 
 * in applying other custom business logics
 */
public interface IEntityDetailsService {

    /**
     * Method to get the OlDetails from the Eav and apply the specified filters on the result
     * The ol details comprises the attributes passed in the parameter
     * @param entityIds
     * @param attributes
     * @return A map (M1) containing expert Details. Size of M1 is equal to the size of the
     *         entityIds[]. In M1, key is the entityId and value is the Map(M2) containing 
     *         the attribute details. The size of the map M2 depends on the filters applied.
     *         Filter may remove any item or put extra items in the map M2.
     */
    public Map getOlDetails(long[] entityIds, long[] attributes, List filters);

}
