package com.openq.utils;

import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: Lenovo
 * Date: Sep 11, 2007
 * Time: 8:48:11 AM
 * To change this template use File | Settings | File Templates.
 */
public class TimeTracker {
    private static final String[] HRS = {"12", "1", "2", "3", "4", "5", "6",
                                        "7", "8", "9", "10", "11"};


    private static final String[] MINUTES = {"00", "15", "30", "45"};


    private static final String[] AM_PM = {"AM", "PM"};

    public static final String[] TimeArray = getCombination();

    private static String[]  getCombination()
    {
        String[] combination = new String[96];
        int c = 0;
        for(int i = 0; i < AM_PM.length; i++)
        {
            for(int j = 0; j < HRS.length; j++)
            {
                 for(int l = 0; l < MINUTES.length; l++)
                    {
                        combination[c++] = HRS[j] + ":" + MINUTES[l] + " " + AM_PM[i];
                    }
            }
        }
        return combination;
    }

    public static int getDifference(String startTime, String endTime)
    {
        // both the string are format "01:30 AM" "2:15 PM"
        int difference = 120;
        String[] startTimeArray = startTime.split(" ");
        String[] startTimeSubArray = startTimeArray[0].split(":");

        String[] endTimeArray = endTime.split(" ");
        String[] endTimeSubArray = endTimeArray[0].split(":");

        try
        {
            long startHrs   =  Long.parseLong(startTimeSubArray[0]);
            long endHrs     =  Long.parseLong(endTimeSubArray[0]);
            long startMin   =  Long.parseLong(startTimeSubArray[1]);
            long endMin     =  Long.parseLong(endTimeSubArray[1]);

            long start = startMin + startHrs*60;
            long end   = endMin + endHrs*60;
            difference = (int)(end - start);
        }
        catch(NumberFormatException n)
        {
            System.out.println(" error is parsing start/ end time " + startTime  + "  " + endTime);
            return difference;
        }

        if ( !startTimeArray[1].equals(endTimeArray[1]) )
        {
            difference = difference + 12*60;
        }
        return difference;

    }
}
