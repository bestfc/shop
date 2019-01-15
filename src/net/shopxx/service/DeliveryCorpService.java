/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import net.shopxx.entity.DeliveryCorp;

import java.util.List;

/**
 * Service物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface DeliveryCorpService extends BaseService<DeliveryCorp, Long> {
    List<DeliveryCorp> findUseTotal();
}