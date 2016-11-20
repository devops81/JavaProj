package com.openq.eav.metadata;

import java.io.Serializable;


public class AttributeType implements Serializable {

	public AttributeType() {}

	private EntityType parent;	
    private long attribute_id;
    private long parent_id;
	private String name;
	private String description;
	private long type;
	private String label;
	private boolean mandatory;
	private boolean searchable;
	private String attributeSize;
	private String widget;
	private boolean arraylist;
	private String columnWidth;
	private long optionId;
	private String readUsers;
	private String writeUsers;
	private boolean showable;
	private long displayOrder;
	
	
	public boolean isEntity()
	{
		if (type > 0 && type <= 10)
			return false;

		return true;
	}	

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public String getDescription() {
		
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}



	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getWidget() {
		return widget;
	}

	public void setWidget(String widget) {
		this.widget = widget;
	}

	public boolean isSearchable() {
		return searchable;
	}

	public void setSearchable(boolean searchable) {
		this.searchable = searchable;
	}

	public boolean isMandatory() {
		return mandatory;
	}

	public void setMandatory(boolean mandatory) {
		this.mandatory = mandatory;
	}

	public boolean isArraylist() {
		return arraylist;
	}

	public void setArraylist(boolean arraylist) {
		this.arraylist = arraylist;
	}

	public String getAttributeSize() {
		return attributeSize;
	}

	public void setAttributeSize(String attributeSize) {
		this.attributeSize = attributeSize;
	}



	public EntityType getParent() {
		return parent;
	}

	public void setParent(EntityType parent) {
		this.parent = parent;
	}

	public void setType(long type) {
		this.type = type;
	}

	public long getType() {
		return type;
	}

	public long getAttribute_id() {
		return attribute_id;
	}

	public void setAttribute_id(long attribute_id) {
		this.attribute_id = attribute_id;
	}

	public String getColumnWidth() {
		return columnWidth;
	}

	public void setColumnWidth(String columnWidth) {
		this.columnWidth = columnWidth;
	}

	public long getOptionId() {
		return optionId;
	}

	public void setOptionId(long optionId) {
		this.optionId = optionId;
	}


	public String getReadUsers() {
		return readUsers;
	}

	public void setReadUsers(String readUsers) {
		this.readUsers = readUsers;
	}

	public boolean isShowable() {
		return showable;
	}

	public void setShowable(boolean showable) {
		this.showable = showable;
	}

	public String getWriteUsers() {
		return writeUsers;
	}

	public void setWriteUsers(String writeUsers) {
		this.writeUsers = writeUsers;
	}

	public long getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(long displayOrder) {
		this.displayOrder = displayOrder;
	}

	public long getParent_id() {
		return parent_id;
	}

	public void setParent_id(long parent_id) {
		this.parent_id = parent_id;
	}

}
