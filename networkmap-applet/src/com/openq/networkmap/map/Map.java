package com.openq.networkmap.map;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import com.openq.networkmap.display.IMapDisplay;
import com.openq.networkmap.elements.DisplayNode;
import com.openq.networkmap.elements.Edge;
import com.openq.networkmap.elements.Node;

public class Map {
	
	protected HashMap nodes = new HashMap();
	protected ArrayList edges = new ArrayList();
	protected IMapDisplay mapDisplay;
	
	protected float minX;
	protected float minY;
	protected float maxX;
	protected float maxY;
	
	protected DisplayNode dragNode;

	
	
	public DisplayNode getDragNode() {
		return dragNode;
	}

	public void setDragNode(DisplayNode dragNode) {
		this.dragNode = dragNode;
	}

	public void AddNode(DisplayNode node) throws NodeAlreadyExistsException{
		if (nodes.get(node.getId()) != null ) throw new NodeAlreadyExistsException();
		nodes.put(node.getId(),node);
		
		
	}
	
	public Node findNode(String id) {
		return (Node)nodes.get(id);
	}
	
	public void AddEdge(Edge edge) {
		edges.add(edge);
	}
	public void RemoveEdge(Edge edge) {
		edges.remove(edge);
	}
	
	public void OperateOnAllNodes(OperateOnAllElements operator, Object extra) {
		Iterator i = nodes.values().iterator();
		while (i.hasNext()) {
			operator.operate((Node)i.next(), extra);
		}
	}
	public void OperateOnAllEdges(OperateOnAllElements operator, Object extra) {
		Iterator i = edges.iterator();
		while (i.hasNext()) {
			operator.operate((Edge)i.next(), extra);
		}
	}

	public IMapDisplay getMapDisplay() {
		return mapDisplay;
	}

	public void setMapDisplay(IMapDisplay mapDisplay) {
		this.mapDisplay = mapDisplay;
	}
	
	public Collection getNodes() {
		return nodes.values();
	}
	public Collection getEdges() {
		return edges;
	}

	public float getMaxX() {
		return maxX;
	}

	public void setMaxX(float maxX) {
		this.maxX = maxX;
	}

	public float getMaxY() {
		return maxY;
	}

	public void setMaxY(float maxY) {
		this.maxY = maxY;
	}

	public float getMinX() {
		return minX;
	}

	public void setMinX(float minX) {
		this.minX = minX;
	}

	public float getMinY() {
		return minY;
	}

	public void setMinY(float minY) {
		this.minY = minY;
	}
	

}
