package com.openq.eav.expert;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import com.openq.user.User;
import com.openq.utils.SqlAndHqlUtilFunctions;

/**
 * @author Tapan Jan 15, 2009
 *
 */
public class ExpertDetailsService extends HibernateDaoSupport implements
        IExpertDetailsService {

    /**
     * This function takes staffId as input parameter and returns an array of
     * kolids of affiliated Experts from Contacts Msl Ol Map
     *
     * @param staffId
     * @return String array of kolId s
     */
    public List getKolidsOfAffiliatedExperts(String staffId) {
        String presentDate = getPresentDate();
        String queryString = "select c.kolId from Contacts c where c.staffid = "
                + staffId
                + "and begindate <= '"
                + presentDate
                + "' and enddate >= '" + presentDate + "'";

        List result = getHibernateTemplate().find(queryString);
        return result;
    }

    /**
     * This function takes the staffid as input and returns an array of
     * ExpertDetails object.
     *
     * @param staffid
     *
     * @return array of ExpertDetails objects
     */
    public List getExpertDetails(String staffId) {

        List result = getKolidsOfAffiliatedExperts(staffId);
        if(result.size() == 0){
            return null;
        }
        Set kolIdSet = new HashSet();
        kolIdSet.addAll(result);
 
        String[] inClauseTokenStrings = SqlAndHqlUtilFunctions
                .constructInClauseForQuery(kolIdSet);
        StringBuffer query = new StringBuffer(
                "from ExpertDetails e where e.deleteFlag = 'N' and ");
        for (int i = 0; i < inClauseTokenStrings.length; i++) {
            query.append("( e.id in (" + inClauseTokenStrings[i] + " )) ");

            if(i != inClauseTokenStrings.length-1)
                query.append("OR");
        }
        query.append("order by lower(e.lastName), lower(e.firstName), lower(e.primarySpeciality), lower(e.secondarySpeciality),lower(e.tertiarySpeciality), lower(e.title), lower(e.addressCity), lower(e.addressState), lower(e.addressCountry) ");

        List resultList = getHibernateTemplate().find(query.toString());
        return resultList;

    }

    /**
     * This function takes the expDetails object as input parameter and
     * temporarily saves it till the materialized view is refreshed.
     *
     * @param ExpertDetails
     *            object
     *
     * @return void
     */
    public void saveExpertDetails(ExpertDetails expertDetails) {
        getHibernateTemplate().save(expertDetails);
    }

    /**
     * This function returns today's date as String.
     *
     * @return String today's Date
     */
    private String getPresentDate() {
        Date date = new Date(System.currentTimeMillis());
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        String presentDate = (dateFormat.format(date)).toString();
        return presentDate;
    }

    /**
     *
     */
    public ExpertDetails getExpertDetailsOnUserid(String id) {
        String queryString = "from ExpertDetails e where e.id = "+id;
        List result = getHibernateTemplate().find(queryString);
        if (result == null || result.size() <= 0)
            return null;
        else {
            ExpertDetails expertDetails = (ExpertDetails)result.get(0);
            return expertDetails;
        }
    }

    public void populateUserObject(User userObj) {

        String speciality = "";
        String queryString = "from ExpertDetails e where e.id = "+userObj.getId();
        List result = getHibernateTemplate().find(queryString);
        if (result != null && result.size()>0) {

            ExpertDetails expDetails = (ExpertDetails)result.get(0);

          //Populating speciality in the User object
            if(expDetails.getPrimarySpeciality()!= null &&
                    !expDetails.getPrimarySpeciality().equals("")){
                speciality = expDetails.getPrimarySpeciality();
            }
            if(expDetails.getSecondarySpeciality()!= null &&
                    !expDetails.getSecondarySpeciality().equals("")){
                if(speciality.equals(""))
                    speciality = expDetails.getSecondarySpeciality();
                else
                    speciality = speciality + ", " + expDetails.getSecondarySpeciality();
            }
            if(expDetails.getTertiarySpeciality()!= null &&
                    !expDetails.getTertiarySpeciality().equals("")){
                if(speciality.equals(""))
                    speciality = expDetails.getTertiarySpeciality();
                else
                    speciality = speciality +", " + expDetails.getTertiarySpeciality();
            }
            userObj.setSpeciality(speciality);

            //Populating Address Details 'Location' in the User Object
            String location ="";
            if(expDetails.getAddressCity()!=null && !expDetails.getAddressCity().equals(""))
            location = expDetails.getAddressCity();
            if(expDetails.getAddressState()!= null && !expDetails.getAddressState().equals(""))
            {
                if(location.equals(""))
                    location = expDetails.getAddressState();
                else
                    location = location+", "+ expDetails.getAddressState();
            }
            if(expDetails.getAddressCountry()!=null &&
                    !expDetails.getAddressCountry().trim().equalsIgnoreCase("United States") &&
                    !expDetails.getAddressCountry().trim().equalsIgnoreCase("USA")&&
                    !expDetails.getAddressCountry().trim().equalsIgnoreCase("United states of America") )
            {
                if(location.equals(""))
                    location = expDetails.getAddressCountry();
                else
                    location = location+", "+expDetails.getAddressCountry();
            }
            userObj.setAddLine1(expDetails.getAddressLine1());
            userObj.setAddLine2(expDetails.getAddressLine2());
            userObj.setAddCity(expDetails.getAddressCity());
            userObj.setAddState(expDetails.getAddressState());
            userObj.setAddCountry(expDetails.getAddressCountry());
            userObj.setAddZip(expDetails.getAddressPostalCode());
            userObj.setLocation(location);

            //Populating the Contact Information Details-- Phone Details
            //userObj.setPreferredContactType("Business");
            userObj.setPreferredContactInfo(expDetails.getPrimaryPhone());
            userObj.setPhone(expDetails.getPrimaryPhone());
            userObj.setEmail(expDetails.getPrimaryEmail());
            userObj.setFax(expDetails.getPrimaryFax());


        }


    }

    public ExpertDetails getExpertDetailsOnKolid(long kolid) {
        String queryString = "from ExpertDetails e where e.kolid = " + kolid;
        List result = getHibernateTemplate().find(queryString);
        if (result.size() > 0) {
            return (ExpertDetails) result.get(0);
        } else {
            return null;
        }
    }

    public void updateExpertDetails(ExpertDetails expertDetails) {
        try{
            getHibernateTemplate().update(expertDetails);
        }catch(Exception e){
            logger.error(e.getStackTrace());
        }
    }
}