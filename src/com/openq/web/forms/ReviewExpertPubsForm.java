package com.openq.web.forms;

/**
 * 
 * 
 * @author Amit Arora
 *
 */
public class ReviewExpertPubsForm {
	private String selectedExperts;
    private long[] checkIds;

	public String getSelectedExperts() {
		return selectedExperts;
	}

	public void setSelectedExperts(String selectedExperts) {
		this.selectedExperts = selectedExperts;
	}

	public long[] getCheckIds() {
		return checkIds;
	}

	public void setCheckIds(long[] checkIds) {
		this.checkIds = checkIds;
	}
}
