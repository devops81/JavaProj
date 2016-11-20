package com.openq.networkmap.load;

import com.openq.networkmap.elements.DisplayEdge;
import com.openq.networkmap.elements.DisplayNode;
import com.openq.networkmap.elements.Edge;
import com.openq.networkmap.elements.Node;
import com.openq.networkmap.map.NodeAlreadyExistsException;

public interface ILoadObserver {
	public void nodePropertyAdded(String name, String value);
	public void edgePropertyAdded(String name, String value);
	public void addNode(DisplayNode node) throws NodeAlreadyExistsException;
	public Node findNode(String id);
	public void addEdge(DisplayEdge e);
}
