package com.openq.event;

import java.io.Serializable;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.openq.audit.Auditable;
import com.openq.eav.option.OptionLookup;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:43:47 PM
 * To change this template use File | Settings | File Templates.
 */
public class EventEntity implements Serializable, Comparable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] { "approvaldate", "approvers", "attendees", "city",
            "deleteflag", "description", "endDate", "endTime", "event_type", "eventdate", "fundingAmount", "invitedol", "owner",
            "staffids", "startTime", "state", "country" ,"status", "ta", "therapy", "title", "userid" });

    public EventEntity() {}

    private long id;
    private OptionLookup event_type;
    private String owner;
    private long userid;
    private String title;
    private OptionLookup ta;
    private OptionLookup state;
    private String city;
    private OptionLookup country;
    private OptionLookup therapy;
    private String invitedol;
    private String approvers;
    private String staffids;
    private Date eventdate;
    private String description;
    private Date createtime;
    private Date updatetime;
    private String deleteflag;
    private Date reviewdate;
    private Date approvaldate;
    private String status;
    private String fundingAmount;
    private Date endDate;


    public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    private String startTime;
    private String endTime;
    private Set attendees = new HashSet();

    public Set getAttendees() {
        return attendees;
    }

    public void setAttendees(Set attendees) {
        this.attendees = attendees;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public OptionLookup getEvent_type() {
        return event_type;
    }

    public void setEvent_type(OptionLookup event_type) {
        this.event_type = event_type;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public long getUserid() {
        return userid;
    }

    public void setUserid(long userid) {
        this.userid = userid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public OptionLookup getTa() {
        return ta;
    }

    public void setTa(OptionLookup ta) {
        this.ta = ta;
    }

    public OptionLookup getTherapy() {
        return therapy;
    }

    public void setTherapy(OptionLookup therapy) {
        this.therapy = therapy;
    }

    public String getInvitedol() {
        return invitedol;
    }

    public void setInvitedol(String invitedol) {
        this.invitedol = invitedol;
    }

    public String getStaffids() {
        return staffids;
    }

    public void setStaffids(String staffids) {
        this.staffids = staffids;
    }

    public Date getEventdate() {
        return eventdate;
    }

    public void setEventdate(Date eventdate) {
        this.eventdate = eventdate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatetime() {
        return createtime;
    }

    public void setCreatetime(Date createtime) {
        this.createtime = createtime;
    }

    public Date getUpdatetime() {
        return updatetime;
    }

    public void setUpdatetime(Date updatetime) {
        this.updatetime = updatetime;
    }

    public String getDeleteflag() {
        return deleteflag;
    }

    public void setDeleteflag(String deleteflag) {
        this.deleteflag = deleteflag;
    }

	public int compareTo(Object o) {
		return this.eventdate.compareTo(((EventEntity)o).eventdate);
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public OptionLookup getState() {
		return state;
	}

	public void setState(OptionLookup state) {
		this.state = state;
	}
	public Date getApprovaldate() {
		return approvaldate;
	}

	public void setApprovaldate(Date approvaldate) {
		this.approvaldate = approvaldate;
	}

	public String getFundingAmount() {
		return fundingAmount;
	}

	public void setFundingAmount(String fundingAmount) {
		this.fundingAmount = fundingAmount;
	}

	public Date getReviewdate() {
		return reviewdate;
	}

	public void setReviewdate(Date reviewdate) {
		this.reviewdate = reviewdate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getApprovers() {
		return approvers;
	}

	public void setApprovers(String approvers) {
		this.approvers = approvers;
	}

    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }

    public OptionLookup getCountry() {
        return country;
    }

    public void setCountry(OptionLookup country) {
        this.country = country;
    }
}
