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
import net.shopxx.entity.PaymentMethod;
import net.shopxx.service.PaymentMethodService;

/**
 * Controller支付方式
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminPaymentMethodController")
@RequestMapping("/admin/payment_method")
public class PaymentMethodController extends BaseController {

	@Inject
	private PaymentMethodService paymentMethodService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("types", PaymentMethod.Type.values());
		model.addAttribute("methods", PaymentMethod.Method.values());
		return "admin/payment_method/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(PaymentMethod paymentMethod, RedirectAttributes redirectAttributes) {
		if (!isValid(paymentMethod)) {
			return ERROR_VIEW;
		}
		paymentMethod.setShippingMethods(null);
		paymentMethod.setOrders(null);
		paymentMethodService.save(paymentMethod);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("types", PaymentMethod.Type.values());
		model.addAttribute("methods", PaymentMethod.Method.values());
		model.addAttribute("paymentMethod", paymentMethodService.find(id));
		return "admin/payment_method/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(PaymentMethod paymentMethod, RedirectAttributes redirectAttributes) {
		if (!isValid(paymentMethod)) {
			return ERROR_VIEW;
		}
		paymentMethodService.update(paymentMethod, "shippingMethods", "orders");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", paymentMethodService.findPage(pageable));
		return "admin/payment_method/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids.length >= paymentMethodService.count()) {
			return Message.error("admin.common.deleteAllNotAllowed");
		}
		paymentMethodService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}