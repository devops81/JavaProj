package com.openq.orx.agmen;

import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import com.amgen.orx.jaxb.Credentials;
import com.amgen.orx.jaxb.Customer;
import com.amgen.orx.jaxb.CustomerBPType;
import com.amgen.orx.jaxb.EoListType;
import com.amgen.orx.jaxb.FindObjectsByAttrs;
import com.amgen.orx.jaxb.ObjectFactory;
import com.amgen.orx.jaxb.PersonIdentifierType;
import com.amgen.orx.jaxb.PersonType;
import com.amgen.orx.jaxb.PostalAddress;
import com.amgen.orx.jaxb.BusinessPartnerType.ContactMechanismsType;
import com.amgen.orx.jaxb.PersonIdentifierType.ParsedNameType;

public class AmgenWebServiceRequestGenerator {

	public static final String PACKAGE_NAME = "com.amgen.orx.jaxb";
	
	public static String createFindObjectsByAttrsRequest(String lastName, String firstName, String state) throws JAXBException {
		JAXBContext jc = JAXBContext.newInstance(PACKAGE_NAME);
		String surname = lastName == null ? "" : lastName;
		String givenName = firstName == null ? "" : firstName;

		ObjectFactory objFactory = new ObjectFactory();
		FindObjectsByAttrs findSourceObjects = objFactory
				.createFindObjectsByAttrs();
		EoListType eoList = objFactory.createEoListType();

		Customer custObj = objFactory.createCustomer();
		CustomerBPType custBo = objFactory.createCustomerBPType();
		custBo.setCountryContext("USA");

		PersonType person = (PersonType) objFactory.createPersonType();
		PersonIdentifierType id = (PersonIdentifierType) objFactory.createPersonIdentifierType();
		ParsedNameType parsedName = objFactory.createPersonIdentifierTypeParsedNameType();
		parsedName.setSurName(surname);
		parsedName.setGivenName(givenName);
		id.setParsedName(parsedName);
		person.setIdentifier(id);
		custBo.setPerson(person);
		
		if (state != null && !state.equals("") && !state.equalsIgnoreCase("Any")) {
			ContactMechanismsType contactMT = (ContactMechanismsType) objFactory.createBusinessPartnerTypeContactMechanismsType();
			PostalAddress pa = objFactory.createPostalAddress();
			pa.setStateOrProvinceName(state);
			contactMT.getOnlineAddressOrPostalAddressOrTelecomAddress().add(pa);
			custBo.setContactMechanisms(contactMT);
		}

		custObj.setBusinessInfo(custBo);
		custObj.setSsoid("");
		custObj.setSsname("");
		
		eoList.getCustomerOrCustomerIdentifierOrMockEnterpriseObject().add(custObj);
		findSourceObjects.setEoList(eoList);

		Credentials credentials = objFactory.createCredentials();
		credentials.setPassword("GojopDplUE8=");
		credentials.setUsername("svc-orx-kolengagement");
		credentials.setSystemName("kol-engagement");
		findSourceObjects.setCredentials(credentials);
		
		StringWriter sos = new StringWriter();
		jc.createMarshaller().marshal(findSourceObjects, sos);
		sos.flush();
		return sos.toString();
	}
}
