package com.openq.utils;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

	public class ServerAuthenticator extends Authenticator{

		PasswordAuthentication auth;
		public ServerAuthenticator(){ 
		this.auth=new PasswordAuthentication("tarun","pause28b");
		}
		public PasswordAuthentication getPasswordAuthentication()
		{
		    return auth;
		}

}
