package com.openq.web.controllers;

import java.io.OutputStream;
import java.util.*;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.MultiHashMap;
import org.apache.commons.collections.MultiMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.authentication.UserDetails;
import com.openq.eav.option.IOptionService;
import com.openq.eav.option.IOptionServiceWrapper;
import com.openq.event.*;
import com.openq.event.materials.EventMaterial;
import com.openq.event.materials.IEventMaterialService;
import com.openq.kol.KOLManager;
import com.openq.report.IReportService;
import com.openq.user.IUserService;
import com.openq.user.User;
import com.openq.utils.DateUtils;
import com.openq.utils.PropertyReader;
import com.openq.web.ActionKeys;

public class ExpertHomeController extends AbstractController {

  IOptionService optionService;

  IReportService reportService;

  IOptionServiceWrapper optionServiceWrapper;

  IEventMaterialService eventMaterialService;

  IEventService eventService;

  IUserService userService;

    public IKolCalendarService getKolCalendarService() {
        return kolCalendarService;
    }

    public void setKolCalendarService(IKolCalendarService kolCalendarService) {
        this.kolCalendarService = kolCalendarService;
    }

    IKolCalendarService kolCalendarService;

  public IUserService getUserService() {
    return userService;
  }

  public void setUserService(IUserService userService) {
    this.userService = userService;
  }

  public IEventMaterialService getEventMaterialService() {
    return eventMaterialService;
  }

  public void setEventMaterialService(IEventMaterialService eventMaterialService) {
    this.eventMaterialService = eventMaterialService;
  }

  public IEventService getEventService() {
    return eventService;
  }

  public void setEventService(IEventService eventService) {
    this.eventService = eventService;
  }

  public IOptionService getOptionService() {
    return optionService;
  }

  public void setOptionService(IOptionService optionService) {
    this.optionService = optionService;
  }

  public IOptionServiceWrapper getOptionServiceWrapper() {
    return optionServiceWrapper;
  }

  public void setOptionServiceWrapper(IOptionServiceWrapper optionServiceWrapper) {
    this.optionServiceWrapper = optionServiceWrapper;
  }

  protected ModelAndView handleRequestInternal(HttpServletRequest req,
                                               HttpServletResponse res) throws Exception {

    HttpSession session = req.getSession(true);
    session.setAttribute("CURRENT_LINK", "HOME");
    session.removeAttribute("fromKOLStrategy");
    session.removeAttribute("ORG_LINK");
    session.removeAttribute("ORGID");
    String pref = (String)req.getParameter("pref");
	String userGroupIdString = (String) session.getAttribute(Constants.CURRENT_USER_GROUP);
	long userGroupId = -1;
	if(userGroupIdString != null && !"".equalsIgnoreCase(userGroupIdString))
	 userGroupId = Long.parseLong(userGroupIdString);

    long userID = Long.parseLong(session.getAttribute(Constants.USER_ID).toString());
    if ( pref != null && !pref.equals(""))
    {
        setKolPrefence(req, userID, pref);
    }
    Object[] eventObject = (Object[]) eventService.getEventsByExpert(userID);

    ArrayList eventIdList = new ArrayList();
    Collection invitationsThisQtr = new HashSet();
    Collection acceptancesForNext6Months = new HashSet();
    Collection eventsThisMonth = new HashSet();
    Collection presentationsThisMonth = new HashSet();


    if (null != eventObject && eventObject.length > 0) {
      for (int i = 0; i < eventObject.length; i++) {
        Object[] eventRow = (Object[]) eventObject[i];
        EventEntity eventEntity = (EventEntity) eventRow[0];
        eventIdList.add(eventEntity);
        EventAttendee attendee = (EventAttendee) eventRow[1];
        Date eventDate = eventEntity.getEventdate();

        if (DateUtils.isInCurrentQtr(eventDate))
          invitationsThisQtr.add(eventEntity);
        if (EventAttendee.ACCEPTED_STATUS.equals(attendee.getAcceptanceStatus()))
        {
          Calendar cal = Calendar.getInstance();
          cal.add(Calendar.MONTH, 6);
          if (eventDate.before(cal.getTime()))
            acceptancesForNext6Months.add(eventEntity);

        }
        if(eventDate.after(new Date()) && eventDate.before(DateUtils.getNextMonthStart())){
          eventsThisMonth.add(eventEntity);
        }
      }
    }

    ArrayList expertMaterialList = new ArrayList();
    MultiMap materialMap = new MultiHashMap();
    for (int i = 0; i < eventIdList.size(); i++) {
      EventEntity event = (EventEntity) eventIdList.get(i);
      EventMaterial[] materialList = eventMaterialService
          .getAllEventMaterialsOfEvent(event.getId());
      if (materialList != null) {
        for (int j = 0; j < materialList.length; j++) {
          expertMaterialList.add(materialList[j]);
          if(eventsThisMonth.contains(event)){
            presentationsThisMonth.addAll(Arrays.asList(materialList));
          }
          materialMap.put(event.getTitle(), materialList[j]);
        }
      }
    }

    session.setAttribute("expertMaterialList", expertMaterialList);
    session.setAttribute("expertMaterialMap", materialMap);
    for (int i = 0; i < expertMaterialList.size(); i++) {
      System.out.println("Material Name is "
          + ((EventMaterial) expertMaterialList.get(i)).getName());
    }
    if ("getFile".equalsIgnoreCase(req.getParameter("action"))) {
      System.out.println("material id is" + req.getParameter("materialId"));
      EventMaterial mat = eventMaterialService.getEventMaterial(Long
          .parseLong(req.getParameter("materialId").toString()));
      System.out.println("the file name from db is " + mat.getName());
      mat.getMaterialContent();
      res.setBufferSize(8192);
      res.setContentType("application/octet-stream");
      res.setHeader("Content-Disposition", "attachment; filename=\""
          + mat.getName() + "\"");
      OutputStream os = res.getOutputStream();
      try {
        FileCopyUtils.copy(mat.getMaterialContentStream(), res
            .getOutputStream());
      } finally {
        mat.getMaterialContentStream().close();
        os.flush();
        os.close();
      }
      return null;
    }

    String staffId = null;
    if (req.getSession().getAttribute(Constants.CURRENT_USER) != null) {
      staffId = (String) session.getAttribute(Constants.CURRENT_STAFF_ID);
      session.setAttribute("STAFF_ID", staffId);
    }

    req.getSession().setAttribute(
        "stateAbbriviation",
        optionServiceWrapper.getValuesForOptionName(PropertyReader
            .getLOVConstantValueFor("STATE"), userGroupId));
    KOLManager kolManager = new KOLManager();
    session.setAttribute("MY_TACTIC_LIST", kolManager.getMyTacticList(staffId));

    session.setAttribute("reportsList", reportService.getAllReports(userGroupId));

    UserDetails userDetails = (UserDetails) session.getAttribute(Constants.CURRENT_USER);
    User user = userService.getUserForKolId(Long.parseLong(userDetails.getKolId()));

    ModelAndView mav = new ModelAndView("experthome");

    Map kolMap = new HashMap();
    kolMap.put("details", user);
    //kolMap.put("photoURL", PropertyReader.getServerConstantValueFor("photos.url"));
    mav.addObject("kol", kolMap);

    mav.addObject("eventsThisQtr", invitationsThisQtr);
    mav.addObject("eventsThisQtrSize", new Integer(invitationsThisQtr.size()));

    mav.addObject("acceptancesNext6Mo", acceptancesForNext6Months);
    mav.addObject("acceptancesNext6MoSize", new Integer(acceptancesForNext6Months.size()));

    mav.addObject("eventsThisMonth", eventsThisMonth);
    mav.addObject("eventsThisMonthSize", new Integer(eventsThisMonth.size()));

    mav.addObject("presentationsThisMonth", presentationsThisMonth);
    mav.addObject("presentationsThisMonthSize", new Integer(presentationsThisMonth.size()));

    return mav;
  }

  private void setKolPrefence( javax.servlet.http.HttpServletRequest req, long userID, String pref)
  {
      KolCalendar kolCalendar = new KolCalendar();
      kolCalendar.setKolId(userID);

      kolCalendar.setType(pref);
      Date date = null;
      try {

           SimpleDateFormat sdf = new SimpleDateFormat(ActionKeys.CALENDAR_DATE_FORMAT);
           int mm = Integer.parseInt(req.getParameter("selectedMonth")) ;
           String selDate = mm + "/" + req.getParameter("selectedDay") +"/" +  req.getParameter("selectedYear");
           date = sdf.parse(selDate);
           System.out.println(" pref date is  "  + selDate  + "   --- "  + date.toString());
      }
      catch (Exception e )
      {
          System.out.println(" exception in setting kol pref "  + e);
          date = new Date();
      }
      kolCalendar.setPreferenceDate(date);
      kolCalendarService.saveKolCalendar(kolCalendar);
  }

  public void setReportService(IReportService reportService) {
    this.reportService = reportService;
  }

}
