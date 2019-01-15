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

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.ProductCategoryDao;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;
import net.shopxx.service.ProductCategoryService;

/**
 * Service商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class ProductCategoryServiceImpl extends BaseServiceImpl<ProductCategory, Long> implements ProductCategoryService {

	@Inject
	private ProductCategoryDao productCategoryDao;

	@Transactional(readOnly = true)
	public List<ProductCategory> findList(Store store, Integer count, List<Filter> filters, List<Order> orders) {
		return productCategoryDao.findList(store, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public List<ProductCategory> findRoots() {
		return productCategoryDao.findRoots(null);
	}

	@Transactional(readOnly = true)
	public List<ProductCategory> findRoots(Integer count) {
		return productCategoryDao.findRoots(count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "productCategory", condition = "#useCache")
	public List<ProductCategory> findRoots(Integer count, boolean useCache) {
		return productCategoryDao.findRoots(count);
	}

	@Transactional(readOnly = true)
	public List<ProductCategory> findParents(ProductCategory productCategory, boolean recursive, Integer count) {
		return productCategoryDao.findParents(productCategory, recursive, count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "productCategory", condition = "#useCache")
	public List<ProductCategory> findParents(Long productCategoryId, boolean recursive, Integer count, boolean useCache) {
		ProductCategory productCategory = productCategoryDao.find(productCategoryId);
		if (productCategoryId != null && productCategory == null) {
			return Collections.emptyList();
		}
		return productCategoryDao.findParents(productCategory, recursive, count);
	}

	@Transactional(readOnly = true)
	public List<ProductCategory> findTree() {
		return productCategoryDao.findChildren(null, true, null);
	}

	@Transactional(readOnly = true)
	public List<ProductCategory> findChildren(ProductCategory productCategory, boolean recursive, Integer count) {
		return productCategoryDao.findChildren(productCategory, recursive, count);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "productCategory", condition = "#useCache")
	public List<ProductCategory> findChildren(Long productCategoryId, boolean recursive, Integer count, boolean useCache) {
		ProductCategory productCategory = productCategoryDao.find(productCategoryId);
		if (productCategoryId != null && productCategory == null) {
			return Collections.emptyList();
		}
		return productCategoryDao.findChildren(productCategory, recursive, count);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public ProductCategory save(ProductCategory productCategory) {
		Assert.notNull(productCategory);

		setValue(productCategory);
		return super.save(productCategory);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public ProductCategory update(ProductCategory productCategory) {
		Assert.notNull(productCategory);

		setValue(productCategory);
		for (ProductCategory children : productCategoryDao.findChildren(productCategory, true, null)) {
			setValue(children);
		}
		return super.update(productCategory);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public ProductCategory update(ProductCategory productCategory, String... ignoreProperties) {
		return super.update(productCategory, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(ProductCategory productCategory) {
		super.delete(productCategory);
	}

	/**
	 * 设置值
	 * 
	 * @param productCategory
	 *            商品分类
	 */
	private void setValue(ProductCategory productCategory) {
		if (productCategory == null) {
			return;
		}
		ProductCategory parent = productCategory.getParent();
		if (parent != null) {
			productCategory.setTreePath(parent.getTreePath() + parent.getId() + ProductCategory.TREE_PATH_SEPARATOR);
		} else {
			productCategory.setTreePath(ProductCategory.TREE_PATH_SEPARATOR);
		}
		productCategory.setGrade(productCategory.getParentIds().length);
	}

}