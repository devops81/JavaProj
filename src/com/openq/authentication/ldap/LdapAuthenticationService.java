package com.openq.authentication.ldap;

import com.openq.ExceptionResolver;
import com.openq.authentication.ldap.AbstractLdapAuthenticationService;
import com.openq.authentication.UserDetails;

import java.util.Properties;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.io.InputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.text.DateFormat;


import javax.naming.AuthenticationException;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;

import org.apache.log4j.Logger;

public class LdapAuthenticationService extends AbstractLdapAuthenticationService {

	private static Logger logger = Logger.getLogger(LdapAuthenticationService.class);
    public LdapAuthenticationService()
    {
        properties = new Properties();
        ClassLoader classLoader = this.getClass().getClassLoader();
        try{
            InputStream inputStream = classLoader.getResourceAsStream("resources/custom-setup.prop");
            properties.load(inputStream);
        } catch ( IOException e)
        {
            logger.error("could not load the service property file" + e);
            logger.error(e.getLocalizedMessage(), e);
        }
    }

    public LdapAuthenticationService(Properties properties)
    {
         this.properties = properties;
    }

    public UserDetails authenticate(String username, String password)
    {
        UserDetails user = null;
        try {
            //  DirContext srchContext = getDirContext("none", null, null);
            DirContext srchContext = getDirContext(properties.getProperty("SECURITY_AUTHENTICATION_BASE"),
                                                   properties.getProperty("SECURITY_PRINCIPAL_BASE"),
                                                   properties.getProperty("SECURITY_CREDENTIALS_BASE"));

            BasicAttribute uid = new BasicAttribute("uid");
            uid.add(username);

            BasicAttributes attrs = new BasicAttributes(true);
            attrs.put(uid);

            UserDetails[] users = getLdapUsers(srchContext, attrs);

            if (users.length != 1)
                return null;

            user = users[0];
            try {
                if (  ((String) properties.get("attr")).equalsIgnoreCase("uid") )
                {
                    getDirContext(properties.getProperty("SECURITY_AUTHENTICATION"), "uid=" + user.getUserName() + ','
                        + properties.getProperty("BASE_CONTEXT"), password);
                }
                else
                {
                    getDirContext(properties.getProperty("SECURITY_AUTHENTICATION"), "uniqueIdentifier=" + user.getStaffId() + ','
                        + properties.getProperty("BASE_CONTEXT"), password);
                }

            } catch (AuthenticationException ae) {
            	 logger.error("Password Supplied not correct");
            	 logger.error(ae.getLocalizedMessage(), ae);
                // password supplied is not correct
                return null;
            }

        } catch (Exception e) {
        	logger.error(e.getLocalizedMessage(), e);
            throw new RuntimeException(e);
        }
        return user;
    }

    /*
      * Returns the list of Ldap user with a given name, firstname or lastname.
      */
    public UserDetails[] searchForUser(String name) {
        UserDetails [] users;
        try {
            DirContext srchContext = getDirContext(properties.getProperty("SECURITY_AUTHENTICATION_BASE"),
                                                   properties.getProperty("SECURITY_PRINCIPAL_BASE"),
                                                   properties.getProperty("SECURITY_CREDENTIALS_BASE"));//getDirContext("none", null, null);
            users = searchLdapUsers(srchContext,name);
        } catch (Exception e) {
        	 logger.error(e.getLocalizedMessage(), e);
            throw new RuntimeException(e);
        }
        return users;
    }

	public static void main(String[] args) {


        LdapAuthenticationService ldapser = new LdapAuthenticationService();
		UserDetails ldapuser = (UserDetails) ldapser.authenticate(
				"jmagdlen", "jmagdlen");

		System.out.println(ldapuser);
		System.out.println(ldapuser != null);
		if (ldapuser != null) {
			System.out.println(ldapuser.getFirstName());
			System.out.println(ldapuser.getLastName());
			System.out.println(ldapuser.getEmail());
			System.out.println(ldapuser.getTitle());
		}

		UserDetails [] users = ldapser.searchForUser("chu");
		System.out.println(users.length);
		for (int i=0; i<users.length; i++) {
			System.out.println(users[i].getEmail());
		}
	}
}
