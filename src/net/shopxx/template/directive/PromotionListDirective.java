/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.template.directive;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Component;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.entity.Promotion;
import net.shopxx.service.PromotionService;
import net.shopxx.util.FreeMarkerUtils;

/**
 * 模板指令促销列表
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class PromotionListDirective extends BaseDirective {

	/**
	 * "类型"参数名称
	 */
	private static final String TYPE_PARAMETER_NAME = "type";

	/**
	 * "店铺ID"参数名称
	 */
	private static final String STORE_ID_PARAMETER_NAME = "storeId";

	/**
	 * "会员等级ID"参数名称
	 */
	private static final String MEMBER_RANK_ID_PARAMETER_NAME = "memberRankId";

	/**
	 * "商品分类ID"参数名称
	 */
	private static final String PRODUCT_CATEGORY_ID_PARAMETER_NAME = "productCategoryId";

	/**
	 * "是否已开始"参数名称
	 */
	private static final String HAS_BEGUN_PARAMETER_NAME = "hasBegun";

	/**
	 * "是否已结束"参数名称
	 */
	private static final String HAS_ENDED_PARAMETER_NAME = "hasEnded";

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "promotions";

	@Inject
	private PromotionService promotionService;

	/**
	 * 执行
	 * 
	 * @param env
	 *            环境变量
	 * @param params
	 *            参数
	 * @param loopVars
	 *            循环变量
	 * @param body
	 *            模板内容
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Promotion.Type type = FreeMarkerUtils.getParameter(TYPE_PARAMETER_NAME, Promotion.Type.class, params);
		Long storeId = FreeMarkerUtils.getParameter(STORE_ID_PARAMETER_NAME, Long.class, params);
		Long memberRankId = FreeMarkerUtils.getParameter(MEMBER_RANK_ID_PARAMETER_NAME, Long.class, params);
		Long productCategoryId = FreeMarkerUtils.getParameter(PRODUCT_CATEGORY_ID_PARAMETER_NAME, Long.class, params);
		Boolean hasBegun = FreeMarkerUtils.getParameter(HAS_BEGUN_PARAMETER_NAME, Boolean.class, params);
		Boolean hasEnded = FreeMarkerUtils.getParameter(HAS_ENDED_PARAMETER_NAME, Boolean.class, params);
		Integer count = getCount(params);
		List<Filter> filters = getFilters(params, Promotion.class);
		List<Order> orders = getOrders(params);
		boolean useCache = useCache(params);
		List<Promotion> promotions = promotionService.findList(type, storeId, memberRankId, productCategoryId, hasBegun, hasEnded, count, filters, orders, useCache);
		setLocalVariable(VARIABLE_NAME, promotions, env, body);
	}

}