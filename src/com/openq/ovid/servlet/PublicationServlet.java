package com.openq.ovid.servlet;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.nio.channels.FileChannel;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import com.openq.ovid.PublicationsManager;
import com.openq.ovid.OvidClient;
import com.openq.ovid.OvidConstants;
import com.openq.ovid.Publications;
import com.openq.web.ActionKeys;
import com.openq.kol.DBUtil;
import com.openq.kol.SearchDTO;


public class PublicationServlet extends HttpServlet {

    private static final long PROCESS_WAIT_PERIOD = 86400000; // one day
    private static final long PROCESS_WAIT_PERIOD_MONTH = 86400000/* * 30*/;

    private static Logger logger = Logger.getLogger(PublicationServlet.class);

    private PublicationsTask pubTask;

    private ServletContext context;

    private int batch;

    private Timer publicationsTimer;

    private Timer mailTimer;

    /**
     * @see javax.servlet.Servlet#init(javax.servlet.ServletConfig)
     */
    public void init(ServletConfig config) throws ServletException {
        logger.info("Into the init method of EmailStatusServlet");
        super.init(config);

        mailTimer = new Timer(true);
        publicationsTimer = new Timer(true);
        pubTask = new PublicationsTask();
        context = getServletContext();


        Calendar calendar = Calendar.getInstance();

        PublicationsManager manager = new PublicationsManager();
        try{
            String[] scheduleDetails = manager.getOvidScheduleDetails();
            String[] time = null;
            if(scheduleDetails[0] != null && !"".equals(scheduleDetails[0]))
                time = scheduleDetails[0].split(":");

            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");

            Calendar cal = Calendar.getInstance();
            if(time != null && scheduleDetails[1] != null){
                cal.setTime(sdf.parse(scheduleDetails[1]));
                cal.set(Calendar.HOUR_OF_DAY,Integer.parseInt(time[0]));
                cal.set(Calendar.MINUTE,Integer.parseInt(time[1]));
            }
            if(scheduleDetails[2] != null)
                publicationsTimer.scheduleAtFixedRate(pubTask,cal.getTime(),Integer.parseInt(scheduleDetails[2]) * 86400000);
        }catch(Exception e){
            logger.error("",e);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException {

        String source = request.getParameter("source");
        /*
           * If the user clicks on Save Schedule button,
           * below block will be executed
           */
        if ("schedule".equalsIgnoreCase(source)) {
            String startTime = request.getParameter("startTime");
            String startDate = request.getParameter("startDate");

            String days = request.getParameter("daysbetween");

            long processWaitTime = Integer.parseInt(days) * 24 * 60 * 60;
            Date startTimeDate = new Date();
            String hourMin[] = startTime.split(":");

            PublicationsManager manager = new PublicationsManager();
            try {
                manager.updateOvidScheduleDetails(startTime, startDate, days);
                request.setAttribute("results",manager.getOvidScheduleDetails());
            } catch (Exception e) {
                logger.error("", e);
            }
            SimpleDateFormat sdf = new SimpleDateFormat(
                    ActionKeys.CALENDAR_DATE_FORMAT);
            try {
                Calendar cal = Calendar.getInstance();
                cal.setTime(sdf.parse(startDate));
                cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(hourMin[0]));
                cal.set(Calendar.MINUTE, Integer.parseInt(hourMin[1]));

                startTimeDate = cal.getTime();
            } catch (ParseException e) {
                logger.error("", e);
            }
            try{
                pubTask.cancel();
                pubTask = new PublicationsTask();
                publicationsTimer.scheduleAtFixedRate(pubTask, startTimeDate, processWaitTime);
            }catch(IllegalStateException e){}
            try {
                response.sendRedirect(request.getContextPath()
                        + "/profileCapture.htm?action="+ActionKeys.OVID_SCHEDULE+"&link=Ovid Schedule");
            } catch (IOException e) {
                logger.error("", e);
            }
        } else {
            //This else part will be executed, if the user clicks on ExecuteCapture button
            try{
                //If the task is already running, don't schedule it again.
                if(!"Executing".equals(getServletContext().getAttribute("OVID_STATUS"))){
                    publicationsTimer.schedule(pubTask, new Date());
                }
            }catch(IllegalStateException e){}
            try {
                response.sendRedirect(request.getContextPath()
                        + "/profileCapture.htm?action="+ActionKeys.OVID_SCHEDULE+"&link=Ovid Schedule");
            } catch (IOException e) {
                logger.error("", e);
            }
        }
    }

    /**
     * @see javax.servlet.Servlet#getServletInfo()
     */
    public String getServletInfo() {
        return "Publication Controller";
    }

    /**
     * @see javax.servlet.Servlet#destroy()
     */
    public void destroy() {
        try {
            mailTimer.cancel();
            mailTimer = null;
            publicationsTimer.cancel();
            publicationsTimer = null;
        } catch (IllegalStateException e) {
        }
    }
    class PublicationsTask extends TimerTask {

        Process process = null;
        OutputStream outputStream = null;
        FileOutputStream fos = null;
        PrintStream ps = null;
        FileChannel fc = null;
        int day = 0;

        public void run() {

            logger.info("Into the run method of Publications task "
                    + new Date());
//			logger.info("status  " + context.getAttribute("OVID_STATUS"));

            try {
                PublicationsManager manager = new PublicationsManager();
                Properties ovidProps = DBUtil.getInstance()
                .getDataFromPropertiesFile("resources/OvidConfig.properties");

                int noOfExperts = Integer.parseInt(ovidProps.getProperty("experts.batch"));
                String initialDir = ovidProps.getProperty("logfile.location");
                int fileMaxSize = Integer.parseInt(ovidProps.getProperty("logfile.maxsize")) *1024 *1024;

                /*
                     * Check whether yaz client is already running or not? If it is
                     * running don't run again.
                     */
                if (!"Executing".equals(context.getAttribute("OVID_STATUS"))) {

                    getServletContext().setAttribute("pub_batch",""+ batch++);

                    context.setAttribute("OVID_STATUS", "Executing");

                    ArrayList authorList = null;

                    authorList = manager.getMatchingAuthorList();
                    logger.debug("authorList " + authorList.size());

                    OvidClient ovidClient = null;
                    ArrayList aggregateSrchResult = null;

                    if (null != authorList && authorList.size() > 0) {
                        SearchDTO searchDTO = null;
                        ArrayList srchResult = null;
                        aggregateSrchResult = new ArrayList();
                        searchDTO = new SearchDTO();
                        /* ovidClient = new OvidClient(searchDTO, null, null);
                               srchResult =
                               ovidClient.connect(OvidConstants.OVID_PUBMED_DATABASE,
                               OvidConstants.CONFIDENCE_FACTOR_FULL);*/

                        if (srchResult != null && srchResult.size() > 0) {
                            process = (Process) srchResult.get(srchResult
                                    .size() - 1);
                            outputStream = (OutputStream) srchResult
                                    .get(srchResult.size() - 2);
                            srchResult.remove(srchResult.size() - 1);
                            srchResult.remove(srchResult.size() - 1);
                        }
                        /*
                               * Create small batches from the author(Expert) list
                               */
                        ArrayList batchList = getBatches(authorList,noOfExperts);

                        String batchDir = "/batch";
                        Calendar cal = Calendar.getInstance();
                        batchDir += cal.get(Calendar.YEAR);
                        batchDir += cal.get(Calendar.MONTH) + 1;
                        if(day == 0 || day != cal.get(Calendar.DAY_OF_MONTH)){
                            day = cal.get(Calendar.DAY_OF_MONTH);
                            batch = 0;
                            getServletContext().setAttribute("pub_batch",""+ batch++);
                        }
                        batchDir += day;
                        batchDir += "_"+getServletContext().getAttribute("pub_batch")+"/";

                        File f = new File(initialDir+batchDir);
                        f.mkdir();

                        for (int k = 0; k < batchList.size(); k++) {
                            aggregateSrchResult = new ArrayList();
                            logger
                                    .info("running batch " + k + " "
                                            + new Date());
                            authorList = (ArrayList) batchList.get(k);
                            String file = initialDir + batchDir
                            + "publications_" + (k+1) + ".log";
                            try {
                                /*
                                         * Create separate Ovid loggers for each batch
                                         */
                                    fos = new FileOutputStream(file);
                                    ps = new PrintStream(fos);
                                    System.setOut(ps);
                                    fc = fos.getChannel();
                            } catch (FileNotFoundException fe) {
                                fe.printStackTrace();
                            }
                            ovidClient = new OvidClient(process, outputStream);

                            for (int i = 0; i < authorList.size(); i++) {
                                try {
                                    searchDTO = (SearchDTO) authorList.get(i);
                                    logger.info("searching for user "
                                            + searchDTO.getLastName() + ", "
                                            + searchDTO.getFirstName());

                                    /*srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_PUBMED_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_FULL);*/
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }

                                    file = isMaxFileSize(file, fileMaxSize);

                                    /*srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_PUBMED_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_SEMI);*/
                                    file = isMaxFileSize(file, fileMaxSize);
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }
                                    /*aggregateSrchResult = filterOvidResults(
                                                     srchResult, aggregateSrchResult);*/
                                    srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_PUBMED_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_HALF);

                                    file = isMaxFileSize(file, fileMaxSize);

                                    /*aggregateSrchResult = filterOvidResults(
                                                     srchResult, aggregateSrchResult);*/
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }

                                    /*if (getTotalPublication(aggregateSrchResult) > 5000) {

                                        manager
                                                .populateUncommitedPublications(aggregateSrchResult);
                                        aggregateSrchResult = new ArrayList();
                                    }*/
                                    /*srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_EMBASE_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_FULL);*/

                                    file = isMaxFileSize(file, fileMaxSize);

                                    /*aggregateSrchResult = filterOvidResults(
                                                     srchResult, aggregateSrchResult);*/
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }
                                    /*srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_EMBASE_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_SEMI);*/

                                    file = isMaxFileSize(file, fileMaxSize);

                                    /*aggregateSrchResult = filterOvidResults(
                                                     srchResult, aggregateSrchResult);*/
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }
                                    srchResult = ovidClient
                                            .connect(
                                                    searchDTO,
                                                    OvidConstants.OVID_EMBASE_DATABASE,
                                                    OvidConstants.CONFIDENCE_FACTOR_HALF);
                                    file = isMaxFileSize(file, fileMaxSize);
                                    /*aggregateSrchResult = filterOvidResults(
                                                     srchResult, aggregateSrchResult);*/
                                    if (null != srchResult
                                            && srchResult.size() > 0) {
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        srchResult
                                                .remove(srchResult.size() - 1);
                                        aggregateSrchResult.add(srchResult);
                                    }

                                   /* if (getTotalPublication(aggregateSrchResult) > 5000) {*/
                                        if(aggregateSrchResult != null && aggregateSrchResult.size()>0) {
                                            manager.populateUncommitedPublications(aggregateSrchResult);
                                        }
                                        aggregateSrchResult = new ArrayList();
                                    //}

                                    // fail test condition
                                    /*
                                              * if(i == 3) throw new Exception("I forced
                                              * to fail");
                                              */
                                } catch (Exception e) {
                                    logger.info("Exception raised for expert "
                                            + searchDTO.getUserid());

                                    e.printStackTrace();
                                    /*
                                              * If the exception raised because of Target closed connection
                                              * search for that expert again.
                                              */
                                    if("Target closed connection".equalsIgnoreCase(e.getMessage())){
                                        i -= 1;
                                    } else {
                                        /*
                                                   * Remove all the publications of the
                                                   * expert who got exception
                                                   */
                                        aggregateSrchResult = removeExpertFromList(
                                                aggregateSrchResult, searchDTO
                                                        .getUserid(), 0);
                                        // Log the expert info into DB
                                        PubLogger pubLogger = new PubLogger(
                                                searchDTO.getUserid(), k);
                                        publicationsTimer.schedule(pubLogger, new Date());
                                    }
                                }
                            }// end of batch search

                            if (outputStream != null) {
                                outputStream.write("quit".getBytes());
                                outputStream.close();
                                outputStream = null;
                            }
                            if (process != null) {
                                process.destroy();
                                process = null;
                            }
                            if (ps != null){
                                ps.close();
                                ps = null;
                            }
                            if (fos != null){
                                fos.close();
                                fos = null;
                            }
                            /*if (aggregateSrchResult != null
                                    && aggregateSrchResult.size() > 0) {

                                manager
                                        .populateUncommitedPublications(aggregateSrchResult);
                            }*/

                            aggregateSrchResult = null;
                        }// batch loop
                    }// authors list not empty
                    manager.resetTimerState();
                    logger.info("finished execute capture "+new Date());
                } else {
                    //if the task is running, then cancel the new task
                    pubTask.cancel();
                }
            } catch (Exception e) {
                context.setAttribute("OVID_STATUS", "Done");

                try {
                    if (ps != null){
                        ps.close();
                        ps = null;
                    }
                    if (fos != null){
                        fos.close();
                        fos = null;
                    }
                } catch (IOException ioe) {

                }
                if (process != null){
                    process.destroy();
                    process = null;
                }
                logger.error("", e);
                e.printStackTrace(); // To change body of catch statement use
                // File | Settings | File Templates.
            }
            context.setAttribute("OVID_STATUS", "Done");
        }
        /**
         * This method will check for the log file size.
         * If it exceeds fileMaxSize (read from OvidConfig.properties),
         * close the current file and open a new file.
         *
         * @param file
         * @param fileMaxSize
         * @return String
         */
        private String isMaxFileSize(String file, int fileMaxSize) {
            String logFileName = file;
            try {
                if (fc != null && fc.size() > fileMaxSize) {
                    try {
                        fos.close();
                        fos = null;
                        ps.close();
                        ps = null;
                        File f = new File(file);
                        String fileName = f.getName();
                        int index = 0;
                        if (fileName.lastIndexOf("_") > 13) {
                            String s = fileName.charAt(fileName
                                    .lastIndexOf("_") + 1)
                                    + "";
                            index = Integer.parseInt(s) + 1;
                        }
                        logFileName = file.substring(0,
                                file.lastIndexOf("/") + 1)
                                + fileName.substring(0, fileName
                                        .lastIndexOf("."))
                                + "_"
                                + index
                                + ".log";
                        logger.info("new file name "+logFileName);
                        fos = new FileOutputStream(logFileName);
                        ps = new PrintStream(fos);
                        System.setOut(ps);
                        fc = fos.getChannel();
                    } catch (FileNotFoundException fe) {
                        fe.printStackTrace();
                    }
                }
            } catch (IOException io) {
                io.printStackTrace();
            }
            return logFileName;
        }
    }

    /**
     * @param srchResult
     * @param aggregateSrchResult
     * @return ArrayList
     */
    private ArrayList filterOvidResults(ArrayList srchResult,
                                        ArrayList aggregateSrchResult) {
        if (null != srchResult && srchResult.size() > 0) {
            ArrayList filteredResults = new ArrayList();
            srchResult.remove(srchResult.size() - 1);
            srchResult.remove(srchResult.size() - 1);
            if (aggregateSrchResult != null && aggregateSrchResult.size() > 0) {
                ArrayList findDuplicates = null;
                Publications publications = null;
                Publications publications1 = null;
                boolean tobeAdded = true;

                for (int s = 0; s < srchResult.size(); s++) {
                    tobeAdded = true;
                    publications1 = (Publications) srchResult.get(s);
                    for (int j = 0; j < aggregateSrchResult.size(); j++) {
                        if (!tobeAdded) {
                            break;
                        }
                        tobeAdded = true;
                        findDuplicates = (ArrayList) aggregateSrchResult.get(j);
                        if (findDuplicates != null && findDuplicates.size() > 0) {
                            for (int d = 0; d < findDuplicates.size(); d++) {
                                publications = (Publications) findDuplicates
                                        .get(d);
                                if (Integer.parseInt(publications1
                                        .getExpertId()) == Integer
                                        .parseInt(publications.getExpertId())
                                        && publications1.getUniqueIdentifier() == publications
                                                .getUniqueIdentifier()) {
                                    tobeAdded = false;
                                    break;
                                }
                                /*if (Integer.parseInt(publications1
                                                .getExpertId()) == Integer
                                                .parseInt(publications.getExpertId())
                                                && publications1.getTitle() != null
                                                && !"".equals(publications1.getTitle())
                                                && publications.getTitle() != null
                                                && !"".equals(publications.getTitle())
                                                && publications1.getTitle().trim()
                                                        .equalsIgnoreCase(
                                                                publications.getTitle()
                                                                        .trim())) {

                                            tobeAdded = false;
                                            break;
                                        }*/
                            }
                        }
                    }
                    if (tobeAdded) {
                        filteredResults.add(publications1);
                    }
                }
                findDuplicates = null;
            }
            if (aggregateSrchResult != null) {
                aggregateSrchResult.add(filteredResults);
            }
            filteredResults = null;
        }
        return aggregateSrchResult;
    }
    /**
     *
     * @param list
     * @param noOfExperts
     */
    private ArrayList getBatches(ArrayList list, int noOfExperts) {
        ArrayList resultList = new ArrayList();
        ArrayList tempList = new ArrayList();

        int counter = noOfExperts;
        if (list.size() <= counter) {
            resultList.add(list);
        } else {
            for (int i = 0; i < list.size();) {
                tempList = new ArrayList();
                counter = noOfExperts;
                counter += i;
                if (list.size() < counter)
                    counter = list.size();
                for (int j = i; j < counter; j++) {
                    tempList.add(list.get(j));
                    i++;
                }
                resultList.add(tempList);
            }
            tempList = null;
        }
        return resultList;
    }
    /**
     *
     * @param list
     * @param authorId
     * @param startIndex
     */
    private ArrayList removeExpertFromList(ArrayList list, int authorId,
                                           int startIndex) {
        ArrayList result = list;
        ArrayList tempList = null;
        Publications publications = null;
        for (int i = startIndex; i < list.size(); i++) {
            tempList = (ArrayList) list.get(i);
            for (int j = 0; j < tempList.size(); j++) {
                publications = (Publications) tempList.get(j);
                if (authorId == Integer.parseInt(publications.getExpertId())) {
                    ((ArrayList) result.get(i)).remove(j);
                    removeExpertFromList(result, authorId, i);
                }
            }
            tempList = null;
        }

        return result;
    }
    /**
     *
     * @param aggregateList
     */
    private int getTotalPublication(ArrayList aggregateList) {
        int result = 0;
        if (aggregateList != null) {
            ArrayList tempList = null;
            for (int i = 0; i < aggregateList.size(); i++) {
                tempList = (ArrayList) aggregateList.get(i);
                result += tempList.size();
            }
            tempList = null;
        }
        return result;
    }
}

class PubLogger extends TimerTask {
	int authorId;

	int build;

	PubLogger(int authorId, int build) {
		this.authorId = authorId;
		this.build = build;
	}

	public void run() {
		PublicationsManager manager = new PublicationsManager();
		manager.logPubException(authorId, build);
	}
}

