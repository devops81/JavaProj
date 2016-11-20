package com.openq.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.activation.DataSource;

public class ByteArrayDataSource implements DataSource
{
	public final String m_strName;
	public final String m_strType;

	public byte[] m_baData;
		
	public class MyByteArrayOutputStream extends ByteArrayOutputStream
	{
		MyByteArrayOutputStream(byte[] baData)
		{
			buf = baData;
		}
	}
		
	public ByteArrayDataSource(String strName, byte[] baData, String strType)
	{
		m_strType = strType;
		m_baData = baData;
		m_strName = strName;
	}

	public ByteArrayDataSource(String strName, String strData, String strType)
	{
		m_strType = strType;
		m_baData = strData.getBytes();
		m_strName = strName;
	}

	public String getContentType()
	{
		return m_strType;
	}

	public InputStream getInputStream() throws IOException
	{
		return new ByteArrayInputStream(m_baData);
	}

	public String getName()
	{
		return m_strName;
	}

	public OutputStream getOutputStream() throws IOException
	{
		return new MyByteArrayOutputStream(m_baData);
	}
		
}
