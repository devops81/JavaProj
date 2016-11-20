package com.openq.eav.data;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import com.openq.audit.Auditable;

import net.sf.hibernate.Hibernate;

public class BinaryAttribute extends EavAttribute implements Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "data", "fileName" });

  private String fileName;

  private Blob data;

  public Blob getData() {
    return data;
  }

  public void setData(Blob data) {
    this.data = data;
  }

  public String getFileName() {
    return fileName;
  }

  public void setFileName(String fileName) {
    this.fileName = fileName;
  }

  public String toString() {
    return "<a class=\"text-blue-01-link\" href=\"getBinary.htm?entityID="
        + getParent().getId() + "&attrID=" + getAttribute().getAttribute_id()
        + "\">" + fileName + "</a>";
  }

  public InputStream getDataStream() throws SQLException {
    if (data != null)
      return data.getBinaryStream();
    return null;
  }

  public void setDataStream(InputStream is) throws IOException {
    data = Hibernate.createBlob(is);
  }

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field) || super.isFieldAuditable(field).booleanValue()) ;
    }
}
