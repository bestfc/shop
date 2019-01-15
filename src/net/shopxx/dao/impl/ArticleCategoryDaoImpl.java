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

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.builder.CompareToBuilder;
import org.springframework.stereotype.Repository;

import net.shopxx.dao.ArticleCategoryDao;
import net.shopxx.entity.ArticleCategory;

/**
 * Dao文章分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class ArticleCategoryDaoImpl extends BaseDaoImpl<ArticleCategory, Long> implements ArticleCategoryDao {

	public List<ArticleCategory> findRoots(Integer count) {
		String jpql = "select articleCategory from ArticleCategory articleCategory where articleCategory.parent is null order by articleCategory.order asc";
		TypedQuery<ArticleCategory> query = entityManager.createQuery(jpql, ArticleCategory.class);
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<ArticleCategory> findParents(ArticleCategory articleCategory, boolean recursive, Integer count) {
		if (articleCategory == null || articleCategory.getParent() == null) {
			return Collections.emptyList();
		}
		TypedQuery<ArticleCategory> query;
		if (recursive) {
			String jpql = "select articleCategory from ArticleCategory articleCategory where articleCategory.id in (:ids) order by articleCategory.grade asc";
			query = entityManager.createQuery(jpql, ArticleCategory.class).setParameter("ids", Arrays.asList(articleCategory.getParentIds()));
		} else {
			String jpql = "select articleCategory from ArticleCategory articleCategory where articleCategory = :articleCategory";
			query = entityManager.createQuery(jpql, ArticleCategory.class).setParameter("articleCategory", articleCategory.getParent());
		}
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<ArticleCategory> findChildren(ArticleCategory articleCategory, boolean recursive, Integer count) {
		TypedQuery<ArticleCategory> query;
		if (recursive) {
			if (articleCategory != null) {
				String jpql = "select articleCategory from ArticleCategory articleCategory where articleCategory.treePath like :treePath order by articleCategory.grade asc, articleCategory.order asc";
				query = entityManager.createQuery(jpql, ArticleCategory.class).setParameter("treePath", "%" + ArticleCategory.TREE_PATH_SEPARATOR + articleCategory.getId() + ArticleCategory.TREE_PATH_SEPARATOR + "%");
			} else {
				String jpql = "select articleCategory from ArticleCategory articleCategory order by articleCategory.grade asc, articleCategory.order asc";
				query = entityManager.createQuery(jpql, ArticleCategory.class);
			}
			if (count != null) {
				query.setMaxResults(count);
			}
			List<ArticleCategory> result = query.getResultList();
			sort(result);
			return result;
		} else {
			String jpql = "select articleCategory from ArticleCategory articleCategory where articleCategory.parent = :parent order by articleCategory.order asc";
			query = entityManager.createQuery(jpql, ArticleCategory.class).setParameter("parent", articleCategory);
			if (count != null) {
				query.setMaxResults(count);
			}
			return query.getResultList();
		}
	}

	/**
	 * 排序文章分类
	 * 
	 * @param articleCategories
	 *            文章分类
	 */
	private void sort(List<ArticleCategory> articleCategories) {
		if (CollectionUtils.isEmpty(articleCategories)) {
			return;
		}
		final Map<Long, Integer> orderMap = new HashMap<>();
		for (ArticleCategory articleCategory : articleCategories) {
			orderMap.put(articleCategory.getId(), articleCategory.getOrder());
		}
		Collections.sort(articleCategories, new Comparator<ArticleCategory>() {
			@Override
			public int compare(ArticleCategory articleCategory1, ArticleCategory articleCategory2) {
				Long[] ids1 = (Long[]) ArrayUtils.add(articleCategory1.getParentIds(), articleCategory1.getId());
				Long[] ids2 = (Long[]) ArrayUtils.add(articleCategory2.getParentIds(), articleCategory2.getId());
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
						compareToBuilder.append(articleCategory1.getGrade(), articleCategory2.getGrade());
					}
				}
				return compareToBuilder.toComparison();
			}
		});
	}

}