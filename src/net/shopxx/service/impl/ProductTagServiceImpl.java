/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.ProductTagDao;
import net.shopxx.entity.ProductTag;
import net.shopxx.service.ProductTagService;

/**
 * Service商品标签
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class ProductTagServiceImpl extends BaseServiceImpl<ProductTag, Long> implements ProductTagService {

	@Inject
	private ProductTagDao productTagDao;

	@Transactional(readOnly = true)
	@Cacheable(value = "productTag", condition = "#useCache")
	public List<ProductTag> findList(Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		return productTagDao.findList(null, count, filters, orders);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public ProductTag save(ProductTag productTag) {
		return super.save(productTag);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public ProductTag update(ProductTag productTag) {
		return super.update(productTag);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public ProductTag update(ProductTag productTag, String... ignoreProperties) {
		return super.update(productTag, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "productTag", allEntries = true)
	public void delete(ProductTag productTag) {
		super.delete(productTag);
	}

}