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
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ProductFavoriteDao;
import net.shopxx.entity.Member;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductFavorite;

/**
 * Dao商品收藏
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class ProductFavoriteDaoImpl extends BaseDaoImpl<ProductFavorite, Long> implements ProductFavoriteDao {

	public boolean exists(Member member, Product product) {
		String jpql = "select count(*) from ProductFavorite productFavorite where productFavorite.member = :member and productFavorite.product = :product";
		Long count = entityManager.createQuery(jpql, Long.class).setParameter("member", member).setParameter("product", product).getSingleResult();
		return count > 0;
	}

	public List<ProductFavorite> findList(Member member, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<ProductFavorite> criteriaQuery = criteriaBuilder.createQuery(ProductFavorite.class);
		Root<ProductFavorite> root = criteriaQuery.from(ProductFavorite.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (member != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("member"), member));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery, null, count, filters, orders);
	}

	public Page<ProductFavorite> findPage(Member member, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<ProductFavorite> criteriaQuery = criteriaBuilder.createQuery(ProductFavorite.class);
		Root<ProductFavorite> root = criteriaQuery.from(ProductFavorite.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (member != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("member"), member));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	public Long count(Member member) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<ProductFavorite> criteriaQuery = criteriaBuilder.createQuery(ProductFavorite.class);
		Root<ProductFavorite> root = criteriaQuery.from(ProductFavorite.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (member != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("member"), member));
		}
		criteriaQuery.where(restrictions);
		return super.count(criteriaQuery);
	}

}