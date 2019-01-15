/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.PluginService;
import net.shopxx.service.SocialUserService;
import net.shopxx.util.WebUtils;

/**
 * Controller会员登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberLoginController")
@RequestMapping("/member/login")
public class LoginController extends BaseController {

	/**
	 * "重定向令牌"Cookie名称
	 */
	private static final String REDIRECT_TOKEN_COOKIE_NAME = "redirectToken";

	@Value("${member_index}")
	private String memberIndex;
	@Value("${member_login_view}")
	private String memberLoginView;

	@Inject
	private PluginService pluginService;
	@Inject
	private SocialUserService socialUserService;

	/**
	 * 登录页面
	 */
	@GetMapping
	public String index(String redirectUrl, String redirectToken, Long socialUserId, String uniqueId, @CurrentUser Member currentUser, HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		if (StringUtils.isNotEmpty(redirectUrl) && StringUtils.isNotEmpty(redirectToken) && StringUtils.equals(redirectToken, WebUtils.getCookie(request, REDIRECT_TOKEN_COOKIE_NAME))) {
			model.addAttribute("redirectUrl", redirectUrl);
			request.getSession().setAttribute("redirectUrl", redirectUrl);
			WebUtils.removeCookie(request, response, REDIRECT_TOKEN_COOKIE_NAME);
		}
		if (socialUserId != null && StringUtils.isNotEmpty(uniqueId)) {
			SocialUser socialUser = socialUserService.find(socialUserId);
			if (socialUser == null || socialUser.getUser() != null || !StringUtils.equals(socialUser.getUniqueId(), uniqueId)) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			model.addAttribute("socialUserId", socialUserId);
			model.addAttribute("uniqueId", uniqueId);
		}
		model.addAttribute("loginPlugins", pluginService.getActiveLoginPlugins(request));
		return currentUser != null ? "redirect:" + memberIndex : memberLoginView;
	}

}