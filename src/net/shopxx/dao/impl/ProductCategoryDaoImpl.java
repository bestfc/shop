/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.builder.CompareToBuilder;
import org.springframework.stereotype.Repository;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.ProductCategoryDao;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;

/**
 * Dao商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class ProductCategoryDaoImpl extends BaseDaoImpl<ProductCategory, Long> implements ProductCategoryDao {

	public List<ProductCategory> findList(Store store, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<ProductCategory> criteriaQuery = criteriaBuilder.createQuery(ProductCategory.class);
		Root<ProductCategory> root = criteriaQuery.from(ProductCategory.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("stores"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery);
	}

	public List<ProductCategory> findRoots(Integer count) {
		String jpql = "select productCategory from ProductCategory productCategory where productCategory.parent is null order by productCategory.order asc";
		TypedQuery<ProductCategory> query = entityManager.createQuery(jpql, ProductCategory.class);
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<ProductCategory> findParents(ProductCategory productCategory, boolean recursive, Integer count) {
		if (productCategory == null || productCategory.getParent() == null) {
			return Collections.emptyList();
		}
		TypedQuery<ProductCategory> query;
		if (recursive) {
			String jpql = "select productCategory from ProductCategory productCategory where productCategory.id in (:ids) order by productCategory.grade asc";
			query = entityManager.createQuery(jpql, ProductCategory.class).setParameter("ids", Arrays.asList(productCategory.getParentIds()));
		} else {
			String jpql = "select productCategory from ProductCategory productCategory where productCategory = :productCategory";
			query = entityManager.createQuery(jpql, ProductCategory.class).setParameter("productCategory", productCategory.getParent());
		}
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<ProductCategory> findChildren(ProductCategory productCategory, boolean recursive, Integer count) {
		TypedQuery<ProductCategory> query;
		if (recursive) {
			if (productCategory != null) {
				String jpql = "select productCategory from ProductCategory productCategory where productCategory.treePath like :treePath order by productCategory.grade asc, productCategory.order asc";
				query = entityManager.createQuery(jpql, ProductCategory.class).setParameter("treePath", "%" + ProductCategory.TREE_PATH_SEPARATOR + productCategory.getId() + ProductCategory.TREE_PATH_SEPARATOR + "%");
			} else {
				String jpql = "select productCategory from ProductCategory productCategory order by productCategory.grade asc, productCategory.order asc";
				query = entityManager.createQuery(jpql, ProductCategory.class);
			}
			if (count != null) {
				query.setMaxResults(count);
			}
			List<ProductCategory> result = query.getResultList();
			sort(result);
			return result;
		} else {
			String jpql = "select productCategory from ProductCategory productCategory where productCategory.parent = :parent order by productCategory.order asc";
			query = entityManager.createQuery(jpql, ProductCategory.class).setParameter("parent", productCategory);
			if (count != null) {
				query.setMaxResults(count);
			}
			return query.getResultList();
		}
	}

	/**
	 * 排序商品分类
	 * 
	 * @param productCategories
	 *            商品分类
	 */
	private void sort(List<ProductCategory> productCategories) {
		if (CollectionUtils.isEmpty(productCategories)) {
			return;
		}
		final Map<Long, Integer> orderMap = new HashMap<>();
		for (ProductCategory productCategory : productCategories) {
			orderMap.put(productCategory.getId(), productCategory.getOrder());
		}
		Collections.sort(productCategories, new Comparator<ProductCategory>() {
			@Override
			public int compare(ProductCategory productCategory1, ProductCategory productCategory2) {
				Long[] ids1 = (Long[]) ArrayUtils.add(productCategory1.getParentIds(), productCategory1.getId());
				Long[] ids2 = (Long[]) ArrayUtils.add(productCategory2.getParentIds(), productCategory2.getId());
				Iterator<Long> iterator1 = Arrays.asList(ids1).iterator();
				Iterator<Long> iterator2 = Arrays.asList(ids2).iterator();
				CompareToBuilder compareToBuilder = new CompareToBuilder();
				while (iterator1.hasNext() && iterator2.hasNext()) {
					Long id1 = iterator1.next();
					Long id2 = iterator2.next();
					Integer order1 = orderMap.get(id1);
					Integer order2 = orderMap.get(id2);
					compareToBuilder.append(order1, order2).append(id1, id2);
					if (!iterator1.hasNext() || !iterator2.hasNext()) {
						compareToBuilder.append(productCategory1.getGrade(), productCategory2.getGrade());
					}
				}
				return compareToBuilder.toComparison();
			}
		});
	}

}