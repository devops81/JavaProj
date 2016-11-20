package com.openq.utils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/**
 * @author tarun gupta
 */

public class SqlAndHqlUtilFunctions
{
	/**
	 * The maximum number of entries allowed in an Oracle "IN" clause
	 */
	private static final int MAX_IN_CLAUSE_ENTRIES = 999;
	
	
	/*
	 * This method takes a set of long/int values and split them into the strings of 
	 * 999 tokens separated by ,. This is needed while creating Sqls which involves
	 * Oracle's IN clause.
	 */
	static public String[] constructInClauseForQuery(Set tokens)
	{
		if (tokens.size() < 1)
			return new String[0];
		Iterator iterator = tokens.iterator();
		List stringsToReturn = new ArrayList();
		int counter = 0;
		StringBuffer buf = new StringBuffer();
		// Create strings of MAX_IN_CLAUSE_ENTRIES tokens separtated by ,
		while (iterator.hasNext()) {
			buf.append(((Long) iterator.next()).longValue() + ", ");
			counter++;
			if (counter == MAX_IN_CLAUSE_ENTRIES) {
				buf.deleteCharAt(buf.length() - 2);
				stringsToReturn.add(buf.toString());
				counter = 0;
				buf.delete(0, buf.length());
			}
		}
		// Create string of residual tokens
		if (counter > 0) {
			buf.deleteCharAt(buf.length() - 2);
			stringsToReturn.add(buf.toString());
		}
		return (String[]) stringsToReturn.toArray(new String[stringsToReturn.size()]);
	}
	
	/*
         * This method takes a array of long values and split them into the strings of 
         * 999 tokens separated by ,. This is needed while creating Sqls which involves
         * Oracle's IN clause.
         */
        static public String[] constructInClauseForQuery(long[] tokens)
        {
                if (tokens.length < 1)
                        return new String[0];
                List stringsToReturn = new ArrayList();
                int counter = 0;
                StringBuffer buf = new StringBuffer();
                // Create strings of MAX_IN_CLAUSE_ENTRIES tokens separtated by ,
                for(int i=0;i<tokens.length;i++)
                {
                        buf.append(tokens[i] + ", ");
                        counter++;
                        if (counter == MAX_IN_CLAUSE_ENTRIES) {
                                stringsToReturn.add(buf.toString().substring(0, buf.length()-2));
                                counter = 0;
                                buf.delete(0, buf.length());
                        }
                }
                // Create string of residual tokens
                if (counter > 0)
                        stringsToReturn.add(buf.toString().substring(0, buf.length()-2));
                return (String[]) stringsToReturn.toArray(new String[stringsToReturn.size()]);
        }
        
    /*
     * This method takes a string of comma separated tokenss and split them into the strings of 
     * 999 tokens separated by ,. This is needed while creating Sqls which involves
     * Oracle's IN clause.
     */
    static public String[] constructInClauseForQuery(String tokens) {
        List list = new ArrayList();

        String[] split = tokens.split(",");
        StringBuffer temp = new StringBuffer();
        for (int i = 0; i < split.length; i++) {
            if (i > 0 && i % MAX_IN_CLAUSE_ENTRIES == 0) {
                list.add(temp.substring(0, temp.length() - 2));
                temp.delete(0, temp.length());
            }
            temp.append(split[i] + ", ");
        }
        if (temp.length() > 0)
            list.add(temp.substring(0, temp.length() - 2));

        return (String[]) list.toArray(new String[list.size()]);

    }
}
