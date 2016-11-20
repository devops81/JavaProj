package com.openq.eav;

public class EavConstants {
	public static final int STRING_ID = 1;
	public static final int DATE_ID = 2;
	public static final int NUMBER_ID = 3;
	public static final int BOOLEAN_ID = 4;
	public static final int DROPDOWN_ID = 5;
	public static final int MULTI_SELECT_ID = 6;
  public static final int BINARY_ID = 7;

	public static final long USERS_ID = 11l;
	public static final long INSTITUTION_ENTITY_ID = 12l;
	public static final long PROGRAMS_ID = 13l;
	public static final long VENUES_ENTITY_ID = 14l;
	public static final long KOL_ENTITY_ID = 101l;
	public static final long ORG_PROFILE_TAB_ATTR = 117l;
	/*
	 * TODO ORG_PROFILE_TAB_ATTR and ORG_ENTITY_ID both refer to same constant..just keep one
	 * inserted ORG_ENTITY_ID for dataloader tool
	 */
	public static final long ORG_ENTITY_ID = 117l;

	/*
	 * ORG_PROFILE_CHART_ORG_ID is the attributeId of the ChartOrgId under the Organization_Profile Tab.
	 * This id is being referred by the dataloader tool.
	 */
	public static final long ORG_PROFILE_CHART_ORG_ID = 83291180;
}
