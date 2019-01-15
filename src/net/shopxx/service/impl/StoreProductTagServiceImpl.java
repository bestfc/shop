/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreProductTagDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductTag;
import net.shopxx.service.StoreProductTagService;

/**
 * Service店铺商品标签
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreProductTagServiceImpl extends BaseServiceImpl<StoreProductTag, Long> implements StoreProductTagService {

	@Inject
	private StoreProductTagDao storeProductTagDao;

	@Transactional(readOnly = true)
	public List<StoreProductTag> findList(Store store, Boolean isEnabled) {
		return storeProductTagDao.findList(store, isEnabled);
	}

	@Transactional(readOnly = true)
	public Page<StoreProductTag> findPage(Store store, Pageable pageable) {
		return storeProductTagDao.findPage(store, pageable);
	}

}