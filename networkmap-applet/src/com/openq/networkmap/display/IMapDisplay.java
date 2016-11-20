package com.openq.networkmap.display;

import java.util.Collection;

import com.openq.networkmap.elements.DisplayEdge;
import com.openq.networkmap.elements.Edge;

public interface IMapDisplay {
	public void mapUpdated();
	public void removeEdge(Edge e);
	public void addEdge(DisplayEdge e);
	public Collection getNodes();
	public Collection getEdges();
}
