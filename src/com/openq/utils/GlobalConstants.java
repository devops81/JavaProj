package com.openq.utils;

import java.io.Serializable;

/**
 * The <code>GlobalConstants</code> class represents the Global Constants
 * defined in the GLOBAL_CONSTANTS table. All system wide constants
 * for example, KOL_SPENDING_CAP are implemented as instances of this class.
 *
 * @author  Deepak Singh Rawat
 * @version 1.0, 06/22/2008
 */

public class GlobalConstants implements Serializable {

	private int id;
	private String name;
	private String value;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
