/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;
import java.util.Map;

import net.shopxx.entity.OrderShipping;

/**
 * Service订单发货
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface OrderShippingService extends BaseService<OrderShipping, Long> {

	/**
	 * 根据编号查找订单发货
	 * 
	 * @param sn
	 *            编号(忽略大小写)
	 * @return 订单发货，若不存在则返回null
	 */
	OrderShipping findBySn(String sn);

	/**
	 * 获取物流动态
	 * 
	 * @param orderShipping
	 *            订单发货
	 * @return 物流动态
	 */
	List<Map<String, String>> getTransitSteps(OrderShipping orderShipping);

}