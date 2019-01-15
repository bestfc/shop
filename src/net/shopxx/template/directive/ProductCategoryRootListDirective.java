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
import net.shopxx.entity.ProductCategory;
import net.shopxx.service.ProductCategoryService;

/**
 * 模板指令顶级商品分类列表
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class ProductCategoryRootListDirective extends BaseDirective {

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "productCategories";

	@Inject
	private ProductCategoryService productCategoryService;

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
		boolean useCache = useCache(params);
		List<ProductCategory> productCategories = productCategoryService.findRoots(count, useCache);
		setLocalVariable(VARIABLE_NAME, productCategories, env, body);
	}

}