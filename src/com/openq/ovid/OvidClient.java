package com.openq.ovid;

import com.openq.kol.DBUtil;
import com.openq.kol.SearchDTO;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Properties;



/**
 * Created by IntelliJ IDEA.
 * User: abhrap
 * Date: Jul 18, 2006
 * Time: 2:21:26 PM
 * To change this template use File | Settings | File Templates.
 */
public class OvidClient {
    private String firstName;
    private String middleName;
    private String lastName;
    private String institution;
    private int userId = 0;
    private String specialty = null;

    private Process process = null;
    PublicationsManager profDistMgr = null;
    private OutputStream stream = null;

    public OvidClient(Process process, OutputStream stream) {
        
    	Runtime runtime = Runtime.getRuntime();
        String yazClientLocation = null;
        String authenticationParam = null;
        String connectionURL = null;
        String connectionPort = null;
        
        try {
            Properties props = DBUtil.getInstance().getDataFromPropertiesFile("resources/OvidConfig.properties");
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
                    this.stream.write((connectionURL + ":" + connectionPort + "\n").getBytes());
                    this.stream.write("set_auto_reconnect on\n".getBytes());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public ArrayList connect(SearchDTO searchDTO,String databaseName, int confidenceFactor) throws Exception {
    	
    	this.userId = searchDTO.getUserid();
        this.firstName = searchDTO.getFirstName();
        this.lastName = searchDTO.getLastName();
        this.middleName = searchDTO.getMiddleName();
        this.institution = searchDTO.getInstitution();
        this.specialty = searchDTO.getSpecialty();
        ArrayList searchResults = null;
        
    	
        String queryStr = "";
        String authorName = "";
        StringBuffer nameBuffer = new StringBuffer();
        StringBuffer checkNameBuff = new StringBuffer();
        int resultConfidenceFactor = 0;

        StringBuffer queryBuffer = new StringBuffer();
        if (lastName != null && !"".equals(nameBuffer)) {
            nameBuffer.append(lastName);
            checkNameBuff.append(lastName);
        }
        if (firstName != null && !"".equals(firstName) && firstName.length() > 0) {
            nameBuffer.append(" ").append(firstName.substring(0, 1));
            checkNameBuff.append(", ").append(firstName);
        }
        if (middleName != null && !"".equals(middleName) && middleName.length() > 0) {
            nameBuffer.append(middleName.substring(0, 1));
            checkNameBuff.append(" ").append(middleName.substring(0, 1));
        }
        authorName = nameBuffer.toString();
        if (OvidConstants.CONFIDENCE_FACTOR_FULL == confidenceFactor) {
        	
			String speciality[] = null;
			
			if (searchDTO.getSpecialty() != null
					&& !"".equals(searchDTO.getSpecialty())) {
				String temp[] = searchDTO.getSpecialty().split(",");
				speciality = temp;
			}
			if (speciality == null) {
				searchResults = new ArrayList();
				searchResults.add(stream);
				searchResults.add(process);
				System.out.println("queryStr = skipping 100% query (no speciality)");
				return searchResults;
			}

			if (authorName != null && !"".equals(authorName)
					&& institution != null && !"".equals(institution)) {
				resultConfidenceFactor = OvidConstants.CONFIDENCE_FACTOR_FULL;
				queryBuffer.append(OvidConstants.QUERY_STR0);
				queryBuffer.append(OvidConstants.QUERY_STR1);
				// for specialities
				queryBuffer.append(OvidConstants.QUERY_STR1);
				for (int i = 1; i < speciality.length; i++)
					queryBuffer.append(OvidConstants.QUERY_STR3);

				queryBuffer.append(OvidConstants.QUERY_STR2).append(
						OvidConstants.NAME_ATTRIBUTE).append("\"").append(
						authorName).append("\"");
				queryBuffer.append(" ").append(OvidConstants.QUERY_STR2)
						.append(OvidConstants.INSTITUTION_ATTRIBUTE).append(
								"\"").append(institution).append("\" ");
				if (speciality != null) {
					queryBuffer.append(OvidConstants.QUERY_STR2).append(
							OvidConstants.SPECIALTY_ATTRIBUTE).append(" ");
					for (int i = 0; i < speciality.length; i++)
						queryBuffer.append("\"").append(speciality[i].trim()).append(
								"\"").append(" ");
				}
			}
		} else if (OvidConstants.CONFIDENCE_FACTOR_SEMI == confidenceFactor) {
			
			String speciality[] = null;
			if (searchDTO.getSpecialty() != null
					&& !"".equals(searchDTO.getSpecialty())) {
				String temp[] = searchDTO.getSpecialty().split(",");
				speciality = temp;
			}
			if (speciality == null) {
				searchResults = new ArrayList();
				searchResults.add(stream);
				searchResults.add(process);
				System.out.println("queryStr = skipping 75% query (no speciality)");
				return searchResults;
			}

			if (authorName != null && !"".equals(authorName)) {
				resultConfidenceFactor = OvidConstants.CONFIDENCE_FACTOR_SEMI;
				queryBuffer.append(OvidConstants.QUERY_STR0);
				if (speciality != null) {
					queryBuffer.append(OvidConstants.QUERY_STR1);
					for (int i = 1; i < speciality.length; i++)
						queryBuffer.append(OvidConstants.QUERY_STR3);
				}
				queryBuffer.append(OvidConstants.QUERY_STR2).append(
						OvidConstants.NAME_ATTRIBUTE).append("\"").append(
						authorName).append("\"");
				if (speciality != null) {
					queryBuffer.append(" ");
					queryBuffer.append(OvidConstants.QUERY_STR2).append(
							OvidConstants.SPECIALTY_ATTRIBUTE).append(" ");
					for (int i = 0; i < speciality.length; i++)
						queryBuffer.append("\"").append(speciality[i]).append(
								"\"").append(" ");
				}
			}
		} else if (OvidConstants.CONFIDENCE_FACTOR_HALF == confidenceFactor) {
			resultConfidenceFactor = OvidConstants.CONFIDENCE_FACTOR_HALF;

			queryBuffer.append(OvidConstants.QUERY_STR0);
			queryBuffer.append(OvidConstants.QUERY_STR2).append(
					OvidConstants.NAME_ATTRIBUTE).append("\"").append(
					authorName).append("\"");
		}

        searchResults = new ArrayList();

        queryStr = queryBuffer.toString();
        System.out.println("queryStr = " + queryStr);
        try {

            stream.write((databaseName + "\n").getBytes());
            stream.write(queryStr.getBytes());
            stream.write("\n".getBytes());
            stream.write((OvidConstants.OVID_DISPLAY_FORMAT + "\n").getBytes());
            stream.write((OvidConstants.OVID_DISPLAY_RESULTS + "\n").getBytes());

            stream.flush();
            try{
            searchResults = iterateData(confidenceFactor, resultConfidenceFactor,
                    checkNameBuff, authorName, searchResults);
            }catch(Exception e){
            	e.printStackTrace();
            	if("Target closed connection".equalsIgnoreCase(e.getMessage()))
            		throw e;
            }

            if (packetDump && nHt != -1) {
                for (int nh = 1; nh <= nHt; nh++) {
                    stream.write(("show " + nh + "\n").getBytes());
                    stream.flush();
                    searchResults = iterateData(confidenceFactor, resultConfidenceFactor,
                            checkNameBuff, authorName, searchResults);
                }
                packetDump = false;
            }
            if (searchResults != null) {
                searchResults.add(stream);
                searchResults.add(process);
            }
//            if(ps != null)
//            	ps.close();
//            if(fos != null)
//            	fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return searchResults;
    }

    private boolean packetDump = false;
    private int nHt = -1;

    private ArrayList iterateData(int confidenceFactor, int resultConfidenceFactor, StringBuffer checkNameBuff,
                                  String authorName, ArrayList searchResults) throws Exception {
        String inputData = null;
        String commonFlag = "";
        Publications publications = new Publications();

        int counter = 0;

        InputStream input = process.getInputStream();
        BufferedReader in = new BufferedReader(new InputStreamReader(input));
        StringBuffer authorFullNames = new StringBuffer("");
        StringBuffer authors = new StringBuffer("");
        StringBuffer abstractName = new StringBuffer("");
        StringBuffer titleBuff = new StringBuffer("");
        StringBuffer journalName = new StringBuffer("");
        Calendar today = Calendar.getInstance();
        int curYear = today.get(Calendar.YEAR);
        int pubYear = 0;

        String numberOfHits = null;

        while ((inputData = in.readLine()) != null) {
        	/*
        	 * If yaz-client returns "Target closed connection",
        	 * throw an exception
        	 */
        	if("Target closed connection".equalsIgnoreCase(inputData.trim())){
        		throw new Exception(inputData.trim());
        	}

            if (inputData.indexOf(OvidConstants.NUMBER_OF_HITS) != -1) {
                numberOfHits = inputData.substring(inputData.indexOf(":")+1, inputData.indexOf(","));
                if (numberOfHits != null && !"".equals(numberOfHits)) {
                    nHt = Integer.parseInt(numberOfHits.trim());
                }
            }
            if (inputData.indexOf(OvidConstants.NEXT_RESULT_POSITION) != -1 ||
                    inputData.equalsIgnoreCase("Packet dump:")) {
                if (inputData.equalsIgnoreCase("Packet dump:")) {
                    packetDump = true;
                }
                break;
            }
            System.out.println(inputData + "\n");
            boolean flag = false;

            if (commonFlag.equals(OvidConstants.UNIQUE_IDENTIFIER)) {
                commonFlag = "";
                publications.setUniqueIdentifier(Integer.parseInt(inputData.trim()));

            } else if (commonFlag.equals(OvidConstants.ACCESSION_NUMBER)) {
                commonFlag = "";
                publications.setUniqueIdentifier(Integer.parseInt(inputData.trim()));

            } else if (commonFlag.equals(OvidConstants.AUTHORS)) {
                authors.append(inputData).append(",");

            } else if (commonFlag.equals(OvidConstants.AUTHOR_FULL_NAME)) {
                authorFullNames.append(inputData);

            } else if (commonFlag.equals(OvidConstants.INSTITUTION)) {
                commonFlag = "";
                publications.setInstitution(inputData);

            } else if (commonFlag.equals(OvidConstants.TITLE)) {
                titleBuff.append(inputData);

            } else if (commonFlag.equals(OvidConstants.SOURCE)) {
                commonFlag = "";
                publications.setSource(inputData);

            } else if (commonFlag.equals(OvidConstants.ORIGINAL_TITLE)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.SERIALS_CODE)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.NLM_JOURNAL_NAME)) {
                //commonFlag = "";
                journalName.append(inputData);
                //publications.setNlmJournal(inputData);

            } else if (commonFlag.equals(OvidConstants.JOURNAL_NAME)) {
                //commonFlag = "";
                journalName.append(inputData);
                //publications.setNlmJournal(inputData);

            } else if (commonFlag.equals(OvidConstants.PUBLISHING_MODEL)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.VOLUME)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.COUNTRY_OF_PUBLICATION)) {
                commonFlag = "";
                publications.setCountryOfPublication(inputData);

            } else if (commonFlag.equals(OvidConstants.MESH_SUBJECT_HEADINGS)) {
                commonFlag = "";
                publications.setSubjectHeading(inputData);

            } else if (commonFlag.equals(OvidConstants.ABSTRACT)) {
                abstractName.append(inputData);

            } else if (commonFlag.equals(OvidConstants.CAS_REGISTRY)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.NUMBER_OF_REFERENCES)) {
                commonFlag = "";

            } else if (commonFlag.equals(OvidConstants.PUBLICATION_TYPE)) {
                commonFlag = "";
                publications.setType(inputData);

            } else if (commonFlag.equals(OvidConstants.LANGUAGE)) {
                commonFlag = "";
                publications.setLanguage(inputData);

            } else if (commonFlag.equals(OvidConstants.DATE_OF_PUBLICATION)) {
                commonFlag = "";
                publications.setDateOfPublication(inputData);

            } else if (commonFlag.equals(OvidConstants.YEAR_OF_PUBLICATION)) {
                commonFlag = "";
                if (inputData != null && !"".equals(inputData)) {
                	if(inputData.indexOf("/") > 0)
                		inputData = inputData.split("/")[0];
                    pubYear = Integer.parseInt(inputData.trim());
                    if ((curYear - pubYear) > 5) {
                    	System.out.println("before 5 years "+publications.getUniqueIdentifier());
                        continue;
                    }
                }
                publications.setYear(inputData);
                flag = true;
                counter++;

            }

            if (inputData.indexOf(OvidConstants.UNIQUE_IDENTIFIER) != -1) {
                commonFlag = OvidConstants.UNIQUE_IDENTIFIER;

            } else if (inputData.indexOf(OvidConstants.ACCESSION_NUMBER) != -1) {
                commonFlag = OvidConstants.ACCESSION_NUMBER;

            } else if (inputData.indexOf(OvidConstants.AUTHORS) != -1) {
                commonFlag = OvidConstants.AUTHORS;

            } else if (inputData.indexOf(OvidConstants.AUTHOR_FULL_NAME) != -1) {
                commonFlag = OvidConstants.AUTHOR_FULL_NAME;

            } else if (inputData.indexOf(OvidConstants.INSTITUTION) != -1) {
                commonFlag = OvidConstants.INSTITUTION;

            } else if (inputData.indexOf(OvidConstants.TITLE) != -1) {
                commonFlag = OvidConstants.TITLE;

            } else if (inputData.indexOf(OvidConstants.SOURCE) != -1) {
                commonFlag = OvidConstants.SOURCE;

            } else if (inputData.indexOf(OvidConstants.ORIGINAL_TITLE) != -1) {
                commonFlag = OvidConstants.ORIGINAL_TITLE;

            } else if (inputData.indexOf(OvidConstants.SERIALS_CODE) != -1) {
                commonFlag = OvidConstants.SERIALS_CODE;

            } else if (inputData.indexOf(OvidConstants.NLM_JOURNAL_NAME) != -1) {
                commonFlag = OvidConstants.NLM_JOURNAL_NAME;

            } else if (inputData.indexOf(OvidConstants.JOURNAL_NAME) != -1) {
                commonFlag = OvidConstants.JOURNAL_NAME;

            } else if (inputData.indexOf(OvidConstants.PUBLISHING_MODEL) != -1) {
                commonFlag = OvidConstants.PUBLISHING_MODEL;

            } else if (inputData.indexOf(OvidConstants.VOLUME) != -1) {
                commonFlag = OvidConstants.VOLUME;

            } else if (inputData.indexOf(OvidConstants.COUNTRY_OF_PUBLICATION) != -1) {
                commonFlag = OvidConstants.COUNTRY_OF_PUBLICATION;

            } else if (inputData.indexOf(OvidConstants.MESH_SUBJECT_HEADINGS) != -1) {
                commonFlag = OvidConstants.MESH_SUBJECT_HEADINGS;

            } else if (inputData.indexOf(OvidConstants.ABSTRACT) != -1) {
                commonFlag = OvidConstants.ABSTRACT;

            } else if (commonFlag.equals(OvidConstants.CAS_REGISTRY)) {
                commonFlag = OvidConstants.CAS_REGISTRY;

            } else if (commonFlag.equals(OvidConstants.NUMBER_OF_REFERENCES)) {
                commonFlag = OvidConstants.NUMBER_OF_REFERENCES;

            } else if (inputData.indexOf(OvidConstants.PUBLICATION_TYPE) != -1) {
                commonFlag = OvidConstants.PUBLICATION_TYPE;

            } else if (inputData.indexOf(OvidConstants.LANGUAGE) != -1) {
                commonFlag = OvidConstants.LANGUAGE;

            } else if (inputData.indexOf(OvidConstants.DATE_OF_PUBLICATION) != -1) {
                commonFlag = OvidConstants.DATE_OF_PUBLICATION;

            } else if (inputData.indexOf(OvidConstants.YEAR_OF_PUBLICATION) != -1) {
                commonFlag = OvidConstants.YEAR_OF_PUBLICATION;

            }

            if (flag) {
                String authorFullName = "";
                String authorNames = "";
                String pubAbstract = "";
                String journalNames = "";
                authorFullName = authorFullNames.toString();
                if (authorFullNames.toString().trim().indexOf(OvidConstants.INSTITUTION) != -1) {
                    authorFullName = authorFullNames.toString().substring(0, authorFullNames.toString().
                            indexOf(OvidConstants.INSTITUTION));
                }
                authorNames = authors.toString();
                if (authors.toString().trim().indexOf(OvidConstants.INSTITUTION) != -1) {
                    authorNames = authors.substring(0, authors.
                            indexOf(OvidConstants.INSTITUTION) - 1);
                }
                if (authors.toString().trim().indexOf(OvidConstants.AUTHOR_FULL_NAME) != -1) {
                    authorNames = authors.substring(0, authors.
                            indexOf(OvidConstants.AUTHOR_FULL_NAME) - 1);
                }
                if (titleBuff != null) {
                    if (titleBuff.length() < 4000) {
                        if (titleBuff.indexOf("Source") != -1)
                            publications.setTitle(titleBuff.substring(0, titleBuff.indexOf("Source")));
                        if (titleBuff.indexOf("Serials Code") != -1)
                            publications.setTitle(titleBuff.substring(0, titleBuff.indexOf("Serials Code")));
                    } else {
                        publications.setTitle(titleBuff.toString().substring(0, 4000));
                    }
                }
                if (journalName != null) {
                    journalNames = journalName.toString();
                    if (journalName.toString().indexOf("Publishing Model Ground") != -1) {
                        journalNames = journalName.toString().substring(0, journalName.toString().
                                indexOf("Publishing Model Ground"));
                    } else if (journalName.toString().indexOf("Publishing Model") != -1) {
                        journalNames = journalName.toString().substring(0, journalName.toString().
                                indexOf("Publishing Model"));
                    } else if (journalName.toString().indexOf("Volume") != -1) {
                        journalNames = journalName.toString().substring(0, journalName.toString().
                                indexOf("Volume"));
                    }
                    if (journalNames.length() < 1000) {
                        publications.setNlmJournal(journalNames);
                    } else {
                        publications.setNlmJournal(journalNames.substring(0, 1000));
                    }
                }
                if (confidenceFactor == OvidConstants.CONFIDENCE_FACTOR_FULL ||
                        (authorFullNames != null && authorFullNames.length() > 0 &&
                                (confidenceFactor == OvidConstants.CONFIDENCE_FACTOR_SEMI ||
                                        confidenceFactor == OvidConstants.CONFIDENCE_FACTOR_HALF) &&
                                authorFullNames.indexOf(checkNameBuff.toString()) != -1) ||
                        (authorFullNames != null && authorFullNames.length() == 0 &&
                                authors != null && authors.length() > 0 &&
                                (confidenceFactor == OvidConstants.CONFIDENCE_FACTOR_SEMI ||
                                        confidenceFactor == OvidConstants.CONFIDENCE_FACTOR_HALF) &&
                                authors.indexOf(authorName) != -1)) {

                    if (authorFullName != null && !"".equals(authorFullName) && authorFullName.length() > 0) {
                        publications.setAuthor(authorFullName);
                    } else if (authorNames != null && !"".equals(authorNames) && authorNames.length() > 0) {
                        publications.setAuthor(authorNames);
                    }
                    publications.setLastName(lastName);
                    publications.setFirstName(firstName);
                    publications.setConfidenceFactor(resultConfidenceFactor);
                    if (abstractName != null && abstractName.length() > 0) {
                        pubAbstract = abstractName.toString();
                        if (abstractName.toString().indexOf(OvidConstants.NUMBER_OF_REFERENCES) != -1) {
                            pubAbstract = abstractName.toString().substring(0, abstractName.toString().
                                    indexOf(OvidConstants.NUMBER_OF_REFERENCES));
                        }
                        if (abstractName.toString().indexOf(OvidConstants.CAS_REGISTRY) != -1) {
                            pubAbstract = abstractName.toString().substring(0, abstractName.toString().
                                    indexOf(OvidConstants.CAS_REGISTRY));
                        }
                        if (pubAbstract.length() > 4000) {
                            publications.setJournalAbstract(pubAbstract.substring(0, 4000));
                        } else {
                            publications.setJournalAbstract(pubAbstract);
                        }
                    }
                        /*}

                        if (specialty != null && !"".equals(specialty)) {
                            String specialties[] = null;
                            if (specialty.indexOf(",") != -1) {
                                specialties = specialty.split(",");
                                if (null != specialties && specialties.length > 0) {
                                    for (int i = 0; i < specialties.length; i++) {
                                        if (publications.getJournalAbstract() != null &&
                                                publications.getJournalAbstract().toUpperCase().
                                                        indexOf(specialties[i].trim().toUpperCase()) != -1) {
                                            toBeAdded = true;
                                            break;
                                        }
                                    }
                                    if (!toBeAdded) {
                                        toBeAdded = true;
                                        publications.setConfidenceFactor(OvidConstants.CONFIDENCE_FACTOR_SEMI);
                                    } else {
                                        toBeAdded = true;
                                        publications.setConfidenceFactor(OvidConstants.CONFIDENCE_FACTOR_HALF);
                                    }
                                }
                            }
                        } else {
                            toBeAdded = true;
                            publications.setConfidenceFactor(OvidConstants.CONFIDENCE_FACTOR_SEMI);
                        }
                    } else {
                        toBeAdded = true;
                        publications.setConfidenceFactor(OvidConstants.CONFIDENCE_FACTOR_SEMI);
                    }*/

                    if (publications.getAuthor() != null && !"".equals(publications.getAuthor())) {

                        publications.setExpertId(Integer.toString(userId));
                        if (searchResults.size() > 0) {
                            boolean contains = false;
                            Publications pubCheck = null;
                            for (int i = 0; i < searchResults.size(); i++) {
                                pubCheck = (Publications) searchResults.get(i);
                                /*
                                 * Checking for any duplicate publications
                                 * if there is any don't add again.
                                 */
                                if (pubCheck.getUniqueIdentifier() == publications.getUniqueIdentifier()) {
                                	System.out.println("matched unique id "+pubCheck.getUniqueIdentifier());
                                    contains = true;
                                    break;
                                }
                            }
                            if (!contains) {
                                searchResults.add(publications);
                            }
                        } else {
                            searchResults.add(publications);
                        }
                    }
                    publications = new Publications();
                    authorFullNames = new StringBuffer();
                    abstractName = new StringBuffer();
                    authors = new StringBuffer();
                    titleBuff = new StringBuffer();
                    journalName = new StringBuffer();
                }
            }
        }
        return searchResults;
    }
}
