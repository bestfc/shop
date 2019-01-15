/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.SnDao;
import net.shopxx.entity.OrderReturns;
import net.shopxx.entity.Sn;
import net.shopxx.service.OrderReturnsService;

/**
 * Service订单退货
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class OrderReturnsServiceImpl extends BaseServiceImpl<OrderReturns, Long> implements OrderReturnsService {

	@Inject
	private SnDao snDao;

	@Override
	@Transactional
	public OrderReturns save(OrderReturns orderReturns) {
		Assert.notNull(orderReturns);

		orderReturns.setSn(snDao.generate(Sn.Type.orderReturns));

		return super.save(orderReturns);
	}

}