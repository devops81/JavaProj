package com.openq.eav.trials;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import net.sf.hibernate.HibernateException;

import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.eav.data.BooleanAttribute;
import com.openq.eav.data.Entity;
import com.openq.eav.data.EntityAttribute;
import com.openq.eav.data.IDataService;
import com.openq.eav.data.StringAttribute;
import com.openq.eav.option.IOptionService;

/**
 * This class is used to maintain clinical trials data in the EAV-based database
 * 
 * @author Amit
 */
public class TrialService extends HibernateDaoSupport implements ITrialService {

	IOptionService optionService;
	IDataService dataService;
	
	/**
	 * Get the trial object with the specified id
	 */
	public ClinicalTrials getTrialWithId(long trialId) {
		return loadTrialData(trialId);
	}
	
	/**
	 * Delete all trials whose ids are provided
	 */
	public void deleteTrials(String[] trialIds) {
		for(int i=0; i<trialIds.length; i++) {
			Entity e = dataService.getEntity(Long.parseLong(trialIds[i]));
			e.setDeleteFlag("Y");
			dataService.updateEntity(e);
		}
	}
	
	/**
	 * Search for all trials matching the specified search criteria
	 */
	public ClinicalTrials[] searchTrialAdv(HashMap parameters) {
		List trials = new ArrayList();
		
		HashSet trialInfoMatchSet = getTrialInfoMatchResults(parameters); 
		HashSet genentechCompoundMatchSet = getGenentechCompoundMatchResults(parameters);
		HashSet investigationDetailsMatchSet = getInvestigationDetailsMatchResults(parameters);
		HashSet instituteMatchSet = getTrialsMatchingInstituteCriteria(parameters);
		
		HashSet finalSet = null;
		
		System.out.println("Trial Info : " + (trialInfoMatchSet != null? "" + trialInfoMatchSet.size() : "None") + 
				" Genentech Compound : " + (genentechCompoundMatchSet != null ? "" + genentechCompoundMatchSet.size() : "None") + 
				" Investigation Details : " + (investigationDetailsMatchSet != null? "" + investigationDetailsMatchSet.size() : " None"));
		
		// first find an intersection of trialInfoMatchSet and genentechCompoundMatchSet
		finalSet = getIntersectionIgnoringNullSet(trialInfoMatchSet, genentechCompoundMatchSet);
		
		System.out.println("Intersection between trial info and genentech compound gave : " + (finalSet != null? "" + finalSet.size() : "None"));
		
		// now find an intersection with investigationDetailsMatchSet
		finalSet = getIntersectionIgnoringNullSet(finalSet, investigationDetailsMatchSet);
		
		System.out.println("Intersection between final set and investigation details gave : " + (finalSet != null? "" + finalSet.size() : "None"));
		
		// now find an intersection with instituteMatchSet
		finalSet = getIntersectionIgnoringNullSet(finalSet, instituteMatchSet);
		
		System.out.println("Intersection between final set and institution details gave : " + (finalSet != null? "" + finalSet.size() : "None"));
		            
		if((finalSet != null) && (finalSet.size() > 0)) {
		    System.out.println("Need to load " + finalSet.size() + " trials");
		            	
		    Iterator iter = finalSet.iterator();
		    while(iter.hasNext()) {
		        trials.add(loadTrialData(Long.parseLong((String)iter.next())));
		        System.out.println("Loaded a trial...");
		    }
		}
		
		return (ClinicalTrials[]) trials.toArray(new ClinicalTrials[trials.size()]);
	}
	
	/**
	 * Return the set of trial ids that match the search criteria specified for all fields under trial info tab.
	 * Returns null if no criteria under "Trial Info" is specified
	 * 
	 * @param parameters
	 * @return
	 */
	private HashSet getTrialInfoMatchResults(HashMap parameters) {
		HashSet finalSet = null;
		
		if (parameters != null && parameters.size() > 0) {
			Long key = null;
	        String value = null;
	        StringBuffer query = new StringBuffer();
	        StringBuffer query1 = new StringBuffer();
	        StringBuffer query2 = new StringBuffer();
			int counter = 0;
            int count = 0;
            
            Set keys = parameters.keySet();
            Iterator itr = keys.iterator();
            
            while (itr.hasNext()) {
                key = (Long) itr.next();
                value = (String) parameters.get(key);
                if ((key.longValue() == TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID) ||
                		(key.longValue() == TrialsConstants.TRIAL_TUMOUR_TYPE_ATTRIB_ID) ||
                		(key.longValue() == TrialsConstants.TRIAL_GENENTECH_INVESTIGATOR_ID_ATTRIB_ID) ||
                		(key.longValue() == TrialsConstants.TRIAL_LICENSE_NUMBER_ATTRIB_ID)){
	                if (counter > 0) {
	                    query1.append(", StringAttribute sa" + counter);
	                    query.append(" and upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
	                    count = counter;
	                    count--;
	                    query2.append(" and sa" + count + ".parent=" + "sa" + counter + ".parent");
	                } else {
	                    query1.append("from StringAttribute sa" + counter);
	                    query.append(" where upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
	                }
	                counter++;
                }
                else if (key.longValue() == TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID) {
                	if(counter > 0) {
                		query1.append(", StringAttribute sa" + counter);
                		count = counter;
	                    count--;
                		query2.append(" and sa" + count + ".parent=" + "sa" + counter + ".parent");
                	}
                	else {
                		query1.append("from StringAttribute sa" + counter);
                	}
                	
                	// We will need to iterate over all comma separated values
                	StringTokenizer st = new StringTokenizer(value, ",");
                	int localCount = 0;
                	while(st.hasMoreTokens()) {
                		String moleculeValue = st.nextToken();
                		if ((counter > 0) || (localCount >0)){
    	                    query.append(" and upper(sa" + counter + ".value) like upper('%" + moleculeValue + "%') and sa" + counter + ".attribute=" + key);
    	                } else {
    	                    query.append(" where upper(sa" + counter + ".value) like upper('%" + moleculeValue + "%') and sa" + counter + ".attribute=" + key);
    	                }
                		localCount++;
                	}
                	
                	counter++;
                }
            }
            
            // check if we got any valid search criteria
            if(query1.length() > 0) {
	            String searchQuery = "select sa0 " + query1.append(query).append(query2).toString();
	
	            System.out.println("Using query : " + searchQuery);
	            
	            finalSet = new HashSet();
	            
	            // Find the list of String Attributes matching the given criteria
				List result = getHibernateTemplate().find(searchQuery);
				
				System.out.println("Got : " + result.size() + " trials");
				
				StringAttribute[] stringAttribute = (StringAttribute[]) result.toArray(new StringAttribute[result.size()]);
				if(stringAttribute != null && stringAttribute.length>0) {
		            HashSet resultSet = new HashSet();
		            for(int a=0;a<stringAttribute.length;a++) {
		            	StringAttribute stringAttr = stringAttribute[a];
						Entity entity = stringAttr.getParent();
						long entityId = entity.getId();
						entity = dataService.getEntity(entityId);
		
						System.out.println("Parsing parent : " + a);
						resultSet = parseParents(entity, entityId, resultSet);
		                finalSet.addAll(resultSet);
		            }
				}
            }
		}
		
		return finalSet;
	}
	
	/**
	 * Return the set of trial ids that match the search criteria specified for the compound field.
	 * Returns null if no such criteria is specified
	 * 
	 * @param parameters
	 * @return
	 */
	private HashSet getGenentechCompoundMatchResults(HashMap parameters) {
		HashSet finalSet = null;
		
		if (parameters != null && parameters.size() > 0) {
			Long key = new Long(TrialsConstants.TRIAL_IS_GENENTECH_COMPOUND_ATTRIB_ID);
            if(parameters.get(key) != null) {
            	String value = (String) parameters.get(key);
            	String searchQuery = "from BooleanAttribute ba where ba.value = " + value + " and ba.attribute = " + key;  
	
	            System.out.println("Using query : " + searchQuery);
	            
	            finalSet = new HashSet();
	            
	            // Find the list of BinaryAttributes matching the given criteria
				List result = getHibernateTemplate().find(searchQuery);
				
				System.out.println("Got : " + result.size() + " trials");
				
				BooleanAttribute[] booleanAttribute = (BooleanAttribute[]) result.toArray(new BooleanAttribute[result.size()]);
				if(booleanAttribute != null && booleanAttribute.length>0) {
		            HashSet resultSet = new HashSet();
		            for(int a=0;a<booleanAttribute.length;a++) {
		            	BooleanAttribute booleanAttr = booleanAttribute[a];
						Entity entity = booleanAttr.getParent();
						long entityId = entity.getId();
						entity = dataService.getEntity(entityId);
		
						resultSet = parseParents(entity, entityId, resultSet);
		                finalSet.addAll(resultSet);
		            }
				}
            }
		}
		
		return finalSet;
	}
	
	/**
	 * Return the set of trial ids that match the search criteria specified for all fields under Investigation Details tab.
	 * Returns null if no criteria under "Investigation Details" is specified
	 * 
	 * @param parameters
	 * @return
	 */
	private HashSet getInvestigationDetailsMatchResults(HashMap parameters) {
		HashSet finalSet = null;
		
		if (parameters != null && parameters.size() > 0) {
			Long key = null;
	        String value = null;
	        StringBuffer query = new StringBuffer();
	        StringBuffer query1 = new StringBuffer();
	        StringBuffer query2 = new StringBuffer();
			int counter = 0;
            int count = 0;
            
            Set keys = parameters.keySet();
            Iterator itr = keys.iterator();
            
            while (itr.hasNext()) {
                key = (Long) itr.next();
                value = (String) parameters.get(key);
                if (key.longValue() == TrialsConstants.TRIAL_INVESTIGATION_INVESTIGATOR_ATTRIB_ID) {
	                if (counter > 0) {
	                    query1.append(", StringAttribute sa" + counter);
	                    query.append(" and upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
	                    count = counter;
	                    count--;
	                    query2.append(" and sa" + count + ".parent=" + "sa" + counter + ".parent");
	                } else {
	                    query1.append("from StringAttribute sa" + counter);
	                    query.append(" where upper(sa" + counter + ".value) like upper('%" + value + "%') and sa" + counter + ".attribute=" + key);
	                }
	                counter++;
                }
            }
            
            // check if we got any valid search criteria
            if(query1.length() > 0) {
	            String searchQuery = "select sa0 " + query1.append(query).append(query2).toString();
	
	            System.out.println("Using query : " + searchQuery);
	            
	            finalSet = new HashSet();
	            
	            // Find the list of String Attributes matching the given criteria
				List result = getHibernateTemplate().find(searchQuery);
				
				System.out.println("Got : " + result.size() + " trials");
				
				StringAttribute[] stringAttribute = (StringAttribute[]) result.toArray(new StringAttribute[result.size()]);
				if(stringAttribute != null && stringAttribute.length>0) {
		            HashSet resultSet = new HashSet();
		            for(int a=0;a<stringAttribute.length;a++) {
		            	StringAttribute stringAttr = stringAttribute[a];
						Entity entity = stringAttr.getParent();
						long entityId = entity.getId();
						entity = dataService.getEntity(entityId);
		
						System.out.println("Parsing parent : " + a);
						resultSet = parseParents(entity, entityId, resultSet);
		                finalSet.addAll(resultSet);
		            }
				}
            }
		}
		
		return finalSet;
	}
	
	/**
	 * Return the set of trial ids that match the search criteria for the institute name.
	 * 
	 * Returns null if no such criteria is specified
	 * 
	 * @param parameters
	 * @return
	 */
	private HashSet getTrialsMatchingInstituteCriteria(HashMap parameters) {
		HashSet finalSet = null;
		
		String institution = (String) parameters.get(new Long(TrialsConstants.TRIAL_OL_INSTITUTE_ATTRIB));
		if(institution != null) {
			String query = "from TrialOlMap t where upper(t.institution) like upper('%" + institution + "%')";
			System.out.println("Using query : " + query);
			List result = getHibernateTemplate().find(query);
			
			finalSet = new HashSet();
			for(int i=0; i<result.size(); i++) {
				TrialOlMap t = (TrialOlMap) result.get(i);
				finalSet.add(t.getTrialId() + "");
			}
		}
		
		return finalSet;
	}

	/**
	 * This routine is used to load data corresponding to the trial with the given id
	 * 
	 * @param trialId
	 * @return
	 */
	private ClinicalTrials loadTrialData(long trialId) {
		ClinicalTrials trial = new ClinicalTrials();
		trial.setId(trialId);
		
		// Retrieve the trial info object for this trial
		EntityAttribute[] trialInfoAttribs = dataService.getEntityAttributes(trialId, TrialsConstants.TRIAL_INFO_ATTRIB_ID);
		
		// Retrieve the official title, tumour type and purpose attributes
		if(trialInfoAttribs.length != 1) {
			trial.setStudyType("");
			trial.setOfficialTitle("");
			trial.setTumourType("");
			trial.setPurpose("");
			trial.setPhase("");
			trial.setMolecules("");
			trial.setStatus("");
		}
		else {
			StringAttribute studyAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_STUDY_TYPE_ATTRIB_ID);
			if(studyAttrib != null) {
				trial.setStudyType(studyAttrib.getValue());
			}
			else {
				trial.setStudyType("");
			}
			
			StringAttribute titleAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_OFFICIAL_TITLE_ATTRIB_ID);
			if(titleAttrib != null)
				trial.setOfficialTitle(titleAttrib.getValue());
			else
				trial.setOfficialTitle("");
			
			StringAttribute moleculeAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_MOLECULE_ATTRIB_ID);
			if(moleculeAttrib != null)
				trial.setMolecules(moleculeAttrib.getValue());
			else
				trial.setMolecules("");
			
			StringAttribute phaseAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_PHASE_ATTRIB_ID);
			if(phaseAttrib != null)
				trial.setPhase(phaseAttrib.getValue());
			else
				trial.setPhase("");
			
			StringAttribute tumorTypeAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_TUMOUR_TYPE_ATTRIB_ID);
			if(tumorTypeAttrib != null)
				trial.setTumourType(tumorTypeAttrib.getValue());
			else
				trial.setTumourType("");
			
			StringAttribute purposeAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_PURPOSE_ATTRIB_ID);
			if(purposeAttrib != null)
				trial.setPurpose(purposeAttrib.getValue());
			else
				trial.setPurpose("");
			
			StringAttribute genentechInvestigatorIdAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_GENENTECH_INVESTIGATOR_ID_ATTRIB_ID);
			if(genentechInvestigatorIdAttrib != null)
				trial.setGenentechInvestigatorId(genentechInvestigatorIdAttrib.getValue());
			else
				trial.setGenentechInvestigatorId("");
			
			StringAttribute licenseNumberAttrib = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_LICENSE_NUMBER_ATTRIB_ID);
			if(licenseNumberAttrib != null)
				trial.setLicenseNumber(licenseNumberAttrib.getValue());
			else
				trial.setLicenseNumber("");
			
			StringAttribute statusAttrib  = dataService.getAttribute(trialInfoAttribs[0].getMyEntity().getId(), TrialsConstants.TRIAL_STATUS_ATTRIB_ID);
			if(statusAttrib != null) 
				trial.setStatus(statusAttrib.getValue());
			else
				trial.setStatus("");
		}
		
		return trial;
	}
	
	/**
	 * This routine is used to find an entity in the hierachy of the given entity
     * that is of type OL Profile (id = 101)
     * 
	 * @param entity
	 * @param entityId
	 * @param results
	 * @return
	 */
	private HashSet parseParents(Entity entity, long entityId, HashSet results) {
    	return parseParents(entity.getType().getEntity_type_id(), entityId, results);
    }
	
	/**
     * This routine is used to find an entity in the hierachy of the given entity
     * that is of type OL Profile (id = 101) 
     * 
     * @param entityType
     * @param entityId
     * @param results
     * @return
     */
    private HashSet parseParents(long entityType, long entityId, HashSet results) {
        if (entityType != TrialsConstants.TRIAL_ENTITY_ID) {
        	PreparedStatement ps = null;
        	ResultSet rs = null;
        	try {
        		System.out.println("Got entity type : " + entityType + " while parsing");
        		// TODO: See if there is any entity-based way provided by hibernate for using
        		// prepared statements.
	            ps = this.getSession().connection().prepareStatement("select ea1.parent_id, e.type " +
	            		"from entities_attribute ea1, entities e " +
	            		"where e.entity_id = ea1.parent_id " +
	            		"and   ea1.myentity_id = ? " +
	            		"and e.deleteFlag = 'N'");
	            
	            ps.setLong(1, entityId);
	            rs = ps.executeQuery();
	            
	            if(rs.next()) {
		            long parentId = rs.getLong(1);
		            long parentEntityType = rs.getLong(2);
		            
		            // Close the ResultSet and PreparedStatement objects
		            rs.close();
		            ps.close();
		            
		            rs = null;
		            ps = null;

		            // Make a recursive call to move one level up in the entity hierarchy
		            parseParents(parentEntityType, parentId, results);
	            }
	            else {
	            	System.out.println("Got no results for : " + entityId);
	            }
        	}
        	catch(SQLException e) {
        		e.printStackTrace();
        		throw new RuntimeException(e);
        	} catch (DataAccessResourceFailureException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            } catch (HibernateException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            } 
            finally {
                try {
                    if(rs != null)
                        rs.close();
                }
                catch(Exception e) {
                    // ignore it
                }
                
                try {
                    if(ps != null)
                       ps.close();
                }
                catch(Exception e) {
                    // ignore it
                }
            }
            
        } else {
            if (results != null && !results.contains(entityId + "")) {
                results.add(entityId + "");
            }
        }
        return results;
    }
	
    /**
     * Get the interaction between two hashsets. If any of the sets is null, it is ignored and the other set is returned.
     * 
     * @param set1
     * @param set2
     * @return
     */
    private HashSet getIntersectionIgnoringNullSet(HashSet set1, HashSet set2) {
		if(set1 == null)
			return set2;
		
		if(set2 == null)
			return set1;
		
		HashSet results = new HashSet();
			
		if (!set1.isEmpty() && !set2.isEmpty()) {
			Iterator itr = set1.iterator();
			String id = null;
			while (itr.hasNext()) {
				id = (String) itr.next();
				if (set2.contains(id)) {
					results.add(id);
				}
			}
		}
		
		return results;
	}
    
	public IDataService getDataService() {
		return dataService;
	}

	public void setDataService(IDataService dataService) {
		this.dataService = dataService;
	}

	public IOptionService getOptionService() {
		return optionService;
	}

	public void setOptionService(IOptionService optionService) {
		this.optionService = optionService;
	}	
}
