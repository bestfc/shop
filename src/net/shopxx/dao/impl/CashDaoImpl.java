/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.CashDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;

/**
 * Dao提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class CashDaoImpl extends BaseDaoImpl<Cash, Long> implements CashDao {

	@Override
	public Page<Cash> findPage(Business business, Pageable pageable) {
		if (business == null) {
			return Page.emptyPage(pageable);
		}
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Cash> criteriaQuery = criteriaBuilder.createQuery(Cash.class);
		Root<Cash> root = criteriaQuery.from(Cash.class);
		criteriaQuery.select(root);
		criteriaQuery.where(criteriaBuilder.equal(root.get("business"), business));
		return super.findPage(criteriaQuery, pageable);
	}

}