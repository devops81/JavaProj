package com.openq.web.controllers;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.exception.BusinessServiceException;
import com.openq.kol.DBUtil;
import com.openq.utils.EncryptionUtil;

/**
 * Controller class to oversee OpenID integration process. Its responsibility is
 * to support the OpenId authentication and to show the view.
 * 
 * @author Tarun
 * 
 */

public class OpenIdIntegrationController extends AbstractController {

    private static final Logger LOGGER = Logger
            .getLogger(OpenIdIntegrationController.class);

    private static final String CONFIG_FILE = "resources/ServerConfig.properties";

    private static final String PROPERTY_OPENID_URL = "openid.url";

    private static final String PROPERTY_ENCRYPTION_KEY = "key";

    private static final String DEFAULT_ENCRYPTION_KEY = "OpenQ99";

    protected ModelAndView handleRequestInternal(final HttpServletRequest req,
            final HttpServletResponse res) throws Exception {
        final ModelAndView mav = new ModelAndView("openid");

        final HttpSession session = req.getSession();

        // required for the header menu highlighting
        session.setAttribute("CURRENT_LINK", "Open Identify");

        final long timestamp = System.currentTimeMillis();
        final String userID = (String) session.getAttribute(Constants.USER_ID);

        final String token = generateSecurityToken(timestamp, userID);
        mav.addObject("token", token);
        mav.addObject("userName", session
                .getAttribute(Constants.COMPLETE_USER_NAME));
        mav.addObject("timestamp", String.valueOf(timestamp));
        mav.addObject("userID", userID);

        final Properties serverProperty = DBUtil.getInstance()
                .getDataFromPropertiesFile(CONFIG_FILE);
        final String openIdUrl = serverProperty.getProperty(PROPERTY_OPENID_URL);

        mav.addObject("openidUrl", openIdUrl);
        return mav;
    }

    private String generateSecurityToken(final long timestamp,
            final String userID) throws BusinessServiceException {
        try {
            final Properties serverProperty = DBUtil.getInstance()
                    .getDataFromPropertiesFile(CONFIG_FILE);
            final String encryptionKey = serverProperty.getProperty(
                    PROPERTY_ENCRYPTION_KEY, DEFAULT_ENCRYPTION_KEY);
            final String message = userID + timestamp + encryptionKey;
            return EncryptionUtil.encrypt(message);
        } catch (IOException ioe) {
            LOGGER.warn("Failed to read the Config file", ioe);
            throw new BusinessServiceException(ioe);
        } catch (EncryptionUtil.EncryptionException exp) {
            LOGGER.warn("Failed to encrypt the message", exp);
            throw new BusinessServiceException(exp);
        }

    }

}
