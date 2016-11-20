package com.openq.orx;

import com.openq.orx.agmen.AmgenSearchORX;
import com.openq.orx.fileSearch.FileSearchImpl;

import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 15, 2007
 * Time: 4:55:36 PM
 * To change this template use File | Settings | File Templates.
 */
public class SearchORXServiceProvider {
    private ISearchORX iSearchORX;
    private static SearchORXServiceProvider searchORXServiceProvider;

    private SearchORXServiceProvider()
    {
        ClassLoader classLoader = this.getClass().getClassLoader();
        InputStream inputStream = classLoader.getResourceAsStream("resources/custom-setup.prop");
        Properties serviceProperties = new Properties();
        try{
            serviceProperties.load(inputStream);
        } catch ( IOException e)
        {
            System.out.println("could not load the service property file" + e);
        }
        String serviceType = (String ) serviceProperties.getProperty("ORX_TYPE");
        if ( serviceType.equalsIgnoreCase("amgen"))
        {
            iSearchORX = new AmgenSearchORX();
        }
        else if ( serviceType.equalsIgnoreCase("file") )
        {
            iSearchORX = new FileSearchImpl();
        }
    }

    public static SearchORXServiceProvider getInstance()
    {
        if ( searchORXServiceProvider == null  )
        {
            searchORXServiceProvider = new SearchORXServiceProvider();
        }

        return searchORXServiceProvider;
    }

    public ISearchORX getISearchORX()
    {
        return iSearchORX;
    }
}
