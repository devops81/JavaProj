package com.openq.web.controllers;


import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.presentation.ISlideMergeService;

//The URL is :http://localhost:7001/Alpharma50/slidemerge.htm?files=Filename1.ppt,Filename2.ppt&selectedSlides=p0s1p1s3p0s5&templateName=Template1
public class SlideMergeController extends AbstractController {

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();

		ModelAndView mav = new ModelAndView("slidemerge");
		
		
		String Url = "E:\\Presentations";
		String ppt = request.getParameter("files")== null ? "-1" : request.getParameter("files");
		
		String[] filesPath = slideMergeService.getPresentationsPath(Url, ppt);
		String selectedSlides = request.getParameter("selectedSlides")== null ? "-1" : request.getParameter("selectedSlides");
		
		
	/*	THIS IS CODE CAN BE USED TO IMPLEMENT THE first APPROACH
	 * String[] pptSlideList = slideMergeService.getPresentationSlidePairs(selectedSlides,filesPath,Url);
		
		System.out.println("The Number of slides in the new presentation will be:"+pptSlideList.length);
		for(int i = 0; i<pptSlideList.length;i++)
		{
			System.out.println("The imagePath for the "+i+"th slide is: "+pptSlideList[i]);
		}
	*/	
		//HashMap pptSlideMap = slideMergeService.getPresentationSlidePairs(selectedSlides,filesPath);
		
		String[] presentationNames = slideMergeService.getPresentationNames(ppt);
		ArrayList pptSlideMap = slideMergeService.getPresentationSlidePairsMap(selectedSlides,presentationNames,Url);
			
		String templateName = request.getParameter("templateName") == null ? "-1" : request.getParameter("templateName");
			
		String xmlString = slideMergeService.createNewPresentation(pptSlideMap, templateName,Url);
		
		System.out.println("The XMLSTRING IN THE CONTROLLER IS:"+xmlString);
		
		(request.getSession()).setAttribute("xmlString", xmlString);
		
		
		
		return mav;
		}
	
	private ISlideMergeService slideMergeService;

	public ISlideMergeService getSlideMergeService() {
		return slideMergeService;
	}

	public void setSlideMergeService(ISlideMergeService slideMergeService) {
		this.slideMergeService = slideMergeService;
	}

		
	//http://www.idevelopment.info/data/Programming/java/object_oriented_techniques/HashCodeExample.java
	
	
	

}
