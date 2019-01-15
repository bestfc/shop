/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import net.shopxx.entity.DeliveryCorp;

import java.util.List;

/**
 * Dao物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface DeliveryCorpDao extends BaseDao<DeliveryCorp, Long> {

    List<DeliveryCorp> findUseTotal();
}