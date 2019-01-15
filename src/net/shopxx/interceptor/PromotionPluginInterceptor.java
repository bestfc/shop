/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.interceptor;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.shopxx.controller.business.DiscountPromotionController;
import net.shopxx.controller.business.FullReductionPromotionController;
import net.shopxx.entity.Store;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.plugin.discountPromotion.DiscountPromotionPlugin;
import net.shopxx.plugin.fullReductionPromotion.FullReductionPromotionPlugin;
import net.shopxx.service.PluginService;
import net.shopxx.service.StoreService;

/**
 * Interceptor促销插件
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public class PromotionPluginInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 默认折扣促销购买URL
	 */
	private static final String DEFAULT_DISCOUNT_PROMOTION_BUY_URL = "/business/discount_promotion/buy";

	/**
	 * 默认满减促销购买URL
	 */
	private static final String DEFAULT_FULL_REDUCTION_PROMOTION_BUY_URL = "/business/full_reduction_promotion/buy";

	/**
	 * 折扣促销购买URL
	 */
	private String discountPromotionBuyUrl = DEFAULT_DISCOUNT_PROMOTION_BUY_URL;

	/**
	 * 满减促销购买URL
	 */
	private String fullReductionPromotionBuyUrl = DEFAULT_FULL_REDUCTION_PROMOTION_BUY_URL;

	@Inject
	private PluginService pluginService;
	@Inject
	private StoreService storeService;

	/**
	 * 请求前处理
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param handler
	 *            处理器
	 * @return 是否继续执行
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		Store currentStore = storeService.getCurrent();
		if (currentStore == null) {
			return false;
		}

		HandlerMethod method = (HandlerMethod) handler;
		Object controller = method.getBean();
		PromotionPlugin promotionPlugin = null;
		String promotionBuyUrl = null;
		boolean promotionHasExpired = true;
		if (controller instanceof DiscountPromotionController) {
			promotionPlugin = pluginService.getPromotionPlugin(DiscountPromotionPlugin.ID);
			promotionHasExpired = currentStore.discountPromotionHasExpired();
			promotionBuyUrl = discountPromotionBuyUrl;
		} else if (controller instanceof FullReductionPromotionController) {
			promotionPlugin = pluginService.getPromotionPlugin(FullReductionPromotionPlugin.ID);
			promotionHasExpired = currentStore.fullReductionPromotionHasExpired();
			promotionBuyUrl = fullReductionPromotionBuyUrl;
		}
		if (promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return false;
		}
		if (promotionHasExpired) {
			if (StringUtils.isNotEmpty(promotionBuyUrl)) {
				response.sendRedirect(request.getContextPath() + promotionBuyUrl);
			}
			return false;
		}
		return true;
	}

	/**
	 * 获取折扣促销购买URL
	 * 
	 * @return 折扣促销购买URL
	 */
	public String getDiscountPromotionBuyUrl() {
		return discountPromotionBuyUrl;
	}

	/**
	 * 设置折扣促销购买URL
	 * 
	 * @param discountPromotionBuyUrl
	 *            折扣促销购买URL
	 */
	public void setDiscountPromotionBuyUrl(String discountPromotionBuyUrl) {
		this.discountPromotionBuyUrl = discountPromotionBuyUrl;
	}

	/**
	 * 获取满减促销购买URL
	 * 
	 * @return 满减促销购买URL
	 */
	public String getFullReductionPromotionBuyUrl() {
		return fullReductionPromotionBuyUrl;
	}

	/**
	 * 设置满减促销购买URL
	 * 
	 * @param fullReductionPromotionBuyUrl
	 *            满减促销购买URL
	 */
	public void setFullReductionPromotionBuyUrl(String fullReductionPromotionBuyUrl) {
		this.fullReductionPromotionBuyUrl = fullReductionPromotionBuyUrl;
	}

}