package com.openq.web.controllers.helpers;

import com.openq.kol.DBUtil;
import com.openq.kol.DataAccessException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Dec 16, 2006
 * Time: 12:06:38 PM
 * To change this template use File | Settings | File Templates.
 */
public class RemoveUserHelper extends HttpServlet {

        public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


            response.setContentType("text/html");

            response.setHeader("Cache-Control", "no-cache");
            long staffId = 0;
            long staffId1 = 0;
            long staffId2 = 0;


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
                String query = "delete from contacts where staffid in (?,?,?)";
                
                psmt = con.prepareStatement(query);

                 psmt.setLong(1, (staffId));
                 psmt.setLong(2, (staffId1));
                 psmt.setLong(3, (staffId2));

                psmt.executeUpdate();
                con.commit();
            } catch (SQLException e) {
                try {
                    con.rollback();
                } catch (SQLException e1) {
                    e1.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            } catch (Exception e) {
                try {
                    con.rollback();
                } catch (SQLException e1) {
                    e1.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            } finally {
                try {
                    DBUtil.getInstance().closeDBResources(con, psmt,rs);
                } catch (DataAccessException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }

        }


    }
