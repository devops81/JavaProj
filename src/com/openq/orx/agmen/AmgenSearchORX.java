package com.openq.orx.agmen;

import java.rmi.RemoteException;
import java.util.List;

import javax.xml.rpc.ServiceException;

import com.amgen.orx.jaxb.Customer;
import com.amgen.orx.jaxb.EoList;
import com.amgen.orx.jaxb.PostalAddress;
import com.amgen.orx.jaxb.BusinessPartnerType.MedicalSpecialtiesType.Specialty;
import com.openq.orx.ISearchORX;
import com.openq.orx.BestORXRecord;

public class AmgenSearchORX implements ISearchORX {
    public BestORXRecord[] searchORX(String lastName, String firstName) throws RemoteException, ServiceException{
        return searchORX(lastName, firstName, null);
    }

    public BestORXRecord [] searchORX(String lastName, String firstName, String state) throws RemoteException, ServiceException{
        AmgenSimpleAxisClient orxService = new AmgenSimpleAxisClient();
        List eoList = null;
        try{
            eoList = orxService.getOrxClusterForNameAndState(lastName, firstName, state);

        }
        catch(Exception e){
            System.out.println("ORX Service not available.");
            //e.printStackTrace();
        }

        return bestRecord(eoList);
    }

    private int bestORXRecordIndex(EoList eolist){
        if(eolist != null)
            for(int i=0;i<eolist.getCustomerOrCustomerIdentifierOrMockEnterpriseObject().size();i++)
                if(((Customer)eolist.getCustomerOrCustomerIdentifierOrMockEnterpriseObject().get(0)).getSsname().equals("CMA"))
                    return i;
                else if(((Customer)eolist.getCustomerOrCustomerIdentifierOrMockEnterpriseObject().get(0)).getSsname().equals("ORION"))
                    return i;
                else if(((Customer)eolist.getCustomerOrCustomerIdentifierOrMockEnterpriseObject().get(0)).getSsname().equals("ECLINICAL"))
                    return i;
        return 0;
    }

    private BestORXRecord[] bestRecord(List eoList){
        if(eoList != null){
            BestORXRecord [] orxResult = new BestORXRecord[eoList.size()];
            if(eoList != null && orxResult != null  && orxResult.length > 0) {

                for(int i=0;i<eoList.size();i++){
                    orxResult[i] = new BestORXRecord();
                    int bestRecordIndex = bestORXRecordIndex((EoList)(eoList.get(i)));
                    System.out.println("the best record is:" + bestRecordIndex);
                    if(((EoList)(eoList.get(i))).getClusterId().equals("-1"))
                        return null;
                    if(((EoList) eoList.get(i)).getCustomerOrCustomerIdentifierOrMockEnterpriseObject().size() >0){

                        Customer bestRecord = (Customer) ((EoList) eoList.get(i)).getCustomerOrCustomerIdentifierOrMockEnterpriseObject().get(bestRecordIndex);
                    if(bestRecord != null) {
                        if(bestRecord.getSsname() != null)
                            orxResult[i].setSsname(bestRecord.getSsname().toString());
                        if(bestRecord.getAgoid() != null)
                            orxResult[i].setAgoid(Long.parseLong(bestRecord.getAgoid().toString()));
                        if(bestRecord.getSsoid() != null)
                            orxResult[i].setSsoid(bestRecord.getSsoid().toString());
                        if(bestRecord.getBusinessInfo() != null){
                            if(bestRecord.getBusinessInfo().getContactMechanisms() != null) {
                                // TODO: Get postal address from contact machenisms
                                if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().size() > 0){
                                    if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0) instanceof PostalAddress) {

                                        orxResult[i].setCountry(((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getCountryName());

                                        if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().size()>0 && ((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getLocalityName() != null)
                                        orxResult[i].setLocality(((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getLocalityName().toString());
                                        if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().size()> 0&&((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getPostalCode() != null)
                                            orxResult[i].setPostalCode(((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getPostalCode().toString());
                                        if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().size() > 0 && ((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getStateOrProvinceName() != null)
                                            orxResult[i].setProvince(((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getStateOrProvinceName().toString());
                                        if(bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().size()> 0 && ((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getStreetAddress() != null)
                                            orxResult[i].setStreetAddress(((PostalAddress) bestRecord.getBusinessInfo().getContactMechanisms().getOnlineAddressOrPostalAddressOrTelecomAddress().get(0)).getStreetAddress().get(0).toString());
                                    }
                                }
                                //TODO: Get the telecom address from the list
                                /*if(bestRecord.getBusinessInfo().getContactMechanisms().getTelecomAddress() != null){
                                            if(bestRecord.getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom() != null
                                                    && bestRecord.getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom().getFullNumber() != null)
                                                orxResult[i].setPhone(bestRecord.getBusinessInfo().getContactMechanisms().getTelecomAddress().getFullTelecom().getFullNumber());
                                        }*/
                            }

                            if(bestRecord.getBusinessInfo().getPerson() != null){
                                if(bestRecord.getBusinessInfo().getPerson().getIdentifier() != null){
                                    if(bestRecord.getBusinessInfo().getPerson().getIdentifier().getFullName() != null)
                                        orxResult[i].setFullName(bestRecord.getBusinessInfo().getPerson().getIdentifier().getFullName());
                                    if(bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName() != null
                                        && bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName().getGivenName()!= null)
                                        orxResult[i].setFirstName(bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName().getGivenName().toString());
                                    if(bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName() != null
                                            && bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName().getSurName()!= null)
                                        orxResult[i].setLastName(bestRecord.getBusinessInfo().getPerson().getIdentifier().getParsedName().getSurName().toString());
                                }
                            }

                            if(bestRecord.getBusinessInfo().getMedicalSpecialties() != null
                                    && bestRecord.getBusinessInfo().getMedicalSpecialties().getSpecialty() != null
                                    && bestRecord.getBusinessInfo().getMedicalSpecialties().getSpecialty().size() > 0)
                                orxResult[i].setSpecialty(((Specialty) bestRecord.getBusinessInfo().getMedicalSpecialties().getSpecialty().get(0)).getName());
                        }
                    }
                    }
                }
            }
            return orxResult;
            }else
            return null;
    }
}
