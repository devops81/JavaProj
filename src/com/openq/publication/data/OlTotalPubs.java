package com.openq.publication.data;
import java.io.Serializable;

public class OlTotalPubs implements Serializable{
	private long id;
	private long authorId;
	private int totalPublications;
	private int ovidDbId;
	private int lastSearchYear;
	
	public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final OlTotalPubs olTotalpubs = (OlTotalPubs) o;

        if (id != olTotalpubs.id) return false;

        return true;
    }

    public int hashCode() {
        return (int) (id ^ (id >>> 32));
    }

	
	public long getAuthorId() {
		return authorId;
	}
	public void setAuthorId(long authorId) {
		this.authorId = authorId;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getLastSearchYear() {
		return lastSearchYear;
	}
	public void setLastSearchYear(int lastSearchYear) {
		this.lastSearchYear = lastSearchYear;
	}
	
	public int getOvidDbId() {
		return ovidDbId;
	}
	public void setOvidDbId(int ovidDbId) {
		this.ovidDbId = ovidDbId;
	}
	public int getTotalPublications() {
		return totalPublications;
	}
	public void setTotalPublications(int totalPublications) {
		this.totalPublications = totalPublications;
	}
	
	

}
