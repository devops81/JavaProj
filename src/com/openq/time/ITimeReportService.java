package com.openq.time;

import java.util.Date;

public interface ITimeReportService {
	
	public TimeReport[] getAllTimeReportforUser(long userId);
	public TimeReport[] getTimeFrameReport(long userId, Date fromDate, Date toDate);
	public void saveTimeReport(TimeReport timeReport);
	public void updateTimeReport(TimeReport timeReport);
	public void deleteTimeReport(TimeReport timeReport);
	public TimeReport getTimeReport(long id);

}
