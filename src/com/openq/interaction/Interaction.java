package com.openq.interaction;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.openq.audit.Auditable;
import com.openq.eav.option.OptionLookup;
import com.openq.interactionData.InteractionData;

public class Interaction implements Serializable, Auditable {

    private static final List auditableFields = Arrays.asList(new String[] {"attendeeCount", "attendees", "deleteFlag",
            "groupId", "interactionData", "interactionDate", "kolIdArr", "attendeeCount",
            "region", "type", "reportLevelId", "staffId", "supervisorId", "ta", "territoryId", "userId" });

    public Interaction(){}

    private long id;

    private OptionLookup type; 
    
    private Date interactionDate;

    private long userId;

    private Date createTime;

    private Date updateTime;

    private String deleteFlag;

    private long staffId;

    private long ta;

    private long supervisorId;
    
    private long groupId;
    
    private long territoryId;
    
    private long reportLevelId;
    
    private long attendeeCount;
    
    private String[] kolIdArr;
    
    private Set attendees = new HashSet();
    
    private Set interactionData = new HashSet();

    /**
     * This method will return an array of interaction data
     * sorted by the interaction id.
     * @param type
     * @return
     */
    public InteractionData[] getInteractionDataArrayOnType(String type) {
    	Set topicSet = null;
    	topicSet = null != getInteractionData() ? getInteractionData(): new HashSet();
    	List interactionDataList = new ArrayList();
    	if (topicSet != null && topicSet.size() > 0) {
    		InteractionData interactionData = new InteractionData();
			Iterator itr = topicSet.iterator();
			while (itr.hasNext()) {
				interactionData = (InteractionData) itr.next();
				if (interactionData.getType().equalsIgnoreCase(type)){
					interactionDataList.add(interactionData);
				}
			}
    		if(interactionDataList.size() > 0){
    			InteractionData[] interactionDataArray = (InteractionData[]) interactionDataList
    			.toArray(new InteractionData[interactionDataList.size()]);
    			
    			Arrays.sort(interactionDataArray);
    			return interactionDataArray;
    		}
    	}
    	return null;
    }
    public Boolean isFieldAuditable(String field) {
        return new Boolean(auditableFields.contains(field));
    }
	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}
	/**
	 * @return the interactionDate
	 */
	public Date getInteractionDate() {
		return interactionDate;
	}
	/**
	 * @param interactionDate the interactionDate to set
	 */
	public void setInteractionDate(Date interactionDate) {
		this.interactionDate = interactionDate;
	}
	/**
	 * @return the userId
	 */
	public long getUserId() {
		return userId;
	}
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(long userId) {
		this.userId = userId;
	}
	/**
	 * @return the createTime
	 */
	public Date getCreateTime() {
		return createTime;
	}
	/**
	 * @param createTime the createTime to set
	 */
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	/**
	 * @return the updateTime
	 */
	public Date getUpdateTime() {
		return updateTime;
	}
	/**
	 * @param updateTime the updateTime to set
	 */
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	/**
	 * @return the deleteFlag
	 */
	public String getDeleteFlag() {
		return deleteFlag;
	}
	/**
	 * @param deleteFlag the deleteFlag to set
	 */
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	/**
	 * @return the staffId
	 */
	public long getStaffId() {
		return staffId;
	}
	/**
	 * @param staffId the staffId to set
	 */
	public void setStaffId(long staffId) {
		this.staffId = staffId;
	}
	/**
	 * @return the ta
	 */
	public long getTa() {
		return ta;
	}
	/**
	 * @param ta the ta to set
	 */
	public void setTa(long ta) {
		this.ta = ta;
	}
	/**
	 * @return the supervisorId
	 */
	public long getSupervisorId() {
		return supervisorId;
	}
	/**
	 * @param supervisorId the supervisorId to set
	 */
	public void setSupervisorId(long supervisorId) {
		this.supervisorId = supervisorId;
	}
	/**
	 * @return the groupId
	 */
	public long getGroupId() {
		return groupId;
	}
	/**
	 * @param groupId the groupId to set
	 */
	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}
	/**
	 * @return the territoryId
	 */
	public long getTerritoryId() {
		return territoryId;
	}
	/**
	 * @param territoryId the territoryId to set
	 */
	public void setTerritoryId(long territoryId) {
		this.territoryId = territoryId;
	}
	/**
	 * @return the reportLevelId
	 */
	public long getReportLevelId() {
		return reportLevelId;
	}
	/**
	 * @param reportLevelId the reportLevelId to set
	 */
	public void setReportLevelId(long reportLevelId) {
		this.reportLevelId = reportLevelId;
	}
	/**
	 * @return the kolIdArr
	 */
	public String[] getKolIdArr() {
		return kolIdArr;
	}
	/**
	 * @param kolIdArr the kolIdArr to set
	 */
	public void setKolIdArr(String[] kolIdArr) {
		this.kolIdArr = kolIdArr;
	}
	/**
	 * @return the attendees
	 */
	public Set getAttendees() {
		return attendees;
	}
	/**
	 * @param attendees the attendees to set
	 */
	public void setAttendees(Set attendees) {
		this.attendees = attendees;
	}
	/**
	 * @return the interactionData
	 */
	public Set getInteractionData() {
		return interactionData;
	}
	/**
	 * @param interactionData the interactionData to set
	 */
	public void setInteractionData(Set interactionData) {
		this.interactionData = interactionData;
	}
	/**
	 * @return the type
	 */
	public OptionLookup getType() {
		return type;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(OptionLookup type) {
		this.type = type;
	}
	/**
	 * @return the attendeeCount
	 */
	public long getAttendeeCount() {
		return attendeeCount;
	}
	/**
	 * @param attendeeCount the attendeeCount to set
	 */
	public void setAttendeeCount(long attendeeCount) {
		this.attendeeCount = attendeeCount;
	}
}
