package com.openq.event;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

import java.util.List;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.text.DateFormat;

import com.openq.web.ActionKeys;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:44:21 PM
 * To change this template use File | Settings | File Templates.
 */
public class KolCalendarService extends HibernateDaoSupport implements IKolCalendarService {

   IKolCalendarService kolCalendarService;
   public final static DateFormat format = new SimpleDateFormat("dd-MMM-yy");

   public void saveKolCalendar(KolCalendar kolCalendar){

        String s = format.format(kolCalendar.getPreferenceDate());
        List result  = getHibernateTemplate().find("from KolCalendar k where k.preferenceDate = '"+ s + "' and k.kolId = "+ kolCalendar.getKolId());

        if ( result.size() > 0 )
        {
            getHibernateTemplate().delete(result.get(0));
        }
        if ( !kolCalendar.getType().equals("3"))  getHibernateTemplate().save(kolCalendar);
   }

   public void updateKolCalendar(KolCalendar kolCalendar){
       getHibernateTemplate().update(kolCalendar);
   }

   public List getAllPreferenceForExpertId(long id){
       return getHibernateTemplate().find("from KolCalendar k where k.kolId = "+ id);
   }

   public List getAllPreferenceForExpertIdByType(long id, String preferenceType){
       return getHibernateTemplate().find("from KolCalendar k where k.kolId = "+ id + " and k.type='"+preferenceType+"'");
   }
}
