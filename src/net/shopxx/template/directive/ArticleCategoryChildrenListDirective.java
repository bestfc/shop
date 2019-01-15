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
import net.shopxx.entity.ArticleCategory;
import net.shopxx.service.ArticleCategoryService;
import net.shopxx.util.FreeMarkerUtils;

/**
 * 模板指令下级文章分类列表
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Component
public class ArticleCategoryChildrenListDirective extends BaseDirective {

	/**
	 * "文章分类ID"参数名称
	 */
	private static final String ARTICLE_CATEGORY_ID_PARAMETER_NAME = "articleCategoryId";

	/**
	 * "是否递归"参数名称
	 */
	private static final String RECURSIVE_PARAMETER_NAME = "recursive";

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "articleCategories";

	@Inject
	private ArticleCategoryService articleCategoryService;

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
		Long articleCategoryId = FreeMarkerUtils.getParameter(ARTICLE_CATEGORY_ID_PARAMETER_NAME, Long.class, params);
		Boolean recursive = FreeMarkerUtils.getParameter(RECURSIVE_PARAMETER_NAME, Boolean.class, params);
		Integer count = getCount(params);
		boolean useCache = useCache(params);
		List<ArticleCategory> articleCategories = articleCategoryService.findChildren(articleCategoryId, recursive != null ? recursive : true, count, useCache);
		setLocalVariable(VARIABLE_NAME, articleCategories, env, body);
	}

}