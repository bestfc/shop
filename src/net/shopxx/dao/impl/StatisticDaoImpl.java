/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.dao.StatisticDao;
import net.shopxx.entity.Statistic;
import net.shopxx.entity.Store;

/**
 * Dao统计
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StatisticDaoImpl extends BaseDaoImpl<Statistic, Long> implements StatisticDao {

	public boolean exists(Statistic.Type type, Store store, int year, int month, int day) {
		Assert.notNull(type);

		if (store != null) {
			String jpql = "select count(*) from Statistic statistic where statistic.type = :type and statistic.year = :year and statistic.month = :month and statistic.day = :day and statistic.store = :store";
			return entityManager.createQuery(jpql, Long.class).setParameter("type", type).setParameter("year", year).setParameter("month", month).setParameter("day", day).setParameter("store", store).getSingleResult() > 0;
		} else {
			String jpql = "select count(*) from Statistic statistic where statistic.type = :type and statistic.year = :year and statistic.month = :month and statistic.day = :day and statistic.store is null";
			return entityManager.createQuery(jpql, Long.class).setParameter("type", type).setParameter("year", year).setParameter("month", month).setParameter("day", day).getSingleResult() > 0;
		}
	}

	public List<Statistic> analyze(Statistic.Type type, Store store, Statistic.Period period, Date beginDate, Date endDate) {
		Assert.notNull(type);
		Assert.notNull(period);

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Statistic> criteriaQuery = criteriaBuilder.createQuery(Statistic.class);
		Root<Statistic> root = criteriaQuery.from(Statistic.class);
		switch (period) {
		case year:
			criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), criteriaBuilder.sum(root.<BigDecimal>get("value"))));
			criteriaQuery.groupBy(root.get("type"), root.get("year"));
			break;
		case month:
			criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), root.get("month"), criteriaBuilder.sum(root.<BigDecimal>get("value"))));
			criteriaQuery.groupBy(root.get("type"), root.get("year"), root.get("month"));
			break;
		case day:
			criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), root.get("month"), root.get("day"), root.<BigDecimal>get("value")));
			break;
		}
		Predicate restrictions = criteriaBuilder.conjunction();
		if (type != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		if (beginDate != null) {
			Calendar calendar = DateUtils.toCalendar(beginDate);
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH);
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.greaterThan(root.<Integer>get("year"), year), criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.greaterThan(root.<Integer>get("month"), month)),
					criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.equal(root.<Integer>get("month"), month), criteriaBuilder.greaterThanOrEqualTo(root.<Integer>get("day"), day))));
		}
		if (endDate != null) {
			Calendar calendar = DateUtils.toCalendar(endDate);
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH);
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.lessThan(root.<Integer>get("year"), year), criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.lessThan(root.<Integer>get("month"), month)),
					criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.equal(root.<Integer>get("month"), month), criteriaBuilder.lessThanOrEqualTo(root.<Integer>get("day"), day))));
		}
		criteriaQuery.where(restrictions);
		return entityManager.createQuery(criteriaQuery).getResultList();
	}

}