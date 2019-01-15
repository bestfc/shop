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
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreAdImage;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.StoreAdImageService;

/**
 * Controller店铺广告图片
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessStoreAdImageController")
@RequestMapping("/business/store_ad_image")
public class StoreAdImageController extends BaseController {

	@Inject
	private StoreAdImageService storeAdImageService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long storeAdImageId, @CurrentStore Store currentStore, ModelMap model) {
		StoreAdImage storeAdImage = storeAdImageService.find(storeAdImageId);
		if (storeAdImage != null && !currentStore.equals(storeAdImage.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("storeAdImage", storeAdImage);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(@CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (StoreAdImage.MAX_COUNT != null && currentStore.getStoreAdImages().size() >= StoreAdImage.MAX_COUNT) {
			addFlashMessage(redirectAttributes, "business.storeAdImage.addCountNotAllowed", StoreAdImage.MAX_COUNT);
			return "redirect:list";
		}
		return "business/store_ad_image/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("storeAdImageForm") StoreAdImage storeAdImageForm, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (storeAdImageForm == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (StoreAdImage.MAX_COUNT != null && currentStore.getStoreAdImages().size() >= StoreAdImage.MAX_COUNT) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeAdImageForm.setStore(currentStore);
		if (!isValid(storeAdImageForm, BaseEntity.Save.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		storeAdImageService.save(storeAdImageForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) StoreAdImage storeAdImage, ModelMap model) {
		if (storeAdImage == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("storeAdImage", storeAdImage);
		return "business/store_ad_image/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("storeAdImageForm") StoreAdImage storeAdImageForm, @ModelAttribute(binding = false) StoreAdImage storeAdImage, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(storeAdImageForm, BaseEntity.Update.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (storeAdImage == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(storeAdImageForm, storeAdImage, "id", "store");
		storeAdImageService.update(storeAdImage);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", storeAdImageService.findPage(currentStore, pageable));
		return "business/store_ad_image/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (StoreAdImage storeAdImage : storeAdImageService.findList(ids)) {
			if (!currentStore.equals(storeAdImage.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		storeAdImageService.delete(ids);
		return Results.OK;
	}
}