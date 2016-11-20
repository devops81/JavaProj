package com.openq.web.controllers;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.audit.IDataAuditService;
import com.openq.contacts.Contacts;
import com.openq.contacts.IContactsService;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.utils.PropertyReader;

public class AmgenContactController extends AbstractController {
	IContactsService contactsService;
	IOptionService optionService;
    IDataAuditService dataAuditService;

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String userGroupIdString = (String) request.getSession().getAttribute(Constants.CURRENT_USER_GROUP);
		long userGroupId = -1;
		if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
		 userGroupId = Long.parseLong(userGroupIdString);

		String contactType = (String) request.getParameter("contactType");
		String contactName = (String) request.getParameter("contactName");
		String email = (String) request.getParameter("email");
		String phone = (String) request.getParameter("phone");
		System.out.println("Phone number is : " + phone);
		String[] brand = (String[]) request.getParameterValues("brand");
		String primaryContact = (String) request.getParameter("primaryContact");
		String role = (String) request.getParameter("contactRole");
		String otherRole = (String) request.getParameter("otherRole");
		long kolId = Long.parseLong(request.getParameter("kolId"));
		String editContact = (String) request.getParameter("editContact");
		long staffId = -1;
		if (request.getParameter("staffId") != null && !request.getParameter("staffId").equals(""))
			staffId =Long.parseLong(request.getParameter("staffId"));
		
		request.getSession().removeAttribute("editContact");
		request.getSession().removeAttribute("message");
		
		//request.getSession().setAttribute("contactType", optionService.getValuesForOption(35));
		
		Contacts contact = new Contacts();
		
		
		contact.setBrandList(brand);
		contact.setContactName(contactName);
		contact.setEmail(email);
		if (primaryContact != null)
			contact.setIsPrimaryContact(primaryContact);
		contact.setKolId(kolId);
		contact.setPhone(phone);
		contact.setRole(role);
		contact.setType(contactType);
		contact.setOtherRole(otherRole);
		contact.setStaffid(staffId);
		
		if(editContact == null){
		if (contact.getContactName() != null
				&& !contact.getContactName().equals(""))
			if(contactsService.getContact(contact))
				contactsService.addContact(contact);
			else
				request.getSession().setAttribute("message", "Contact already exist");
		}
		else
		{
			if (contact.getContactName() != null
					&& !contact.getContactName().equals(""))
				contact.setContactId(Long.parseLong(editContact));
				contactsService.update(contact);
		}
		
		
		String[] deleteContacts = request.getParameterValues("checkedContacts");
		if (deleteContacts != null && deleteContacts.length != 0) {
			for (int i = 0; i < deleteContacts.length; i++) {
				contactsService.delete(Long.parseLong(deleteContacts[i]));
			}
		}
		
		if(request.getParameter("editContactId") != null){
			long editContactId = Long.parseLong(request.getParameter("editContactId"));
			request.getSession().setAttribute("editContact", contactsService.getContact(editContactId));
		}
		
		Contacts[] contactForKol = contactsService.getContactsForKol(kolId);
		
        // This map maintains audit data of the attributes
        Map auditMap = new HashMap();
        List attributeList = Arrays.asList(new String[] { "contactName", "phone", "email", "role", "type" });
        for (int i = 0; i < contactForKol.length; i++) {
            String contactId = contactForKol[i].getContactId() + "";
            auditMap.putAll(dataAuditService.getLatest(contactId, attributeList));
        }
		request.getSession().setAttribute("contacts", contactForKol);
		session.setAttribute("contactRole",  optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("CONTACT_ROLE"), userGroupId));
        session.setAttribute("contactType", optionServiceWrapper.getValuesForOptionName(PropertyReader.getLOVConstantValueFor("CONTACT_TYPE"), userGroupId));

        // Set the audit info in the session
        request.getSession().setAttribute("auditLastUpdated", auditMap);
        
        String print = null != request.getParameter("prettyPrint") ? request.getParameter("prettyPrint") : null ;
        if ( (null != print && "true".equalsIgnoreCase(print)) || (null != print  &&  "false".equalsIgnoreCase(print)))
               return new ModelAndView("contacts_list");
        else
        return new ModelAndView("contacts");
	}

	IOptionServiceWrapper optionServiceWrapper;

    public IOptionServiceWrapper getOptionServiceWrapper() {
        return optionServiceWrapper;
    }

    public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
        this.optionServiceWrapper = optionServiceWrapper;
    }

	public IContactsService getContactsService() {
		return contactsService;
	}

	public void setContactsService(IContactsService contactsService) {
		this.contactsService = contactsService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}

    public IDataAuditService getDataAuditService() {
        return dataAuditService;
    }

    public void setDataAuditService(IDataAuditService dataAuditService) {
        this.dataAuditService = dataAuditService;
    }
}
