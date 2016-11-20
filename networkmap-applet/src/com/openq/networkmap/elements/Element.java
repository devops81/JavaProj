package com.openq.networkmap.elements;

import java.util.HashMap;

public abstract class Element {
	protected HashMap properties = new HashMap();
	protected boolean visible = true;
	protected boolean active = true;
	
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
	public void addProperty(String key, String value){
		properties.put(key, value);
	}
	
	public String getProperty(String key) {
		return (String)properties.get(key);
	}
	public boolean isVisible() {
		return visible;
	}
	public void setVisible(boolean visible) {
		this.visible = visible;
	}
	

}
