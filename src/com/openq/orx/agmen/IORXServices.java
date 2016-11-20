package com.openq.orx.agmen;

import java.rmi.RemoteException;
import java.io.IOException;

import javax.xml.rpc.ServiceException;

import com.amgen.orx.types.EoList;
import com.amgen.orx.types.RegistrationReceipt;

public interface IORXServices {

	public EoList[] findByCustomerName(String lastName, String firstName, String state) throws ServiceException, RemoteException;
    public RegistrationReceipt registerObject(String name,String middleName, String lastName, String openQID, String OLspeciality, String Location) throws ServiceException, RemoteException, IOException;

}
