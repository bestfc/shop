/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Attribute;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Brand;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.ProductTag;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductCategory;
import net.shopxx.exception.ResourceNotFoundException;
import net.shopxx.service.AttributeService;
import net.shopxx.service.BrandService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.ProductService;
import net.shopxx.service.ProductTagService;
import net.shopxx.service.PromotionService;
import net.shopxx.service.SearchService;
import net.shopxx.service.StoreProductCategoryService;
import net.shopxx.service.StoreService;

/**
 * Controller商品
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopProductController")
@RequestMapping("/product")
public class ProductController extends BaseController {

	/**
	 * 最大对比商品数
	 */
	public static final Integer MAX_COMPARE_PRODUCT_COUNT = 4;

	/**
	 * 最大浏览记录商品数
	 */
	public static final Integer MAX_HISTORY_PRODUCT_COUNT = 10;

	@Inject
	private ProductService productService;
	@Inject
	private StoreService storeService;
	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private StoreProductCategoryService storeProductCategoryService;
	@Inject
	private BrandService brandService;
	@Inject
	private PromotionService promotionService;
	@Inject
	private ProductTagService productTagService;
	@Inject
	private AttributeService attributeService;
	@Inject
	private SearchService searchService;

	/**
	 * 详情
	 */
	@GetMapping("/detail/{productId}")
	public String detail(@PathVariable Long productId, ModelMap model) {
		Product product = productService.find(productId);
		if (product == null || BooleanUtils.isNotTrue(product.getIsActive()) || BooleanUtils.isNotTrue(product.getIsMarketable())) {
			throw new ResourceNotFoundException();
		}
		model.addAttribute("product", product);
		return "shop/product/detail";
	}

	/**
	 * 对比栏
	 */
	@GetMapping("/compare_bar")
	public ResponseEntity<?> compareBar(Long[] productIds) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (ArrayUtils.isEmpty(productIds) || productIds.length > MAX_COMPARE_PRODUCT_COUNT) {
			return ResponseEntity.ok(data);
		}

		List<Product> products = productService.findList(productIds);
		for (Product product : products) {
			if (product != null && BooleanUtils.isTrue(product.getIsActive()) && BooleanUtils.isTrue(product.getIsMarketable())) {
				Map<String, Object> item = new HashMap<>();
				item.put("id", product.getId());
				item.put("name", product.getName());
				item.put("price", product.getPrice());
				item.put("marketPrice", product.getMarketPrice());
				item.put("thumbnail", product.getThumbnail());
				item.put("path", product.getPath());
				data.add(item);
			}
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 添加对比
	 */
	@GetMapping("/add_compare")
	public ResponseEntity<?> addCompare(Long productId) {
		Map<String, Object> data = new HashMap<>();
		Product product = productService.find(productId);
		if (product == null || BooleanUtils.isNotTrue(product.getIsActive()) || BooleanUtils.isNotTrue(product.getIsMarketable())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		data.put("id", product.getId());
		data.put("name", product.getName());
		data.put("price", product.getPrice());
		data.put("marketPrice", product.getMarketPrice());
		data.put("thumbnail", product.getThumbnail());
		data.put("path", product.getPath());
		return ResponseEntity.ok(data);
	}

	/**
	 * 浏览记录
	 */
	@GetMapping("/history")
	public ResponseEntity<?> history(Long[] productIds) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (ArrayUtils.isEmpty(productIds) || productIds.length > MAX_HISTORY_PRODUCT_COUNT) {
			return ResponseEntity.ok(data);
		}

		List<Product> products = productService.findList(productIds);
		for (Product product : products) {
			if (product != null && BooleanUtils.isTrue(product.getIsActive()) && BooleanUtils.isTrue(product.getIsMarketable())) {
				Map<String, Object> item = new HashMap<>();
				item.put("name", product.getName());
				item.put("price", product.getPrice());
				item.put("thumbnail", product.getThumbnail());
				item.put("path", product.getPath());
				data.add(item);
			}
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list/{productCategoryId}")
	public String list(@PathVariable Long productCategoryId, Product.Type type, Long brandId, Long promotionId, Long productTagId, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Integer pageNumber, Integer pageSize, HttpServletRequest request, ModelMap model) {
		ProductCategory productCategory = productCategoryService.find(productCategoryId);
		if (productCategory == null) {
			throw new ResourceNotFoundException();
		}

		Brand brand = brandService.find(brandId);
		Promotion promotion = promotionService.find(promotionId);
		ProductTag productTag = productTagService.find(productTagId);
		Map<Attribute, String> attributeValueMap = new HashMap<>();
		Set<Attribute> attributes = productCategory.getAttributes();
		if (CollectionUtils.isNotEmpty(attributes)) {
			for (Attribute attribute : attributes) {
				String value = request.getParameter("attribute_" + attribute.getId());
				String attributeValue = attributeService.toAttributeValue(attribute, value);
				if (attributeValue != null) {
					attributeValueMap.put(attribute, attributeValue);
				}
			}
		}

		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal tempPrice = startPrice;
			startPrice = endPrice;
			endPrice = tempPrice;
		}

		Pageable pageable = new Pageable(pageNumber, pageSize);
		model.addAttribute("orderTypes", Product.OrderType.values());
		model.addAttribute("productCategory", productCategory);
		model.addAttribute("type", type);
		model.addAttribute("brand", brand);
		model.addAttribute("promotion", promotion);
		model.addAttribute("productTag", productTag);
		model.addAttribute("attributeValueMap", attributeValueMap);
		model.addAttribute("startPrice", startPrice);
		model.addAttribute("endPrice", endPrice);
		model.addAttribute("orderType", orderType);
		model.addAttribute("pageNumber", pageNumber);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("page", productService.findPage(type, null, productCategory, null, brand, promotion, productTag, null, attributeValueMap, startPrice, endPrice, true, true, null, true, null, null, null, orderType, pageable));
		return "shop/product/list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Product.Type type, Long storeProductCategoryId, Long brandId, Long promotionId, Long productTagId, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Integer pageNumber, Integer pageSize, ModelMap model) {
		StoreProductCategory storeProductCategory = storeProductCategoryService.find(storeProductCategoryId);
		Brand brand = brandService.find(brandId);
		Promotion promotion = promotionService.find(promotionId);
		ProductTag productTag = productTagService.find(productTagId);

		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal tempPrice = startPrice;
			startPrice = endPrice;
			endPrice = tempPrice;
		}

		Pageable pageable = new Pageable(pageNumber, pageSize);
		model.addAttribute("orderTypes", Product.OrderType.values());
		model.addAttribute("type", type);
		model.addAttribute("storeProductCategory", storeProductCategory);
		model.addAttribute("brand", brand);
		model.addAttribute("promotion", promotion);
		model.addAttribute("productTag", productTag);
		model.addAttribute("startPrice", startPrice);
		model.addAttribute("endPrice", endPrice);
		model.addAttribute("orderType", orderType);
		model.addAttribute("pageNumber", pageNumber);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("page", productService.findPage(type, null, null, storeProductCategory, brand, promotion, productTag, null, null, startPrice, endPrice, true, true, null, true, null, null, null, orderType, pageable));
		return "shop/product/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Long productCategoryId, Product.Type type, Long storeProductCategoryId, Long brandId, Long promotionId, Long productTagId, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Integer pageNumber, Integer pageSize, HttpServletRequest request) {
		ProductCategory productCategory = productCategoryService.find(productCategoryId);
		StoreProductCategory storeProductCategory = storeProductCategoryService.find(storeProductCategoryId);
		Brand brand = brandService.find(brandId);
		Promotion promotion = promotionService.find(promotionId);
		ProductTag productTag = productTagService.find(productTagId);
		Map<Attribute, String> attributeValueMap = new HashMap<>();
		if (productCategory != null) {
			Set<Attribute> attributes = productCategory.getAttributes();
			if (CollectionUtils.isNotEmpty(attributes)) {
				for (Attribute attribute : attributes) {
					String value = request.getParameter("attribute_" + attribute.getId());
					String attributeValue = attributeService.toAttributeValue(attribute, value);
					if (attributeValue != null) {
						attributeValueMap.put(attribute, attributeValue);
					}
				}
			}
		}

		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal tempPrice = startPrice;
			startPrice = endPrice;
			endPrice = tempPrice;
		}

		Pageable pageable = new Pageable(pageNumber, pageSize);
		return ResponseEntity.ok(productService.findPage(type, null, productCategory, storeProductCategory, brand, promotion, productTag, null, attributeValueMap, startPrice, endPrice, true, true, null, true, null, null, null, orderType, pageable).getContent());
	}

	/**
	 * 搜索
	 */
	@GetMapping("/search")
	public String search(String keyword, Long storeId, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Integer pageNumber, Integer pageSize, ModelMap model) {
		if (StringUtils.isEmpty(keyword)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal tempPrice = startPrice;
			startPrice = endPrice;
			endPrice = tempPrice;
		}
		Store store = storeService.find(storeId);

		Pageable pageable = new Pageable(pageNumber, pageSize);
		model.addAttribute("orderTypes", Product.OrderType.values());
		model.addAttribute("productKeyword", keyword);
		model.addAttribute("store", store);
		model.addAttribute("startPrice", startPrice);
		model.addAttribute("endPrice", endPrice);
		model.addAttribute("orderType", orderType);
		model.addAttribute("page", searchService.search(keyword, store, startPrice, endPrice, orderType, pageable));
		model.addAttribute("stores", searchService.searchStore(keyword));
		return "shop/product/search";
	}

	/**
	 * 搜索
	 */
	@GetMapping(path = "/search", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> search(String keyword, Long storeId, BigDecimal startPrice, BigDecimal endPrice, Product.OrderType orderType, Integer pageNumber, Integer pageSize) {
		if (StringUtils.isEmpty(keyword)) {
			return ResponseEntity.notFound().build();
		}

		if (startPrice != null && endPrice != null && startPrice.compareTo(endPrice) > 0) {
			BigDecimal tempPrice = startPrice;
			startPrice = endPrice;
			endPrice = tempPrice;
		}
		Store store = storeService.find(storeId);

		Pageable pageable = new Pageable(pageNumber, pageSize);
		return ResponseEntity.ok(searchService.search(keyword, store, startPrice, endPrice, orderType, pageable).getContent());
	}

	/**
	 * 对比
	 */
	@GetMapping("/compare")
	public String compare(Long[] productIds, ModelMap model) {
		if (ArrayUtils.isEmpty(productIds) || productIds.length > MAX_COMPARE_PRODUCT_COUNT) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<Product> products = productService.findList(productIds);
		CollectionUtils.filter(products, new Predicate() {
			@Override
			public boolean evaluate(Object obj) {
				Product product = (Product) obj;
				return BooleanUtils.isTrue(product.getIsActive()) && BooleanUtils.isTrue(product.getIsMarketable());
			}
		});
		if (CollectionUtils.isEmpty(products)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("products", products);
		return "shop/product/compare";
	}

	/**
	 * 点击数
	 */
	@GetMapping("/hits/{productId}")
	public @ResponseBody Long hits(@PathVariable Long productId) {
		if (productId == null) {
			return 0L;
		}

		return productService.viewHits(productId);
	}

}