package com.openq.publication.data;

import java.util.List;
import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class OvidDbService extends HibernateDaoSupport implements IOvidDbService {

	public OvidDb [] getAllOvidDataSource() {
		List ovidDataSource = getHibernateTemplate().find("from OvidDb");
		return (OvidDb []) ovidDataSource.toArray(new OvidDb[ovidDataSource.size()]);
	}
	

}
