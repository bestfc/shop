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

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.BusinessAttributeDao;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessAttribute;

/**
 * Dao商家注册项
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class BusinessAttributeDaoImpl extends BaseDaoImpl<BusinessAttribute, Long> implements BusinessAttributeDao {

	public Integer findUnusedPropertyIndex() {
		for (int i = 0; i < Business.COMMON_ATTRIBUTE_VALUE_PROPERTY_COUNT; i++) {
			String jpql = "select count(*) from BusinessAttribute businessAttribute where businessAttribute.propertyIndex = :propertyIndex";
			Long count = entityManager.createQuery(jpql, Long.class).setParameter("propertyIndex", i).getSingleResult();
			if (count == 0) {
				return i;
			}
		}
		return null;
	}

	public List<BusinessAttribute> findList(Boolean isEnabled, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<BusinessAttribute> criteriaQuery = criteriaBuilder.createQuery(BusinessAttribute.class);
		Root<BusinessAttribute> root = criteriaQuery.from(BusinessAttribute.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (isEnabled != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isEnabled"), isEnabled));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery, null, count, filters, orders);
	}

	public void clearAttributeValue(BusinessAttribute businessAttribute) {
		if (businessAttribute == null || businessAttribute.getType() == null || businessAttribute.getPropertyIndex() == null) {
			return;
		}

		String propertyName;
		switch (businessAttribute.getType()) {
		case text:
		case select:
		case checkbox:
		case image:
		case date:
			propertyName = Business.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + businessAttribute.getPropertyIndex();
			break;
		default:
			propertyName = String.valueOf(businessAttribute.getType());
			break;
		}
		String jpql = "update Business businesses set businesses." + propertyName + " = null";
		entityManager.createQuery(jpql).executeUpdate();
	}

}