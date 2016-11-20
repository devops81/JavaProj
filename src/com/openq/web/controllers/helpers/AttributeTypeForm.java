package com.openq.web.controllers.helpers;

import javax.servlet.http.HttpServletRequest;

import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.metadata.MetadataUtil;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionNames;

public class AttributeTypeForm {

	public String name = "";

	public String desc = "";

	public String[] typeOptions;

	public int selectedType = 0;

	public OptionNames [] optionList;

	public long selectedOption = 0;

	public static final String[] textSizeOptions = new String[] { "Small", "Medium", "Large" };

	public String selectedSize = textSizeOptions[0];

	public String width = "";

	public boolean mandatory = false;

	public boolean viewable = true;

	public boolean searchable = false;
	
	public boolean edit = false;
	
	public String viewGroups = "";
	
	public String editGroups = "";
	
	public boolean showAddAttributeForm = false;
	
	public long entityTypeId = -1;
	
	public boolean isArrayList = false;
	
	public boolean isLeaf = false; // allow delete only if leaf

	public static AttributeTypeForm fillFormValues(long parentEntityId,
			boolean parentIsArray, long attrId,
			IMetadataService metadataService, IOptionService optionSvc) {
		//EntityType parent = metadataService.getEntityType(parentEntityId);
		AttributeTypeForm attrTypeForm = new AttributeTypeForm();
		
		attrTypeForm.optionList = optionSvc.getAllOptionNames();
		
		if (attrId < 0) {
			// Populate empty form for a new attribute
			// if parent an array or has children of basic types, allow only
			// basic types
			if (parentIsArray) {
				// only basic attributes allowed
				attrTypeForm.typeOptions = getBasicTypes();
			} else {
				AttributeType[] attributes = metadataService
						.getAllAttributes(parentEntityId);
				if (attributes != null && attributes.length > 0) {
					if (attributes[0].isEntity()) {
						// only tabs or tables allowed
						attrTypeForm.typeOptions = getEntityTypes();
					} else {
						// all attributes allowed
						attrTypeForm.typeOptions = getBasicTypes();
					}
				} else {
					// allow all types
					attrTypeForm.typeOptions = getAllTypes();
				}
			}
		} else {
			// we are editing an existing attribute
			// make sure that the form is pre-populated with right values
			AttributeType attrToEdit = metadataService.getAttributeType(attrId);
			attrTypeForm.edit = true;
			attrTypeForm.name = attrToEdit.getName();
			attrTypeForm.desc = attrToEdit.getDescription();
			attrTypeForm.typeOptions = new String [] { MetadataUtil.getTypeFromEntityTypeId((int) attrToEdit.getType() - 1, attrToEdit.isArraylist()) };
			attrTypeForm.selectedOption = attrToEdit.getOptionId();
			attrTypeForm.width = ((attrToEdit.getColumnWidth() == null) ? "" : attrToEdit.getColumnWidth());
			attrTypeForm.mandatory = attrToEdit.isMandatory();
			attrTypeForm.searchable = attrToEdit.isSearchable();
			attrTypeForm.viewable = attrToEdit.isShowable();
			if (attrToEdit.getAttributeSize() != null)
				attrTypeForm.selectedSize = attrToEdit.getAttributeSize();
			
			if (!attrToEdit.isEntity()) {
				attrTypeForm.isLeaf = true;
			} else {
				AttributeType [] children = metadataService.getAllAttributes(attrToEdit.getType());
				if (children == null || children.length == 0)
					attrTypeForm.isLeaf = true;
 			}
			if (attrToEdit.isEntity()) {
				attrTypeForm.showAddAttributeForm = true;
				attrTypeForm.entityTypeId = attrToEdit.getType();
				attrTypeForm.isArrayList = attrToEdit.isArraylist();
			}			
		}
		return attrTypeForm;
	}

	public static AttributeType loadAttributeForm(HttpServletRequest request, AttributeType attrType) {
		String name = request.getParameter("attributeName").replaceAll("'","");
		String desc = request.getParameter("description");
		String type = request.getParameter("selectedType");
		String optionId = request.getParameter("selectedOptionId");
		String size = request.getParameter("textSize");
		String width = request.getParameter("columnWidth");
		boolean mandatory = request.getParameter("mandatory") != null;
		boolean searchable = request.getParameter("searchable") != null;
		boolean viewable = request.getParameter("viewable") != null;
		String [] viewGroups = request.getParameterValues("viewGroups");

		long attrTypeId = Long.parseLong(type);
		
		boolean createNew = false;
		if (attrType == null) {
			attrType = new AttributeType();
			createNew = true;
		}
			
		attrType.setName(name);
		attrType.setDescription(desc);

		// cannot change type of existing attribute
		if (createNew) {
			// basic type or entity
			if (attrTypeId < MetadataUtil.BASIC_TYPE_COUNT) {
				attrType.setType(attrTypeId + 1);
			}
			else {
				attrType.setType(-1); // it is an entity
				if (attrTypeId == 8)
					attrType.setArraylist(true);
			}
		}
		
		//	cannot change optionId of existing attribute
		if (createNew)
			attrType.setOptionId(Long.parseLong(optionId == null ? "-1" : optionId));
		
		attrType.setAttributeSize(size);
		attrType.setMandatory(mandatory);
		attrType.setSearchable(searchable);
		attrType.setShowable(viewable);
		attrType.setColumnWidth(width);
		
		return attrType;
	}
	public static String[] getBasicTypes() {
		String[] basicTypes = new String[MetadataUtil.BASIC_TYPE_COUNT];
		System.arraycopy(MetadataUtil.supportedTypes, 0, basicTypes, 0, MetadataUtil.BASIC_TYPE_COUNT);
		return basicTypes;
	}

	public static String[] getEntityTypes() {
		String[] entityTypes = new String[MetadataUtil.ENTITY_TYPE_COUNT];
		System.arraycopy(MetadataUtil.supportedTypes,
				MetadataUtil.BASIC_TYPE_COUNT, entityTypes, 0, MetadataUtil.ENTITY_TYPE_COUNT);
		return entityTypes;
	}

	public static String[] getAllTypes() {
		return MetadataUtil.supportedTypes;
	}
}
