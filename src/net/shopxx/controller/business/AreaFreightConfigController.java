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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Area;
import net.shopxx.entity.AreaFreightConfig;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.AreaFreightConfigService;
import net.shopxx.service.AreaService;
import net.shopxx.service.ShippingMethodService;

/**
 * Controller地区运费配置
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessAreaFreightConfigController")
@RequestMapping("/business/area_freight_config")
public class AreaFreightConfigController extends BaseController {

	@Inject
	private AreaFreightConfigService areaFreightConfigService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private AreaService areaService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long shippingMethodId, Long areaId, Long areaFreightConfigId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("area", areaService.find(areaId));
		model.addAttribute("shippingMethod", shippingMethodService.find(shippingMethodId));

		AreaFreightConfig areaFreightConfig = areaFreightConfigService.find(areaFreightConfigId);
		if (areaFreightConfig != null && !currentStore.equals(areaFreightConfig.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("areaFreightConfig", areaFreightConfig);
	}

	/**
	 * 检查地区是否唯一
	 */
	@GetMapping("/check_area")
	public @ResponseBody boolean checkArea(Long id, @ModelAttribute(binding = false) ShippingMethod shippingMethod, @ModelAttribute(binding = false) Area area, @CurrentStore Store currentStore) {
		if (shippingMethod == null || area == null) {
			return false;
		}

		return areaFreightConfigService.unique(id, shippingMethod, currentStore, area);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(@ModelAttribute(binding = false) ShippingMethod shippingMethod, ModelMap model) {
		model.addAttribute("shippingMethod", shippingMethod);
		return "business/area_freight_config/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("areaFreightConfigForm") AreaFreightConfig areaFreightConfigForm, @ModelAttribute(binding = false) ShippingMethod shippingMethod, @ModelAttribute(binding = false) Area area, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		areaFreightConfigForm.setArea(area);
		areaFreightConfigForm.setShippingMethod(shippingMethod);
		areaFreightConfigForm.setStore(currentStore);
		if (!isValid(areaFreightConfigForm, BaseEntity.Save.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (areaFreightConfigService.exists(shippingMethod, currentStore, area)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		areaFreightConfigService.save(areaFreightConfigForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list?shippingMethodId=" + shippingMethod.getId();
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) AreaFreightConfig areaFreightConfig, ModelMap model) {
		if (areaFreightConfig == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("areaFreightConfig", areaFreightConfig);
		return "business/area_freight_config/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("areaFreightConfigForm") AreaFreightConfig areaFreightConfigForm, @ModelAttribute(binding = false) AreaFreightConfig areaFreightConfig, @ModelAttribute(binding = false) Area area, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (areaFreightConfig == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		areaFreightConfigForm.setArea(area);
		if (!isValid(areaFreightConfigForm, BaseEntity.Update.class)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!areaFreightConfigService.unique(areaFreightConfig.getId(), areaFreightConfig.getShippingMethod(), currentStore, area)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(areaFreightConfigForm, areaFreightConfig, "id", "store", "shippingMethod");
		areaFreightConfigService.update(areaFreightConfig);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list?shippingMethodId=" + areaFreightConfig.getShippingMethod().getId();
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @ModelAttribute(binding = false) ShippingMethod shippingMethod, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("shippingMethod", shippingMethod);
		model.addAttribute("page", areaFreightConfigService.findPage(shippingMethod, currentStore, pageable));
		return "business/area_freight_config/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (AreaFreightConfig areaFreightConfig : areaFreightConfigService.findList(ids)) {
			if (!currentStore.equals(areaFreightConfig.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		areaFreightConfigService.delete(ids);
		return Results.OK;
	}

}