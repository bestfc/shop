/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.CashDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.entity.Cash;
import net.shopxx.service.BusinessService;
import net.shopxx.service.CashService;

/**
 * Service提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class CashServiceImpl extends BaseServiceImpl<Cash, Long> implements CashService {

	@Inject
	private CashDao cashDao;
	@Inject
	private BusinessService businessService;

	@Transactional(readOnly = true)
	public Page<Cash> findPage(Business business, Pageable pageable) {
		return cashDao.findPage(business, pageable);
	}

	public void applyCash(Cash cash, Business business) {
		Assert.notNull(cash);
		Assert.notNull(business);
		Assert.isTrue(cash.getAmount().compareTo(BigDecimal.ZERO) > 0);

		cash.setStatus(Cash.Status.pending);
		cash.setBusiness(business);
		cashDao.persist(cash);

		businessService.addBalance(cash.getBusiness(), cash.getAmount().negate(), BusinessDepositLog.Type.cash, null);
		businessService.addFrozenFund(business, cash.getAmount());

	}

	public void review(Cash cash, Boolean isPassed) {
		Assert.notNull(cash);
		Assert.notNull(isPassed);

		Business business = cash.getBusiness();
		if (isPassed) {
			Assert.notNull(cash.getAmount());
			Assert.notNull(cash.getBusiness());
			Assert.notNull(cash.getBusiness());
			cash.setStatus(Cash.Status.approved);
		} else {
			cash.setStatus(Cash.Status.failed);
			businessService.addBalance(cash.getBusiness(), cash.getAmount(), BusinessDepositLog.Type.unfrozen, null);
		}
		businessService.addFrozenFund(business, cash.getAmount().negate());
	}

}