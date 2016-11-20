package com.openq.web.controllers.helpers;

import com.openq.kol.DBUtil;
import com.openq.kol.DataAccessException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.beans.Statement;

/**
 * Created by IntelliJ IDEA.
 * User: radhikav
 * Date: Dec 15, 2006
 * Time: 5:22:05 PM
 * To change this template use File | Settings | File Templates.
 */
public class RealignUserHelper extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


            response.setContentType("text/html");
            HttpSession session = request.getSession();
            response.setHeader("Cache-Control", "no-cache");
            long staffId1 = 0;
            long staffId2 =0;

            if (null != request.getParameter("staffId1")) {
                staffId1 = Long.parseLong(request.getParameter("staffId1"));
                session.setAttribute("STAFFID1",staffId1+"");
            }

            if (null != request.getParameter("staffId2")) {
                staffId2 = Long.parseLong(request.getParameter("staffId2"));
                session.setAttribute("STAFFID2",staffId2+"");
            }

            String list1 = null;
            if (null != request.getParameter("userList1")){
              list1 = request.getParameter("userList1");
            }
            String list2 = null;
            if (null != request.getParameter("userList2")){
              list2 = request.getParameter("userList2");
            }

            String user2 = "";
            if (null != request.getParameter("user2")){
                user2 = request.getParameter("user2");
            }

            String user1 = "";
            if (null != request.getParameter("user1")){
                user1 = request.getParameter("user1");
            }
           String email1 = null != request.getParameter("email1") ? request.getParameter("email1") : null;
           String phone1 = null != request.getParameter("phone1") ? request.getParameter("phone1") : null;

           String email2 = null != request.getParameter("email2") ? request.getParameter("email2") : null;
           String phone2 = null != request.getParameter("phone2") ? request.getParameter("phone2") : null;

           String move="";
            if (null != request.getParameter("move")) move = request.getParameter("move");

            Connection con = null;
            PreparedStatement psmt = null;
            ResultSet rs = null;
            String query ="";
            String query1 = "";

           if (null != move && "list2".equalsIgnoreCase(move) ){
               query = new StringBuffer().append("update contacts set contactname='").append(user2).append("'").append(", staffid = ").append(staffId2).append(",phone=").append(phone2).append(", email='").append(email2).append("' where kolid in ( ").append(list1).append(") and staffid=").append(staffId1).toString();
               query1 = new StringBuffer().append("update kol_development_plan set owner='").append(user2).append("', staffid='").append(staffId2).append("' where expert_id in (").append(list1).append(") and staffid='").append(staffId1).append("'").toString();
           }
           if (null != move && "list1".equalsIgnoreCase(move)){
              query = new StringBuffer().append("update contacts set contactname='").append(user1).append("'").append(",staffid = ").append(staffId1).append(",phone=").append(phone1).append(", email='").append(email1).append("' where kolid in ( ").append(list2).append(") and staffid=").append(staffId2).toString();
              query1 = new StringBuffer().append("update kol_development_plan set owner='").append(user1).append("', staffid='").append(staffId1).append("' where expert_id in (").append(list2).append(") and staffid='").append(staffId2).append("'").toString();
           }

            try {
                con = DBUtil.getInstance().createConnection();

                psmt = con.prepareStatement(query);
                int i = psmt.executeUpdate();
                psmt.close();

                psmt = con.prepareStatement(query1);
                int j = psmt.executeUpdate();

                psmt.close();
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
