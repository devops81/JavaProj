package com.openq.eav.scripts;

public interface IAttributeIdGenerator {

	/*
	 * Generates Ids for the entire subtree of an entity. It's in a format that can be 
	 * directly used in a constants file.
	 */
	public void generate(String name, long entityTypeId);

}