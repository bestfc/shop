/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;
import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Order;
import net.shopxx.service.MemberService;
import net.shopxx.service.MessageService;
import net.shopxx.service.OrderService;
import net.shopxx.service.ProductService;

/**
 * Controller首页
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminIndexController")
@RequestMapping("/admin/index")
public class IndexController {

	@Value("${system.name}")
	private String systemName;
	@Value("${system.version}")
	private String systemVersion;
	@Value("${system.description}")
	private String systemDescription;

	@Inject
	private ServletContext servletContext;
	@Inject
	private OrderService orderService;
	@Inject
	private ProductService productService;
	@Inject
	private MemberService memberService;
	@Inject
	private MessageService messageService;

	/**
	 * 首页
	 */
	@GetMapping
	public String index(ModelMap model) {
		model.addAttribute("systemName", systemName);
		model.addAttribute("systemVersion", systemVersion);
		model.addAttribute("systemDescription", systemDescription);
		model.addAttribute("javaVersion", System.getProperty("java.version"));
		model.addAttribute("javaHome", System.getProperty("java.home"));
		model.addAttribute("osName", System.getProperty("os.name"));
		model.addAttribute("osArch", System.getProperty("os.arch"));
		model.addAttribute("serverInfo", servletContext.getServerInfo());
		model.addAttribute("servletVersion", servletContext.getMajorVersion() + "." + servletContext.getMinorVersion());
		model.addAttribute("pendingReviewOrderCount", orderService.count(null, Order.Status.pendingReview, null, null, null, null, null, null, null, null, null));
		model.addAttribute("pendingShipmentOrderCount", orderService.count(null, Order.Status.pendingShipment, null, null, null, null, null, null, null, null, null));
		model.addAttribute("pendingReceiveOrderCount", orderService.count(null, null, null, null, null, true, null, null, null, null, null));
		model.addAttribute("pendingRefundsOrderCount", orderService.count(null, null, null, null, null, null, true, null, null, null, null));
		model.addAttribute("marketableSkuCount", productService.count(null, null, true, null, null, null, null, null));
		model.addAttribute("notMarketableSkuCount", productService.count(null, null, false, null, null, null, null, null));
		model.addAttribute("outOfStockSkuCount", productService.count(null, null, null, null, null, null, true, null));
		model.addAttribute("stockAlertSkuCount", productService.count(null, null, null, null, null, null, null, true));
		model.addAttribute("memberCount", memberService.count());
		model.addAttribute("unreadMessageCount", messageService.count(null, false));
		return "admin/index";
	}

}