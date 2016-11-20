package com.openq.eav.trials;

import java.util.HashMap;

/**
 * This interface is used to maintain clinical trials data in the EAV-based database
 * 
 * @author Amit
 */
public interface ITrialService {
	public ClinicalTrials getTrialWithId(long trialId);
	public ClinicalTrials[] searchTrialAdv(HashMap parameters);
	public void deleteTrials(String[] trialIds);
}
