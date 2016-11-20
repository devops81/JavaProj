
package com.openq.kol;

import java.util.ArrayList;
import java.util.HashMap;

/*
 * KOLDAOInterface
 *
 * Feb 18,2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
*/

public interface KOLDAOInterface {
	
	public abstract ArrayList getSegmentTree() throws DataAccessException;
	
	
		
	public abstract boolean deleteExpertsFromSegment(String[] expertIds,int segmentId) throws DataAccessException;
	
	public ArrayList getExpertsForTG(String expertIds) throws DataAccessException;
	
	public abstract ArrayList getExpertsForSegmentId(int segmentId) throws DataAccessException;
	
	public abstract boolean addNode(NodeDTO nodeDTO) throws DataAccessException;
	
	public abstract boolean deleteNode(String[] nodeIds) throws DataAccessException;
	
	
	// methods related to KOL Key Messages
	public ArrayList findKOLKeyMessage(int keyMessageId) throws DataAccessException;
	
	public ArrayList findAllKOLKeyMessage() throws DataAccessException;
	
	public ArrayList insertKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws DataAccessException;
	
	public ArrayList updateKOLKeyMessage(KeyMessageDTO keyMessageDTO) throws DataAccessException;
	
	public ArrayList deleteKOLKeyMessage(String keyMessageIds) throws DataAccessException;
	
	//	methods related to KOL Tactics
	 public ArrayList findTactics(int tacticId) throws DataAccessException;
	
	 public ArrayList findAllTactics(String ta, String fa, String region) throws DataAccessException;
	
	 public ArrayList insertTactic(TacticDTO tacticDTO) throws DataAccessException;
	
	 public ArrayList updateTactic(TacticDTO tacticDTO) throws DataAccessException;
	
	 public ArrayList deleteTactic(String tacticIds, String ta, String fa, String region) throws DataAccessException;
	
	//	methods related to Brand Objectives
	public ArrayList findAllSegmentWithBrandObjectives() throws DataAccessException;
	
	
	// Methods related to Segment Tactics
	
	public TacticDTO findSegementTacticDetail(int segmentTacticId) throws DataAccessException;
	
	public ArrayList findSegementTactics(int segmentId) throws DataAccessException;
	
	public ArrayList insertNUpdateSegmentTactics(int segmentId, TacticDTO segmentTacticDTO, ArrayList segmentTacticList) throws DataAccessException;
	
	public ArrayList deleteSegmentTactics(String segmentTacticIds, int segmentId) throws DataAccessException; 
	
	public ArrayList updateSegmentExpertTactics(int segmentTacticId, int segmentId) throws DataAccessException;
	
		
	
	public boolean addExpertsToSegment(ArrayList expertsInSegement,int segmentId) throws DataAccessException;
	
	public ArrayList getNodesForParentId(int parentId) throws DataAccessException;
	
	public boolean saveStrategy(NodeDTO nodeDTO) throws DataAccessException;
	
	public NodeDTO getSegmentInfoForSegmentId(int segmentId) throws DataAccessException;

	
	public ArrayList getAllMainObjectives() throws DataAccessException;
	
	public ArrayList getAllMainObjectivesOnFilter(String TA,String FA, String region)throws DataAccessException;
	
	public MainObjectiveDTO findMainObjective(int mainObjectiveId) throws DataAccessException;
	
	public void removeMainObjective(String mainObjectiveIds) throws DataAccessException;
	
	public void addMainObjective(MainObjectiveDTO mainObjectiveDTO) throws DataAccessException;
	
	public void saveMainObjective(MainObjectiveDTO mainObjectiveDTO) throws DataAccessException;


	// Methods related to KOL Capability

	public ArrayList findCapability(int capabilityId) throws DataAccessException;
	
	public ArrayList findAllCapabilities(int expertId) throws DataAccessException;
	
	public ArrayList insertCapability(CapabilityDTO capabilityDTO) throws DataAccessException;
	
	public ArrayList updateCapability(CapabilityDTO capabilityDTO) throws DataAccessException;
	
	public ArrayList deleteCapability(String capabilityIds, int expertId) throws DataAccessException;
	
	public ArrayList findKOLTactics(int expertId) throws DataAccessException;
	
	public HashMap findKOLReferenceDetails(String refIds) throws DataAccessException;
	
	public NodeDTO getNodeInfo(int segmentId) throws DataAccessException;
	
	public void saveNodeInfo(NodeDTO nodeDTO) throws DataAccessException;  
	
	public ArrayList getLatestSegmentCriteria(int segmentId) throws DataAccessException;
	
	public abstract ArrayList getSegmentCriteria() throws DataAccessException;

    public HashMap getMatchedTaFaRegion(long userId) throws DataAccessException;

    public ArrayList getMyTacticList(String staffid) throws DataAccessException;

    public boolean  isExists(String planId, long expertId) throws DataAccessException;

}
