package com.openq.siteSearch;

import java.util.HashMap;
import java.util.List;

/**
*
* @author Tapan
* @date 15th Sept 2009
*
*/

public interface ISiteSearchService {

    public List getAllSites(HashMap siteParamMap, long userGroupId, String currentUserTA);

}