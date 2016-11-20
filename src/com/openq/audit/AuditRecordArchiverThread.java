/**
 * 
 */
package com.openq.audit;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimerTask;

import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Session;
import net.sf.hibernate.SessionFactory;
import net.sf.hibernate.Transaction;

import org.apache.log4j.Logger;

/**
 * @author aagarwal
 * 
 */
public class AuditRecordArchiverThread extends TimerTask {
    private static Logger logger = Logger.getLogger(AuditRecordArchiverThread.class);

    // Hibernate sessionFactory
    private SessionFactory sessionFactory;

    // Audit records older than this age, in days, qualify to be archived
    static final int ARCHIVE_AGE = 120;

    // The state of this task, chosen from the constants below.
    int state = VIRGIN;

    // This task has not yet been scheduled.
    static final int VIRGIN = 0;

    // This task is scheduled for execution.
    static final int SCHEDULED = 1;

    /**
     * 
     */
    public void run() {
        // Check if the task is scheduled
        if (!isTaskScheduled()) {

            // Set the correct task state
            setTaskScheduled();

            // Get the current date
            Calendar cal = Calendar.getInstance();
            Date currentDate = cal.getTime();

            // Get the date eligible for archiving
            cal.add(Calendar.DATE, -1 * ARCHIVE_AGE);
            Date archivableDate = cal.getTime();

            // Set the date formatter
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd:hh:mm:ssa");

            // Do the archiving
            Session session = null;
            Transaction tx = null;
            try {
                // Get a hibernate session
                session = sessionFactory.openSession();
                
                // Start a transaction
                tx = session.beginTransaction();
                try {
                    logger.debug("Calling the db procedure AUDITRECORDSARCHIVEPROCEDURE");
                    
                    // Call the procedure
                    PreparedStatement st = session.connection().prepareStatement("{call AUDITRECORDSARCHIVEPROCEDURE(?, ?)}");
                    st.setString(1, formatter.format(currentDate));
                    st.setString(2, formatter.format(archivableDate));
                    st.execute();
                    
                    // Everything went fine, commit the transaction
                    tx.commit();
                    logger.debug("Finished the db procedure AUDITRECORDSARCHIVEPROCEDURE");
                } catch (HibernateException e) {
                    // Couldn't complete the transaction
                    logger.error(e);
                    try {
                        // Some issue while executing the transaction, lets rollback
                        tx.rollback();
                    } catch (HibernateException e1) {
                        // Some error while rolling back the transaction
                        logger.error(e1);
                    }
                } catch (SQLException e) {
                    // Some issue with the procedure definition
                    logger.error(e);
                }
            } catch (HibernateException e) {
                // Couldn't get a session or start a transaction, lets get out
                logger.error(e);
            }

            // Reset the task state
            setTaskVirgin();
        } else {
            logger.warn("The background thread is already running, quitting siliently");
        }
    }

    private void setTaskVirgin() {
        state = VIRGIN;
    }

    private void setTaskScheduled() {
        state = SCHEDULED;
    }

    private boolean isTaskScheduled() {
        return state == SCHEDULED;
    }

    /**
     * @return the sessionFactory
     */
    public SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    /**
     * @param sessionFactory
     *            the sessionFactory to set
     */
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }
}
