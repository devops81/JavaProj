package com.openq.alerts;

import java.util.Date;
import java.util.List;

import com.openq.alerts.data.Alert;
import com.openq.alerts.data.AlertAuditQueue;
import com.openq.alerts.data.AlertQueue;

public interface IAlertsService {
    public Alert[] getAllAlerts();

    public Alert getAlert(long id);

    public void saveAlert(Alert alert);

    public void updateAlert(Alert alert);

    public void deleteAlert(long id);

    public void saveAlertQueue(AlertQueue queue);

    public void updateAlertQueue(AlertQueue queue);

    public AlertQueue[] getAlertQueue(String id);

    public AlertAuditQueue[] getAuditQueue();

    public void updateAuditQueue(AlertAuditQueue queue);

    public void processAlerts();
    
    public Alert getAlertByName(String alertName);
    
    public AlertQueue getAlertQueueByKolid(long alertId, long kolid);
    
    public boolean deleteAlertQueueRecord(AlertQueue alertQueue);
    
    public void deleteAlertQueueList(List queue);
    
    public List getChangesInTheLastMonth(Date fromDate,Date endDate);
}