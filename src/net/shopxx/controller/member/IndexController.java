/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.member;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.controller.shop.BaseController;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.ConsultationService;
import net.shopxx.service.CouponCodeService;
import net.shopxx.service.MessageService;
import net.shopxx.service.OrderService;
import net.shopxx.service.ProductFavoriteService;
import net.shopxx.service.ProductNotifyService;
import net.shopxx.service.ReviewService;

/**
 * Controller首页
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("memberIndexController")
@RequestMapping("/member/index")
public class IndexController extends BaseController {

	/**
	 * 最新订单数量
	 */
	private static final int NEW_ORDER_SIZE = 3;

	@Inject
	private OrderService orderService;
	@Inject
	private CouponCodeService couponCodeService;
	@Inject
	private MessageService messageService;
	@Inject
	private ProductFavoriteService productFavoriteService;
	@Inject
	private ProductNotifyService productNotifyService;
	@Inject
	private ReviewService reviewService;
	@Inject
	private ConsultationService consultationService;

	/**
	 * 首页
	 */
	@GetMapping
	public String index(@CurrentUser Member currentUser, ModelMap model) {
		model.addAttribute("pendingPaymentOrderCount", orderService.count(null, Order.Status.pendingPayment, null, currentUser, null, null, null, null, null, null, false));
		model.addAttribute("pendingShipmentOrderCount", orderService.count(null, Order.Status.pendingShipment, null, currentUser, null, null, null, null, null, null, null));
		model.addAttribute("shippedOrderCount", orderService.count(null, Order.Status.shipped, null, currentUser, null, null, null, null, null, null, null));
		model.addAttribute("messageCount", messageService.count(currentUser, false));
		model.addAttribute("couponCodeCount", couponCodeService.count(null, currentUser, null, false, false));
		model.addAttribute("productFavoriteCount", productFavoriteService.count(currentUser));
		model.addAttribute("productNotifyCount", productNotifyService.count(currentUser, null, null, null));
		model.addAttribute("reviewCount", reviewService.count(currentUser, null, null, null));
		model.addAttribute("consultationCount", consultationService.count(currentUser, null, null));
		model.addAttribute("newOrders", orderService.findList(null, null, null, currentUser, null, null, null, null, null, null, null, NEW_ORDER_SIZE, null, null));
		return "member/index";
	}

}