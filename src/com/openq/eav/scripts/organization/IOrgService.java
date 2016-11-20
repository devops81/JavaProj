package com.openq.eav.scripts.organization;

public interface IOrgService {

	public Organization[] searchOrganizationByName(String orgName);
	public Organization[] getAllOrganizations(int startIndex, int size);
	public OrganizationFromOrion[] getAllOrganizationFromOrionForCmaId(String cmaId);
	public Organization[] getAllOrganizationForCmaId(String cmaId);
}