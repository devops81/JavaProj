package com.openq.presentation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.aspose.slides.AsposeLicenseException;
import com.aspose.slides.PptException;
import com.aspose.slides.Presentation;
import com.aspose.slides.Slide;
import com.aspose.slides.License;

public class SlideMergeService extends HibernateDaoSupport implements ISlideMergeService  {
	
	public String[] getPresentationNames(String files)
	{
		String []pptNames = files.split(",");
		return pptNames;
		
	}
	public String[] getPresentationsPath(String url,String files)
	{
		String []pptNames = files.split(",");
		ArrayList arrList = new ArrayList();
		//String []fileUrl = new String[2]; 
		
		for(int i = 0; i<pptNames.length; i++)
		{
			String temp = url.concat("\\").concat(pptNames[i]);
			arrList.add(temp);
		}
		return (String[]) arrList.toArray(new String[arrList.size()]);
	}
	
	//THIS FUNCTION IS TO BE USED IF WE GO BY APPRAOCH 1
	public String[] getPresentationSlidePairs(String selectedSlides,String[] fileNames,String url)
	{
		String []slides = selectedSlides.split(",");
			
		ArrayList pptSlideList = new ArrayList();
		for(int i = 0; i<slides.length; i++)
		{
			int indexOfP = 0;
			int indexOfS = 0;
			int indexEnd = 0;
		
			for(int j = 0; j<slides[i].length();j++)
			{
				if(slides[i].charAt(j) == 'p')
					indexOfP = j;
				if(slides[i].charAt(j) == 's')
					indexOfS = j;
					
			}
			indexEnd = slides[i].length();
			
			String pptNumber = slides[i].substring(indexOfP+1, indexOfS);
			String slideNumber = slides[i].substring(indexOfS+1);
			
			//Now creating the image path so that can used as picture frames on the slides of the new Presentation
			String imagePath = url.concat("Filename").concat(pptNumber).concat(".ppt\\").concat("img").concat(slideNumber).concat(".png");
		
			
			pptSlideList.add(imagePath);
			
		}
		
		return (String[]) pptSlideList.toArray(new String[pptSlideList.size()]);
		
	}
	
	//THIS FUNCTION IS TO BE USED IF WE GO BY APPRAOCH 2
	//RIGHT NOW WE ARE USING THIS FUNCTION
	//HERE INSTEAD OF RETURNING A STRING ARRAY OF IMAGEPATHS WE RETURN AN ARRAYLIST THAT CONSISTS OF PRESENTATION PATH AND SLIDE NUMBER PAIR.
	/*public ArrayList getPresentationSlidePairsMap(String selectedSlides,String[] presentationNames,String url)
	{
		String []slides = selectedSlides.split(",");
		
		HashMap pptSlideMap = new HashMap();
		
		ArrayList presentationToMap = new ArrayList();
		ArrayList slidesToMap = new ArrayList();
		
		for(int i = 0; i<slides.length; i++)
		{
			int indexOfP = 0;
			int indexOfS = 0;
			int indexEnd = 0;
			for(int j = 0; j<slides[i].length();j++)
			{
				if(slides[i].charAt(j) == 'p')
					indexOfP = j;
				if(slides[i].charAt(j) == 's')
					indexOfS = j;
					
			}
			indexEnd = slides[i].length();
			
			String pptNumber = slides[i].substring(indexOfP+1, indexOfS);
			String slideNumber = slides[i].substring(indexOfS+1);
			
			int pptNum = Integer.parseInt(pptNumber);
			int slideNum = Integer.parseInt(slideNumber);
			
			presentationToMap.add(url+"\\"+presentationNames[pptNum]);
			slidesToMap.add(slideNumber);
			
		}
		
		String[] pptMap = (String[]) presentationToMap.toArray(new String[presentationToMap.size()]);
		String[] slidesMap = (String[]) slidesToMap.toArray(new String[slidesToMap.size()]);
		
		
		//NOW CREATING THE HASHMAP THAT IS TO BE PASSED TO THE CONTROLLER
		for (int i = 0; i < pptMap.length; i++) {
			pptSlideMap.put(pptMap[i],slidesMap[i]);
        }
		
		ArrayList pptSlideMap2 = new ArrayList();
		for(int i = 0;i<pptMap.length;i++)
		{
			String temp = pptMap[i]+","+slidesMap[i];
			pptSlideMap2.add(temp);
		}
		//return pptSlideMap;
		return pptSlideMap2;
	}
	*/
	
	
	public ArrayList getPresentationSlidePairsMap(String selectedSlides,String[] presentationNames,String url)
	{
		
		System.out.println("The selected Slides String is:"+selectedSlides);
		
		char strArray[] = selectedSlides.toCharArray();
		int noOfSlides = 0;
		int indexp1 = 0;
		int indexp2 = 0;
		for(int i = 0;i<strArray.length;i++)
			if(strArray[i]=='p')
				noOfSlides++;
				
		
		
		ArrayList test = new ArrayList();
		ArrayList strList = new ArrayList();
		//for(int i = 0; i<noOfSlides-1;i++)
		for(int i = 0; i<strArray.length;i++)
		{
			if(strArray[i]=='p')
				test.add(new Integer(i));
		}
		
		int testSize = test.size();
		
		for(int i = 0;i<test.size()-1;i++)
		{
			indexp1 = ((Integer)(test.get(i))).intValue();
			indexp2 = ((Integer)(test.get(i+1))).intValue();
			strList.add(selectedSlides.substring(indexp1, indexp2));
		}
		int finalIndex=((Integer)(test.get((test.size())-1))).intValue();
		strList.add(selectedSlides.substring(finalIndex));
		
		String []slides = (String[])strList.toArray(new String [strList.size()]);
		//String []slides = selectedSlides.split(",");
		
		
		HashMap pptSlideMap = new HashMap();
		
		ArrayList presentationToMap = new ArrayList();
		ArrayList slidesToMap = new ArrayList();
		
		for(int i = 0; i<slides.length; i++)
		{
			int indexOfP = 0;
			int indexOfS = 0;
			int indexEnd = 0;
			for(int j = 0; j<slides[i].length();j++)
			{
				if(slides[i].charAt(j) == 'p')
					indexOfP = j;
				if(slides[i].charAt(j) == 's')
					indexOfS = j;
					
			}
			indexEnd = slides[i].length();
			
			String pptNumber = slides[i].substring(indexOfP+1, indexOfS);
			String slideNumber = slides[i].substring(indexOfS+1);
			
			int pptNum = Integer.parseInt(pptNumber);
			int slideNum = Integer.parseInt(slideNumber);
			
			presentationToMap.add(url+"\\"+presentationNames[pptNum]);
			slidesToMap.add(slideNumber);
			
		}
		
		String[] pptMap = (String[]) presentationToMap.toArray(new String[presentationToMap.size()]);
		String[] slidesMap = (String[]) slidesToMap.toArray(new String[slidesToMap.size()]);
		
		
		//NOW CREATING THE HASHMAP THAT IS TO BE PASSED TO THE CONTROLLER
		for (int i = 0; i < pptMap.length; i++) {
			pptSlideMap.put(pptMap[i],slidesMap[i]);
        }
		
		ArrayList pptSlideMap2 = new ArrayList();
		for(int i = 0;i<pptMap.length;i++)
		{
			String temp = pptMap[i]+","+slidesMap[i];
			pptSlideMap2.add(temp);
		}
		//return pptSlideMap;
		return pptSlideMap2;
	}
	
	
	
	
	
	
	
	
	public String createNewPresentation(ArrayList pptSlideMap,String templateName,String url) throws FileNotFoundException, PptException, AsposeLicenseException
	{
		
		License license = new License();
		license.setLicense(new FileInputStream(new File("Aspose.Slides.lic")));
		 
		String presentation = null;
		String slide = null;
		String presentationSlide = null;
		Presentation newPresentation = new Presentation();
		
		for(int iterator = 0;iterator<pptSlideMap.size();iterator++)
		{
			presentationSlide = (String)pptSlideMap.get(iterator);
			String[] strArray = presentationSlide.split(",");
			presentation = strArray[0];
			slide = strArray[1];
			
			
			int slidePosition  = Integer.parseInt(slide)+1; 
		
			Presentation part1 = new Presentation(new FileInputStream(new File(presentation)));
			TreeMap ids = new TreeMap();
            if(newPresentation.getSlides().size() != 0)
            {	
				for (int i = 0; i < part1.getSlides().size(); i++) {
	                if (part1.getSlides().get(i).getSlidePosition() == slidePosition) {
	                    ids.clear();
	                    Slide sl = part1.cloneSlide(part1.getSlides().get(i),
	                            newPresentation.getSlides().getLastSlidePosition() + 1, newPresentation, ids);
	                }
	            }
            }
            else
            {	
            	for (int i = 0; i < part1.getSlides().size(); i++) {
	                if (part1.getSlides().get(i).getSlidePosition() == slidePosition) {
	                    ids.clear();
	                    Slide sl = part1.cloneSlide(part1.getSlides().get(i),
	                            0, newPresentation, ids);
	                }
	            }
            }
			
		}
		
		
		
		newPresentation.getSlides().removeAt(0);
		
		
		
		//NOW APPLYING A NEW MASTER TEMPLETE .POT FILE FORMAT SPECIFIED.
		//http://www.aspose.com/community/forums/79025/showthread.aspx This is the link in the aspose.slides forum which contains the 
		//information to apply a master template to an existing presentation
		//RIGHT NOW THE FILE PATH IS HARDCODED .. 
		Presentation srcTemplate;
		
		if(templateName.equalsIgnoreCase("Template1"))
			srcTemplate = new Presentation(new FileInputStream(new File(url+"\\Template1.pot")));
		else
			srcTemplate = new Presentation(new FileInputStream(new File(url+"\\Template2.pot")));
		
		
		TreeMap SortedList = new TreeMap();
		Slide sld = srcTemplate.cloneSlide(srcTemplate.getSlideByPosition(1),1, newPresentation,SortedList);
				
		//Save the master id of the newly cloned slide
		long mstrId = sld.getMasterId();
		//Delete the extraneous slide
		newPresentation.getSlides().remove(sld);
		//Get the master slide
		Slide mstrSld = newPresentation.getSlideById(mstrId);
		//Change the master of all the normal slides in source presentation
		for (int i = 1; i <= newPresentation.getSlides().getLastSlidePosition(); i++)
		{
			Slide normSld = newPresentation.getSlideByPosition(i);
			normSld.changeMaster(mstrSld, true);
		}
		
		//I AM WRITING THIS FILE TO THE DISK. THE PATH WHERE THE FILE IS TO BE WRITTEN CAN BE SPECIFIED
		newPresentation.write(new FileOutputStream(new File("E:\\openQ40new\\output\\openQ40\\slide2\\Presentation.ppt")));
		
		//NOW GENERATING THE XMLSTRING THAT IS TO BE RETURNED
		StringBuffer xmlString = new StringBuffer("<slidermerge-output><status>");
		if(newPresentation != null)
		{
			xmlString.append("SUCCESS</status>");
			xmlString.append("<url>http://sandbox.openq.com:8000/openQ40/slide2/Presentation.ppt</url>");
		}
		else
		{	xmlString.append("FAILED</status>");
			xmlString.append("<failure-reason>Reason for failure</failure-reason><url></url>");
		}
		
		xmlString.append("</slidermerge-output>");
		
		return xmlString.toString();
	}
	
	
	
	
}




	
