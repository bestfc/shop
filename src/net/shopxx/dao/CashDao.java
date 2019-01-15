/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;

/**
 * Dao提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface CashDao extends BaseDao<Cash, Long> {

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

}