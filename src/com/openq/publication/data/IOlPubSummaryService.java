package com.openq.publication.data;

public interface IOlPubSummaryService {
	public void addOlSummary(OlPublicationSummaryDTO msg);
	public void updateOlSummary(OlPublicationSummaryDTO msg);
	public OlPublicationSummaryDTO [] getAllOlPubSummary();
	public OlPublicationSummaryDTO getOlPubSummary(long authorId);
}
