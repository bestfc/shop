/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.AttributeDao;
import net.shopxx.dao.ProductCategoryDao;
import net.shopxx.dao.ProductDao;
import net.shopxx.entity.Attribute;
import net.shopxx.entity.ProductCategory;
import net.shopxx.service.AttributeService;

/**
 * Service属性
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class AttributeServiceImpl extends BaseServiceImpl<Attribute, Long> implements AttributeService {

	@Inject
	private AttributeDao attributeDao;
	@Inject
	private ProductCategoryDao productCategoryDao;
	@Inject
	private ProductDao productDao;

	@Transactional(readOnly = true)
	public Integer findUnusedPropertyIndex(ProductCategory productCategory) {
		return attributeDao.findUnusedPropertyIndex(productCategory);
	}

	@Transactional(readOnly = true)
	public List<Attribute> findList(ProductCategory productCategory, Integer count, List<Filter> filters, List<Order> orders) {
		return attributeDao.findList(productCategory, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "attribute", condition = "#useCache")
	public List<Attribute> findList(Long productCategoryId, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		ProductCategory productCategory = productCategoryDao.find(productCategoryId);
		if (productCategoryId != null && productCategory == null) {
			return Collections.emptyList();
		}
		return attributeDao.findList(productCategory, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public String toAttributeValue(Attribute attribute, String value) {
		Assert.notNull(attribute);

		if (StringUtils.isEmpty(value) || CollectionUtils.isEmpty(attribute.getOptions()) || !attribute.getOptions().contains(value)) {
			return null;
		}
		return value;
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public Attribute save(Attribute attribute) {
		Assert.notNull(attribute);

		Integer unusedPropertyIndex = attributeDao.findUnusedPropertyIndex(attribute.getProductCategory());
		Assert.notNull(unusedPropertyIndex);

		attribute.setPropertyIndex(unusedPropertyIndex);
		return super.save(attribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public Attribute update(Attribute attribute) {
		return super.update(attribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public Attribute update(Attribute attribute, String... ignoreProperties) {
		return super.update(attribute, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "attribute", allEntries = true)
	public void delete(Attribute attribute) {
		if (attribute != null) {
			productDao.clearAttributeValue(attribute);
		}

		super.delete(attribute);
	}

}