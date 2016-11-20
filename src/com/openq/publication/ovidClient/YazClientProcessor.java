package com.openq.publication.ovidClient;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import com.openq.kol.DBUtil;
import com.openq.publication.ovidClient.YazClientConstants;
import com.openq.publication.data.CmaPubOl;
import com.openq.publication.data.OlPublicationSummaryDTO;
import com.openq.publication.data.OlTotalPubs;
import com.openq.publication.data.OvidDb;
import com.openq.publication.data.Publications;
import com.openq.publication.data.Request;
import com.openq.user.User;

public class YazClientProcessor extends Thread {

	OvidClient ovidClient;

	private Process process = null;

	private OutputStream stream = null;

	boolean keepProcessing;

	private String firstName;

	private String middleName;

	private String lastName;

	private String institution;

	private int userId = 0;

	private String specialty = null;

	private int resultConfidenceFactor = 0;

	private String authorName = "";

	private StringBuffer checkNameBuff = new StringBuffer();

	private String queryStr = "";

	private boolean packetDump = false;

	private int nHt = -1;

	private String numberOfHits = null;

	Calendar today = Calendar.getInstance();

	int curYear = today.get(Calendar.YEAR);

	int pubYear = 0;

	OvidDb[] ovidDbs;

	OlTotalPubs olTotalPublication;

	String lastSearchYear;

	private Hashtable olPublicationsHashOnIssn;

	boolean addOltotalPubs;

	OlPublicationSummaryDTO olPublicationSummaryDTO;

	YazClientProcessor() {
		this.setPriority(Thread.MIN_PRIORITY);

	}

	YazClientProcessor(OvidClient ovidClient) {
		this.setPriority(Thread.MIN_PRIORITY);
		this.setOvidClient(ovidClient);

	}

	public OvidClient getOvidClient() {
		return ovidClient;
	}

	public void run() {
		boolean queueEndTime = true;
		while (keepProcessing) {

			ArrayList requestList = new ArrayList();
			try {

				// get the request list
				requestList.addAll(ovidClient.getRequestList());
				ovidClient.getRequestList().clear();
				// get Ovid DataSources
				ovidDbs = ovidClient.ovidDbService.getAllOvidDataSource();
				yazClientConnection(process, stream);
				Thread.sleep(10);
				queueEndTime = requestList.size() > 0;
				for (int i = 0; i < requestList.size(); i++) {

					try {
						// search n save user publications
						searchOlPub((User) requestList.get(i));
						// searchNSaveOlPub((CmaPubOl)requestList.get(i));
					} catch (Exception e) {
						e.printStackTrace();
						if ("Target closed connection".equalsIgnoreCase(e
								.getMessage()))
							throw e;
					}
				}
				if (queueEndTime) {
					today = Calendar.getInstance();
					Request requestCaptureStatus = ovidClient.requestService
							.getCaptureStatus(ovidClient.currentUserId);
					requestCaptureStatus.setRequestCompeleted(today.getTime());
					requestCaptureStatus.setStatus("Request Compeleted ");
					ovidClient.requestService
							.updateCaptureStatus(requestCaptureStatus);
				}

				System.out.println("Process Over at " + today.getTime()
						+ requestList.size()
						+ " Ols updated rechecking in 1 min");
				Thread.sleep(60000);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return;
	}

	/*
	 * private void closeYazClientConeection() { try { stream .write(("\n" +
	 * YazClientConstants.CLOSE_CONNECTION_URL + "\n" + "\n").getBytes());
	 * stream.write((YazClientConstants.EXIT_OVID + "\n" + "\n ") .getBytes());
	 * stream.flush(); } catch (IOException e) { e.printStackTrace(); } process =
	 * null; stream = null; }
	 */

	public void searchOlPub(User user) {
		boolean flagSkip = false;

		StringBuffer db = new StringBuffer();
		String databaseNames;
		// Set Author Name, cache olTotalPubs
		authorName = ovidClient.userService.getUserName(user);

		olTotalPublication = (OlTotalPubs) ovidClient.hashAllOlTotalPubs
				.get(new Long(user.getId()));

		// for result display table
		olPublicationSummaryDTO = (OlPublicationSummaryDTO) ovidClient.olPubSummaryService
				.getOlPubSummary(user.getId());

		if (olTotalPublication != null)
			lastSearchYear = String.valueOf(olTotalPublication
					.getLastSearchYear());
		else
			lastSearchYear = null;
		// get db from database loop db list from database and append in db
		for (int i = 0; i < ovidDbs.length; i++) {
			if (i == 0)
				db.append(YazClientConstants.OVID_BASE).append(" ").append(
						ovidDbs[i].getOvidDatabaseName());
			else
				db.append(",").append(ovidDbs[i].getOvidDatabaseName());
		}
		databaseNames = db.toString();

		// send this to YAZ Console
		try {
			stream.write((databaseNames + "\n").getBytes());
			stream
					.write((YazClientConstants.OVID_DISPLAY_FORMAT + "\n" + "\n ")
							.getBytes());
			stream.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// queryformulatoin
		queryFormulation(true, user.getId());
		System.out.println("queryStr = " + queryStr);

		try {
			// execute it on yaz
			executeQuery();
			// Check if results are already up to date, skip
			flagSkip = checkSkip(true, user.getId());
		} catch (Exception e) {
			e.printStackTrace();
		}

		// if skip true, then return
		if (flagSkip) {
			System.out.println("\n No new updates for this OL !");
			return;
		}
		flagSkip = false;

		queryFormulation(false, user.getId());
		System.out.println(" New updates found...updating Profile Pubs");
		System.out.println("queryStr = " + queryStr);
		try {
			// execute it on yaz
			executeQuery();
			flagSkip = checkSkip(false, user.getId());
			stream.write((YazClientConstants.OVID_DISPLAY_RESULTS + "\n")
					.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}

		// if (packetDump && nHt != -1) {
		for (int nh = 1; nh <= nHt; nh++) {
			try {
				stream.write(("show " + nh + "\n").getBytes());
				stream.flush();
				parseOlPublications(user.getId());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		updateAndPersistDetails(user.getId());
		// packetDump = false;
		// }

		return;
	}

	private void updateAndPersistDetails(long userId) {
		// some publications without ISSN are already persisted at t time of
		// creations
		ArrayList olAllPublications = new ArrayList();
		olAllPublications.addAll(olPublicationsHashOnIssn.values());

		for (int i = 0; i < olAllPublications.size(); i++)
			ovidClient.publicationsService
					.addpublication((Publications) olAllPublications.get(i));
		// for No of Hits = 0 its already persisted
		if (addOltotalPubs)
			ovidClient.olTotalPubsService.addTotalPubs(olTotalPublication);
		else
			ovidClient.olTotalPubsService.updateTotalPubs(olTotalPublication);

		if (olPublicationSummaryDTO != null) {
			olPublicationSummaryDTO.setLastCapture(today.getTime());
			olPublicationSummaryDTO
					.setNewPublications(olAllPublications.size());
			int totaluncommitpubs = 0;
			totaluncommitpubs = olPublicationSummaryDTO
					.getTotalUncommitedPublications()
					+ olAllPublications.size();
			olPublicationSummaryDTO
					.setTotalUncommitedPublications(totaluncommitpubs);
			ovidClient.olPubSummaryService
					.updateOlSummary(olPublicationSummaryDTO);
		} else {
			olPublicationSummaryDTO = new OlPublicationSummaryDTO();
			olPublicationSummaryDTO.setExpertId(userId);
			olPublicationSummaryDTO.setExpertName(authorName);
			olPublicationSummaryDTO.setLastCapture(today.getTime());
			olPublicationSummaryDTO
					.setNewPublications(olAllPublications.size());
			olPublicationSummaryDTO
					.setTotalUncommitedPublications(olAllPublications.size());
			ovidClient.olPubSummaryService
					.addOlSummary(olPublicationSummaryDTO);
		}

	}

	private boolean checkSkip(boolean flagFirstQuery, long userId)
			throws Exception {
		String inputData = null;
		InputStream input = process.getInputStream();
		BufferedReader in = new BufferedReader(new InputStreamReader(input));
		boolean flagSkip = false;

		while ((inputData = in.readLine()) != null) {
			/*
			 * If yaz-client returns "Target closed connection", throw an
			 * exception
			 */
			if ("Target closed connection".equalsIgnoreCase(inputData.trim())) {
				throw new Exception(inputData.trim());
			}

			if (inputData.indexOf(YazClientConstants.NUMBER_OF_HITS) != -1) {
				numberOfHits = inputData.substring(inputData.indexOf(":") + 1,
						inputData.indexOf(","));
				if (numberOfHits != null && !"".equals(numberOfHits)) {
					nHt = Integer.parseInt(numberOfHits.trim());
					System.out.println(" \n NHT " + nHt + "  " + inputData);

					if (olTotalPublication != null
							&& olTotalPublication.getTotalPublications() == nHt)
						flagSkip = true;
					else // if not update db
					{
						if (olTotalPublication == null) {
							olTotalPublication = new OlTotalPubs();
							addOltotalPubs = true;
						}
						if (flagFirstQuery) {
							olTotalPublication.setTotalPublications(nHt);
							olTotalPublication.setAuthorId(userId);
							olTotalPublication.setLastSearchYear(curYear);
						}

					}
					if (nHt == 0) {
						flagSkip = true;
						if (addOltotalPubs)
							ovidClient.olTotalPubsService
									.addTotalPubs(olTotalPublication);
						else
							ovidClient.olTotalPubsService
									.updateTotalPubs(olTotalPublication);
					}

					break;
				}
			}

		}
		return flagSkip;
	}

	public void queryFormulation(boolean flag, long authorId) {
		StringBuffer queryBuffer = new StringBuffer();
		if (flag == true) {
			// Qyery Fomulation 1st Time
			queryBuffer.append(YazClientConstants.QUERY_STR0);
			queryBuffer.append(YazClientConstants.QUERY_STR2).append(
					YazClientConstants.NAME_ATTRIBUTE).append("\"").append(
					authorName).append("\"");
			queryStr = queryBuffer.toString();
			olPublicationsHashOnIssn = new Hashtable();
		} else {
			if (lastSearchYear != null) {
				olPublicationsHashOnIssn = new Hashtable();
				olPublicationsHashOnIssn = ovidClient.publicationsService
						.deleteOlPublicationsOfYearHashedOnISSN(authorId,
								olTotalPublication.getLastSearchYear());

				queryBuffer.append(YazClientConstants.QUERY_STR0);
				queryBuffer.append(YazClientConstants.QUERY_STR1).append(
						YazClientConstants.QUERY_STR2).append(
						YazClientConstants.NAME_ATTRIBUTE).append("\"").append(
						authorName).append("\"");
				queryBuffer.append(" ").append(YazClientConstants.QUERY_STR2)
						.append(YazClientConstants.YEAR_ATTRIBUTE).append(" ")
						.append(lastSearchYear);
				queryStr = queryBuffer.toString();
			} else {
				olPublicationsHashOnIssn = new Hashtable();
				queryFormulation(true, authorId);
			}
		}
	}

	private void executeQuery() throws Exception {
		stream.write(queryStr.getBytes());
		stream.write("\n".getBytes());
		stream
				.write((YazClientConstants.OVID_DISPLAY_FORMAT + "\n")
						.getBytes());
		stream.flush();
	}

	public void yazClientConnection(Process process, OutputStream stream) {

		Runtime runtime = Runtime.getRuntime();
		String yazClientLocation = null;
		String authenticationParam = null;
		String connectionURL = null;
		String connectionPort = null;

		try {
			Properties props = DBUtil.getInstance().getDataFromPropertiesFile(
					"resources/OvidConfig.properties");
			yazClientLocation = props.getProperty("yaz.client.location");
			authenticationParam = props.getProperty("authentication.param");
			connectionURL = props.getProperty("connection.url");
			connectionPort = props.getProperty("connection.port");

			if (process != null) {
				this.process = process;
			} else {
				this.process = runtime.exec(yazClientLocation);
			}
			if (stream != null) {
				this.stream = stream;
			} else {
				if (this.process != null) {
					this.stream = this.process.getOutputStream();
					this.stream.write((authenticationParam + "\n").getBytes());
					this.stream
							.write((connectionURL + ":" + connectionPort + "\n")
									.getBytes());
					this.stream.write("set_auto_reconnect on\n".getBytes());
					this.stream.flush();
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void setOvidClient(OvidClient ovidClient) {
		this.ovidClient = ovidClient;
	}

	public boolean isKeepProcessing() {
		return keepProcessing;
	}

	public void setKeepProcessing(boolean keepProcessing) {
		this.keepProcessing = keepProcessing;
	}

	public void parseOlPublications(long userId) throws Exception {
		String inputData = null;
		String commonFlag = "";
		int counter = 0;

		InputStream input = process.getInputStream();
		BufferedReader in = new BufferedReader(new InputStreamReader(input));
		StringBuffer authorFullNames = new StringBuffer("");
		StringBuffer authors = new StringBuffer("");
		StringBuffer abstractName = new StringBuffer("");
		StringBuffer titleBuff = new StringBuffer("");
		StringBuffer journalName = new StringBuffer("");

		Publications publication = new Publications();
		publication.setAuthorId(userId);
		publication.setCreateTime(today.getTime());

		while ((inputData = in.readLine()) != null) {
			/*
			 * If yaz-client returns "Target closed connection",
			 */

			if ("Target closed connection".equalsIgnoreCase(inputData.trim())) {
				throw new Exception(inputData.trim());
			}
			if (inputData.indexOf(YazClientConstants.NUMBER_OF_HITS) != -1) {
				numberOfHits = inputData.substring(inputData.indexOf(":") + 1,
						inputData.indexOf(","));
				if (numberOfHits != null && !"".equals(numberOfHits)) {
					nHt = Integer.parseInt(numberOfHits.trim());
				}
			}

			if (inputData.indexOf(YazClientConstants.NEXT_RESULT_POSITION) != -1
					|| inputData.equalsIgnoreCase("Packet dump:")) {
				if (inputData.equalsIgnoreCase("Packet dump:")) {
					packetDump = true;
				}
				break;
			}

			boolean flag = false;

			if (commonFlag.equals(YazClientConstants.UNIQUE_IDENTIFIER)) {
				commonFlag = "";
				publication.setUniqueId(Long.parseLong(inputData.trim()));

			} else if (commonFlag.equals(YazClientConstants.ACCESSION_NUMBER)) {
				commonFlag = "";
				publication.setUniqueId(Long.parseLong(inputData.trim()));

			} else if (commonFlag.equals(YazClientConstants.AUTHORS)) {
				authors.append(inputData).append(",");

			} else if (commonFlag.equals(YazClientConstants.AUTHOR_FULL_NAME)) {
				authorFullNames.append(inputData);

			} else if (commonFlag.equals(YazClientConstants.INSTITUTION)) {
				commonFlag = "";
				publication.setInstitution(inputData);

			} else if (commonFlag.equals(YazClientConstants.TITLE)) {
				titleBuff.append(inputData);

			} else if (commonFlag.equals(YazClientConstants.SOURCE)) {
				commonFlag = "";
				publication.setSource(inputData);

			} else if (commonFlag.equals(YazClientConstants.ORIGINAL_TITLE)) {
				commonFlag = "";

			} else if (commonFlag.equals(YazClientConstants.SERIALS_CODE)) {
				commonFlag = "";

			} else if (commonFlag.equals(YazClientConstants.NLM_JOURNAL_NAME)) {
				// commonFlag = "";
				journalName.append(inputData);
				// publications.setNlmJournal(inputData);

			} else if (commonFlag.equals(YazClientConstants.JOURNAL_NAME)) {
				// commonFlag = "";
				journalName.append(inputData);
				// publications.setNlmJournal(inputData);

			} else if (commonFlag
					.equals(YazClientConstants.COUNTRY_OF_PUBLICATION)) {
				commonFlag = "";
				publication.setCountryOfPublication(inputData);

			} else if (commonFlag
					.equals(YazClientConstants.MESH_SUBJECT_HEADINGS)) {
				commonFlag = "";
				publication.setSubjectHeading(inputData);

			} else if (commonFlag.equals(YazClientConstants.ABSTRACT)) {
				abstractName.append(inputData);

			} else if (commonFlag.equals(YazClientConstants.PUBLICATION_TYPE)) {
				commonFlag = "";
				publication.setPublicationType(inputData);

			} else if (commonFlag.equals(YazClientConstants.ISSN)) {
				commonFlag = "";
				publication.setIssn(inputData);

			} else if (commonFlag.equals(YazClientConstants.LANGUAGE)) {
				commonFlag = "";
				publication.setLanguage(inputData);

			} else if (commonFlag
					.equals(YazClientConstants.DATE_OF_PUBLICATION)) {
				commonFlag = "";
				publication.setDateOfPublication(inputData);

			} else if (commonFlag
					.equals(YazClientConstants.YEAR_OF_PUBLICATION)) {
				commonFlag = "";
				if (inputData != null && !"".equals(inputData)) {
					if (inputData.indexOf("/") > 0)
						inputData = inputData.split("/")[0];
					pubYear = Integer.parseInt(inputData.trim());
					/*
					 * if ((curYear - pubYear) > 5) { System.out.println("before
					 * 5 years " + publication.getUniqueId()); continue; }
					 */
				}
				publication.setYearOfPublication(pubYear);
				flag = true;
				counter++;
			}

			if (inputData.indexOf(YazClientConstants.UNIQUE_IDENTIFIER) != -1) {
				commonFlag = YazClientConstants.UNIQUE_IDENTIFIER;

			} else if (inputData.indexOf(YazClientConstants.ACCESSION_NUMBER) != -1) {
				commonFlag = YazClientConstants.ACCESSION_NUMBER;

			} else if (inputData.indexOf(YazClientConstants.AUTHORS) != -1) {
				commonFlag = YazClientConstants.AUTHORS;

			} else if (inputData.indexOf(YazClientConstants.AUTHOR_FULL_NAME) != -1) {
				commonFlag = YazClientConstants.AUTHOR_FULL_NAME;

			} else if (inputData.indexOf(YazClientConstants.INSTITUTION) != -1) {
				commonFlag = YazClientConstants.INSTITUTION;

			} else if (inputData.indexOf(YazClientConstants.TITLE) != -1) {
				commonFlag = YazClientConstants.TITLE;

			} else if (inputData.indexOf(YazClientConstants.SOURCE) != -1) {
				commonFlag = YazClientConstants.SOURCE;

			} else if (inputData.indexOf(YazClientConstants.ORIGINAL_TITLE) != -1) {
				commonFlag = YazClientConstants.ORIGINAL_TITLE;

			} else if (inputData.indexOf(YazClientConstants.NLM_JOURNAL_NAME) != -1) {
				commonFlag = YazClientConstants.NLM_JOURNAL_NAME;

			} else if (inputData.indexOf(YazClientConstants.JOURNAL_NAME) != -1) {
				commonFlag = YazClientConstants.JOURNAL_NAME;

			} else if (inputData
					.indexOf(YazClientConstants.COUNTRY_OF_PUBLICATION) != -1) {
				commonFlag = YazClientConstants.COUNTRY_OF_PUBLICATION;

			} else if (inputData
					.indexOf(YazClientConstants.MESH_SUBJECT_HEADINGS) != -1) {
				commonFlag = YazClientConstants.MESH_SUBJECT_HEADINGS;

			} else if (inputData.indexOf(YazClientConstants.ABSTRACT) != -1) {
				commonFlag = YazClientConstants.ABSTRACT;

			} else if (inputData.indexOf(YazClientConstants.PUBLICATION_TYPE) != -1) {
				commonFlag = YazClientConstants.PUBLICATION_TYPE;

			} else if (inputData.indexOf(YazClientConstants.ISSN) != -1) {
				commonFlag = YazClientConstants.ISSN;

			} else if (inputData.indexOf(YazClientConstants.LANGUAGE) != -1) {
				commonFlag = YazClientConstants.LANGUAGE;

			} else if (inputData
					.indexOf(YazClientConstants.DATE_OF_PUBLICATION) != -1) {
				commonFlag = YazClientConstants.DATE_OF_PUBLICATION;

			} else if (inputData
					.indexOf(YazClientConstants.YEAR_OF_PUBLICATION) != -1) {
				commonFlag = YazClientConstants.YEAR_OF_PUBLICATION;

			}

			if (flag) {
				String authorFullName = "";
				String authorNames = "";
				String pubAbstract = "";
				String journalNames = "";
				authorFullName = authorFullNames.toString();
				if (authorFullNames.toString().trim().indexOf(
						YazClientConstants.INSTITUTION) != -1) {
					authorFullName = authorFullNames.toString().substring(
							0,
							authorFullNames.toString().indexOf(
									YazClientConstants.INSTITUTION));
				}
				authorNames = authors.toString();
				if (authors.toString().trim().indexOf(
						YazClientConstants.INSTITUTION) != -1) {
					authorNames = authors.substring(0, authors
							.indexOf(YazClientConstants.INSTITUTION) - 1);
				}
				if (authors.toString().trim().indexOf(
						YazClientConstants.AUTHOR_FULL_NAME) != -1) {
					authorNames = authors.substring(0, authors
							.indexOf(YazClientConstants.AUTHOR_FULL_NAME) - 1);
				}
				if (titleBuff != null) {
					if (titleBuff.length() < 4000) {
						if (titleBuff.indexOf("Source") != -1)
							publication.setTitle(titleBuff.substring(0,
									titleBuff.indexOf("Source")));
						else if (titleBuff.indexOf("Serials Code") != -1)
							publication.setTitle(titleBuff.substring(0,
									titleBuff.indexOf("Serials Code")));
						else
							publication.setTitle(titleBuff.toString());
					} else {
						publication.setTitle(titleBuff.toString().substring(0,
								4000));
					}

				}
				if (journalName != null) {
					journalNames = journalName.toString();
					if (journalName.toString().indexOf(
							"Publishing Model Ground") != -1) {
						journalNames = journalName.toString().substring(
								0,
								journalName.toString().indexOf(
										"Publishing Model Ground"));
					} else if (journalName.toString().indexOf(
							"Publishing Model") != -1) {
						journalNames = journalName.toString().substring(
								0,
								journalName.toString().indexOf(
										"Publishing Model"));
					} else if (journalName.toString().indexOf("Volume") != -1) {
						journalNames = journalName.toString().substring(0,
								journalName.toString().indexOf("Volume"));
					}
					if (journalNames.length() < 1000) {
						publication.setJournalName(journalNames);
					} else {
						publication.setJournalName(journalNames.substring(0,
								1000));
					}
				}

				if (authorFullName != null && !"".equals(authorFullName)
						&& authorFullName.length() > 0) {
					publication.setAuthors(authorFullName);
				} else if (authorNames != null && !"".equals(authorNames)
						&& authorNames.length() > 0) {
					publication.setAuthors(authorNames);
				}
				if (abstractName != null && abstractName.length() > 0) {
					pubAbstract = abstractName.toString();
					if (abstractName.toString().indexOf(
							YazClientConstants.NUMBER_OF_REFERENCES) != -1) {
						pubAbstract = abstractName
								.toString()
								.substring(
										0,
										abstractName
												.toString()
												.indexOf(
														YazClientConstants.NUMBER_OF_REFERENCES));
					}
					if (abstractName.toString().indexOf(
							YazClientConstants.CAS_REGISTRY) != -1) {
						pubAbstract = abstractName.toString().substring(
								0,
								abstractName.toString().indexOf(
										YazClientConstants.CAS_REGISTRY));
					}
					if (pubAbstract.length() > 4000) {
						publication.setAbstractPublication(pubAbstract
								.substring(0, 4000));
					} else {
						publication.setAbstractPublication(pubAbstract);
					}
				}

				authorFullNames = new StringBuffer();
				abstractName = new StringBuffer();
				authors = new StringBuffer();
				titleBuff = new StringBuffer();
				journalName = new StringBuffer();

			}
		}
		// Save the publication !
		if (publication.getIssn().length() > 0)
			olPublicationsHashOnIssn.put(publication.getIssn(), publication);
		else
			ovidClient.publicationsService.addpublication(publication);
	}

}
