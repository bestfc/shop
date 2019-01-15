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
import net.shopxx.entity.Area;
import net.shopxx.entity.DeliveryCenter;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.AreaService;
import net.shopxx.service.DeliveryCenterService;

/**
 * Controller发货点
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessDeliveryCenterController")
@RequestMapping("/business/delivery_center")
public class DeliveryCenterController extends BaseController {

	@Inject
	private DeliveryCenterService deliveryCenterService;
	@Inject
	private AreaService areaService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long areaId, Long deliveryCenterId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("area", areaService.find(areaId));

		DeliveryCenter deliveryCenter = deliveryCenterService.find(deliveryCenterId);
		if (deliveryCenter != null && !currentStore.equals(deliveryCenter.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("deliveryCenter", deliveryCenter);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add() {
		return "business/delivery_center/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(@ModelAttribute("deliveryCenterForm") DeliveryCenter deliveryCenterForm, @ModelAttribute(binding = false) Area area, @CurrentStore Store currentStore, RedirectAttributes redirectAttributes) {
		if (area == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		deliveryCenterForm.setArea(area);
		if (!isValid(deliveryCenterForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		deliveryCenterForm.setAreaName(null);
		deliveryCenterForm.setStore(currentStore);
		deliveryCenterService.save(deliveryCenterForm);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) DeliveryCenter deliveryCenter, Model model) {
		if (deliveryCenter == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("deliveryCenter", deliveryCenter);
		return "business/delivery_center/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(@ModelAttribute("deliveryCenterForm") DeliveryCenter deliveryCenterForm, @ModelAttribute(binding = false) Area area, @ModelAttribute(binding = false) DeliveryCenter deliveryCenter, RedirectAttributes redirectAttributes) {
		deliveryCenterForm.setArea(area);
		if (!isValid(deliveryCenterForm)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (deliveryCenter == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		BeanUtils.copyProperties(deliveryCenterForm, deliveryCenter, "id", "store", "areaName");
		deliveryCenterService.update(deliveryCenter);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Model model, @CurrentStore Store currentStore, Pageable pageable) {
		model.addAttribute("page", deliveryCenterService.findPage(currentStore, pageable));
		return "business/delivery_center/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			DeliveryCenter deliveryCenter = deliveryCenterService.find(id);
			if (deliveryCenter == null || !currentStore.equals(deliveryCenter.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		deliveryCenterService.delete(ids);
		return Results.OK;
	}

}