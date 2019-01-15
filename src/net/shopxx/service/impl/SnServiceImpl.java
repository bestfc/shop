/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.shopxx.dao.SnDao;
import net.shopxx.entity.Sn;
import net.shopxx.service.SnService;

/**
 * Service序列号
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class SnServiceImpl implements SnService {

	@Inject
	private SnDao snDao;

	@Transactional
	public String generate(Sn.Type type) {
		return snDao.generate(type);
	}

}