package com.openq.networkmap.elements;

import java.awt.Color;
import java.awt.Point;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;

import com.openq.networkmap.display.DrawUtils;
import com.openq.networkmap.display.IMapDisplay;



public class NodeGroup {
	
	ArrayList nodes = new ArrayList();
    ArrayList edges = new ArrayList();
    String name = "Unknown";

    private Color color;

    private Point topLeft;
    private Point bottomRight;

    private static int numGroupEdges = 0;

    private static HashMap groups = new HashMap();

    public static Collection getNodeGroups() {
        return groups.values();
    }

    public static int getNumberofGroupEdges() {
        return numGroupEdges;
    }
    

    public static void clearCollections(IMapDisplay gp) {
    	Iterator i = groups.values().iterator();
    	while (i.hasNext()) ((NodeGroup)i.next()).Clear(gp);
        groups.clear();
        numGroupEdges = 0;
    }

    public Point getTopLeft() {
        return topLeft;
    }

    public Point getBottomRight() {
        return bottomRight;
    }


    public void Clear(IMapDisplay gp) {
    	Iterator i = edges.iterator();
    	while (i.hasNext()) gp.removeEdge((Edge)i.next());
    	
    	i = nodes.iterator();
    	
    	while (i.hasNext()) ((Node)i.next()).setNodeGroup(null);

        edges.clear();
        nodes.clear();
    }
    
    



    public Color getColor() {
		return color;
	}

	public void setColor(Color color) {
		this.color = color;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static NodeGroup getGroup(String name) {
        String NonNullName = (name == null ? "Unknown" : name);
        if (groups.get(NonNullName) == null) {
            NodeGroup g = new NodeGroup();
            g.setName(NonNullName);
            groups.put(NonNullName, g);
        }

        return (NodeGroup)groups.get(NonNullName);
    }




    public void AddNode(Node n, IMapDisplay map) {
        if (!nodes.contains(n)) {
        	Iterator i = nodes.iterator();
        	while (i.hasNext()) {
        		Node n2 = (Node)i.next();
                DisplayEdge e = new DisplayEdge(n, n2,5000);
                numGroupEdges = numGroupEdges + 1;
                e.setActive(true);
                e.setVisible(false);
                e.setFilterable(false);
                map.addEdge(e);
                edges.add(e);
            }
            nodes.add(n);
            n.setNodeGroup(this);
        }
    }

    public boolean ContainsNode(Node n) {
        return nodes.contains(n);
    }

    public void ResetDrawArea() {
        topLeft = null;
        bottomRight = null;
    }

    public static void ResetAllDrawingAreas() {
    	Iterator i = groups.values().iterator();
    	while (i.hasNext()) {
    		Object o = i.next();
    		//System.out.println("*" + o.getClass().getName());
    		((NodeGroup)o).ResetDrawArea();
    	}
    }

    public static void UpdateDrawAreasForAllGroups() {
    	Iterator i = groups.entrySet().iterator();
    	while (i.hasNext()) ((NodeGroup)i.next()).UpdateDrawAreaForNodes();
    }

    public void UpdateDrawAreaForNodes() {
        ResetDrawArea();
    	Iterator i = nodes.iterator();
    	while (i.hasNext()) UpdateDrawAreaAfterMove((DisplayNode)i.next());
    }

    public void UpdateDrawAreaAfterMove(DisplayNode n) {
        if (topLeft == null) {
            topLeft = new Point(n.getDrawX(), n.getDrawY());
            bottomRight = new Point(n.getDrawX() + n.getWidth(), n.getDrawY() + n.getHeight());
        }
        else {
            topLeft.x = Math.min(n.getDrawX(), topLeft.x);
            topLeft.y = Math.min(n.getDrawY(), topLeft.y);

            bottomRight.x = Math.max(bottomRight.x, n.getDrawX() + n.getWidth());
            bottomRight.y = Math.max(bottomRight.y, n.getDrawY() + n.getHeight());
        }
            
    }

    

    public static void GroupNodesBy(String key, IMapDisplay map) {
        NodeGroup.clearCollections(map);
        
        Iterator i = map.getNodes().iterator();
        while (i.hasNext()) {
        	Node n = ((DisplayNode)i.next());
            NodeGroup.getGroup(n.getProperty(key)).AddNode(n, map);
        }

        int colorIndex = 0;
        i = groups.values().iterator();
        while (i.hasNext()) {
        	NodeGroup ng = (NodeGroup)i.next();
            ng.setColor(DrawUtils.colors[colorIndex]);
            colorIndex = colorIndex + 1;
            if (colorIndex == DrawUtils.colors.length) colorIndex = 0;
        }
    }

}
