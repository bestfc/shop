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
import net.shopxx.dao.StoreAdImageDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreAdImage;
import net.shopxx.service.StoreAdImageService;

/**
 * Service店铺广告图片
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreAdImageServiceImpl extends BaseServiceImpl<StoreAdImage, Long> implements StoreAdImageService {

	@Inject
	private StoreAdImageDao storeAdImageDao;

	@Transactional(readOnly = true)
	public Page<StoreAdImage> findPage(Store store, Pageable pageable) {
		return storeAdImageDao.findPage(store, pageable);
	}

}