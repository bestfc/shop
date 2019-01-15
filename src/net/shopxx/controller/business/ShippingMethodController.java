/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.entity.DefaultFreightConfig;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.DefaultFreightConfigService;
import net.shopxx.service.ShippingMethodService;

/**
 * Controller配送方式
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessShippingMethodController")
@RequestMapping("/business/shipping_method")
public class ShippingMethodController extends BaseController {

	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private DefaultFreightConfigService defaultFreightConfigService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long shippingMethodId, Long defaultFreightConfigId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("shippingMethod", shippingMethodService.find(shippingMethodId));

		DefaultFreightConfig defaultFreightConfig = defaultFreightConfigService.find(defaultFreightConfigId);
		if (defaultFreightConfig != null && !currentStore.equals(defaultFreightConfig.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("defaultFreightConfig", defaultFreightConfig);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", shippingMethodService.findPage(pageable));
		return "business/shipping_method/list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) ShippingMethod shippingMethod, @CurrentStore Store currentStore, ModelMap model) {
		if (shippingMethod == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		DefaultFreightConfig defaultFreightConfig = defaultFreightConfigService.find(shippingMethod, currentStore);
		if (null != defaultFreightConfig) {
			model.addAttribute("defaultFreightConfig", defaultFreightConfig);
		} else {
			model.addAttribute("defaultFreightConfig", null);
		}
		model.addAttribute("shippingMethod", shippingMethod);
		return "business/shipping_method/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("defaultFreightConfigForm") DefaultFreightConfig defaultFreightConfigForm, @ModelAttribute(binding = false) ShippingMethod shippingMethod, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (shippingMethod == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		defaultFreightConfigService.update(defaultFreightConfigForm, currentStore, shippingMethod);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

}