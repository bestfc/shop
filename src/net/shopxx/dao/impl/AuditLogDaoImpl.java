/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import org.springframework.stereotype.Repository;

import net.shopxx.dao.AuditLogDao;
import net.shopxx.entity.AuditLog;

/**
 * Dao审计日志
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class AuditLogDaoImpl extends BaseDaoImpl<AuditLog, Long> implements AuditLogDao {

	public void removeAll() {
		String jpql = "delete from AuditLog auditLog";
		entityManager.createQuery(jpql).executeUpdate();
	}

}