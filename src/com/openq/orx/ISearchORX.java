package com.openq.orx;

import javax.xml.rpc.ServiceException;
import java.rmi.RemoteException;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 15, 2007
 * Time: 1:57:51 PM
 * To change this template use File | Settings | File Templates.
 */
public interface ISearchORX {
    BestORXRecord[] searchORX(String lastName, String firstName) throws RemoteException, ServiceException;

    BestORXRecord [] searchORX(String lastName, String firstName, String state) throws RemoteException, ServiceException;
}
