package com.openq.user;


import java.util.Arrays;
import java.util.Date;
import java.util.List;

import com.openq.audit.Auditable;
import com.openq.eav.option.OptionLookup;
import com.openq.interaction.Interaction;


public class User implements java.io.Serializable, Comparable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "addCity", "addCountry", "addLine1", "addLine2",
            "addState", "addType", "addUse", "addZip", "answer", "areaOfInterest", "bioData", "birthDate", "deleteFlag",
            "division", "dob", "email", "firstName", "gender", "global", "influenceLevel", "kolid", "lastName", "latitude",
            "location", "longitude", "middleName", "motherMaidenName", "mslStartDate", "myRegions", "numberOfPublication",
            "password", "phone", "photo", "position", "prefix", "pubCount", "reference", "securityQuestion", "speciality",
            "sphereOfInf", "ssn", "ssoid", "staffid", "suffix", "Tier", "title", "userName", "userType", "year" });

        public User() {}

        private long id;

        public String getFax() {
            return fax;
        }

        public void setFax(String fax) {
            this.fax = fax;
        }

        String fax;

        private String mobile;

        /**
         * @return the mobile
         */
        public String getMobile() {
            return mobile;
        }

        /**
         * @param mobile the mobile to set
         */
        public void setMobile(String mobile) {
            this.mobile = mobile;
        }

    public String getAreaOfInterest() {
        return areaOfInterest;
    }

    public void setAreaOfInterest(String areaOfInterest) {
        this.areaOfInterest = areaOfInterest;
    }

    String areaOfInterest;

        private OptionLookup   userType;
        private String         ssoid;
        private String         ssname;
        private String         userName;
        private String         password;
        private String         firstName;
        private String         middleName;
        private String         lastName;
        private OptionLookup   prefix;
        private OptionLookup   suffix;
        private Date	       birthDate;
        private String         ssn;
        private String         motherMaidenName;

        private UserAddress    userAddress;

        private String         securityQuestion;
        private String         answer;
        private String         myRegions;
        private String         bioData;
        private String         dob;
        private String         photo;

        private String         email;

        private float longitude;
        private float latitude;
        private long influenceLevel;

        private String reference;
        private String title;
        private Date updateTime;
        private String deleteFlag;

        private String staffid;

        private long kolid;
        private LocationView userLocation;
        private HomeUserView homeUserView;

        private String speciality;

        private String phone;

        private String location;

        private OptionLookup gender;

        private OptionLookup global;
        private String preferredContactType = "";
        private String preferredContactInfo = "";
        private String position;
        private String division;
        private String year;
        private String Tier;
        private String mslOlType;

        private Date mslStartDate;
        private OptionLookup sphereOfInf;
	public OptionLookup getSphereOfInf() {
			return sphereOfInf;
		}

		public void setSphereOfInf(OptionLookup sphereOfInf) {
			this.sphereOfInf = sphereOfInf;
		}
    public String getAddType() {
        return addType;
    }

    public void setAddType(String addType) {
        this.addType = addType;
    }

    public String getAddUse() {
        return addUse;
    }

    public void setAddUse(String addUse) {
        this.addUse = addUse;
    }

    public String getAddLine1() {
        return addLine1;
    }

    public void setAddLine1(String addLine1) {
        this.addLine1 = addLine1;
    }

    public String getAddLine2() {
        return addLine2;
    }

    public void setAddLine2(String addLine2) {
        this.addLine2 = addLine2;
    }

    public String getAddCity() {
        return addCity;
    }

    public void setAddCity(String addCity) {
        this.addCity = addCity;
    }

    public String getAddState() {
        return addState;
    }

    public void setAddState(String addState) {
        this.addState = addState;
    }

    public String getAddZip() {
        return addZip;
    }

    public void setAddZip(String addZip) {
        this.addZip = addZip;
    }

    public String getAddCountry() {
        return addCountry;
    }

    public void setAddCountry(String addCountry) {
        this.addCountry = addCountry;
    }

    private String addType;
        private String addUse;
        private String addLine1;
        private String addLine2;
        private String addCity;
        private String addState;
        private String addZip;
        private String addCountry;

        private Interaction lastInteraction;
        private int pubCount;

    public int getNumberOfPublication() {
        return numberOfPublication;
    }

    public void setNumberOfPublication(int numberOfPublication) {
        this.numberOfPublication = numberOfPublication;
    }

    private int numberOfPublication;

        private long lastUpdateTime;

            public long getLastUpdateTime() {
                return lastUpdateTime;
        }

        public void setLastUpdateTime(long lastUpdateTime) {
            this.lastUpdateTime = lastUpdateTime;
        }


        /**
         * @return the division
         */
        public String getDivision() {
            return division;
        }

        /**
         * @param division the division to set
         */
        public void setDivision(String division) {
            this.division = division;
        }

        /**
         * @return the position
         */
        public String getPosition() {
            return position;
        }

        /**
         * @param position the position to set
         */
        public void setPosition(String position) {
            this.position = position;
        }

        /**
         * @return the year
         */
        public String getYear() {
            return year;
        }

        /**
         * @param year the year to set
         */
        public void setYear(String year) {
            this.year = year;
        }

        public String getPreferredContactType() {
            return preferredContactType;
        }

        public void setPreferredContactType(String preferredContactType) {
            this.preferredContactType = preferredContactType;
        }

        public String getPreferredContactInfo() {
            return preferredContactInfo;
        }

        public void setPreferredContactInfo(String preferredContactInfo) {
            this.preferredContactInfo = preferredContactInfo;
        }

        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public long getKolid() {
            return kolid;
        }

        public void setKolid(long kolid) {
            this.kolid = kolid;
        }


        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }



        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getSpeciality() {
            return speciality;
        }

        public void setSpeciality(String speciality) {
            this.speciality = speciality;
        }

        public String getStaffid() {
            return staffid;
        }

        public void setStaffid(String staffid) {
            this.staffid = staffid;
        }



        public String getAnswer() {
            return answer;
        }

        public void setAnswer(String answer) {
            this.answer = answer;
        }

        public String getBioData() {
            return bioData;
        }

        public void setBioData(String bioData) {
            this.bioData = bioData;
        }

        public Date getBirthDate() {
            return birthDate;
        }

        public void setBirthDate(Date birthDate) {
            this.birthDate = birthDate;
        }

        public String getDob() {
            return dob;
        }

        public void setDob(String dob) {
            this.dob = dob;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }


        public String getFirstName() {
            return firstName;
        }

        public void setFirstName(String firstName) {
            this.firstName = firstName;
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

        public String getMotherMaidenName() {
            return motherMaidenName;
        }

        public void setMotherMaidenName(String motherMaidenName) {
            this.motherMaidenName = motherMaidenName;
        }

        public String getMyRegions() {
            return myRegions;
        }

        public void setMyRegions(String myRegions) {
            this.myRegions = myRegions;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getPhoto() {
            return photo;
        }

        public void setPhoto(String photo) {
            this.photo = photo;
        }


        public String getSecurityQuestion() {
            return securityQuestion;
        }

        public void setSecurityQuestion(String securityQuestion) {
            this.securityQuestion = securityQuestion;
        }

        public String getSsn() {
            return ssn;
        }

        public void setSsn(String ssn) {
            this.ssn = ssn;
        }



        public UserAddress getUserAddress() {
            return userAddress;
        }

        public void setUserAddress(UserAddress userAddress) {
            this.userAddress = userAddress;
        }

        public String getUserName() {
            return userName;
        }

        public void setUserName(String userName) {
            this.userName = userName;
        }

        public float getLatitude() {
            return latitude;
        }

        public void setLatitude(float latitude) {
            this.latitude = latitude;
        }

        public float getLongitude() {
            return longitude;
        }

        public void setLongitude(float longitude) {
            this.longitude = longitude;
        }

        public String getReference() {
            return reference;
        }

        public void setReference(String reference) {
            this.reference = reference;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public long getInfluenceLevel() {
            return influenceLevel;
        }

        public void setInfluenceLevel(long influenceLevel) {
            this.influenceLevel = influenceLevel;
        }


        public void setUserType(OptionLookup userType) {
            this.userType = userType;
        }

        public OptionLookup getUserType() {
            return userType;
        }

        public OptionLookup getGender() {
            return gender;
        }

        public void setGender(OptionLookup gender) {
            this.gender = gender;
        }

        public OptionLookup getGlobal() {
            return global;
        }

        public void setGlobal(OptionLookup global) {
            this.global = global;
        }

        public OptionLookup getPrefix() {
            return prefix;
        }

        public void setPrefix(OptionLookup prefix) {
            this.prefix = prefix;
        }

        public OptionLookup getSuffix() {
            return suffix;
        }

        public void setSuffix(OptionLookup suffix) {
            this.suffix = suffix;
        }

        public String getSsname() {
            return ssname;
        }

        public void setSsname(String ssname) {
            this.ssname = ssname;
        }

        public String getSsoid() {
            return ssoid;
        }

        public void setSsoid(String ssoid) {
            this.ssoid = ssoid;
        }

        public String getDeleteFlag() {
            return deleteFlag;
        }

        public void setDeleteFlag(String deleteFlag) {
            this.deleteFlag = deleteFlag;
        }

        public Date getUpdateTime() {
            return updateTime;
        }

        public void setUpdateTime(Date updateTime) {
            this.updateTime = updateTime;
        }

        public LocationView getUserLocation() {
            return userLocation;
        }

        public void setUserLocation(LocationView userLocation) {
            this.userLocation = userLocation;
        }

        public int compareTo(Object o) {
            return this.lastName.compareTo(((User)o).lastName);
        }

        public HomeUserView getHomeUserView() {
            return homeUserView;
        }

        public void setHomeUserView(HomeUserView homeUserView) {
            this.homeUserView = homeUserView;
        }


        public Interaction getLastInteraction() {
            return lastInteraction;
        }

        public void setLastInteraction(Interaction lastInteraction) {
            this.lastInteraction = lastInteraction;
        }

    public String getVCardText(){
        StringBuffer sb = new StringBuffer();
        sb.append("begin:vcard").append("\n");
        sb.append("n:").append(this.getLastName()).append(", ").append(this.getFirstName()).append("\n");
        sb.append("fn:").append(this.firstName).append(" ").append(this.lastName).append("\n");
        StringBuffer ad = new StringBuffer();
        if ( this.getAddLine1() != null ) ad.append(this.getAddLine1());
        if ( this.getAddLine2() != null ) ad.append(", ").append(this.getAddLine2());
        if ( this.getAddCity() != null ) ad.append(", ").append(this.getAddCity());
        if ( this.getAddState() != null ) ad.append(this.getAddState());
        if(this.getAddZip()!=null) ad.append(this.getAddZip());
        sb.append("ADR;WORK:;;").append(ad).append("\n");
        sb.append("TEL;WORK;VOICE:").append(this.phone).append("\n");
        sb.append("email:").append(this.email!=null?this.email:"").append("\n");
        sb.append("version:3.0").append("\n");
        sb.append("end:vcard").append("\n");
        return sb.toString();
    }

		public int getPubCount() {
			return pubCount;
		}

		public void setPubCount(int pubCount) {
			this.pubCount = pubCount;
		}

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final User user = (User) o;

        if (id != user.id) return false;

        return true;
    }

    public int hashCode() {
        return (int) (id ^ (id >>> 32));
    }

	public String getTier() {
		return Tier;
	}

	public void setTier(String tier) {
		Tier = tier;
	}



	public Date getMslStartDate() {
		return mslStartDate;
	}

	public void setMslStartDate(Date mslStartDate) {
		this.mslStartDate = mslStartDate;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }

	public String getMslOlType() {
		return mslOlType;
	}

	public void setMslOlType(String mslOlType) {
		this.mslOlType = mslOlType;
	}
}
