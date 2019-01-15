/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.BrandDao;
import net.shopxx.entity.Brand;
import net.shopxx.entity.ProductCategory;

/**
 * Dao品牌
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class BrandDaoImpl extends BaseDaoImpl<Brand, Long> implements BrandDao {

	public List<Brand> findList(ProductCategory productCategory, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Brand> criteriaQuery = criteriaBuilder.createQuery(Brand.class);
		Root<Brand> root = criteriaQuery.from(Brand.class);
		criteriaQuery.select(root);
		if (productCategory != null) {
			criteriaQuery.where(criteriaBuilder.equal(root.join("productCategories"), productCategory));
		}
		return super.findList(criteriaQuery, null, count, filters, orders);
	}

}