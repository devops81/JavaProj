package com.openq.eav.trials;

import java.io.Serializable;

public class ClinicalTrials implements Comparable, Serializable {
	private long id;
	private String officialTitle;
	private String status;

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final ClinicalTrials that = (ClinicalTrials) o;

        if (id != that.id) return false;

        return true;
    }

    public int hashCode() {
        return (int) (id ^ (id >>> 32));
    }

    private String sponsorsAndCollaborators;
	private String clinicalTrialsGovIdentifier;
	private String purpose;
	private String tumourType;
	private String molecules;
	private String phase;
	private String studyType;
	private String studyDesign;
	private String primaryOutcomeMeasures;
	private String secondaryOutcomeMeasures;
	private String studyStartDate;
	private String expectedCompletionDate;
	private String institutions;
	private int plannedPatients;
	private int actualPatients;
	private String disease;
	private String genentechInvestigatorId;
	private String licenseNumber;
	
	public String getGenentechInvestigatorId() {
		return genentechInvestigatorId;
	}

	public void setGenentechInvestigatorId(String genentechInvestigatorId) {
		this.genentechInvestigatorId = genentechInvestigatorId;
	}

	public String getLicenseNumber() {
		return licenseNumber;
	}

	public void setLicenseNumber(String licenseNumber) {
		this.licenseNumber = licenseNumber;
	}

	public ClinicalTrials() {
	}

	public int getActualPatients() {
		return actualPatients;
	}

	public void setActualPatients(int actualPatients) {
		this.actualPatients = actualPatients;
	}

	public String getClinicalTrialsGovIdentifier() {
		return clinicalTrialsGovIdentifier;
	}

	public void setClinicalTrialsGovIdentifier(String clinicalTrialsGovIdentifier) {
		this.clinicalTrialsGovIdentifier = clinicalTrialsGovIdentifier;
	}

	public String getDisease() {
		return disease;
	}

	public void setDisease(String disease) {
		this.disease = disease;
	}

	public String getExpectedCompletionDate() {
		return expectedCompletionDate;
	}

	public void setExpectedCompletionDate(String expectedCompletionDate) {
		this.expectedCompletionDate = expectedCompletionDate;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getInstitutions() {
		return institutions;
	}

	public void setInstitutions(String institutions) {
		this.institutions = institutions;
	}

	public String getMolecules() {
		return molecules;
	}

	public void setMolecules(String molecules) {
		this.molecules = molecules;
	}

	public String getOfficialTitle() {
		return officialTitle;
	}

	public void setOfficialTitle(String officialTitle) {
		this.officialTitle = officialTitle;
	}

	public String getPhase() {
		return phase;
	}

	public void setPhase(String phase) {
		this.phase = phase;
	}

	public int getPlannedPatients() {
		return plannedPatients;
	}

	public void setPlannedPatients(int plannedPatients) {
		this.plannedPatients = plannedPatients;
	}

	public String getPrimaryOutcomeMeasures() {
		return primaryOutcomeMeasures;
	}

	public void setPrimaryOutcomeMeasures(String primaryOutcomeMeasures) {
		this.primaryOutcomeMeasures = primaryOutcomeMeasures;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public String getSecondaryOutcomeMeasures() {
		return secondaryOutcomeMeasures;
	}

	public void setSecondaryOutcomeMeasures(String secondaryOutcomeMeasures) {
		this.secondaryOutcomeMeasures = secondaryOutcomeMeasures;
	}

	public String getSponsorsAndCollaborators() {
		return sponsorsAndCollaborators;
	}

	public void setSponsorsAndCollaborators(String sponsorsAndCollaborators) {
		this.sponsorsAndCollaborators = sponsorsAndCollaborators;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStudyDesign() {
		return studyDesign;
	}

	public void setStudyDesign(String studyDesign) {
		this.studyDesign = studyDesign;
	}

	public String getStudyStartDate() {
		return studyStartDate;
	}

	public void setStudyStartDate(String studyStartDate) {
		this.studyStartDate = studyStartDate;
	}

	public String getStudyType() {
		return studyType;
	}

	public void setStudyType(String studyType) {
		this.studyType = studyType;
	}

	public String getTumourType() {
		return tumourType;
	}

	public void setTumourType(String tumourType) {
		this.tumourType = tumourType;
	}

	public int compareTo(Object arg0) {
		return this.officialTitle.compareTo(((ClinicalTrials)arg0).getOfficialTitle());
	}
}
