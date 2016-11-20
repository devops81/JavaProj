package com.openq.eav.scripts;

import java.util.List;

import org.springframework.orm.hibernate.support.HibernateDaoSupport;

public class DataLoadService extends HibernateDaoSupport implements IDataLoadService {
	
	
	   /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getSummaryByCustNum(java.lang.String)
	 */
	public Summary[] getSummaryByCustNum(String custnum) {

		List result = getHibernateTemplate().find("from Summary s where s.custnum='"+custnum + "'");
		return (Summary[]) result.toArray(new Summary[result.size()]);
	   }
	
	public Topics[] getTopicsByCustNum(String custnum) {

		List result = getHibernateTemplate().find("from Topics t where t.custId='"+custnum + "'");
		return (Topics[]) result.toArray(new Topics[result.size()]);
	   }
	
	public Position[] getPositionByCustNum(String custnum) {

		List result = getHibernateTemplate().find("from Position p where p.custId='"+custnum + "'");
		return (Position[]) result.toArray(new Position[result.size()]);
	   }
	
	public OlStrength[] getOlStrengthByCustNum(String custnum) {

		List result = getHibernateTemplate().find("from OlStrength o where o.custnum='"+custnum + "'");
		return (OlStrength[]) result.toArray(new OlStrength[result.size()]);
	   }
	   
	public Bio[] getBioByCustNum(String custnum) {

		List result = getHibernateTemplate().find("from Bio b where b.custnum='"+custnum + "'");
		return (Bio[]) result.toArray(new Bio[result.size()]);
	   }
	
	
	   
       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getAddressByCustNum(java.lang.String)
	 */
    public Address[] getAddressByCustNum(String custnum) {

			List result = getHibernateTemplate().find("from Address a where a.custnum='"+custnum + "'");
			return (Address[]) result.toArray(new Address[result.size()]);
		}

       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getContactByCustNum(java.lang.String)
	 */
    public Contact[] getContactByCustNum(String custnum) {

   		List result = getHibernateTemplate().find("from Contact c where c.custnum='"+custnum + "'");
   		return (Contact[]) result.toArray(new Contact[result.size()]);
   	   }
       
       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getEducationByCustNum(java.lang.String)
	 */
    public Education[] getEducationByCustNum(String custnum) {

			List result = getHibernateTemplate().find("from Education e where e.custnum='"+custnum + "'");
			return (Education[]) result.toArray(new Education[result.size()]);
		}
       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getExperienceTypeByCustNum(java.lang.String)
	 */
    public ExperienceType[] getExperienceTypeByCustNum(String custnum) {

			List result = getHibernateTemplate().find("from ExperienceType e where e.custnum='"+custnum + "'");
			return (ExperienceType[]) result.toArray(new ExperienceType[result.size()]);
		}
       
       
       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getPublicationByCustNum(java.lang.String)
	 */
    public Publication[] getPublicationByCustNum(String custnum) {

			List result = getHibernateTemplate().find("from Publication p where p.custnum='"+custnum + "'");
			return (Publication[]) result.toArray(new Publication[result.size()]);
		}
       
       /* (non-Javadoc)
	 * @see com.openq.eav.scripts.IDataLoadService#getTherapiesByCustNum(java.lang.String)
	 */
    public Therapies[] getTherapiesByCustNum(String custnum) {

			List result = getHibernateTemplate().find("from Therapies t where t.custnum='"+custnum + "'");
			return (Therapies[]) result.toArray(new Therapies[result.size()]);
		}
       
		/* (non-Javadoc)
		 * @see com.openq.eav.scripts.IDataLoadService#getAllAddress()
		 */
		public Summary[] getAllSummaries() {

			List result = getHibernateTemplate().find(
					"from Summary s");
			return (Summary[]) result.toArray(new Summary[result.size()]);
		}

		public Address[] getAllAddresses() {

			List result = getHibernateTemplate().find(
					"from Address s");
			return (Address[]) result.toArray(new Address[result.size()]);
		}

		public Societies[] getAllSocietiesByCustNum(String custNum) {
			List result = getHibernateTemplate().find("from Societies s where s.custId='"+custNum + "'");
			return (Societies[]) result.toArray(new Societies[result.size()]);
		}

		public InterestDescription[] getAllInterestDescriptionsByCustNum(String custNum) {
			List result = getHibernateTemplate().find("from InterestDescription s where s.custId='"+custNum + "'");
			return (InterestDescription[]) result.toArray(new InterestDescription[result.size()]);
		}

		public Presentations[] getAllPresentationsByCustNum(String custNum) {
			List result = getHibernateTemplate().find("from Presentations s where s.custId='"+custNum + "'");
			return (Presentations[]) result.toArray(new Presentations[result.size()]);
		}
		
		public Trials[] getAllTrialsByCustNum(String custNum) {
			List result = getHibernateTemplate().find("from Trials t where t.custnum='"+custNum + "'");
			return (Trials[]) result.toArray(new Trials[result.size()]);
		}
		
		public Tiers[] getAllTiersByCustNum(String custNum) {
			List result = getHibernateTemplate().find("from Tiers t where t.custnum='"+custNum + "'");
			return (Tiers[]) result.toArray(new Tiers[result.size()]);
		}

	}

