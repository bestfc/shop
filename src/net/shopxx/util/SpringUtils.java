/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.util;

import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.web.servlet.LocaleResolver;

/**
 * UtilsSpring
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Lazy(false)
@Component
public final class SpringUtils implements ApplicationContextAware, DisposableBean {

	/**
	 * ApplicationContext
	 */
	private static ApplicationContext applicationContext;

	/**
	 * 不可实例化
	 */
	private SpringUtils() {
	}

	/**
	 * 设置ApplicationContext
	 * 
	 * @param applicationContext
	 *            ApplicationContext
	 */
	public void setApplicationContext(ApplicationContext applicationContext) {
		SpringUtils.applicationContext = applicationContext;
	}

	/**
	 * 获取ApplicationContext
	 * 
	 * @return ApplicationContext
	 */
	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}

	/**
	 * 获取实例
	 * 
	 * @param name
	 *            Bean名称
	 * @return 实例
	 */
	public static Object getBean(String name) {
		Assert.hasText(name);

		return applicationContext.getBean(name);
	}

	/**
	 * 获取实例
	 * 
	 * @param type
	 *            Bean类型
	 * @return 实例
	 */
	public static <T> T getBean(Class<T> type) {
		Assert.notNull(type);

		return applicationContext.getBean(type);
	}

	/**
	 * 获取实例
	 * 
	 * @param name
	 *            Bean名称
	 * @param type
	 *            Bean类型
	 * @return 实例
	 */
	public static <T> T getBean(String name, Class<T> type) {
		Assert.hasText(name);
		Assert.notNull(type);

		return applicationContext.getBean(name, type);
	}

	/**
	 * 获取实例
	 * 
	 * @param type
	 *            Bean类型
	 * @return 实例
	 */
	public static <T> Map<String, T> getBeansOfType(Class<T> type) {
		Assert.notNull(type);

		return applicationContext.getBeansOfType(type);
	}

	/**
	 * 获取国际化消息
	 * 
	 * @param code
	 *            代码
	 * @param args
	 *            参数
	 * @return 国际化消息
	 */
	public static String getMessage(String code, Object... args) {
		Assert.hasText(code);

		LocaleResolver localeResolver = getBean("localeResolver", LocaleResolver.class);
		Locale locale = localeResolver.resolveLocale(null);
		return applicationContext.getMessage(code, args, locale);
	}

	/**
	 * 销毁
	 */
	public void destroy() throws Exception {
		applicationContext = null;
	}

}