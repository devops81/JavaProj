package com.openq.networkmap.elements;

import java.awt.Color;
import java.awt.Image;
import java.util.Iterator;

public class DisplayEdge extends Edge implements IDisplayElement {
	
	private int width;
	private Color color;
	private int drawXFrom, drawXTo, drawYFrom, drawYTo;
	private int arrow = ARROW_TO;
	
	public static final int ARROW_TO = 0;
	public static final int ARROW_FROM = 1;
	public static final int ARROW_BOTH = 2;
	public static final int ARROW_NONE = 3;
	

	public int getArrow() {
		return arrow;
	}
	public void setArrow(int arrow) {
		this.arrow = arrow;
	}
	public int getDrawXFrom() {
		return drawXFrom;
	}
	public void setDrawXFrom(int drawXFrom) {
		this.drawXFrom = drawXFrom;
	}
	public int getDrawXTo() {
		return drawXTo;
	}
	public void setDrawXTo(int drawXTo) {
		this.drawXTo = drawXTo;
	}
	public int getDrawYFrom() {
		return drawYFrom;
	}
	public void setDrawYFrom(int drawYFrom) {
		this.drawYFrom = drawYFrom;
	}
	public int getDrawYTo() {
		return drawYTo;
	}
	public void setDrawYTo(int drawYTo) {
		this.drawYTo = drawYTo;
	}
	public DisplayEdge(Node from, Node to) {
		super (from,to);
	}
	public DisplayEdge(Node from, Node to, float length) {
		super (from,to,length);
	}


	public Color getColor() {
		return color;
	}

	public void setColor(Color color) {
		this.color = color;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}
	
	public String toString() {
		StringBuffer buf = new StringBuffer();
		
		buf.append("From: ").append(this.getFrom().getId()).append("\n");
		buf.append("To: ").append(this.getTo().getId()).append("\n");
		Iterator i = properties.keySet().iterator();
		while (i.hasNext()) {
			String name = (String)i.next();
			buf.append(" ").append(name).append(":").append(properties.get(name)).append("\n");
			
		}
		
		return buf.toString();
	}
	public Image getFullImage() {
		return null;
	}
	public String getFullInfo() {
		StringBuffer buf = new StringBuffer();
		if (getFrom() != null && getFrom() instanceof DisplayNode && getTo() != null && getTo() instanceof DisplayNode) {
			buf.append("From <b>" + ((DisplayNode)getFrom()).getDisplayLabel() + "</b> to <b>" + ((DisplayNode)getTo()).getDisplayLabel() + "</b><BR><HR>");

		}
		Iterator i = properties.keySet().iterator();
		while (i.hasNext()) {
			String name = (String)i.next();
			buf.append(" ").append(name).append(": ").append(properties.get(name)).append("<BR>");
			
		}
		
		
		return "<html>" + buf.toString() + "</html>";
		
	}
}
