package com.openq.authentication;

/**
 * Created by IntelliJ IDEA.
 * User: PRASHANTH
 * Date: Jan 14, 2007
 * Time: 12:51:56 PM
 * To change this template use File | Settings | File Templates.
 */
public interface IAuthenticationService {
/**
 * this is the interface which any authentication service provider must
 * implements. the logical implemention can be db based, ldap based or
 * any other.
 */
    UserDetails authenticate(String username, String password);

    /*
      * Returns the list of Ldap user with a given name, firstname or lastname.
      */
    UserDetails[] searchForUser(String name);
}
