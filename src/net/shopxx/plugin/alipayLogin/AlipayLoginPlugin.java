/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin.alipayLogin;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.entity.PluginConfig;
import net.shopxx.plugin.LoginPlugin;
import net.shopxx.util.WebUtils;

/**
 * Plugin支付宝快捷登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component("alipayLoginPlugin")
public class AlipayLoginPlugin extends LoginPlugin {

	/**
	 * 获取授权请求URL
	 */
	private static final String AUTHORIZE_REQUEST_URL = "https://mapi.alipay.com/gateway.do";

	@Override
	public String getName() {
		return "支付宝快捷登录";
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
		return "alipay_login/install";
	}

	@Override
	public String getUninstallUrl() {
		return "alipay_login/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "alipay_login/setting";
	}

	@Override
	public void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("service", "alipay.auth.authorize");
		parameterMap.put("partner", getPartner());
		parameterMap.put("_input_charset", "utf-8");
		parameterMap.put("sign_type", "MD5");
		parameterMap.put("return_url", getPostSignInUrl(loginPlugin));
		parameterMap.put("target_service", "user.auth.quick.login");
		parameterMap.put("exter_invoke_ip", request.getLocalAddr());
		parameterMap.put("client_ip", request.getLocalAddr());
		parameterMap.put("sign", generateSign(parameterMap));

		modelAndView.addObject("requestUrl", AUTHORIZE_REQUEST_URL);
		modelAndView.addObject("parameterMap", parameterMap);
		modelAndView.setViewName(LoginPlugin.DEFAULT_PAY_VIEW_NAME);

	}

	@Override
	public boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (generateSign(request.getParameterMap()).equals(request.getParameter("sign")) && "T".equals(request.getParameter("is_success"))) {
			Map<String, Object> parameterMap = new HashMap<>();
			parameterMap.put("service", "notify_verify");
			parameterMap.put("partner", getPartner());
			parameterMap.put("notify_id", request.getParameter("notify_id"));
			if ("true".equals(WebUtils.post(AUTHORIZE_REQUEST_URL, parameterMap))) {
				return true;
			}
		}
		return false;
	}

	@Override
	public String getUniqueId(HttpServletRequest request) {
		String userId = request.getParameter("user_id");
		if (StringUtils.isNotEmpty(userId)) {
			return userId;
		}
		return null;
	}

	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 */
	private String generateSign(Map<String, ?> parameterMap) {
		return DigestUtils.md5Hex(joinKeyValue(new TreeMap<>(parameterMap), null, getKey(), "&", true, "sign_type", "sign"));
	}

	/**
	 * 获取Partner
	 *
	 * @return Partner
	 */
	private String getPartner() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("partner");
	}

	/**
	 * 获取Key
	 *
	 * @return Key
	 */
	private String getKey() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig.getAttribute("key");
	}

}