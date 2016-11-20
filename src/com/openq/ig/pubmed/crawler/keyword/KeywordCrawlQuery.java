/*
 * PubMedQuery
 *
 * Feb 28, 2006
 *
 * Copyright (C) Unpublished openQ. All rights reserved.
 * openQ, Confidential and Proprietary.
 * This software is subject to copyright protection
 * under the laws of the United States and other countries.
 * Unauthorized reproduction and/or distribution is strictly prohibited.
 * Unless otherwise explicitly stated, this software is provided
 * by openQ "AS IS".
 */
package com.openq.ig.pubmed.crawler.keyword;

import gov.nih.nlm.ncbi.efetch_eutils.EFetchPubmedServiceLocator;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.ArticleType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.AuthorListType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.AuthorType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.EFetchRequest;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.EFetchResult;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.MeshHeadingListType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.MeshHeadingType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.PubmedArticleSet;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.PubmedArticleType;
import gov.nih.nlm.ncbi.efetch_eutils.efetch_pubmed.QualifierNameType;
import gov.nih.nlm.ncbi.www.soap.eutils.EUtilsServiceLocator;
import gov.nih.nlm.ncbi.www.soap.eutils.EUtilsServiceSoap;
import gov.nih.nlm.ncbi.www.soap.eutils.esearch.ESearchRequest;
import gov.nih.nlm.ncbi.www.soap.eutils.esearch.ESearchResult;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.rmi.RemoteException;
import java.util.ArrayList;

import javax.xml.rpc.ServiceException;

import org.apache.log4j.Logger;

import com.openq.expertdna.ig.IGException;
import com.openq.expertdna.ig.pubmed.Author;

/**
 * This class provides routines to search PunMed for matching artile
 * 
 * @author Amit Arora
 */
public class KeywordCrawlQuery {
	public static final String EUTILS_URL = "http://eutils.ncbi.nlm.nih.gov";
	public static final String TOOL = "openqpm";
	public static final String EMAIL = "grahamh@openq.com";

    private static final int MAX_FETCHER_THREADS = 5; // number of threads to fetch results in parallel
	private static final int FETCH_BATCH_SIZE = 50; // To keep memory requirements low, we will fetch the publications in batches
	
	private static Logger logger = Logger.getLogger(KeywordCrawlQuery.class);
	private EUtilsServiceSoap utils;
    
    private INetworkMapDataService networkMapDataService;
    private String webappDir;
    private AuthorDataStore authorDataStore;
	
	public KeywordCrawlQuery(INetworkMapDataService nmDService, String webappDir) throws ServiceException {
		EUtilsServiceLocator service = new EUtilsServiceLocator();
		this.utils = service.geteUtilsServiceSoap();
		
        this.authorDataStore = new AuthorDataStore();
        
        this.networkMapDataService = nmDService;
        this.webappDir = webappDir;
	}



	public void finalize(){      
        this.authorDataStore.finalize();
        this.authorDataStore = null;
	}

    public void findMatchingArticles(String searchTerm, int relativeDayCount) throws IGException {
		try {
			//ArrayList articles = new ArrayList();
			logger.info("Running query: '" + searchTerm + "'");
            
			String urlEncodedSearchTerm = URLEncoder.encode(searchTerm, "UTF-8");

			ESearchRequest parameters = new ESearchRequest();
			parameters.setDb("pubmed");
			parameters.setTerm(urlEncodedSearchTerm);
			if(relativeDayCount > 0) {
				parameters.setReldate(Integer.toString(relativeDayCount));
			}
			parameters.setEmail(EMAIL);
			parameters.setTool(TOOL);
			parameters.setUsehistory("y");
			parameters.setSort("pub+date");
			
			ESearchResult res = null;
			res = utils.run_eSearch(parameters);
			
			// Fetch the results if the search found any matches
			if(Integer.parseInt(res.getCount()) > 0) {
				int numResults = Integer.parseInt(res.getCount());
          
                if (  numResults > 1000 ) numResults = 1000;                
                
                System.out.println("Got a total of : " + numResults + " matching results for the query : '" + searchTerm + "'");

				String queryKey = res.getQueryKey();
				String webEnv = res.getWebEnv();

                // Calculate the number of threads needed
                int numThreads = 1;

                /*if((numResults / FETCH_BATCH_SIZE) > MAX_FETCHER_THREADS)
                    numThreads = MAX_FETCHER_THREADS;
                else
                    numThreads = (int) Math.ceil((double)numResults / (double)FETCH_BATCH_SIZE);*/

                ArticleFetcherThread[] fetchThreads = new ArticleFetcherThread[numThreads];

                // Divide the overall fetch results equally into all threads
                int threadWorkLoadCount = (int) Math.ceil((double)numResults / numThreads);

                logger.debug("Spawning : " + numThreads + " fetcher threads, each having a workload of approx : "
                    + threadWorkLoadCount + " articles");

                int startIndex = 0;

                // Spawn the relevant number of threads
				for(int i=0; i<numThreads; i++) {
                    fetchThreads[i] = new ArticleFetcherThread(i, queryKey, webEnv, startIndex, startIndex + threadWorkLoadCount);

                    // increment the start index for the next thread
                    startIndex += threadWorkLoadCount;

                    fetchThreads[i].start();
                }

                for(int j=0; j<numThreads; j++) {
                    try {
                        fetchThreads[j].join();
                    }
                    catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                        logger.error(e);
                    }
                }

                // Now print all nodes and edges from the data store
                logger.debug("All threads ended - printing results to a file");
                authorDataStore.printMapToFile(webappDir);
                authorDataStore.storeResultsInDB(networkMapDataService);
            }

		} catch (RemoteException re) {
			throw new IGException(re.getMessage(), re);
		} catch (UnsupportedEncodingException e) {
			throw new IGException(e.getMessage(), e);
		}
	}


    private class ArticleFetcherThread extends Thread {
        long threadId;
        String queryKey;
        String webEnv;
        long startIndex;
        long endIndex;


        ArticleFetcherThread(long id, String queryKey, String webEnv, long startIndex, long endIndex) {
            this.threadId = id;
            this.queryKey = queryKey;
            this.webEnv = webEnv;
            this.startIndex = startIndex;
            this.endIndex = endIndex;

            logger.debug("Thread : " + threadId + " will fetch results from : " + startIndex + " to " + endIndex);
        }

        public void run() {

            // Now fetch the articles between startIndex and endIndex in batches
            for(long index = startIndex; index < endIndex; index+=FETCH_BATCH_SIZE) {
                long startTime = System.currentTimeMillis();

                EFetchRequest fetchReq = new EFetchRequest();
                //fetchReq.setDb("pubmed");
                fetchReq.setEmail(EMAIL);
                fetchReq.setQuery_key(queryKey);
                fetchReq.setWebEnv(webEnv);
                fetchReq.setTool(TOOL);
                fetchReq.setRetstart("" + index);

                // calculate what the end index should be
                long remaining = endIndex - startIndex;
                long batchSize;
                if(remaining > FETCH_BATCH_SIZE) {
                    batchSize = FETCH_BATCH_SIZE;
                }
                else {
                    batchSize = remaining;
                }

                fetchReq.setRetmax("" + batchSize);

                EFetchResult fetchResults = null;
                try {                	
                    EFetchPubmedServiceLocator service = new EFetchPubmedServiceLocator();
                    gov.nih.nlm.ncbi.efetch_eutils.EUtilsServiceSoap utils1 = service.geteUtilsServiceSoap();
                    fetchResults = utils1.run_eFetch(fetchReq);

                    PubmedArticleSet type = fetchResults.getPubmedArticleSet();
                    PubmedArticleType[] articleTypes = type.getPubmedArticle();
                    for (int i = 0; i < articleTypes.length; i++) {
                        PubmedArticleType articleType = articleTypes[i];

                        //Parse and record the author's data
                        parseAndRecordAuthorData(articleType);
                    }
                }
                catch(Exception e) {
                    logger.error(e);
                    e.printStackTrace();
                }
                finally {
                    long endTime = System.currentTimeMillis();
                    logger.debug("Thread : " + threadId + " took: " + (endTime - startTime) + " ms for the batch at index " + index);

                    if(fetchResults != null) {
                        fetchResults = null;
                    }
                }
            }
        }

        private void parseAndRecordAuthorData(PubmedArticleType articleType) {
            if (articleType.getMedlineCitation() != null) {
                if (articleType.getMedlineCitation().getArticle() != null) {
                    ArticleType articleData = articleType.getMedlineCitation().getArticle();

                    ArrayList authors = new ArrayList();
                    if (articleData.getAuthorList() != null) {

                        AuthorListType authorList = articleData.getAuthorList();
                        AuthorType[] authorTypeArray = authorList.getAuthor();
                        for (int i = 0; i < authorTypeArray.length; i++) {
                            AuthorType authorType = authorTypeArray[i];
                            Author author = new Author();
                            if (authorType.getForeName() != null) {
                                author.setFirstName(new String(authorType.getForeName()));
                            }
                            else if(authorType.getForeName() != null) {
                                author.setFirstName(new String(authorType.getForeName()));
                            }

                            if(authorType.getLastName() != null)
                                author.setLastName(new String(authorType.getLastName()));

                            if(authorType.getInitials() != null)
                                author.setInitials(new String(authorType.getInitials()));

                            if(author.getFirstName() == null) author.setFirstName("");
                            if(author.getLastName() == null) author.setLastName("");
                            if(author.getFirstInitial() == null) author.setFirstInitial("");

                            authors.add(author);
                        }

                        // TODO: Remove this call which is just for debugging purposes
                        printAuthorList(authors, articleType.getMedlineCitation().getPMID());
                    }

                    // Extract the mesh headings
                    MeshHeadingListType meshHeadingList = articleType.getMedlineCitation().getMeshHeadingList();
                    ArrayList qualifiersList = new ArrayList();
                    if (meshHeadingList != null)
                    {
                        MeshHeadingType[] meshHeadingListType = meshHeadingList.getMeshHeading();
                        for (int i = 0; i < meshHeadingListType.length; i++) {

                            MeshHeadingType meshHeading = meshHeadingListType[i];
                            QualifierNameType[] qualifiers = meshHeading.getQualifierName();

                            for (int j = 0; qualifiers != null && j < qualifiers.length; j++) {
                                QualifierNameType qualifier = qualifiers[j];
                                String qualifierVal = qualifier.get_value();

                                if(qualifierVal != null)
                                    qualifiersList.add(new String(qualifierVal));
                            }
                        }
                    }
                    
                    // Make a call to the AuthorDataStore to record the author's data
                    authorDataStore.parseAndRecordAuthorRelations(authors, qualifiersList);
                }
            }
        }
        
        private void printAuthorList(ArrayList authors, String pmId) {
            StringBuffer buff = new StringBuffer();
            buff.append(pmId).append(": ");
            for(int i=0; i<authors.size(); i++) {
                buff.append(((Author)authors.get(i)).getLastNameAndFirstInitials()).append(", ");
            }
            
            logger.debug(buff.toString());
        }
    }


    public INetworkMapDataService getNetworkMapDataService() {
        return networkMapDataService;
    }

    public void setNetworkMapDataService(INetworkMapDataService networkMapDataService) {
        this.networkMapDataService = networkMapDataService;
    }
}
