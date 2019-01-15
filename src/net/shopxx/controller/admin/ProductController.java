/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.Brand;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.ProductTag;
import net.shopxx.service.BrandService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.ProductService;
import net.shopxx.service.ProductTagService;

/**
 * Controller商品
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminProductController")
@RequestMapping("/admin/product")
public class ProductController extends BaseController {

	@Inject
	private ProductService productService;
	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private BrandService brandService;
	@Inject
	private ProductTagService productTagService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Product.Type type, Long productCategoryId, Long brandId, Long productTagId, Boolean isActive, Boolean isMarketable, Boolean isList, Boolean isTop, Boolean isOutOfStock, Boolean isStockAlert, Pageable pageable, ModelMap model) {
		ProductCategory productCategory = productCategoryService.find(productCategoryId);
		Brand brand = brandService.find(brandId);
		ProductTag productTag = productTagService.find(productTagId);

		model.addAttribute("types", Product.Type.values());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("brands", brandService.findAll());
		model.addAttribute("productTags", productTagService.findAll());
		model.addAttribute("type", type);
		model.addAttribute("productCategoryId", productCategoryId);
		model.addAttribute("brandId", brandId);
		model.addAttribute("productTagId", productTagId);
		model.addAttribute("isMarketable", isMarketable);
		model.addAttribute("isList", isList);
		model.addAttribute("isTop", isTop);
		model.addAttribute("isActive", isActive);
		model.addAttribute("isOutOfStock", isOutOfStock);
		model.addAttribute("isStockAlert", isStockAlert);
		model.addAttribute("page", productService.findPage(type, null, productCategory, null, brand, null, productTag, null, null, null, null, isMarketable, isList, isTop, isActive, isOutOfStock, isStockAlert, null, null, pageable));
		return "admin/product/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		productService.delete(ids);
		return SUCCESS_MESSAGE;
	}

	/**
	 * 上架商品
	 */
	@PostMapping("/shelves")
	public @ResponseBody Message shelves(Long[] ids) {
		if (ids != null) {
			for (Long id : ids) {
				Product product = productService.find(id);
				if (product == null) {
					return ERROR_MESSAGE;
				}
				if (product.getStore().hasExpired() || !product.getStore().getIsEnabled() || !product.getStore().getProductCategories().contains(product.getProductCategory())) {
					return Message.error("admin.product.isShelvesSku", product.getName());
				}
			}
			productService.shelves(ids);
		}
		return SUCCESS_MESSAGE;
	}

	/**
	 * 下架商品
	 */
	@PostMapping("/shelf")
	public @ResponseBody Message shelf(Long[] ids) {
		productService.shelf(ids);
		return SUCCESS_MESSAGE;
	}
}