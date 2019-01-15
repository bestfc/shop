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
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.service.PluginService;

/**
 * Controller支付插件
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminPaymentPluginController")
@RequestMapping("/admin/payment_plugin")
public class PaymentPluginController extends BaseController {

	@Inject
	private PluginService pluginService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(ModelMap model) {
		model.addAttribute("paymentPlugins", pluginService.getPaymentPlugins());
		return "admin/payment_plugin/list";
	}

}