package com.openq.eav.option;

import java.io.Serializable;

public class OptionNames implements Serializable {
	
	public OptionNames() {}

    private long id;

	private String name;
	private long parentId;

	public long getParentId() {
		return parentId;
	}

	public void setParentId(long parentId) {
		this.parentId = parentId;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


}
