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

import net.shopxx.Pageable;
import net.shopxx.service.StockLogService;

/**
 * Controller库存
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminStockController")
@RequestMapping("/admin/stock")
public class StockController extends BaseController {

	@Inject
	private StockLogService stockLogService;

	/**
	 * 记录
	 */
	@GetMapping("/log")
	public String log(Pageable pageable, ModelMap model) {
		model.addAttribute("page", stockLogService.findPage(pageable));
		return "admin/stock/log";
	}

}