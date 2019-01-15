/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.entity.CategoryApplication;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.CategoryApplicationService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.StoreService;

/**
 * Controller经营分类申请
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessCategoryApplicationController")
@RequestMapping("/business/category_application")
public class CategoryApplicationController extends BaseController {

	@Inject
	private CategoryApplicationService categoryApplicationService;
	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private StoreService storeService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(@CurrentStore Store currentStore, ModelMap model) {
		if (currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<ProductCategory> productCategories = storeService.findProductCategoryList(currentStore, CategoryApplication.Status.pending);
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("appliedProductCategories", productCategories);
		return "business/category_application/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(Long productCategoryId, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		ProductCategory productCategory = productCategoryService.find(productCategoryId);
		if (productCategory == null || currentStore == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (storeService.productCategoryExists(currentStore, productCategory) || categoryApplicationService.exist(currentStore, productCategory, CategoryApplication.Status.pending)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		CategoryApplication categoryApplication = new CategoryApplication();
		categoryApplication.setStatus(CategoryApplication.Status.pending);
		categoryApplication.setRate(Store.Type.general.equals(currentStore.getType()) ? productCategory.getGeneralRate() : productCategory.getSelfRate());
		categoryApplication.setStore(currentStore);
		categoryApplication.setProductCategory(productCategory);
		categoryApplicationService.save(categoryApplication);

		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", categoryApplicationService.findPage(currentStore, pageable));
		return "business/category_application/list";
	}

}