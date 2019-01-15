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

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.StoreProductCategoryDao;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductCategory;

/**
 * Dao店铺商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class StoreProductCategoryDaoImpl extends BaseDaoImpl<StoreProductCategory, Long> implements StoreProductCategoryDao {

	public List<StoreProductCategory> findRoots(Store store, Integer count) {
		String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory where storeProductCategory.store = :store and storeProductCategory.parent is null order by storeProductCategory.order asc";
		TypedQuery<StoreProductCategory> query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("store", store);
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<StoreProductCategory> findParents(StoreProductCategory storeProductCategory, boolean recursive, Integer count) {
		if (storeProductCategory == null || storeProductCategory.getParent() == null) {
			return Collections.emptyList();
		}
		TypedQuery<StoreProductCategory> query;
		if (recursive) {
			String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory where storeProductCategory.id in (:ids) order by storeProductCategory.grade asc";
			query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("ids", Arrays.asList(storeProductCategory.getParentIds()));
		} else {
			String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory where storeProductCategory = :storeProductCategory";
			query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("storeProductCategory", storeProductCategory.getParent());
		}
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<StoreProductCategory> findChildren(StoreProductCategory storeProductCategory, Store store, boolean recursive, Integer count) {
		TypedQuery<StoreProductCategory> query;
		if (recursive) {
			if (storeProductCategory != null) {
				String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory where storeProductCategory.store = :store and storeProductCategory.treePath like :treePath order by storeProductCategory.grade asc";
				query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("treePath", "%" + StoreProductCategory.TREE_PATH_SEPARATOR + storeProductCategory.getId() + StoreProductCategory.TREE_PATH_SEPARATOR + "%").setParameter("store", store);
			} else {
				String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory  where storeProductCategory.store = :store order by storeProductCategory.grade asc";
				query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("store", store);
			}
			if (count != null) {
				query.setMaxResults(count);
			}
			List<StoreProductCategory> result = query.getResultList();
			sort(result);
			return result;
		} else {
			String jpql = "select storeProductCategory from StoreProductCategory storeProductCategory where storeProductCategory.parent = :parent and storeProductCategory.store = :store order by storeProductCategory.order asc";
			query = entityManager.createQuery(jpql, StoreProductCategory.class).setParameter("parent", storeProductCategory).setParameter("store", store);
			if (count != null) {
				query.setMaxResults(count);
			}
			return query.getResultList();
		}
	}

	public Page<StoreProductCategory> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<StoreProductCategory> criteriaQuery = criteriaBuilder.createQuery(StoreProductCategory.class);
		Root<StoreProductCategory> root = criteriaQuery.from(StoreProductCategory.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	/**
	 * 排序店铺商品分类
	 * 
	 * @param storeProductCategorys
	 *            店铺商品分类
	 */
	private void sort(List<StoreProductCategory> storeProductCategorys) {
		if (CollectionUtils.isEmpty(storeProductCategorys)) {
			return;
		}
		final Map<Long, Integer> orderMap = new HashMap<>();
		for (StoreProductCategory shopProductCategory : storeProductCategorys) {
			orderMap.put(shopProductCategory.getId(), shopProductCategory.getOrder());
		}
		Collections.sort(storeProductCategorys, new Comparator<StoreProductCategory>() {
			@Override
			public int compare(StoreProductCategory storeProductCategory1, StoreProductCategory storeProductCategory2) {
				Long[] ids1 = (Long[]) ArrayUtils.add(storeProductCategory1.getParentIds(), storeProductCategory1.getId());
				Long[] ids2 = (Long[]) ArrayUtils.add(storeProductCategory2.getParentIds(), storeProductCategory2.getId());
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
						compareToBuilder.append(storeProductCategory1.getGrade(), storeProductCategory2.getGrade());
					}
				}
				return compareToBuilder.toComparison();
			}
		});
	}

}