package com.openq.eav.metadata;

public class MetadataUtil {
	public static final int BASIC_TYPE_COUNT = 7;
	public static final int ENTITY_TYPE_COUNT = 2;
	public static final String[] supportedTypes = new String[] { "Text",
			"Date", "Number", "Yes/No", "Dropdown", "Multi-Select", "Binary", "Tab",
			"Table" };

	public static String[] getSupportedTypes() {
		return supportedTypes;
	}

	public static String getTypeFromEntityTypeId(int typeId, boolean isList) {
		if (isList)
			return supportedTypes[supportedTypes.length - 1];

		if (typeId <= 6) {
			return supportedTypes[typeId];
		}
		return supportedTypes[supportedTypes.length - 2];
	}
}
