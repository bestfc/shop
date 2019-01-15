/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.StoreRankDao;
import net.shopxx.entity.StoreRank;

/**
 * Dao店铺等级
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StoreRankDaoImpl extends BaseDaoImpl<StoreRank, Long> implements StoreRankDao {

	public List<StoreRank> findList(Boolean isAllowRegister, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreRank> criteriaQuery = criteriaBuilder.createQuery(StoreRank.class);
		Root<StoreRank> root = criteriaQuery.from(StoreRank.class);
		criteriaQuery.select(root);
		if (isAllowRegister != null) {
			criteriaQuery.where(criteriaBuilder.equal(root.get("isAllowRegister"), isAllowRegister));
		}
		return super.findList(criteriaQuery, null, null, filters, orders);
	}

}