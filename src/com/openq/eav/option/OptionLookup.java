package com.openq.eav.option;

import java.io.Serializable;

public class OptionLookup implements Serializable {

	public OptionLookup() {}

    private long id;

	private OptionNames optionId;

	private String optValue;
	
	private String deleteFlag;
	private long parentId;
	private boolean defaultSelected;
	private long displayOrder;

	/**
	 * @return the displayOrder
	 */
	public long getDisplayOrder() {
		return displayOrder;
	}

	/**
	 * @param displayOrder the displayOrder to set
	 */
	public void setDisplayOrder(long displayOrder) {
		this.displayOrder = displayOrder;
	}

	/**
	 * @return the deleteFlag
	 */
	public String getDeleteFlag() {
		return deleteFlag;
	}

	/**
	 * @param deleteFlag the deleteFlag to set
	 */
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public OptionNames getOptionId() {
		return optionId;
	}

	public void setOptionId(OptionNames optionId) {
		this.optionId = optionId;
	}

	public String getOptValue() {
		return optValue;
	}

	public void setOptValue(String optValue) {
		this.optValue = optValue;
	}

	public long getParentId() {
		return parentId;
	}

	public void setParentId(long parentId) {
		this.parentId = parentId;
	}
	public boolean isDefaultSelected() {
		return defaultSelected;
	}

	public void setDefaultSelected(boolean defaultSelected) {
		this.defaultSelected = defaultSelected;
	}
}
