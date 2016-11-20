package com.openq.eav.org;

import java.util.HashMap;

public interface IOrganizationService {
    public Organization [] searchOrganizations(String nameOrAcronym);

    public Organization[] searchOrganizationsAdv(HashMap parameters,long userGroupId);

     public Organization[] getAllOrganizations();

    public Organization getOrganizationByid(long orgId);
	//public Organization getOrganization(long orgId);
}
