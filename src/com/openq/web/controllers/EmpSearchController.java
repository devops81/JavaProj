package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.user.IUserService;
import com.openq.user.User;

public class EmpSearchController extends AbstractController {

    IUserService userService;
    
    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        request.setAttribute("fromEvents", request.getParameter("fromEvents"));
        ModelAndView mav = new ModelAndView("employee_search");
        String name = (String) request.getParameter("searchtext");
        String employeeSearchMessage = "";

        if (name != null && !"".equals(name)) {
                User[] employeeSearchResults = userService.searchEmployee(name);
                request.setAttribute("EMPLOYEE_SEARCH_RESULTS", employeeSearchResults);
                if( employeeSearchResults.length == 0 ){
                    employeeSearchMessage = Constants.EMPLOYEE_SEARCH_MESSAGE;
                }
        }
        request.setAttribute("EMPLOYEE_SEARCH_MESSAGE", employeeSearchMessage);
        return mav;
    }
}