package com.openq.exception;

/**
 * The base exception class for all user defined exceptions.
 * 
 * @author manish.
 * 
 */
public class ApplicationException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String errorCode;

	public ApplicationException(String msg) {
		super(msg);
	}

	public ApplicationException(Throwable cause) {
		super(cause);
	}

	public ApplicationException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public ApplicationException(String errorCode, String message) {
		super(message);
		setErrorCode(errorCode);
	}

	public ApplicationException(String errorCode, String message,
			Throwable cause) {
		super(message, cause);
		setErrorCode(errorCode);
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

}
