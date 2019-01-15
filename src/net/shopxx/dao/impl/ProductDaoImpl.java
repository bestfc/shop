/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao.impl;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.Setting;
import net.shopxx.dao.ProductDao;
import net.shopxx.entity.Attribute;
import net.shopxx.entity.Brand;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.ProductTag;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductCategory;
import net.shopxx.entity.StoreProductTag;
import net.shopxx.util.SystemUtils;

/**
 * Dao商品
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Repository
public class ProductDaoImpl extends BaseDaoImpl<Product, Long> implements ProductDao {

	public List<Product> findList(Product.Type type, Store store, ProductCategory productCategory, StoreProductCategory storeProductCategory, Brand brand, Promotion promotion, ProductTag productTag, StoreProductTag storeProductTag, Map<Attribute, String> attributeValueMap, BigDecimal startPrice,
			BigDecimal endPrice, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert, Boolean hasPromotion, Product.OrderType orderType, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Product> criteriaQuery = criteriaBuilder.createQuery(Product.class);
		Root<Product> root = criteriaQuery.from(Product.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (type != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		if (productCategory != null) {
			Subquery<ProductCategory> subquery = criteriaQuery.subquery(ProductCategory.class);
			Root<ProductCategory> subqueryRoot = subquery.from(ProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, productCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + ProductCategory.TREE_PATH_SEPARATOR + productCategory.getId() + ProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("productCategory")).value(subquery));
		}
		if (storeProductCategory != null) {
			Subquery<StoreProductCategory> subquery = criteriaQuery.subquery(StoreProductCategory.class);
			Root<StoreProductCategory> subqueryRoot = subquery.from(StoreProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, storeProductCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + StoreProductCategory.TREE_PATH_SEPARATOR + storeProductCategory.getId() + StoreProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("storeProductCategory")).value(subquery));
		}
		if (brand != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("brand"), brand));
		}
		if (promotion != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("promotions"), promotion));
		}
		if (productTag != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("productTags"), productTag));
		}
		if (storeProductTag != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("storeProductTags"), storeProductTag));
		}
		if (attributeValueMap != null) {
			for (Map.Entry<Attribute, String> entry : attributeValueMap.entrySet()) {
				String propertyName = Product.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + entry.getKey().getPropertyIndex();
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get(propertyName), entry.getValue()));
			}
		}
		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal temp = startPrice;
			startPrice = endPrice;
			endPrice = temp;
		}
		if (startPrice != null && startPrice.compareTo(BigDecimal.ZERO) >= 0) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.ge(root.<Number>get("price"), startPrice));
		}
		if (endPrice != null && endPrice.compareTo(BigDecimal.ZERO) >= 0) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.le(root.<Number>get("price"), endPrice));
		}
		if (isMarketable != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isMarketable"), isMarketable));
		}
		if (isList != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isList"), isList));
		}
		if (isTop != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isTop"), isTop));
		}
		if (isActive != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isActive"), isActive));
		}
		if (isOutOfStock != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			if (isOutOfStock) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, allocatedStock));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, allocatedStock));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		if (isStockAlert != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			Setting setting = SystemUtils.getSetting();
			if (isStockAlert) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		if (hasPromotion != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.isNotNull(root.join("promotions")));
		}
		criteriaQuery.where(restrictions);
		if (orderType != null) {
			switch (orderType) {
			case topDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("isTop")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case priceAsc:
				criteriaQuery.orderBy(criteriaBuilder.asc(root.get("price")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case priceDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("price")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case salesDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("sales")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case scoreDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("score")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case dateDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("createdDate")));
				break;
			}
		} else if (CollectionUtils.isEmpty(orders)) {
			criteriaQuery.orderBy(criteriaBuilder.desc(root.get("isTop")), criteriaBuilder.desc(root.get("createdDate")));
		}
		return super.findList(criteriaQuery, null, count, filters, orders);
	}

	public List<Product> findList(ProductCategory productCategory, StoreProductCategory storeProductCategory, Boolean isMarketable, Boolean isActive, Date beginDate, Date endDate, Integer first, Integer count) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Product> criteriaQuery = criteriaBuilder.createQuery(Product.class);
		Root<Product> root = criteriaQuery.from(Product.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (productCategory != null) {
			Subquery<ProductCategory> subquery = criteriaQuery.subquery(ProductCategory.class);
			Root<ProductCategory> subqueryRoot = subquery.from(ProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, productCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + ProductCategory.TREE_PATH_SEPARATOR + productCategory.getId() + ProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("productCategory")).value(subquery));
		}
		if (storeProductCategory != null) {
			Subquery<StoreProductCategory> subquery = criteriaQuery.subquery(StoreProductCategory.class);
			Root<StoreProductCategory> subqueryRoot = subquery.from(StoreProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, storeProductCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + StoreProductCategory.TREE_PATH_SEPARATOR + storeProductCategory.getId() + StoreProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("storeProductCategory")).value(subquery));
		}
		if (isMarketable != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isMarketable"), isMarketable));
		}
		if (isActive != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isActive"), isActive));
		}
		if (beginDate != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.greaterThanOrEqualTo(root.<Date>get("createdDate"), beginDate));
		}
		if (endDate != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.lessThanOrEqualTo(root.<Date>get("createdDate"), endDate));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery, first, count);
	}

	public List<Product> findList(Product.RankingType rankingType, Store store, Integer count) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Product> criteriaQuery = criteriaBuilder.createQuery(Product.class);
		Root<Product> root = criteriaQuery.from(Product.class);
		criteriaQuery.select(root);
		if (rankingType != null) {
			switch (rankingType) {
			case score:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("score")), criteriaBuilder.desc(root.get("scoreCount")));
				break;
			case scoreCount:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("scoreCount")), criteriaBuilder.desc(root.get("score")));
				break;
			case weekHits:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("weekHits")));
				break;
			case monthHits:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("monthHits")));
				break;
			case hits:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("hits")));
				break;
			case weekSales:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("weekSales")));
				break;
			case monthSales:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("monthSales")));
				break;
			case sales:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("sales")));
				break;
			}
		}
		if (store != null) {
			criteriaQuery.where(criteriaBuilder.equal(root.get("store"), store));
		}
		return super.findList(criteriaQuery, null, count);
	}

	public Page<Product> findPage(Product.Type type, Store store, ProductCategory productCategory, StoreProductCategory storeProductCategory, Brand brand, Promotion promotion, ProductTag productTag, StoreProductTag storeProductTag, Map<Attribute, String> attributeValueMap, BigDecimal startPrice,
			BigDecimal endPrice, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert, Boolean hasPromotion, Product.OrderType orderType, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Product> criteriaQuery = criteriaBuilder.createQuery(Product.class);
		Root<Product> root = criteriaQuery.from(Product.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (type != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		if (productCategory != null) {
			Subquery<ProductCategory> subquery = criteriaQuery.subquery(ProductCategory.class);
			Root<ProductCategory> subqueryRoot = subquery.from(ProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, productCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + ProductCategory.TREE_PATH_SEPARATOR + productCategory.getId() + ProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("productCategory")).value(subquery));
		}
		if (storeProductCategory != null) {
			Subquery<StoreProductCategory> subquery = criteriaQuery.subquery(StoreProductCategory.class);
			Root<StoreProductCategory> subqueryRoot = subquery.from(StoreProductCategory.class);
			subquery.select(subqueryRoot);
			subquery.where(criteriaBuilder.or(criteriaBuilder.equal(subqueryRoot, storeProductCategory), criteriaBuilder.like(subqueryRoot.<String>get("treePath"), "%" + StoreProductCategory.TREE_PATH_SEPARATOR + storeProductCategory.getId() + StoreProductCategory.TREE_PATH_SEPARATOR + "%")));
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.in(root.get("storeProductCategory")).value(subquery));
		}
		if (brand != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("brand"), brand));
		}
		if (promotion != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("promotions"), promotion));
		}
		if (productTag != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("productTags"), productTag));
		}
		if (storeProductTag != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.join("storeProductTags"), storeProductTag));
		}
		if (attributeValueMap != null) {
			for (Map.Entry<Attribute, String> entry : attributeValueMap.entrySet()) {
				String propertyName = Product.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + entry.getKey().getPropertyIndex();
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get(propertyName), entry.getValue()));
			}
		}
		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal temp = startPrice;
			startPrice = endPrice;
			endPrice = temp;
		}
		if (startPrice != null && startPrice.compareTo(BigDecimal.ZERO) >= 0) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.ge(root.<Number>get("price"), startPrice));
		}
		if (endPrice != null && endPrice.compareTo(BigDecimal.ZERO) >= 0) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.le(root.<Number>get("price"), endPrice));
		}
		if (isMarketable != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isMarketable"), isMarketable));
		}
		if (isList != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isList"), isList));
		}
		if (isTop != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isTop"), isTop));
		}
		if (isActive != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isActive"), isActive));
		}
		if (isOutOfStock != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			if (isOutOfStock) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, allocatedStock));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, allocatedStock));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		if (isStockAlert != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			Setting setting = SystemUtils.getSetting();
			if (isStockAlert) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		if (hasPromotion != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.isNotNull(root.join("promotions")));
		}
		criteriaQuery.where(restrictions);
		if (orderType != null) {
			switch (orderType) {
			case topDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("isTop")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case priceAsc:
				criteriaQuery.orderBy(criteriaBuilder.asc(root.get("price")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case priceDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("price")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case salesDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("sales")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case scoreDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("score")), criteriaBuilder.desc(root.get("createdDate")));
				break;
			case dateDesc:
				criteriaQuery.orderBy(criteriaBuilder.desc(root.get("createdDate")));
				break;
			}
		} else if (pageable == null || ((StringUtils.isEmpty(pageable.getOrderProperty()) || pageable.getOrderDirection() == null) && (CollectionUtils.isEmpty(pageable.getOrders())))) {
			criteriaQuery.orderBy(criteriaBuilder.desc(root.get("isTop")), criteriaBuilder.desc(root.get("createdDate")));
		}
		return super.findPage(criteriaQuery, pageable);
	}

	public Long count(Product.Type type, Store store, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isActive, Boolean isOutOfStock, Boolean isStockAlert) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Product> criteriaQuery = criteriaBuilder.createQuery(Product.class);
		Root<Product> root = criteriaQuery.from(Product.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (type != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		if (isMarketable != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isMarketable"), isMarketable));
		}
		if (isList != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isList"), isList));
		}
		if (isTop != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isTop"), isTop));
		}
		if (isActive != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("isActive"), isActive));
		}
		if (isOutOfStock != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			if (isOutOfStock) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, allocatedStock));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, allocatedStock));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		if (isStockAlert != null) {
			Subquery<Sku> subquery = criteriaQuery.subquery(Sku.class);
			Root<Sku> subqueryRoot = subquery.from(Sku.class);
			subquery.select(subqueryRoot);
			Path<Integer> stock = subqueryRoot.get("stock");
			Path<Integer> allocatedStock = subqueryRoot.get("allocatedStock");
			Setting setting = SystemUtils.getSetting();
			if (isStockAlert) {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.lessThanOrEqualTo(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			} else {
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("product"), root), criteriaBuilder.greaterThan(stock, criteriaBuilder.sum(allocatedStock, setting.getStockAlertCount())));
			}
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery));
		}
		criteriaQuery.where(restrictions);
		return super.count(criteriaQuery, null);
	}

	public void clearAttributeValue(Attribute attribute) {
		if (attribute == null || attribute.getPropertyIndex() == null || attribute.getProductCategory() == null) {
			return;
		}

		String jpql = "update Product product set product." + Product.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + attribute.getPropertyIndex() + " = null where product.productCategory = :productCategory";
		entityManager.createQuery(jpql).setParameter("productCategory", attribute.getProductCategory()).executeUpdate();
	}

	public void refreshExpiredStoreProductActive() {
		String jpql = "update Product product set product.isActive = false where product.isActive = true and product.store in (select store from Store store where store.endDate is null or store.endDate <= :now)";
		entityManager.createQuery(jpql).setParameter("now", new Date()).executeUpdate();
	}

	public void refreshActive(Store store) {
		Assert.notNull(store);

		setActive(store);
		setInactive(store);
	}

	/**
	 * 设置商品有效状态
	 * 
	 * @param store
	 *            店铺
	 */
	private void setActive(Store store) {
		Assert.notNull(store);

		String jpql = "update Product product set product.isActive = true where product.isActive = false and product.store = :store and product.store in (select store from Store store where store.isEnabled = true and store.status = :status and store.endDate is not null and store.endDate > :now) and product.productCategory in(select productCategory from ProductCategory productCategory join productCategory.stores productCategoryStore where productCategoryStore = product.store)";
		entityManager.createQuery(jpql).setParameter("store", store).setParameter("status", Store.Status.success).setParameter("now", new Date()).executeUpdate();
	}

	/**
	 * 设置商品无效状态
	 * 
	 * @param store
	 *            店铺
	 */
	private void setInactive(Store store) {
		Assert.notNull(store);

		String jpql = "update Product product set product.isActive = false where product.isActive = true and product.store = :store and product.store in (select store from Store store where store.isEnabled != true or store.status != :status or store.endDate is null or store.endDate <= :now) or product.productCategory not in(select productCategory from ProductCategory productCategory join productCategory.stores productCategoryStore where productCategoryStore = product.store)";
		entityManager.createQuery(jpql).setParameter("store", store).setParameter("status", Store.Status.success).setParameter("now", new Date()).executeUpdate();
	}

	@Override
	public void shelves(Long[] ids) {
		Assert.notEmpty(ids);

		String jpql = "update Product product set product.isMarketable = true where product.isMarketable = false and product.id in (:ids)";
		entityManager.createQuery(jpql).setParameter("ids", Arrays.asList(ids)).executeUpdate();
	}

	@Override
	public void shelf(Long[] ids) {
		Assert.notEmpty(ids);

		String jpql = "update Product product set product.isMarketable = false where product.isMarketable = true and product.id in (:ids)";
		entityManager.createQuery(jpql).setParameter("ids", Arrays.asList(ids)).executeUpdate();
	}

}