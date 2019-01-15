/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreAdImageDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreAdImage;

/**
 * Dao店铺广告图片
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StoreAdImageDaoImpl extends BaseDaoImpl<StoreAdImage, Long> implements StoreAdImageDao {

	public Page<StoreAdImage> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreAdImage> criteriaQuery = criteriaBuilder.createQuery(StoreAdImage.class);
		Root<StoreAdImage> root = criteriaQuery.from(StoreAdImage.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

}