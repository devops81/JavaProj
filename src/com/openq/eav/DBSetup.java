package com.openq.eav;

import java.util.List;

import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.metadata.EntityType;

public class DBSetup extends HibernateDaoSupport {

	private int countOfReservedBasicTypes;

	private int countOfReservedRootnodes;

	private EntityType initCompletedEntityType;

	private EntityType reservedEntityType;

	private EntityType reservedBasicType;

	private List basicTypes;

	private List rootNodes;

	public void start() {
		if (isAlreadyInitialized())
			return;

		setupTypes(basicTypes);

		setupType(reservedBasicType, countOfReservedBasicTypes,"ReservedBasicType");

		setupTypes(rootNodes);
		setupType(reservedEntityType, countOfReservedRootnodes,"ReservedRootNode");

		setupType(initCompletedEntityType, 1,"DBSetup Completed");
		
		System.out.println("");
		System.out.println("======================== Summary ==================================");
		System.out.println("    Inserted " + basicTypes.size() + " basic types.");
		System.out.println("    Reserved " + countOfReservedBasicTypes + " entries for basic types.");
		System.out.println("    Inserted " + rootNodes.size() + " root nodes.");
		System.out.println("    Reserved " + countOfReservedRootnodes + " entries for root nodes.");
		System.out.println("===================================================================");
		
	}
    
	
	private void setupTypes(List entityTypes) {
		for (int i = 0; i < entityTypes.size(); i++) {
			getHibernateTemplate().save(entityTypes.get(i));
		}
	}

	private void setupType(EntityType entityType, int count,String name) {
		for (int i = 0; i < count; i++) {
			entityType.setName(name+i);
			getHibernateTemplate().save(entityType);
		}
	}

	public boolean isAlreadyInitialized() {
		EntityType t = (EntityType) getHibernateTemplate()
				.get(EntityType.class, new Long(basicTypes.size()
						+ rootNodes.size() + countOfReservedBasicTypes
						+ countOfReservedRootnodes));
		if (t == null)
			return false;

		if (!t.getName().equals(initCompletedEntityType.getName()))
			throw new IllegalStateException("Unknown database state.");

		return true;
	}

	public List getBasicTypes() {
		return basicTypes;
	}

	public void setBasicTypes(List basicTypes) {
		this.basicTypes = basicTypes;
	}

	public EntityType getInitCompletedEntityType() {
		return initCompletedEntityType;
	}

	public void setInitCompletedEntityType(EntityType initCompletedEntityType) {
		this.initCompletedEntityType = initCompletedEntityType;
	}

	public EntityType getReservedEntityType() {
		return reservedEntityType;
	}

	public void setReservedEntityType(EntityType reservedEntityType) {
		this.reservedEntityType = reservedEntityType;
	}

	public List getRootNodes() {
		return rootNodes;
	}

	public void setRootNodes(List rootNodes) {
		this.rootNodes = rootNodes;
	}

	public EntityType getReservedBasicType() {
		return reservedBasicType;
	}

	public void setReservedBasicType(EntityType reservedBasicType) {
		this.reservedBasicType = reservedBasicType;
	}

	public int getCountOfReservedBasicTypes() {
		return countOfReservedBasicTypes;
	}

	public void setCountOfReservedBasicTypes(int countOfReservedBasicTypes) {
		this.countOfReservedBasicTypes = countOfReservedBasicTypes;
	}

	public int getCountOfReservedRootnodes() {
		return countOfReservedRootnodes;
	}

	public void setCountOfReservedRootnodes(int countOfReservedRootnodes) {
		this.countOfReservedRootnodes = countOfReservedRootnodes;
	}
	
	public static void main(String [] args) {
		ClassPathResource res = new ClassPathResource("beans.xml");

		XmlBeanFactory factory = new XmlBeanFactory(res);
		
		XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(factory);
		res = new ClassPathResource("dbsetup.xml");
		reader.loadBeanDefinitions(res);
		
		DBSetup initializer = (DBSetup) factory.getBean("DBSetup");
		initializer.start();
	}
}
