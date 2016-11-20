package com.openq.eav.trials;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

/**
 * This class is used to maintain a mapping between trials and affiliated OLs
 * 
 * @author Amit
 */
public class TrialOlMapService extends HibernateDaoSupport implements
		ITrialOlMapService {

	/**
	 * Get the list of all OLs for the specified trial Id
	 */
	public TrialOlMap[] getAllOlsForTrial(long trialId) {
		List result = getHibernateTemplate().find("select t from TrialOlMap t, Entity e where t.trialId = " + trialId 
				+ " and e.id = t.trialId " 
				+ " and e.deleteFlag = 'N'");
		
		System.out.println("Returning : " + result.size() + " map entries for trial : " + trialId);
		
		return (TrialOlMap[]) result.toArray(new TrialOlMap[result.size()]);
	}
	
	/**
	 * Get the list of all trials for the specified ol
	 */
	public TrialOlMap[] getAllTrialsForOl(long olId) {
		List result = getHibernateTemplate().find("select t from TrialOlMap t, Entity e where t.olId = " + olId
				+ " and e.id = t.trialId " 
				+ " and e.deleteFlag = 'N'");
		
		System.out.println("Returning : " + result.size() + " map entries for ol : " + olId);
		
		return (TrialOlMap[]) result.toArray(new TrialOlMap[result.size()]);
	}

	/**
	 * Save an entry to record affiliation between an OL and a trial
	 */
	public void saveTrialOlMap(TrialOlMap map) {
		getHibernateTemplate().save(map);
	}

	/**
	 * Get the TrialOLMap object with the specified id
	 */
	public TrialOlMap getTrialOlMap(long id) {
		List result = getHibernateTemplate().find("from TrialOlMap t where t.id = " + id);
		
		if(result.size() == 1)
			return (TrialOlMap) result.get(0);
		
		throw new IllegalArgumentException("Got : " + result.size() + " TrialOlMap entries for id : " + id);
	}

	/**
	 * Delete the entry corresponding to the affiliation between the specified OL and trial
	 */
	public void deleteTrialOlMap(TrialOlMap map) {
		getHibernateTemplate().delete(map);
	}
}
