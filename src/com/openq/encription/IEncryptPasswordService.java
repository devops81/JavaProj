package com.openq.encription;
import javax.naming.ServiceUnavailableException;

public interface IEncryptPasswordService {
	public String encryptPassword(String plaintext)	throws ServiceUnavailableException;	
}

		

