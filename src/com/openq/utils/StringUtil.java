/*
 * StringUtil
 *
 * Feb 28, 2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
 */
package com.openq.utils;

import java.util.Collection;
import java.util.Iterator;

/**
 * Utility class dealing with String objects.
 */
public class StringUtil {
	/**
	 * Returns true if the given String is null or an empty String.
	 * @param s The String to check.
	 * @return true if s is null or an empty String and otherwise false.
	 */
	public static boolean isEmptyString(String s) {
		return s == null || s.equals("");	
	}

  public static String join(Collection c){
    return join(c, ", ");
  }

  public static String join(Collection c, String delim){
    StringBuffer sBuffer = new StringBuffer();
    boolean isFirst = true;
    for(Iterator itr=c.iterator(); itr.hasNext();){
      if(!isFirst) sBuffer.append(delim);
      sBuffer.append(itr.next());
      isFirst = false;
    }
    return sBuffer.toString();
  }
}
