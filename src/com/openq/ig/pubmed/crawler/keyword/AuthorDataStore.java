
package com.openq.ig.pubmed.crawler.keyword;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.openq.expertdna.ig.pubmed.Author;
import com.openq.utils.StringUtil;

/**
 * This class is used to maintain specific details about various authors who have writter publications related
 * to the keyword for which a PubmedCrawl is spawned
 *
 * @author Amit Arora
 */
public class AuthorDataStore {
    private static Logger logger = Logger.getLogger(AuthorDataStore.class);

    private static final String NETWORK_MAP_XML_FILE_PATH = "/applet/dummy_kol.xml";


    /* A Hashmap of author name to another hashmap
     * The second map would map the co-authors to the strength
     * of the relationship
     */
    private TreeMap authorsMap;

    private HashMap authorPubCountMap;

    private Document dom = null;

    private ArrayList authorDetailsSortedOnPubCount = null;

    public AuthorDataStore() {
        authorsMap = new TreeMap();
        authorPubCountMap = new HashMap();
    }

      public void finalize(){
        authorsMap.clear();
        authorPubCountMap.clear();
    }

    public synchronized void parseAndRecordAuthorRelations(ArrayList authorList, ArrayList qualifiersList) {
        // now create entries for each author in the HashMap
        for(int i=0; i<authorList.size(); i++) {
            Author author = (Author) authorList.get(i);
            String authorName = author.getLastNameAndFirstInitials();

            // Do not record data if the author name is empty
            if(!StringUtil.isEmptyString(authorName)) {
                // First record this count towards total num of pubs for this author
                // Also record the list of qualifiers
                AuthorDetails authDetails = (AuthorDetails) authorPubCountMap.get(authorName);
                if(authDetails == null) {
                    authDetails = new AuthorDetails(new ArrayList(), 0, authorName);
                    authorPubCountMap.put(authorName, authDetails);
                }

                // increment the count
                authDetails.incrementPubCount();

                // merge the qualifier lists into the existing qualifier list for author, keeping a max of 5
                mergeLists(authDetails.getMedicalfocus(), qualifiersList, 5);


                // Now process the list of co-authors
                HashMap coauthorMap = (HashMap) authorsMap.get(authorName);
                if(coauthorMap == null) {
                    coauthorMap = new HashMap();
                    authorsMap.put(authorName, coauthorMap);
                }

                // Insert/update entries corresponding to all the co-authors
                for(int j=0; j<authorList.size(); j++) {
                    // check that we shouldn't make an entry for the author himself
                    if(j != i) {
                        Author coauthor = (Author) authorList.get(j);
                        String coauthorName = coauthor.getLastNameAndFirstInitials();

                        // Do not record data if the co-author name is empty
                        if(!StringUtil.isEmptyString(coauthorName)) {
                            // Do not make an entry if the reverse entry is already there
                            boolean flag = isReverseEntryThere(authorName, coauthorName);

                            if(!flag) {
                                Integer relationStrength = (Integer) coauthorMap.get(coauthorName);
                                int strength = 0;

                                // check if the two authors have any existing entry
                                if(relationStrength != null) {
                                    strength = relationStrength.intValue();
                                }

                                //increment the strength to account for this entry
                                strength++;

                                // store the new strength in the co-author map
                                coauthorMap.put(coauthorName, new Integer(strength));
                            }
                        }
                    }
                }
            }
        }

    }

    private boolean isReverseEntryThere(String authorName, String coauthorName) {
        boolean retVal = false;

        HashMap map = (HashMap) authorsMap.get(coauthorName);
        if(map != null) {
            if(map.get(authorName) != null) {
                retVal = true;
            }
        }

        return retVal;
    }


    private void printAllNodes(Element rootEle) {

        HashMap duplicates = new HashMap();
        authorDetailsSortedOnPubCount = new ArrayList(authorPubCountMap.values());
        Collections.sort(authorDetailsSortedOnPubCount);
        Iterator iter = authorDetailsSortedOnPubCount.iterator();
        int size = 10; int counter = 0;
        while(iter.hasNext() && counter++ < size )  {
            AuthorDetails authDetailsfromPubCount = (AuthorDetails) iter.next();
            String author =   authDetailsfromPubCount.getAuthorName();
            if ( duplicates.get(author) == null )
            {
                duplicates.put(author,author);
                printNode(author, rootEle);
                HashMap coauthorMap = (HashMap) authorsMap.get(author);

                Iterator coauthorIter = coauthorMap.keySet().iterator();
                while(coauthorIter.hasNext()) {
                    String coauthor = (String) coauthorIter.next();
                    if ( duplicates.get(coauthor) == null )
                    {
                        duplicates.put(coauthor,coauthor);
                        printNode(coauthor, rootEle);
                    }
                }

            }
        }
    }

    private void printNode(String author, Element rootEle)
    {
            /*"node full-image=\"http://aarora:7351/webapp/photos/noimage.jpg\" " +
            "icon-image=\"doctor.png\" display-mode=\"Label\" color=\"#299EDE\" font-size=\"8\" " +
            "label=\"<<doctor_name>>\" id=\"<<doctor_name>>\" url=\"http://aarora:7351/webapp/photos/noimage.jpg\">" +*/

            Element nodeEle = dom.createElement("node");
            nodeEle.setAttribute("full-image", "photos/noimage.jpg");
            nodeEle.setAttribute("icon-image", "doctor.png");
            nodeEle.setAttribute("displaymode", "Label");
            nodeEle.setAttribute("color", "#299EDE");
            nodeEle.setAttribute("font-size", "8");
            nodeEle.setAttribute("label", author);
            nodeEle.setAttribute("id", author);
            nodeEle.setAttribute("url", "photos/noimage.jpg");

            rootEle.appendChild(nodeEle);

            // Create a hash-map to print relevant properties for this author
            HashMap propsMap = new HashMap();
            AuthorDetails authDetails = (AuthorDetails)authorPubCountMap.get(author);
            propsMap.put("Publication Count", "" + authDetails.getPubCount());
            propsMap.put("Medical Focus", listToString(authDetails.getMedicalfocus()));

            // print the props for this doctor node
            printMetaTags(propsMap, nodeEle);
    }


    private void mergeLists(ArrayList l1, ArrayList l2, int maxSize) {
        // first check if the size of list l1 is already greater than maxSize.
        // if so, do nothing
        if(l1.size() < maxSize) {
            // find out how many entries we need to add from l2
            int totalRemaining = maxSize - l1.size();
            int numEntriesToMove = (totalRemaining > l2.size() ? l2.size() : totalRemaining);
            for(int i=0; i<numEntriesToMove; i++) {
                l1.add(l2.get(i));
            }
        }
    }

    private String listToString(ArrayList list) {
        StringBuffer buff = new StringBuffer();
        for(int i=0; i<list.size(); i++) {
            buff.append(list.get(i));

            if(i != (list.size() - 1))
                buff.append(", ");
        }

        return buff.toString();
    }

    private void printMetaTags(HashMap props, Element parent) {
        Iterator iter = props.keySet().iterator();
        while(iter.hasNext()) {
            String prop = (String) iter.next();
            String val = (String) props.get(prop);

            Element metaEle = dom.createElement("meta");
            metaEle.setAttribute("name", prop);
            metaEle.setAttribute("value", val);

            parent.appendChild(metaEle);
        }
    }

    private void printAllEdges(Element rootEle) {

        Iterator iter = authorDetailsSortedOnPubCount.iterator();
        int size = 10; int counter = 0;
        while(iter.hasNext() && counter++ < size )  {

            AuthorDetails authDetailsfromPubCount = (AuthorDetails) iter.next();
            String author =   authDetailsfromPubCount.getAuthorName();
            HashMap coauthorMap = (HashMap) authorsMap.get(author);
            
            Iterator coauthorIter = coauthorMap.keySet().iterator();
            while(coauthorIter.hasNext()) {
                String coauthor = (String) coauthorIter.next();
                Integer relationStrength = (Integer) coauthorMap.get(coauthor);
                
                /*"<edge start=\"<<author_name>>\" end=\"<<coauthor_name>>\" width=\"4\" " +
                "length=\"2240\" color=\"#A00000\">"*/
                
                Element edgeEle = dom.createElement("edge");
                edgeEle.setAttribute("start", author);
                edgeEle.setAttribute("end", coauthor);
                edgeEle.setAttribute("width", relationStrength + "");
                edgeEle.setAttribute("length", "2240");
                edgeEle.setAttribute("color", "#A00000");
                edgeEle.setAttribute("arrow", "none");
            
                rootEle.appendChild(edgeEle);
                
                // now print the meta tags for this edge
                HashMap propsMap = new HashMap();
                propsMap.put("Connection Type", "Publication");
                propsMap.put("Connection Strength", relationStrength + " Instances");
                
                printMetaTags(propsMap, edgeEle);
            }
        }
    }
    
    public synchronized void printMapToFile(String webappDir) {
        FileOutputStream fos = null;
        
        try {
            // Create the xml document
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            try {
                //get an instance of builder
                DocumentBuilder db = dbf.newDocumentBuilder();

                //create an instance of DOM
                dom = db.newDocument();

            }
            catch(ParserConfigurationException pce) {
                    //dump it
                    System.out.println("Error while trying to instantiate DocumentBuilder " + pce);
                    throw new IllegalStateException(pce.getMessage());
            }
            
            // Create the root node for the document
            Element rootEle = dom.createElement("graph");
            dom.appendChild(rootEle);
            
            // print all the nodes
            logger.debug("Printing all nodes");
            printAllNodes(rootEle);
            
            // print all the edges
            logger.debug("Printing all edges");
            printAllEdges(rootEle);
            
            OutputFormat format = new OutputFormat(dom);
            format.setIndenting(true);

            //to generate output to console use this serializer
            //XMLSerializer serializer = new XMLSerializer(System.out, format);

            String filePath = webappDir + NETWORK_MAP_XML_FILE_PATH;

            System.out.println("Serializing XML to : '" + filePath + "'");
            
            //to generate a file output use fileoutputstream instead of system.out
            fos = new FileOutputStream(new File(filePath));
            XMLSerializer serializer = new XMLSerializer(fos, format);

            serializer.serialize(dom);
            
            serializer = null;
        }
        catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        finally {
            if(fos != null) {
                try {
                    fos.close();
                }
                catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
    }
    
    public synchronized void storeResultsInDB(INetworkMapDataService networkMapDataService) {
        networkMapDataService.storeKeywordCrawlResults(authorPubCountMap);
    }
    
    
}
