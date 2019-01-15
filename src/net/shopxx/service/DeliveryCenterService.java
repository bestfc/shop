/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.DeliveryCenter;
import net.shopxx.entity.Store;

/**
 * Service发货点
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface DeliveryCenterService extends BaseService<DeliveryCenter, Long> {

	/**
	 * 查找默认发货点
	 * 
	 * @param store
	 *            店铺
	 * @return 默认发货点，若不存在则返回null
	 */
	DeliveryCenter findDefault(Store store);

	/**
	 * 查找发货点分页
	 * 
	 * @param store
	 *            店铺
	 * @param pageable
	 *            分页
	 * @return 发货点分页
	 */
	Page<DeliveryCenter> findPage(Store store, Pageable pageable);

	/**
	 * 查找发货点
	 * 
	 * @param store
	 *            店铺
	 * @return 发货点
	 */
	List<DeliveryCenter> findAll(Store store);

}