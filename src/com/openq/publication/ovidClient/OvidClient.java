package com.openq.publication.ovidClient;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import com.openq.publication.data.ICmaPubOlService;
import com.openq.publication.data.IOlPubSummaryService;
import com.openq.publication.data.IOlTotalPubsService;
import com.openq.publication.data.IOvidDbService;
import com.openq.publication.data.IPublicationsService;
import com.openq.publication.data.IRequestService;
import com.openq.user.IUserService;

public class OvidClient {

	/**
	 * @param args
	 */
	public IUserService userService;
	public IOlTotalPubsService olTotalPubsService;
	public IOvidDbService ovidDbService;
	public IPublicationsService publicationsService;
	public IRequestService requestService;
	public ICmaPubOlService cmaPubOlService;
	public IOlPubSummaryService olPubSummaryService;
	public Hashtable hashAllOlTotalPubs;
	public String startThread=null;
	private ArrayList requestList;
	private YazClientProcessor yazClientThreadOne;
	public long currentUserId;
	
	public OvidClient()
	{
		requestList = new ArrayList();
		initializeRequestProcessor();
	}
	
	private void initializeRequestProcessor() {
		yazClientThreadOne = new YazClientProcessor();
		yazClientThreadOne.setOvidClient(this);
		yazClientThreadOne.setKeepProcessing(true);
	}

	public void handleRequest(List request, long curUserId)
	{
		currentUserId=curUserId;
		ArrayList authorids = new ArrayList();
		requestList.addAll(request);
		hashAllOlTotalPubs=olTotalPubsService.getAllOlTotalPubsHashedOnAuthorId();
		if(startThread==null){
			startThread="started";
			yazClientThreadOne.start();
		}
		

	}
	

	public IRequestService getRequestService() {
		return requestService;
	}

	public void setRequestService(IRequestService requestService) {
		this.requestService = requestService;
	}
	
	public ArrayList getRequestList() {
		return requestList;
	}

	public void setRequestList(ArrayList requestList) {
		this.requestList = requestList;
	}
	
	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public IOlTotalPubsService getOlTotalPubsService() {
		return olTotalPubsService;
	}

	public void setOlTotalPubsService(IOlTotalPubsService olTotalPubsService) {
		this.olTotalPubsService = olTotalPubsService;
	}

	public IOvidDbService getOvidDbService() {
		return ovidDbService;
	}

	public void setOvidDbService(IOvidDbService ovidDbService) {
		this.ovidDbService = ovidDbService;
	}

	public IPublicationsService getPublicationsService() {
		return publicationsService;
	}

	public void setPublicationsService(IPublicationsService publicationsService) {
		this.publicationsService = publicationsService;
	}

	public ICmaPubOlService getCmaPubOlService() {
		return cmaPubOlService;
	}

	public void setCmaPubOlService(ICmaPubOlService cmaPubOlService) {
		this.cmaPubOlService = cmaPubOlService;
	}

	public IOlPubSummaryService getOlPubSummaryService() {
		return olPubSummaryService;
	}

	public void setOlPubSummaryService(IOlPubSummaryService olPubSummaryService) {
		this.olPubSummaryService = olPubSummaryService;
	}
}
