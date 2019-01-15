/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.AreaFreightConfigDao;
import net.shopxx.entity.Area;
import net.shopxx.entity.AreaFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;
import net.shopxx.service.AreaFreightConfigService;

/**
 * Service地区运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class AreaFreightConfigServiceImpl extends BaseServiceImpl<AreaFreightConfig, Long> implements AreaFreightConfigService {

	@Inject
	private AreaFreightConfigDao areaFreightConfigDao;

	@Transactional(readOnly = true)
	public boolean exists(ShippingMethod shippingMethod, Store store, Area area) {
		return areaFreightConfigDao.exists(shippingMethod, store, area);
	}

	@Transactional(readOnly = true)
	public boolean unique(Long id, ShippingMethod shippingMethod, Store store, Area area) {
		return areaFreightConfigDao.unique(id, shippingMethod, store, area);
	}

	@Transactional(readOnly = true)
	public Page<AreaFreightConfig> findPage(ShippingMethod shippingMethod, Store store, Pageable pageable) {
		return areaFreightConfigDao.findPage(shippingMethod, store, pageable);
	}

}