/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.qqLogin;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.util.WebUtils;

/**
 * PluginQQ登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("qqLoginPlugin")
public class QqLoginPlugin extends LoginPlugin {

	/**
	 * code请求URL
	 */
	private static final String CODE_REQUEST_URL = "https://graph.qq.com/oauth2.0/authorize";

	/**
	 * accessToken请求URL
	 */
	private static final String ACCESS_TOKEN_REQUEST_URL = "https://graph.qq.com/oauth2.0/token";

	/**
	 * openId请求URL
	 */
	private static final String OPEN_ID_REQUEST_URL = "https://graph.qq.com/oauth2.0/me";

	/**
	 * "状态"属性名称
	 */
	private static final String STATE_ATTRIBUTE_NAME = QqLoginPlugin.class.getName() + ".STATE";

	/**
	 * "openId"配比
	 */
	private static final Pattern OPEN_ID_PATTERN = Pattern.compile("\"openid\"\\s*:\\s*\"(\\S*?)\"");

	@Override
	public String getName() {
		return "QQ登录";
	}

	@Override
	public String getVersion() {
		return "1.0";
	}

	@Override
	public String getAuthor() {
		return "SHOP++";
	}

	@Override
	public String getSiteUrl() {
		return "http://www.shopxx.net";
	}

	@Override
	public String getInstallUrl() {
		return "qq_login/install";
	}

	@Override
	public String getUninstallUrl() {
		return "qq_login/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "qq_login/setting";
	}

	@Override
	public void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		PluginConfig pluginConfig = getPluginConfig();
		String state = DigestUtils.md5Hex(UUID.randomUUID() + RandomStringUtils.randomAlphabetic(30));
		request.getSession().setAttribute(STATE_ATTRIBUTE_NAME, state);

		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("response_type", "code");
		parameterMap.put("client_id", pluginConfig.getAttribute("oauthKey"));
		parameterMap.put("redirect_uri", getPostSignInUrl(loginPlugin));
		parameterMap.put("state", state);

		modelAndView.addObject("requestUrl", CODE_REQUEST_URL);
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(LoginPlugin.DEFAULT_PAY_VIEW_NAME);
	}

	@Override
	public boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String state = (String) request.getSession().getAttribute(STATE_ATTRIBUTE_NAME);
		if (StringUtils.isNotEmpty(state) && StringUtils.equals(state, request.getParameter("state")) && StringUtils.isNotEmpty(request.getParameter("code"))) {
			request.getSession().removeAttribute(STATE_ATTRIBUTE_NAME);
			Map<String, Object> parameterMap = new HashMap<>();
			parameterMap.put("grant_type", "authorization_code");
			parameterMap.put("client_id", getClientId());
			parameterMap.put("client_secret", getClientSecret());
			parameterMap.put("redirect_uri", getPostSignInUrl(loginPlugin));
			parameterMap.put("code", request.getParameter("code"));
			String content = WebUtils.get(ACCESS_TOKEN_REQUEST_URL, parameterMap);
			String accessToken = WebUtils.parse(content).get("access_token");
			if (StringUtils.isNotEmpty(accessToken)) {
				request.setAttribute("accessToken", accessToken);
				return true;
			}
		}
		return false;
	}

	@Override
	public String getUniqueId(HttpServletRequest request) {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("access_token", request.getAttribute("accessToken"));
		String content = WebUtils.get(OPEN_ID_REQUEST_URL, parameterMap);
		Matcher matcher = OPEN_ID_PATTERN.matcher(content);
		if (matcher.find()) {
			String openId = matcher.group(1);
			request.setAttribute("openId", openId);
			return openId;
		}
		return null;
	}

	/**
	 * 获取 ClientId
	 * 
	 * @return ClientId
	 */
	private String getClientId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("oauthKey");
	}

	/**
	 * 获取ClientSecret
	 * 
	 * @return ClientSecret
	 */
	private String getClientSecret() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("oauthSecret");
	}

}