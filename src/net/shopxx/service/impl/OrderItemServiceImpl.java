/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.dao.OrderItemDao;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import net.shopxx.entity.OrderItem;
import net.shopxx.service.OrderItemService;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;

/**
 * Service订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class OrderItemServiceImpl extends BaseServiceImpl<OrderItem, Long> implements OrderItemService {
    @Inject
    private OrderItemDao orderItemDao;

    @Override
    @Transactional(readOnly = true)
    public OrderItem findBySn(String sn) {
       return orderItemDao.find("sn", StringUtils.lowerCase(sn));
    }
}