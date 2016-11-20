package com.openq.networkmap.map;

import java.util.Iterator;

import com.openq.networkmap.elements.DisplayNode;
import com.openq.networkmap.elements.Edge;
import com.openq.networkmap.elements.Node;
import com.openq.networkmap.elements.NodeGroup;

public class SpringMap extends Map implements Runnable {
	
    private Thread relaxer;
    private float damper = 1.0F;      // A low damper value causes the graph to move slowly
    private float maxMotion = 0;     // Keep an eye on the fastest moving node to see if the graph is stabilizing
    private float lastMaxMotion = 0;
    private float motionRatio = 0; // It's sort of a ratio, equal to lastMaxMotion/maxMotion-1
    private boolean damping = true; // When damping is true, the damper value decreases
    private boolean springOn = true;
    private float maxMovePerRound = 100F;

    private float rigidity = 1;    // Rigidity has the same effect as the damper, except that it's a constant
    // a low rigidity value causes things to go slowly.
    // a value that's too high will cause oscillation
    private float newRigidity = 1;


    private synchronized void relaxEdges() {

    	for (int i=0 ;i<edges.size(); i++) {
            Edge e = (Edge)edges.get(i);

            if (e!=null && e.getFrom() != null && e.getFrom().isActive() && e.getTo() != null && e.getTo().isActive()) {
                float vx = e.getTo().getX() - e.getFrom().getX();
                float vy = e.getTo().getY() - e.getFrom().getY();
                float len = (float)Math.sqrt(vx * vx + vy * vy);

                float dx = vx * rigidity;  //rigidity makes edges tighter
                float dy = vy * rigidity;

                dx /= (e.getLength() * 100);
                dy /= (e.getLength() * 100);

                // Edges pull directly in proportion to the distance between the nodes. This is good,
                // because we want the edges to be stretchy.  The edges are ideal rubberbands.  They
                // They don't become springs when they are too short.  That only causes the graph to
                // oscillate.


                //if (e.To.justMadeLocal || e.To.markedForRemoval || (!e.From.justMadeLocal && !e.From.markedForRemoval)) {
                //    e.To.dx -= dx * len;
                //    e.To.dy -= dy * len;
                //}
                //else {
                e.getTo().setDX(e.getTo().getDX() - dx * len);
                e.getTo().setDY(e.getTo().getDY() - dy * len);
                //}
                //if (e.from.justMadeLocal || e.from.markedForRemoval || (!e.to.justMadeLocal && !e.to.markedForRemoval)) {
                //    e.from.dx += dx * len;
                //    e.from.dy += dy * len;
                //}
                //else {
                e.getFrom().setDX(e.getFrom().getDX() + dx * len);
                e.getFrom().setDY(e.getFrom().getDY() + dy * len);
                //}
            }
        }


    }


    private synchronized void avoidLabels() {
        float dx;
        float dy;
        float vx;
        float vy;
        float len;
        
        Object[] nodeArray = nodes.values().toArray();
        
        for (int i1=0; i1< nodeArray.length; i1 ++) {
            Node n1 = (DisplayNode)nodeArray[i1];

            if (n1.isActive()) {

                for (int i2 = i1 + 1; i2 <nodeArray.length; i2++) {



                    Node n2 = (DisplayNode)nodeArray[i2];

                    if (n2.isActive()) {
                        //if (n1.CurrentRect.IntersectsWith(n2.CurrentRect)) {
                        dx = 0;
                        dy = 0;
                        vx = n1.getX() - n2.getX();
                        vy = n1.getY() - n2.getY();
                        len = vx * vx + vy * vy; //so it's length squared
                        if (len == 0) {
                            dx = (float)Math.random(); //If two nodes are right on top of each other, randomly separate
                            dy = (float)Math.random();
                        }
                        else if (len < 600 * 600) { //600, because we don't want deleted nodes to fly too far away
                            dx = vx / len;  // If it was sqrt(len) then a single node surrounded by many others will
                            dy = vy / len;  // always look like a circle.  This might look good at first, but I think
                            // it makes large graphs look ugly + it contributes to oscillation.  A
                            // linear function does not fall off fast enough, so you get rough edges
                            // in the 'force field'
                        }

                        float repSum = n1.getRepulsion() * n2.getRepulsion() / 100;
                        n1.setDX(n1.getDX() + dx * repSum * rigidity);
                        n1.setDY(n1.getDY() + dy * repSum * rigidity);
                        n2.setDX(n2.getDX() - dx * repSum * rigidity);
                        n2.setDY(n2.getDY() - dy * repSum * rigidity);
                        //}
                    }
                }
            }

            //tgPanel.getGES().forAllNodePairs(fenp);
        }
    }


    public void startDamper() {
        damping = true;
    }

    public void stopDamper() {
        damping = false;
        damper = 1.0F;     //A value of 1.0 means no damping
    }

    public void resetDamper() {  //reset the damper, but don't keep damping.
        damping = true;
        damper = 1.0F;
    }

    public void slowMotion() {  // stabilize the graph, but do so gently by setting the damper to a low value
        damping = true;
        if (damper > 0.3F)
            damper = 0.3F;
        else
            damper = 0;
    }

    public void damp() {
        if (damping) {
            if (motionRatio <= 0.001) {  //This is important.  Only damp when the graph starts to move faster
                //When there is noise, you damp roughly half the time. (Which is a lot)
                //
                //If things are slowing down, then you can let them do so on their own,
                //without damping.

                //If max motion<0.2, damp away
                //If by the time the damper has ticked down to 0.9, maxMotion is still>1, damp away
                //We never want the damper to be negative though
                if ((maxMotion < 0.2 || (maxMotion > 1 && damper < 0.9)) && damper > 0.01) damper -= 0.01F;
                //If we've slowed down significanly, damp more aggresively (then the line two below)
                else if (maxMotion < 0.4 && damper > 0.003) damper -= 0.003F;
                //If max motion is pretty high, and we just started damping, then only damp slightly
                else if (damper > 0.0001) damper -= 0.0001F;
            }
        }
        if (maxMotion < 0.001 && damping) {
            damper = 0;
        }
    }

    private synchronized void moveNodes() {
        lastMaxMotion = maxMotion;
        float[] maxMotionA = new float[1];
        maxMotionA[0] = 0;

        boolean setVals = false;

        NodeGroup.ResetAllDrawingAreas();


        Iterator i = nodes.values().iterator();
        while(i.hasNext()) {
        	DisplayNode n = (DisplayNode)i.next();

            if (n.isActive()) {

                float dx = n.getDX();
                float dy = n.getDY();
                dx *= damper;  //The damper slows things down.  It cuts down jiggling at the last moment, and optimizes
                dy *= damper;  //layout.  As an experiment, get rid of the damper in these lines, and make a
                //long straight line of nodes.  It wiggles too much and doesn't straighten out.

                n.setDX(dx / 2);   //Slow down, but don't stop.  Nodes in motion store momentum.  This helps when the force
                n.setDY(dy / 2);   //on a node is very low, but you still want to get optimal layout.

                float distMoved = (float)Math.sqrt((double)(dx * dx + dy * dy)); //how far did the node actually move?

                if (!n.isFixed() && !(n == dragNode)) {
                    n.setX(n.getX() + Math.max(-1 * maxMovePerRound, Math.min(maxMovePerRound, dx))); //don't move faster then 30 units at a time.
                    n.setY(n.getY() + Math.max(-1 * maxMovePerRound, Math.min(maxMovePerRound, dy))); //I forget when this is important.  Stopping severed nodes from
                    //flying away?
                }
                maxMotionA[0] = Math.max(distMoved, maxMotionA[0]);

                if (setVals) {
                    maxX = Math.max(maxX, n.getX() + n.getWidth() / 2);
                    minX = Math.min(minX, n.getX() - n.getWidth() / 2);
                    maxY = Math.max(maxY, n.getY() + n.getHeight() / 2);
                    minY = Math.min(minY, n.getY() - n.getHeight() / 2);
                }
                else {
                    maxX = n.getX();
                    minX = n.getX();
                    maxY = n.getY();
                    minY = n.getY();
                    setVals = true;
                }
            }

            if (n.isVisible() && n.getNodeGroup() != null) {
                n.getNodeGroup().UpdateDrawAreaAfterMove(n);
            }





        }

        maxMotion = maxMotionA[0];
        if (maxMotion > 0) motionRatio = lastMaxMotion / maxMotion - 1; //subtract 1 to make a positive value mean that
        else motionRatio = 0;                                     //things are moving faster

        damp();


    }



    private synchronized void relax() {
        //DateTime startTime = DateTime.Now;
        for (int i = 0; i < 1; i++) {
            //Console.WriteLine("Iterating...");
            relaxEdges();
            avoidLabels();
            moveNodes();
            //avoidLabels2();
            //moveNodes();
        }
        if (rigidity != newRigidity) rigidity = newRigidity; //update rigidity
        //Console.WriteLine("Relax time: " + DateTime.Now.Subtract(startTime));
    }

    private void runRelaxer() {
        Thread me = Thread.currentThread();
        //      me.setPriority(1);       //Makes standard executable look better, but the applet look worse.
        this.resetDamper();
        while (relaxer == me) {
            MoveUntilStill();
            try {
            	Thread.currentThread().sleep(100);  //Delay to wait for the prior repaint command to finish.
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
    }

    public void MoveUntilStill() {
    	//System.out.println(isStill());
        while (!isStill()) {
            if (isSpringOn() && edges.size() > 0) {
                relax();
                mapDisplay.mapUpdated();
            	//System.out.println(isStill());
            }
            try {
            	Thread.currentThread().sleep(20);  //Delay to wait for the prior repaint command to finish.
            } catch (Exception e) {
            	e.printStackTrace();
            }
        }
    }

    public float getMaxMotion() {
        return maxMotion;
    }

    public boolean Damping() {
        return damping;
    }

    public float Damper() {
        return damper;
    }

    public boolean isStill() {
    	return damper < 0.1 && damping && maxMotion < 0.001;
    }

    private double maxMotionThreshhold = 0.001;
    public double getMaxMotionThreshhold() {
        return maxMotionThreshhold;
    }
    public void setMaxMotionThreshhold(double value) {
    	maxMotionThreshhold = value;
    }

    public void startMotion() {
        relaxer = new Thread(this);
        relaxer.start();

    }

    public void stopMotion() {
        if (relaxer != null) {
            relaxer.stop();
            relaxer = null;
        }
    }


	public boolean isSpringOn() {
		return springOn;
	}


	public void setSpringOn(boolean springOn) {
		this.springOn = springOn;
	}


	public void run() {
		runRelaxer();
		
	}
}
