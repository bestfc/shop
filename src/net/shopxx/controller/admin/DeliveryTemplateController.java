/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Pageable;
import net.shopxx.service.DeliveryTemplateService;

/**
 * Controller快递单模板
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminDeliveryTemplateController")
@RequestMapping("/admin/delivery_template")
public class DeliveryTemplateController extends BaseController {

	@Inject
	private DeliveryTemplateService deliveryTemplateService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, Model model) {
		model.addAttribute("page", deliveryTemplateService.findPage(pageable));
		return "admin/delivery_template/list";
	}

}