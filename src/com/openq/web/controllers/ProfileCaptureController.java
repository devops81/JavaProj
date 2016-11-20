package com.openq.web.controllers;

import com.openq.kol.SearchDTO;
import com.openq.ovid.PublicationsManager;
import com.openq.web.ActionKeys;
import com.openq.eav.data.IDataService;
import com.openq.user.IUserService;
import com.openq.user.User;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.TreeMap;

/**
 * User: abhrap
 * Date: Dec 12, 2006
 * Time: 2:38:45 PM
 */
public class ProfileCaptureController extends AbstractController {
    IDataService dataService;
    IUserService userService;

    public IUserService getUserService() {
        return userService;
    }

    public void setUserService(IUserService userService) {
        this.userService = userService;
    }

    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

    protected ModelAndView handleRequestInternal(HttpServletRequest request,
                                                 HttpServletResponse httpServletResponse) throws Exception {

        HttpSession session = request.getSession();
        String action = (String) request.getParameter("action");
        PublicationsManager manager = new PublicationsManager();
        session.setAttribute("CURRENT_LINK", "Profile Capture");
        if (ActionKeys.OVID_HOME.equals(action)) {

            ArrayList publicationDetails = manager.refreshProfiles();
            session.setAttribute("PUBLICATION_DETAILS", publicationDetails);
            session.setAttribute("CURRENT_LINK_OVID", "Results");
            return new ModelAndView("ovid_search_home");

        } else if (ActionKeys.OVID_RESULTS.equals(action)) {

            ArrayList publicationDetails = manager.refreshProfiles();
            session.setAttribute("PUBLICATION_DETAILS", publicationDetails);
            session.setAttribute("CURRENT_LINK_OVID", "Results");
            return new ModelAndView("ovid_search_home");

        } else if (ActionKeys.OVID_DATA_SOURCES.equals(action)) {
            session.setAttribute("CURRENT_LINK_OVID", "Data Sources");
            return new ModelAndView("ovid_datasources");
        } else if (ActionKeys.OVID_SCHEDULE.equals(action)) {
            session.setAttribute("CURRENT_LINK_OVID", "Ovid Schedule");
            request.setAttribute("results", manager.getOvidScheduleDetails());
            return new ModelAndView("ovid_schedule");
        } else if (ActionKeys.PUBLICATION_DETAILS.equals(action)) {

            String authorId = null;
            if (request.getParameter("expert_id") != null) {
                authorId = request.getParameter("expert_id");
            }
            SearchDTO searchDTO = null;
            ArrayList uncommitedPubs = null;
            if (null != authorId && !"".equals(authorId)) {
                searchDTO = manager.getOVIDAuthor(Integer.parseInt(authorId));
                uncommitedPubs = manager.showNewPubs(Integer.parseInt(authorId));
            }
            session.setAttribute("PROFILE_DETAILS", searchDTO);
            session.setAttribute("UNCOMMITED_PUBLICATIONS", uncommitedPubs);

            return new ModelAndView("publication_details");

        } else if (ActionKeys.SHOW_ABSTRACT.equals(action)) {

            String[] result = manager.getAbstract(request.getParameter("expId"), request.getParameter("uId"));
            request.setAttribute("abstract", result[0]);
            request.setAttribute("title", result[1]);

            return new ModelAndView("ovid_abstract");
        } else if (ActionKeys.COMMIT_DB.equals(action)) {
            String authors[] = request.getParameterValues("authorList");
            TreeMap authorsList = null;
            String authorId = null;
            if (null != authors && authors.length > 0) {
                authorsList = new TreeMap();
                String authorPublicationIds[] = null;
                for (int i = 0; i < authors.length; i++) {
                    authorPublicationIds = authors[i].split(",");
                    if (authorPublicationIds[0] != null && !"".equals(authorPublicationIds[0]) &&
                            authorPublicationIds[1] != null && !"".equals(authorPublicationIds[1])) {
                        authorsList.put(authorPublicationIds[1].trim(), authorPublicationIds[0].trim());
                        authorId = authorPublicationIds[0].trim();
                    }
                }
            }
            if(authorId != null && !"".equals(authorId)) {
                User user = userService.getUser(Long.parseLong(authorId));
                ArrayList pubList = manager.getPublications(authorsList);
                dataService.savePublications(user.getKolid(),5,pubList);
            }

            session.setAttribute("CURRENT_LINK_OVID", "Results");
            ArrayList publicationDetails = manager.refreshProfiles();
            session.setAttribute("PUBLICATION_DETAILS", publicationDetails);
            return new ModelAndView("ovid_search_home");
        }
        return null;
    }
}
