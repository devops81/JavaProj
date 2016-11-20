package com.openq.web.controllers;

import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.event.materials.EventMaterial;
import com.openq.event.materials.IEventMaterialService;

public class EventMaterialController extends AbstractController{

	protected ModelAndView handleRequestInternal(HttpServletRequest req,HttpServletResponse res) throws Exception {
		HttpSession session = req.getSession(true);
		System.out.println("*******************************************st 1*****");
		
		 if("getFile".equalsIgnoreCase(req.getParameter("action"))){
	    	System.out.println("material id is"+req.getParameter("materialId"));
	    	EventMaterial mat=eventMaterialService.getEventMaterial(Long.parseLong(req.getParameter("materialId").toString()));
	    	System.out.println("the file name from db is "+mat.getName());
	    	Blob materialContent=mat.getMaterialContent();
	    	res.setBufferSize(8192);	    	
	        res.setContentType("application/octet-stream");
	        res.setHeader("Content-Disposition", "attachment; filename=\""+ mat.getName() + "\"");
	        OutputStream os = res.getOutputStream();
	        try{
	            FileCopyUtils.copy(mat.getMaterialContentStream(), res.getOutputStream());
	          }finally{
	        	mat.getMaterialContentStream().close();
	            os.flush();
	            os.close();
	          }
	    	return null;		    	
	    }
		 if("viewFile".equalsIgnoreCase(req.getParameter("action"))){
			 	ArrayList inputStream=(ArrayList)req.getSession().getAttribute("inputStream");
			 	ArrayList filePath=(ArrayList)session.getAttribute("filePath");
			 	String index=req.getParameter("index");
			 	InputStream is=(InputStream)inputStream.get(Integer.parseInt(index));	
			 	res.setBufferSize(8192);
		        res.setContentType("application/octet-stream");
		        res.setHeader("Content-Disposition", "attachment; filename=\""+ filePath.get(Integer.parseInt(index)) + "\"");
		        OutputStream os = res.getOutputStream();
		        try{
		            FileCopyUtils.copy(is, res.getOutputStream());
		          }finally{
		        	  is.close();
		            os.flush();
		            os.close();
		          }
		    	return null;		    	
		    } 
		if (req.getContentType() != null&& req.getContentType().indexOf("multipart") >= 0) {
			MultipartHttpServletRequest mreq = (MultipartHttpServletRequest)req;
		    String action = mreq.getParameter("action");
		    System.out.println("file in contrller is "+mreq.getFile("materialFile").getOriginalFilename());
		    req.setAttribute("mreq", mreq);
		    System.out.println("st 2 action is"+action);
		    if("upload".equalsIgnoreCase(action)){
		    	EventMaterial material = new EventMaterial();
		    	
		        //material.setName(mreq.getParameter("file_name"));
		        material.setDescription(mreq.getParameter("versionNumber"));		        
		        material.setMaterialContentStream(mreq.getFile("materialFile").getInputStream());
		        //material.setEventId(Long.parseLong(mreq.getParameter("eventId")));
		        //eventMaterialService.saveEventMaterial(material);
		        session.setAttribute("material", material);
		    }else if("View".equalsIgnoreCase(action)){
		    	System.out.println("st 3");
		    	System.out.println("event id is "+session.getAttribute("eventId"));
		    	if(session.getAttribute("eventId")!=null){
			    	String eventId=session.getAttribute("eventId").toString();
			    	EventMaterial[] materials=eventMaterialService.getAllEventMaterialsOfEvent(Long.parseLong(eventId));
			    	session.setAttribute("materials", materials);
			    	//action=null;
		    	}
		    		    	
		    }else if("getFile".equalsIgnoreCase(action)){
		    	System.out.println("material id is"+req.getAttribute("materialId"));
		    	EventMaterial mat=eventMaterialService.getEventMaterial(Long.parseLong(req.getAttribute("materialId").toString()));
		    	System.out.println("the file name from db is "+mat.getName());
		    	Blob materialContent=mat.getMaterialContent();
		    	res.setBufferSize(8192);
		        res.setContentType("application/octet-stream");
		        res.setHeader("Content-Disposition", "attachment; filename=\""+ mat.getName() + "\"");
		        OutputStream os = res.getOutputStream();
		        try{
		            FileCopyUtils.copy(mat.getMaterialContentStream(), res.getOutputStream());
		          }finally{
		        	mat.getMaterialContentStream().close();
		            os.flush();
		            os.close();
		          }
		    	return null;		    	
		    }
		    
		}
		ModelAndView mav = new ModelAndView("exp_present_mat");
	    return mav;
	}
	
	public IEventMaterialService eventMaterialService;

	public IEventMaterialService getEventMaterialService() {
		return eventMaterialService;
	}

	public void setEventMaterialService(IEventMaterialService eventMaterialService) {
		this.eventMaterialService = eventMaterialService;
	}
	
}
