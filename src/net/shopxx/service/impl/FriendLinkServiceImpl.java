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
import net.shopxx.dao.FriendLinkDao;
import net.shopxx.entity.FriendLink;
import net.shopxx.service.FriendLinkService;

/**
 * Service友情链接
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class FriendLinkServiceImpl extends BaseServiceImpl<FriendLink, Long> implements FriendLinkService {

	@Inject
	private FriendLinkDao friendLinkDao;

	@Transactional(readOnly = true)
	public List<FriendLink> findList(FriendLink.Type type) {
		return friendLinkDao.findList(type);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "friendLink", condition = "#useCache")
	public List<FriendLink> findList(Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		return friendLinkDao.findList(null, count, filters, orders);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public FriendLink save(FriendLink friendLink) {
		return super.save(friendLink);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public FriendLink update(FriendLink friendLink) {
		return super.update(friendLink);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public FriendLink update(FriendLink friendLink, String... ignoreProperties) {
		return super.update(friendLink, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "friendLink", allEntries = true)
	public void delete(FriendLink friendLink) {
		super.delete(friendLink);
	}

}