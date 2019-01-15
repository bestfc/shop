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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.entity.DeliveryCorp;
import net.shopxx.service.DeliveryCorpService;

/**
 * Controller物流公司
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminDeliveryCorpController")
@RequestMapping("/admin/delivery_corp")
public class DeliveryCorpController extends BaseController {

	@Inject
	private DeliveryCorpService deliveryCorpService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add() {
		return "admin/delivery_corp/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(DeliveryCorp deliveryCorp, RedirectAttributes redirectAttributes) {
		if (!isValid(deliveryCorp)) {
			return ERROR_VIEW;
		}
		deliveryCorp.setShippingMethods(null);
		deliveryCorpService.save(deliveryCorp);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("deliveryCorp", deliveryCorpService.find(id));
		return "admin/delivery_corp/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(DeliveryCorp deliveryCorp, RedirectAttributes redirectAttributes) {
		if (!isValid(deliveryCorp)) {
			return ERROR_VIEW;
		}
		deliveryCorpService.update(deliveryCorp, "shippingMethods");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", deliveryCorpService.findPage(pageable));
		return "admin/delivery_corp/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		deliveryCorpService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}