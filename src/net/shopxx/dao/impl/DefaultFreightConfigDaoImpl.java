/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import javax.persistence.NoResultException;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.DefaultFreightConfigDao;
import net.shopxx.entity.Area;
import net.shopxx.entity.DefaultFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;

/**
 * Dao默认运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class DefaultFreightConfigDaoImpl extends BaseDaoImpl<DefaultFreightConfig, Long> implements DefaultFreightConfigDao {

	public boolean exists(ShippingMethod shippingMethod, Area area) {
		if (shippingMethod == null || area == null) {
			return false;
		}
		String jpql = "select count(*) from AreaFreightConfig areaFreightConfig where areaFreightConfig.shippingMethod = :shippingMethod and areaFreightConfig.area = :area";
		Long count = entityManager.createQuery(jpql, Long.class).setParameter("shippingMethod", shippingMethod).setParameter("area", area).getSingleResult();
		return count > 0;
	}

	public Page<DefaultFreightConfig> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<DefaultFreightConfig> criteriaQuery = criteriaBuilder.createQuery(DefaultFreightConfig.class);
		Root<DefaultFreightConfig> root = criteriaQuery.from(DefaultFreightConfig.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	public DefaultFreightConfig find(ShippingMethod shippingMethod, Store store) {
		if (shippingMethod == null || store == null) {
			return null;
		}
		String jpql = "select defaultFreightConfig from DefaultFreightConfig defaultFreightConfig where defaultFreightConfig.store = :store and defaultFreightConfig.shippingMethod = :shippingMethod order by defaultFreightConfig.store asc";
		try {
			return entityManager.createQuery(jpql, DefaultFreightConfig.class).setParameter("store", store).setParameter("shippingMethod", shippingMethod).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

}