/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreProductTagDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductTag;

/**
 * Dao店铺商品标签
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StoreProductTagDaoImpl extends BaseDaoImpl<StoreProductTag, Long> implements StoreProductTagDao {

	public List<StoreProductTag> findList(Store store, Boolean isEnabled) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreProductTag> criteriaQuery = criteriaBuilder.createQuery(StoreProductTag.class);
		Root<StoreProductTag> root = criteriaQuery.from(StoreProductTag.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		if (isEnabled != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isEnabled"), isEnabled));
		}
		criteriaQuery.where(restrictions);
		criteriaQuery.orderBy(criteriaBuilder.asc(root.get("order")));
		return entityManager.createQuery(criteriaQuery).getResultList();
	}

	public Page<StoreProductTag> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreProductTag> criteriaQuery = criteriaBuilder.createQuery(StoreProductTag.class);
		Root<StoreProductTag> root = criteriaQuery.from(StoreProductTag.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

}