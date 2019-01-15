/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.entity.ArticleCategory;

/**
 * Service文章分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ArticleCategoryService extends BaseService<ArticleCategory, Long> {

	/**
	 * 查找顶级文章分类
	 * 
	 * @return 顶级文章分类
	 */
	List<ArticleCategory> findRoots();

	/**
	 * 查找顶级文章分类
	 * 
	 * @param count
	 *            数量
	 * @return 顶级文章分类
	 */
	List<ArticleCategory> findRoots(Integer count);

	/**
	 * 查找顶级文章分类
	 * 
	 * @param count
	 *            数量
	 * @param useCache
	 *            是否使用缓存
	 * @return 顶级文章分类
	 */
	List<ArticleCategory> findRoots(Integer count, boolean useCache);

	/**
	 * 查找上级文章分类
	 * 
	 * @param articleCategory
	 *            文章分类
	 * @param recursive
	 *            是否递归
	 * @param count
	 *            数量
	 * @return 上级文章分类
	 */
	List<ArticleCategory> findParents(ArticleCategory articleCategory, boolean recursive, Integer count);

	/**
	 * 查找上级文章分类
	 * 
	 * @param articleCategoryId
	 *            文章分类ID
	 * @param recursive
	 *            是否递归
	 * @param count
	 *            数量
	 * @param useCache
	 *            是否使用缓存
	 * @return 上级文章分类
	 */
	List<ArticleCategory> findParents(Long articleCategoryId, boolean recursive, Integer count, boolean useCache);

	/**
	 * 查找文章分类树
	 * 
	 * @return 文章分类树
	 */
	List<ArticleCategory> findTree();

	/**
	 * 查找下级文章分类
	 * 
	 * @param articleCategory
	 *            文章分类
	 * @param recursive
	 *            是否递归
	 * @param count
	 *            数量
	 * @return 下级文章分类
	 */
	List<ArticleCategory> findChildren(ArticleCategory articleCategory, boolean recursive, Integer count);

	/**
	 * 查找下级文章分类
	 * 
	 * @param articleCategoryId
	 *            文章分类ID
	 * @param recursive
	 *            是否递归
	 * @param count
	 *            数量
	 * @param useCache
	 *            是否使用缓存
	 * @return 下级文章分类
	 */
	List<ArticleCategory> findChildren(Long articleCategoryId, boolean recursive, Integer count, boolean useCache);

}