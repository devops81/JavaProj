package com.openq.authentication.db;

import com.openq.authentication.IAuthenticationService;
import com.openq.authentication.UserDetails;
import com.openq.user.IUserService;
import com.openq.user.User;

import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA.
 * User: Lenovo
 * Date: Feb 10, 2007
 * Time: 10:46:39 AM
 * To change this template use File | Settings | File Templates.
 */
public class DbAuthenticationService implements IAuthenticationService {

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    IUserService userService;

    public DbAuthenticationService(IUserService iUserService)
    {
        this.userService = iUserService;
    }

    public DbAuthenticationService()
    {

        System.out.println( " this is being initialized now  " + this);

        System.out.println( " this is being initialized now  " + userService);
    }

    public UserDetails authenticate(String username, String password)
    {
        User user = userService.getUser(username,password);
        if ( user == null )  return null;
        UserDetails userDetails = new UserDetails(user);
        return userDetails;
    }


    public UserDetails[] searchForUser(String name)
    {
        User [] users = userService.searchEmployee(name);
        int length = users.length;
        UserDetails [] userDetails= new UserDetails[length];
        for (int i = 0; i < length; i++)
        {
            User user = users[i];
            userDetails[i] = new UserDetails(user);
        }
        return userDetails;
    }

}
