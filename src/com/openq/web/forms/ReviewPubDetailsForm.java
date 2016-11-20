package com.openq.web.forms;

/**
 * 
 * 
 * @author Amit Arora
 *
 */
public class ReviewPubDetailsForm {
	private String selectedPublications;
    private String[] checkIds;

	public String getSelectedPublications() {
		return selectedPublications;
	}

	public void setSelectedPublications(String selectedPublications) {
		this.selectedPublications = selectedPublications;
	}

	public String[] getCheckIds() {
		return checkIds;
	}

	public void setCheckIds(String[] checkIds) {
		this.checkIds = checkIds;
	}
}
