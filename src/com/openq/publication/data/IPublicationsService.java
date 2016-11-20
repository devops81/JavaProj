package com.openq.publication.data;

import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

public interface IPublicationsService {

	public void addpublication(Publications publication);

	public void updatePublication(Publications pub);

	public Publications[] getAllPublicationsOfOl(long authorId);

	public Hashtable deleteOlPublicationsOfYearHashedOnISSN(long authorId, int lastYear);

	public Publications[] getPublicationsInProfile(long authorId);

	public Publications[] getUncommittedPublications(long authorId);

	public Publications[] getNewPublications(long authorId, Date lastcapture);

	public Publications getPublicationDetails(long publicationId);

	public Publications getlastProfileUpdate(long authorId);

	public Publications getlastProfileCapture(long authorId);
	
	

}
