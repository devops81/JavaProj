package com.openq.orx.agmen;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.List;
import java.util.Vector;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.SOAPException;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.message.SOAPBodyElement;
import org.apache.axis.utils.Options;
import org.w3c.dom.Document;

import com.amgen.orx.jaxb.impl.FindResultImpl;
import com.sun.xml.bind.StringInputStream;

import javax.xml.bind.Unmarshaller;

public class AmgenSimpleAxisClient
{
    private static String orxServerURL = "http://usto-dapp-lnx02.amgen.com:7253/orx/services/ORXWebservice";
    //private static String orxServerURL = "http://localhost:1234/orx/services/ORXWebservice";

    private Call call;

    public AmgenSimpleAxisClient ()
    {
    	Options opts;
    	
		try {
			opts = new Options(new String[0]);
	    	opts.setDefaultURL(orxServerURL);
	    	Service service = new Service();
	    	call = (Call) service.createCall();
	    	call.setTargetEndpointAddress(new URL(opts.getURL()));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    public List getOrxClusterForName(String lastName, String firstName)  throws IOException, SOAPException, JAXBException {
    	return getOrxClusterForNameAndState(lastName, firstName, null);
    }

    public List getOrxClusterForNameAndState(String lastName, String firstName, String state)  throws IOException, SOAPException, JAXBException {
    	return createAndSendMessage(new StringInputStream(AmgenWebServiceRequestGenerator.createFindObjectsByAttrsRequest(lastName, firstName, state)));
    }
    
    /**
     * Creates a soap message containing the XML from the InputStream. Sends the message 
     * to the service call setup in the constructor.
     * 
     * @param is Input stream with the XML to put in the SOAPBodyElement
     * @throws IOException
     * @throws SOAPException
     */
    public List createAndSendMessage(InputStream is) throws IOException, SOAPException 
    {
    	// create SOAPBodyElement, load data from input file
    	SOAPBodyElement[] input = new SOAPBodyElement[1];
        
        // create the w3c.Document from the xml in the input stream
        Document xmlDocument = createDocument(is);
        
        // create an Axis SOAPBodyElement from the newly created w3c.Document Document element
    	input[0] = new SOAPBodyElement( xmlDocument.getDocumentElement() );
		
		// call service and print results
		Vector results = (Vector) call.invoke(input);
		return unmarshal((SOAPBodyElement) results.get(0));
    }

    /**
     * Read a file and create a DOM Document out of it
     *
     * @param filename the file where the XML is stored
     * @return
     */
    public static Document createDocument( InputStream is ){
        Document xmlDocument = null;
        
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(false);
            factory.setNamespaceAware(true);
            DocumentBuilder parser = factory.newDocumentBuilder();
            xmlDocument = parser.parse(is);
        } catch (Exception e) {
            System.out.println("Couldnt read input stream " + e);
        }
    
    	return xmlDocument;
    }    
    
    public static List unmarshal( SOAPBodyElement e ){
		try {
			JAXBContext jc = JAXBContext.newInstance(AmgenWebServiceRequestGenerator.PACKAGE_NAME);
			Unmarshaller um = (Unmarshaller) jc.createUnmarshaller();
			FindResultImpl res = (FindResultImpl) um.unmarshal(new StringInputStream(e.getAsString()));
			//System.out.println(res.getClass().getName());
			return (List) res.getEoList();
			
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return null;
	}
}
