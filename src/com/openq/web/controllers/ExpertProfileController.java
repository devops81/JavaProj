package com.openq.web.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.data.Entity;
import com.openq.eav.data.IDataService;

import com.openq.eav.metadata.AttributeType;
import com.openq.eav.metadata.IMetadataService;
import com.openq.authentication.UserDetails;

public class ExpertProfileController extends AbstractController {

    IMetadataService metadataService;
    IDataService dataService;


    public ModelAndView handleRequestInternal(HttpServletRequest request,
                                              HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("expertprofile");

        UserDetails user = (UserDetails) request.getSession().getAttribute(Constants.CURRENT_USER);
        long kolid=(long) Long.parseLong(request.getParameter("kolid"));

        Entity entity = (Entity) dataService.getEntity(kolid);
        AttributeType[] attributes=(AttributeType[]) metadataService.getAllAttributes(entity.getId());

        String [] linklabel = null;


         for(int i=0;i<attributes.length;i++)
        {
             linklabel[i] = attributes[i].getLabel();

        }

        mav.addObject("linklabels", linklabel);

        return mav;
    }

    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }
}

