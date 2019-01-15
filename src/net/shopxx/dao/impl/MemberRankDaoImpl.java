/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.math.BigDecimal;

import javax.persistence.NoResultException;

import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.dao.MemberRankDao;
import net.shopxx.entity.MemberRank;

/**
 * Dao会员等级
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class MemberRankDaoImpl extends BaseDaoImpl<MemberRank, Long> implements MemberRankDao {

	public MemberRank findDefault() {
		try {
			String jpql = "select memberRank from MemberRank memberRank where memberRank.isDefault = true";
			return entityManager.createQuery(jpql, MemberRank.class).getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public MemberRank findByAmount(BigDecimal amount) {
		String jpql = "select memberRank from MemberRank memberRank where memberRank.isSpecial = false and memberRank.amount <= :amount order by memberRank.amount desc";
		return entityManager.createQuery(jpql, MemberRank.class).setParameter("amount", amount).setMaxResults(1).getSingleResult();
	}

	public void clearDefault() {
		String jpql = "update MemberRank memberRank set memberRank.isDefault = false where memberRank.isDefault = true";
		entityManager.createQuery(jpql).executeUpdate();
	}

	public void clearDefault(MemberRank exclude) {
		Assert.notNull(exclude);

		String jpql = "update MemberRank memberRank set memberRank.isDefault = false where memberRank.isDefault = true and memberRank != :exclude";
		entityManager.createQuery(jpql).setParameter("exclude", exclude).executeUpdate();
	}

}