package com.openq.web.filter;

import java.io.IOException;
import java.text.MessageFormat;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class CacheControlFilter implements Filter {

    static Logger logger = Logger.getLogger(CacheControlFilter.class);

    String maxAge = null;

    static final String CACHE_CONTROL_HEADER = "Cache-Control";

    static final String MAX_AGE = "max-age={0}";

    static final String CACHE_FILTER_FLAG = "cache.filter.flag";

    public void destroy() {
        logger.debug("CacheControlFilter destroyed");
    }

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain filterChain) throws IOException, ServletException {

        if (response instanceof HttpServletResponse) {
            
            //Check if the filter has been applied already.
            Boolean isApplied = (Boolean) request
                    .getAttribute(CACHE_FILTER_FLAG);
            if (isApplied == null || !isApplied.booleanValue()) {
                HttpServletResponse httpResponse = (HttpServletResponse) response;
                if (maxAge != null) {
                    httpResponse.setHeader(CACHE_CONTROL_HEADER, MessageFormat
                            .format(MAX_AGE, new Object[] { maxAge }));
                }
                //Set the applied flag to make sure this filter doesn't get applied again.
                request.setAttribute(CACHE_FILTER_FLAG, Boolean.TRUE);
            }
        }
        filterChain.doFilter(request, response);

    }

    public void init(FilterConfig filterConfig) throws ServletException {

        maxAge = filterConfig.getInitParameter("maxage");

        logger.debug("CacheControlFilter initialized with max-age = " + maxAge);
    }

}
