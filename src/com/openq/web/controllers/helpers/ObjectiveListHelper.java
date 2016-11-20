package com.openq.web.controllers.helpers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.openq.kol.DBUtil;
import com.openq.kol.QueryUtil;



public class ObjectiveListHelper extends HttpServlet {

    private ServletContext servContext;
	int i = 0;

	/**
	 * servlet init method.
	 * @param servletconfig object.
	 */
    public void init(ServletConfig config) throws ServletException {
    	this.servContext = config.getServletContext();
    }

    /**
     * This method gets affiliates for a particular state.
     * @param request
     * @param response
     * @throws serveletException
     * @throws IOException
     */
    public void doGet(HttpServletRequest request, HttpServletResponse  response)
        								throws IOException, ServletException {
    	
		String objName = new String();		

		String taField = request.getParameter("taField");
		String faField = request.getParameter("faField");
		String regionField = request.getParameter("regionField");      

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
			
		try {
	    	
	    	con = DBUtil.getInstance().createConnection();
	    	String query = QueryUtil.getInstance().getQuery("KOL.ALL_MAIN_OBJECTIVES.INFO.SELECT.BASED_ON_FILTER");	
	    	
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, taField);
			pstmt.setString(2, faField);
			pstmt.setString(3,regionField);
			rs = pstmt.executeQuery();
		    	
	    	while (rs.next()) {	
				objName += rs.getInt("MAIN_OBJECTIVE_ID")+"*";
				objName += rs.getString("MAIN_OBJECTIVE")+";";			    		
	    	}			    	
	    	
		} catch (SQLException e) {					
		} catch (Exception e) {
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (pstmt != null){
					pstmt.close();
				}
				if (con != null){
					con.close();
				}
			} catch (SQLException e) {}
		}					
			
		response.setContentType("text/xml");
		response.setHeader("Cache-Control", "no-cache");
		response.getWriter().write(objName);		
	
    } // end of doGet()

} // end of class