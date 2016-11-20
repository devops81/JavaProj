package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.EavConstants;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.EntityType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.trials.TrialsConstants;

public class MetadataTreeController extends AbstractController {

	IMetadataService metadataService;

	private static final String ENTITY_PREFIX = "entity";

	private static final String ATTRIBUTE_PREFIX = "attr";

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String treeRoot = "foldersTree";
		String initTree = treeRoot + " = gFld('Entity Meta-Data'); ";
		request.getSession().setAttribute(Constants.TREE_ROOT, initTree);

		String kolTree = getEntityTree(EavConstants.KOL_ENTITY_ID, treeRoot);
		request.getSession().setAttribute(Constants.KOL_PROFILE_TREE, kolTree);

		String institutionTree = getEntityTree(
				EavConstants.INSTITUTION_ENTITY_ID, treeRoot);
		request.getSession().setAttribute(Constants.INSTITUTIONS_TREE,
				institutionTree);
		
		String trialsTree = getEntityTree(
				TrialsConstants.TRIAL_ENTITY_ID, treeRoot);
		request.getSession().setAttribute(Constants.TRIALS_TREE,
				trialsTree);

		return new ModelAndView("metadataTree");
	}

	private String getEntityTree(long id, String treeRoot) {
		EntityType type = metadataService.getEntityType(id);
		String nodeName = ENTITY_PREFIX + id;

		String tree = nodeName + " = insFld(" + treeRoot + ", gFld('"
				+ type.getName() + "', 'createAttribute.htm?entityId="
				+ type.getEntity_type_id() + "')); ";
		tree += getAttributeTree(id, nodeName);

		return tree;
	}

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}

	private String getAttributeTree(long entityTypeId, String parent) {
		AttributeType[] attrs = metadataService.getAllAttributes(entityTypeId);
		AttributeType parentAttr = metadataService
				.getAttributeForEntity(entityTypeId);
		
		boolean parentIsList = false;
		if (parentAttr != null)
			parentIsList = parentAttr.isArraylist();

		String tree = " ";
		if (attrs != null && attrs.length > 0)

		{
			for (int i = 0; i < attrs.length; i++) {
				if (attrs[i].isEntity()) {
					// define this node
					String nodeName = ENTITY_PREFIX + attrs[i].getType();

					tree += nodeName + " = insFld(" + parent + ", gFld('"
							+ attrs[i].getName().replaceAll("\'", "\\\\'")
							+ "', 'addAttribute.htm?_action=edit&parentId="
							+ attrs[i].getParent().getEntity_type_id()
							+ "&parentIsList=" + parentIsList
							+ "&attrId=" + attrs[i].getAttribute_id() + "')); ";

					tree += getAttributeTree(attrs[i].getType(), nodeName);
				} else {
						
						
					
					tree += "insDoc(" + parent + ", gLnk('R','"
							+ attrs[i].getName().replaceAll("\'", "\\\\'")
							+ "', 'addAttribute.htm?_action=edit&attrId="
							+ attrs[i].getAttribute_id() + "&parentId="
							+ attrs[i].getParent().getEntity_type_id()
							+ "&parentIsList=" + parentIsList
							+ "')); ";
				}
			}
		}

		return tree;
	}
}
