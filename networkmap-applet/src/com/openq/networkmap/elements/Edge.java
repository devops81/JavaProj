package com.openq.networkmap.elements;

import java.util.HashMap;

public class Edge extends Element{
	
	private Node from;
	private Node to;
	private float length;
	private boolean filterable = true;
	

	public Edge(Node from, Node to) {
		this.from = from;
		this.to = to;
		
		from.addFromEdge(this);
		to.addToEdge(this);
	}
	public Edge(Node from, Node to, float length) {
		this.from = from;
		this.to = to;
		this.length = length;
		from.addFromEdge(this);
		to.addToEdge(this);
	}
	
	public Node getFrom() {
		return from;
	}
	public void setFrom(Node from) {
		this.from = from;
	}
	public Node getTo() {
		return to;
	}
	public void setTo(Node to) {
		this.to = to;
	}

	public float getLength() {
		return length;
	}

	public void setLength(float length) {
		this.length = length;
	}
	public boolean isFilterable() {
		return filterable;
	}
	public void setFilterable(boolean filterable) {
		this.filterable = filterable;
	}

}
