/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.plugin;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.builder.CompareToBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.shiro.web.util.SavedRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.Setting;
import net.shopxx.entity.PluginConfig;
import net.shopxx.entity.SocialUser;
import net.shopxx.service.PluginConfigService;
import net.shopxx.util.SystemUtils;

/**
 * Plugin登录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public abstract class LoginPlugin implements Comparable<LoginPlugin> {

	/**
	 * "登录方式名称"属性名称
	 */
	public static final String LOGIN_METHOD_NAME_ATTRIBUTE_NAME = "loginMethodName";

	/**
	 * "LOGO"属性名称
	 */
	public static final String LOGO_ATTRIBUTE_NAME = "logo";

	/**
	 * "描述"属性名称
	 */
	public static final String DESCRIPTION_ATTRIBUTE_NAME = "description";

	/**
	 * 默认登录视图名称
	 */
	public static final String DEFAULT_PAY_VIEW_NAME = "/shop/social_user_login/sign_in";

	@Value("${member_index}")
	private String memberIndex;
	@Value("${member_login}")
	private String memberLogin;

	@Inject
	private PluginConfigService pluginConfigService;

	/**
	 * 获取ID
	 * 
	 * @return ID
	 */
	public String getId() {
		return getClass().getAnnotation(Component.class).value();
	}

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	public abstract String getName();

	/**
	 * 获取版本
	 * 
	 * @return 版本
	 */
	public abstract String getVersion();

	/**
	 * 获取作者
	 * 
	 * @return 作者
	 */
	public abstract String getAuthor();

	/**
	 * 获取网址
	 * 
	 * @return 网址
	 */
	public abstract String getSiteUrl();

	/**
	 * 获取安装URL
	 * 
	 * @return 安装URL
	 */
	public abstract String getInstallUrl();

	/**
	 * 获取卸载URL
	 * 
	 * @return 卸载URL
	 */
	public abstract String getUninstallUrl();

	/**
	 * 获取设置URL
	 * 
	 * @return 设置URL
	 */
	public abstract String getSettingUrl();

	/**
	 * 获取是否已安装
	 * 
	 * @return 是否已安装
	 */
	public boolean getIsInstalled() {
		return pluginConfigService.pluginIdExists(getId());
	}

	/**
	 * 获取插件配置
	 * 
	 * @return 插件配置
	 */
	public PluginConfig getPluginConfig() {
		return pluginConfigService.findByPluginId(getId());
	}

	/**
	 * 获取是否已启用
	 * 
	 * @return 是否已启用
	 */
	public boolean getIsEnabled() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getIsEnabled() : false;
	}

	/**
	 * 获取属性值
	 * 
	 * @param name
	 *            属性名称
	 * @return 属性值
	 */
	public String getAttribute(String name) {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(name) : null;
	}

	/**
	 * 获取排序
	 * 
	 * @return 排序
	 */
	public Integer getOrder() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getOrder() : null;
	}

	/**
	 * 获取登录方式名称
	 * 
	 * @return 登录方式名称
	 */
	public String getLoginMethodName() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(LOGIN_METHOD_NAME_ATTRIBUTE_NAME) : null;
	}

	/**
	 * 获取LOGO
	 * 
	 * @return LOGO
	 */
	public String getLogo() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(LOGO_ATTRIBUTE_NAME) : null;
	}

	/**
	 * 获取描述
	 * 
	 * @return 描述
	 */
	public String getDescription() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(DESCRIPTION_ATTRIBUTE_NAME) : null;
	}

	/**
	 * 是否支持
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @return 是否支持
	 */
	public boolean supports(HttpServletRequest request) {
		return true;
	}

	/**
	 * 登录前处理
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param modelAndView
	 *            ModelAndView
	 * @throws Exception
	 */
	public void preSignInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		modelAndView.setViewName("redirect:" + loginPlugin.getSignInUrl(loginPlugin));
	}

	/**
	 * 登录处理
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param modelAndView
	 *            ModelAndView
	 * @throws Exception
	 */
	public abstract void signInHandle(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception;

	/**
	 * 登录后处理
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param socialUser
	 *            社会化用户
	 * @param extra
	 *            附加内容
	 * @param isLoginSuccess
	 *            是否登录成功
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param modelAndView
	 *            ModelAndView
	 * @throws Exception
	 */
	public void postSignInHandle(LoginPlugin loginPlugin, SocialUser socialUser, String extra, boolean isLoginSuccess, HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {
		if (socialUser != null && socialUser.getUser() != null) {
			String redirectUrl;
			SavedRequest savedRequest = org.apache.shiro.web.util.WebUtils.getAndClearSavedRequest(request);
			String contextPath = request.getContextPath();
			if (savedRequest != null) {
				redirectUrl = StringUtils.substringAfter(savedRequest.getRequestUrl(), contextPath);
			} else {
				String sessionRedirectUrl = (String) request.getSession().getAttribute("redirectUrl");
				if (sessionRedirectUrl != null) {
					redirectUrl = sessionRedirectUrl;
					request.getSession().removeAttribute("redirectUrl");
				} else {
					redirectUrl = memberIndex;
				}
			}
			modelAndView.setViewName("redirect:" + redirectUrl);
		} else {
			modelAndView.setViewName("redirect:" + memberLogin);
		}
	}

	/**
	 * 判断是否登录成功
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @return 是否登录成功
	 * @throws Exception
	 */
	public abstract boolean isSignInSuccess(LoginPlugin loginPlugin, String extra, HttpServletRequest request, HttpServletResponse response) throws Exception;

	/**
	 * 获取登录前处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @return 登录前处理URL
	 */
	public String getPreSignInUrl(LoginPlugin loginPlugin) {
		return getPreSignInUrl(loginPlugin, null);
	}

	/**
	 * 获取登录前处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @return 登录前处理URL
	 */
	public String getPreSignInUrl(LoginPlugin loginPlugin, String extra) {
		Assert.notNull(loginPlugin);
		Assert.hasText(loginPlugin.getId());

		Setting setting = SystemUtils.getSetting();
		return setting.getSiteUrl() + "/social_user_login/pre_sign_in_" + loginPlugin.getId() + (StringUtils.isNotEmpty(extra) ? "_" + extra : "");
	}

	/**
	 * 获取登录处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @return 登录处理URL
	 */
	public String getSignInUrl(LoginPlugin loginPlugin) {
		return getSignInUrl(loginPlugin, null);
	}

	/**
	 * 获取登录处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @return 登录处理URL
	 */
	public String getSignInUrl(LoginPlugin loginPlugin, String extra) {
		Assert.notNull(loginPlugin);
		Assert.hasText(loginPlugin.getId());

		Setting setting = SystemUtils.getSetting();
		return setting.getSiteUrl() + "/social_user_login/sign_in_" + loginPlugin.getId() + (StringUtils.isNotEmpty(extra) ? "_" + extra : "");
	}

	/**
	 * 获取登录后处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @return 登录后处理URL
	 */
	public String getPostSignInUrl(LoginPlugin loginPlugin) {
		return getPostSignInUrl(loginPlugin, null);
	}

	/**
	 * 获取登录后处理URL
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @param extra
	 *            附加内容
	 * @return 登录后处理URL
	 */
	public String getPostSignInUrl(LoginPlugin loginPlugin, String extra) {
		Assert.notNull(loginPlugin);
		Assert.hasText(loginPlugin.getId());

		Setting setting = SystemUtils.getSetting();
		return setting.getSiteUrl() + "/social_user_login/post_sign_in_" + loginPlugin.getId() + (StringUtils.isNotEmpty(extra) ? "_" + extra : "");
	}

	/**
	 * 获取唯一ID
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @return 唯一ID
	 */
	public abstract String getUniqueId(HttpServletRequest request);

	/**
	 * 连接Map键值对
	 * 
	 * @param map
	 *            Map
	 * @param prefix
	 *            前缀
	 * @param suffix
	 *            后缀
	 * @param separator
	 *            连接符
	 * @param ignoreEmptyValue
	 *            忽略空值
	 * @param ignoreKeys
	 *            忽略Key
	 * @return 字符串
	 */
	protected String joinKeyValue(Map<String, Object> map, String prefix, String suffix, String separator, boolean ignoreEmptyValue, String... ignoreKeys) {
		List<String> list = new ArrayList<>();
		if (map != null) {
			for (Map.Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				String value = ConvertUtils.convert(entry.getValue());
				if (StringUtils.isNotEmpty(key) && !ArrayUtils.contains(ignoreKeys, key) && (!ignoreEmptyValue || StringUtils.isNotEmpty(value))) {
					list.add(key + "=" + (value != null ? value : ""));
				}
			}
		}
		return (prefix != null ? prefix : "") + StringUtils.join(list, separator) + (suffix != null ? suffix : "");
	}

	/**
	 * 连接Map值
	 * 
	 * @param map
	 *            Map
	 * @param prefix
	 *            前缀
	 * @param suffix
	 *            后缀
	 * @param separator
	 *            连接符
	 * @param ignoreEmptyValue
	 *            忽略空值
	 * @param ignoreKeys
	 *            忽略Key
	 * @return 字符串
	 */
	protected String joinValue(Map<String, Object> map, String prefix, String suffix, String separator, boolean ignoreEmptyValue, String... ignoreKeys) {
		List<String> list = new ArrayList<>();
		if (map != null) {
			for (Map.Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				String value = ConvertUtils.convert(entry.getValue());
				if (StringUtils.isNotEmpty(key) && !ArrayUtils.contains(ignoreKeys, key) && (!ignoreEmptyValue || StringUtils.isNotEmpty(value))) {
					list.add(value != null ? value : "");
				}
			}
		}
		return (prefix != null ? prefix : "") + StringUtils.join(list, separator) + (suffix != null ? suffix : "");
	}

	/**
	 * 重写equals方法
	 * 
	 * @param obj
	 *            对象
	 * @return 是否相等
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		if (this == obj) {
			return true;
		}
		LoginPlugin other = (LoginPlugin) obj;
		return new EqualsBuilder().append(getId(), other.getId()).isEquals();
	}

	/**
	 * 重写hashCode方法
	 * 
	 * @return HashCode
	 */
	@Override
	public int hashCode() {
		return new HashCodeBuilder(17, 37).append(getId()).toHashCode();
	}

	/**
	 * 实现compareTo方法
	 * 
	 * @param loginPlugin
	 *            登录插件
	 * @return 比较结果
	 */
	public int compareTo(LoginPlugin loginPlugin) {
		if (loginPlugin == null) {
			return 1;
		}
		return new CompareToBuilder().append(getOrder(), loginPlugin.getOrder()).append(getId(), loginPlugin.getId()).toComparison();
	}

}