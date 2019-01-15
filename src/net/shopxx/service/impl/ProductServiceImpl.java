/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.persistence.LockModeType;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
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
import net.shopxx.Setting;
import net.shopxx.dao.AttributeDao;
import net.shopxx.dao.BrandDao;
import net.shopxx.dao.ProductCategoryDao;
import net.shopxx.dao.ProductDao;
import net.shopxx.dao.ProductTagDao;
import net.shopxx.dao.PromotionDao;
import net.shopxx.dao.SkuDao;
import net.shopxx.dao.SnDao;
import net.shopxx.dao.StockLogDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.dao.StoreProductCategoryDao;
import net.shopxx.dao.StoreProductTagDao;
import net.shopxx.entity.Attribute;
import net.shopxx.entity.Brand;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.ProductTag;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Sn;
import net.shopxx.entity.SpecificationItem;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductCategory;
import net.shopxx.entity.StoreProductTag;
import net.shopxx.service.ProductService;
import net.shopxx.service.SpecificationValueService;
import net.shopxx.util.SystemUtils;

/**
 * Service商品
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service
public class ProductServiceImpl extends BaseServiceImpl<Product, Long> implements ProductService {

	@Inject
	private CacheManager cacheManager;
	@Inject
	private ProductDao productDao;
	@Inject
	private SkuDao skuDao;
	@Inject
	private SnDao snDao;
	@Inject
	private ProductCategoryDao productCategoryDao;
	@Inject
	private StoreProductCategoryDao storeProductCategoryDao;
	@Inject
	private BrandDao brandDao;
	@Inject
	private PromotionDao promotionDao;
	@Inject
	private ProductTagDao productTagDao;
	@Inject
	private StoreProductTagDao storeProductTagDao;
	@Inject
	private AttributeDao attributeDao;
	@Inject
	private StockLogDao stockLogDao;
	@Inject
	private StoreDao storeDao;
	@Inject
	private SpecificationValueService specificationValueService;

	@Transactional(readOnly = true)
	public boolean snExists(String sn) {
		return productDao.exists("sn", sn, true);
	}

	@Transactional(readOnly = true)
	public Product findBySn(String sn) {
		return productDao.find("sn", sn, true);
	}

	@Transactional(readOnly = true)
	public List<Product> findList(Product.Type type, Store store, ProductCategory productCategory, StoreProductCategory storeProductCategory, Brand brand, Promotion promotion, ProductTag productTag, StoreProductTag storeProductTag, Map<Attribute, String> attributeValueMap, BigDecimal startPrice,
			BigDecimal endPrice, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert, Boolean hasPromotion, Product.OrderType orderType, Integer count, List<Filter> filters, List<Order> orders) {
		return productDao.findList(type, store, productCategory, storeProductCategory, brand, promotion, productTag, storeProductTag, attributeValueMap, startPrice, endPrice, isMarketable, isList, isTop, isActive, isOutOfStock, isStockAlert, hasPromotion, orderType, count, filters, orders);
	}

	@Transactional(readOnly = true)
	@Cacheable(value = "product", condition = "#useCache")
	public List<Product> findList(Product.Type type, Long storeId, Long productCategoryId, Long storeProductCategoryId, Long brandId, Long promotionId, Long productTagId, Long storeProductTagId, Map<Long, String> attributeValueMap, BigDecimal startPrice, BigDecimal endPrice, Boolean isMarketable,
			Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert, Boolean hasPromotion, Product.OrderType orderType, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return Collections.emptyList();
		}
		ProductCategory productCategory = productCategoryDao.find(productCategoryId);
		if (productCategoryId != null && productCategory == null) {
			return Collections.emptyList();
		}
		StoreProductCategory storeProductCategory = storeProductCategoryDao.find(storeProductCategoryId);
		if (storeProductCategoryId != null && storeProductCategory == null) {
			return Collections.emptyList();
		}
		Brand brand = brandDao.find(brandId);
		if (brandId != null && brand == null) {
			return Collections.emptyList();
		}
		Promotion promotion = promotionDao.find(promotionId);
		if (promotionId != null && promotion == null) {
			return Collections.emptyList();
		}
		ProductTag productTag = productTagDao.find(productTagId);
		if (productTagId != null && productTag == null) {
			return Collections.emptyList();
		}
		StoreProductTag storeProductTag = storeProductTagDao.find(storeProductTagId);
		if (storeProductTagId != null && storeProductTag == null) {
			return Collections.emptyList();
		}
		Map<Attribute, String> map = new HashMap<>();
		if (attributeValueMap != null) {
			for (Map.Entry<Long, String> entry : attributeValueMap.entrySet()) {
				Attribute attribute = attributeDao.find(entry.getKey());
				if (attribute != null) {
					map.put(attribute, entry.getValue());
				}
			}
		}
		if (MapUtils.isNotEmpty(attributeValueMap) && MapUtils.isEmpty(map)) {
			return Collections.emptyList();
		}
		return productDao.findList(type, store, productCategory, storeProductCategory, brand, promotion, productTag, storeProductTag, map, startPrice, endPrice, isMarketable, isList, isTop, isActive, isOutOfStock, isStockAlert, hasPromotion, orderType, count, filters, orders);
	}

	@Transactional(readOnly = true)
	public List<Product> findList(Product.RankingType rankingType, Store store, Integer count) {
		return productDao.findList(rankingType, store, count);
	}

	@Transactional(readOnly = true)
	public Page<Product> findPage(Product.Type type, Store store, ProductCategory productCategory, StoreProductCategory storeProductCategory, Brand brand, Promotion promotion, ProductTag productTag, StoreProductTag storeProductTag, Map<Attribute, String> attributeValueMap, BigDecimal startPrice,
			BigDecimal endPrice, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert, Boolean hasPromotion, Product.OrderType orderType, Pageable pageable) {
		return productDao.findPage(type, store, productCategory, storeProductCategory, brand, promotion, productTag, storeProductTag, attributeValueMap, startPrice, endPrice, isMarketable, isList, isTop, isActive, isOutOfStock, isStockAlert, hasPromotion, orderType, pageable);
	}

	@Transactional(readOnly = true)
	public Long count(Product.Type type, Store store, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert) {
		return productDao.count(type, store, isMarketable, isList, isTop, isActive, isOutOfStock, isStockAlert);
	}

	public long viewHits(Long id) {
		Assert.notNull(id);

		Ehcache cache = cacheManager.getEhcache(Product.HITS_CACHE_NAME);
		cache.acquireWriteLockOnKey(id);
		try {
			Element element = cache.get(id);
			Long hits;
			if (element != null) {
				hits = (Long) element.getObjectValue() + 1;
			} else {
				Product product = productDao.find(id);
				if (product == null) {
					return 0L;
				}
				hits = product.getHits() + 1;
			}
			cache.put(new Element(id, hits));
			return hits;
		} finally {
			cache.releaseWriteLockOnKey(id);
		}
	}

	public void addHits(Product product, long amount) {
		Assert.notNull(product);
		Assert.state(amount >= 0);

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(productDao.getLockMode(product))) {
			productDao.flush();
			productDao.refresh(product, LockModeType.PESSIMISTIC_WRITE);
		}

		Calendar nowCalendar = Calendar.getInstance();
		Calendar weekHitsCalendar = DateUtils.toCalendar(product.getWeekHitsDate());
		Calendar monthHitsCalendar = DateUtils.toCalendar(product.getMonthHitsDate());
		if (nowCalendar.get(Calendar.YEAR) > weekHitsCalendar.get(Calendar.YEAR) || nowCalendar.get(Calendar.WEEK_OF_YEAR) > weekHitsCalendar.get(Calendar.WEEK_OF_YEAR)) {
			product.setWeekHits(amount);
		} else {
			product.setWeekHits(product.getWeekHits() + amount);
		}
		if (nowCalendar.get(Calendar.YEAR) > monthHitsCalendar.get(Calendar.YEAR) || nowCalendar.get(Calendar.MONTH) > monthHitsCalendar.get(Calendar.MONTH)) {
			product.setMonthHits(amount);
		} else {
			product.setMonthHits(product.getMonthHits() + amount);
		}
		product.setHits(product.getHits() + amount);
		product.setWeekHitsDate(new Date());
		product.setMonthHitsDate(new Date());
		productDao.flush();
	}

	public void addSales(Product product, long amount) {
		Assert.notNull(product);
		Assert.state(amount >= 0);

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(productDao.getLockMode(product))) {
			productDao.flush();
			productDao.refresh(product, LockModeType.PESSIMISTIC_WRITE);
		}

		Calendar nowCalendar = Calendar.getInstance();
		Calendar weekSalesCalendar = DateUtils.toCalendar(product.getWeekSalesDate());
		Calendar monthSalesCalendar = DateUtils.toCalendar(product.getMonthSalesDate());
		if (nowCalendar.get(Calendar.YEAR) > weekSalesCalendar.get(Calendar.YEAR) || nowCalendar.get(Calendar.WEEK_OF_YEAR) > weekSalesCalendar.get(Calendar.WEEK_OF_YEAR)) {
			product.setWeekSales(amount);
		} else {
			product.setWeekSales(product.getWeekSales() + amount);
		}
		if (nowCalendar.get(Calendar.YEAR) > monthSalesCalendar.get(Calendar.YEAR) || nowCalendar.get(Calendar.MONTH) > monthSalesCalendar.get(Calendar.MONTH)) {
			product.setMonthSales(amount);
		} else {
			product.setMonthSales(product.getMonthSales() + amount);
		}
		product.setSales(product.getSales() + amount);
		product.setWeekSalesDate(new Date());
		product.setMonthSalesDate(new Date());
		productDao.flush();
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product create(Product product, Sku sku) {
		Assert.notNull(product);
		Assert.isTrue(product.isNew());
		Assert.notNull(product.getType());
		Assert.isTrue(!product.hasSpecification());
		Assert.notNull(sku);
		Assert.isTrue(sku.isNew());
		Assert.state(!sku.hasSpecification());

		switch (product.getType()) {
		case general:
			sku.setExchangePoint(0L);
			break;
		case exchange:
			sku.setPrice(BigDecimal.ZERO);
			sku.setRewardPoint(0L);
			product.setPromotions(null);
			break;
		case gift:
			sku.setPrice(BigDecimal.ZERO);
			sku.setRewardPoint(0L);
			sku.setExchangePoint(0L);
			product.setPromotions(null);
			break;
		}
		if (sku.getMarketPrice() == null) {
			sku.setMarketPrice(calculateDefaultMarketPrice(sku.getPrice()));
		}
		if (sku.getRewardPoint() == null) {
			sku.setRewardPoint(calculateDefaultRewardPoint(sku.getPrice()));
		} else {
			long maxRewardPoint = calculateMaxRewardPoint(sku.getPrice());
			sku.setRewardPoint(sku.getRewardPoint() > maxRewardPoint ? maxRewardPoint : sku.getRewardPoint());
		}
		sku.setAllocatedStock(0);
		sku.setIsDefault(true);
		sku.setProduct(product);
		sku.setSpecificationValues(null);
		sku.setCartItems(null);
		sku.setOrderItems(null);
		sku.setOrderShippingItems(null);
		sku.setProductNotifies(null);
		sku.setStockLogs(null);
		sku.setGiftPromotions(null);

		product.setPrice(sku.getPrice());
		product.setCost(sku.getCost());
		product.setMarketPrice(sku.getMarketPrice());
		product.setIsActive(true);
		product.setScore(0F);
		product.setTotalScore(0L);
		product.setScoreCount(0L);
		product.setHits(0L);
		product.setWeekHits(0L);
		product.setMonthHits(0L);
		product.setSales(0L);
		product.setWeekSales(0L);
		product.setMonthSales(0L);
		product.setWeekHitsDate(new Date());
		product.setMonthHitsDate(new Date());
		product.setWeekSalesDate(new Date());
		product.setMonthSalesDate(new Date());
		product.setSpecificationItems(null);
		product.setReviews(null);
		product.setConsultations(null);
		product.setProductFavorites(null);
		product.setSkus(null);
		setValue(product);
		productDao.persist(product);

		setValue(sku);
		skuDao.persist(sku);
		stockIn(sku);

		return product;
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product create(Product product, List<Sku> skus) {
		Assert.notNull(product);
		Assert.isTrue(product.isNew());
		Assert.notNull(product.getType());
		Assert.isTrue(product.hasSpecification());
		Assert.notEmpty(skus);

		final List<SpecificationItem> specificationItems = product.getSpecificationItems();
		if (CollectionUtils.exists(skus, new Predicate() {
			private Set<List<Integer>> set = new HashSet<>();

			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku == null || !sku.isNew() || !sku.hasSpecification() || !set.add(sku.getSpecificationValueIds()) || !specificationValueService.isValid(specificationItems, sku.getSpecificationValues());
			}
		})) {
			throw new IllegalArgumentException();
		}

		Sku defaultSku = (Sku) CollectionUtils.find(skus, new Predicate() {
			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku != null && sku.getIsDefault();
			}
		});
		if (defaultSku == null) {
			defaultSku = skus.get(0);
			defaultSku.setIsDefault(true);
		}

		for (Sku sku : skus) {
			switch (product.getType()) {
			case general:
				sku.setExchangePoint(0L);
				break;
			case exchange:
				sku.setPrice(BigDecimal.ZERO);
				sku.setRewardPoint(0L);
				product.setPromotions(null);
				break;
			case gift:
				sku.setPrice(BigDecimal.ZERO);
				sku.setRewardPoint(0L);
				sku.setExchangePoint(0L);
				product.setPromotions(null);
				break;
			}
			if (sku.getMarketPrice() == null) {
				sku.setMarketPrice(calculateDefaultMarketPrice(sku.getPrice()));
			}
			if (sku.getRewardPoint() == null) {
				sku.setRewardPoint(calculateDefaultRewardPoint(sku.getPrice()));
			} else {
				long maxRewardPoint = calculateMaxRewardPoint(sku.getPrice());
				sku.setRewardPoint(sku.getRewardPoint() > maxRewardPoint ? maxRewardPoint : sku.getRewardPoint());
			}
			if (sku != defaultSku) {
				sku.setIsDefault(false);
			}
			sku.setAllocatedStock(0);
			sku.setProduct(product);
			sku.setCartItems(null);
			sku.setOrderItems(null);
			sku.setOrderShippingItems(null);
			sku.setProductNotifies(null);
			sku.setStockLogs(null);
			sku.setGiftPromotions(null);
		}

		product.setPrice(defaultSku.getPrice());
		product.setCost(defaultSku.getCost());
		product.setMarketPrice(defaultSku.getMarketPrice());
		product.setIsActive(true);
		product.setScore(0F);
		product.setTotalScore(0L);
		product.setScoreCount(0L);
		product.setHits(0L);
		product.setWeekHits(0L);
		product.setMonthHits(0L);
		product.setSales(0L);
		product.setWeekSales(0L);
		product.setMonthSales(0L);
		product.setWeekHitsDate(new Date());
		product.setMonthHitsDate(new Date());
		product.setWeekSalesDate(new Date());
		product.setMonthSalesDate(new Date());
		product.setReviews(null);
		product.setConsultations(null);
		product.setProductFavorites(null);
		product.setSkus(null);
		setValue(product);
		productDao.persist(product);

		for (Sku sku : skus) {
			setValue(sku);
			skuDao.persist(sku);
			stockIn(sku);
		}

		return product;
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product modify(Product product, Sku sku) {
		Assert.notNull(product);
		Assert.isTrue(!product.isNew());
		Assert.isTrue(!product.hasSpecification());
		Assert.notNull(sku);
		Assert.isTrue(sku.isNew());
		Assert.state(!sku.hasSpecification());

		Product pProduct = productDao.find(product.getId());
		switch (pProduct.getType()) {
		case general:
			sku.setExchangePoint(0L);
			break;
		case exchange:
			sku.setPrice(BigDecimal.ZERO);
			sku.setRewardPoint(0L);
			product.setPromotions(null);
			break;
		case gift:
			sku.setPrice(BigDecimal.ZERO);
			sku.setRewardPoint(0L);
			sku.setExchangePoint(0L);
			product.setPromotions(null);
			break;
		}
		if (sku.getMarketPrice() == null) {
			sku.setMarketPrice(calculateDefaultMarketPrice(sku.getPrice()));
		}
		if (sku.getRewardPoint() == null) {
			sku.setRewardPoint(calculateDefaultRewardPoint(sku.getPrice()));
		} else {
			long maxRewardPoint = calculateMaxRewardPoint(sku.getPrice());
			sku.setRewardPoint(sku.getRewardPoint() > maxRewardPoint ? maxRewardPoint : sku.getRewardPoint());
		}
		sku.setAllocatedStock(0);
		sku.setIsDefault(true);
		sku.setProduct(pProduct);
		sku.setSpecificationValues(null);
		sku.setCartItems(null);
		sku.setOrderItems(null);
		sku.setOrderShippingItems(null);
		sku.setProductNotifies(null);
		sku.setStockLogs(null);
		sku.setGiftPromotions(null);

		if (pProduct.hasSpecification()) {
			for (Sku pSku : pProduct.getSkus()) {
				skuDao.remove(pSku);
			}
			if (sku.getStock() == null) {
				throw new IllegalArgumentException();
			}
			setValue(sku);
			skuDao.persist(sku);
			stockIn(sku);
		} else {
			Sku defaultSku = pProduct.getDefaultSku();
			defaultSku.setPrice(sku.getPrice());
			defaultSku.setCost(sku.getCost());
			defaultSku.setMarketPrice(sku.getMarketPrice());
			defaultSku.setRewardPoint(sku.getRewardPoint());
			defaultSku.setExchangePoint(sku.getExchangePoint());
		}

		product.setPrice(sku.getPrice());
		product.setCost(sku.getCost());
		product.setMarketPrice(sku.getMarketPrice());
		setValue(product);
		copyProperties(product, pProduct, "sn", "type", "score", "totalScore", "scoreCount", "hits", "weekHits", "monthHits", "sales", "weekSales", "monthSales", "weekHitsDate", "monthHitsDate", "weekSalesDate", "monthSalesDate", "reviews", "consultations", "productFavorites", "skus", "store");

		return pProduct;
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product modify(Product product, List<Sku> skus) {
		Assert.notNull(product);
		Assert.isTrue(!product.isNew());
		Assert.isTrue(product.hasSpecification());
		Assert.notEmpty(skus);

		final List<SpecificationItem> specificationItems = product.getSpecificationItems();
		if (CollectionUtils.exists(skus, new Predicate() {
			private Set<List<Integer>> set = new HashSet<>();

			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku == null || !sku.isNew() || !sku.hasSpecification() || !set.add(sku.getSpecificationValueIds()) || !specificationValueService.isValid(specificationItems, sku.getSpecificationValues());
			}
		})) {
			throw new IllegalArgumentException();
		}

		Sku defaultSku = (Sku) CollectionUtils.find(skus, new Predicate() {
			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku != null && sku.getIsDefault();
			}
		});
		if (defaultSku == null) {
			defaultSku = skus.get(0);
			defaultSku.setIsDefault(true);
		}

		Product pProduct = productDao.find(product.getId());
		for (Sku sku : skus) {
			switch (pProduct.getType()) {
			case general:
				sku.setExchangePoint(0L);
				break;
			case exchange:
				sku.setPrice(BigDecimal.ZERO);
				sku.setRewardPoint(0L);
				product.setPromotions(null);
				break;
			case gift:
				sku.setPrice(BigDecimal.ZERO);
				sku.setRewardPoint(0L);
				sku.setExchangePoint(0L);
				product.setPromotions(null);
				break;
			}
			if (sku.getMarketPrice() == null) {
				sku.setMarketPrice(calculateDefaultMarketPrice(sku.getPrice()));
			}
			if (sku.getRewardPoint() == null) {
				sku.setRewardPoint(calculateDefaultRewardPoint(sku.getPrice()));
			} else {
				long maxRewardPoint = calculateMaxRewardPoint(sku.getPrice());
				sku.setRewardPoint(sku.getRewardPoint() > maxRewardPoint ? maxRewardPoint : sku.getRewardPoint());
			}
			if (sku != defaultSku) {
				sku.setIsDefault(false);
			}
			sku.setAllocatedStock(0);
			sku.setProduct(pProduct);
			sku.setCartItems(null);
			sku.setOrderItems(null);
			sku.setOrderShippingItems(null);
			sku.setProductNotifies(null);
			sku.setStockLogs(null);
			sku.setGiftPromotions(null);
		}

		if (pProduct.hasSpecification()) {
			for (Sku pSku : pProduct.getSkus()) {
				if (!exists(skus, pSku.getSpecificationValueIds())) {
					skuDao.remove(pSku);
				}
			}
			for (Sku sku : skus) {
				Sku pSku = find(pProduct.getSkus(), sku.getSpecificationValueIds());
				if (pSku != null) {
					pSku.setPrice(sku.getPrice());
					pSku.setCost(sku.getCost());
					pSku.setMarketPrice(sku.getMarketPrice());
					pSku.setRewardPoint(sku.getRewardPoint());
					pSku.setExchangePoint(sku.getExchangePoint());
					pSku.setIsDefault(sku.getIsDefault());
					pSku.setSpecificationValues(sku.getSpecificationValues());
				} else {
					if (sku.getStock() == null) {
						throw new IllegalArgumentException();
					}
					setValue(sku);
					skuDao.persist(sku);
					stockIn(sku);
				}
			}
		} else {
			skuDao.remove(pProduct.getDefaultSku());
			for (Sku sku : skus) {
				if (sku.getStock() == null) {
					throw new IllegalArgumentException();
				}
				setValue(sku);
				skuDao.persist(sku);
				stockIn(sku);
			}
		}

		product.setPrice(defaultSku.getPrice());
		product.setCost(defaultSku.getCost());
		product.setMarketPrice(defaultSku.getMarketPrice());
		setValue(product);
		copyProperties(product, pProduct, "sn", "type", "score", "totalScore", "scoreCount", "hits", "weekHits", "monthHits", "sales", "weekSales", "monthSales", "weekHitsDate", "monthHitsDate", "weekSalesDate", "monthSalesDate", "reviews", "consultations", "productFavorites", "skus", "store");

		return pProduct;
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void refreshExpiredStoreProductActive() {
		productDao.refreshExpiredStoreProductActive();
	}

	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void refreshActive(Store store) {
		Assert.notNull(store);

		productDao.refreshActive(store);
	}

	@Override
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void shelves(Long[] ids) {
		productDao.shelves(ids);
	}

	@Override
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void shelf(Long[] ids) {
		productDao.shelf(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product save(Product product) {
		return super.save(product);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product update(Product product) {
		return super.update(product);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public Product update(Product product, String... ignoreProperties) {
		return super.update(product, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void delete(Product product) {
		super.delete(product);
	}

	/**
	 * 设置商品值
	 * 
	 * @param product
	 *            商品
	 */
	private void setValue(Product product) {
		if (product == null) {
			return;
		}

		if (StringUtils.isEmpty(product.getImage()) && StringUtils.isNotEmpty(product.getThumbnail())) {
			product.setImage(product.getThumbnail());
		}
		if (product.isNew()) {
			if (StringUtils.isEmpty(product.getSn())) {
				String sn;
				do {
					sn = snDao.generate(Sn.Type.product);
				} while (snExists(sn));
				product.setSn(sn);
			}
		}
	}

	/**
	 * 设置SKU值
	 * 
	 * @param sku
	 *            SKU
	 */
	private void setValue(Sku sku) {
		if (sku == null) {
			return;
		}

		if (sku.isNew()) {
			Product product = sku.getProduct();
			if (product != null && StringUtils.isNotEmpty(product.getSn())) {
				String sn;
				int i = sku.hasSpecification() ? 1 : 0;
				do {
					sn = product.getSn() + (i == 0 ? "" : "_" + i);
					i++;
				} while (skuDao.exists("sn", sn, true));
				sku.setSn(sn);
			}
		}
	}

	/**
	 * 计算默认市场价
	 * 
	 * @param price
	 *            价格
	 * @return 默认市场价
	 */
	private BigDecimal calculateDefaultMarketPrice(BigDecimal price) {
		Assert.notNull(price);

		Setting setting = SystemUtils.getSetting();
		Double defaultMarketPriceScale = setting.getDefaultMarketPriceScale();
		return defaultMarketPriceScale != null ? setting.setScale(price.multiply(new BigDecimal(String.valueOf(defaultMarketPriceScale)))) : BigDecimal.ZERO;
	}

	/**
	 * 计算默认赠送积分
	 * 
	 * @param price
	 *            价格
	 * @return 默认赠送积分
	 */
	private long calculateDefaultRewardPoint(BigDecimal price) {
		Assert.notNull(price);

		Setting setting = SystemUtils.getSetting();
		Double defaultPointScale = setting.getDefaultPointScale();
		return defaultPointScale != null ? price.multiply(new BigDecimal(String.valueOf(defaultPointScale))).longValue() : 0L;
	}

	/**
	 * 计算最大赠送积分
	 * 
	 * @param price
	 *            价格
	 * @return 最大赠送积分
	 */
	private long calculateMaxRewardPoint(BigDecimal price) {
		Assert.notNull(price);

		Setting setting = SystemUtils.getSetting();
		Double maxPointScale = setting.getMaxPointScale();
		return maxPointScale != null ? price.multiply(new BigDecimal(String.valueOf(maxPointScale))).longValue() : 0L;
	}

	/**
	 * 根据规格值ID查找SKU
	 * 
	 * @param skus
	 *            SKU
	 * @param specificationValueIds
	 *            规格值ID
	 * @return SKU
	 */
	private Sku find(Collection<Sku> skus, final List<Integer> specificationValueIds) {
		if (CollectionUtils.isEmpty(skus) || CollectionUtils.isEmpty(specificationValueIds)) {
			return null;
		}

		return (Sku) CollectionUtils.find(skus, new Predicate() {
			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku != null && sku.getSpecificationValueIds() != null && sku.getSpecificationValueIds().equals(specificationValueIds);
			}
		});
	}

	/**
	 * 根据规格值ID判断SKU是否存在
	 * 
	 * @param skus
	 *            SKU
	 * @param specificationValueIds
	 *            规格值ID
	 * @return SKU是否存在
	 */
	private boolean exists(Collection<Sku> skus, final List<Integer> specificationValueIds) {
		return find(skus, specificationValueIds) != null;
	}

	/**
	 * 入库
	 * 
	 * @param sku
	 *            SKU
	 */
	private void stockIn(Sku sku) {
		if (sku == null || sku.getStock() == null || sku.getStock() <= 0) {
			return;
		}

		StockLog stockLog = new StockLog();
		stockLog.setType(StockLog.Type.stockIn);
		stockLog.setInQuantity(sku.getStock());
		stockLog.setOutQuantity(0);
		stockLog.setStock(sku.getStock());
		stockLog.setMemo(null);
		stockLog.setSku(sku);
		stockLogDao.persist(stockLog);
	}

}