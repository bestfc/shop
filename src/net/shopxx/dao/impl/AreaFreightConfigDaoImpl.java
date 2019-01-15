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
import net.shopxx.dao.AreaFreightConfigDao;
import net.shopxx.entity.Area;
import net.shopxx.entity.AreaFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;

/**
 * Dao地区运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class AreaFreightConfigDaoImpl extends BaseDaoImpl<AreaFreightConfig, Long> implements AreaFreightConfigDao {

	public boolean exists(ShippingMethod shippingMethod, Store store, Area area) {
		if (shippingMethod == null || store == null || area == null) {
			return false;
		}
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<AreaFreightConfig> criteriaQuery = criteriaBuilder.createQuery(AreaFreightConfig.class);
		Root<AreaFreightConfig> root = criteriaQuery.from(AreaFreightConfig.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("shippingMethod"), shippingMethod));
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("area"), area));
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery).size() > 0;
	}

	public boolean unique(Long id, ShippingMethod shippingMethod, Store store, Area area) {
		if (shippingMethod == null || store == null || area == null) {
			return false;
		}
		if (id != null) {
			String jpql = "select count(*) from AreaFreightConfig areaFreightConfig where areaFreightConfig.id != :id and areaFreightConfig.shippingMethod = :shippingMethod and areaFreightConfig.store = :store and areaFreightConfig.area = :area";
			Long count = entityManager.createQuery(jpql, Long.class).setParameter("id", id).setParameter("shippingMethod", shippingMethod).setParameter("store", store).setParameter("area", area).getSingleResult();
			return count <= 0;
		} else {
			String jpql = "select count(*) from AreaFreightConfig areaFreightConfig where areaFreightConfig.shippingMethod = :shippingMethod and areaFreightConfig.store = :store and areaFreightConfig.area = :area";
			Long count = entityManager.createQuery(jpql, Long.class).setParameter("shippingMethod", shippingMethod).setParameter("store", store).setParameter("area", area).getSingleResult();
			return count <= 0;
		}
	}

	public Page<AreaFreightConfig> findPage(ShippingMethod shippingMethod, Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<AreaFreightConfig> criteriaQuery = criteriaBuilder.createQuery(AreaFreightConfig.class);
		Root<AreaFreightConfig> root = criteriaQuery.from(AreaFreightConfig.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (shippingMethod != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("shippingMethod"), shippingMethod));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}
}