/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StockLogDao;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;
import net.shopxx.service.StockLogService;

/**
 * Service库存记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class StockLogServiceImpl extends BaseServiceImpl<StockLog, Long> implements StockLogService {

	@Inject
	private StockLogDao stockLogDao;

	@Transactional(readOnly = true)
	public Page<StockLog> findPage(Store store, Pageable pageable) {
		return stockLogDao.findPage(store, pageable);
	}

}