package com.openq.backend;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.orm.hibernate.HibernateTemplate;
import org.springframework.core.io.ClassPathResource;
import com.openq.eav.metadata.IMetadataService;
import com.openq.eav.metadata.AttributeType;
import com.openq.eav.option.IOptionService;
import com.openq.utils.PropertyReader;
import com.openq.user.UserService;
import com.openq.user.User;
import com.openq.user.IUserService;
import com.aspose.slides.PptException;
import com.aspose.slides.AsposeLicenseException;

import java.util.*;
import java.io.*;
import java.text.SimpleDateFormat;

import net.sf.hibernate.SessionFactory;

import javax.swing.text.html.Option;

/**
 * Created by IntelliJ IDEA.
 * User: Lenovo
 * Date: Jan 16, 2008
 * Time: 2:36:20 PM
 * To change this template use File | Settings | File Templates.
 */
public class BmsUserBatchProcessor {

    protected XmlBeanFactory factory;
    protected HibernateTemplate hibernateTemplate;
    private IUserService userService;
    IOptionService optionService;
    Hashtable hashedUsers;

    BmsUserBatchProcessor()
    {
        ClassPathResource res = new ClassPathResource("openq-servlet-user.xml");
        factory = new XmlBeanFactory(res);
        hibernateTemplate = new HibernateTemplate((SessionFactory) factory.getBean("sessionFactory"));
        userService = (IUserService) factory.getBean("userService");
        optionService = (IOptionService) factory.getBean("optionService");
        List users = userService.getMSLs();
        Iterator it = users.iterator();
        hashedUsers = new Hashtable();
        while(it.hasNext())
        {
             User u = (User)it.next();
             hashedUsers.put(u.getStaffid(),u);
        }

        processFolderAndFiles();


    }

    public void processFolderAndFiles()
    {
        try
        {
            FileInputStream fstream = new FileInputStream("e:\\user.csv");
            DataInputStream in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            //Read File Line By Line
            while ((strLine = br.readLine()) != null)
            {
                String [] a= strLine.split(",");
                System.out.println (strLine);
                User u = new User();
                u.setStaffid(a[0]);
                u.setUserName(a[1]);
                u.setPassword(a[1]);
                u.setEmail(a[2]);
                u.setPhone(a[3]);
                //u.setPrefix(a[4],5);
                u.setFirstName(a[6]);
                u.setMiddleName(a[7]);
                u.setLastName(a[8]);
                // 9 is not used, 10, 11 is for getting the groups
                // 12 13 14 is not used,
                u.setTitle(a[15]);
                // 21 is for supervisors
                u.setDeleteFlag("N");
                u.setLastUpdateTime((new Date()).getTime());


                u.setUserType(optionService.getOptionLookup(2));

                if ( hashedUsers.get(u.getStaffid()) != null)
                    userService.updateUser(u);
                else
                    userService.createUserForDataLoad(u);
            }
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }

    public static void main(String args[])
    {
        BmsUserBatchProcessor bmsUserBatchProcessor = new BmsUserBatchProcessor();

    }
}
