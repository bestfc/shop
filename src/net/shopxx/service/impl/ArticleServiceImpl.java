/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ArticleCategoryDao;
import net.shopxx.dao.ArticleDao;
import net.shopxx.dao.ArticleTagDao;
import net.shopxx.entity.Article;
import net.shopxx.entity.ArticleCategory;
import net.shopxx.entity.ArticleTag;
import net.shopxx.service.ArticleService;

/**
 * Service文章
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class ArticleServiceImpl extends BaseServiceImpl<Article, Long> implements ArticleService {

	@Inject
	private CacheManager cacheManager;
	@Inject
	private ArticleDao articleDao;
	@Inject
	private ArticleCategoryDao articleCategoryDao;
	@Inject
	private ArticleTagDao articleTagDao;

	@Transactional(readOnly = true)
	public List<Article> findList(ArticleCategory articleCategory, ArticleTag articleTag, Boolean isPublication, Integer count, List<Filter> filters, List<Order> orders) {
		return articleDao.findList(articleCategory, articleTag, isPublication, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "article", condition = "#useCache")
	public List<Article> findList(Long articleCategoryId, Long articleTagId, Boolean isPublication, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		ArticleCategory articleCategory = articleCategoryDao.find(articleCategoryId);
		if (articleCategoryId != null && articleCategory == null) {
			return Collections.emptyList();
		}
		ArticleTag articleTag = articleTagDao.find(articleTagId);
		if (articleTagId != null && articleTag == null) {
			return Collections.emptyList();
		}
		return articleDao.findList(articleCategory, articleTag, isPublication, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public Page<Article> findPage(ArticleCategory articleCategory, ArticleTag articleTag, Boolean isPublication, Pageable pageable) {
		return articleDao.findPage(articleCategory, articleTag, isPublication, pageable);
	}

	public long viewHits(Long id) {
		Assert.notNull(id);

		Ehcache cache = cacheManager.getEhcache(Article.HITS_CACHE_NAME);
		cache.acquireWriteLockOnKey(id);
		try {
			Element element = cache.get(id);
			Long hits;
			if (element != null) {
				hits = (Long) element.getObjectValue() + 1;
			} else {
				Article article = articleDao.find(id);
				if (article == null) {
					return 0L;
				}
				hits = article.getHits() + 1;
			}
			cache.put(new Element(id, hits));
			return hits;
		} finally {
			cache.releaseWriteLockOnKey(id);
		}
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public Article save(Article article) {
		return super.save(article);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public Article update(Article article) {
		return super.update(article);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public Article update(Article article, String... ignoreProperties) {
		return super.update(article, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "article", "articleCategory" }, allEntries = true)
	public void delete(Article article) {
		super.delete(article);
	}

}