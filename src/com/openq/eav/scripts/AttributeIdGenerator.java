/**
 * 
 */
package com.openq.eav.scripts;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

import com.openq.eav.EavConstants;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;

/**
 * @author Anand
 *
 */
public class AttributeIdGenerator implements IAttributeIdGenerator {

	public static void main(String[] args) {
		// initialize this bean
		ClassPathResource res = new ClassPathResource("beans.xml");

		XmlBeanFactory factory = new XmlBeanFactory(res);
		IAttributeIdGenerator idGenerator = (IAttributeIdGenerator) factory.getBean("attrIdGenerator");
		idGenerator.generate("KOL", EavConstants.KOL_ENTITY_ID);
	}

	/*
	 * Generates Ids for the entire subtree of an entity. It's in a format that can be 
	 * directly used in a constants file.
	 */
	public void generate(String name, long entityTypeId) {
		if (metadataService == null)
			System.out.println("metadata service is null");
		AttributeType [] attributes = metadataService.getAllAttributes(entityTypeId);
		write(name + "_ENTITY", entityTypeId);
		System.out.println();
		System.out.println("// Generating attribute IDs for " + name);
		for (int i=0; i<attributes.length; i++) {
			write(name + "_" + attributes[i].getName(), attributes[i].getAttribute_id());
			if (attributes[i].isEntity()) {
				generate(name + "_" + attributes[i].getName(), attributes[i].getType());
			}
		}
	}

	private void write(String name, long entityTypeId) {
		// remove whitespace from name before writing to console
		System.out.println("public static final long " + name.replace(' ', '_') + " = " + entityTypeId + "l;");
	}

	IMetadataService metadataService;

	public IMetadataService getMetadataService() {
		return metadataService;
	}

	public void setMetadataService(IMetadataService metadataService) {
		this.metadataService = metadataService;
	}
}
