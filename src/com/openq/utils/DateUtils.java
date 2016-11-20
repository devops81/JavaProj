package com.openq.utils;

import java.util.Calendar;
import java.util.Date;

public abstract class DateUtils {
  public static boolean isInCurrentQtr(Date date) {
    Date currentQtrStart = getCurrentQtrStartDate();
    Date currentQtrEnd = getCurrentQtrEndDate();

    if (date.after(currentQtrStart) && date.before(currentQtrEnd))
      return true;
    return false;
  }

  public static Date getCurrentQtrStartDate() {
    Date currentDate = new Date();
    Calendar calendar = Calendar.getInstance();

    calendar.set(Calendar.MONTH, 0);
    calendar.set(Calendar.DATE, 1);
    Date Q1 = calendar.getTime();

    calendar.set(Calendar.MONTH, 3);
    calendar.set(Calendar.DATE, 1);
    Date Q2 = calendar.getTime();

    calendar.set(Calendar.MONTH, 6);
    calendar.set(Calendar.DATE, 1);
    Date Q3 = calendar.getTime();

    calendar.set(Calendar.MONTH, 9);
    calendar.set(Calendar.DATE, 1);
    Date Q4 = calendar.getTime();

    if (currentDate.after(Q4))
      return Q4;

    if (currentDate.after(Q3))
      return Q3;

    if (currentDate.after(Q2))
      return Q2;

    return Q1;
  }

  public static Date getCurrentQtrEndDate() {
    Date currentDate = new Date();
    Calendar calendar = Calendar.getInstance();

    calendar.set(Calendar.MONTH, 3);
    calendar.set(Calendar.DATE, 1);
    Date Q1 = calendar.getTime();

    calendar.set(Calendar.MONTH, 6);
    calendar.set(Calendar.DATE, 1);
    Date Q2 = calendar.getTime();

    calendar.set(Calendar.MONTH, 9);
    calendar.set(Calendar.DATE, 1);
    Date Q3 = calendar.getTime();

    calendar.set(Calendar.YEAR, calendar.get(Calendar.YEAR) + 1);
    calendar.set(Calendar.MONTH, 0);
    calendar.set(Calendar.DATE, 1);
    Date Q4 = calendar.getTime();

    if (currentDate.before(Q1))
      return Q1;

    if (currentDate.before(Q2))
      return Q2;

    if (currentDate.before(Q3))
      return Q3;

    return Q4;
  }
  
  public static Date getNextMonthStart(){
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, 1);
    cal.set(Calendar.DATE, 1);
    return cal.getTime();
  }
}
