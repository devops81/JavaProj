package com.openq.orx.fileSearch;

import com.openq.orx.ISearchORX;
import com.openq.orx.BestORXRecord;
import com.openq.kol.DBUtil;

import javax.xml.rpc.ServiceException;
import java.rmi.RemoteException;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.Properties;
import java.util.ArrayList;
import java.io.*;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 15, 2007
 * Time: 2:44:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class FileSearchImpl implements ISearchORX {

    private Hashtable bestOrxRecordHashed = null;
    private ArrayList arrayList;

    public FileSearchImpl()
    {
        bestOrxRecordHashed = new Hashtable();
        initialize();
    }

    public void initialize()
    {
        Properties prop = null;
        try{
            prop = DBUtil.getInstance().getDataFromPropertiesFile("resources/BestORXRecords");
        }
        catch (IOException e)
        {
            System.out.println(" problem with the Orx File Loading "   + e );
        }
        for ( int i = 0; i < prop.size(); i++)
        {
            int j = i + 1;
            String key = "rec-" + j;
            String line = (String) prop.getProperty(key);
            //System.out.println("adding line"   + line );
            if ( line != null )
                parseAndBuildRecord(line);
        }
    }

    private void parseAndBuildRecord(String line)
    {
        StringTokenizer st = new StringTokenizer(line, ",");
        BestORXRecord bestORXRecord = new BestORXRecord();
        bestORXRecord.setSsoid((String) st.nextElement());
        bestORXRecord.setSsname	((String)	st.nextElement());
        //bestORXRecord.setAgoid	(
        st.nextElement();
        bestORXRecord.setFullName	((String)	st.nextElement());
        String firstName = ((String)	st.nextElement());
        bestORXRecord.setFirstName(firstName);

        bestORXRecord.setPreferredName	((String)	st.nextElement());
        bestORXRecord.setMiddleName	((String)	st.nextElement());

        String lastName = ((String)	st.nextElement());
        bestORXRecord.setLastName(lastName);

        bestORXRecord.setAddress((String)	st.nextElement());
        bestORXRecord.setSpecialty((String)	st.nextElement());
        bestORXRecord.setPhone((String)	st.nextElement());
        bestORXRecord.setLocation((String)	st.nextElement());
        bestORXRecord.setCountry((String)	st.nextElement());
        bestORXRecord.setLocality((String)	st.nextElement());
        bestORXRecord.setPostalCode((String)	st.nextElement());

        String state = ((String)	st.nextElement());
        bestORXRecord.setProvince(state);

        bestORXRecord.setStreetAddress((String)	st.nextElement());
        String key = lastName+firstName+state;
        arrayList = (ArrayList) bestOrxRecordHashed.get(lastName+firstName+state);
        if ( arrayList == null)
        {
            arrayList = new ArrayList();
            bestOrxRecordHashed.put( key, arrayList);
        }
        System.out.println("adding to the list with key "   + key );
        arrayList.add(bestORXRecord);
    }


    public BestORXRecord[] searchORX(String lastName, String firstName) throws RemoteException, ServiceException
    {
        return searchORX(lastName, firstName, null);
    }

    public BestORXRecord [] searchORX(String lastName, String firstName, String state) throws RemoteException, ServiceException
    {

        String key = lastName+firstName+state;
        // System.out.println("finding list with key "   + key  + " in hashtable " + bestOrxRecordHashed + " in hashtable size " + bestOrxRecordHashed.size());
        arrayList = (ArrayList) bestOrxRecordHashed.get(key);
        if (arrayList != null )
        {
            //System.out.println("finding list with key "   + key + " and result size is " + arrayList.size() );
            return  (BestORXRecord[]) arrayList.toArray(new BestORXRecord[arrayList.size()]);
        }
        else
            return null;
    }
}
