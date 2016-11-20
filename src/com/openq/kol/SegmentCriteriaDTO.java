/*
 * Created on Oct 11, 2006
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.openq.kol;

public class SegmentCriteriaDTO {
   int attributeId = 0;
   String attributeName = null;
   String condition = null;
   String value = null;
   String attributeDataType = null;
   
	/**
	 * @return
	 */
	public String getAttributeName() {
		return attributeName;
	}
	
	/**
	 * @return
	 */
	public String getCondition() {
		return condition;
	}
	
	/**
	 * @return
	 */
	public String getValue() {
		return value;
	}
	
	/**
	 * @param string
	 */
	public void setAttributeName(String string) {
		attributeName = string;
	}
	
	/**
	 * @param string
	 */
	public void setCondition(String string) {
		condition = string;
	}
	
	/**
	 * @param string
	 */
	public void setValue(String string) {
		value = string;
	}

	/**
	 * @return
	 */
	public int getAttributeId() {
		return attributeId;
	}
	
	/**
	 * @param i
	 */
	public void setAttributeId(int i) {
		attributeId = i;
	}
	

	/**
	 * @return
	 */
	public String getAttributeDataType() {
		return attributeDataType;
	}
	
	/**
	 * @param string
	 */
	public void setAttributeDataType(String string) {
		attributeDataType = string;
	}

}
