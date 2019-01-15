/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;
import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MemberRankDao;
import net.shopxx.dao.ProductCategoryDao;
import net.shopxx.dao.PromotionDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.entity.MemberRank;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Promotion.Type;
import net.shopxx.entity.Store;
import net.shopxx.service.PromotionService;

/**
 * Service促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class PromotionServiceImpl extends BaseServiceImpl<Promotion, Long> implements PromotionService {

	/**
	 * 价格表达式变量
	 */
	private static final List<Map<String, Object>> PRICE_EXPRESSION_VARIABLES = new ArrayList<>();

	/**
	 * 积分表达式变量
	 */
	private static final List<Map<String, Object>> POINT_EXPRESSION_VARIABLES = new ArrayList<>();

	@Inject
	private PromotionDao promotionDao;
	@Inject
	private MemberRankDao memberRankDao;
	@Inject
	private ProductCategoryDao productCategoryDao;
	@Inject
	private StoreDao storeDao;

	static {
		Map<String, Object> variable0 = new HashMap<>();
		Map<String, Object> variable1 = new HashMap<>();
		Map<String, Object> variable2 = new HashMap<>();
		Map<String, Object> variable3 = new HashMap<>();
		variable0.put("quantity", 99);
		variable0.put("price", new BigDecimal("99"));
		variable1.put("quantity", 99);
		variable1.put("price", new BigDecimal("9.9"));
		variable2.put("quantity", 99);
		variable2.put("price", new BigDecimal("0.99"));
		variable3.put("quantity", 99);
		variable3.put("point", 99L);
		PRICE_EXPRESSION_VARIABLES.add(variable0);
		PRICE_EXPRESSION_VARIABLES.add(variable1);
		PRICE_EXPRESSION_VARIABLES.add(variable2);
		POINT_EXPRESSION_VARIABLES.add(variable3);
	}

	@Transactional(readOnly = true)
	public boolean isValidPriceExpression(String priceExpression) {
		Assert.hasText(priceExpression);

		for (Map<String, Object> variable : PRICE_EXPRESSION_VARIABLES) {
			try {
				Binding binding = new Binding();
				for (Map.Entry<String, Object> entry : variable.entrySet()) {
					binding.setVariable(entry.getKey(), entry.getValue());
				}
				GroovyShell groovyShell = new GroovyShell(binding);
				Object result = groovyShell.evaluate(priceExpression);
				new BigDecimal(result.toString());
			} catch (Exception e) {
				return false;
			}
		}
		return true;
	}

	@Transactional(readOnly = true)
	public List<Promotion> findList(Store store, Type type, Boolean isEnabled) {
		return promotionDao.findList(store, type, isEnabled);
	}

	@Transactional(readOnly = true)
	public List<Promotion> findList(Store store, Promotion.Type type, MemberRank memberRank, ProductCategory productCategory, Boolean hasBegun, Boolean hasEnded, Integer count, List<Filter> filters, List<Order> orders) {
		return promotionDao.findList(store, type, memberRank, productCategory, hasBegun, hasEnded, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "promotion", condition = "#useCache")
	public List<Promotion> findList(Promotion.Type type, Long storeId, Long memberRankId, Long productCategoryId, Boolean hasBegun, Boolean hasEnded, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return Collections.emptyList();
		}
		MemberRank memberRank = memberRankDao.find(memberRankId);
		if (memberRankId != null && memberRank == null) {
			return Collections.emptyList();
		}
		ProductCategory productCategory = productCategoryDao.find(productCategoryId);
		if (productCategoryId != null && productCategory == null) {
			return Collections.emptyList();
		}
		return promotionDao.findList(store, type, memberRank, productCategory, hasBegun, hasEnded, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public Page<Promotion> findPage(Store store, Promotion.Type type, Pageable pageable) {
		return promotionDao.findPage(store, type, pageable);
	}

	public void shutDownPromotion(Type type) {
		while (true) {
			List<Promotion> promotions = promotionDao.findList(null, type, null, null, null, null, 100, null, null);
			if (CollectionUtils.isNotEmpty(promotions)) {
				for (Promotion promotion : promotions) {
					promotion.setIsEnabled(false);
				}
				promotionDao.flush();
				promotionDao.clear();
			}
			if (promotions.size() < 100) {
				break;
			}
		}
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public Promotion save(Promotion promotion) {
		return super.save(promotion);
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public Promotion update(Promotion promotion) {
		return super.update(promotion);
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public Promotion update(Promotion promotion, String... ignoreProperties) {
		return super.update(promotion, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "promotion", allEntries = true)
	public void delete(Promotion promotion) {
		super.delete(promotion);
	}

}