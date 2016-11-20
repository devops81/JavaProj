package com.openq.kol;

/**
 * File 		: ManagerException.java
 * purpose		: 
 *  
 * Created on Jul 29, 2004
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * description : 
 * author 	   : Baskark
 */
public class ManagerException extends Exception {
	

	public ManagerException(String pExceptionMsg) {
		super(pExceptionMsg);
	}

	public ManagerException(String pExceptionMsg, Throwable pException) {
		super(pExceptionMsg, pException);
			
	}
}
