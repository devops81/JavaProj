/*
 * Anil Gracias
 * Sort logic for OptionLookup values that represent Integers
 * 5-Mar-2008
 * Need to find the right place to package this class, probably com.openq.utils ?
 */

package com.openq.eav.option;

import java.util.Comparator;

public class OptionLookupNumComparator implements Comparator {

	public int compare(Object o1, Object o2) {
		if(Integer.parseInt(((OptionLookup)o1).getOptValue()) < Integer.parseInt(((OptionLookup)o2).getOptValue())) {
			return -1;
		}
		if(Integer.parseInt(((OptionLookup)o1).getOptValue()) > Integer.parseInt(((OptionLookup)o2).getOptValue())) {
			return 1;
		}
		return 0;
	}

}
