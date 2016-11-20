package com.openq.orx.agmen;

import java.io.IOException;
import java.net.URL;
import java.rmi.RemoteException;
import java.util.Properties;

import javax.xml.rpc.ServiceException;

import org.apache.axis.types.NMToken;
import org.apache.axis.types.Token;

import com.amgen.orx.types.BusinessPartnerTypeContactMechanisms;
import com.amgen.orx.types.BusinessPartnerTypeMedicalSpecialties;
import com.amgen.orx.types.CredentialsType;
import com.amgen.orx.types.Customer;
import com.amgen.orx.types.CustomerBPType;
import com.amgen.orx.types.EoList;
import com.amgen.orx.types.FindByArgsType;
import com.amgen.orx.types.MedicalSpecialtyType;
import com.amgen.orx.types.PersonIdentifierType;
import com.amgen.orx.types.PersonIdentifierTypeParsedName;
import com.amgen.orx.types.PersonType;
import com.amgen.orx.types.PostalAddressContactMechType;
import com.amgen.orx.types.RegisterObjects;
import com.amgen.orx.types.RegistrationReceipt;
import com.amgen.orx.wsdl.ORXWebservice.IORXWebservice;
import com.amgen.orx.wsdl.ORXWebservice.ORXWebservice;
import com.amgen.orx.wsdl.ORXWebservice.ORXWebserviceLocator;
import com.openq.kol.DBUtil;

public class ORXServices implements IORXServices{

	public EoList[] findByCustomerName(String lastName, String firstName, String state) throws ServiceException, RemoteException {
		
		ORXWebservice service = new ORXWebserviceLocator();
		
		IORXWebservice port = service.getIORXWebservicePort();

/*
 * Initializing person identifier
 */
		PersonIdentifierTypeParsedName givenName = new PersonIdentifierTypeParsedName();
		givenName.setGivenName(new Token(firstName));
		givenName.setSurName(new Token(lastName));
		PersonIdentifierType identifier = new PersonIdentifierType();
		//identifier.setFullName(customerName);
		identifier.setParsedName(givenName);
		
/*
 * Initializing person information
 */
		PersonType person = new PersonType();
		person.setIdentifier(identifier);
		
/*
 * setting eolist for state or province search
 */		
		PostalAddressContactMechType postalAddress = new PostalAddressContactMechType();
		postalAddress.setStateOrProvinceName(new Token(state));
		BusinessPartnerTypeContactMechanisms contactMechanisms = new BusinessPartnerTypeContactMechanisms();
		contactMechanisms.setPostalAddress(postalAddress);
/*
 * Initializing businesInfo
 */
		CustomerBPType businessInfo = new CustomerBPType();
		businessInfo.setCountryContext(new Token("USA"));
		businessInfo.setPerson(person);
		if(state != null && !state.equals("ANY")){
			businessInfo.setContactMechanisms(contactMechanisms);
		}
/*
 * Initializing customers
 */
		Customer customer = new Customer();
		customer.setBusinessInfo(businessInfo);
		customer.setSsname(new NMToken(""));
		customer.setSsoid(new Token(""));
		
		
/*
 * Initializing values for the EoList
 */
		EoList eoList = new EoList();
		eoList.setCustomer(customer);
		
/*
 * Initializing credentials
 */
		CredentialsType credentials = new CredentialsType();
		credentials.setPassword("GojopDplUE8=");
		credentials.setSystemName(new NMToken("kol-engagement"));
		credentials.setUsername(new NMToken("svc-orx-kolengagement"));
		
		FindByArgsType params = new FindByArgsType();
		params.setCredentials(credentials);
		params.setEoList(eoList);
		EoList res[] = port.findObjectsByAttrs(params);
		return res;
	}

	public RegistrationReceipt registerObject(String name,String middleName, String lastName, String openQID, String OLspeciality, String Location) throws ServiceException, IOException {

		ORXWebservice service = new ORXWebserviceLocator();
		Properties p = DBUtil.getInstance().getDataFromPropertiesFile("resources/ServerConfig.properties");
		String webserviceURL = p.getProperty("webservice.url");
		if(webserviceURL == null){
			return null;
		}
		IORXWebservice port = service.getIORXWebservicePort(new URL(webserviceURL));
		
		RegisterObjects regObj = new RegisterObjects();
		
		CredentialsType cred = new CredentialsType();
		cred.setPassword("rJaUfxLf8a8=");
		cred.setSystemName(new NMToken("kol-engagement"));
		cred.setUsername(new NMToken("svc-orx-kolengagement"));
		
		MedicalSpecialtyType specialityType = new MedicalSpecialtyType();
		specialityType.setName(new Token(OLspeciality));
		specialityType.setDescription(new Token(""));
		specialityType.setCode(new Token("A"));
		
		BusinessPartnerTypeMedicalSpecialties speciality = new BusinessPartnerTypeMedicalSpecialties();
		speciality.setSpecialty(specialityType);
		
		PersonIdentifierTypeParsedName parsedName = new PersonIdentifierTypeParsedName();
		parsedName.setGivenName(new Token(name));
		parsedName.setMiddleName(new Token(middleName));
		parsedName.setSurName(new Token(lastName));
		
		PersonIdentifierType personIdentifier = new PersonIdentifierType();
		//personIdentifier.setFullName(name);
		personIdentifier.setParsedName(parsedName);
		
		PersonType person = new PersonType();
		person.setIdentifier(personIdentifier);
		
		
		CustomerBPType businessInfo = new CustomerBPType();
		businessInfo.setCountryContext(new Token("USA"));
		businessInfo.setPerson(person);
		//businessInfo.setMedicalSpecialties(speciality);
		
		Customer customer = new Customer();
		customer.setSsname(new NMToken("kol-engagement"));
		customer.setSsoid(new Token(openQID));
		customer.setBusinessInfo(businessInfo);
		
		EoList eolist = new EoList();
		eolist.setCustomer(customer);
		
		regObj.setCredentials(cred);
		regObj.setEoList(eolist);
		
		RegistrationReceipt reciept = port.registerObjects(regObj);
		return reciept;
	}
}
