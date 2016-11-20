package com.openq.eav.data;

import java.util.Comparator;

import org.apache.log4j.Logger;

import com.openq.eav.scripts.OlConstants;

public class EavTableRowComparator implements Comparator {
	/*
	 * Compares two entity attributes. 
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	private static Logger logger = Logger.getLogger(EavTableRowComparator.class);
	public int compare(Object o1, Object o2) {
		EntityAttribute ea1 = (EntityAttribute) o1;
		EntityAttribute ea2 = (EntityAttribute) o2;
		
		if (ea1.getAttribute().getAttribute_id() ==  OlConstants.KOL_OL_Summary_Education) {
			return compareNumbers(ea1, ea2, OlConstants.KOL_OL_Summary_Education_Beginning_Year);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Industry_Profile_Society_Membership) {
			return compareStrings(ea1, ea2, OlConstants.KOL_Industry_Profile_Society_Membership_Name);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Industry_Profile_Topic_Expertise) {
			return compareStrings(ea1, ea2, OlConstants.KOL_Industry_Profile_Topic_Expertise_Topic_Description);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Industry_Profile_Interest_Description) {
			return compareNumbers(ea2, ea1, OlConstants.KOL_Industry_Profile_Interest_Description_Frequency);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Industry_Profile_Presentations) {
			return compareNumbers(ea1, ea2, OlConstants.KOL_Industry_Profile_Presentations_Date);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science) {
			StringAttribute sa1 = dataService.getStringAttribute(ea1.getMyEntity().getId(), OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Therapy);
			StringAttribute sa2 = dataService.getStringAttribute(ea2.getMyEntity().getId(), OlConstants.KOL_Amgen_Profile_Position_to_Amgen_Science_Therapy);
			
			if (sa1 == null || sa1.getValue() == null || sa2 == null || sa2.getValue() == null || sa1.getValue().equals(sa2.getValue()))
				return (int) (ea1.getId() - ea2.getId());
			
			String s1 = sa1.getValue().trim().equals("Total") ? "a" : sa1.getValue();
			String s2 = sa2.getValue().trim().equals("Total") ? "a" : sa2.getValue();
			
			return s2.compareTo(s1);
		} else if (ea1.getAttribute().getAttribute_id() == OlConstants.KOL_Publications) {
			return compareNumbers(ea2, ea1, OlConstants.KOL_Publications_Pub_Date);
		}
		
		return (int) (ea1.getId() - ea2.getId());
	}

	private int compareStrings(EntityAttribute ea1, EntityAttribute ea2, long attrId) {
		StringAttribute sa1 = dataService.getStringAttribute(ea1.getMyEntity().getId(), attrId);
		StringAttribute sa2 = dataService.getStringAttribute(ea2.getMyEntity().getId(), attrId);
		
		if (sa1 == null || sa1.getValue() == null || sa2 == null || sa2.getValue() == null || sa1.getValue().equals(sa2.getValue()))
			return (int) (ea1.getId() - ea2.getId());
		
		return sa1.getValue().compareTo(sa2.getValue());
	}

	private int compareNumbers(EntityAttribute ea1, EntityAttribute ea2, long attrId) {
		StringAttribute v1 = dataService.getStringAttribute(ea1.getMyEntity().getId(), attrId);
		StringAttribute v2 = dataService.getStringAttribute(ea2.getMyEntity().getId(), attrId);
		
		if (v1 == null || v1.getValue() == null || v2 == null || v2.getValue() == null || v1.getValue().equals(v2.getValue()))
			return (int) (ea1.getId() - ea2.getId());
		
		int x1, x2;
		try {
			x1 = Integer.parseInt(v1.getValue());
		
			x2 = Integer.parseInt(v2.getValue());
		} catch (Exception e) {
			logger.error(e.getLocalizedMessage(), e);
			return v1.getValue().compareTo(v2.getValue());
		}

		return x1 - x2;
	}

	IDataService dataService;

	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}
}
