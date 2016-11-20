package com.openq.authentication.ldap;

import com.openq.authentication.IAuthenticationService;
import com.openq.authentication.UserDetails;

import javax.naming.directory.*;
import javax.naming.NamingException;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Properties;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 4, 2007
 * Time: 2:13:42 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class AbstractLdapAuthenticationService implements IAuthenticationService {
    /*
    * Returns details of the user if LDAP authentication is successful. Else
    * returns null.
    */
// TODO: Move these values to config
    protected Properties properties;

    AbstractLdapAuthenticationService()
    {

    }

    protected DirContext getDirContext(String securityLevel, String securityPrincipal, String password)
            throws NamingException
    {
        Hashtable env = new Hashtable();
        env.put(Context.INITIAL_CONTEXT_FACTORY, properties.getProperty("INITIAL_CONTEXT_FACTORY"));
        env.put(Context.PROVIDER_URL, properties.getProperty("PROVIDER_URL"));
        env.put(Context.SECURITY_AUTHENTICATION, securityLevel);

        if (securityLevel.equals("simple")) {
            env.put(Context.SECURITY_CREDENTIALS, password);
            env.put(Context.SECURITY_PRINCIPAL, securityPrincipal);
        }
        DirContext srchContext = new InitialDirContext(env);
        return srchContext;
    }

    protected UserDetails[] getLdapUsers(DirContext dirContext, BasicAttributes attrs)
            throws NamingException
    {
        NamingEnumeration ne = dirContext.search( properties.getProperty("BASE_CONTEXT"), attrs);
        ArrayList users = new ArrayList();
        if (ne != null)
        {
            while (ne.hasMore())
            {
                // Getting individual SearchResult object
                SearchResult sr = (SearchResult) ne.next();
                Attributes attributes = sr.getAttributes();

                UserDetails person = new UserDetails();

                Attribute attr = attributes.get("cn");
                person.setCompleteName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("sn");
                person.setLastName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("uid");
                person.setUserName((attr == null) ? null : (String) attr
                        .get());

                attr = attributes.get("mail");
                person.setEmail((attr == null) ? null : (String) attr.get());

                attr = attributes.get("givenName");
                person.setFirstName((attr == null) ? null : (String) attr
                        .get());

                attr = attributes.get("telephoneNumber");
                person.setTelephoneNumber((attr == null) ? null
                        : (String) attr.get());

                attr = attributes.get("uniqueIdentifier");
                person.setStaffId((attr == null) ? null : (String) attr
                        .get());

                users.add(person);
            }
        }

        return (UserDetails []) users.toArray(new UserDetails[users.size()]);
    }

    protected UserDetails[] searchLdapUsers(DirContext dirContext, String name)
            throws NamingException
    {
        NamingEnumeration ne = dirContext.search(properties.getProperty("BASE_CONTEXT"),"(sn=*"+name+"*)",null);
        ArrayList users = new ArrayList();
        if (ne != null)
        {
            while (ne.hasMore())
            {
                SearchResult sr = (SearchResult) ne.next();
                Attributes attributes = sr.getAttributes();
                UserDetails person = new UserDetails();
                Attribute attr = attributes.get("cn");
                person.setCompleteName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("sn");
                person.setLastName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("uid");
                person.setUserName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("mail");
                person.setEmail((attr == null) ? null : (String) attr.get());

                attr = attributes.get("givenName");
                person.setFirstName((attr == null) ? null : (String) attr.get());

                attr = attributes.get("telephoneNumber");
                person.setTelephoneNumber((attr == null) ? null : (String) attr.get());

                attr = attributes.get("uniqueIdentifier");
                person.setStaffId((attr == null) ? null : (String) attr.get());

                attr = attributes.get("title");
                person.setTitle((attr == null) ? null : (String) attr.get());

                users.add(person);
            }
        }

        return (UserDetails []) users.toArray(new UserDetails[users.size()]);
    }
}
