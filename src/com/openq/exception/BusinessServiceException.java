package com.openq.exception;

/**
 * The base exception class for exceptions that are thrown at the business
 * layer.
 * 
 * @author manish.
 * 
 */
public class BusinessServiceException extends ApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String errorCode;

	public BusinessServiceException(String msg) {
		super(msg);
	}

	public BusinessServiceException(Throwable cause) {
		super(cause);
	}

	public BusinessServiceException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public BusinessServiceException(String errorCode, String message) {
		super(message);
		setErrorCode(errorCode);
	}

	public BusinessServiceException(String errorCode, String message,
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
