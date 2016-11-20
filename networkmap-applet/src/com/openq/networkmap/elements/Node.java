package com.openq.networkmap.elements;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

public class Node extends Element{
	
	private float X = (float)Math.random();
	private float Y = (float)Math.random();
	private float DX = 0;
	private float DY = 0;
	protected String Id;
	private float repulsion = 100;
	private boolean fixed = false;
	private NodeGroup nodeGroup;
	private ArrayList edgesWhereIAmFrom = new ArrayList();
	private ArrayList edgesWhereIAmTo = new ArrayList();
	
	public NodeGroup getNodeGroup() {
		return nodeGroup;
	}
	
	public void addFromEdge(Edge e) {
		edgesWhereIAmFrom.add(e);
	}
	public void addToEdge(Edge e) {
		edgesWhereIAmTo.add(e);
	}


	public void setNodeGroup(NodeGroup nodeGroup) {
		this.nodeGroup = nodeGroup;
	}


	public boolean isFixed() {
		return fixed;
	}


	public void setFixed(boolean fixed) {
		this.fixed = fixed;
	}


	public float getRepulsion() {
		return repulsion;
	}


	public void setRepulsion(float repulsion) {
		this.repulsion = repulsion;
	}


	public Node(String id) {
		this.Id = id;
	}
	
	
	public float getDX() {
		return DX;
	}
	public void setDX(float dx) {
		DX = dx;
	}
	public float getDY() {
		return DY;
	}
	public void setDY(float dy) {
		DY = dy;
	}
	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public float getX() {
		return X;
	}
	public void setX(float x) {
		X = x;
	}
	public float getY() {
		return Y;
	}
	public void setY(float y) {
		Y = y;
	}
	
	public Collection getConnected() {
		return getConnected(-1);
	}
	
	public Collection getConnected(int levels) {
		ArrayList connected = new ArrayList();
		connected.add(this);
		
		for (int i=0; i<levels || levels == -1; i++) {
			int num = connected.size();
			for (int n=0; n<num; n++) {
				Node node = (Node)connected.get(n);
				Iterator ei = node.edgesWhereIAmFrom.iterator();
				while (ei.hasNext()) {
					Edge e = (Edge)ei.next();
					if (e.isActive() && e.isVisible() && !connected.contains(e.getTo())) connected.add(e.getTo());
				}
				ei = node.edgesWhereIAmTo.iterator();
				while (ei.hasNext()) {
					Edge e = (Edge)ei.next();
					if (e.isActive() && e.isVisible() && !connected.contains(e.getFrom())) connected.add(e.getFrom());
				}
			}
			
			if (connected.size() == num) break;
		}
		
		return connected;
	}
	

	
	

}
