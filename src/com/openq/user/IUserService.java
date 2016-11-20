package com.openq.user;

import java.util.List;

import com.openq.eav.option.OptionLookup;

public interface IUserService {

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#createUser(com.openq.user.User)
     */
    public User[] getContactForKol(long kolId);

    public long createUser(User user);

    public void createUserForDataLoad(User user);

    public User getUser(String userName, String password);

    public User[] getUsers(String kolids);

    public User userExist(String userName, String staffId);

    public void createUserAddress(UserAddress userAddress);

    public void updateUserAddress(UserAddress userAddress);

    public void deleteUserAddress(UserAddress userAddress);

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#deleteUser(com.openq.user.User)
     */
    public void deleteUser(User user);

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#updateUser(com.openq.user.User)
     */
    public void updateUser(User user);

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#getUser(long)
     */
    public User getUser(long userId);

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#getAllUser()
     */
    public User[] getAllUser();

    /*
     * (non-Javadoc)
     *
     * @see com.openq.user.IUserService#getUser(java.lang.String)
     */
    public User getUser(String username);

    public String getUserName(User user);

    public User[] getAllExperts(int expLen);

    public User[] getAllExperts();

    public User[] searchUser(String username);

    public User[] searchEmployee(String username);

    public String[] searchUser(String username, OptionLookup userType);

    public String[] searchUser(String username, OptionLookup userType,
            long groupId);

    public List searchExpert(String name);

    public List searchExpert(String firstName, String lastName);

    public List searchExpert(String firstName, String lastName,
            String citySearch);

    public List searchExpert(String firstName, String lastName, String state,
            String citySearch);

    public void updateGeocodeAddressForUser(long userId, float latitude,
            float longitude);

    public User[] getUserForStaffId(String staffId);

    public User[] getUserForStaffIdInOLAlignment(String staffId);

    public User getUserForKolId(long kolId);

    public User getLightWeightOLForId(String userId);

    public User getOLForId(long userId);

    /**
     * This method returns the Experts for a given MSL.
     *
     * @param staffId
     * @return
     */
    public User[] getKolsForContacts(long staffId);

    public User[] getUsersByType(long userTypeId);

    public User[] getUsersNotIntheList(String whitePageUserList);

    public User getUserByStaffId(String staffId);

    public List getMSLs();

    public User getUserByUserName(String username);

    public User getUserForProfileSummary(long userId);
    
    public User checkExistUserNameStaffID(String userName,String staffID);
    }