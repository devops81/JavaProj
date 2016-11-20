package com.openq.networkmap.display;

import java.applet.Applet;
import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Composite;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Label;
import java.awt.MediaTracker;
import java.awt.Panel;
import java.awt.Point;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.Stroke;
import java.awt.Toolkit;
import java.awt.geom.Line2D;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.net.URL;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import javax.swing.JLabel;

import com.openq.networkmap.elements.DisplayEdge;
import com.openq.networkmap.elements.DisplayNode;
import com.openq.networkmap.elements.Edge;
import com.openq.networkmap.elements.Element;
import com.openq.networkmap.elements.IDisplayElement;
import com.openq.networkmap.elements.Node;
import com.openq.networkmap.elements.NodeGroup;
import com.openq.networkmap.map.Map;
import com.openq.networkmap.map.OperateOnAllElements;

public class DrawUtils {
	
	static final int GROUP_BORDER = 3;
	private static final Color BORDER_COLOR = Color.BLACK;
	
	
	static final float saturation = (float)1.0;
	static final float saturation2 = (float)0.30;
	static final float brightness = (float)0.75;
	static final float brightness2 = (float)0.75;
	static final float saturation3 = (float)0.70;
	static final float brightness3 = (float)0.50;
	
	public static Color[] colors = {
			Color.getHSBColor((float)0.05,saturation,brightness),
			Color.getHSBColor((float)0.10,saturation,brightness),
			Color.getHSBColor((float)0.15,saturation,brightness),
			Color.getHSBColor((float)0.20,saturation,brightness),
			Color.getHSBColor((float)0.40,saturation,brightness),
			Color.getHSBColor((float)0.50,saturation,brightness),
			Color.getHSBColor((float)0.60,saturation,brightness),
			Color.getHSBColor((float)0.70,saturation,brightness),
			Color.getHSBColor((float)0.80,saturation,brightness),
			Color.getHSBColor((float)0.90,saturation,brightness),
			Color.getHSBColor((float)0.08,saturation,brightness),
			Color.getHSBColor((float)0.13,saturation,brightness),
			Color.getHSBColor((float)0.17,saturation,brightness),
			Color.getHSBColor((float)0.30,saturation,brightness),
			Color.getHSBColor((float)0.45,saturation,brightness),
			Color.getHSBColor((float)0.55,saturation,brightness),
			Color.getHSBColor((float)0.65,saturation,brightness),
			Color.getHSBColor((float)0.75,saturation,brightness),
			Color.getHSBColor((float)0.85,saturation,brightness),
			Color.getHSBColor((float)0.95,saturation,brightness),
			Color.getHSBColor((float)0.10,saturation2,brightness2),
			Color.getHSBColor((float)0.20,saturation2,brightness2),
			Color.getHSBColor((float)0.40,saturation2,brightness2),
			Color.getHSBColor((float)0.50,saturation2,brightness2),
			Color.getHSBColor((float)0.60,saturation2,brightness2),
			Color.getHSBColor((float)0.70,saturation2,brightness2),
			Color.getHSBColor((float)0.80,saturation2,brightness2),
			Color.getHSBColor((float)0.90,saturation2,brightness2),
			Color.getHSBColor((float)0.08,saturation2,brightness2),
			Color.getHSBColor((float)0.25,saturation2,brightness2),
			Color.getHSBColor((float)0.45,saturation2,brightness2),
			Color.getHSBColor((float)0.55,saturation2,brightness2),
			Color.getHSBColor((float)0.65,saturation2,brightness2),
			Color.getHSBColor((float)0.75,saturation2,brightness2),
			Color.getHSBColor((float)0.85,saturation2,brightness2),
			Color.getHSBColor((float)0.95,saturation2,brightness2),
			Color.getHSBColor((float)0.10,saturation3,brightness3),
			Color.getHSBColor((float)0.20,saturation3,brightness3),
			Color.getHSBColor((float)0.40,saturation3,brightness3),
			Color.getHSBColor((float)0.50,saturation3,brightness3),
			Color.getHSBColor((float)0.60,saturation3,brightness3),
			Color.getHSBColor((float)0.70,saturation3,brightness3),
			Color.getHSBColor((float)0.80,saturation3,brightness3),
			Color.getHSBColor((float)0.90,saturation3,brightness3),
			Color.getHSBColor((float)0.08,saturation3,brightness3),
			Color.getHSBColor((float)0.25,saturation3,brightness3),
			Color.getHSBColor((float)0.45,saturation3,brightness3),
			Color.getHSBColor((float)0.55,saturation3,brightness3),
			Color.getHSBColor((float)0.65,saturation3,brightness3),
			Color.getHSBColor((float)0.75,saturation3,brightness3),
			Color.getHSBColor((float)0.85,saturation3,brightness3),
			Color.getHSBColor((float)0.95,saturation3,brightness3)
	};
	
	private static FontMetrics fontMetrics = null;
	private static Font groupFont = new Font("Verdana", Font.PLAIN, 10);
	private static FontMetrics getFontMetrics(Graphics2D g) {
		if (fontMetrics == null) {
			g.setFont(groupFont);
			fontMetrics = g.getFontMetrics();
		}
		return fontMetrics;
		
	}
	

		

	
	public static void paint(Graphics2D g, Collection nodes, Collection edges, DisplayNode HighlightNode, DisplayEdge HighlightEdge, Image logo, int width, int height, Point origin, float scale, ImageObserver observer, boolean addingEdge, DisplayNode addingEdgeStartNode, int currentCursorX, int currentCursorY, boolean allAntiAlias) {
        
        if (allAntiAlias) {
    		g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        	
        } else {
    		g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
        }
		g.setColor(Color.WHITE);
		g.fillRect(0,0,width,height);
		
//		g.setColor(Color.red);
//		g.fillOval(origin.x-25, origin.y-25, 50,50);
		

        if (logo != null) {
            g.drawImage(logo, width-10-logo.getWidth(observer), height-20-logo.getHeight(observer), observer);
        }


        Iterator ngi = NodeGroup.getNodeGroups().iterator();
        while (ngi.hasNext()) {
        	NodeGroup ng = (NodeGroup)ngi.next();
        	if (ng.getBottomRight() != null && ng.getTopLeft() != null) {
	        	FontMetrics met = getFontMetrics(g);
	            //Size size = TextRenderer.MeasureText(ng.Name, GROUP_FONT);
	
	            int x = ng.getTopLeft().x - GROUP_BORDER;
	            int y = ng.getTopLeft().y - GROUP_BORDER * 2 - met.getHeight();
	            int w = Math.max(ng.getBottomRight().x - ng.getTopLeft().x + GROUP_BORDER * 2, met.stringWidth(ng.getName()) + GROUP_BORDER * 2);
	            int h = ng.getBottomRight().y - ng.getTopLeft().y + met.getHeight() + GROUP_BORDER * 3;
	            
	            //System.out.println(met.getAscent());
	            
				Composite oldComposite = g.getComposite();
				g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
	            g.setColor(ng.getColor());
	            g.fillRect(x, y, w, h);
				g.setComposite(oldComposite);

	            g.setColor(BORDER_COLOR);
	            g.drawRect(x, y, w, h);
	            g.drawString(ng.getName(), x + GROUP_BORDER, y + GROUP_BORDER + met.getHeight());
        	}
        }


        Iterator ei = edges.iterator();
        while (ei.hasNext()) {
        	DisplayEdge e = (DisplayEdge)ei.next();
            if (e.isVisible() && e.getFrom().isVisible() && e.getTo().isVisible()) {
            	if (e == HighlightEdge) {
            		g.setColor(Color.orange.darker());
            	} else {
            		g.setColor(e.getColor());
            	}
//                g.drawLine((int)(e.getFrom().getX() * scale + width / 2 - origin.getX()), (int)(e.getFrom().getY() * scale + height / 2 + origin.getY()), (int)(e.getTo().getX() * scale + width / 2 - origin.getX()), (int)(e.getTo().getY() * scale + height / 2 + origin.getY()));
            	//Stroke s = new Stroke()
            	Point fromPoint = new Point(translateXFromActualToDraw(e.getFrom().getX(), width, origin, scale),translateYFromActualToDraw(e.getFrom().getY(), height, origin, scale) );
            	Point toPoint = new Point(translateXFromActualToDraw(e.getTo().getX(), width, origin, scale),translateYFromActualToDraw(e.getTo().getY(), height, origin, scale));
            	e.setDrawXFrom(fromPoint.x);
            	e.setDrawYFrom(fromPoint.y);
            	e.setDrawXTo(toPoint.x);
            	e.setDrawYTo(toPoint.y);
            	
            	if (e.getArrow() == DisplayEdge.ARROW_BOTH || e.getArrow() == DisplayEdge.ARROW_TO) {
	                Rectangle toRect = new Rectangle(((DisplayNode)e.getTo()).getDrawX(), ((DisplayNode)e.getTo()).getDrawY(), ((DisplayNode)e.getTo()).getWidth(), ((DisplayNode)e.getTo()).getHeight());
	                
	                Point2D inter = intersection(toRect, new Line2D.Double(fromPoint, toPoint));
	                
	                Point.Double pnt = drawArrowHead(g,fromPoint.x, fromPoint.y,(int)inter.getX(), (int)inter.getY(),(float)e.getWidth());
	                e.setDrawXTo((int)pnt.x);
	                e.setDrawYTo((int)pnt.y);
            	}
            	if (e.getArrow() == DisplayEdge.ARROW_BOTH || e.getArrow() == DisplayEdge.ARROW_FROM) {
	                Rectangle fromRect = new Rectangle(((DisplayNode)e.getFrom()).getDrawX(), ((DisplayNode)e.getFrom()).getDrawY(), ((DisplayNode)e.getFrom()).getWidth(), ((DisplayNode)e.getFrom()).getHeight());
	                
	                Point2D inter = intersection(fromRect, new Line2D.Double(fromPoint, toPoint));
	                
	                Point.Double pnt = drawArrowHead(g,toPoint.x, toPoint.y,(int)inter.getX(), (int)inter.getY(),(float)e.getWidth());
	                e.setDrawXFrom((int)pnt.x);
	                e.setDrawYFrom((int)pnt.y);
            	}
                Stroke str = new BasicStroke(e.getWidth(), BasicStroke.CAP_BUTT, BasicStroke.JOIN_ROUND);
            	g.setStroke(str);
                g.drawLine(e.getDrawXFrom(), e.getDrawYFrom(), e.getDrawXTo(), e.getDrawYTo());
            }
        }
        
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        Iterator ni = nodes.iterator();
        while(ni.hasNext()) {
        	DisplayNode n = (DisplayNode)ni.next();
            drawNodeImage(g, n, width, height, origin, scale, observer,false, addingEdge);
        }

        if (addingEdge) {
			Composite oldComposite = g.getComposite();
			g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
    		g.setColor(Color.LIGHT_GRAY.brighter().brighter());
    		g.fillRect(0,0,width,height);
			g.setComposite(oldComposite);
        }
        if (addingEdgeStartNode != null) {
			drawNodeImage(g, addingEdgeStartNode, width, height, origin, scale, observer,false, addingEdge);
        }
        if (HighlightNode != null) {
            drawNodeImage(g, HighlightNode, width, height, origin, scale, observer,false, addingEdge);
        }
        
        
        if (addingEdge && addingEdgeStartNode != null) {
        	g.setColor(Color.GREEN);
            g.drawLine(translateXFromActualToDraw(addingEdgeStartNode.getX(), width, origin, scale), translateYFromActualToDraw(addingEdgeStartNode.getY(), height, origin, scale), currentCursorX, currentCursorY);
            
        }


    }
    public static void drawNodeImage(Graphics2D g, DisplayNode n, int width, int height, Point origin, float scale, ImageObserver observer, boolean highlight, boolean addingEdge) {
        if (n.isVisible()) {
            //  && n.DrawX > 0 - n.Width && n.DrawX < Width && n.DrawY > 0 - n.Height && n.DrawY < Height
//            n.setDrawX((int)((int)(n.getX() * scale) + (int)(width / 2) - origin.getX() - n.getWidth() / 2));
//            n.setDrawY((int)((int)(n.getY() * scale) + (int)(height / 2) + origin.getY() - n.getHeight() / 2));
        	n.setDrawX(translateXFromActualToDraw(n.getX(),width,origin,scale) - n.getWidth() / 2);
        	n.setDrawY(translateYFromActualToDraw(n.getY(),height,origin,scale)- n.getHeight() / 2);
            g.drawImage(n.getImage(highlight, addingEdge), n.getDrawX(), n.getDrawY(), observer);

        }
    }
    
    public static int translateXFromActualToDraw(float x, int width, Point origin, float scale) {
//    	float tmpX = x;
//    	tmpX = tmpX - origin.x;
//    	tmpX = tmpX * scale;
//    	tmpX = tmpX + width/2;
//    	return (int)tmpX;
    	
    	return (int)((x - origin.x) * scale + width/2);
    }
    public static float translateXFromDrawToActual(float x, int width, Point origin, float scale) {
    	
    	return (x - width/2) / scale  + origin.x;
    }
    public static float translateYFromDrawToActual(float y, int height, Point origin, float scale) {
    	return (y - height/2) / scale  + origin.y;
    
    }
    
    public static int translateYFromActualToDraw(float y, int height, Point origin, float scale) {
//    	float tmpY = y;
//    	tmpY = tmpY - origin.y;
//    	tmpY = (tmpY * scale);
//    	tmpY = tmpY + height/2;
//    	return (int)tmpY;
    	return (int)((y-origin.y) * scale + height/2);
    }
    
//	public static void paintHTMLText(Graphics buffer, Component parent, int x, int y, int width, String text, Color backgroundColor) {
//		if (textLabel == null) {
//			textLabel = new Label();
//			textLabel.setForeground(Color.BLACK);
//			textLabel.setBackground(Color.WHITE);
//			
//			textPanel = new Panel();
//			textPanel.setSize(600, 600);
//			textPanel.setLayout(new BorderLayout());
//			
//			textPanel.add(textLabel, BorderLayout.CENTER);
//			
//		}
//		textLabel.setSize(width, 1500);
//		//textLabel.setVerticalAlignment(JLabel.NORTH);
//		textLabel.setText(text);
//		textLabel.validate();
//		textPanel.validate();
//		textPanel.setSize(textLabel.getPreferredSize());
//		textLabel.setBackground(backgroundColor);
//		
//		Image labelImage = parent.createImage(textLabel.getWidth(), textLabel.getHeight());
//		Graphics g2 = labelImage.getGraphics();
//		textLabel.paint(g2);
//		buffer.drawImage(labelImage,x,y,parent);
//	}
	
	private static Image popUpTop = null;
	private static Dimension popUpTopDimension = null;
	private static Image popUpBottom = null;
	private static Dimension popUpBottomDimension = null;
	private static Image popUpShadow = null;
	private static Dimension popUpShadowDimension = null;
	private static int popupOffset = 109;
	private static int shadowOffset = 50;
	private static JLabel textLabel = null;
	private static int textTopBorder = 10;
	private static int textBottomBorder = 34;
	private static int textSideBorder = 10;
	private static Object imageLoader = null;

	
	static HashMap images = new HashMap();
	private static String[] preloads = {"popup-top.png","popup-middle.png","popup-bottom.png","shadow.png", "paste.png","note_add.png"};

	
	public static void paintInfoBox(Graphics buffer, Component parent, int x, int y, IDisplayElement el) {
		if (popUpTop == null) {
			popUpTop = getImage("popup-top.png", parent);
			popUpTopDimension = new Dimension(popUpTop.getWidth(parent),popUpTop.getHeight(parent));
			popUpBottom = getImage("popup-bottom.png", parent);
			popUpBottomDimension = new Dimension(popUpBottom.getWidth(parent),popUpBottom.getHeight(parent));
			popUpShadow = getImage("shadow.png", parent);
			popUpShadowDimension = new Dimension(popUpShadow.getWidth(parent),popUpShadow.getHeight(parent));
		}
		if (textLabel == null) {
			textLabel = new JLabel();
			textLabel.setForeground(Color.BLACK);
			textLabel.setBackground(Color.WHITE);
			textLabel.setOpaque(true);
			textLabel.setFont(new Font("Verdana",Font.PLAIN, 10));
			
		}
		
		//System.out.println(text);

		textLabel.setText(el.getFullInfo());
		//System.out.println(node.getFullInfo());

		textLabel.setBackground(Color.WHITE);
		
		//System.out.println("Image:" + node.getFullImage());
		
		int labelHeight = 0;
		if (el.getFullImage() != null) {
			textLabel.setSize(popUpTop.getWidth(parent) - textSideBorder * 3 - el.getFullImage().getWidth(parent), textLabel.getPreferredSize().height);
			labelHeight = Math.max(textLabel.getPreferredSize().height, el.getFullImage().getHeight(parent));
		} else {
			textLabel.setSize(popUpTop.getWidth(parent) - textSideBorder * 2, textLabel.getPreferredSize().height);
			labelHeight = textLabel.getPreferredSize().height;
			
		}
		
		// FIrst Draw the shadow of the info box
		buffer.drawImage(popUpShadow, x-shadowOffset, y-popUpShadowDimension.height,parent);
		
		// Then draw the bottom part of the box
		buffer.drawImage(popUpBottom, x - popupOffset, y - popUpBottomDimension.height,parent);
		
		// Calculate how much middle we will need for the label
		//
		// figure out how much we can overlap the top and bottom parts of the box
		int heightAvailableInTopAndBottomImages = popUpTopDimension.height + popUpBottomDimension.height - textBottomBorder - textTopBorder;
		
		// Figure out how much of the middel image we will need
		int howMuchMiddleNeeded = labelHeight - heightAvailableInTopAndBottomImages;
		//System.out.println("heightAvailableInTopAndBottomImages " + heightAvailableInTopAndBottomImages);
		//System.out.println("We need " + howMuchMiddleNeeded + " middle.");
		
		
		
		// Draw that middle part
		buffer.setColor(Color.WHITE);
		buffer.fillRect(x - popupOffset, y - popUpBottomDimension.height - howMuchMiddleNeeded, popUpTopDimension.width, howMuchMiddleNeeded);
		buffer.setColor(Color.decode("#A2A2A2"));
		buffer.fillRect(x - popupOffset, y - popUpBottomDimension.height - howMuchMiddleNeeded,1,howMuchMiddleNeeded);
		buffer.fillRect(x - popupOffset + popUpBottomDimension.width - 1, y - popUpBottomDimension.height - howMuchMiddleNeeded,1,howMuchMiddleNeeded);
		
		//buffer.drawImage(popUpMiddle, x - popupOffset.width, y - popupOffset.height - popUpMiddleDimension.height,parent);
		
		
		// Now Draw the top part in the right place
		buffer.drawImage(popUpTop, x - popupOffset, y - popUpBottomDimension.height - howMuchMiddleNeeded - popUpTopDimension.height,parent);

		Image labelImage = parent.createImage(Math.max(textLabel.getWidth(),1), textLabel.getHeight());
		Graphics g2 = labelImage.getGraphics();
		g2.setColor(Color.WHITE);
		//g2.fillRect(0,0,l.getWidth(), l.getHeight());
		textLabel.paint(g2);
		
		if (el.getFullImage() != null) {
			buffer.drawImage(labelImage, x - popupOffset + textSideBorder*2 + el.getFullImage().getWidth(parent), y - popUpBottomDimension.height - howMuchMiddleNeeded - popUpTopDimension.height +  textTopBorder,parent);
			buffer.drawImage(el.getFullImage(), x - popupOffset + textSideBorder, y - popUpBottomDimension.height - howMuchMiddleNeeded - popUpTopDimension.height + textSideBorder,parent);
		} else {
		
			buffer.drawImage(labelImage, x - popupOffset + textSideBorder, y - popUpBottomDimension.height - howMuchMiddleNeeded - popUpTopDimension.height +  textTopBorder,parent);
		}
		
	}
	
	public static Image getImage(String name, Component parent) {
		if (images.get(name) == null) {
			Image image = null;
			
			if (name.toLowerCase().startsWith("http:")) {
				if (imageLoader instanceof Applet) {
					try {
						//System.out.println("Applet loading " + name);
						image = ((Applet)imageLoader).getImage(new URL(name));
						MediaTracker mediaTracker = new MediaTracker((parent == null ? (Applet)imageLoader : parent));
						mediaTracker.addImage(image, 0);
						mediaTracker.waitForID(0);
					} catch (Exception iew) {
					}
					
				}
			}
			if (image == null) {
				try {
					Toolkit toolkit = Toolkit.getDefaultToolkit();
					System.out.println("Name:"+name);
					if (toolkit != null) {
						image = toolkit.getImage(images.getClass().getResource((name.startsWith("/") ? "" : "/") + name));
						MediaTracker mediaTracker = new MediaTracker((parent == null ? (Applet)imageLoader : parent));
						mediaTracker.addImage(image, 0);
						mediaTracker.waitForID(0);
					}
				} catch (Exception ie) {
					ie.printStackTrace();
				}
			}
			if (image == null) {
				if (imageLoader instanceof Applet) {
					try {
						//System.out.println("Applet loading " + name);
						image = ((Applet)imageLoader).getImage(((Applet)imageLoader).getDocumentBase(),(name.startsWith("/") ? name.substring(1) : name));
						MediaTracker mediaTracker = new MediaTracker((parent == null ? (Applet)imageLoader : parent));
						mediaTracker.addImage(image, 0);
						mediaTracker.waitForID(0);
					} catch (Exception iew) {
						iew.printStackTrace();
						return null;
					}

				}
			}
			if (image != null) images.put(name, image);
			return image;
		} else {
			return (Image)images.get(name);
		}
		
		
	}
	
	public static void preloadImages(Component parent) {
		for (int i=0; i< preloads.length; i++) getImage(preloads[i], parent);
	}
	
	public static void regsiterImageLoader(Object loader) {
		imageLoader = loader;
	}
	
	private static double lineMagnitude(double x1, double y1, double x2, double y2) {
	    return Math.sqrt(((x2 - x1)*(x2-x1)) + ((y2 - y1)*(y2-y1)));
	}
	 
	public static double distancePointLine(double px, double py, double x1, double y1, double x2, double y2) {
//	    ' px,py is the point to test.
//	    ' x1,y1,x2,y2 is the line to check distance.
//	    '
//	    ' Returns distance from the line, or if the intersecting point on the line nearest
//	    ' the point tested is outside the endpoints of the line, the distance to the
//	    ' nearest endpoint.
//	    '
//	    ' Returns 9999 on 0 denominator conditions.
	    double LineMag, ix, iy,u;
	    
	    LineMag = lineMagnitude(x1, y1, x2, y2);
	    
	    
	    if (LineMag < 0.00000001) return 9999;
	   
	    u = (((px - x1) * (x2 - x1)) + ((py - y1) * (y2 - y1)));
	    u = u / (LineMag * LineMag);
	    if (u < 0.00001 || u > 1) {
//	        '// closest point does not fall within the line segment, take the shorter distance
//	        '// to an endpoint
	        ix = lineMagnitude(px, py, x1, y1);
	        iy = lineMagnitude(px, py, x2, y2);
	        if (ix > iy) return iy;
	        else return ix;
	    } else {
//	        ' Intersecting point is on the line, use the formula
	        ix = x1 + u * (x2 - x1);
	        iy = y1 + u * (y2 - y1);
	        return lineMagnitude(px, py, ix, iy);
	    }
	}
	
	public static Point2D intersection(Rectangle2D rec, Line2D line) {
		if (!rec.contains(line.getP1()) && !rec.contains(line.getP2())) {
			return line.getP2();
		} else if (rec.contains(line.getP1()) && rec.contains(line.getP2())) {
			return line.getP2();
		}
		Line2D.Double recLine = null;
		
		// Check the top line
		recLine = new Line2D.Double(rec.getX(), rec.getY(), rec.getX() + rec.getWidth(),rec.getY());
		if (!recLine.intersectsLine(line)) recLine = null;
		
		// Check the right side
		if (recLine == null) {
			recLine = new Line2D.Double(rec.getX() + rec.getWidth(), rec.getY(), rec.getX() + rec.getWidth(),rec.getY()+rec.getHeight());
			if (!recLine.intersectsLine(line)) recLine = null;
		}
		
		// Check the bottom
		if (recLine == null) {
			recLine = new Line2D.Double(rec.getX(), rec.getY()+rec.getHeight(), rec.getX() + rec.getWidth(),rec.getY()+rec.getHeight());
			if (!recLine.intersectsLine(line)) recLine = null;
		}

		// Check the left side
		if (recLine == null) {
			recLine = new Line2D.Double(rec.getX(), rec.getY(), rec.getX(),rec.getY()+rec.getHeight());
			if (!recLine.intersectsLine(line)) recLine = null;
		}

		if (recLine == null) {
			return null;
		} else {
			return intersection(line, recLine);
		}
		
	}
	
	public static Point2D intersection(Line2D line1, Line2D line2) {
		double a1 = line1.getY2()-line1.getY1();
		double b1 = line1.getX1()-line1.getX2();
		double c1 = line1.getX2()*line1.getY1() - line1.getX1()*line1.getY2();

		double a2 = line2.getY2()-line2.getY1();
		double b2 = line2.getX1()-line2.getX2();
		double c2 = line2.getX2()*line2.getY1() - line2.getX1()*line2.getY2();

		double denom = a1*b2 - a2*b1;
		if (denom == 0) {
			return null;
		}
		
		Point2D.Double retVal = new Point2D.Double();
		retVal.x = ((b1*c2 - b2*c1)/denom);
		retVal.y = ((a2*c1 - a1*c2)/denom);
		
		return retVal;
	}
	
	public static Point.Double drawArrowHead(Graphics2D g2d, int xCenter, int yCenter, int x, int y, float stroke) {
	      double aDir=Math.atan2(xCenter-x,yCenter-y);
	      //g2d.drawLine(x,y,xCenter,yCenter);
	      g2d.setStroke(new BasicStroke(1f));					// make the arrow head solid even if dash pattern has been specified
	      Polygon tmpPoly=new Polygon();
	      int i1=6+(int)(stroke*2);
	      int i2=4+(int)stroke;							// make the arrow head the same size regardless of the length length
	      tmpPoly.addPoint(x,y);							// arrow tip
	      tmpPoly.addPoint(x+xCor(i1,aDir+.5),y+yCor(i1,aDir+.5));
	      tmpPoly.addPoint(x+xCor(i2,aDir),y+yCor(i2,aDir));
	      tmpPoly.addPoint(x+xCor(i1,aDir-.5),y+yCor(i1,aDir-.5));
	      tmpPoly.addPoint(x,y);							// arrow tip
	      g2d.drawPolygon(tmpPoly);
	      g2d.fillPolygon(tmpPoly);						// remove this line to leave arrow head unpainted
	      return new Point.Double(x+xCor(i2,aDir),y+yCor(i2,aDir));
	   }
	private static int yCor(int len, double dir) {return (int)(len * Math.cos(dir));}
	private static int xCor(int len, double dir) {return (int)(len * Math.sin(dir));}




}
