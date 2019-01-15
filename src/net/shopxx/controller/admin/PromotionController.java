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
import net.shopxx.service.PromotionService;

/**
 * Controller促销
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("adminPromotionController")
@RequestMapping("/admin/promotion")
public class PromotionController extends BaseController {

	@Inject
	private PromotionService promotionService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", promotionService.findPage(pageable));
		return "admin/promotion/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public @ResponseBody Message delete(Long[] ids) {
		promotionService.delete(ids);
		return SUCCESS_MESSAGE;
	}

}