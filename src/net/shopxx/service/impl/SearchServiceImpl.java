/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.lang.StringUtils;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.FullTextQuery;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.BooleanJunction;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.Article;
import net.shopxx.entity.Product;
import net.shopxx.entity.Store;
import net.shopxx.service.SearchService;

/**
 * Service搜索
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public class SearchServiceImpl implements SearchService {

	@PersistenceContext
	private EntityManager entityManager;

	public void index(Class<?> type) {
		index(type, true);
	}

	public void index(Class<?> type, boolean purgeAll) {
		Assert.notNull(type);

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		fullTextEntityManager.createIndexer(type).purgeAllOnStart(purgeAll).start();
	}

	@SuppressWarnings("unchecked")
	public Page<Article> search(String keyword, Pageable pageable) {
		if (StringUtils.isEmpty(keyword)) {
			return new Page<>();
		}

		if (pageable == null) {
			pageable = new Pageable();
		}

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Article.class).get();

		Query titleQuery = queryBuilder.keyword().fuzzy().onField("title").matching(keyword).createQuery();
		Query contentQuery = queryBuilder.keyword().onField("content").matching(keyword).createQuery();
		Query isPublicationQuery = queryBuilder.phrase().onField("isPublication").sentence("true").createQuery();
		Query query = queryBuilder.bool().must(queryBuilder.bool().should(titleQuery).should(contentQuery).createQuery()).must(isPublicationQuery).createQuery();

		FullTextQuery fullTextQuery = fullTextEntityManager.createFullTextQuery(query, Article.class);
		fullTextQuery.setSort(new Sort(new SortField("isTop", SortField.Type.STRING, true), new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true)));
		fullTextQuery.setFirstResult((pageable.getPageNumber()) * pageable.getPageSize());
		fullTextQuery.setMaxResults(pageable.getPageSize());
		return new Page<>(fullTextQuery.getResultList(), fullTextQuery.getResultSize(), pageable);
	}

	@SuppressWarnings("unchecked")
	public Page<Product> search(String keyword, Store store, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Pageable pageable) {
		if (StringUtils.isEmpty(keyword)) {
			return new Page<>();
		}

		if (pageable == null) {
			pageable = new Pageable();
		}

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Product.class).get();

		Query snQuery = queryBuilder.phrase().onField("sn").sentence(keyword).createQuery();
		Query nameQuery = queryBuilder.keyword().fuzzy().onField("name").matching(keyword).createQuery();
		Query keywordQuery = queryBuilder.keyword().onField("keyword").matching(keyword).createQuery();
		Query introductionQuery = queryBuilder.keyword().onField("introduction").matching(keyword).createQuery();
		Query isMarketableQuery = queryBuilder.phrase().onField("isMarketable").sentence("true").createQuery();
		Query isListQuery = queryBuilder.phrase().onField("isList").sentence("true").createQuery();
		Query isActiveQuery = queryBuilder.phrase().onField("isActive").sentence("true").createQuery();
		BooleanJunction<?> booleanJunction = queryBuilder.bool().must(queryBuilder.bool().should(snQuery).should(nameQuery).should(keywordQuery).should(introductionQuery).createQuery()).must(isMarketableQuery).must(isListQuery).must(isActiveQuery);
		if (store != null) {
			Query storeQuery = queryBuilder.phrase().onField("store.id").sentence(String.valueOf(store.getId())).createQuery();
			booleanJunction = booleanJunction.must(storeQuery);
		}
		if (startPrice != null && endPrice != null) {
			Query priceQuery = queryBuilder.range().onField("price").from(startPrice.doubleValue()).to(endPrice.doubleValue()).createQuery();
			booleanJunction = booleanJunction.must(priceQuery);
		} else if (startPrice != null) {
			Query priceQuery = queryBuilder.range().onField("price").above(startPrice.doubleValue()).createQuery();
			booleanJunction = booleanJunction.must(priceQuery);
		} else if (endPrice != null) {
			Query priceQuery = queryBuilder.range().onField("price").below(endPrice.doubleValue()).createQuery();
			booleanJunction = booleanJunction.must(priceQuery);
		}
		FullTextQuery fullTextQuery = fullTextEntityManager.createFullTextQuery(booleanJunction.createQuery(), Product.class);

		SortField[] sortFields = null;
		if (orderType != null) {
			switch (orderType) {
			case topDesc:
				sortFields = new SortField[] { new SortField("isTop", SortField.Type.STRING, true), new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			case priceAsc:
				sortFields = new SortField[] { new SortField("price", SortField.Type.DOUBLE, false), new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			case priceDesc:
				sortFields = new SortField[] { new SortField("price", SortField.Type.DOUBLE, true), new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			case salesDesc:
				sortFields = new SortField[] { new SortField("sales", SortField.Type.LONG, true), new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			case scoreDesc:
				sortFields = new SortField[] { new SortField("score", SortField.Type.FLOAT, true), new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			case dateDesc:
				sortFields = new SortField[] { new SortField("createdDate", SortField.Type.LONG, true) };
				break;
			}
		} else {
			sortFields = new SortField[] { new SortField("isTop", SortField.Type.STRING, true), new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true) };
		}
		fullTextQuery.setSort(new Sort(sortFields));
		fullTextQuery.setFirstResult((pageable.getPageNumber()) * pageable.getPageSize());
		fullTextQuery.setMaxResults(pageable.getPageSize());
		return new Page<>(fullTextQuery.getResultList(), fullTextQuery.getResultSize(), pageable);
	}

	@SuppressWarnings("unchecked")
	public List<Store> searchStore(String keyword) {
		if (StringUtils.isEmpty(keyword)) {
			return new ArrayList<>();
		}

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Store.class).get();

		Query nameQuery = queryBuilder.keyword().fuzzy().onField("name").matching(keyword).createQuery();
		Query keywordQuery = queryBuilder.keyword().onField("keyword").matching(keyword).createQuery();
		Query statusQuery = queryBuilder.phrase().onField("status").sentence(String.valueOf(Store.Status.success)).createQuery();
		Query isEnabledQuery = queryBuilder.phrase().onField("isEnabled").sentence("true").createQuery();
		Query query = queryBuilder.bool().must(queryBuilder.bool().should(nameQuery).should(keywordQuery).createQuery()).must(statusQuery).must(isEnabledQuery).createQuery();

		FullTextQuery fullTextQuery = fullTextEntityManager.createFullTextQuery(query, Store.class);
		fullTextQuery.setSort(new Sort(new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true)));
		return fullTextQuery.getResultList();
	}

}