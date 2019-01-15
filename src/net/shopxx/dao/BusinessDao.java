/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import java.util.List;

import net.shopxx.entity.Business;

/**
 * Dao商家
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface BusinessDao extends BaseDao<Business, Long> {

	/**
	 * 通过名称查找商家
	 * 
	 * @param keyword
	 *            关键词
	 * @param count
	 *            数量
	 * @return 商家
	 */
	List<Business> search(String keyword, Integer count);

}