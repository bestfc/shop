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

import net.shopxx.Message;
import net.shopxx.Pageable;
import net.shopxx.service.OrderRefundsService;

/**
 * Controller订单退款
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminOrderRefundsController")
@RequestMapping("/admin/refunds")
public class OrderRefundsController extends BaseController {

	@Inject
	private OrderRefundsService orderRefundsService;

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(Long id, ModelMap model) {
		model.addAttribute("refunds", orderRefundsService.find(id));
		return "admin/order_refunds/view";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", orderRefundsService.findPage(pageable));
		return "admin/order_refunds/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		orderRefundsService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}