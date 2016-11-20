package com.openq.authentication;
import com.openq.eav.option.OptionLookup;
import com.openq.user.User;

/*
 * Contains all the basic Ldap attributes of a user like given name,
 * first name, last name, address, telephone extention.
 */
public class UserDetails implements Comparable,java.io.Serializable{
	
	private String userName;//User Id  or Logon (uid)
	private String passWord;//userpassword
	private String staffId; //uniqueIdentifier
	private String email; //mail
	private String firstName; //givenName
	private String lastName;  //sn
	private String completeName;//cn
	private String telephoneNumber; //telephoneNumber
	private String id ;
	private OptionLookup  userType;
	private String title;

    public String getKolId() {
        return kolId;
    }

    public void setKolId(String kolId) {
        this.kolId = kolId;
    }

    private String kolId;

    public UserDetails() {}

    public UserDetails(User user)
    {
        this.setFirstName(user.getFirstName());
        this.setUserName(user.getUserName());
        this.setPassWord(user.getPassword());
        this.setStaffId(user.getStaffid());
        this.setEmail(user.getEmail());
        this.setLastName(user.getLastName());
        this.setCompleteName(user.getLastName()+", "+user.getFirstName());
        this.setTelephoneNumber(user.getPhone());
        this.setId(new Long(user.getId()).toString());
        this.setUserType(user.getUserType());
        this.setTitle(user.getTitle());
        this.setKolId(new Long(user.getKolid()).toString());
    }

    public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCompleteName() {
		return completeName;
	}
	public void setCompleteName(String completeName) {
		this.completeName = completeName;
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
	public String getPassWord() {
		return passWord;
	}
	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public String getTelephoneNumber() {
		return telephoneNumber;
	}
	public void setTelephoneNumber(String telephoneNumber) {
		this.telephoneNumber = telephoneNumber;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public OptionLookup getUserType() {
		return userType;
	}
	public void setUserType(OptionLookup userType) {
		this.userType = userType;
	}

     public int compareTo(Object o) {
	     return this.lastName.compareTo(((UserDetails)o).lastName);
     }

	
}
