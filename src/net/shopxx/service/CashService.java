/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;

/**
 * Service提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface CashService extends BaseService<Cash, Long> {

	/**
	 * 申请提现
	 * 
	 * @param cash
	 *            提现
	 * @param business
	 *            商家
	 */
	void applyCash(Cash cash, Business business);

	/**
	 * 查找提现记录分页
	 * 
	 * @param business
	 *            商家
	 * @param pageable
	 *            分页信息
	 * @return 提现记录分页
	 */
	Page<Cash> findPage(Business business, Pageable pageable);

	/**
	 * 审核提现
	 * 
	 * @param cash
	 *            提现
	 * @param isPassed
	 *            是否审核通过
	 */
	void review(Cash cash, Boolean isPassed);
}