/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Article;
import net.shopxx.entity.ArticleCategory;
import net.shopxx.entity.ArticleTag;

/**
 * Service文章
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ArticleService extends BaseService<Article, Long> {

	/**
	 * 查找文章
	 * 
	 * @param articleCategory
	 *            文章分类
	 * @param articleTag
	 *            文章标签
	 * @param isPublication
	 *            是否发布
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @return 文章
	 */
	List<Article> findList(ArticleCategory articleCategory, ArticleTag articleTag, Boolean isPublication, Integer count, List<Filter> filters, List<Order> orders);

	/**
	 * 查找文章
	 * 
	 * @param articleCategoryId
	 *            文章分类ID
	 * @param articleTagId
	 *            文章标签ID
	 * @param isPublication
	 *            是否发布
	 * @param count
	 *            数量
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @param useCache
	 *            是否使用缓存
	 * @return 文章
	 */
	List<Article> findList(Long articleCategoryId, Long articleTagId, Boolean isPublication, Integer count, List<Filter> filters, List<Order> orders, boolean useCache);

	/**
	 * 查找文章分页
	 * 
	 * @param articleCategory
	 *            文章分类
	 * @param articleTag
	 *            文章标签
	 * @param isPublication
	 *            是否发布
	 * @param pageable
	 *            分页信息
	 * @return 文章分页
	 */
	Page<Article> findPage(ArticleCategory articleCategory, ArticleTag articleTag, Boolean isPublication, Pageable pageable);

	/**
	 * 查看点击数
	 * 
	 * @param id
	 *            ID
	 * @return 点击数
	 */
	long viewHits(Long id);

}