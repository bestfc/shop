/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.StoreRankDao;
import net.shopxx.entity.StoreRank;
import net.shopxx.service.StoreRankService;

/**
 * Service店铺等级
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StoreRankServiceImpl extends BaseServiceImpl<StoreRank, Long> implements StoreRankService {

	@Inject
	private StoreRankDao storeRankDao;

	@Transactional(readOnly = true)
	public boolean nameExists(String name) {
		return storeRankDao.exists("name", name);
	}

	@Transactional(readOnly = true)
	public boolean nameUnique(Long id, String name) {
		return storeRankDao.unique(id, "name", name);
	}

	@Transactional(readOnly = true)
	public List<StoreRank> findList(Boolean isAllowRegister, List<Filter> filters, List<Order> orders) {
		return storeRankDao.findList(isAllowRegister, filters, orders);
	}

}