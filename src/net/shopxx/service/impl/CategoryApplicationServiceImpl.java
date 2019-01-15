/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.HashSet;
import java.util.Set;

import javax.inject.Inject;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.CategoryApplicationDao;
import net.shopxx.dao.ProductDao;
import net.shopxx.entity.CategoryApplication;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;
import net.shopxx.service.CategoryApplicationService;

/**
 * Service经营分类申请
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CategoryApplicationServiceImpl extends BaseServiceImpl<CategoryApplication, Long> implements CategoryApplicationService {

	@Inject
	private CategoryApplicationDao categoryApplicationDao;
	@Inject
	private ProductDao productDao;

	@Transactional(readOnly = true)
	public boolean exist(Store store, ProductCategory productCategory, CategoryApplication.Status status) {
		Assert.notNull(status);
		Assert.notNull(store);
		Assert.notNull(productCategory);

		return categoryApplicationDao.findList(store, productCategory, status).size() > 0;
	}

	@Transactional(readOnly = true)
	public Page<CategoryApplication> findPage(Store store, Pageable pageable) {
		return categoryApplicationDao.findPage(store, pageable);
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void review(CategoryApplication categoryApplication, boolean isPassed) {
		Assert.notNull(categoryApplication);

		if (isPassed) {
			Store store = categoryApplication.getStore();
			ProductCategory productCategory = categoryApplication.getProductCategory();

			categoryApplication.setStatus(CategoryApplication.Status.approved);
			store.getProductCategories().add(productCategory);
			Set<ProductCategory> productCategories = new HashSet<>();
			productCategories.add(productCategory);
			productDao.refreshActive(store);
		} else {
			categoryApplication.setStatus(CategoryApplication.Status.failed);
		}
	}

}