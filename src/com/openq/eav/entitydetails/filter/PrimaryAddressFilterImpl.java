/**
 * com.openq.eav.entityDetails.filter
 * tarun
 * Oct 18, 2008
 */
package com.openq.eav.entitydetails.filter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.openq.eav.scripts.OlConstants;

/**
 * 
 */
public class PrimaryAddressFilterImpl implements ITableRowFilter {

    // address filtering depends on Address_Usage attribute
    long[] extraAttrs= {OlConstants.KOL_OL_Summary_Address_Usage};        
    
    /* (non-Javadoc)
     * @see com.openq.eav.filter.ITableRowFilter#addRequiredAttributes(long[])
     */
    public long[] addFilterAttributes(long[] attributesList) {
        
        List newAttributesList=new ArrayList();
        for(int i=0; i<attributesList.length; i++)
            newAttributesList.add(new Long(attributesList[i]));
        
        //append the extra attributes
        for(int i=0; i<extraAttrs.length; i++)
        {
            if(newAttributesList.contains(new Long(extraAttrs[i])))
                continue;
            else
                newAttributesList.add(new Long(extraAttrs[i])); 
        }
        
        //reconstruct the long[] to return
        long[] toReturn=new long[newAttributesList.size()];
        for(int i=0; i<toReturn.length; i++)
            toReturn[i]=((Long)newAttributesList.get(i)).longValue();    

        return toReturn;
    }
    
    /**
     * (non-Javadoc)
     * @see com.openq.eav.entitydetails.filter.ITableRowFilter#doFiltering(java.util.Map)
     */
    public Map doFiltering(Map entityDetailsMap)
    {
        if(entityDetailsMap==null || entityDetailsMap.size()==0)
            return new HashMap();
        Iterator iter= entityDetailsMap.keySet().iterator();
        while(iter.hasNext())
        {
            String entityId= (String)iter.next();
            Map entityDetails= (Map)entityDetailsMap.get(entityId);
            if(!entityDetails.containsKey(OlConstants.KOL_OL_Summary_Address+""))
                continue;
            Map addressTableRows=(Map)entityDetails.get(OlConstants.KOL_OL_Summary_Address+"");
            Map preferredAddressRow=getPreferredRow(addressTableRows);
            
            //put all the keys in preferred row to the entityDatails map
            Iterator i=preferredAddressRow.keySet().iterator();
            while(i.hasNext())
            {
                Object key=i.next();
                Object value=preferredAddressRow.get(key);
                entityDetails.put(key, value);                
            }
            
            //remove the address tab key-value entry from entityDetails map
            entityDetails.remove(OlConstants.KOL_OL_Summary_Address+"");            
        }
        
        return entityDetailsMap;
    }
    
    /**
     * The address row with the usage="Primary" will be the preferred row
     * If there is no primary address then return any row
     * @param addressRows
     * @return
     */
    private Map getPreferredRow(Map addressRows)
    {
        if(addressRows==null || addressRows.size()==0)
            return new HashMap();
        Map toReturn=new HashMap();
        Iterator iter= addressRows.keySet().iterator();
        while(iter.hasNext())
        {
            String rowId=(String)iter.next();
            Map row= (Map) addressRows.get(rowId);
            toReturn=row;
            if(row.containsKey(OlConstants.KOL_OL_Summary_Address_Usage+""))
            {
                //if this row is primary address then return
                if("Primary".equalsIgnoreCase((String)row.get(OlConstants.KOL_OL_Summary_Address_Usage+"")))
                    return toReturn;
            }
        }        
        return toReturn;
    }
}
