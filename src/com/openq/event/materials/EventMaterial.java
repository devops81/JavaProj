package com.openq.event.materials;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

import net.sf.hibernate.Hibernate;

import java.sql.Blob;

public class EventMaterial {

	private long materialID;
	private long eventId;
	private String name;
	private String description;
	private Blob materialContent;
	
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Blob getMaterialContent() {
		return materialContent;
	}
	public void setMaterialContent(Blob materialContent) {
		this.materialContent = materialContent;
	}
	public long getMaterialID() {
		return materialID;
	}
	public void setMaterialID(long materialID) {
		this.materialID = materialID;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getEventId() {
		return eventId;
	}
	public void setEventId(long eventId) {
		this.eventId = eventId;
	}
	
	public InputStream getMaterialContentStream() throws SQLException {
	    if (materialContent != null)
	      return materialContent.getBinaryStream();
	    return null;
	  }

	  public void setMaterialContentStream(InputStream is) throws IOException {
	    this.materialContent = Hibernate.createBlob(is);
	  }
	
	
}
