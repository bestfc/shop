/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import javax.inject.Inject;

import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreProductTag;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.StoreProductTagService;

/**
 * Controller店铺商品标签
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessStoreProductTagController")
@RequestMapping("/business/store_product_tag")
public class StoreProductTagController extends BaseController {

	@Inject
	private StoreProductTagService storeProductTagService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long storeProductTagId, @CurrentStore Store currentStore, ModelMap model) {
		StoreProductTag storeProductTag = storeProductTagService.find(storeProductTagId);
		if (storeProductTag != null && !currentStore.equals(storeProductTag.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("storeProductTag", storeProductTag);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		return "business/store_product_tag/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("storeProductTagForm") StoreProductTag storeProductTagForm, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(storeProductTagForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeProductTagForm.setStore(currentStore);
		storeProductTagForm.setProducts(null);
		storeProductTagService.save(storeProductTagForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) StoreProductTag storeProductTag, ModelMap model) {
		if (storeProductTag == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("storeProductTag", storeProductTag);
		return "business/store_product_tag/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("storeProductTagForm") StoreProductTag storeProductTagForm, @ModelAttribute(binding = false) StoreProductTag storeProductTag, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(storeProductTagForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (storeProductTag == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(storeProductTagForm, storeProductTag, "id", "store", "product");
		storeProductTagService.update(storeProductTag);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", storeProductTagService.findPage(currentStore, pageable));
		return "business/store_product_tag/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			StoreProductTag storeProductTag = storeProductTagService.find(id);
			if (storeProductTag == null || !currentStore.equals(storeProductTag.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			storeProductTagService.delete(id);
		}
		return Results.OK;
	}

}