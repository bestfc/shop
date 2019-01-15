/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import net.shopxx.dao.DeliveryCorpDao;
import org.springframework.stereotype.Service;

import net.shopxx.entity.DeliveryCorp;
import net.shopxx.service.DeliveryCorpService;

import javax.inject.Inject;
import java.util.List;

/**
 * Service物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class DeliveryCorpServiceImpl extends BaseServiceImpl<DeliveryCorp, Long> implements DeliveryCorpService {
    @Inject
    private DeliveryCorpDao deliveryCorpDao;

    @Override
    public List<DeliveryCorp> findUseTotal() {
        return deliveryCorpDao.findUseTotal();
    }
}