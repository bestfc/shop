/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Area;
import net.shopxx.entity.AreaFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;

/**
 * Service地区运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface AreaFreightConfigService extends BaseService<AreaFreightConfig, Long> {

	/**
	 * 判断运费配置是否存在
	 * 
	 * @param shippingMethod
	 *            配送方式
	 * @param store
	 *            店铺
	 * @param area
	 *            地区
	 * @return 运费配置是否存在
	 */
	boolean exists(ShippingMethod shippingMethod, Store store, Area area);

	/**
	 * 判断运费配置是否唯一
	 * 
	 * @param id
	 *            ID
	 * @param shippingMethod
	 *            配送方式
	 * @param area
	 *            地区
	 * @param store
	 *            店铺
	 * @return 运费配置是否唯一
	 */
	boolean unique(Long id, ShippingMethod shippingMethod, Store store, Area area);

	/**
	 * 查找运费配置分页
	 * 
	 * @param shippingMethod
	 *            配送方式
	 * @param store
	 *            店铺
	 * @param pageable
	 *            分页信息
	 * @return 运费配置分页
	 */
	Page<AreaFreightConfig> findPage(ShippingMethod shippingMethod, Store store, Pageable pageable);

}