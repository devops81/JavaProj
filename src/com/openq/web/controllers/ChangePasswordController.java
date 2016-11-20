package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.UserDetails;
import com.openq.authentication.AuthenticationServiceProvider;
import com.openq.authentication.ldap.LdapAuthenticationService;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.web.controllers.Constants;

import java.util.Arrays;

public class ChangePasswordController extends AbstractController{

    protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // TODO Auto-generated method stub
    	HttpSession session = request.getSession();
        ModelAndView mav = new ModelAndView("change_password");
        String currentpassword = (String) request.getParameter("currentpassword");
        String newpassword = (String) request.getParameter("newpassword");
        
        if(currentpassword != null && !currentpassword.equals("")){
            try{
                
            	long userId =  Long.parseLong((String)request.getSession().getAttribute(Constants.USER_ID));
            	User user = userService.getUser(userId);
            	if(user.getPassword().equals(currentpassword))
            	{
            		user.setPassword(newpassword);
            		userService.updateUser(user);
            		session.setAttribute("message", "Password saved Successfully.");
            		session.setAttribute("status","success");
            		
               	}
            	else
            	{
            		session.setAttribute("message", "Please enter correct password");
            		session.setAttribute("status","failed");
            		
            	}
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return mav;
    }

    IUserService userService;
    public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	}