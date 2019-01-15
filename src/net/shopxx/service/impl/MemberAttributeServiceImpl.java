/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.text.ParseException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.CommonAttributes;
import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.AreaDao;
import net.shopxx.dao.MemberAttributeDao;
import net.shopxx.dao.MemberDao;
import net.shopxx.entity.Area;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberAttribute;
import net.shopxx.service.MemberAttributeService;

/**
 * Service会员注册项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class MemberAttributeServiceImpl extends BaseServiceImpl<MemberAttribute, Long> implements MemberAttributeService {

	@Inject
	private MemberAttributeDao memberAttributeDao;
	@Inject
	private MemberDao memberDao;
	@Inject
	private AreaDao areaDao;

	@Transactional(readOnly = true)
	public Integer findUnusedPropertyIndex() {
		return memberAttributeDao.findUnusedPropertyIndex();
	}

	@Transactional(readOnly = true)
	public List<MemberAttribute> findList(Boolean isEnabled, Integer count, List<Filter> filters, List<Order> orders) {
		return memberAttributeDao.findList(isEnabled, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "memberAttribute", condition = "#useCache")
	public List<MemberAttribute> findList(Boolean isEnabled, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		return memberAttributeDao.findList(isEnabled, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "memberAttribute", condition = "#useCache")
	public List<MemberAttribute> findList(Boolean isEnabled, boolean useCache) {
		return memberAttributeDao.findList(isEnabled, null, null, null);
	}

	@Transactional(readOnly = true)
	public boolean isValid(MemberAttribute memberAttribute, String[] values) {
		Assert.notNull(memberAttribute);
		Assert.notNull(memberAttribute.getType());

		String value = ArrayUtils.isNotEmpty(values) ? values[0].trim() : null;
		switch (memberAttribute.getType()) {
		case name:
		case address:
		case zipCode:
		case phone:
		case text:
			if (memberAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (StringUtils.isNotEmpty(memberAttribute.getPattern()) && StringUtils.isNotEmpty(value) && !Pattern.compile(memberAttribute.getPattern()).matcher(value).matches()) {
				return false;
			}
			break;
		case gender:
			if (memberAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (StringUtils.isNotEmpty(value)) {
				try {
					Member.Gender.valueOf(value);
				} catch (IllegalArgumentException e) {
					return false;
				}
			}
			break;
		case birth:
			if (memberAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (StringUtils.isNotEmpty(value)) {
				try {
					DateUtils.parseDate(value, CommonAttributes.DATE_PATTERNS);
				} catch (ParseException e) {
					return false;
				}
			}
			break;
		case area:
			Long id = NumberUtils.toLong(value, -1L);
			Area area = areaDao.find(id);
			if (memberAttribute.getIsRequired() && area == null) {
				return false;
			}
			break;
		case select:
			if (memberAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (CollectionUtils.isEmpty(memberAttribute.getOptions())) {
				return false;
			}
			if (StringUtils.isNotEmpty(value) && !memberAttribute.getOptions().contains(value)) {
				return false;
			}
			break;
		case checkbox:
			if (memberAttribute.getIsRequired() && ArrayUtils.isEmpty(values)) {
				return false;
			}
			if (CollectionUtils.isEmpty(memberAttribute.getOptions())) {
				return false;
			}
			if (ArrayUtils.isNotEmpty(values) && !memberAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return false;
			}
			break;
		}
		return true;
	}

	@Transactional(readOnly = true)
	public Object toMemberAttributeValue(MemberAttribute memberAttribute, String[] values) {
		Assert.notNull(memberAttribute);
		Assert.notNull(memberAttribute.getType());

		if (ArrayUtils.isEmpty(values)) {
			return null;
		}

		String value = values[0].trim();
		switch (memberAttribute.getType()) {
		case name:
		case address:
		case zipCode:
		case phone:
		case text:
			return StringUtils.isNotEmpty(value) ? value : null;
		case gender:
			if (StringUtils.isEmpty(value)) {
				return null;
			}
			try {
				return Member.Gender.valueOf(value);
			} catch (IllegalArgumentException e) {
				return null;
			}
		case birth:
			if (StringUtils.isEmpty(value)) {
				return null;
			}
			try {
				return DateUtils.parseDate(value, CommonAttributes.DATE_PATTERNS);
			} catch (ParseException e) {
				return null;
			}
		case area:
			Long id = NumberUtils.toLong(value, -1L);
			return areaDao.find(id);
		case select:
			if (CollectionUtils.isNotEmpty(memberAttribute.getOptions()) && memberAttribute.getOptions().contains(value)) {
				return value;
			}
			break;
		case checkbox:
			if (CollectionUtils.isNotEmpty(memberAttribute.getOptions()) && memberAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return Arrays.asList(values);
			}
			break;
		}
		return null;
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public MemberAttribute save(MemberAttribute memberAttribute) {
		Assert.notNull(memberAttribute);

		Integer unusedPropertyIndex = memberAttributeDao.findUnusedPropertyIndex();
		Assert.notNull(unusedPropertyIndex);

		memberAttribute.setPropertyIndex(unusedPropertyIndex);

		return super.save(memberAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public MemberAttribute update(MemberAttribute memberAttribute) {
		return super.update(memberAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public MemberAttribute update(MemberAttribute memberAttribute, String... ignoreProperties) {
		return super.update(memberAttribute, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "memberAttribute", allEntries = true)
	public void delete(MemberAttribute memberAttribute) {
		if (memberAttribute != null) {
			memberDao.clearAttributeValue(memberAttribute);
		}

		super.delete(memberAttribute);
	}

}