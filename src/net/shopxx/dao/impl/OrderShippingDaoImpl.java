/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import javax.persistence.NoResultException;

import org.springframework.stereotype.Repository;

import net.shopxx.dao.OrderShippingDao;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderShipping;

/**
 * Dao订单发货
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class OrderShippingDaoImpl extends BaseDaoImpl<OrderShipping, Long> implements OrderShippingDao {

	public OrderShipping findLast(Order order) {
		if (order == null) {
			return null;
		}
		String jpql = "select orderShipping from OrderShipping shipping where lower(orderShipping.order) = lower(:order) order by orderShipping.createdDate desc";
		try {
			return entityManager.createQuery(jpql, OrderShipping.class).setParameter("order", order.getId()).setMaxResults(1).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

}