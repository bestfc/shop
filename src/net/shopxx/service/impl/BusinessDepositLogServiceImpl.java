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
import net.shopxx.dao.BusinessDepositLogDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.service.BusinessDepositLogService;

/**
 * Service商家预存款记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class BusinessDepositLogServiceImpl extends BaseServiceImpl<BusinessDepositLog, Long> implements BusinessDepositLogService {

	@Inject
	private BusinessDepositLogDao businessDepositLogDao;

	@Transactional(readOnly = true)
	public Page<BusinessDepositLog> findPage(Business business, Pageable pageable) {
		return businessDepositLogDao.findPage(business, pageable);
	}

}