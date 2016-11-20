package com.openq.eav.expert;

import java.util.List;

import com.openq.user.User;

public interface IExpertDetailsService {

    public List getExpertDetails(String staffId);

    public List getKolidsOfAffiliatedExperts(String staffId);

    public void saveExpertDetails(ExpertDetails expertDetails);

    public ExpertDetails getExpertDetailsOnUserid(String id);

    public void populateUserObject(User userObj);
    
    public ExpertDetails getExpertDetailsOnKolid(long kolid);
    
    public void updateExpertDetails(ExpertDetails expertDetails);
}