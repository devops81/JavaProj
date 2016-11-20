package com.openq.Notify;

import java.util.Date;

public class ChangeNotify {

	long id;
	long attribute;
	long attribute_id;
	String original_value;
	String new_value;
	long operation;
	long kolId;
	Date created_at;
	Date updated_at;
	public long getAttribute() {
		return attribute;
	}
	public void setAttribute(long attribute) {
		this.attribute = attribute;
	}
	public long getAttribute_id() {
		return attribute_id;
	}
	public void setAttribute_id(long attribute_id) {
		this.attribute_id = attribute_id;
	}
	public Date getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getKolId() {
		return kolId;
	}
	public void setKolId(long kolId) {
		this.kolId = kolId;
	}
	public String getNew_value() {
		return new_value;
	}
	public void setNew_value(String new_value) {
		this.new_value = new_value;
	}
	public long getOperation() {
		return operation;
	}
	public void setOperation(long operation) {
		this.operation = operation;
	}
	public String getOriginal_value() {
		return original_value;
	}
	public void setOriginal_value(String original_value) {
		this.original_value = original_value;
	}
	public Date getUpdated_at() {
		return updated_at;
	}
	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}
	
	
	
	
}
