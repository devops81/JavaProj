package com.openq.audit;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.openq.web.controllers.Constants;

public class HttpRequestMonitor implements HandlerInterceptor {

    public void afterCompletion(HttpServletRequest req, HttpServletResponse res, Object handler, Exception ex) throws Exception {
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView mav)
            throws Exception {
    }

    /**
     * Here we're just implementing the preHandle method to output a bit of logging data *before* the request is handled.
     */
    public boolean preHandle(HttpServletRequest request, HttpServletResponse arg1, Object response) throws Exception {
        Map parameterMap = request.getParameterMap();
        Iterator iter = parameterMap.keySet().iterator();
        StringBuffer buff = new StringBuffer();
        while (iter.hasNext()) {
            Object key = iter.next();
            String val = request.getParameter((String) key);
            
            if(val != null) {
	            buff.append(key);
	            if(val instanceof String)
	            	buff.append("=").append((String) val).append("&");
	            else
	            	buff.append("=").append(val).append("&");
            }
        }
        
        // Extract the details of currently logged-in user and set it on a thread-local variable
        String userIdString = (String) request.getSession().getAttribute(Constants.USER_ID);
        if (userIdString != null) {
            UserThreadLocal.set(new Long(userIdString));
        }
        else {
            UserThreadLocal.set(new Long(-1));
        }

        return true;
    }
}
