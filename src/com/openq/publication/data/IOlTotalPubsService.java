package com.openq.publication.data;

import java.util.Hashtable;
import java.util.List;

public interface IOlTotalPubsService {
	
	public void updateTotalPubs(OlTotalPubs msg);
	
	public List getAllTotalPubs();
	
	public void addTotalPubs(OlTotalPubs msg);
	
	public Hashtable getAllOlTotalPubsHashedOnAuthorId();
}