package com.openq.kol;
/**
 * File 		: DataAccessException.java
 * purpose		: 
 *  
 * Created on Jul 26, 2004
 *
 * Copyright (c) Openq 2005. All rights reserved Unauthorized reproduction
 * and/or distribution is strictly prohibited. 
 * description : 
 * author 	   : Baskark
 */
public class DataAccessException extends Exception {
	

public DataAccessException(String pExceptionMsg) {
	super(pExceptionMsg);
}

public DataAccessException(String pExceptionMsg, Throwable pException) {
	super(pExceptionMsg, pException);
		
}


}
