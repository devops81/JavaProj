package com.openq.eav.scripts;

public class Tiers {
	
	public Tiers() {}
	private long id;
    private String custnum;
	private String tier;
	private String ta;
	public String getCustnum() {
		return custnum;
	}
	public void setCustnum(String custnum) {
		this.custnum = custnum;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getTa() {
		return ta;
	}
	public void setTa(String ta) {
		this.ta = ta;
	}
	public String getTier() {
		return tier;
	}
	public void setTier(String tier) {
		this.tier = tier;
	}
	
}
