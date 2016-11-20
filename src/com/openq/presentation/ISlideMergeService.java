package com.openq.presentation;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Collection;

import com.aspose.slides.AsposeLicenseException;
import com.aspose.slides.PptException;



public interface ISlideMergeService {
	
	public String[] getPresentationsPath(String url,String files);
	public String[] getPresentationSlidePairs(String slides,String[] fileNames, String Url);
	public ArrayList getPresentationSlidePairsMap(String selectedSlides,String[] filesPath,String url);
	public String[] getPresentationNames(String files);
	public String createNewPresentation(ArrayList pptSlideMap,String templateName ,String url) throws FileNotFoundException, PptException, AsposeLicenseException;
}
