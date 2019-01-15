/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.DefaultFreightConfigDao;
import net.shopxx.entity.Area;
import net.shopxx.entity.DefaultFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;
import net.shopxx.service.DefaultFreightConfigService;

/**
 * Service默认运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class DefaultFreightConfigServiceImpl extends BaseServiceImpl<DefaultFreightConfig, Long> implements DefaultFreightConfigService {

	@Inject
	private DefaultFreightConfigDao defaultFreightConfigDao;

	@Transactional(readOnly = true)
	public boolean exists(ShippingMethod shippingMethod, Area area) {
		return defaultFreightConfigDao.exists(shippingMethod, area);
	}

	@Transactional(readOnly = true)
	public boolean unique(ShippingMethod shippingMethod, Area previousArea, Area currentArea) {
		if (previousArea != null && previousArea.equals(currentArea)) {
			return true;
		}
		return !defaultFreightConfigDao.exists(shippingMethod, currentArea);
	}

	@Transactional(readOnly = true)
	public Page<DefaultFreightConfig> findPage(Store store, Pageable pageable) {
		return defaultFreightConfigDao.findPage(store, pageable);
	}

	@Transactional(readOnly = true)
	public DefaultFreightConfig find(ShippingMethod shippingMethod, Store store) {
		return defaultFreightConfigDao.find(shippingMethod, store);
	}

	public void update(DefaultFreightConfig defaultFreightConfig, Store store, ShippingMethod shippingMethod) {
		Assert.notNull(store);
		Assert.notNull(shippingMethod);
		if (!defaultFreightConfig.isNew()) {
			super.update(defaultFreightConfig);
		} else {
			defaultFreightConfig.setStore(store);
			defaultFreightConfig.setShippingMethod(shippingMethod);
			super.save(defaultFreightConfig);
		}
	}

}