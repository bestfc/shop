/*
 * Copyright 2005-2017 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Pageable;
import net.shopxx.entity.Business;
import net.shopxx.entity.Cash;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.CashService;

/**
 * Controller提现
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("businessCashController")
@RequestMapping("/business/cash")
public class CashController extends BaseController {

	@Inject
	private CashService cashService;

	/**
	 * 检查余额
	 */
	@GetMapping("/check_balance")
	public @ResponseBody boolean checkBalance(BigDecimal amount, @CurrentUser Business currentUser) {
		if (amount.compareTo(BigDecimal.ZERO) <= 0) {
			return false;
		}
		return currentUser.getBalance().compareTo(amount) >= 0;
	}

	/**
	 * 申请提现
	 */
	@GetMapping("/application")
	public String cash() {
		return "business/cash/application";
	}

	/**
	 * 申请提现
	 */
	@PostMapping("/save")
	public String applyCash(Cash cash, @CurrentUser Business currentUser, RedirectAttributes redirectAttributes) {
		if (!isValid(cash)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (currentUser.getBalance().compareTo(cash.getAmount()) < 0) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		cashService.applyCash(cash, currentUser);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentUser Business currentUser, ModelMap model) {
		model.addAttribute("page", cashService.findPage(currentUser, pageable));
		return "business/cash/list";
	}

}