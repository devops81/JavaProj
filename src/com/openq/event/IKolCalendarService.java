package com.openq.event;

import java.util.TreeMap;
import java.util.List;
import java.text.ParseException;

/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Nov 30, 2006
 * Time: 3:44:21 PM
 * To change this template use File | Settings | File Templates.
 */
public interface IKolCalendarService {

   public void saveKolCalendar(KolCalendar kolCalendar);

   public void updateKolCalendar(KolCalendar kolCalendar);

   public List getAllPreferenceForExpertId(long id);

   public List getAllPreferenceForExpertIdByType(long id, String preferenceType);
}
