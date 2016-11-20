package com.openq.exception;

/**
 * The base exception class for exceptions that are thrown at the data layer.
 * 
 * @author manish.
 * 
 */
public class DataServiceException extends ApplicationException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String errorCode;

	public DataServiceException(String msg) {
		super(msg);
	}

	public DataServiceException(Throwable cause) {
		super(cause);
	}

	public DataServiceException(String msg, Throwable cause) {
		super(msg, cause);
	}

	public DataServiceException(String errorCode, String message) {
		super(message);
		setErrorCode(errorCode);
	}

	public DataServiceException(String errorCode, String message,
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
