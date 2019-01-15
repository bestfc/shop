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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.DeliveryTemplate;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.DeliveryTemplateService;

/**
 * Controller快递单模板
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessDeliveryTemplateController")
@RequestMapping("/business/delivery_template")
public class DeliveryTemplateController extends BaseController {

	@Inject
	private DeliveryTemplateService deliveryTemplateService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long deliveryTemplateId, @CurrentStore Store currentStore, ModelMap model) {
		DeliveryTemplate deliveryTemplate = deliveryTemplateService.find(deliveryTemplateId);
		if (deliveryTemplate != null && !currentStore.equals(deliveryTemplate.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("deliveryTemplate", deliveryTemplate);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(Model model, RedirectAttributes redirectAttributes) {
		model.addAttribute("storeAttributes", DeliveryTemplate.StoreAttribute.values());
		model.addAttribute("deliveryCenterAttributes", DeliveryTemplate.DeliveryCenterAttribute.values());
		model.addAttribute("orderAttributes", DeliveryTemplate.OrderAttribute.values());
		return "business/delivery_template/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("deliveryTemplateFrom") DeliveryTemplate deliveryTemplateFrom, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (!isValid(deliveryTemplateFrom)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		deliveryTemplateFrom.setStore(currentStore);
		deliveryTemplateService.save(deliveryTemplateFrom);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String eidt(@ModelAttribute(binding = false) DeliveryTemplate deliveryTemplate, Model model) {
		if (deliveryTemplate == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("storeAttributes", DeliveryTemplate.StoreAttribute.values());
		model.addAttribute("deliveryCenterAttributes", DeliveryTemplate.DeliveryCenterAttribute.values());
		model.addAttribute("orderAttributes", DeliveryTemplate.OrderAttribute.values());
		model.addAttribute("deliveryTemplate", deliveryTemplate);
		return "business/delivery_template/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String udpate(@ModelAttribute("deliveryTemplateFrom") DeliveryTemplate deliveryTemplateFrom, @ModelAttribute(binding = false) DeliveryTemplate deliveryTemplate, RedirectAttributes redirectAttributes) {
		if (!isValid(deliveryTemplateFrom)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (deliveryTemplate == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(deliveryTemplateFrom, deliveryTemplate, "id", "store");
		deliveryTemplateService.update(deliveryTemplate);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, Model model) {
		model.addAttribute("page", deliveryTemplateService.findPage(currentStore, pageable));
		return "business/delivery_template/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			DeliveryTemplate deliveryTemplate = deliveryTemplateService.find(id);
			if (deliveryTemplate == null || !currentStore.equals(deliveryTemplate.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		deliveryTemplateService.delete(ids);
		return Results.OK;
	}
}