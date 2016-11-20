package com.openq.eav.scripts;

import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

import com.openq.user.IUserService;
import com.openq.user.User;

public class ORXExporter extends OlDataLoader {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ClassPathResource res = new ClassPathResource("beans.xml");

		XmlBeanFactory factory = new XmlBeanFactory(res);
		IOlDataLoader olDataLoader = (IOlDataLoader) factory
				.getBean("olDataLoader");
		IUserService userService = olDataLoader.getUserService();
		User[] users = userService.getAllUser();
        for (int i=0; i<users.length; i++) {
        	if (users[i].getUserType().getId() == 4) {
        		// Export this OL
        	}
        }
	}
}
