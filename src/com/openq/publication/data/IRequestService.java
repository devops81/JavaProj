package com.openq.publication.data;

public interface IRequestService {
	
	public Request getCaptureStatus(long userId);
	
	public void updateCaptureStatus(Request request);
	
	public void addCaptureStatus(Request request);

}
