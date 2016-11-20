package com.openq.networkmap.load;

import java.awt.Color;
import java.io.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.openq.networkmap.display.DrawUtils;
import com.openq.networkmap.elements.DisplayEdge;
import com.openq.networkmap.map.Map;

public class XMLLoader {

	public static void LoadXML(InputStream xml, ILoadObserver observer) {
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(xml);
			doc.getDocumentElement().normalize();

			NodeList nodeLst = doc.getElementsByTagName("node");

			System.out.println(nodeLst.getLength() + " nodes found");

			for (int s = 0; s < nodeLst.getLength(); s++) {
				Node fstNode = nodeLst.item(s);
//				System.out.println("s is " + s + " and we have a "
//						+ fstNode.getNodeName() + " element?"
//						+ (fstNode.getNodeType() == Node.ELEMENT_NODE));
				if (fstNode.getNodeType() == Node.ELEMENT_NODE) {
					String id = getAttribute(fstNode, "id");
					String color = getAttribute(fstNode, "color");
					String fontSize = getAttribute(fstNode, "font-size");
					String label = getAttribute(fstNode, "label");
					String displayMode = getAttribute(fstNode, "display-mode");
					String iconImage = getAttribute(fstNode, "icon-image");
					String fullImage = getAttribute(fstNode, "full-image");
					String url = getAttribute(fstNode, "url");

					//System.out.println("id is " + id);

					if (id != null) {
						com.openq.networkmap.elements.DisplayNode node = new com.openq.networkmap.elements.DisplayNode(
								id);

						if (label != null)
							node.setDisplayLabel(label);

						try {
							if (displayMode != null)
								node.setDisplayMode(displayMode);
						} catch (Exception e) {
							e.printStackTrace();
						}
						try {
							if (color != null)
								node.setColor(Color.decode(color));
						} catch (Exception e) {
							e.printStackTrace();
						}
						try {
							if (fontSize != null)
								node.setFontSize(Integer.parseInt(fontSize));
						} catch (Exception e) {
							e.printStackTrace();
						}
						try {
							if (iconImage != null)
								node.setIconImage(DrawUtils.getImage(iconImage,null));
						} catch (Exception e) {
							e.printStackTrace();
						}
						try {
							if (url != null)
								node.setUrl(url);
						} catch (Exception e) {
							e.printStackTrace();
						}
						try {
							if (fullImage != null)
//								node.setFullImage(DrawUtils.getImage("img/doc.gif",null));
								node.setFullImage(DrawUtils.getImage(fullImage,null));
						} catch (Exception e) {
							e.printStackTrace();
						}

						NodeList props = ((Element) fstNode)
								.getElementsByTagName("meta");

						for (int p = 0; p < props.getLength(); p++) {
							Node prop = props.item(p);
							if (prop.getNodeType() == Node.ELEMENT_NODE) {
								String name = getAttribute(prop, "name");
								String value = getAttribute(prop, "value");
								if (name != null && value != null) {
									node.addProperty(name, value);
									observer.nodePropertyAdded(name, value);
								}
							}
						}

						observer.addNode(node);
						//System.out.println(node.toString());

						//System.out.println(nodeLst.getLength());

					}
				}
			}
			nodeLst = doc.getElementsByTagName("edge");
			//System.out.println(nodeLst.getLength() + " edges found");

			for (int s = 0; s < nodeLst.getLength(); s++) {
				Node fstNode = nodeLst.item(s);
//				System.out.println("s is " + s + " and we have a "
//						+ fstNode.getNodeName() + " element?"
//						+ (fstNode.getNodeType() == Node.ELEMENT_NODE));
				if (fstNode.getNodeType() == Node.ELEMENT_NODE) {
					String start = getAttribute(fstNode, "start");
					String end = getAttribute(fstNode, "end");
					String width = getAttribute(fstNode, "width");
					String length = getAttribute(fstNode, "length");
					String color = getAttribute(fstNode, "color");
					String arrow = getAttribute(fstNode, "arrow");

					if (start != null && end != null) {

						com.openq.networkmap.elements.Node startNode = observer
								.findNode(start);
						com.openq.networkmap.elements.Node endNode = observer
								.findNode(end);

						if (startNode != null && endNode != null) {
							com.openq.networkmap.elements.DisplayEdge edge = new com.openq.networkmap.elements.DisplayEdge(
									startNode, endNode);

							try {
								if (width != null)
									edge.setWidth(Integer.parseInt(width));
							} catch (Exception e) {
								e.printStackTrace();
							}
							try {
								if (color != null)
									edge.setColor(Color.decode(color));
							} catch (Exception e) {
								e.printStackTrace();
							}
							try {
								if (length != null)
									edge.setLength(Float.parseFloat(length));
							} catch (Exception e) {
								e.printStackTrace();
							}
							try {
								if (arrow != null) {
									if (arrow.toLowerCase().trim().equals("both")) edge.setArrow(DisplayEdge.ARROW_BOTH);
									if (arrow.toLowerCase().trim().equals("none")) edge.setArrow(DisplayEdge.ARROW_NONE);
									if (arrow.toLowerCase().trim().equals("to")) edge.setArrow(DisplayEdge.ARROW_TO);
									if (arrow.toLowerCase().trim().equals("from")) edge.setArrow(DisplayEdge.ARROW_FROM);
								}
							} catch (Exception e) {
								e.printStackTrace();
							}

							NodeList props = fstNode.getChildNodes();

							for (int p = 0; p < props.getLength(); p++) {
								Node prop = props.item(p);
								if (prop.getNodeType() == Node.ELEMENT_NODE
										&& prop.getNodeName().toLowerCase()
												.trim().equals("meta")) {
									String name = getAttribute(prop, "name");
									String value = getAttribute(prop, "value");
									if (name != null && value != null) {
										edge.addProperty(name, value);
										observer.edgePropertyAdded(name, value);
									}
								}
							}

							observer.addEdge(edge);
							//System.out.println(edge.toString());
						}
					}

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	private static String getAttribute(Node node, String att) {
		return node.getAttributes().getNamedItem(att) == null ? null : node
				.getAttributes().getNamedItem(att).getNodeValue();
	}

}
