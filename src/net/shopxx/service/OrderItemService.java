/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.entity.OrderItem;

/**
 * Service订单项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface OrderItemService extends BaseService<OrderItem, Long> {
    /**
     * 根据编号查找订单
     *
     * @param sn
     *            编号(忽略大小写)
     * @return 订单，若不存在则返回null
     */
    OrderItem findBySn(String sn);
}