package com.openq.web.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.eav.option.IOptionService;
import com.openq.eav.option.OptionLookup;
import com.openq.kol.KOLManager;
import com.openq.kol.KeyMessageDTO;
import com.openq.kol.MainObjectiveDTO;
import com.openq.kol.MyExpertDTO;
import com.openq.kol.NodeDTO;
import com.openq.kol.SegmentCriteriaDTO;
import com.openq.kol.TacticDTO;
import com.openq.web.ActionKeys;
import com.openq.user.User;
import com.openq.utils.PropertyReader;
import com.openq.eav.data.IDataService;
/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Oct 7, 2006
 * Time: 10:38:01 AM
 * To change this template use File | Settings | File Templates.
 */
public class KolStrategyController extends AbstractController {
     IOptionService strategyStatusOption;
     IDataService dataService;

    protected ModelAndView handleRequestInternal(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {
        HttpSession session = request.getSession();
        String action = (String) request.getParameter("action");
        String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
    	long userGroupId = -1;
    	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
    	 userGroupId = Long.parseLong(userGroupIdString);
        String userId = "";
        if (request.getSession().getAttribute(Constants.CURRENT_USER) != null){
            userId =  (String)session.getAttribute(Constants.USER_ID);
            session.setAttribute("USER_ID",userId);
        }

        OptionLookup  userType = null;
        if (request.getSession().getAttribute(Constants.CURRENT_USER) != null){
            userType =  (OptionLookup)session.getAttribute(Constants.USER_TYPE);

        }
//        session.setAttribute("THERAPEUTIC_AREA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA")));
//        session.setAttribute("FUNCTIONAL_AREA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA")));
//        session.setAttribute("REGION_AREA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION")));

        // cast the bean
        if (ActionKeys.KOL_STRATEGY.equalsIgnoreCase(action)) {
            KOLManager kOLManager = new KOLManager();
            ArrayList nodeTree = kOLManager.getSegmentTree();
            session.setAttribute("HIERARCHY", nodeTree.get(0));
            session.setAttribute("HIERARCHY_MAP", nodeTree.get(1));
            ArrayList segmentCriteriaList = new ArrayList();
            segmentCriteriaList = kOLManager.getSegmentCriteria();

            session.setAttribute("SEGMENT_CRITERIA", segmentCriteriaList);
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());

            session.setAttribute("CURRENT_LINK", "KOL_Strategy");
            session.removeAttribute("segmentlevel");

            int parentId = 0;
            int segmentId = 0;

            if (session.getAttribute("segmentId") != null)
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();


            if (session.getAttribute("parentId") != null)
                parentId = ((Integer) session.getAttribute("parentId")).intValue();

            String parentName = "";
            String segmentLevel = "";

            if (session.getAttribute("parentName") != null)
                parentName = (String) session.getAttribute("parentName");

            if (session.getAttribute("segmentlevel") != null)
                segmentLevel = (String) session.getAttribute("segmentlevel");

            String fromPage = request.getParameter("fromPage");

            if (fromPage != null && "main".equalsIgnoreCase(fromPage)) {
                session.setAttribute("USER_TYPE",String.valueOf(userType.getId()));

                parentId = 0;
                session.setAttribute("parentId", new Integer(parentId));
                String rootnode = null;
                if (request.getParameter("rootnode") != null) {
                    rootnode = (String) request.getParameter("rootnode");
                    request.getSession().setAttribute("rootnode", request.getParameter("rootnode"));
                }
                KOLManager kolManager = new KOLManager();
                ArrayList nodesForParentIdList = new ArrayList();
                nodesForParentIdList = kolManager.getNodesForParentId(parentId);
                request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

                parentName = "Root Node";
                session.setAttribute("parentName", parentName);

                session.setAttribute("parentId", new Integer(parentId));
                session.setAttribute("SHOW_ONLY_CREATE_NODE", "showonlycreatenode");
                session.setAttribute("segmentId", new Integer(0));

            } else if (segmentId != 0) {
                KOLManager kolManager = new KOLManager();
                ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
                request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);

                ArrayList nodesForParentIdList = new ArrayList();
                nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
                request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);
            
                NodeDTO nodeDTO = new NodeDTO();
                nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
                request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);
                session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
                if ((parentId == 0) && (segmentId == 0)) {
                    session.setAttribute("SHOW_ONLY_CREATE_NODE", "showonlycreatenode");
                    parentName = "Root Node";
                } else {
                    session.setAttribute("SHOW_ONLY_CREATE_NODE", "showallnodes");
                }

                String ta = request.getParameter("filterTa");
                String fa = request.getParameter("filterFa");
                String region = request.getParameter("filterRegion");

                session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

                session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
                //session.setAttribute("CURRENT_LINK","setSegmentation");

                if ((segmentLevel != null) && (segmentLevel.equals("last"))) {

                    // session.setAttribute("CURRENT_LINK","setSegmentation");

                    ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

                    session.setAttribute("SEGMENT_TACTICS", result.get(0));
                    session.setAttribute("APPLIED_TACTIC", result.get(1));
                    session.setAttribute("segmentlevel", "last");
                } else {
                    //session.setAttribute("CURRENT_LINK","createNode");
                }
            }


            session.setAttribute("SHOW_ONLY_CREATE_NODE", "showallnodes");
            session.setAttribute("THERAPEUTIC", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("FUNCTIONAL", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
            session.setAttribute("RA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));
            /*session.removeAttribute("THERAPEUTIC_AREA");
               session.removeAttribute("FUNCTIONAL_AREA");
               session.removeAttribute("REGION_AREA");*/

            //session.setAttribute("USER_TYPE",userType.getId());
            return new ModelAndView("kolstrategy_home");



        } else if (ActionKeys.KOL_SEGMENT_TREE.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "setSegmentation");
            return new ModelAndView("kolstrategy_home");
        } else if (ActionKeys.KOL_MAIN_OBJECTIVES.equalsIgnoreCase(action)) {
            //session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
            session.removeAttribute("THERAPEUTIC_AREA");
            session.removeAttribute("FUNCTIONAL_AREA");
            session.removeAttribute("REGION_AREA");
            String ta = null;
            if (null != request.getParameter("therapeuticArea")){
                ta = request.getParameter("therapeuticArea");
            }

            String fa = null;
            if (null != request.getParameter("functionalArea")){
                fa =  request.getParameter("functionalArea");
            }

            String region = null;
            if (null != request.getParameter("regionArea")){
                region = request.getParameter("regionArea");
            }

            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));
            session.setAttribute("CURRENT_LINK", "MainObjectives");

            session.setAttribute("TA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("FA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
            session.setAttribute("REGION", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));

//            session.removeAttribute("THERAPEUTIC_AREA");
//            session.removeAttribute("FUNCTIONAL_AREA");
//            session.removeAttribute("REGION_AREA");

            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.ADD_MAIN_OBJECTIVE.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "MainObjectives");
            KOLManager kolManager = new KOLManager();
            MainObjectiveDTO mainObjectiveDTO = new MainObjectiveDTO();

            mainObjectiveDTO.setMainObjective(request.getParameter("mainObjective"));
            mainObjectiveDTO.setDescription(request.getParameter("description"));

            mainObjectiveDTO.setTA(request.getParameter("TA"));
            mainObjectiveDTO.setFA(request.getParameter("FA"));
            mainObjectiveDTO.setRegion(request.getParameter("region"));

            kolManager.addMainObjective(mainObjectiveDTO);

            String ta = null;
            if (null != request.getParameter("TA")){
                ta = request.getParameter("TA");
            }

            String fa = null;
            if (null != request.getParameter("FA")){
                fa =  request.getParameter("FA");
            }

            String region = null;
            if (null != request.getParameter("region")){
                region = request.getParameter("region");
            }
            session.setAttribute("THERAPEUTIC_AREA",ta);
            session.setAttribute("FUNCTIONAL_AREA",fa);
            session.setAttribute("REGION_AREA",region);

            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));

            //session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
            session.setAttribute("MESSAGE", "Main Objective(s) added  successfully.");
            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.SAVE_MAIN_OBJECTIVE.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "MainObjectives");

            KOLManager kolManager = new KOLManager();
            MainObjectiveDTO mainObjectiveDTO = new MainObjectiveDTO();

            mainObjectiveDTO.setId(Integer.parseInt(request.getParameter("mainObjectiveId")));
            mainObjectiveDTO.setMainObjective(request.getParameter("mainObjective"));
            mainObjectiveDTO.setDescription(request.getParameter("description"));
            mainObjectiveDTO.setTA(request.getParameter("TA"));
            mainObjectiveDTO.setFA(request.getParameter("FA"));
            mainObjectiveDTO.setRegion(request.getParameter("region"));


            kolManager.saveMainObjective(mainObjectiveDTO);
            //session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
            String ta = null;
            if (null != request.getParameter("TA")){
                ta = request.getParameter("TA");
            }

            String fa = null;
            if (null != request.getParameter("FA")){
                fa =  request.getParameter("FA");
            }

            String region = null;
            if (null != request.getParameter("region")){
                region = request.getParameter("region");
            }
            session.setAttribute("THERAPEUTIC_AREA",ta);
            session.setAttribute("FUNCTIONAL_AREA",fa);
            session.setAttribute("REGION_AREA",region);
            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));

            session.setAttribute("MESSAGE", "Main Objective(s) updated successfully.");

            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.VIEW_MAIN_OBJECTIVE.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "MainObjectives");

             String ta = null;
             if (null != request.getParameter("TA")){
                 ta = request.getParameter("TA");
             }

             String fa = null;
             if (null != request.getParameter("FA")){
                 fa =  request.getParameter("FA");
             }

             String region = null;
             if (null != request.getParameter("region")){
                 region = request.getParameter("region");
             }
             session.setAttribute("THERAPEUTIC_AREA",ta);
             session.setAttribute("FUNCTIONAL_AREA",fa);
             session.setAttribute("REGION_AREA",region);

             session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));
            //session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());

            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.EDIT_MAIN_OBJECTIVE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "MainObjectives");

            int mainObjectiveId = Integer.parseInt(request.getParameter("mainObjectiveId"));

            MainObjectiveDTO result = new KOLManager().getMainObjective(mainObjectiveId);

            session.setAttribute("SEL_MAIN_OBJECTIVE", result);
            //session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
            String ta = null;
            if (null != request.getParameter("therapeuticArea")){
                ta = request.getParameter("therapeuticArea");
            }

            String fa = null;
            if (null != request.getParameter("functionalArea")){
                fa =  request.getParameter("functionalArea");
            }

            String region = null;
            if (null != request.getParameter("regionArea")){
                region = request.getParameter("regionArea");
            }
            session.setAttribute("THERAPEUTIC_AREA",ta);
             session.setAttribute("FUNCTIONAL_AREA",fa);
             session.setAttribute("REGION_AREA",region);

            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));
            session.setAttribute("SHOW", "edit");

            return new ModelAndView("kol_main_objectives");

        } else if (ActionKeys.DELETE_MAIN_OBJECTIVE.equalsIgnoreCase(action)) {

            KOLManager kolManager = new KOLManager();

            session.setAttribute("CURRENT_LINK", "MainObjectives");


            String mainObjectiveIds[] = request.getParameterValues("mainObjectiveId");
            if (mainObjectiveIds != null && mainObjectiveIds.length > 0) {
                StringBuffer sbMainObjectiveIds = new StringBuffer();
                for (int i = 0; i < mainObjectiveIds.length; ++i) {
                    if (sbMainObjectiveIds.length() > 0)
                        sbMainObjectiveIds.append(",").append(mainObjectiveIds[i]);
                    else
                        sbMainObjectiveIds.append(mainObjectiveIds[i]);
                }


                kolManager.removeMainObjective(sbMainObjectiveIds.toString());

              //  session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
                String ta = null;
                if (null != request.getParameter("therapeuticArea")){
                    ta = request.getParameter("therapeuticArea");
                }

                String fa = null;
                if (null != request.getParameter("functionalArea")){
                    fa =  request.getParameter("functionalArea");
                }

                String region = null;
                if (null != request.getParameter("regionArea")){
                    region = request.getParameter("regionArea");
                }
                session.setAttribute("THERAPEUTIC_AREA",ta);
                 session.setAttribute("FUNCTIONAL_AREA",fa);
                 session.setAttribute("REGION_AREA",region);

                session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));
                session.setAttribute("MESSAGE", "Main Objective(s) deleted successfully.");
            }

            return new ModelAndView("kol_main_objectives");
        } else if (ActionKeys.KOL_MAIN_OBJECTIVES_ON_FILTER.equalsIgnoreCase(action)){
            String ta = null;
            if (null != request.getParameter("therapeuticArea")){
                ta = request.getParameter("therapeuticArea");
            }

            String fa = null;
            if (null != request.getParameter("functionalArea")){
                fa =  request.getParameter("functionalArea");
            }

            String region = null;
            if (null != request.getParameter("regionArea")){
                region = request.getParameter("regionArea");
            }
            session.setAttribute("THERAPEUTIC_AREA",ta);
            session.setAttribute("FUNCTIONAL_AREA",fa);
            session.setAttribute("REGION_AREA",region);
            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));

            session.setAttribute("CURRENT_LINK", "MainObjectives");
            return new ModelAndView("kol_main_objectives");

        }else if (ActionKeys.KOL_NEW_NODE_PAGE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "createNode");

            int parentId = 0;
            int segmentId = 0;

            session.setAttribute("CURRENT_LINK", "createNode");
            if (session.getAttribute("segmentId") != null) {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            if (session.getAttribute("parentId") != null) {
                parentId = ((Integer) session.getAttribute("parentId")).intValue();
            }

            String parentName = "";
            String segmentLevel = "";

            if (session.getAttribute("parentName") != null) {
                parentName = (String) session.getAttribute("parentName");
            }

            if (session.getAttribute("segmentlevel") != null) {
                segmentLevel = (String) session.getAttribute("segmentlevel");
            }

            KOLManager kolManager = new KOLManager();

            // to get the list of segments
            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            if (segmentId != 0) {

                ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
                request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);

                NodeDTO nodeDTO = new NodeDTO();
                nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
                request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);

                String ta = nodeDTO.getTaId();
                String fa = nodeDTO.getFaId();
                String region = nodeDTO.getRegionId();
                session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta, fa, region));
                if ((parentId == 0) && (segmentId == 0)) {
                    session.setAttribute("SHOW_ONLY_CREATE_NODE", "showonlycreatenode");
                    parentName = "Root Node";
                } else {
                     session.setAttribute("SHOW_ONLY_CREATE_NODE", "showallnodes");
                }
                session.removeAttribute("THERAPEUTIC_AREA");
                session.removeAttribute("FUNCTIONAL_AREA");
                session.removeAttribute("REGION_AREA");
                session.setAttribute("THERAPEUTIC", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
                session.setAttribute("FUNCTIONAL", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
                session.setAttribute("RA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));
                session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
                session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
                session.setAttribute("CURRENT_LINK", "setSegmentation");

                if ((segmentLevel != null) && (segmentLevel.equals("last"))) {

                    session.setAttribute("CURRENT_LINK", "setSegmentation");

                    ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);
                   
                    session.setAttribute("SEGMENT_TACTICS", result.get(0));
                    session.setAttribute("APPLIED_TACTIC", result.get(1));
                    session.setAttribute("segmentlevel", "last");
                   return new ModelAndView("kol_setsegment");
                } else {
                    session.setAttribute("CURRENT_LINK", "createNode");
                    return new ModelAndView("kol_create_node");
                }
            }
            return new ModelAndView("kol_create_node");

        } else if (ActionKeys.KOL_ADD_NEW_NODE.equalsIgnoreCase(action)) {
            NodeDTO nodeDTO = new NodeDTO();
            int segmentId = 0;
            int parentId = 0;
            String strategyLevel = null;
            String rootNode = null;
            String parentName = null;
            String description = null;
            String createdBy = null;
            String ta = null;
            String fa = null;
            String region = null;

            /*if (request.getSession().getAttribute(Constants.CURRENT_USER) != null){
                   nodeDTO.setCreatedBy((String)session.getAttribute(Constants.USER_ID));
				
               }*/

            if (session.getAttribute("segmentId")!=null)
            {
                segmentId = ((Integer)session.getAttribute("segmentId")).intValue();
            }
            if (session.getAttribute("parentId")!=null)
            {
                parentId = ((Integer)session.getAttribute("parentId")).intValue();
            }
            if (session.getAttribute("rootnode")!=null)
            {
                rootNode = (String)session.getAttribute("rootnode");
            }

            nodeDTO.setSegmentId(segmentId);

            if ((rootNode != null) && (rootNode.equals("true"))) {
                nodeDTO.setParentId(0);
             }
            else {
                nodeDTO.setParentId(segmentId);
            }


            if (request.getParameter("parentName") != null)
            {
             parentName = (String)request.getParameter("parentName");
             nodeDTO.setParentName(parentName);
            }
            if (request.getParameter("description") != null)
            {
                description = (String)request.getParameter("description");
                nodeDTO.setDescription (description);
            }

            nodeDTO.setCreatedBy(userId);
            if (request.getParameter("strategyLevel") != null)
            {
             strategyLevel = (String)request.getParameter("strategyLevel");
            }
            nodeDTO.setStrategyLevel(strategyLevel);
            if (request.getParameter("ta") != null )
            {
             ta = (String)request.getParameter("ta");
             nodeDTO.setTaId(ta);
            }
            if (request.getParameter("fa") != null)
            {
             fa = (String)request.getParameter("fa");
             nodeDTO.setFaId(fa);
            }
            if (request.getParameter("region") != null)
            {
             region = (String)request.getParameter("region");
             nodeDTO.setRegionId(region);
            }
            KOLManager kolManager = new KOLManager();
            kolManager.addNode(nodeDTO);
            ArrayList nodeTree = kolManager.getSegmentTree();
            session.setAttribute("HIERARCHY",nodeTree.get(0));
            session.setAttribute("HIERARCHY_MAP",nodeTree.get(1));

            // to get the list of segments
            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID",nodesForParentIdList);

            session.setAttribute("THERAPEUTIC_AREA",ta);
            session.setAttribute("FUNCTIONAL_AREA",fa);
            session.setAttribute("REGION_AREA",region);


        // return new ModelAndView("kolstrategy_home");
           return new ModelAndView("forward:kolstrategy_home.htm?action="+ActionKeys.KOL_STRATEGY);


        } else if (ActionKeys.KOL_DELETE_NODE.equalsIgnoreCase(action)) {
            String nodeIds[] = request.getParameterValues("NodeId");
            KOLManager kolManager = new KOLManager();
            kolManager.deleteNode(nodeIds);
            ArrayList nodeTree = kolManager.getSegmentTree();
            session.setAttribute("HIERARCHY", nodeTree.get(0));
            session.setAttribute("HIERARCHY_MAP", nodeTree.get(1));

            // to get the list of segments
            int segmentId = 0;
            if (session.getAttribute("segmentId") != null) {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);


            return new ModelAndView("forward:kolstrategy_home.htm?action="+ActionKeys.KOL_STRATEGY);

        } else if (ActionKeys.KOL_EDIT_NODE.equalsIgnoreCase(action)) {


            int segmentId = Integer.parseInt(request.getParameter("segmentId"));
            NodeDTO nodeDTO = new KOLManager().getNodeInfo(segmentId);
            int parentId = 0;
            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            }


            KOLManager kolManager = new KOLManager();
            ArrayList nodeTree = kolManager.getSegmentTree();
            session.setAttribute("HIERARCHY", nodeTree.get(0));
            session.setAttribute("HIERARCHY_MAP", nodeTree.get(1));

            session.setAttribute("EDIT_NODE_INFO", nodeDTO);
            session.setAttribute("CURRENT_LINK", "createNode");
            session.setAttribute("NODES_FOR_PARENT_ID", new KOLManager().getNodesForParentId(parentId));

            return new ModelAndView("kol_create_node");

        } else if (ActionKeys.KOL_SAVE_NODE.equalsIgnoreCase(action)) {

            int parentId = 0;
            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            }

            KOLManager kolManager = new KOLManager();
            NodeDTO nodeDTO = new NodeDTO();

            nodeDTO.setSegmentId(Integer.parseInt(request.getParameter("segmentId")));
            nodeDTO.setParentName(request.getParameter("parentName"));
            nodeDTO.setDescription(request.getParameter("description"));
            nodeDTO.setTaId(request.getParameter("ta"));
            nodeDTO.setFaId(request.getParameter("fa"));
            nodeDTO.setRegionId(request.getParameter("region"));

            kolManager.saveNodeInfo(nodeDTO);
            session.setAttribute("CURRENT_LINK", "createNode");
            session.setAttribute("NODES_FOR_PARENT_ID", new KOLManager().getNodesForParentId(parentId));
            return new ModelAndView("forward:kolstrategy_home.htm?action="+ActionKeys.KOL_STRATEGY);
            //return new ModelAndView("kol_create_node");

        } else if (ActionKeys.KOL_VIEW_NODE.equalsIgnoreCase(action)) {
            int parentId = 0;
            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            }
            session.setAttribute("CURRENT_LINK", "createNode");
            session.setAttribute("NODES_FOR_PARENT_ID", new KOLManager().getNodesForParentId(parentId));

            return new ModelAndView("kol_create_node");

        } else if (ActionKeys.KOL_TACTICS.equalsIgnoreCase(action)) {

            session.removeAttribute("FILTER_TA");
            session.removeAttribute("FILTER_FA");
            session.removeAttribute("FILTER_REGION");

            session.removeAttribute("SEL_TA");
            session.removeAttribute("SEL_FA");
            session.removeAttribute("SEL_REGION");

            session.setAttribute("TA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("FA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
            session.setAttribute("REGION", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));

            session.setAttribute("CURRENT_LINK", "tactics");
            // session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics());
            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.VIEW_TACTICS.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "tactics");

            String ta = request.getParameter("filterTa");
            String fa = request.getParameter("filterFa");
            String region = request.getParameter("filterRegion");

            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

            session.setAttribute("FILTER_TA", ta);
            session.setAttribute("FILTER_FA", fa);
            session.setAttribute("FILTER_REGION", region);

            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.ADD_TACTIC.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "tactics");

            KOLManager kolManager = new KOLManager();
            TacticDTO tacticDTO = new TacticDTO();

            tacticDTO.setTacticName(request.getParameter("tacticName"));
            /*
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            String tacticDate = request.getParameter("tacticDate");

            if (tacticDate != null && tacticDate.length() > 0) {
                tacticDTO.setTacticDate(tacticDate);
            }
            */

            tacticDTO.setTacticDetail(request.getParameter("tacticDetails") != null ? request.getParameter("tacticDetails").trim() : "");
            tacticDTO.setFA(request.getParameter("fa"));
            tacticDTO.setTA(request.getParameter("ta"));
            tacticDTO.setRegion(request.getParameter("region"));
            tacticDTO.setObjective(request.getParameter("objective"));

            session.setAttribute("FILTER_TA", request.getParameter("ta"));
            session.setAttribute("FILTER_FA", request.getParameter("fa"));
            session.setAttribute("FILTER_REGION", request.getParameter("region"));

            // adds a new Tactic
            ArrayList result = kolManager.addTactic(tacticDTO);

            //session.setAttribute("KOL_TACTICS", result.get(1));
              String ta = request.getParameter("ta");
              String fa = request.getParameter("fa");
              String region = request.getParameter("region");
              session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

            int errorCode = Integer.parseInt((String) result.get(0));

            if (errorCode == 0)
                session.setAttribute("MESSAGE", "New Tactic added successfully.");
            else
                session.setAttribute("MESSAGE", "Error in adding New Tactic.");

            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.EDIT_TACTIC.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "tactics");

            int tacticId = Integer.parseInt(request.getParameter("tacticId"));

            ArrayList result = new KOLManager().getTactic(tacticId);

            session.setAttribute("SEL_TACTIC", result.get(0));




            //session.setAttribute("KOL_TACTICS", result.get(1));

            session.setAttribute("SHOW", "edit");

            String ta = null;
            if (null != request.getParameter("ta")){
                ta = request.getParameter("ta");
            }
            if (null != request.getParameter("filterTa") && ta.equalsIgnoreCase("-1")) {
                ta = request.getParameter("filterTa");
            }

            String fa = null;
            if (null != request.getParameter("fa")){
                fa =  request.getParameter("fa");
            }
            if (null != request.getParameter("filterFa") && fa.equalsIgnoreCase("-1")) {
                fa = request.getParameter("filterFa");
            }

            String region = null;
            if (null != request.getParameter("region")) {
                region = request.getParameter("region");
            }
            if (null != request.getParameter("filterRegion") && region.equalsIgnoreCase("-1")) {
                region = request.getParameter("filterRegion");
            }

            session.setAttribute("OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta, fa, region));
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.SAVE_TACTIC.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "tactics");

            KOLManager kolManager = new KOLManager();
            TacticDTO tacticDTO = new TacticDTO();

            tacticDTO.setTacticId(Integer.parseInt(request.getParameter("selTacticId")));
            tacticDTO.setTacticName(request.getParameter("tacticName"));

            /*
            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            String tacticDate = request.getParameter("tacticDate");
            
            if (tacticDate != null && tacticDate.length() > 0) {
                tacticDTO.setTacticDate(tacticDate);
            }
            */
            tacticDTO.setTacticDetail(request.getParameter("tacticDetails") != null ? request.getParameter("tacticDetails").trim() : "");
            tacticDTO.setFA(request.getParameter("fa"));
            tacticDTO.setTA(request.getParameter("ta"));
            tacticDTO.setRegion(request.getParameter("region"));
            tacticDTO.setObjective(request.getParameter("objective"));

            session.setAttribute("FILTER_TA", request.getParameter("ta"));
            session.setAttribute("FILTER_FA", request.getParameter("fa"));
            session.setAttribute("FILTER_REGION", request.getParameter("region"));

            //	updates the selected Tactic
            ArrayList result = kolManager.saveTactic(tacticDTO);

            String ta = request.getParameter("ta");
            String fa = request.getParameter("fa");
            String region = request.getParameter("region");

            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

//            session.setAttribute("KOL_TACTICS", result.get(1));
            session.setAttribute("MESSAGE", "Tactic updated successfully.");

            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.DELETE_TACTIC.equalsIgnoreCase(action)) {

            KOLManager kolManager = new KOLManager();

            session.setAttribute("CURRENT_LINK", "tactics");

            String ta = null;
            if (request.getParameter("filterTa") != null) {
                ta = request.getParameter("filterTa");
            }
            String fa = null;
            if (request.getParameter("filterFa") != null) {
                fa = request.getParameter("filterFa");
            }
            String region = null;
            if (request.getParameter("filterRegion") != null) {
                region = request.getParameter("filterRegion");
            }

            // pass the selected Tactic Ids as a comma separated String value
            String tacticIds[] = request.getParameterValues("tacticId");
            if (tacticIds != null && tacticIds.length > 0) {
                StringBuffer sbTacticIds = new StringBuffer();
                for (int i = 0; i < tacticIds.length; ++i) {
                    if (sbTacticIds.length() > 0)
                        sbTacticIds.append(",").append(tacticIds[i]);
                    else
                        sbTacticIds.append(tacticIds[i]);
                }

                // deletes selected Tactics
                ArrayList result = kolManager.removeTactic(sbTacticIds.toString(), ta, fa, region);

                session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

              //  session.setAttribute("KOL_TACTICS", result.get(1));
                session.setAttribute("MESSAGE", "Tactic(s) deleted successfully.");
            }

            return new ModelAndView("kol_tactics");
        } else if (ActionKeys.APPLY_SEGMENT_TACTIC.equalsIgnoreCase(action))
        {

            int parentId  = 0;
            int segmentId  = 0;

            int segmentTacticId = 0;

            if(request.getParameter("segmentTacticId") != null)
                segmentTacticId = Integer.parseInt(request.getParameter("segmentTacticId"));

            if(request.getParameter("parentId")!=null){
                parentId = Integer.parseInt(request.getParameter("parentId"));
            } else {
                parentId = ((Integer) session.getAttribute("parentId")).intValue();
            }

            if(request.getParameter("segmentId")!=null){
                segmentId = Integer.parseInt(request.getParameter("segmentId"));
            } else {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            session.setAttribute("segmentId",new Integer(segmentId));
            session.setAttribute("parentId",new Integer(parentId));

            KOLManager kolManager = new KOLManager();

            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT",expertsForSegmentList);

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID",nodesForParentIdList);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID",nodeDTO);

            session.setAttribute("CURRENT_LINK","setSegmentation");
            session.setAttribute("segmentlevel", "last");


            // applies selected Tactics to the segment under selection.

            ArrayList result = kolManager.applySegmentTactic(segmentTacticId, segmentId, Integer.parseInt(userId));

            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            session.setAttribute("SEGMENT_TACTICS", result.get(1));

            int errorCode = Integer.parseInt((String) result.get(0));

            if(errorCode == 0) {
                session.setAttribute("MESSAGE", "Segment Tactic applied successfully.");
                session.setAttribute("APPLIED_TACTIC", segmentTacticId+"");
            }

             return new ModelAndView("kol_setsegment");

        } else if (ActionKeys.GET_OBJECTIVES.equalsIgnoreCase(action)){

            String ta = null;
            if (null != request.getParameter("ta")){
                ta = request.getParameter("ta");
            }

            String fa = null;
            if (null != request.getParameter("fa")){
                fa =  request.getParameter("fa");
            }

            String region = null;
            if (null != request.getParameter("region")){
                region = request.getParameter("region");
            }

            session.setAttribute("SEL_TA", ta);
            session.setAttribute("SEL_FA", fa);
            session.setAttribute("SEL_REGION", region);

            session.setAttribute("OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta,fa,region));
            session.setAttribute("CURRENT_LINK", "tactics");

            return new ModelAndView("kol_tactics");

        } else if (ActionKeys.KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "keyMessage");
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.VIEW_KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "keyMessage");
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());

            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.ADD_KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "keyMessage");

            KOLManager kolManager = new KOLManager();
            KeyMessageDTO keyMsgDTO = new KeyMessageDTO();

            keyMsgDTO.setKeyMessageName(request.getParameter("keyMsgName"));
            keyMsgDTO.setMarketClaims(request.getParameter("marketClaims"));

            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            String keyMsgDate = request.getParameter("keyMsgDate");

            if (keyMsgDate != null && keyMsgDate.length() > 0) {
                keyMsgDTO.setKeyMessageDate(keyMsgDate);
            }

            keyMsgDTO.setMarketClaimsDesc(request.getParameter("marketClaimsDesc") != null ? request.getParameter("marketClaimsDesc").trim() : "");

            // adds a new KOL Key Message
            ArrayList result = kolManager.addKOLKeyMessage(keyMsgDTO);

            session.setAttribute("KOL_KEY_MESSAGE", result.get(1));
            int errorCode = Integer.parseInt((String) result.get(0));

            if (errorCode == 0)
                session.setAttribute("MESSAGE", "New Key Message added successfully.");
            else
                session.setAttribute("MESSAGE", "Error in adding New Key Message.");

            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.EDIT_KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "keyMessage");

            int keyMsgId = Integer.parseInt(request.getParameter("keyMsgId"));

            ArrayList result = new KOLManager().getKOLKeyMessage(keyMsgId);

            session.setAttribute("SEL_KOL_KEY_MESSAGE", result.get(0));
            session.setAttribute("KOL_KEY_MESSAGE", result.get(1));

            session.setAttribute("SHOW", "edit");

            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.SAVE_KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {

            session.setAttribute("CURRENT_LINK", "keyMessage");

            KOLManager kolManager = new KOLManager();
            KeyMessageDTO keyMsgDTO = new KeyMessageDTO();

            keyMsgDTO.setKeyMessageId(Integer.parseInt(request.getParameter("selKeyMsgId")));
            keyMsgDTO.setKeyMessageName(request.getParameter("keyMsgName"));
            keyMsgDTO.setMarketClaims(request.getParameter("marketClaims"));

            SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
            String keyMsgDate = request.getParameter("keyMsgDate");

            if (keyMsgDate != null && keyMsgDate.length() > 0) {
                keyMsgDTO.setKeyMessageDate(keyMsgDate);
            }

            keyMsgDTO.setMarketClaimsDesc(request.getParameter("marketClaimsDesc") != null ? request.getParameter("marketClaimsDesc").trim() : "");

            //	updates the selected KOL Key Messages
            ArrayList result = kolManager.saveKOLKeyMessage(keyMsgDTO);

            session.setAttribute("KOL_KEY_MESSAGE", result.get(1));
            session.setAttribute("MESSAGE", "Key Message updated successfully.");

            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.DELETE_KOL_KEY_MESSAGE.equalsIgnoreCase(action)) {

            KOLManager kolManager = new KOLManager();

            session.setAttribute("CURRENT_LINK", "keyMessage");

            // pass the selected KOL Key Message Ids as a comma separated String value
            String keyMsgIds[] = request.getParameterValues("keyMessageId");
            if (keyMsgIds != null && keyMsgIds.length > 0) {
                StringBuffer msgIds = new StringBuffer();
                for (int i = 0; i < keyMsgIds.length; ++i) {
                    if (msgIds.length() > 0)
                        msgIds.append(",").append(keyMsgIds[i]);
                    else
                        msgIds.append(keyMsgIds[i]);
                }

                // deletes selected KOL Key Messages
                ArrayList result = kolManager.removeKOLKeyMessage(msgIds.toString());

                session.setAttribute("KOL_KEY_MESSAGE", result.get(1));
                session.setAttribute("MESSAGE", "Key Message(s) deleted successfully.");
            }

            return new ModelAndView("kol_keymessages");

        } else if (ActionKeys.KOL_BRAND_OBJECTIVES.equalsIgnoreCase(action)) {
            session.setAttribute("CURRENT_LINK", "brandObjectives");

            KOLManager kolManager = new KOLManager();
            session.setAttribute("SEGMENT_OBJECTIVE", kolManager.getAllSegmentWithObjectives());
            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());
            return new ModelAndView("kol_brand_objectives");

        } else if (ActionKeys.KOL_SHOW_DATA_FOR_ROOTNODE.equalsIgnoreCase(action)) {

            int parentId = 0;
            session.setAttribute("parentId", new Integer(parentId));
            String rootnode = null;
            if (request.getParameter("rootnode") != null) {
                rootnode = (String) request.getParameter("rootnode");
                request.getSession().setAttribute("rootnode", request.getParameter("rootnode"));
            }
            KOLManager kolManager = new KOLManager();
            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(parentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            String parentName = "Root Node";
            session.setAttribute("parentName", parentName);

            session.setAttribute("CURRENT_LINK", "createNode");
            session.setAttribute("parentId", new Integer(parentId));
            session.setAttribute("SHOW_ONLY_CREATE_NODE", "showonlycreatenode");
            session.setAttribute("USER_TYPE",String.valueOf(userType.getId()));

            session.setAttribute("THERAPEUTIC", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("FUNCTIONAL", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
            session.setAttribute("RA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));


            return new ModelAndView("kol_create_node");

        } else if (ActionKeys.KOL_SAVE_STRATEGY.equalsIgnoreCase(action)) {
            KOLManager kolManager = new KOLManager();
            NodeDTO nodeDTO = new NodeDTO();
            if (request.getParameter("strategyDesc") != null) {
                nodeDTO.setStatedStrategy(request.getParameter("strategyDesc"));
            }
            if (request.getParameter("objectiveDesc") != null) {
                nodeDTO.setSegmentObjective(request.getParameter("objectiveDesc"));
            }
            StringBuffer keyMessage = new StringBuffer();
            if (request.getParameterValues("keyMessages") != null) {
                String[] keyMsgs = request.getParameterValues("keyMessages");
                for (int i = 0; i < keyMsgs.length; i++) {
                    if (i == 0) {
                        keyMessage.append(keyMsgs[i]);
                    } else {
                        keyMessage.append("," + keyMsgs[i]);
                    }
                }
            }
            StringBuffer mainObjectivesBuffer = new StringBuffer();
            if (request.getParameterValues("mainObjectives") != null) {
                String[] mainObjectives = request.getParameterValues("mainObjectives");
                for (int i = 0; i < mainObjectives.length; i++) {
                    if (i == 0) {
                        mainObjectivesBuffer.append(mainObjectives[i]);
                    } else {
                        mainObjectivesBuffer.append("," + mainObjectives[i]);
                    }
                }
            }
            if (request.getParameter("segmentstatus") != null) {
                nodeDTO.setStrategyStatus(request.getParameter("segmentstatus"));
            }

            nodeDTO.setKeyMessages(keyMessage.toString());
            nodeDTO.setSegmentObjective(mainObjectivesBuffer.toString());
            int segmentId = 0;
            if (session.getAttribute("segmentId") != null) {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }
            nodeDTO.setSegmentId(segmentId);
            boolean saveStrategyFlag = kolManager.saveStrategy(nodeDTO);
            if (saveStrategyFlag == true) {
                request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", kolManager.getSegmentInfoForSegmentId(segmentId));
            }
            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", getExpSegList(expertsForSegmentList));

            String ta = null;
            if (null != session.getAttribute("TA") ){
              ta = (String)session.getAttribute("TA");
            }
            String fa = null;
            if (null != session.getAttribute("FA") ){
              fa = (String)session.getAttribute("FA");
            }
            String region = null;
            if (null != session.getAttribute("REGION") ){
              region = (String)session.getAttribute("REGION");
            }

            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

            session.setAttribute("SEGMENT_TACTICS", result.get(0));
            session.setAttribute("APPLIED_TACTIC", result.get(1));
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");

            return new ModelAndView("kol_setsegment");
        } else if (ActionKeys.KOL_SHOW_DATA_FOR_TREE.equalsIgnoreCase(action)) {
            int parentId = 0;
            int segmentId = 0;
            session.setAttribute("SEGMENT_ROLE", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("ROLE"), userGroupId));
            session.setAttribute("THERAPEUTIC", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("THERAPEUTIC_AREA"), userGroupId));
            session.setAttribute("FUNCTIONAL", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("FUNCTIONAL_AREA"), userGroupId));
            session.setAttribute("RA", strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("REGION"), userGroupId));

            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
                request.getSession().setAttribute("parentId", request.getParameter("parentId"));
            }
            session.removeAttribute("rootnode");

            if (request.getParameter("segmentId") != null) {
                segmentId = Integer.parseInt(request.getParameter("segmentId"));
                request.getSession().setAttribute("segmentId", request.getParameter("segmentId"));
            }

            String segmentLevel = null;
            if (request.getParameter("segmentlevel") != null) {
                segmentLevel = (String) request.getParameter("segmentlevel");
            }

            String parentName = null;
            if (request.getParameter("parentName") != null) {
                parentName = (String) request.getParameter("parentName");
            }

            session.setAttribute("segmentId", new Integer(segmentId));
            session.setAttribute("parentId", new Integer(parentId));

            KOLManager kolManager = new KOLManager();
            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", getExpSegList(expertsForSegmentList));

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);

            session.setAttribute("TA_NAME", nodeDTO.getTaName());
            session.setAttribute("FA_NAME", nodeDTO.getFaName());
            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            
            session.setAttribute("TA",ta);
            session.setAttribute("FA",fa);
            session.setAttribute("REGION",region);
            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectivesOnFilter(ta, fa, region));
            if ((parentId == 0) && (segmentId == 0)) {
                session.setAttribute("SHOW_ONLY_CREATE_NODE", "showonlycreatenode");
                parentName = "Root Node";
            } else {
                session.setAttribute("SHOW_ONLY_CREATE_NODE", "showallnodes");
            }

            session.setAttribute("parentName", parentName);
            session.setAttribute("PNAME", parentName);
            session.setAttribute("segmentlevel", segmentLevel);

            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("LATEST_CRITERIA_LIST", new KOLManager().getLatestSegmentCriteria(segmentId));
            session.setAttribute("STRATEGY_STATUS_LIST",strategyStatusOption.getValuesForOption(PropertyReader.getLOVConstantValueFor("STRATEGY_STATUS"), userGroupId));


            if ((segmentLevel != null) && (segmentLevel.equals("last"))) {

                session.setAttribute("CURRENT_LINK", "setSegmentation");

               ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

                session.setAttribute("SEGMENT_TACTICS", result.get(0));
                session.setAttribute("APPLIED_TACTIC", result.get(1));
                session.setAttribute("segmentlevel", "last");

                return new ModelAndView("kol_setsegment");
            } else {
                session.setAttribute("CURRENT_LINK", "createNode");
                return new ModelAndView("kol_create_node");
            }
        } else if (ActionKeys.KOL_SET_SEGMENT.equalsIgnoreCase(action)) {
            KOLManager kOLManager = new KOLManager();
            if (session.getAttribute("SEGMENT_CRITERIA") == null) {
                ArrayList segmentCriteriaList = new ArrayList();
                segmentCriteriaList = kOLManager.getSegmentCriteria();
                session.setAttribute("SEGMENT_CRITERIA", segmentCriteriaList);
            }
            if (session.getAttribute("KOL_KEY_MESSAGE") == null) {
                session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            }
            session.setAttribute("MAIN_OBJECTIVES", new KOLManager().getAllMainObjectives());

            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");

            return new ModelAndView("kol_setsegment");

        } else if (ActionKeys.KOL_ADD_EXPERTS.equalsIgnoreCase(action)) {

            //session.removeAttribute("fromKOLStrategy");
            String fromStrategy = null;
            if (null != request.getParameter("fromKOLStrategy")){
                fromStrategy = request.getParameter("fromKOLStrategy");
                session.setAttribute("fromKOLStrategy",fromStrategy);
            }

            KOLManager kolManager = new KOLManager();
            ArrayList expertsList = new ArrayList();
            String[] strExpertIds = null;
            if (request.getParameter("checkIds") != null) {
                strExpertIds = request.getParameterValues("checkIds");
            }
            for (int i = 0; i < strExpertIds.length; i++) {
                MyExpertDTO expertDTO = new MyExpertDTO();
                expertDTO.setExpertId(Integer.parseInt(strExpertIds[i]));
                expertsList.add(expertDTO);
            }
            int segmentId = 0;
            if (session.getAttribute("segmentId") != null) {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            boolean addExpertsFlag = kolManager.addExpertsToSegment(expertsList, segmentId);
            //if (addExpertsFlag==true){
            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
           // request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);
            //}
            //////////To display add/edit tactics button
          /*  ArrayList segExpList = new ArrayList();
            expertsForSegmentList = segExpList;*/
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", getExpSegList(expertsForSegmentList));

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

            session.setAttribute("SEGMENT_TACTICS", result.get(0));
            session.setAttribute("APPLIED_TACTIC", result.get(1));
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            session.setAttribute("CURRENT_LINK", "KOL_STRATEGY");
            session.setAttribute("segmentlevel", "last");
            ///////////
            session.setAttribute("LATEST_CRITERIA_LIST", new KOLManager().getLatestSegmentCriteria(segmentId));

            session.setAttribute("segId", segmentId + "");

            return new ModelAndView("kolstrategy_home");

        } else if (ActionKeys.KOL_DELETE_EXPERT.equalsIgnoreCase(action)) {
            int segmentId = 0;
            if (session.getAttribute("segmentId") != null) {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }
            String expertIds[] = request.getParameterValues("checkExpertIds");
            ArrayList segmentCriteria = populateSegmentCriteria(request);
            KOLManager kOLManager = new KOLManager();
            ArrayList expertsInSegment = kOLManager.deleteExpertsFromSegment(expertIds, segmentCriteria, segmentId);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kOLManager.getSegmentInfoForSegmentId(segmentId);

            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

            session.setAttribute("SEGMENT_TACTICS", result.get(0));
            session.setAttribute("APPLIED_TACTIC", result.get(1));
            session.setAttribute("KOL_KEY_MESSAGE", new KOLManager().getAllKOLKeyMessage());
            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");

            if (expertsInSegment == null) {
                 return new ModelAndView("kol_setsegment");
            } else {
                request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsInSegment);
                return new ModelAndView("kol_setsegment");
            }
        } else if (ActionKeys.ADD_SEGMENT_TACTIC.equalsIgnoreCase(action)) {

           // session.setAttribute("SEGMENT_ROLE", strategyStatusOption.getValuesForOption(44));

            int parentId = 0;
            int segmentId = 0;

            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            } else {
                parentId = ((Integer) session.getAttribute("parentId")).intValue();
            }

            if (request.getParameter("segmentId") != null) {
                segmentId = Integer.parseInt(request.getParameter("segmentId"));
            } else {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            session.setAttribute("segmentId", new Integer(segmentId));
            session.setAttribute("parentId", new Integer(parentId));

            KOLManager kolManager = new KOLManager();

            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);

            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");


            String[] segmentTacticIds = request.getParameterValues("segmentTacticIds");
            String[] activityIds = request.getParameterValues("activityId");
            String[] tacticIds = request.getParameterValues("tacticList");
          //  String[] tacticYears = request.getParameterValues("tacticYear");
           // String[] tacticQuarters = request.getParameterValues("tacticQuarter");
            String[] tacticRoles = request.getParameterValues("tacticRole");
            String[] tacticDueDates = request.getParameterValues("tacticDueDate");
            //String[] tacticRegions = request.getParameterValues("tacticRegion");
            //String[] tacticBudgets = request.getParameterValues("tacticBudget");

            String newActivityId = (request.getParameter("newActivityId") != null && request.getParameter("newActivityId").length() > 0) ? request.getParameter("newActivityId").trim() : null;
            String newTacticId = request.getParameter("newTacticList") != null && request.getParameter("newTacticList").length() > 0 ? request.getParameter("newTacticList").trim() : null;
            //String newTacticYear = request.getParameter("newTacticYear") != null && request.getParameter("newTacticYear").length() > 0 ? request.getParameter("newTacticYear").trim() : null;
            //String newTacticQuarter = request.getParameter("newTacticQuarter") != null && request.getParameter("newTacticQuarter").length() > 0 ? request.getParameter("newTacticQuarter").trim() : null;
            String newTacticRole = request.getParameter("newTacticRole") != null && request.getParameter("newTacticRole").length() > 0 ? request.getParameter("newTacticRole").trim() : null;
            String newTacticDueDate = request.getParameter("newTacticDueDate") != null && request.getParameter("newTacticDueDate").length() > 0 ? request.getParameter("newTacticDueDate").trim() : null ;
            //String newTacticRegion = request.getParameter("newTacticRegion") != null && request.getParameter("newTacticRegion").length() > 0 ? request.getParameter("newTacticRegion").trim() : null;
            //String newTacticBudget = request.getParameter("newTacticBudget") != null && request.getParameter("newTacticBudget").length() > 0 ? request.getParameter("newTacticBudget").trim() : null;

            TacticDTO newSegmentTacticDTO = null;
            TacticDTO segmentTacticDTO = null;

            if (newTacticId != null && newTacticRole != null  && newTacticDueDate != null  ) {

                newSegmentTacticDTO = new TacticDTO();

                newSegmentTacticDTO.setSegmentId(segmentId);
                newSegmentTacticDTO.setTacticId(Integer.parseInt(newTacticId));
                //newSegmentTacticDTO.setQuarter(newTacticQuarter);
                newSegmentTacticDTO.setRole(newTacticRole);
                //newSegmentTacticDTO.setRegion(newTacticRegion);
                //newSegmentTacticDTO.setBudget(newTacticBudget);
                 newSegmentTacticDTO.setTacticDueDate(newTacticDueDate);

            }

            ArrayList segmentTacticList = new ArrayList();

            if (segmentTacticIds != null) {

                for (int i = 0; i < segmentTacticIds.length; i++) {

                    segmentTacticDTO = new TacticDTO();

                    segmentTacticDTO.setSegmentTacticId(Integer.parseInt(segmentTacticIds[i]));
                    segmentTacticDTO.setSegmentId(segmentId);
                    segmentTacticDTO.setTacticId(Integer.parseInt(tacticIds[i]));
                    //segmentTacticDTO.setQuarter(tacticQuarters[i]);
                    segmentTacticDTO.setRole(tacticRoles[i]);
                    //segmentTacticDTO.setRegion(tacticRegions[i]);
                    //segmentTacticDTO.setBudget(tacticBudgets[i]);
                     segmentTacticDTO.setTacticDueDate(tacticDueDates[i]);

                     segmentTacticList.add(segmentTacticDTO);
                }
            }

            ArrayList result = kolManager.addNSaveSegmentTactic(segmentId, newSegmentTacticDTO, segmentTacticList);

            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));

            session.setAttribute("SEGMENT_TACTICS", result.get(1));
            session.setAttribute("APPLIED_TACTIC", result.get(2));

            int errorCode = Integer.parseInt((String) result.get(0));

            if (errorCode == 0)
                session.setAttribute("MESSAGE", "Segment Tactic(s) saved successfully.");
            else
                session.setAttribute("MESSAGE", "Segment Tactic(s) save error.");

            return new ModelAndView("kol_setsegment");

        } else if (ActionKeys.VIEW_SEGMENT_TACTIC.equalsIgnoreCase(action)) {

            int parentId = 0;
            int segmentId = 0;

            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            } else {
                parentId = ((Integer) session.getAttribute("parentId")).intValue();
            }

            if (request.getParameter("segmentId") != null) {
                segmentId = Integer.parseInt(request.getParameter("segmentId"));
            } else {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            session.setAttribute("segmentId", new Integer(segmentId));
            session.setAttribute("parentId", new Integer(parentId));

            KOLManager kolManager = new KOLManager();

            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);

            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");

            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            ArrayList result = new KOLManager().getAllSegmentTactics(segmentId);

            session.setAttribute("SEGMENT_TACTICS", result.get(0));
            session.setAttribute("APPLIED_TACTIC", result.get(1));

            return new ModelAndView("kol_setsegment");
        } else if (ActionKeys.DELETE_SEGMENT_TACTIC.equalsIgnoreCase(action)) {

            int parentId = 0;
            int segmentId = 0;

            if (request.getParameter("parentId") != null) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            } else {
                parentId = ((Integer) session.getAttribute("parentId")).intValue();
            }

            if (request.getParameter("segmentId") != null) {
                segmentId = Integer.parseInt(request.getParameter("segmentId"));
            } else {
                segmentId = ((Integer) session.getAttribute("segmentId")).intValue();
            }

            session.setAttribute("segmentId", new Integer(segmentId));
            session.setAttribute("parentId", new Integer(parentId));

            KOLManager kolManager = new KOLManager();

            ArrayList expertsForSegmentList = kolManager.getExpertsForSegmentId(segmentId);
            request.getSession().setAttribute("EXPERTS_IN_SEGMENT", expertsForSegmentList);

            ArrayList nodesForParentIdList = new ArrayList();
            nodesForParentIdList = kolManager.getNodesForParentId(segmentId);
            request.getSession().setAttribute("NODES_FOR_PARENT_ID", nodesForParentIdList);

            NodeDTO nodeDTO = new NodeDTO();
            nodeDTO = kolManager.getSegmentInfoForSegmentId(segmentId);
            request.getSession().setAttribute("SEGMENTINFO_FOR_SEGMENTID", nodeDTO);

            session.setAttribute("CURRENT_LINK", "setSegmentation");
            session.setAttribute("segmentlevel", "last");

            String segmentTacticId = request.getParameter("segmentTacticId");

            // deletes selected Segment Tactics

            ArrayList result = kolManager.removeSegmentTactic(segmentTacticId, segmentId);

            String ta = nodeDTO.getTaId();
            String fa = nodeDTO.getFaId();
            String region = nodeDTO.getRegionId();
            session.setAttribute("KOL_TACTICS", new KOLManager().getAllTactics(ta, fa, region));
            session.setAttribute("SEGMENT_TACTICS", result.get(1));
            session.setAttribute("APPLIED_TACTIC", result.get(2));

            session.setAttribute("MESSAGE", "Segment Tactic deleted successfully.");

            return new ModelAndView("kol_setsegment");

        }
        return null;
    }

    /*protected Object formBackingObject(HttpServletRequest request) throws ServletException {
        NodeForm nodeForm = new NodeForm();
        nodeForm.setDescription("Some Description");
        return nodeForm;
    }*/

    public ArrayList populateSegmentCriteria(HttpServletRequest request) {
        ArrayList segmentCriteria = new ArrayList();
        String [] atributetype = null;
        String [] atributevalue = null;
        String [] attributeIds = null;
        if (request.getParameterValues("attributename") != null) {
            attributeIds = (String[]) request.getParameterValues("attributename");
        }

        if (request.getParameterValues("attributetype") != null) {
            atributetype = (String[]) request.getParameterValues("attributetype");
        }
        if (request.getParameterValues("attributevalue") != null) {
            atributevalue = (String[]) request.getParameterValues("attributevalue");
        }
        if (attributeIds != null && attributeIds.length > 0) {
            for (int i = 0; i < attributeIds.length; i++) {
                SegmentCriteriaDTO segmentCriteriaDTO = new SegmentCriteriaDTO();
                // The following code is used to seperate the
                // concatenated passed segmentCriteriaId and segmentCriteriaDatatype
                int indexOfPlus = attributeIds[i].indexOf("+");
                int attributeId = Integer.parseInt(attributeIds[i].substring(0, indexOfPlus));
                String attributeDataType = attributeIds[i].substring(indexOfPlus + 1, attributeIds[i].length());
                segmentCriteriaDTO.setAttributeId(attributeId);
                segmentCriteriaDTO.setAttributeDataType(attributeDataType);
                segmentCriteriaDTO.setCondition(atributetype[i]);
                segmentCriteriaDTO.setValue(atributevalue[i]);
                segmentCriteria.add(segmentCriteriaDTO);
            }
        }
        return segmentCriteria;
    }

    public IOptionService getStrategyStatusOption() {
        return strategyStatusOption;
    }

    public void setStrategyStatusOption(IOptionService strategyStatusOption) {
        this.strategyStatusOption = strategyStatusOption;
    }
    public IDataService getDataService() {
        return dataService;
    }

    public void setDataService(IDataService dataService) {
        this.dataService = dataService;
    }

    private ArrayList getExpSegList(ArrayList expertsForSegmentList) {
        ArrayList segExpList = new ArrayList();
        if (expertsForSegmentList != null && !expertsForSegmentList.isEmpty()) {
            User[] user = new User[expertsForSegmentList.size()];
            MyExpertDTO dto = null;
            for (int m = 0; m < expertsForSegmentList.size(); m++) {
                dto = (MyExpertDTO) expertsForSegmentList.get(m);
                user[m] = new User();
                user[m].setId(dto.getExpertId());
                user[m].setPhone(dto.getPhone());
                user[m].setFirstName(dto.getFirstName());
                user[m].setLastName(dto.getLastName());
                if (null != dto.getKolId()) {
                    user[m].setKolid(Long.parseLong(dto.getKolId()));
                }
            }

            User[] resultUsr = dataService.getAttrVals(user);
            if (resultUsr != null && resultUsr.length > 0) {

                MyExpertDTO expertDTO = null;
                User userObj = null;
                for (int u = 0; u < resultUsr.length; u++) {
                    userObj = resultUsr[u];
                    expertDTO = new MyExpertDTO();
                    expertDTO.setExpertId(userObj.getId());
                    expertDTO.setFirstName(userObj.getFirstName());
                    expertDTO.setLastName(userObj.getLastName());
                    expertDTO.setSpeciality(userObj.getSpeciality());
                    expertDTO.setLocation(userObj.getLocation());
                    expertDTO.setPhone(userObj.getPhone());
                    expertDTO.setKolId(String.valueOf(userObj.getKolid()));
                    expertDTO.setExpertName(userObj.getLastName() + ", " + userObj.getFirstName());
                    segExpList.add(expertDTO);

                }
            }
        }
        return segExpList;
    }


}
