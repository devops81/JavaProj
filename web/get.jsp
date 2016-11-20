<%@ page language="java"%>
<%@ page import="java.io.*"%>
<%
File file = new File ("new.pdf");

response.setContentType ("application/vnd.ms-powerpoint");
response.setHeader ("Content-disposition", "attachment; filename=new.pdf");

BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
ServletOutputStream outs = response.getOutputStream();

byte bytes[] = new byte[4096];
int i = 0;

try
{
	while ((i = in.read(bytes,0,4096)) != -1)
	{
		outs.write(bytes,0,i);
	}
}
catch (IOException ioe)
{
	ioe.printStackTrace();
}

in.close();
outs.flush();
outs.close();

%>