package com.openq.networkmap;

import java.applet.Applet;
import java.awt.BorderLayout;
import java.io.InputStream;
import java.net.URL;

import javax.swing.JApplet;
import javax.swing.JOptionPane;

import com.openq.networkmap.display.DrawUtils;


public class NetworkMapApplet extends Applet {
	
	private static Applet thisApplet = null;
	
	public void init() {
		thisApplet = this;
		
	    //Execute a job on the event-dispatching thread:
	    //creating this applet's GUI.
		try{
			URL url = new URL(this.getDocumentBase(),this.getParameter("data"));
			createGUI(url.openStream());
			
			
			//createGUI();
	    } catch (Exception e) {
	        System.err.println("createGUI didn't successfully complete");
	        e.printStackTrace();
	    }
	}
	
	public static void showDocument(String url) {
		try {
			
			
			if (url.toLowerCase().trim().startsWith("http:")) {
				thisApplet.getAppletContext().showDocument(new URL(url));
			} else {
				//JOptionPane.showMessageDialog(thisApplet, thisApplet.getCodeBase().toExternalForm());
				thisApplet.getAppletContext().showDocument(new URL(thisApplet.getCodeBase().toExternalForm() + "/" + url));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void createGUI(InputStream url) {
		DrawUtils.regsiterImageLoader(this);
	    AppletPanel networkPanel = new AppletPanel(url);
	    setLayout(new BorderLayout());
	    add(networkPanel, BorderLayout.CENTER);
	}

}
