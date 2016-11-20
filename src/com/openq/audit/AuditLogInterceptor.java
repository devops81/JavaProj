package com.openq.audit;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import net.sf.hibernate.CallbackException;
import net.sf.hibernate.HibernateException;
import net.sf.hibernate.Interceptor;
import net.sf.hibernate.Session;
import net.sf.hibernate.SessionFactory;
import net.sf.hibernate.Transaction;
import net.sf.hibernate.type.Type;

import org.apache.log4j.Logger;

import com.openq.eav.option.OptionLookup;

/**
 * Hibernate Interceptor for logging saves, updates and deletes to the AuditLogRecord Table
 */
public class AuditLogInterceptor implements Interceptor {

    private static Logger logger = Logger.getLogger(AuditLogInterceptor.class);

    private SessionFactory sessionFactory;

    private static final String UPDATE = "update";

    private static final String INSERT = "insert";

    private static final String DELETE = "delete";

    private Set inserts = new HashSet();

    private Set updates = new HashSet();

    private Set deletes = new HashSet();

    /**
     * Sets the session factory
     * 
     * @param sessionFactory
     *            The sessionFactory to set.
     */
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#onLoad(java.lang.Object, java.io.Serializable, java.lang.Object[], java.lang.String[],
     * net.sf.hibernate.type.Type[])
     */
    public boolean onLoad(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
            throws CallbackException {
        return false;
    }

    /**
     * This routine is called before an object is saved. It extracts the data from object and records them as 'insert'.
     * 
     * @param entity
     *            Object to be saved
     * @param id
     *            Generated id of the object
     * @param state
     *            Current state of the object
     * @param propertyNames
     *            Property names
     * @param types
     *            Property types
     * @return false
     */
    public boolean onSave(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
            throws CallbackException {

        // Check if instance is auditable
        if (entity instanceof Auditable) {

            // Extract the details about the object
            Class objectClass = entity.getClass();
            String className = getClassName(objectClass);

            // Log the updates
            try {
                logChanges(entity, null, null, id, INSERT, className);
            } catch (Exception e) {
                logger.error(e);
            }
        }
        return false;
    }

    /**
     * This routine is called before an object is deleted. It extracts the data from the object and records them as 'delete'.
     * 
     * @param entity
     *            Object to be saved
     * @param id
     *            Generated id of the object
     * @param state
     *            Current state of the object
     * @param propertyNames
     *            Property names
     * @param types
     */
    public void onDelete(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
            throws CallbackException {

        if (entity instanceof Auditable) {

            // Extract the details about the object
            Class objectClass = entity.getClass();
            String className = getClassName(objectClass);

            // Log the updates
            try {
                logChanges(null, entity, null, id, DELETE, className);
            } catch (Exception e) {
                logger.error(e);
            }

        }

    }

    /**
     * This routine is called when an object is detected to be dirty, during a flush. It compares the old object with the new
     * objects and records the changes as 'update', if any.
     * 
     * @param entity
     *            Object to be saved
     * @param id
     *            Generated id of the object
     * @param currentState
     *            Current state of the object
     * @param previousState
     *            Previous state of the object
     * @param propertyNames
     *            Property names
     * @param types
     *            Property types
     * @return false
     */
    public boolean onFlushDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState,
            String[] propertyNames, Type[] types) throws CallbackException {

        // Check if instance is auditable
        if (entity instanceof Auditable) {

            // Get a hibernate session from the factory
            Session session = null;
            try {
                session = sessionFactory.openSession();
            } catch (HibernateException e) {
                // Couldn't acquire session, continue without auditing
                logger.error(e);
                return false;
            }

            // Extract the details about the object
            Class objectClass = entity.getClass();
            String className = getClassName(objectClass);

            // Use the id and class to get the pre-update state from the database
            Object preUpdateState = null;
            try {
                preUpdateState = session.get(objectClass, id);
            } catch (HibernateException e) {
                logger.error(e);
            }

            // Log the updates
            try {
                logChanges(entity, preUpdateState, null, id, UPDATE, className);
            } catch (Exception e) {
                logger.error(e);
            }

            // Close the session
            try {
                session.flush();
                session.close();
            } catch (HibernateException e) {
                logger.error(e);
            }
        }

        return false;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#preFlush(java.util.Iterator)
     */
    public void preFlush(Iterator entities) throws CallbackException {
    }

    /**
     * This routine is called after a flush. It reads all the audit records and write them in database.
     * 
     * @param entities
     *            Iterator for the changed entities
     */
    public void postFlush(Iterator entities) throws CallbackException {
        logger.debug("PostFlush(): updates = " + updates.size() + " inserts = " + inserts.size() + " deletes = " + deletes.size());

        // Get a hibernate session from the factory
        Session session = null;
        try {
            session = sessionFactory.openSession();
        } catch (HibernateException e) {
            // Couldn't get a session, continue without writing the audit records
            logger.error(e);
            return;
        }

        try {
            synchronized (inserts) {
                for (Iterator itr = inserts.iterator(); itr.hasNext();) {
                    AuditLogRecord logRecord = (AuditLogRecord) itr.next();
                    session.save(logRecord);
                }
            }

            synchronized (updates) {
                for (Iterator itr = updates.iterator(); itr.hasNext();) {
                    AuditLogRecord logRecord = (AuditLogRecord) itr.next();
                    session.save(logRecord);
                }
            }

            synchronized (deletes) {
                for (Iterator itr = deletes.iterator(); itr.hasNext();) {
                    AuditLogRecord logRecord = (AuditLogRecord) itr.next();
                    session.save(logRecord);
                }
            }
        } catch (HibernateException e) {
            logger.error(e);
            throw new CallbackException(e);
        } finally {
            synchronized (inserts) {
                inserts.clear();
            }
            synchronized (updates) {
                updates.clear();
            }
            synchronized (deletes) {
                deletes.clear();
            }
            try {
                session.flush();
                session.close();
            } catch (HibernateException e) {
                logger.error(e);
            }
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#isUnsaved(java.lang.Object)
     */
    public Boolean isUnsaved(Object entity) {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#findDirty(java.lang.Object, java.io.Serializable, java.lang.Object[], java.lang.Object[],
     * java.lang.String[], net.sf.hibernate.type.Type[])
     */
    public int[] findDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState, String[] propertyNames,
            Type[] types) {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#instantiate(java.lang.Class, java.io.Serializable)
     */
    public Object instantiate(Class clazz, Serializable id) throws CallbackException {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#isTransient(java.lang.Object)
     */
    public Boolean isTransient(Object entity) {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#instantiate(java.lang.String, java.io.Serializable)
     */
    public Object instantiate(String entityName, Serializable id) throws CallbackException {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#getEntityName(java.lang.Object)
     */
    public String getEntityName(Object object) throws CallbackException {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#getEntity(java.lang.String, java.io.Serializable)
     */
    public Object getEntity(String entityName, Serializable id) throws CallbackException {
        return null;
    }

    /*
     * (non-Javadoc)
     * 
     * @seenet.sf.hibernate.Interceptor#afterTransactionBegin(net.sf.hibernate. Transaction)
     */
    public void afterTransactionBegin(Transaction tx) {
    }

    /*
     * (non-Javadoc)
     * 
     * @see net.sf.hibernate.Interceptor#beforeTransactionCompletion(net.sf.hibernate .Transaction)
     */
    public void beforeTransactionCompletion(Transaction tx) {
    }

    /**
     * This routine is called after a transaction is committed or rolled back. It clears all the audit records.
     * 
     * @param tx
     *            The transaction
     */
    public void afterTransactionCompletion(Transaction tx) {
        // clear any audit log records potentially remaining from a rolled back transaction
        synchronized (inserts) {
            inserts.clear();
        }
        synchronized (updates) {
            updates.clear();
        }
        synchronized (deletes) {
            deletes.clear();
        }
    }

    /**
     * Logs changes to persistent data
     * 
     * @param newObject
     *            the object being saved, updated or deleted
     * @param existingObject
     *            the existing object in the database. Used only for updates
     * @param parentObject
     *            the parent object. Set only if passing a Component object as the newObject
     * @param id
     *            the id of the persisted object. Used only for update and delete
     * @param event
     *            the type of event being logged. Valid values are "update", "delete", "save"
     * @param className
     *            the name of the class being logged. Used as a reference in the auditLogRecord
     * @throws IllegalArgumentException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     */
    private void logChanges(Object newObject, Object existingObject, Object parentObject, Serializable id, String event,
            String className) throws IllegalArgumentException, IllegalAccessException, InvocationTargetException {

        logger.debug("logChanges() : id = " + id + " class = " + className + " operation " + event);

        // Get an array of all fields defined in the class and recursively in the superclass
        Object object = event.equals(DELETE) ? existingObject : newObject;
        Class objectClass = object.getClass();
        Field[] fields = getAllFields(objectClass, null);

        // Iterate through all the fields in the object
        Date updatedDate = new Date();
        fieldIteration: for (int i = 0; i < fields.length; i++) {

            // make private fields accessible so we can access their values
            fields[i].setAccessible(true);

            // If the current field is static, transient or final then don't log it as these modifiers are v.unlikely to be part of
            // the data model.
            if (Modifier.isTransient(fields[i].getModifiers()) || Modifier.isFinal(fields[i].getModifiers())
                    || Modifier.isStatic(fields[i].getModifiers())) {
                continue fieldIteration;
            }

            // Ignore the id field
            String fieldName = fields[i].getName();

            // Check if the field is to be ignored
            try {
                Boolean isFieldAuditable = (Boolean) objectClass.getMethod("isFieldAuditable", new Class[] { String.class })
                        .invoke(object, new Object[] { fieldName });
                if (Boolean.FALSE.equals(isFieldAuditable)) {
                    continue fieldIteration;
                }
            } catch (NoSuchMethodException e) {
                // How is this possible? Anyway lets then audit this field. Print the stack trace and continue
                logger.error(e);
            }

            // Get the old and new values (instances) of this field
            Object existingFieldInstance = existingObject != null ? fields[i].get(existingObject) : null;
            Object newFieldInstance = newObject != null ? fields[i].get(newObject) : null;

            // In case the two instances are equal, we don't need to audit
            if (areEqualForAudit(existingFieldInstance, newFieldInstance)) {
                continue fieldIteration;
            }

            // Get the string values
            String existingFieldState = getFieldState(existingFieldInstance);
            String newFieldState = getFieldState(newFieldInstance);

            // It is possible that the two objects weren't same, but they represent the same state. No need to audit it.
            if (existingFieldState.equals(newFieldState)) {
                continue fieldIteration;
            }

            // Create audit log record
            AuditLogRecord logRecord = new AuditLogRecord();
            logRecord.setEntityClass(className);
            logRecord.setEntityAttribute(fieldName);
            logRecord.setOperationType(event);
            logRecord.setUserId(this.getUserId() != null? this.getUserId(): new Long(-1));
            logRecord.setUpdatedDate(updatedDate);
            logRecord.setNewValue(newFieldState);
            logRecord.setOldValue(existingFieldState);
            logRecord.setEntityId(id.toString());

            // For update operations
            if (event.equals(UPDATE)) {
                // Add to the batch
                synchronized (updates) {
                    updates.add(logRecord);
                }
            } else if (event.equals(DELETE)) {
                // Add to the batch
                synchronized (deletes) {
                    deletes.add(logRecord);
                }
            } else if (event.equals(INSERT)) {
                // Add to the batch
                synchronized (inserts) {
                    inserts.add(logRecord);
                }
            }
        }
    }

    /**
     * Returns the stringized value of an object
     * 
     * @param instance
     *            Object to get the value from
     * 
     * @return optValue of an OptionLookup instance toString() for anything else
     */
    private String getFieldState(Object instance) {
        String fieldState;
        if (instance == null) {
            fieldState = "";
        } else if (instance instanceof OptionLookup) {
            fieldState = ((OptionLookup) instance).getOptValue();
            if (fieldState == null) {
                Session session = null;
                try {
                    session = sessionFactory.openSession();
                    Long id = new Long(((OptionLookup) instance).getId());
                    OptionLookup option = (OptionLookup) session.load(OptionLookup.class, id);
                    fieldState = option.getOptValue();
                } catch (HibernateException e) {
                    logger.error(e);
                    fieldState = instance.toString();
                } finally {
                    if (session != null) {
                        try {
                            session.flush();
                            session.close();
                        } catch (HibernateException e) {
                            logger.error(e);
                        }
                    }
                }
            }
        } else {
            fieldState = instance.toString();
        }
        return fieldState;
    }

    /**
     * Returns an array of all fields used by this object from it's class and all superclasses.
     * 
     * @param clazz
     *            the class
     * @param fields
     *            the current field list
     * 
     * @return an array of fields
     */
    private Field[] getAllFields(Class clazz, Field[] fields) {
        // Get the fields from current class in an array
        Field[] newFields = clazz.getDeclaredFields();

        // Get the sizes of two arrays
        int fieldsSize = fields != null ? fields.length : 0;
        int newFieldsSize = newFields != null ? newFields.length : 0;

        // Define a larger array to hold both the smaller arrays
        Field[] totalFields = new Field[fieldsSize + newFieldsSize];

        if (fieldsSize > 0) {
            System.arraycopy(fields, 0, totalFields, 0, fieldsSize);
        }

        if (newFieldsSize > 0) {
            System.arraycopy(newFields, 0, totalFields, fieldsSize, newFieldsSize);
        }

        // Recursively append the array of fields from superclass
        Class superClass = clazz.getSuperclass();
        if (superClass != null && !superClass.getName().equals("java.lang.Object")) {
            return getAllFields(superClass, totalFields);
        } else {
            return totalFields;
        }
    }

    /**
     * Gets the current user's id
     * 
     * @return current user's userId
     */
    private Long getUserId() {
        // Get the details of user id from thread-local and return it
        return UserThreadLocal.get();
    }

    /**
     * Compares the audit-able fields of two objects to determine whether any auditing is required or not
     * 
     * @param a
     *            First object
     * @param b
     *            Second object
     * 
     * @return true - if the value of two objects are equal false - otherwise
     */
    private boolean areEqualForAudit(Object a, Object b) {
        if ((a == null) && (b == null)) {
            return true;
        } else if ((a == null) || (b == null)) {
            return false;
        } else if ((a instanceof OptionLookup) && (b instanceof OptionLookup)) {
            return ((OptionLookup) a).getOptValue().equals(((OptionLookup) b).getOptValue());
        } else if ((a instanceof String) && (b instanceof String)) {
            return ((String) a).equals((String) b);
        } else if ((a instanceof Integer) && (b instanceof Integer)) {
            return ((Integer) a).equals((Integer) b);
        } else if ((a instanceof Long) && (b instanceof Long)) {
            return ((Long) a).equals((Long) b);
        } else if ((a instanceof Float) && (b instanceof Float)) {
            return ((Float) a).equals((Float) b);
        } else if ((a instanceof Double) && (b instanceof Double)) {
            return ((Double) a).equals((Double) b);
        } else if ((a instanceof Date) && (b instanceof Date)) {
            return ((Date) a).equals((Date) b);
        } else if ((a instanceof Boolean) && (b instanceof Boolean)) {
            return ((Boolean) a).equals((Boolean) b);
        } else {
            logger.error("Don't know how to compare(& audit) the objects of type : " + a.getClass().getName());
            return true;
        }
    }

    /**
     * Get the class name without the package structure
     * 
     * @param clazz
     *            Fully qualified class name
     * 
     * @return Base class name
     */
    private String getClassName(Class clazz) {
        String className = clazz.getName();
        String[] tokens = className.split("\\.");
        int lastToken = tokens.length - 1;
        className = tokens[lastToken];
        return className;
    }
}
