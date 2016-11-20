package com.openq.utils;

import java.io.FileWriter;

public class ReportEMail {

	public String kolName;
	
	public String username;
	
	private String part1 = "Dear Dr. ";
	
	private String part2 = "\n\nPlease Find the attached PDF Report sent to you by "; 
	private String part3 = ".\n\n"
						+"\nThank You.";
	public String returnCompleteHTMLString()
	{
		StringBuffer html=new StringBuffer();
		html.append(part1);
		html.append(kolName);
		html.append(part2);
		html.append(username);
		html.append(part3);
		return(html.toString());
	}

	}