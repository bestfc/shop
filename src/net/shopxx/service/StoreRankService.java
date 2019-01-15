/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.entity.StoreRank;

/**
 * Service店铺等级
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface StoreRankService extends BaseService<StoreRank, Long> {

	/**
	 * 判断名称是否存在
	 * 
	 * @param name
	 *            名称
	 * @return 名称是否存在
	 */
	boolean nameExists(String name);

	/**
	 * 判断名称是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param name
	 *            名称
	 * @return 名称是否唯一
	 */
	boolean nameUnique(Long id, String name);

	/**
	 * 查找店铺等级
	 * 
	 * @param isAllowRegister
	 *            是否允许注册
	 * @param filters
	 *            筛选
	 * @param orders
	 *            排序
	 * @return 店铺等级
	 */
	List<StoreRank> findList(Boolean isAllowRegister, List<Filter> filters, List<Order> orders);
}