/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.shopxx.util.WebUtils;

/**
 * Interceptor列表查询
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class ListInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 重定向视图名称前缀
	 */
	private static final String REDIRECT_VIEW_NAME_PREFIX = "redirect:";

	/**
	 * 列表查询Cookie名称
	 */
	private static final String LIST_QUERY_COOKIE_NAME = "listQuery";

	/**
	 * 请求后处理
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param handler
	 *            处理器
	 * @param modelAndView
	 *            数据视图
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		if (modelAndView != null && modelAndView.isReference()) {
			String viewName = modelAndView.getViewName();
			if (StringUtils.startsWith(viewName, REDIRECT_VIEW_NAME_PREFIX)) {
				String listQuery = WebUtils.getCookie(request, LIST_QUERY_COOKIE_NAME);
				if (StringUtils.isNotEmpty(listQuery)) {
					if (StringUtils.startsWith(listQuery, "?")) {
						listQuery = listQuery.substring(1);
					}
					if (StringUtils.contains(viewName, "?")) {
						modelAndView.setViewName(viewName + "&" + listQuery);
					} else {
						modelAndView.setViewName(viewName + "?" + listQuery);
					}
					WebUtils.removeCookie(request, response, LIST_QUERY_COOKIE_NAME);
				}
			}
		}
	}

}