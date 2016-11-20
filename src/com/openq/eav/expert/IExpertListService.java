package com.openq.eav.expert;


import java.io.IOException;
import java.text.ParseException;

import com.openq.contacts.Contacts;
import com.openq.user.HomeUserView;
import com.openq.user.User;


public interface IExpertListService {

    public User[] getOLFromContacts(String staffid);
    
    public HomeUserView[] getOLFromContactsForHomePage(String staffid);
    
    public boolean addOL(Contacts contact) throws IOException, ParseException ;

    public Contacts[] getOLList(long staffId);

    public void updateContactList(long staffId, Contacts[] contact)throws IOException, ParseException ;

    public void deleteContact(Contacts contact);
    
    public void deleteMyExperts(String[] kolIds,String staffId);
    
    public Contacts[] getAllOLList(long staffId);
}