package com.openq.web.controllers.helpers;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.openq.eav.expert.MyExpertList;
import com.openq.eav.expert.IExpertListService;
import com.openq.kol.DBUtil;
import com.openq.kol.DataAccessException;


/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Dec 12, 2006
 * Time: 3:04:42 PM
 * To change this template use File | Settings | File Templates.
 */
public class AlignedUserHelper extends HttpServlet {
   

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        response.setContentType("text/xml");

        response.setHeader("Cache-Control", "no-cache");
        long staffId = 0;
        long staffId1 = 0;
        long staffId2 = 0;
        long id =0;
       
        if (null != request.getParameter("staffId")) {
            staffId = Long.parseLong(request.getParameter("staffId"));
        }
        if (null != request.getParameter("staffId1")) {
            staffId1 = Long.parseLong(request.getParameter("staffId1"));
        }
        if (null != request.getParameter("staffId2")) {
            staffId2 = Long.parseLong(request.getParameter("staffId2"));
        }


        String userList = "";

        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        try {
            con = DBUtil.getInstance().createConnection();

            psmt = con.prepareStatement("select distinct ID ,firstname, lastname from user_table where id in (select kolid from contacts where staffid =? )");
            if (staffId !=0)
             psmt.setLong(1, (staffId));

            if (staffId1 !=0)
              psmt.setLong(1, (staffId1));

            if(staffId2 != 0)
            psmt.setLong(1, (staffId2));

            rs = psmt.executeQuery();

            while (rs.next()) {
                userList += rs.getString("ID")+"/";
                userList += rs.getString("LASTNAME") + ", "+ rs.getString("FIRSTNAME") + ";";
            }

          response.getWriter().write(userList);


        } catch (SQLException e) {
        } catch (Exception e) {
        } finally {
            try {
                DBUtil.getInstance().closeDBResources(con, psmt,rs);
            } catch (DataAccessException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }

    }


}


