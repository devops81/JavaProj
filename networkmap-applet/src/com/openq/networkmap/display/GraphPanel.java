package com.openq.networkmap.display;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.Menu;
import java.awt.MenuItem;
import java.awt.Panel;
import java.awt.Point;
import java.awt.PopupMenu;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.Border;
import javax.swing.border.EmptyBorder;

import com.openq.networkmap.NetworkMapApplet;
import com.openq.networkmap.elements.DisplayEdge;
import com.openq.networkmap.elements.DisplayNode;
import com.openq.networkmap.elements.Edge;
import com.openq.networkmap.elements.Element;
import com.openq.networkmap.elements.Node;
import com.openq.networkmap.elements.NodeGroup;
import com.openq.networkmap.load.ILoadObserver;
import com.openq.networkmap.load.XMLLoader;
import com.openq.networkmap.map.NodeAlreadyExistsException;
import com.openq.networkmap.map.OperateOnAllElements;
import com.openq.networkmap.map.SpringMap;

public class GraphPanel extends Panel implements ILoadObserver, IMapDisplay, ActionListener, ComponentListener, MouseListener, MouseWheelListener, MouseMotionListener {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1221192L;
	
	public static float MAX_SCALE = 2f;
	public static float MIN_SCALE = 0f;
	
	int currentCursorX = 0;
	int currentCursorY = 0;
	
	public static final String SHOW_ALL_FILTER = "Show All";
	
	private Point origin = new Point(0,0);
	private float currentScale = 0.2F;
	private BufferedImage buffer;
	
	private Point lastDragLocation;
	
	private ArrayList nodePropertyNames = new ArrayList();
	private ArrayList nodeGroupMenuItems = new ArrayList();
	private ArrayList nodeColorMenuItems = new ArrayList();
	
	private DisplayNode highlightNode;
	private DisplayEdge highlightEdge;
	private DisplayNode clickedNode;
	
	private boolean addingEdge = false;
	private DisplayNode addingEdgeStartNode = null;
	
	private ArrayList zoomChangeListeners = new ArrayList();
	
	private PopupMenu popMenu;
	
	private MenuItem mnuMakeAllCircles = new MenuItem("Make All Small");
	private MenuItem mnuMakeAllLabels = new MenuItem("Make All Large");
	private MenuItem mnuShowAllNodes = new MenuItem("Show all Nodes");
	private Menu mnuGroupBy = new Menu("Group by");
	private MenuItem mnuUngroup = new MenuItem("Ungroup All");
	private MenuItem mnuHideConnected = new MenuItem("Hide All Connected Nodes");
	private MenuItem mnuHideUnconnected = new MenuItem("Hide All Unconnected Nodes");
	private Menu mnuColorBy = new Menu("Color by");
	private Menu mnuShowEgoNet = new Menu("Show EgoNet");
	private MenuItem mnuEgoNetOneLevel = new MenuItem("One Level Out");
	private MenuItem mnuEgoNetTwoLevel = new MenuItem("Two Levels Out");
	private MenuItem mnuEgoNetThreeLevel = new MenuItem("Three Levels Out");
	
	private IEdgeFilterer parentFilterer = null;
	
	private JButton addEdgeButton = new JButton(new ImageIcon(DrawUtils.getImage("note_add.png",this)));
	private JLabel addEdgeLabel = new JLabel("");
	
	private JPanel controlPanel = new JPanel();
	
	private JDialog addEdgePopup = new JDialog();
	private JComboBox cmbEdgeWidth = new JComboBox();
	private GridBagLayout addEdgeBag = new GridBagLayout();
	private GridBagConstraints addEdgeConstraints = new GridBagConstraints();
	private HashMap addEdgeCombos = new HashMap();
	private JPanel addEdgeButtonPanel = new JPanel();
	private JPanel addEdgeComboPanel = new JPanel();
	private JButton addEdgePopupButton = new JButton("Add Connection");
	private JButton cancelPopupButton = new JButton("Cancel");
	private boolean addNodeFromPopup = false;
	
	
	private SpringMap map;
	
	public GraphPanel() {
		super();
		createGraphPanel(null);
	}
	
	public GraphPanel(IEdgeFilterer parent) {
		super();
		createGraphPanel(parent);
	}
	
	public JPanel getControlPanel() {
		return controlPanel;
	}
	
	
	private void createGraphPanel(IEdgeFilterer parent) {
		
		parentFilterer = parent;
		
		addEdgeButton.setFont(controlPanel.getFont().deriveFont(10f));
		addEdgeButton.setIcon(new ImageIcon(DrawUtils.getImage("node_add.png",this)));
		addEdgeButton.setToolTipText("Add Connection");
		addEdgeButton.setMargin(new Insets(1,1,1,1));

		Border b = addEdgeButton.getBorder();
		
		FlowLayout f = new FlowLayout();
		f.setVgap(0);
		controlPanel.setLayout(f);
		
		
		
		controlPanel.add(this.addEdgeButton);
		controlPanel.add(this.addEdgeLabel);
		addEdgeButton.addActionListener(this);
		
		DrawUtils.preloadImages(this);
		
		map = new SpringMap();
		map.setMapDisplay(this);
		this.addComponentListener(this);
		this.addMouseWheelListener(this);
		this.addMouseListener(this);
		this.addMouseMotionListener(this);
		
		popMenu = new PopupMenu();
		
		this.add(popMenu);
		popMenu.add(mnuMakeAllCircles);
		popMenu.add(this.mnuMakeAllLabels);
		popMenu.add(mnuShowAllNodes);
		popMenu.addSeparator();
		popMenu.add(mnuColorBy);
		popMenu.add(mnuGroupBy);
		popMenu.add(mnuUngroup);
		popMenu.addSeparator();
		popMenu.add(mnuHideConnected);
		popMenu.add(mnuHideUnconnected);
		popMenu.add(mnuShowEgoNet);
		mnuShowEgoNet.add(mnuEgoNetOneLevel);
		mnuShowEgoNet.add(mnuEgoNetTwoLevel);
		mnuShowEgoNet.add(mnuEgoNetThreeLevel);
		
		mnuMakeAllCircles.addActionListener(this);
		mnuShowAllNodes.addActionListener(this);
		mnuMakeAllLabels.addActionListener(this);
		mnuUngroup.addActionListener(this);
		mnuHideConnected.addActionListener(this);
		mnuHideUnconnected.addActionListener(this);
		mnuEgoNetOneLevel.addActionListener(this);
		mnuEgoNetTwoLevel.addActionListener(this);
		mnuEgoNetThreeLevel.addActionListener(this);
		
		this.addEdgePopup.setSize(250,200);
		addEdgePopup.setLocationRelativeTo(null);
		addEdgePopup.setTitle("Add Connection");
    	addEdgePopup.setModal(true);
    	addEdgeComboPanel.setLayout(addEdgeBag);
    	
    	addEdgeConstraints.fill = GridBagConstraints.NONE;
    	addEdgeConstraints.anchor = GridBagConstraints.EAST;
    	
    	JLabel lblWidth = new JLabel("Width: ");
    	addEdgeConstraints.gridwidth = GridBagConstraints.RELATIVE;
    	addEdgeBag.setConstraints(lblWidth, addEdgeConstraints);
    	addEdgeComboPanel.add(lblWidth);
    	
    	
    	for (int i=1; i<=10; i++) this.cmbEdgeWidth.addItem(i+"");
    	cmbEdgeWidth.setSelectedIndex(3);
    	
    	addEdgeConstraints.gridwidth = GridBagConstraints.REMAINDER;
    	addEdgeConstraints.anchor = GridBagConstraints.WEST;
    	addEdgeBag.setConstraints(this.cmbEdgeWidth, addEdgeConstraints);
    	addEdgeComboPanel.add(this.cmbEdgeWidth);
    	
    	addEdgePopup.getContentPane().setLayout(new BorderLayout());
    	addEdgePopup.getContentPane().add(BorderLayout.CENTER, addEdgeComboPanel);
    	addEdgePopup.getContentPane().add(BorderLayout.SOUTH, addEdgeButtonPanel);
    	
		addEdgeButtonPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
		addEdgeButtonPanel.add(addEdgePopupButton);
		addEdgeButtonPanel.add(cancelPopupButton);
		
		addEdgePopupButton.addActionListener(this);
		cancelPopupButton.addActionListener(this);
		
		
		
		
	}
	
	public void mapUpdated() {
		repaint();
	}
	
	public void addZoomChangeListener(ZoomChangeListener list) {
		zoomChangeListeners.add(list);
	}
	
	public void paint(Graphics g) {
		drawGraph((Graphics2D)g);
	}
	
	public void update(Graphics g) {
		drawGraph((Graphics2D)g);
	}
	
	public void drawGraph(Graphics2D g) {
		drawGraph(g,false);
	}
	
	public void drawGraph(Graphics2D g, boolean allAntiAlias) {
		if (buffer == null) {
			buffer = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
		}
		Graphics2D b = buffer.createGraphics();
        DrawUtils.paint(b,map.getNodes(),map.getEdges(), highlightNode, highlightEdge, DrawUtils.getImage("logo.gif", this), getWidth(), getHeight(), origin, currentScale, this, addingEdge, addingEdgeStartNode,currentCursorX,currentCursorY,allAntiAlias);
        if (highlightNode != null && highlightNode.isVisible() && !addingEdge) {
        	DrawUtils.paintInfoBox(b,this,highlightNode.getDrawX() + highlightNode.getWidth(), highlightNode.getDrawY(), highlightNode);
        } else if (highlightEdge != null && highlightEdge.isVisible() && !addingEdge) {
        	DrawUtils.paintInfoBox(b,this,currentCursorX, currentCursorY, highlightEdge);
        }
        
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
        b.setColor(Color.GRAY);
        b.drawRect(0,-1,getWidth(), getHeight());
        g.drawImage(buffer,0,0,this);
	}
	
	public void loadXML(InputStream stream) {
		XMLLoader.LoadXML(stream, this);
		map.startMotion();
		map.resetDamper();
	}

	public void componentHidden(ComponentEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	public void componentMoved(ComponentEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	public void componentResized(ComponentEvent arg0) {
		buffer = null;
	}

	public void componentShown(ComponentEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	public void mouseClicked(MouseEvent arg0) {
		if (arg0.getButton() == MouseEvent.BUTTON3) {
			if (highlightNode == null) {
				this.mnuHideConnected.setEnabled(false);
				this.mnuHideUnconnected.setEnabled(false);
				this.mnuShowEgoNet.setEnabled(false);
				clickedNode = null;
			} else {
				this.mnuHideConnected.setEnabled(true);
				this.mnuHideUnconnected.setEnabled(true);
				this.mnuShowEgoNet.setEnabled(true);
				clickedNode = highlightNode;
			}
			popMenu.show(this, arg0.getX(), arg0.getY());
		} else if (arg0.getButton() == MouseEvent.BUTTON1 && arg0.getClickCount() == 2) {
			try {
				if (this.highlightNode.getUrl() != null) NetworkMapApplet.showDocument(highlightNode.getUrl());
			} catch (Exception e) {}
		}
			
		
	}

	public void mouseEntered(MouseEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	public void mouseExited(MouseEvent arg0) {
		highlightNode = null;
		repaint();
		
	}

	public void mousePressed(MouseEvent e) {
		if (e.getButton() == MouseEvent.BUTTON1) {
			if (addingEdge && this.addingEdgeStartNode == null) {
		        Iterator i = map.getNodes().iterator();
		        while (i.hasNext()) {
		        	DisplayNode n = (DisplayNode)i.next();
		            if (n.isVisible() && (n.getDrawX() <= e.getX() && n.getDrawY() <= e.getY() && e.getX() <= n.getDrawX() + n.getWidth() && e.getY() <= n.getDrawY() + n.getHeight())) {
		            	addingEdgeStartNode = n;
		                repaint();
		                break;
		            }
		            if (addingEdgeStartNode != null) {
		            	addEdgeLabel.setText("Choose the end node...");
		            }
		        }
			} else if (addingEdge && this.addingEdgeStartNode != null) {
				
		        Iterator i = map.getNodes().iterator();
		        Node end = null;
		        while (i.hasNext()) {
		        	DisplayNode n = (DisplayNode)i.next();
		            if (n.isVisible() && (n.getDrawX() <= e.getX() && n.getDrawY() <= e.getY() && e.getX() <= n.getDrawX() + n.getWidth() && e.getY() <= n.getDrawY() + n.getHeight())) {
		            	end = n;
		                repaint();
		                break;
		            }
		        }
		        if (end != null) {
		        	addNodeFromPopup = false;
		        	addEdgePopup.show();
		        	if (addNodeFromPopup) {
			        	DisplayEdge edge = new DisplayEdge(addingEdgeStartNode, end);
			        	edge.setLength(2000);
			        	edge.setWidth(Integer.parseInt(cmbEdgeWidth.getSelectedItem().toString()));
			        	Iterator mKeys = this.addEdgeCombos.keySet().iterator();
			        	while (mKeys.hasNext()) {
			        		String name = (String)mKeys.next();
			        		JComboBox box = (JComboBox)addEdgeCombos.get(name);
			        		edge.addProperty(name, box.getSelectedItem().toString());
			        		
			        		Iterator ei = map.getEdges().iterator();
			        		while (ei.hasNext()) {
			        			Edge ee = (Edge)ei.next();
			        			if (ee instanceof DisplayEdge && ee.getProperty(name)!=null && ee.getProperty(name).equals(box.getSelectedItem().toString())) {
			        				edge.setColor(((DisplayEdge)ee).getColor());
			        				break;
			        			
			        			}
			        		}
			        		
			        	}
			        	map.AddEdge(edge);
			        	map.resetDamper();
			        	

			        	
		        	}
		        	stopAddingEdge();
		        } else {
		        	stopAddingEdge();
		        }
			} else {
		        lastDragLocation = e.getPoint();
		        Iterator i = map.getNodes().iterator();
		        while (i.hasNext()) {
		        	DisplayNode n = (DisplayNode)i.next();
		            if (n.isVisible() && (n.getDrawX() <= e.getX() && n.getDrawY() <= e.getY() && e.getX() <= n.getDrawX() + n.getWidth() && e.getY() <= n.getDrawY() + n.getHeight())) {
		                map.setDragNode(n);
		                repaint();
		                break;
		            }
		        }
			}
		}
	}
	
	private void stopAddingEdge() {
    	addingEdge = false;
    	addingEdgeStartNode = null;
    	this.setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
    	this.addEdgeLabel.setText("");
	}
	public void mouseReleased(MouseEvent e) {
		if (e.getButton() == MouseEvent.BUTTON1) {
			map.setDragNode(null);
	        repaint();
		}
	}
	
	public void adjustScale(float amount) {
		setScale(currentScale + amount);
	}
	
	public void setScale(float amount) {
		if (amount != currentScale) {
			currentScale = amount;
			if (currentScale > MAX_SCALE) currentScale = MAX_SCALE;
			else if (currentScale < MIN_SCALE) currentScale = MIN_SCALE;
			
			Iterator i = zoomChangeListeners.iterator();
			while (i.hasNext()) ((ZoomChangeListener)i.next()).scaleChangedTo(currentScale);
			
			repaint();
		}
		
	}
	
	public float getScale() {
		return currentScale;
	}

	public void mouseWheelMoved(MouseWheelEvent arg0) {
		adjustScale(arg0.getWheelRotation()/100F);
		
	}

	public void mouseDragged(MouseEvent e) {
			if (map.getDragNode() == null && !addingEdge) {
	            origin.x = origin.x + (int)((lastDragLocation.x - e.getX()) / currentScale);
	            origin.y = origin.y + (int)((lastDragLocation.y - e.getY()) / currentScale);
	            repaint();
	            lastDragLocation = e.getPoint();
				
			} else {
//				map.getDragNode().setX((e.getX() - getWidth() / 2 + origin.x) / currentScale);
//				map.getDragNode().setY((e.getY() - getHeight() / 2 - origin.y) / currentScale);
				
				map.getDragNode().setX(DrawUtils.translateXFromDrawToActual(e.getX(), getWidth(), origin, currentScale));
				map.getDragNode().setY(DrawUtils.translateYFromDrawToActual(e.getY(), getHeight(), origin, currentScale));
	            //if (m_Map.DragNode.NodeGroup != null) m_Map.DragNode.NodeGroup.UpdateDrawAreaAfterMove(m_Map.DragNode);
	            repaint();
	            map.resetDamper();
	
			}
		}		
		

	public void mouseMoved(MouseEvent e) {
		
			currentCursorX = e.getX();
			currentCursorY = e.getY();
			if (map.getDragNode() == null) {
	            DisplayNode NewHighlightNode = null;
	            DisplayEdge NewHighlightEdge = null;
	            if (highlightNode != null && e.getX() >= highlightNode.getDrawX() && e.getX() <= highlightNode.getDrawX() + highlightNode.getWidth() && e.getY() >= highlightNode.getDrawY() && e.getY() <= highlightNode.getDrawY() + highlightNode.getHeight()) {
	                NewHighlightNode = highlightNode;
	            }
	            else {
	            	Iterator i = map.getNodes().iterator();
	            	boolean nodeFound = false;
	            	while (i.hasNext()) {
	            		DisplayNode n = (DisplayNode)i.next();
	                    if (n.isVisible()) {
	                        if (e.getX() >= n.getDrawX() && e.getX() <= n.getDrawX() + n.getWidth() && e.getY() >= n.getDrawY() && e.getY() <= n.getDrawY() + n.getHeight()) {
	                            NewHighlightNode = n;
	                            nodeFound = true;
	                            break;
	                        }
	                    }
	                }
	            	if (!nodeFound) {
	            		i = map.getEdges().iterator();
	            		while (i.hasNext()) {
	            			Edge edge = (Edge)i.next();
	            			if (edge instanceof DisplayEdge && edge.isVisible()) {
	            				if (DrawUtils.distancePointLine(
	            						e.getX(),
	            						e.getY(),
	            						((DisplayEdge)edge).getDrawXFrom(),
	            						((DisplayEdge)edge).getDrawYFrom(),
	            						((DisplayEdge)edge).getDrawXTo(),
	            						((DisplayEdge)edge).getDrawYTo()) < 4 + ((DisplayEdge)edge).getWidth()) {
	            					NewHighlightEdge = (DisplayEdge)edge;
	            					break;
	            				}
	            			}
	            		}
	            	}
	            }
	            if (highlightNode != NewHighlightNode || NewHighlightEdge != highlightEdge) {
	            	highlightNode = NewHighlightNode;
	            	highlightEdge = NewHighlightEdge;
	                repaint();
	            }
	            
	            
	        }
			
			if (this.addingEdge) repaint();
		}


	public void removeEdge(Edge e) {
		map.RemoveEdge(e);
		
	}

	public Collection getEdges() {
		return map.getEdges();
	}

	public Collection getNodes() {
		return map.getNodes();
	}

	public void actionPerformed(ActionEvent arg0) {
		if (arg0.getSource() == this.mnuMakeAllCircles) {
			class makeCircles extends OperateOnAllElements {
				public void operate(Element element, Object extra) {
					((DisplayNode)element).setDisplayMode(DisplayNode.DISPLAY_MODE_CIRCLE);
				}
				
			}
			map.OperateOnAllNodes(new makeCircles(), null);
			repaint();
		}else if (arg0.getSource() == this.mnuMakeAllLabels) {
			class makeCircles extends OperateOnAllElements {
				public void operate(Element element, Object extra) {
					((DisplayNode)element).setDisplayMode(DisplayNode.DISPLAY_MODE_LABEL);
				}
				
			}
			map.OperateOnAllNodes(new makeCircles(), null);
			repaint();
		} else if (arg0.getSource() == this.mnuHideConnected) {
			if (clickedNode != null) {
				Iterator i = clickedNode.getConnected().iterator();
				while (i.hasNext()) {
					Node n = (Node)i.next();
					n.setVisible(false);
					n.setActive(false);
				}
				map.resetDamper();
			}
		} else if (arg0.getSource() == this.mnuShowAllNodes) {
			Iterator i = map.getNodes().iterator();
			while (i.hasNext()) {
				Node n = (Node)i.next();
				n.setVisible(true);
				n.setActive(true);
			}
			map.resetDamper();
		} else if (arg0.getSource() == this.mnuHideUnconnected) {
			if (clickedNode != null) {
				Collection connected = clickedNode.getConnected();
				Iterator i = map.getNodes().iterator();
				while (i.hasNext()) {
					Node n = (Node)i.next();
					if (!connected.contains(n)) {
						n.setVisible(false);
						n.setActive(false);
					}
				}
				map.resetDamper();
			}
		} else if (arg0.getSource() == this.addEdgeButton) {
			addEdgeButtonPressed();
		} else if (arg0.getSource() == this.cancelPopupButton) {
			addEdgePopup.hide();
		} else if (arg0.getSource() == this.addEdgePopupButton) {
			Iterator i = this.addEdgeCombos.values().iterator();
			boolean allSet = true;
			while (i.hasNext()) {
				JComboBox box = (JComboBox)i.next();
				if (box.getSelectedItem().equals("Choose...")) allSet = false;
			}
			if (allSet) {
				addNodeFromPopup = true;
				addEdgePopup.hide();
			} else {
				JOptionPane.showMessageDialog(addEdgePopup, "Please supply a value for all requested fields.");
			}
		} else if (arg0.getSource() == this.mnuUngroup) {
			NodeGroup.clearCollections(this);
			map.resetDamper();
		} else if (this.nodeColorMenuItems.contains(arg0.getSource())) {
			HashMap nodeColors = new HashMap();
			Iterator i = map.getNodes().iterator();
			String prop = ((MenuItem)arg0.getSource()).getLabel();
			int colorIndex = 0;
			while (i.hasNext()) {
				DisplayNode node = (DisplayNode)i.next();
				if (nodeColors.get(node.getProperty(prop)) == null) {
					nodeColors.put(node.getProperty(prop), DrawUtils.colors[colorIndex]);
					colorIndex = colorIndex + 1;
					if (colorIndex >= DrawUtils.colors.length) colorIndex = 0;
				}
				node.setColor((Color)nodeColors.get(node.getProperty(prop)));
			}
			
			map.resetDamper();
		} else if (this.nodeGroupMenuItems.contains(arg0.getSource())) {
			NodeGroup.GroupNodesBy(((MenuItem)arg0.getSource()).getLabel(), this);
			map.resetDamper();
		} else if (arg0.getSource() == mnuEgoNetOneLevel || arg0.getSource() == mnuEgoNetTwoLevel || arg0.getSource() == mnuEgoNetThreeLevel) {
			int level = 1;
			if (arg0.getSource() == mnuEgoNetTwoLevel) level = 2;
			if (arg0.getSource() == mnuEgoNetThreeLevel) level = 3;
			if (clickedNode != null) {
				Collection connected = clickedNode.getConnected(level);
				Iterator i = map.getNodes().iterator();
				while (i.hasNext()) {
					Node n = (Node)i.next();
					if (!connected.contains(n)) {
						n.setVisible(false);
						n.setActive(false);
					} else {
						n.setVisible(true);
						n.setActive(true);
					}
				}
				
				this.origin = new Point((int)clickedNode.getX(), (int)clickedNode.getY());
				
				clickedNode.setDisplayMode(DisplayNode.DISPLAY_MODE_BIG);
				
				map.resetDamper();
				
			}
		
		}
		
	}

	public void addNode(DisplayNode node) throws NodeAlreadyExistsException {
		map.AddNode(node);
		
	}

	public Node findNode(String id) {
		return map.findNode(id);
	}
	
	public void edgePropertyAdded(String name, String value){
		if (parentFilterer != null) parentFilterer.edgePropertyAdded(name, value);
		
		if (!addEdgeCombos.containsKey(name)) {
			int h = addEdgeComboPanel.getHeight();
			JComboBox box = new JComboBox();
			JLabel lbl = new JLabel(name + ": ");
			addEdgeCombos.put(name, box);
	    	addEdgeConstraints.anchor = GridBagConstraints.EAST;
	    	addEdgeConstraints.gridwidth = GridBagConstraints.RELATIVE;
	    	addEdgeBag.setConstraints(lbl, addEdgeConstraints);
	    	addEdgeComboPanel.add(lbl);
	    	addEdgeConstraints.anchor = GridBagConstraints.WEST;
	    	addEdgeConstraints.gridwidth = GridBagConstraints.REMAINDER;
	    	addEdgeBag.setConstraints(box, addEdgeConstraints);
	    	addEdgeComboPanel.add(box);
	    	//this.addEdgePopup.setSize(addEdgePopup.getSize().height + addEdgeComboPanel.getHeight() - h, addEdgePopup.getSize().width);
	    	box.addItem("Choose...");
		}
		
		JComboBox theBox = (JComboBox)addEdgeCombos.get(name);
		boolean found = false;
		for (int i=0; i<theBox.getItemCount(); i++)
			if (theBox.getItemAt(i).equals(value)) {
				found = true;
				break;
			}
		if (!found) theBox.addItem(value);
			
		
	}


	public void nodePropertyAdded(String name, String value) {
		if (!this.nodePropertyNames.contains(name)) {
			MenuItem item = new MenuItem(name);
			item.addActionListener(this);
			this.mnuGroupBy.add(item);
			this.nodePropertyNames.add(name);
			this.nodeGroupMenuItems.add(item);
			
			item = new MenuItem(name);
			item.addActionListener(this);
			this.mnuColorBy.add(item);
			this.nodeColorMenuItems.add(item);
			
			
		}
		
	}

	public void addEdge(DisplayEdge e) {
		map.AddEdge(e);
		
	}
	
	public void filterEdges(String name, String value) {
		Iterator i = map.getEdges().iterator();
		while (i.hasNext()) {
			Edge e = (Edge)i.next();
			if (e.isFilterable()) {
				if (value.equals(SHOW_ALL_FILTER) || (e.getProperty(name) != null && e.getProperty(name).equals(value))) {
					e.setVisible(true);
					e.setActive(true);
				} else {
					e.setVisible(false);
					e.setActive(false);
				}
			}
		}
		
		map.resetDamper();
		
	}
	
	private void addEdgeButtonPressed() {
		Cursor r;
		this.setCursor(new Cursor(Cursor.HAND_CURSOR));
    	addEdgeLabel.setText("Choose the start node...");
    	controlPanel.validate();

		addingEdge = true;
	}

}
