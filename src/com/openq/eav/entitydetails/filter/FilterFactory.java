/**
 * com.openq.eav.entitydetails.filter
 * tarun
 * Nov 4, 2008
 */
package com.openq.eav.entitydetails.filter;

/**
 * Factory to return the instance of ITableRowFilter for the given filter implementation
 */
public class FilterFactory {
    
    static public ITableRowFilter createFilter(String filterName) throws Exception
    {
            return (ITableRowFilter)Class.forName("com.openq.eav.entitydetails.filter."+filterName).newInstance();
    }

}
