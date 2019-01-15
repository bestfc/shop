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
import net.shopxx.dao.InstantMessageDao;
import net.shopxx.entity.InstantMessage;
import net.shopxx.entity.Store;
import net.shopxx.service.InstantMessageService;

/**
 * Service即时通讯
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class InstantMessageServiceImpl extends BaseServiceImpl<InstantMessage, Long> implements InstantMessageService {

	@Inject
	private InstantMessageDao instantMessageDao;

	@Transactional(readOnly = true)
	public Page<InstantMessage> findPage(Store store, Pageable pageable) {
		return instantMessageDao.findPage(store, pageable);
	}

}