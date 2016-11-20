/*
 * Kirubakaran D
 * Sort logic for OptionLookup values that represent Doubles
 * 20-Mar-2008
 */
package com.openq.eav.option;

import java.util.Comparator;

public class OptionLookupDoubleComparator implements Comparator {

	public int compare(Object o1, Object o2) {
		if(Double.parseDouble(((OptionLookup)o1).getOptValue()) < Double.parseDouble(((OptionLookup)o2).getOptValue())) {
			return -1;
		}
		if(Double.parseDouble(((OptionLookup)o1).getOptValue()) > Double.parseDouble(((OptionLookup)o2).getOptValue())) {
			return 1;
		}
		return 0;
	}

}
