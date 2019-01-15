/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import javax.inject.Inject;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import net.shopxx.dao.AuditLogDao;
import net.shopxx.entity.AuditLog;
import net.shopxx.service.AuditLogService;

/**
 * Service审计日志
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class AuditLogServiceImpl extends BaseServiceImpl<AuditLog, Long> implements AuditLogService {

	@Inject
	private AuditLogDao auditLogDao;

	@Async
	public void create(AuditLog auditLog) {
		auditLogDao.persist(auditLog);
	}

	public void clear() {
		auditLogDao.removeAll();
	}

}