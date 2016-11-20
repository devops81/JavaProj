package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.web.controllers.helpers.UIHelper;

public class CreateAttributeController extends AbstractController {

	IMetadataService metadataService;

	UIHelper uiHelper;

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("createAttribute");

		if (request.getParameter("Add") != null) {
			response.sendRedirect("addAttribute.htm?_action=new&parentId="
					+ request.getParameter("entityId") + "&parentIsList="
					+ request.getParameter("isList"));
		}

		String entityIdString = request.getParameter("entityId");
		if (entityIdString != null) {
			mav.addObject("entityTypeId", entityIdString);
			long entityId = Long.parseLong(entityIdString);

			EntityType type = setEntityDetails(request, mav, entityId);

			// update this entity?
			if (request.getParameter("Update") != null) {
				updateEntityDetails(request, mav, type);
			}

			// save this entity?
		}

		mav.addObject("viewGroups", uiHelper.getGroupOptions("viewGroups",
				"field-blue-15-110x20", ""));
		mav.addObject("editGroups", uiHelper.getGroupOptions("editGroups",
				"field-blue-15-110x20", ""));
		return mav;
	}

	private void updateEntityDetails(HttpServletRequest request,
			ModelAndView mav, EntityType type) {
		String name = request.getParameter("entityName");
		String desc = request.getParameter("entityDescription");
		String mandatory = request.getParameter("mandatory");
		String viewable = request.getParameter("viewable");
		String readGroups = request.getParameter("viewSelectedGroups");
		String writeGroups = request.getParameter("editSelectedGroups");

		if (name != null && desc != null) {
			type.setName(name);
			type.setDescription(desc);
			metadataService.updateEntityType(type);

			mav.addObject("entityName", type.getName());
			mav.addObject("entityDesc", type.getDescription());

			String attrId = request.getParameter("attrId");

			if (attrId != null) {
				long attributeId = Long.parseLong(attrId);
				AttributeType attrType = metadataService
						.getAttributeType(attributeId);

				attrType.setName(name);
				attrType.setDescription(desc);
				attrType.setMandatory(mandatory != null);
				attrType.setShowable(viewable != null);
				attrType.setReadUsers(readGroups);
				attrType.setWriteUsers(writeGroups);

				metadataService.updateAttributeType(attrType);
			}
		}
	}

	private EntityType setEntityDetails(HttpServletRequest request,
			ModelAndView mav, long entityId) {
		// put name, desc & type in mav
		EntityType type = metadataService.getEntityType(entityId);

		mav.addObject("entityName", type.getName());
		mav.addObject("entityDesc", type.getDescription());

		String isList = request.getParameter("isList") == null ? "false"
				: "true";

		String selected = "";
		if (isList.equals("true"))
			selected = "Table";
		else
			selected = "Tab";

		mav.addObject("dataTypeSelect", uiHelper.getDataTypeOptions(
				"datatypes", "field-blue-15-110x20", selected, "disabled"));
		mav.addObject("isList", isList);

		return type;
	}

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	public UIHelper getUiHelper() {
		return uiHelper;
	}

	public void setUiHelper(UIHelper uiHelper) {
		this.uiHelper = uiHelper;
	}

}
