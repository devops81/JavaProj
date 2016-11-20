package com.openq.networkmap.elements;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Composite;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.util.Iterator;


public class DisplayNode extends Node implements ImageObserver, IDisplayElement {
	
	public static final int DISPLAY_MODE_LABEL = 0;
	public static final int DISPLAY_MODE_CIRCLE = 1;
	public static final int DISPLAY_MODE_BIG = 2;
	
	private boolean drawnHighlighted = false;
	private boolean drawnHighlightedAddingEdge = false;
	
    private static final int SHADOW_OFFSET = 3;
    private static final int WRITING_BORDER = 3;
    private static final int CIRCLE_SIZE = 12;
    private static final int CORNER_ARC = 10;
    private static final int BIG_GRADIENT_BORDER = 6;
    
    final static BasicStroke NORMAL_STROKE = new BasicStroke(1.0f);
    final static BasicStroke WIDE_STROKE = new BasicStroke(2.0f);
    final static BasicStroke SUPER_WIDE_STROKE = new BasicStroke(4.0f);

    
    private static final Color HIGHLIGHT_OUTLINE_COLOR = Color.ORANGE.darker();
    private static final Color HIGHLIGHT_TEXT_COLOR = Color.ORANGE.darker().darker();
    private static final Color ADDINGEDGE_COLOR = Color.YELLOW;
    
    private Image iconImage;
    private Image fullImage;
	
	private Color color;
	private Color outlineColor = Color.black;
	private static Font font = new Font("Verdana", Font.PLAIN, 10);
	private static Font bigFont = new Font("Verdana", Font.BOLD, 12);
	private int displayMode = DISPLAY_MODE_LABEL;
	private int lastGeneratedDisplayMode = -1;
	private String displayLabel;
	private int fontSize = 8;
	private int drawX = 0;
	private int drawY = 0;
	private int width = 0;
	private int height = 0;
	private BufferedImage image;
	private String url;
	
	
	
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getDisplayLabel() {
		return displayLabel;
	}

	public void setDisplayLabel(String displayLabel) {
		this.displayLabel = displayLabel;
	}

	public DisplayNode(String id) {
		super(id);
	}
	
	public void setDisplayMode(String mode) {
		if (mode.toLowerCase().trim().equals("circle")) {
			displayMode = DISPLAY_MODE_CIRCLE;
		}	else if (mode.toLowerCase().trim().equals("big")) {
			displayMode = DISPLAY_MODE_BIG;
		} else {
			displayMode = DISPLAY_MODE_LABEL;
		}
	}

	public Color getColor() {
		return color;
	}

	public void setColor(Color color) {
		this.color = color;
		image = null;
	}

	public int getDisplayMode() {
		return displayMode;
	}

	public void setDisplayMode(int displayMode) {
		this.displayMode = displayMode;
	}

	public int getFontSize() {
		return fontSize;
	}

	public void setFontSize(int fontSize) {
		this.fontSize = fontSize;
	}
	
	public String toString() {
		StringBuffer buf = new StringBuffer();
		
		buf.append(Id).append("\n");
		buf.append(" ").append(displayLabel).append("\n");
		Iterator i = properties.keySet().iterator();
		while (i.hasNext()) {
			String name = (String)i.next();
			buf.append(" ").append(name).append(":").append(properties.get(name)).append("\n");
			
		}
		
		return buf.toString();
	}

	public int getDrawX() {
		return drawX;
	}

	public void setDrawX(int drawX) {
		this.drawX = drawX;
	}

	public int getDrawY() {
		return drawY;
	}

	public void setDrawY(int drawY) {
		this.drawY = drawY;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public Image getImage(boolean highlight, boolean addingEdge) {
		
        if (image == null || lastGeneratedDisplayMode != displayMode || drawnHighlighted != highlight || addingEdge != drawnHighlightedAddingEdge) {

        	if (displayMode == this.DISPLAY_MODE_CIRCLE) {
        		image = new BufferedImage(CIRCLE_SIZE+1, CIRCLE_SIZE+1, BufferedImage.TYPE_INT_ARGB);
        		Graphics2D g = image.createGraphics();
        		g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        		g.setColor(color);
                g.fillOval(0, 0, CIRCLE_SIZE, CIRCLE_SIZE);
                if (highlight) {
                	g.setColor(HIGHLIGHT_OUTLINE_COLOR);
                	
                } else {
                	g.setColor(outlineColor);
                }
                g.drawOval(0, 0, CIRCLE_SIZE, CIRCLE_SIZE);
            } else if (displayMode == DISPLAY_MODE_LABEL) {
            	BufferedImage tempImage = new BufferedImage(10,10,BufferedImage.TYPE_INT_ARGB);
            	Graphics2D tmpG = tempImage.createGraphics();
            	tmpG.setFont(font);
            	FontMetrics met = tmpG.getFontMetrics();
            	
                int bh = met.getHeight() + WRITING_BORDER * 2;
                int bw = met.stringWidth(displayLabel) + WRITING_BORDER * 2;
                if (iconImage != null) {
                	bw = bw + iconImage.getWidth(this);
                	bh = Math.max(bh, iconImage.getHeight(this));
                }
                
                
        		image = new BufferedImage(bw + SHADOW_OFFSET, bh + SHADOW_OFFSET, BufferedImage.TYPE_INT_ARGB);
        		Graphics2D g = image.createGraphics();
        		g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

				Composite oldComposite = g.getComposite();
				g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
				g.setColor(Color.GRAY.darker());
				g.fillRoundRect(SHADOW_OFFSET, SHADOW_OFFSET, bw, bh, CORNER_ARC,CORNER_ARC);
				g.setComposite(oldComposite);

        		
				
        		
        		g.setColor(color);
        		g.fillRoundRect(0, 0, bw, bh, CORNER_ARC,CORNER_ARC);
                if (highlight && addingEdge) {
                	g.setColor(ADDINGEDGE_COLOR);
                	g.setStroke(SUPER_WIDE_STROKE);
                } else if (highlight) {
                	g.setColor(HIGHLIGHT_TEXT_COLOR);
                	g.setStroke(WIDE_STROKE);
                } else {
                	g.setStroke(NORMAL_STROKE);
                	g.setColor(outlineColor);
                }
        		g.drawRoundRect(0, 0, bw, bh, CORNER_ARC,CORNER_ARC);
        		
        		g.setFont(font);
        		
        		if (iconImage != null) {
        			g.drawImage(iconImage,WRITING_BORDER,(bh - iconImage.getHeight(this))/2,null);
            		g.drawString(displayLabel, WRITING_BORDER + iconImage.getWidth(this), met.getHeight());
        		} else {
            		g.drawString(displayLabel, WRITING_BORDER, met.getHeight());
        		}
            } else if (displayMode == DISPLAY_MODE_BIG) {
	        	BufferedImage tempImage = new BufferedImage(10,10,BufferedImage.TYPE_INT_ARGB);
	        	Graphics2D tmpG = tempImage.createGraphics();
	        	tmpG.setFont(bigFont);
	        	FontMetrics met = tmpG.getFontMetrics();
	        	
	            int bh = met.getHeight() + WRITING_BORDER * 2;
	            int bw = met.stringWidth(displayLabel) + WRITING_BORDER * 2;
	            if (iconImage != null) {
	            	bw = bw + iconImage.getWidth(this);
	            	bh = Math.max(bh, iconImage.getHeight(this));
	            }

	            image = new BufferedImage(bw + SHADOW_OFFSET + BIG_GRADIENT_BORDER*2, bh + SHADOW_OFFSET + BIG_GRADIENT_BORDER*2, BufferedImage.TYPE_INT_ARGB);
	    		
	    		Graphics2D g = image.createGraphics();
	    		g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

	    		Composite oldComposite = g.getComposite();
				g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
				g.setColor(Color.GRAY.darker());
				g.fillRoundRect(SHADOW_OFFSET, SHADOW_OFFSET, bw + BIG_GRADIENT_BORDER*2, bh + BIG_GRADIENT_BORDER*2, CORNER_ARC,CORNER_ARC);
				g.setComposite(oldComposite);

				g.setColor(color);
				g.setPaint(new GradientPaint(-20, -20, Color.white, bw + BIG_GRADIENT_BORDER*2+40, bh + BIG_GRADIENT_BORDER*2+40, color));
	    		g.fillRoundRect(0, 0, bw + BIG_GRADIENT_BORDER*2, bh + BIG_GRADIENT_BORDER*2, CORNER_ARC,CORNER_ARC);

	    		if (highlight && addingEdge) {
	            	g.setColor(ADDINGEDGE_COLOR);
	            	g.setStroke(SUPER_WIDE_STROKE);
	            } else if (highlight) {
	            	g.setColor(HIGHLIGHT_TEXT_COLOR);
	            	g.setStroke(WIDE_STROKE);
	            } else {
	            	g.setStroke(NORMAL_STROKE);
	            	g.setColor(outlineColor);
	            }
	    		g.drawRoundRect(0, 0, bw + BIG_GRADIENT_BORDER*2, bh + BIG_GRADIENT_BORDER*2, CORNER_ARC,CORNER_ARC);
	    		
	    		
//	            int odx = dx - BIG_GRADIENT_BORDER;
//				int ody = dy - BIG_GRADIENT_BORDER;
//				int odh = dh + BIG_GRADIENT_BORDER*2;
//				int odw = dw + BIG_GRADIENT_BORDER*2;
//				
//				g2.setPaint(new GradientPaint(odx-20, ody-20, tgPanel.getBackground(), odx+odw+40, ody+odh+40, backCol));
//
//				// Draw the outside, background shape
//				if (typ == TYPE_ROUNDRECT) {
//					g2.fillRoundRect(odx, ody, odw, odh, r, r);
//				} else if (typ == TYPE_ELLIPSE) {
//					g2.fillOval(odx, ody, odw, odh);
//				} else if (typ == TYPE_CIRCLE) {
//					g2.fillOval(odx, ody, odw, odw);
//				} else { // TYPE_RECTANGLE
//					g2.fillRect(odx, ody, odw, odh);
//				}
//				
//				// Draw a border around the outside of the node
//				Color borderCol = getPaintBorderColor(tgPanel);
//				g2.setColor(borderCol);
//				if (typ == TYPE_ROUNDRECT) {
//					g2.drawRoundRect(odx, ody, odw, odh, r, r);
//					//g2.drawRoundRect(dx, dy, dw, dh, r, r);
//				} else if (typ == TYPE_ELLIPSE) {
//					g2.drawOval(odx, ody, odw, odh);
//					g2.drawOval(dx, dy, dw, dh);
//				} else if (typ == TYPE_CIRCLE) {
//					g2.drawOval(odx, ody, odw, odw);
//					g2.drawOval(dx, dy, dw, dw);
//				} else { // TYPE_RECTANGLE
//					g2.drawRect(odx, ody, odw, odh);
//					g2.drawRect(dx, dy, dw, dh);
//				}
//
//				
//				//draw the inside shape
//				g2.setPaint(new GradientPaint(odx-20, ody-20, backCol, odx+odw+40, ody+odh+40, tgPanel.getBackground()));
//				if (typ == TYPE_ROUNDRECT) {
//					g2.fillRoundRect(dx, dy, dw, dh, r, r);
//				} else if (typ == TYPE_ELLIPSE) {
//					g2.fillOval(dx, dy, dw, dh);
//				} else if (typ == TYPE_CIRCLE) {
//					g2.fillOval(dx, iy - w / 2 + 2, dw, dw);
//				} else { // TYPE_RECTANGLE
//					g2.fillRect(dx, dy, dw, dh);
//				}
	            
	            
	
	
	    		
				
	    		
				g.setColor(color);
				g.setPaint(new GradientPaint(-20, -20, color, bw + BIG_GRADIENT_BORDER*2+40, bh + BIG_GRADIENT_BORDER*2+40, Color.white));
	    		g.fillRoundRect(BIG_GRADIENT_BORDER, BIG_GRADIENT_BORDER, bw, bh, CORNER_ARC,CORNER_ARC);
	    		
	    		g.setFont(bigFont);
                if (highlight && addingEdge) {
                	g.setColor(ADDINGEDGE_COLOR);
                	g.setStroke(SUPER_WIDE_STROKE);
                } else if (highlight) {
                	g.setColor(HIGHLIGHT_TEXT_COLOR);
                	g.setStroke(WIDE_STROKE);
                } else {
                	g.setStroke(NORMAL_STROKE);
                	g.setColor(outlineColor);
                }	    		
	    		if (iconImage != null) {
	    			g.drawImage(iconImage,WRITING_BORDER + BIG_GRADIENT_BORDER,(bh - iconImage.getHeight(this))/2 + BIG_GRADIENT_BORDER,null);
	        		g.drawString(displayLabel, WRITING_BORDER + iconImage.getWidth(this) + BIG_GRADIENT_BORDER, met.getHeight() + BIG_GRADIENT_BORDER);
	    		} else {
	        		g.drawString(displayLabel, WRITING_BORDER + BIG_GRADIENT_BORDER, met.getHeight() + BIG_GRADIENT_BORDER);
	    		}
	        }

        	width = image.getWidth();
            height = image.getHeight();
            lastGeneratedDisplayMode = displayMode;
            drawnHighlighted = highlight;
        }

		return image;
	}
	
	public String getFullInfo() {
		StringBuffer buf = new StringBuffer();
		
		buf.append("<b>" + getDisplayLabel() + "</b><BR><HR>");
		Iterator i = properties.keySet().iterator();
		while (i.hasNext()) {
			String name = (String)i.next();
			buf.append(" ").append(name).append(": ").append(properties.get(name)).append("<BR>");
			
		}
		
		
		return "<html>" + buf.toString() + "</html>";
		
	}

	public Image getIconImage() {
		return iconImage;
	}

	public void setIconImage(Image iconImage) {
		this.iconImage = iconImage;
	}

	public boolean imageUpdate(Image arg0, int arg1, int arg2, int arg3, int arg4, int arg5) {
		// TODO Auto-generated method stub
		return false;
	}

	public Image getFullImage() {
		return fullImage;
	}

	public void setFullImage(Image fullImage) {
		this.fullImage = fullImage;
	}



}
