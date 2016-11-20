package com.openq.web.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.openq.publication.data.IOlPubSummaryService;
import com.openq.publication.data.IOlTotalPubsService;
import com.openq.publication.data.IPublicationsService;
import com.openq.publication.data.IRequestService;
import com.openq.publication.data.OlPublicationSummaryDTO;
import com.openq.publication.data.Publications;
import com.openq.user.IUserService;
import com.openq.user.User;

public class PubExpertController extends AbstractController {
	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView("pubexpert");
		HttpSession session = request.getSession();
		session.setAttribute("CURRENT_LINK", "PUBCAP");
		session.setAttribute("CURRENT_SUB_LINK", "RESULTS");
		long authorId = Long.parseLong((String) request.getParameter("page"));
		Publications[] olPublicationsArray;
		User user;
		String lastUpdate = "";
		String updater = "";

		olPublicationsArray = publicationsService
				.getAllPublicationsOfOl(authorId);
		user = userService.getUser(authorId);
		session.setAttribute("olPublicationSummaryDTOArray",
				olPublicationsArray);
		session.setAttribute("olName", olPubSummaryService.getOlPubSummary(
				authorId).getExpertName());
		// (userService.getUserName(user) != null ? userService
		// .getUserName(user) : " NA "));

		String loc = " ";
		
		if (user.getUserLocation()!= null) {
			loc = user.getUserLocation().getState() == null ? "" : user
					.getUserLocation().getState();
			loc += user.getUserLocation().getCountry() == null ? "" : user
					.getUserLocation().getCountry();
			
		}
		session.setAttribute("olLocation", loc);
		session
				.setAttribute("olSpeciality",
						(user.getSpeciality() != null ? user.getSpeciality()
								: "  NA "));
		Publications lastProfileUpdate = publicationsService
				.getlastProfileUpdate(authorId);
		if (lastProfileUpdate != null) {
			if (lastProfileUpdate.getUpdateTime() != null
					&& lastProfileUpdate.getAuthorId() > 0) {
				lastUpdate = lastProfileUpdate.getUpdateTime().toString();
				updater = userService.getUser(lastProfileUpdate.getAuthorId())
						.getLastName();
			}
		} else {
			lastUpdate = " NA ";
			updater = " NA  ";
		}
		session.setAttribute("lastUpdate", lastUpdate);
		session.setAttribute("lastUpdater", updater);

		String action = request.getParameter("commit");

		if (action != null) {
			int countPubsInProfile = 0;
			int countuncommitpubs = 0;
			for (int i = 0; i < olPublicationsArray.length; i++) {
				String commitdb = request.getParameter("checkcomitvalue"
						+ olPublicationsArray[i].getPublicationId());
				if (commitdb != null) {
					countPubsInProfile++;
					olPublicationsArray[i].setCommit_flag(10);
					publicationsService
							.updatePublication(olPublicationsArray[i]);
				} else {
					olPublicationsArray[i].setCommit_flag(0);
					publicationsService
							.updatePublication(olPublicationsArray[i]);
				}
			}
			OlPublicationSummaryDTO olPublicationSummaryDTO = olPubSummaryService
					.getOlPubSummary(authorId);
			int oldCountPubsInProfile = olPublicationSummaryDTO
					.getPublicationInProfile();
			if (oldCountPubsInProfile != countPubsInProfile) {
				olPublicationSummaryDTO
						.setPublicationInProfile(countPubsInProfile);
				countuncommitpubs = olPublicationSummaryDTO
						.getTotalUncommitedPublications()
						+ oldCountPubsInProfile - countPubsInProfile;
				olPublicationSummaryDTO
						.setTotalUncommitedPublications(countuncommitpubs);
			}

			olPubSummaryService.updateOlSummary(olPublicationSummaryDTO);

		}

		return mav;
	}

	public IPublicationsService publicationsService;

	public IUserService userService;

	public IOlPubSummaryService olPubSummaryService;

	public IOlPubSummaryService getOlPubSummaryService() {
		return olPubSummaryService;
	}

	public void setOlPubSummaryService(IOlPubSummaryService olPubSummaryService) {
		this.olPubSummaryService = olPubSummaryService;
	}

	public IPublicationsService getPublicationsService() {
		return publicationsService;
	}

	public void setPublicationsService(IPublicationsService publicationsService) {
		this.publicationsService = publicationsService;
	}

	public IUserService getUserService() {
		return userService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

}
