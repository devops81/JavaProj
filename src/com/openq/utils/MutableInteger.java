package com.openq.utils;

public class MutableInteger
{
	private int number;

    public MutableInteger(int a) {
    	this.number = a;
    	
    }
    public int getNumber()
    {
    	return number;
    }
    public void setNumber(int num)
    {
    	this.number=num;
    }
    public void increment()
    {
    	this.number=this.number+1;
    }
    
    
}