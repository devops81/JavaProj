package com.openq.contacts;

public interface IContactsService {
	public Contacts [] getContactsForKol (long kolId);
	public void addContact (Contacts contact);
	public void update (Contacts contact);
	public void delete (long contactId);
	public Contacts getContact(long contactId);
	public boolean getContact(Contacts contact);
}
