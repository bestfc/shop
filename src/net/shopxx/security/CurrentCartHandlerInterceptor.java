/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.security;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.shopxx.service.CartService;

/**
 * Security当前购物车拦截器
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class CurrentCartHandlerInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 默认"当前购物车"属性名称
	 */
	public static final String DEFAULT_CURRENT_CART_ATTRIBUTE_NAME = "currentCart";

	/**
	 * "当前购物车"属性名称
	 */
	private String currentCartAttributeName = DEFAULT_CURRENT_CART_ATTRIBUTE_NAME;

	@Inject
	private CartService cartService;

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
		request.setAttribute(getCurrentCartAttributeName(), cartService.getCurrent());
	}

	/**
	 * 获取"当前购物车"属性名称
	 * 
	 * @return "当前购物车"属性名称
	 */
	public String getCurrentCartAttributeName() {
		return currentCartAttributeName;
	}

	/**
	 * 设置"当前购物车"属性名称
	 * 
	 * @param currentCartAttributeName
	 *            "当前购物车"属性名称
	 */
	public void setCurrentCartAttributeName(String currentCartAttributeName) {
		this.currentCartAttributeName = currentCartAttributeName;
	}

}