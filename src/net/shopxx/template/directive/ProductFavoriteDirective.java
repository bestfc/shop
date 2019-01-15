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
import net.shopxx.entity.ProductFavorite;
import net.shopxx.service.ProductFavoriteService;

/**
 * 模板指令商品收藏
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class ProductFavoriteDirective extends BaseDirective {

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "productFavorites";

	@Inject
	private ProductFavoriteService productFavoriteService;

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
		Integer count = getCount(params);
		List<Filter> filters = getFilters(params, ProductFavorite.class);
		List<Order> orders = getOrders(params);
		boolean useCache = useCache(params);
		List<ProductFavorite> productFavorites = productFavoriteService.findList(count, filters, orders, useCache);
		setLocalVariable(VARIABLE_NAME, productFavorites, env, body);
	}

}