/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

import javax.persistence.NoResultException;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.dao.PaymentTransactionDao;
import net.shopxx.entity.PaymentTransaction;
import net.shopxx.entity.PaymentTransaction.LineItem;
import net.shopxx.plugin.PaymentPlugin;

/**
 * Dao支付事务
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class PaymentTransactionDaoImpl extends BaseDaoImpl<PaymentTransaction, Long> implements PaymentTransactionDao {

	public PaymentTransaction findAvailable(PaymentTransaction.LineItem lineItem, PaymentPlugin paymentPlugin) {
		Assert.notNull(lineItem);
		Assert.notNull(paymentPlugin);
		Assert.notNull(lineItem.getAmount());
		Assert.notNull(lineItem.getType());
		Assert.notNull(lineItem.getTarget());

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<PaymentTransaction> criteriaQuery = criteriaBuilder.createQuery(PaymentTransaction.class);
		Root<PaymentTransaction> root = criteriaQuery.from(PaymentTransaction.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		BigDecimal amount = paymentPlugin.calculateAmount(lineItem.getAmount());
		BigDecimal fee = paymentPlugin.calculateFee(lineItem.getAmount());
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), lineItem.getType()), criteriaBuilder.equal(root.get("amount"), amount), criteriaBuilder.equal(root.get("fee"), fee), criteriaBuilder.equal(root.get("isSuccess"), false),
				criteriaBuilder.equal(root.get("paymentPluginId"), paymentPlugin.getId()), root.get("parent").isNull(), criteriaBuilder.or(root.get("expire").isNull(), criteriaBuilder.greaterThan(root.<Date>get("expire"), new Date())));
		switch (lineItem.getType()) {
		case ORDER_PAYMENT:
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("order"), lineItem.getTarget()));
			break;
		case SVC_PAYMENT:
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("svc"), lineItem.getTarget()));
			break;
		case DEPOSIT_RECHARGE:
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("user"), lineItem.getTarget()));
			break;
		case BAIL_PAYMENT:
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), lineItem.getTarget()));
			break;
		}
		try {
			return entityManager.createQuery(criteriaQuery.where(restrictions)).setMaxResults(1).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public PaymentTransaction findAvailableParent(Collection<PaymentTransaction.LineItem> lineItems, PaymentPlugin paymentPlugin) {
		Assert.notEmpty(lineItems);
		Assert.state(lineItems.size() > 1);
		Assert.notNull(paymentPlugin);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<PaymentTransaction> criteriaQuery = criteriaBuilder.createQuery(PaymentTransaction.class);
		Root<PaymentTransaction> root = criteriaQuery.from(PaymentTransaction.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(root.get("expire").isNull(), criteriaBuilder.greaterThan(root.<Date>get("expire"), new Date())), criteriaBuilder.equal(root.get("isSuccess"), false),
				criteriaBuilder.equal(root.get("paymentPluginId"), paymentPlugin.getId()));
		for (LineItem lineItem : lineItems) {
			Assert.notNull(lineItem);
			Assert.notNull(lineItem.getAmount());
			Assert.notNull(lineItem.getType());
			Assert.notNull(lineItem.getTarget());

			Subquery<PaymentTransaction> subquery = criteriaQuery.subquery(PaymentTransaction.class);
			Root<PaymentTransaction> subqueryRoot = subquery.from(PaymentTransaction.class);
			subquery.select(subqueryRoot);
			Predicate subqueryRestrictions = criteriaBuilder.conjunction();
			BigDecimal amount = paymentPlugin.calculateAmount(lineItem.getAmount());
			BigDecimal fee = paymentPlugin.calculateFee(lineItem.getAmount());

			subqueryRestrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(subqueryRoot.get("type"), lineItem.getType()), criteriaBuilder.equal(subqueryRoot.get("amount"), amount), criteriaBuilder.equal(subqueryRoot.get("fee"), fee),
					criteriaBuilder.equal(subqueryRoot.get("parent"), root));
			switch (lineItem.getType()) {
			case ORDER_PAYMENT:
				subqueryRestrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(subqueryRoot.get("order"), lineItem.getTarget()));
				break;
			case SVC_PAYMENT:
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("svc"), lineItem.getTarget()));
				break;
			case DEPOSIT_RECHARGE:
				subqueryRestrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(subqueryRoot.get("user"), lineItem.getTarget()));
				break;
			case BAIL_PAYMENT:
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), lineItem.getTarget()));
				break;
			}
			subquery.where(subqueryRestrictions);
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		try {
			return entityManager.createQuery(criteriaQuery.where(restrictions)).setMaxResults(1).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

}