package com.openq.web.forms;

/**
 * Encapsulate data corresponding to the form which is used for submitting
 * asynchronous geocoding requests corresponding to the selected experts
 * 
 * @author Amit Arora
 *
 */
public class GeocodeExpertsForm {
    private String selectedExperts;
    private long[] checkIds;

	public String getSelectedExperts() {
		return selectedExperts;
	}

	public void setSelectedExperts(String selectedExperts) {
		this.selectedExperts = selectedExperts;
	}

	public long[] getCheckId() {
		return checkIds;
	}

	public void setCheckId(long[] checkIds) {
		this.checkIds = checkIds;
	}
}
