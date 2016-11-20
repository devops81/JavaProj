/*
 * Created on Feb 27, 2006
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.openq.kol;

import java.sql.Timestamp;
import java.io.Serializable;

/**
 * @author ravipm
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

public class KeyMessageDTO implements Serializable{
	
	private int keyMessageId;
	
	private String keyMessageName;
	private String marketClaims;
	private String keyMessageDate;
	private String marketClaimsDesc;
	 

	/**
	 * @return
	 */
	public String getKeyMessageDate() {
		return keyMessageDate;
	}

	/**
	 * @return
	 */
	public int getKeyMessageId() {
		return keyMessageId;
	}

	/**
	 * @return
	 */
	public String getKeyMessageName() {
		return keyMessageName;
	}

	/**
	 * @return
	 */
	public String getMarketClaims() {
		return marketClaims;
	}

	/**
	 * @param timestamp
	 */
	public void setKeyMessageDate(String keyMsgDate) {
		keyMessageDate = keyMsgDate;
	}

	/**
	 * @param i
	 */
	public void setKeyMessageId(int i) {
		keyMessageId = i;
	}

	/**
	 * @param string
	 */
	public void setKeyMessageName(String string) {
		keyMessageName = string;
	}

	/**
	 * @param string
	 */
	public void setMarketClaims(String string) {
		marketClaims = string;
	}
	
	

	/**
	 * @return
	 */
	public String getMarketClaimsDesc() {
		return marketClaimsDesc;
	}

	/**
	 * @param string
	 */
	public void setMarketClaimsDesc(String string) {
		marketClaimsDesc = string;
	}

}
