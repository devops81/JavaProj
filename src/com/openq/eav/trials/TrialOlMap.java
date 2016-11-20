package com.openq.eav.trials;

public class TrialOlMap {
	private long id;
	private long trialId;
	private long olId;
	private String role;
	private String institution;
	
	public String getInstitution() {
		return institution;
	}

	public void setInstitution(String institution) {
		this.institution = institution;
	}

	public TrialOlMap() {
	}

	public long getOlId() {
		return olId;
	}

	public void setOlId(long olId) {
		this.olId = olId;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public long getTrialId() {
		return trialId;
	}

	public void setTrialId(long trialId) {
		this.trialId = trialId;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}
}
