/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.weixinLogin;

import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.oltu.oauth2.client.OAuthClient;
import org.apache.oltu.oauth2.client.URLConnectionClient;
import org.apache.oltu.oauth2.client.request.OAuthClientRequest;
import org.apache.oltu.oauth2.client.request.OAuthClientRequest.TokenRequestBuilder;
import org.apache.oltu.oauth2.client.response.OAuthJSONAccessTokenResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.exception.OAuthProblemException;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.types.GrantType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.LoginPlugin;

/**
 * Plugin微信登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("weixinLoginPlugin")
public class WeixinLoginPlugin extends LoginPlugin {

	/**
	 * code请求URL
	 */
	private static final String CODE_REQUEST_URL = "https://open.weixin.qq.com/connect/oauth2/authorize#wechat_redirect";

	/**
	 * openId请求URL
	 */
	private static final String OPEN_ID_REQUEST_URL = "https://api.weixin.qq.com/sns/oauth2/access_token";

	@Override
	public String getName() {
		return "微信登录";
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
		return "weixin_login/install";
	}

	@Override
	public String getUninstallUrl() {
		return "weixin_login/uninstall";
	}

	@Override
	public boolean supports(HttpServletRequest request) {
		String userAgent = request.getHeader("USER-AGENT");
		return StringUtils.contains(userAgent.toLowerCase(), "micromessenger");
	}

	@Override
	public void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		Map<String, Object> parameterMap = new TreeMap<>();
		parameterMap.put("appid", getAppId());
		parameterMap.put("redirect_uri", getPostSignInUrl(loginPlugin));
		parameterMap.put("response_type", "code");
		parameterMap.put("scope", "snsapi_userinfo");

		modelAndView.addObject("requestUrl", CODE_REQUEST_URL);
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(LoginPlugin.DEFAULT_PAY_VIEW_NAME);

	}

	@Override
	public boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		if (StringUtils.isEmpty(code)) {
			return false;
		}
		try {
			OAuthClient oAuthClient = new OAuthClient(new URLConnectionClient());
			TokenRequestBuilder tokenRequestBuilder = OAuthClientRequest.tokenLocation(OPEN_ID_REQUEST_URL);
			tokenRequestBuilder.setParameter("appid", getAppId());
			tokenRequestBuilder.setParameter("secret", getAppSecret());
			tokenRequestBuilder.setCode(code);
			tokenRequestBuilder.setGrantType(GrantType.AUTHORIZATION_CODE);
			OAuthClientRequest accessTokenRequest = tokenRequestBuilder.buildQueryMessage();
			OAuthJSONAccessTokenResponse authJSONAccessTokenResponse = oAuthClient.accessToken(accessTokenRequest, OAuth.HttpMethod.GET);
			String openId = authJSONAccessTokenResponse.getParam("openid");
			String accessToken = authJSONAccessTokenResponse.getParam("access_token");
			if (StringUtils.isNotEmpty(openId) && StringUtils.isNotEmpty(accessToken)) {
				request.setAttribute("openid", openId);
				request.setAttribute("access_token", accessToken);
				return true;
			}
		} catch (OAuthSystemException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (OAuthProblemException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
		return false;
	}

	@Override
	public String getSettingUrl() {
		return "weixin_login/setting";
	}

	@Override
	public String getUniqueId(HttpServletRequest request) {
		String openId = (String) request.getAttribute("openid");
		return StringUtils.isNotEmpty(openId) ? openId : null;
	}

	/**
	 * 获取AppID
	 * 
	 * @return AppID
	 */
	private String getAppId() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("appId");
	}

	/**
	 * 获取AppSecret
	 * 
	 * @return AppSecret
	 */
	private String getAppSecret() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("appSecret");
	}

}