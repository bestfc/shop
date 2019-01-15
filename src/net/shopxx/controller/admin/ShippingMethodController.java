/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import java.util.HashSet;

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
import net.shopxx.entity.ShippingMethod;
import net.shopxx.service.DeliveryCorpService;
import net.shopxx.service.PaymentMethodService;
import net.shopxx.service.ShippingMethodService;

/**
 * Controller配送方式
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminShippingMethodController")
@RequestMapping("/admin/shipping_method")
public class ShippingMethodController extends BaseController {

	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private DeliveryCorpService deliveryCorpService;

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		return "admin/shipping_method/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public String save(ShippingMethod shippingMethod, Long defaultDeliveryCorpId, Long[] paymentMethodIds, RedirectAttributes redirectAttributes) {
		shippingMethod.setDefaultDeliveryCorp(deliveryCorpService.find(defaultDeliveryCorpId));
		shippingMethod.setPaymentMethods(new HashSet<>(paymentMethodService.findList(paymentMethodIds)));
		if (!isValid(shippingMethod)) {
			return ERROR_VIEW;
		}
		shippingMethod.setAreaFreightConfigs(null);
		shippingMethod.setOrders(null);
		shippingMethodService.save(shippingMethod);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethod", shippingMethodService.find(id));
		return "admin/shipping_method/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public String update(ShippingMethod shippingMethod, Long defaultDeliveryCorpId, Long[] paymentMethodIds, RedirectAttributes redirectAttributes) {
		shippingMethod.setDefaultDeliveryCorp(deliveryCorpService.find(defaultDeliveryCorpId));
		shippingMethod.setPaymentMethods(new HashSet<>(paymentMethodService.findList(paymentMethodIds)));
		if (!isValid(shippingMethod)) {
			return ERROR_VIEW;
		}
		shippingMethodService.update(shippingMethod, "areaFreightConfigs", "orders");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", shippingMethodService.findPage(pageable));
		return "admin/shipping_method/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		if (ids.length >= shippingMethodService.count()) {
			return Message.error("admin.common.deleteAllNotAllowed");
		}
		shippingMethodService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}