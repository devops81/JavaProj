

document.write("<OBJECT ");
document.write("    classid = \"clsid:8AD9C840-044E-11D1-B3E9-00805F499D93\"");
document.write("    codebase = \"http://java.sun.com/update/1.4.2/jinstall-1_4-windows-i586.cab#Version=1,4,0,0\"");
document.write("    WIDTH = 1000 HEIGHT = 600 >");
document.write("    <PARAM NAME = CODE VALUE = \"com.openq.networkmap.NetworkMapApplet.class\" >");
document.write("    <PARAM NAME = ARCHIVE VALUE = \"applet/networkMap.jar\" >");
document.write("    <PARAM NAME = \"type\" VALUE = \"application/x-java-applet;version=1.4\">");
document.write("    <PARAM NAME = \"scriptable\" VALUE = \"false\">");
var randomString = Math.random();
document.write("    <PARAM NAME = \"data\" VALUE=\"applet/dummy_kol.xml?ran="+randomString+"\">");
document.write("    <COMMENT>");
document.write("	<EMBED ");
document.write("            type = \"application/x-java-applet;version=1.4\" \\");
document.write("            CODE = \"com.openq.networkmap.NetworkMapApplet.class\" \\");
document.write("            ARCHIVE = \"applet/networkMap.jar\" \\");
document.write("            WIDTH = 1000 \\");
document.write("            HEIGHT = 600 \\");
document.write("            data =\"applet/dummy_kol.xml?ran="+randomString+"\" \\");
document.write("	    scriptable = false \\");
document.write("	    pluginspage = \"http://java.sun.com/products/plugin/index.html#download\">");
document.write("	    <NOEMBED>");
document.write("            </NOEMBED>");
document.write("	</EMBED>");
document.write("    </COMMENT>");
document.write("</OBJECT>");