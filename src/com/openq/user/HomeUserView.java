package com.openq.user;

public class HomeUserView implements Comparable{

	private long id;
	private String firstName = null;
	private String middleName = null;
	private String lastName = null;
	private String deleteFlag = null;
	private long kolId;
	private String title =null;
	private String specialty1 = null;
	private String specialty2 = null;
	private String specialty3 = null;
	private String specialty4 = null;
	private String specialty5 = null;
	private String specialty6 = null;
	private String city = null;
	private String state = null;
	private String country = null;
	private String phone = null;
	private String staffId = null;
	private String speciality = null;
	private String tier = null;
	private String mslOlType = null;
	public String getMslOlType() {
		return mslOlType;
	}
	public void setMslOlType(String mslOlType) {
		this.mslOlType = mslOlType;
	}
	public String getSpeciality() {
		return speciality;
	}
	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public long getKolId() {
		return kolId;
	}
	public void setKolId(long kolId) {
		this.kolId = kolId;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getMiddleName() {
		return middleName;
	}
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getSpecialty1() {
		return specialty1;
	}
	public void setSpecialty1(String specialty1) {
		this.specialty1 = specialty1;
	}
	public String getSpecialty2() {
		return specialty2;
	}
	public void setSpecialty2(String specialty2) {
		this.specialty2 = specialty2;
	}
	public String getSpecialty3() {
		return specialty3;
	}
	public void setSpecialty3(String specialty3) {
		this.specialty3 = specialty3;
	}
	public String getSpecialty4() {
		return specialty4;
	}
	public void setSpecialty4(String specialty4) {
		this.specialty4 = specialty4;
	}
	public String getSpecialty5() {
		return specialty5;
	}
	public void setSpecialty5(String specialty5) {
		this.specialty5 = specialty5;
	}
	public String getSpecialty6() {
		return specialty6;
	}
	public void setSpecialty6(String specialty6) {
		this.specialty6 = specialty6;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

    public int compareTo(Object o) {
	     return this.lastName.compareTo(((HomeUserView)o).getLastName());
    }
	/**
	 * @return the city
	 */
	public String getCity() {
		return city;
	}
	/**
	 * @param city the city to set
	 */
	public void setCity(String city) {
		this.city = city;
	}
	public String getTier() {
		return tier;
	}
	public void setTier(String tier) {
		this.tier = tier;
	}
}
