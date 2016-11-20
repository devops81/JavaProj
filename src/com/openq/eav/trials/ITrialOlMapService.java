package com.openq.eav.trials;

public interface ITrialOlMapService {
	public TrialOlMap[] getAllOlsForTrial(long trialId);
	public TrialOlMap[] getAllTrialsForOl(long olId);
	public void saveTrialOlMap(TrialOlMap map);
	public TrialOlMap getTrialOlMap(long id);
	public void deleteTrialOlMap(TrialOlMap map);
}
