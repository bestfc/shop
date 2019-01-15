/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import java.util.List;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.CategoryApplication;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;

/**
 * Dao经营分类申请
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface CategoryApplicationDao extends BaseDao<CategoryApplication, Long> {

	/**
	 * 查找经营分类申请
	 * 
	 * @param store
	 *            店铺
	 * @param productCategory
	 *            经营分类
	 * @param status
	 *            状态
	 * @return 经营分类申请
	 */
	List<CategoryApplication> findList(Store store, ProductCategory productCategory, CategoryApplication.Status status);

	/**
	 * 查找经营分类申请分页
	 * 
	 * @param store
	 *            店铺
	 * @param pageable
	 *            分页
	 * @return 经营分类申请分页
	 */
	Page<CategoryApplication> findPage(Store store, Pageable pageable);

}