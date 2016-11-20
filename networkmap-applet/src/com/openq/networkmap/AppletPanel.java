package com.openq.networkmap;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.ClipboardOwner;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Hashtable;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.BorderFactory;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.border.BevelBorder;
import javax.swing.border.EmptyBorder;

import com.openq.networkmap.display.DrawUtils;
import com.openq.networkmap.display.GraphPanel;
import com.openq.networkmap.display.IEdgeFilterer;
import com.openq.networkmap.display.ZoomChangeListener;

public class AppletPanel extends JPanel implements ClipboardOwner, ActionListener, ChangeListener, ZoomChangeListener, IEdgeFilterer {

	private JPanel controlPanel = new JPanel();
	private JPanel filterPanel = new JPanel();
	private JSlider zoomSlider = new JSlider();
	private Hashtable edgeFilterDropDowns = new Hashtable();
	
	private JButton btnExport = new JButton(new ImageIcon(DrawUtils.getImage("paste.png",this)));
	
	GraphPanel gp;
	
	private float zoomTickValue = 1f;
	private static final int NUM_TICKS = 100;
	
	public AppletPanel(InputStream url) {
		gp = new GraphPanel(this);
		BorderLayout lyLayout = new BorderLayout();
		lyLayout.setHgap(0);
		lyLayout.setVgap(0);
		
		btnExport.setFont(this.getFont().deriveFont(10f));
		
		
		this.setLayout(new BorderLayout());
		this.add(gp, BorderLayout.CENTER);
		try {
			gp.loadXML(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		setUpZoomSlider();
		FlowLayout f = new FlowLayout(FlowLayout.LEFT);
		f.setVgap(0);
		
		controlPanel.setLayout(f);
		controlPanel.setBorder(BorderFactory.createBevelBorder(BevelBorder.RAISED));
		
		
		JPanel zoomPanel = new JPanel();
		zoomPanel.setLayout(new BorderLayout());
		JLabel lblZoom = new JLabel("Zoom:");
		lblZoom.setFont(this.getFont().deriveFont(10f));
		zoomPanel.add(lblZoom,BorderLayout.WEST);
		zoomPanel.add(zoomSlider,BorderLayout.EAST);
		
		//controlPanel.setBorder(BorderFactory.createEmptyBorder());
		//zoomPanel.setBorder(new EmptyBorder(0,0,0,0));
		
//		controlPanel.setBackground(Color.green);
//		zoomPanel.setBackground(Color.yellow);
//		setBackground(Color.blue);
		
		//filterPanel.setBackground(Color.orange);
		
		controlPanel.add(zoomPanel);
		controlPanel.add(filterPanel);
		if (gp.getControlPanel() != null) controlPanel.add(gp.getControlPanel());
		
		btnExport.setIcon(new ImageIcon(DrawUtils.getImage("paste.png",this)));
		btnExport.setToolTipText("Copy Image to Clipboard");
		btnExport.setMargin(new Insets(1,1,1,1));
		controlPanel.add(btnExport);
		
		btnExport.addActionListener(this);
		
//		controlPanel.add(new JLabel("Connection Filter:"));
//		controlPanel.add(typeDropDown);
//		
//		typeDropDown.addItem("Show All");
		
		this.add(controlPanel, BorderLayout.NORTH);
		
	}
	
	private void setUpZoomSlider() {
		zoomTickValue = NUM_TICKS/(gp.MAX_SCALE - gp.MIN_SCALE);
		//zoomSlider.setPaintTrack(true);
		//zoomSlider.setPaintTicks(true);
		zoomSlider.setMinimum(0);
		zoomSlider.setMaximum(NUM_TICKS);
		zoomSlider.setMajorTickSpacing(NUM_TICKS/10);
		zoomSlider.setMinorTickSpacing(NUM_TICKS/100);
		zoomSlider.addChangeListener(this);
		zoomSlider.setValue((int)(gp.getScale() * zoomTickValue));
		zoomSlider.setOrientation(JSlider.HORIZONTAL);
		gp.addZoomChangeListener(this);
	}

	public void stateChanged(ChangeEvent arg0) {
		if (arg0.getSource() == zoomSlider) {
			gp.setScale(zoomSlider.getValue() / zoomTickValue);
		}
		
	}

	public void scaleChangedTo(float scale) {
		zoomSlider.setValue((int)(gp.getScale() * zoomTickValue));
		
	}

	public void edgePropertyAdded(String name, String value) {
		if (!this.edgeFilterDropDowns.containsKey(name)) {
			JComboBox drop = new JComboBox();
			drop.addActionListener(this);
			drop.setFont(this.getFont().deriveFont(10f));
			this.edgeFilterDropDowns.put(name, drop);
			JLabel filterLabel =new JLabel(name + ":" );
			filterLabel.setFont(this.getFont().deriveFont(10f));
			filterPanel.add(filterLabel);
			filterPanel.add(drop);
			drop.addItem(GraphPanel.SHOW_ALL_FILTER);
		}
		
		JComboBox box = (JComboBox)this.edgeFilterDropDowns.get(name);
		Object o = null;
		for (int i=0; i<box.getItemCount(); i++) {
			if (box.getItemAt(i).toString().equals(value)) {
				o = box.getItemAt(i);
				break;
			}
		}
		if (o==null) {
			box.addItem(value);
		}
			
		
		
		
		
	}

	public void actionPerformed(ActionEvent arg0) {
		if (arg0.getSource() instanceof JComboBox) {
			System.out.println("App action:" + arg0.toString());
			Iterator i = this.edgeFilterDropDowns.keySet().iterator();
			while (i.hasNext()) {
				String name = (String)i.next();
				if (this.edgeFilterDropDowns.get(name) == arg0.getSource()) {
					gp.filterEdges(name, ((JComboBox)arg0.getSource()).getSelectedItem().toString());
					break;
				}
			}
		} else if (arg0.getSource() == btnExport) {
			BufferedImage img = new BufferedImage(gp.getWidth(), gp.getHeight(), BufferedImage.TYPE_INT_RGB);
			gp.drawGraph((Graphics2D)img.getGraphics(), true);
			
			Clipboard c = Toolkit.getDefaultToolkit().getSystemClipboard();
			
			c.setContents(new ClipImage(img), this);
			
//			try {
//				ImageIO.write(img, "png", new File("c:\\temp\\image.png"));
//			} catch (IOException eee) {
//				eee.printStackTrace();
//			}
		}
		
	}
	
	private class ClipImage implements Transferable {
		
		private DataFlavor[] myFlavors;
		private BufferedImage myImage;

		public ClipImage(BufferedImage theImage) {
			myFlavors = new DataFlavor[]{DataFlavor.imageFlavor};
			myImage = theImage;
		}

		public Object getTransferData(DataFlavor flavor) throws UnsupportedFlavorException {
			if (flavor != DataFlavor.imageFlavor) {
				throw new UnsupportedFlavorException(flavor);
			}
			return myImage;
		}

		public DataFlavor[] getTransferDataFlavors() {
			return myFlavors;
		}

		public boolean isDataFlavorSupported(DataFlavor flavor) {
			return (flavor == DataFlavor.imageFlavor);
		}
}


	public void lostOwnership(Clipboard clipboard, Transferable contents) {
		// TODO Auto-generated method stub
		
	}
}
