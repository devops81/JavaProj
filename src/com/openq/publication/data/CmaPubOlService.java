package com.openq.publication.data;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class CmaPubOlService  extends HibernateDaoSupport implements ICmaPubOlService {

	public CmaPubOl[] getAllOls() {
		List result = getHibernateTemplate().find("from CmaPubOl ");
        return (CmaPubOl[]) result.toArray(new CmaPubOl[result.size()]);
	}

	public String getOlName(CmaPubOl cma) {
		StringBuffer nameBuffer = new StringBuffer();
		String firstName="";
		String lastName = "";
		
		
		firstName = cma.getFirstName();
        lastName = cma.getLastName();
      
 
        // Name Formulation
        if (lastName != null && !"".equals(nameBuffer)) {
            nameBuffer.append(lastName);
        }
        if (firstName != null && !"".equals(firstName) && firstName.length() > 0) {
            nameBuffer.append(" ").append(firstName.substring(0, 1));
        }
     
        return (nameBuffer.toString());
	}

}
