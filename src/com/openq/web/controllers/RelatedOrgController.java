package com.openq.web.controllers;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.audit.IDataAuditService;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.org.IOrgOlMapService;
import com.openq.eav.org.IOrganizationService;
import com.openq.eav.org.OrgOlMap;
import com.openq.eav.org.Organization;
import com.openq.eav.org.OrganizationService;
import com.openq.user.IUserService;
import com.openq.utils.PropertyReader;

public class RelatedOrgController extends AbstractController {

	IOrgOlMapService orgOlMapService;
	IUserService userService;
	IOrganizationService orgService;
    IDataAuditService dataAuditService;
    IDataService dataService;

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String orgName = (String) request.getParameter("orgName");
		String position = (String) request.getParameter("position");
		String division = (String) request.getParameter("division");
		String year     = (String) request.getParameter("year");
		String[] deleteOrgsId = request.getParameterValues("checkedOrg");
		request.getSession().removeAttribute("relatedOrgs");
		long orgId = -1;
		
		if(request.getParameter("orgId") != null)
			orgId = Long.parseLong(request.getParameter("orgId"));
		
		long kolId = -1;
		if(request.getParameter("kolId")!= null)
			kolId = Long.parseLong(request.getParameter("kolId"));

		if(deleteOrgsId != null){
			for(int i=0;i<deleteOrgsId.length; i++){
				orgOlMapService.deleteOrgOlMap(kolId, Long.parseLong(deleteOrgsId[i]));
			}
		}
		
		OrgOlMap orgolMap = new OrgOlMap();
		orgolMap.setOlId(kolId);
		orgolMap.setOrgId(orgId);
		orgolMap.setDivision(division);
		orgolMap.setPosition(position);
		orgolMap.setYear(year);

		if(orgName != null && !orgName.equals("")){
			orgOlMapService.saveOrgOlMap(orgolMap);
		}
		OrgOlMap [] relatedOrgMap = orgOlMapService.getAllOrgsForOl(kolId);

        // This map maintains audit data of the attributes
        Map auditMap = new HashMap();
		
		String action = request.getParameter("action");
		if (action != null && action.equals("ORGLIST")) {
			if(relatedOrgMap != null && relatedOrgMap.length != 0){
			Organization [] relatedOrgs = new Organization[relatedOrgMap.length];
			
            List attributeList = Arrays.asList(new String[] { "division", "position", "year" });
            List orgAttributeList = Arrays.asList(new String[] { "name", "type" });
			for(int i=0;i<relatedOrgMap.length;i++){
				relatedOrgs[i] = orgService.getOrganizationByid(relatedOrgMap[i].getOrgId());
				if(relatedOrgs[i] != null)
				{
                    long orgMapId = relatedOrgMap[i].getId();
                    relatedOrgs[i].setOrgOlMapId(orgMapId);

				if(relatedOrgMap[i].getDivision() != null)
					relatedOrgs[i].setDivision(relatedOrgMap[i].getDivision());
				if(relatedOrgMap[i].getPosition() != null)
					relatedOrgs[i].setPosition(relatedOrgMap[i].getPosition());
				if(relatedOrgMap[i].getYear() != null)
				relatedOrgs[i].setYear(relatedOrgMap[i].getYear());

                    // Fill in the audit map
                    auditMap.putAll(dataAuditService.getLatest(orgMapId + "", attributeList));

                    EntityAttribute [] children = dataService.getEntityAttributes(relatedOrgMap[i].getOrgId(), OrganizationService.orgProfileAttrId);
                    if (children.length > 0) {
                        long parent = children[0].getMyEntity().getId();
                        StringAttribute sa = dataService.getAttribute(parent, OrganizationService.nameAttributeId);
                        if (sa != null) {
                            auditMap.put(relatedOrgs[i].getEntityId() + "name", dataAuditService.getLatest(sa.getId() + "", "value"));
                        }
                        sa = dataService.getAttribute(parent, OrganizationService.typeAttributeId);
                        if (sa != null) {
                            auditMap.put(relatedOrgs[i].getEntityId() + "type", dataAuditService.getLatest(sa.getId() + "", "value"));
                        }
                    }
                }
			}			
                request.getSession().setAttribute("relatedOrgs", relatedOrgs);

                // Set the audit info in the session
                request.getSession().setAttribute("auditLastUpdated", auditMap);
			}
			return new ModelAndView("org_list");
		}
		//dummy related org data for developmet purpose. This part of code has to be removed by an API that gets org name for given id

		
		
		return new ModelAndView("related_org");
	}

	public IOrganizationService getOrgService() {
		return orgService;
	}

	public void setOrgService(IOrganizationService orgService) {
		this.orgService = orgService;
	}
	
	public IOrgOlMapService getOrgOlMapService() {
		return orgOlMapService;
	}

	public void setOrgOlMapService(IOrgOlMapService orgOlMapService) {
		this.orgOlMapService = orgOlMapService;
	}
	
	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }

    /**
     * @return the dataService
     */
    public IDataService getDataService() {
        return dataService;
    }

    /**
     * @param dataService the dataService to set
     */
    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }
}
