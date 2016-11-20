package com.openq.eav.metadata;


import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;



/*
 * Define the metadata of an entity. <p>
 */


public class EntityType implements Serializable {
	
	
	public EntityType() {}

    private long entity_type_id;

	private String name;

	private String description;

	private String label;
	
	private long treeDepth;
	
	private Set attributes = new HashSet();
	
	
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


	
	
	public long getTreeDepth() {
		return treeDepth;
	}
	
	public void setTreeDepth(long treeDepth) {
		this.treeDepth = treeDepth;
	}

	public Set getAttributes() {
		return attributes;
	}

	public void setAttributes(Set attributes) {
		this.attributes = attributes;
	}

    public void addAttributeType(AttributeType attributeType)
	{
		attributeType.setParent(this);
		attributes.add(attributeType);
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}
	
	public String getDisplayName() {
		if (label == null)
			return name;
		return label;
	}

	public long getEntity_type_id() {
		return entity_type_id;
	}

	public void setEntity_type_id(long entity_type_id) {
		this.entity_type_id = entity_type_id;
	}
}