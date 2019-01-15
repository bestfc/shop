/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.service.BrandService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.PromotionService;

/**
 * Controller商品分类
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminProductCategoryController")
@RequestMapping("/admin/product_category")
public class ProductCategoryController extends BaseController {

	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private BrandService brandService;
	@Inject
	private PromotionService promotionService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("brands", brandService.findAll());
		model.addAttribute("promotions", promotionService.findAll());
		return "admin/product_category/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(ProductCategory productCategory, Long parentId, Long[] brandIds, Long[] promotionIds, RedirectAttributes redirectAttributes) {
		productCategory.setParent(productCategoryService.find(parentId));
		productCategory.setBrands(new HashSet<>(brandService.findList(brandIds)));
		productCategory.setPromotions(new HashSet<>(promotionService.findList(promotionIds)));
		if (!isValid(productCategory)) {
			return ERROR_VIEW;
		}
		productCategory.setTreePath(null);
		productCategory.setGrade(null);
		productCategory.setChildren(null);
		productCategory.setProducts(null);
		productCategory.setParameters(null);
		productCategory.setAttributes(null);
		productCategory.setSpecifications(null);
		productCategory.setStores(null);
		productCategory.setCategoryApplications(null);
		productCategoryService.save(productCategory);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		ProductCategory productCategory = productCategoryService.find(id);
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("brands", brandService.findAll());
		model.addAttribute("promotions", promotionService.findAll());
		model.addAttribute("productCategory", productCategory);
		model.addAttribute("children", productCategoryService.findChildren(productCategory, true, null));
		return "admin/product_category/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(ProductCategory productCategory, Long parentId, Long[] brandIds, Long[] promotionIds, RedirectAttributes redirectAttributes) {
		productCategory.setParent(productCategoryService.find(parentId));
		productCategory.setBrands(new HashSet<>(brandService.findList(brandIds)));
		productCategory.setPromotions(new HashSet<>(promotionService.findList(promotionIds)));
		if (!isValid(productCategory)) {
			return ERROR_VIEW;
		}
		if (productCategory.getParent() != null) {
			ProductCategory parent = productCategory.getParent();
			if (parent.equals(productCategory)) {
				return ERROR_VIEW;
			}
			List<ProductCategory> children = productCategoryService.findChildren(parent, true, null);
			if (children != null && children.contains(parent)) {
				return ERROR_VIEW;
			}
		}
		productCategoryService.update(productCategory, "stores", "categoryApplications", "treePath", "grade", "children", "product", "parameters", "attributes", "specifications");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/product_category/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long id) {
		ProductCategory productCategory = productCategoryService.find(id);
		if (productCategory == null) {
			return ERROR_MESSAGE;
		}
		Set<ProductCategory> children = productCategory.getChildren();
		if (children != null && !children.isEmpty()) {
			return Message.error("admin.productCategory.deleteExistChildrenNotAllowed");
		}
		Set<Product> products = productCategory.getProducts();
		if (products != null && !products.isEmpty()) {
			return Message.error("admin.productCategory.deleteExistProductNotAllowed");
		}
		productCategoryService.delete(id);
		return SUCCESS_MESSAGE;
	}

}