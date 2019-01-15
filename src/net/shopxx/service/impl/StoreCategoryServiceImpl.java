/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.dao.StoreCategoryDao;
import net.shopxx.entity.StoreCategory;
import net.shopxx.service.StoreCategoryService;

/**
 * Service店铺分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreCategoryServiceImpl extends BaseServiceImpl<StoreCategory, Long> implements StoreCategoryService {

	@Inject
	private StoreCategoryDao storeCategoryDao;

	@Transactional(readOnly = true)
	public boolean nameExists(String name) {
		return storeCategoryDao.exists("name", name, true);
	}

}