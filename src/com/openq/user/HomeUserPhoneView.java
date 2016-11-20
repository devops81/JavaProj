package com.openq.user;

public class HomeUserPhoneView {

	private long id;
	private long kolId;
	private long contactFlag;
	private String phone = null;
	private long uniqueId;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    private String type = null;

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        final HomeUserPhoneView that = (HomeUserPhoneView) o;

        if (kolId != that.kolId) return false;
        if (phone != null ? !phone.equals(that.phone) : that.phone != null) return false;
        if (type != null ? !type.equals(that.type) : that.type != null) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = (int) (kolId ^ (kolId >>> 32));
        result = 29 * result + (phone != null ? phone.hashCode() : 0);
        result = 29 * result + (type != null ? type.hashCode() : 0);
        return result;
    }

    public long getId() {
        return id;
    }
	public void setId(long id) {
		this.id = id;
	}
	public long getKolId() {
		return kolId;
	}
	public void setKolId(long kolId) {
		this.kolId = kolId;
	}
	public long getContactFlag() {
		return contactFlag;
	}
	public void setContactFlag(long contactFlag) {
		this.contactFlag = contactFlag;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}

	public long getUniqueId() {
		return uniqueId;
	}

	public void setUniqueId(long uniqueId) {
		this.uniqueId = uniqueId;
	}
}
