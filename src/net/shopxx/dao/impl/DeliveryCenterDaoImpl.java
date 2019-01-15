/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.DeliveryCenterDao;
import net.shopxx.entity.DeliveryCenter;
import net.shopxx.entity.Store;

/**
 * Dao发货点
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class DeliveryCenterDaoImpl extends BaseDaoImpl<DeliveryCenter, Long> implements DeliveryCenterDao {

	public DeliveryCenter findDefault(Store store) {
		try {
			String jpql = "select deliveryCenter from DeliveryCenter deliveryCenter where deliveryCenter.isDefault = true and lower(deliveryCenter.store) = lower(:store)";
			return entityManager.createQuery(jpql, DeliveryCenter.class).setParameter("store", store).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public void clearDefault(Store store) {
		String jpql = "update DeliveryCenter deliveryCenter set deliveryCenter.isDefault = false where deliveryCenter.isDefault = true and lower(deliveryCenter.store) = lower(:store)";
		entityManager.createQuery(jpql).setParameter("store", store).executeUpdate();
	}

	public void clearDefault(DeliveryCenter exclude) {
		Assert.notNull(exclude);

		String jpql = "update DeliveryCenter deliveryCenter set deliveryCenter.isDefault = false where deliveryCenter.isDefault = true and deliveryCenter != :exclude and lower(deliveryCenter.store) = lower(:store)";
		entityManager.createQuery(jpql).setParameter("exclude", exclude).setParameter("store", exclude.getStore()).executeUpdate();
	}

	public Page<DeliveryCenter> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<DeliveryCenter> criteriaQuery = criteriaBuilder.createQuery(DeliveryCenter.class);
		Root<DeliveryCenter> root = criteriaQuery.from(DeliveryCenter.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	public List<DeliveryCenter> findAll(Store store) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<DeliveryCenter> criteriaQuery = criteriaBuilder.createQuery(DeliveryCenter.class);
		Root<DeliveryCenter> root = criteriaQuery.from(DeliveryCenter.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery);
	}
}