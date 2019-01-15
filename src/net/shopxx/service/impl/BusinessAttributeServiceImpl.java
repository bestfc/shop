/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.BusinessAttributeDao;
import net.shopxx.entity.BusinessAttribute;
import net.shopxx.service.BusinessAttributeService;

/**
 * Service商家注册项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class BusinessAttributeServiceImpl extends BaseServiceImpl<BusinessAttribute, Long> implements BusinessAttributeService {

	@Inject
	private BusinessAttributeDao businessAttributeDao;

	@Transactional(readOnly = true)
	public Integer findUnusedPropertyIndex() {
		return businessAttributeDao.findUnusedPropertyIndex();
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "businessAttribute", condition = "#useCache")
	public List<BusinessAttribute> findList(Boolean isEnabled, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		return businessAttributeDao.findList(isEnabled, count, filters, orders);

	}

	@Transactional(readOnly = true)
	@Cacheable(value = "businessAttribute", condition = "#useCache")
	public List<BusinessAttribute> findList(Boolean isEnabled, boolean useCache) {
		return businessAttributeDao.findList(isEnabled, null, null, null);
	}

	@Transactional(readOnly = true)
	public boolean isValid(BusinessAttribute businessAttribute, String[] values) {
		Assert.notNull(businessAttribute);
		Assert.notNull(businessAttribute.getType());

		String value = ArrayUtils.isNotEmpty(values) ? values[0].trim() : null;
		switch (businessAttribute.getType()) {
		case name:
		case licenseNumber:
		case licenseImage:
		case legalPerson:
		case idCard:
		case idCardImage:
		case phone:
		case organizationCode:
		case organizationImage:
		case identificationNumber:
		case taxImage:
		case bankName:
		case bankAccount:
		case text:
		case image:
		case date:
			if (businessAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (StringUtils.isNotEmpty(businessAttribute.getPattern()) && StringUtils.isNotEmpty(value) && !Pattern.compile(businessAttribute.getPattern()).matcher(value).matches()) {
				return false;
			}
			break;
		case select:
			if (businessAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (CollectionUtils.isEmpty(businessAttribute.getOptions())) {
				return false;
			}
			if (StringUtils.isNotEmpty(value) && !businessAttribute.getOptions().contains(value)) {
				return false;
			}
			break;
		case checkbox:
			if (businessAttribute.getIsRequired() && ArrayUtils.isEmpty(values)) {
				return false;
			}
			if (CollectionUtils.isEmpty(businessAttribute.getOptions())) {
				return false;
			}
			if (ArrayUtils.isNotEmpty(values) && !businessAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return false;
			}
			break;
		}
		return true;
	}

	@Transactional(readOnly = true)
	public Object toBusinessAttributeValue(BusinessAttribute businessAttribute, String[] values) {
		Assert.notNull(businessAttribute);
		Assert.notNull(businessAttribute.getType());

		if (ArrayUtils.isEmpty(values)) {
			return null;
		}

		String value = values[0].trim();
		switch (businessAttribute.getType()) {
		case name:
		case licenseNumber:
		case licenseImage:
		case legalPerson:
		case idCard:
		case idCardImage:
		case phone:
		case organizationCode:
		case organizationImage:
		case identificationNumber:
		case taxImage:
		case bankName:
		case bankAccount:
		case text:
		case image:
		case date:
			return StringUtils.isNotEmpty(value) ? value : null;
		case select:
			if (CollectionUtils.isNotEmpty(businessAttribute.getOptions()) && businessAttribute.getOptions().contains(value)) {
				return value;
			}
			break;
		case checkbox:
			if (CollectionUtils.isNotEmpty(businessAttribute.getOptions()) && businessAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return Arrays.asList(values);
			}
			break;
		}
		return null;
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute save(BusinessAttribute businessAttribute) {
		Assert.notNull(businessAttribute);

		Integer unusedPropertyIndex = businessAttributeDao.findUnusedPropertyIndex();
		Assert.notNull(unusedPropertyIndex);

		businessAttribute.setPropertyIndex(unusedPropertyIndex);

		return super.save(businessAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute update(BusinessAttribute businessAttribute) {
		return super.update(businessAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute update(BusinessAttribute businessAttribute, String... ignoreProperties) {
		return super.update(businessAttribute, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(BusinessAttribute businessAttribute) {
		if (businessAttribute != null) {
			businessAttributeDao.clearAttributeValue(businessAttribute);
		}

		super.delete(businessAttribute);
	}

}