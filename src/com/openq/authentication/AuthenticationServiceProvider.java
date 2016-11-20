package com.openq.authentication;

import com.openq.authentication.ldap.LdapAuthenticationService;
import com.openq.authentication.db.DbAuthenticationService;
import com.openq.user.IUserService;
import com.openq.user.UserService;
import com.openq.kol.DBUtil;

import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;
import java.io.FileInputStream;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 14, 2007
 * Time: 1:15:40 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * this is singleton class which creates the implementation class of the
 * authentication service provider class based on the property in
 * custom-setup.prop
 */
public class AuthenticationServiceProvider {

    public IAuthenticationService getDbAuthenticationService() {
        return dbAuthenticationService;
    }

    public void setDbAuthenticationService(
            IAuthenticationService dbAuthenticationService) {
        this.dbAuthenticationService = dbAuthenticationService;
    }

    public IAuthenticationService getLdapAuthenticationService() {
        return ldapAuthenticationService;
    }

    public void setLdapAuthenticationService(
            IAuthenticationService ldapAuthenticationService) {
        this.ldapAuthenticationService = ldapAuthenticationService;
    }

    private IAuthenticationService dbAuthenticationService;
    private IAuthenticationService ldapAuthenticationService;

    public AuthenticationServiceProvider() {
    }

    public IAuthenticationService getIAuthenticationService() {
        String authentication = DBUtil.getInstance().prop
        .getProperty("AUTHENTICATION");
        if (authentication.equalsIgnoreCase("LDAP")) {
            return ldapAuthenticationService;
        } else {
            return dbAuthenticationService;
        }
    }

}
