/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.shopxx.entity.Member;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.entity.SocialUser;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.security.SocialUserAuthenticationToken;
import net.shopxx.service.PluginService;
import net.shopxx.service.SocialUserService;
import net.shopxx.service.UserService;

/**
 * Controller社会化用户登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopSocialUserLoginController")
@RequestMapping("/social_user_login")
public class SocialUserLoginController extends BaseController {

	@Value("${member_index}")
	private String memberIndex;
	@Value("${member_login}")
	private String memberLogin;
	@Value("${member_login_view}")
	private String memberLoginView;

	@Inject
	private UserService userService;
	@Inject
	private PluginService pluginService;
	@Inject
	private SocialUserService socialUserService;

	/**
	 * 首页
	 */
	@RequestMapping
	public String index(String loginPluginId, HttpServletRequest request, HttpServletResponse response) {
		LoginPlugin loginPlugin = pluginService.getLoginPlugin(loginPluginId);
		if (loginPlugin == null || BooleanUtils.isNotTrue(loginPlugin.getIsEnabled())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		return "redirect:" + loginPlugin.getPreSignInUrl(loginPlugin);
	}

	/**
	 * 登录前处理
	 */
	@RequestMapping({ "/pre_sign_in_{loginPluginId:[^_]+}", "/pre_sign_in_{loginPluginId[^_]+}_{extra}" })
	public ModelAndView preSignIn(@PathVariable String loginPluginId, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginPlugin loginPlugin = pluginService.getLoginPlugin(loginPluginId);
		if (loginPlugin == null || BooleanUtils.isNotTrue(loginPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		loginPlugin.preSignInHandle(loginPlugin, extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 登录处理
	 */
	@RequestMapping({ "/sign_in_{loginPluginId:[^_]+}", "/sign_in_{loginPluginId[^_]+}_{extra}" })
	public ModelAndView signin(@PathVariable String loginPluginId, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginPlugin loginPlugin = pluginService.getLoginPlugin(loginPluginId);
		if (loginPlugin == null || BooleanUtils.isNotTrue(loginPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		ModelAndView modelAndView = new ModelAndView();
		loginPlugin.signInHandle(loginPlugin, extra, request, response, modelAndView);
		return modelAndView;
	}

	/**
	 * 登录后处理
	 */
	@RequestMapping({ "/post_sign_in_{loginPluginId:[^_]+}", "/post_sign_in_{loginPluginId[^_]+}_{extra}" })
	public ModelAndView postSignin(@PathVariable String loginPluginId, @PathVariable(required = false) String extra, HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {
		LoginPlugin loginPlugin = pluginService.getLoginPlugin(loginPluginId);
		ModelAndView modelAndView = new ModelAndView();
		if (loginPlugin == null || BooleanUtils.isNotTrue(loginPlugin.getIsEnabled())) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}

		boolean isSigninSuccess = loginPlugin.isSignInSuccess(loginPlugin, extra, request, response);
		if (!isSigninSuccess) {
			modelAndView.setViewName("redirect:" + memberIndex);
			return modelAndView;
		}

		String uniqueId = loginPlugin.getUniqueId(request);
		if (StringUtils.isEmpty(uniqueId)) {
			model.addAttribute("errorMessage", message("member.login.pluginError"));
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		SocialUser socialUser = socialUserService.find(loginPluginId, uniqueId);
		if (socialUser != null) {
			if (socialUser.getUser() != null) {
				SocialUserAuthenticationToken socialUserAuthenticationToken = new SocialUserAuthenticationToken(socialUser, false, request.getRemoteAddr());
				userService.login(socialUserAuthenticationToken);
			} else {
				redirectAttributes.addAttribute("socialUserId", socialUser.getId());
				redirectAttributes.addAttribute("uniqueId", uniqueId);
			}
		} else {
			socialUser = new SocialUser();
			socialUser.setLoginPluginId(loginPluginId);
			socialUser.setUniqueId(uniqueId);
			socialUser.setUser(null);
			socialUserService.save(socialUser);
			redirectAttributes.addAttribute("socialUserId", socialUser.getId());
			redirectAttributes.addAttribute("uniqueId", uniqueId);
		}
		loginPlugin.postSignInHandle(loginPlugin, socialUser, extra, isSigninSuccess, request, response, modelAndView);
		return modelAndView;
	}

}