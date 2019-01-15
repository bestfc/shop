/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreDao;
import net.shopxx.dao.StoreProductCategoryDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductCategory;
import net.shopxx.service.StoreProductCategoryService;
import net.shopxx.service.StoreService;

/**
 * Service店铺商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreProductCategoryServiceImpl extends BaseServiceImpl<StoreProductCategory, Long> implements StoreProductCategoryService {

	@Inject
	private StoreProductCategoryDao storeProductCategoryDao;
	@Inject
	private StoreDao storeDao;
	@Inject
	private StoreService storeService;

	@Transactional(readOnly = true)
	public List<StoreProductCategory> findRoots(Long storeId) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return Collections.emptyList();
		}
		return storeProductCategoryDao.findRoots(store, null);
	}

	@Transactional(readOnly = true)
	public List<StoreProductCategory> findRoots(Long storeId, Integer count) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return Collections.emptyList();
		}
		return storeProductCategoryDao.findRoots(store, count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "storeProductCategory", condition = "#useCache")
	public List<StoreProductCategory> findRoots(Long storeId, Integer count, boolean useCache) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return Collections.emptyList();
		}
		return storeProductCategoryDao.findRoots(store, count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "storeProductCategory", condition = "#useCache")
	public List<StoreProductCategory> findParents(Long storeProductCategoryId, boolean recursive, Integer count, boolean useCache) {
		StoreProductCategory storeProductCategory = storeProductCategoryDao.find(storeProductCategoryId);
		if (storeProductCategoryId != null && storeProductCategory == null) {
			return Collections.emptyList();
		}
		return storeProductCategoryDao.findParents(storeProductCategory, recursive, count);
	}

	@Transactional(readOnly = true)
	public List<StoreProductCategory> findTree(Store store) {
		return storeProductCategoryDao.findChildren(null, store, true, null);
	}

	@Transactional(readOnly = true)
	public List<StoreProductCategory> findChildren(StoreProductCategory storeProductCategory, Store store, boolean recursive, Integer count) {
		return storeProductCategoryDao.findChildren(storeProductCategory, store, recursive, count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "storeProductCategory", condition = "#useCache")
	public List<StoreProductCategory> findChildren(Long storeProductCategoryId, Long storeId, boolean recursive, Integer count, boolean useCache) {
		StoreProductCategory storeProductCategory = storeProductCategoryDao.find(storeProductCategoryId);
		if (storeProductCategoryId != null && storeProductCategory == null) {
			return Collections.emptyList();
		}
		Store store = storeDao.find(storeId);
		if (storeId == null && store == null) {
			return Collections.emptyList();
		}

		return storeProductCategoryDao.findChildren(storeProductCategory, store, recursive, count);
	}

	@Transactional(readOnly = true)
	public Page<StoreProductCategory> findPage(Store store, Pageable pageable) {
		return storeProductCategoryDao.findPage(store, pageable);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public StoreProductCategory save(StoreProductCategory storeProductCategory) {
		Assert.notNull(storeProductCategory);

		setValue(storeProductCategory);
		return super.save(storeProductCategory);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public StoreProductCategory update(StoreProductCategory storeProductCategory) {
		Assert.notNull(storeProductCategory);

		setValue(storeProductCategory);
		for (StoreProductCategory children : storeProductCategoryDao.findChildren(storeProductCategory, storeService.getCurrent(), true, null)) {
			setValue(children);
		}
		return super.update(storeProductCategory);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public StoreProductCategory update(StoreProductCategory storeProductCategory, String... ignoreProperties) {
		return super.update(storeProductCategory, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "storeProductCategory" }, allEntries = true)
	public void delete(StoreProductCategory storeProductCategory) {
		super.delete(storeProductCategory);
	}

	/**
	 * 设置值
	 * 
	 * @param storeProductCategory
	 *            店铺商品分类
	 */
	private void setValue(StoreProductCategory storeProductCategory) {
		if (storeProductCategory == null) {
			return;
		}
		StoreProductCategory parent = storeProductCategory.getParent();
		if (parent != null) {
			storeProductCategory.setTreePath(parent.getTreePath() + parent.getId() + StoreProductCategory.TREE_PATH_SEPARATOR);
		} else {
			storeProductCategory.setTreePath(StoreProductCategory.TREE_PATH_SEPARATOR);
		}
		storeProductCategory.setGrade(storeProductCategory.getParentIds().length);
	}

}