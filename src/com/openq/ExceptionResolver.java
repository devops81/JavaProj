package com.openq;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import com.openq.eav.data.DataService;



public class ExceptionResolver extends SimpleMappingExceptionResolver{
	
	private static Logger l = Logger.getLogger(ExceptionResolver.class);
	
	public ModelAndView resolveException(HttpServletRequest request,
            HttpServletResponse response,
            Object handler,
            Exception ex){
		ModelAndView mav = super.resolveException(request, response, handler, ex);
		
		l.error(ex.getLocalizedMessage(), ex);

		return mav;
		
	}

}
